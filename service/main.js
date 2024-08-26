import Express from "express";

const service = Express();

service.use(Express.static('public'));

service.listen(8080, () => {
	console.log('service listening');
});
