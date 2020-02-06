const fastify = require('fastify')({ logger: true });

fastify.get('/customer/:id', async (request, reply) => {
    let services = [{
        "name": "Air conditioning",
    }, {
        "name": "Solar panel",
    }, {
        "name": "SMS consumption alerts",
    }];
    return {
        "customer_id": request.params.id,
        services,
    }
});

fastify.get('/error/:code', async (request, reply) => {
    let message;

    switch (request.params.code) {
        case "403":
            message = "You don't have access to requested resource";
            reply.code(403);
            break;
        case "404":
            message = "Requested resource not exists";
            reply.code(404);
            break
        default:
            message = "Internal error, try again later";
            reply.code(500);
            break
    }

    return reply.send({
        message
    });
});

fastify.post('/auth', async (request, reply) => {
    console.log('Raw request: ', request.raw)
    const body = request.body;
    if (body.user == "admin" && body.password == "admin") {
        reply.code(200).send();
    } else {
        reply.code(403).send();
    }
});

const start = async () => {
    try {
        await fastify.listen(3000, '0.0.0.0')
        fastify.log.info(`Server listening on ${fastify.server.address().port}`)
    } catch (err) {
        fastify.log.error(err);
        process.exit(1);
    }
}
start();