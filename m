Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42210 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaL3NK6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 08:10:58 -0500
Date: Tue, 30 Dec 2014 11:10:51 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH] dvb-core: add template code for i2c binding model
Message-ID: <20141230111051.7aeff58a@concha.lan>
In-Reply-To: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 05 Dec 2014 19:49:33 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> Define a standard interface for demod/tuner i2c driver modules.
> A module client calls dvb_i2c_attach_{fe,tuner}(),
> and a module driver defines struct dvb_i2c_module_param and
> calls DEFINE_DVB_I2C_MODULE() macro.
> 
> This template provides implicit module requests and ref-counting,
> alloc/free's private data structures,
> fixes the usage of clientdata of i2c devices,
> and defines the platformdata structures for passing around
> device specific config/output parameters between drivers and clients.
> These kinds of code are common to (almost) all dvb i2c drivers/client,
> but they were scattered over adapter modules and demod/tuner modules.

The idea behind this patch is good. I didn't have time yet to test it on a
device that I have currently access.

I have a few comments below, mostly regards with naming convention.

By seeing the patches you converted a few drivers to use this, I'm a little
bit concern about the conversion. We need something that won't be hard to
convert to the new model without requiring to re-test everything.

Anyway, my plan is to take a deeper look on it next week and convert one
or two drivers to use the new I2C binding approach you're proposing.
> 
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>  drivers/media/dvb-core/Makefile       |   4 +
>  drivers/media/dvb-core/dvb_frontend.h |   1 +
>  drivers/media/dvb-core/dvb_i2c.c      | 219 ++++++++++++++++++++++++++++++++++
>  drivers/media/dvb-core/dvb_i2c.h      | 110 +++++++++++++++++
>  4 files changed, 334 insertions(+)
>  create mode 100644 drivers/media/dvb-core/dvb_i2c.c
>  create mode 100644 drivers/media/dvb-core/dvb_i2c.h
> 
> diff --git a/drivers/media/dvb-core/Makefile b/drivers/media/dvb-core/Makefile
> index 8f22bcd..271648d 100644
> --- a/drivers/media/dvb-core/Makefile
> +++ b/drivers/media/dvb-core/Makefile
> @@ -8,4 +8,8 @@ dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o 	\
>  		 dvb_ca_en50221.o dvb_frontend.o 		\
>  		 $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
>  
> +ifneq ($(CONFIG_I2C)$(CONFIG_I2C_MODULE),)
> +dvb-core-objs += dvb_i2c.o
> +endif
> +
>  obj-$(CONFIG_DVB_CORE) += dvb-core.o
> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
> index 816269e..41aae1b 100644
> --- a/drivers/media/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb-core/dvb_frontend.h
> @@ -415,6 +415,7 @@ struct dtv_frontend_properties {
>  struct dvb_frontend {
>  	struct dvb_frontend_ops ops;
>  	struct dvb_adapter *dvb;
> +	struct i2c_client *fe_cl;

fe_cl doesn't seem to be a good name for something that should be
accessed by all drivers that use it. fe_i2c_client is likely a
better name for it.

>  	void *demodulator_priv;
>  	void *tuner_priv;
>  	void *frontend_priv;
> diff --git a/drivers/media/dvb-core/dvb_i2c.c b/drivers/media/dvb-core/dvb_i2c.c
> new file mode 100644
> index 0000000..4ea4e5e
> --- /dev/null
> +++ b/drivers/media/dvb-core/dvb_i2c.c
> @@ -0,0 +1,219 @@
> +/*
> + * dvb_i2c.c
> + *
> + * Copyright 2014 Akihiro Tsukada <tskd08 AT gmail DOT com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +#include "dvb_i2c.h"
> +
> +static struct i2c_client *
> +dvb_i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info *info,
> +		   const unsigned short *probe_addrs)
> +{
> +	struct i2c_client *cl;
> +
> +	request_module(I2C_MODULE_PREFIX "%s", info->type);
> +	/* Create the i2c client */
> +	if (info->addr == 0 && probe_addrs)
> +		cl = i2c_new_probed_device(adap, info, probe_addrs, NULL);
> +	else
> +		cl = i2c_new_device(adap, info);
> +	if (!cl || !cl->dev.driver)
> +		return NULL;
> +	return cl;

The best would be to also register the device with the media controller,
if CONFIG_MEDIA_CONTROLLER is defined, just like v4l2_i2c_subdev_init()
does.

I would also try to use similar names for the function calls to the ones
that the v4l subsystem uses for subdevices.

> +}
> +
> +struct dvb_frontend *
> +dvb_i2c_attach_fe(struct i2c_adapter *adap, const struct i2c_board_info *info,
> +		  const void *cfg, void **out)
> +{
> +	struct i2c_client *cl;
> +	struct i2c_board_info bi;

Better to call this as "tmp_info", as this seems to be just a temp var.

> +	struct dvb_i2c_dev_config dcfg;

I would, instead, call this as "cfg", and rename the parameter as
cfg_template.

> +
> +	dcfg.priv_cfg = cfg;
> +	dcfg.out = out;
> +	bi = *info;
> +	bi.platform_data = &dcfg;
> +
> +	cl = dvb_i2c_new_device(adap, &bi, NULL);
> +	if (!cl)
> +		return NULL;
> +	return i2c_get_clientdata(cl);
> +}
> +EXPORT_SYMBOL(dvb_i2c_attach_fe);
> +
> +struct i2c_client *
> +dvb_i2c_attach_tuner(struct i2c_adapter *adap,
> +		     const struct i2c_board_info *info,
> +		     struct dvb_frontend *fe,
> +		     const void *cfg, void **out)
> +{
> +	struct i2c_board_info bi;
> +	struct dvb_i2c_tuner_config tcfg;

Same as above with regards to name: please rename:
	- bi -> tmp_info
	- tcfg -> cfg

> +
> +	tcfg.fe = fe;
> +	tcfg.devcfg.priv_cfg = cfg;
> +	tcfg.devcfg.out = out;
> +	bi = *info;
> +	bi.platform_data = &tcfg;
> +
> +	return dvb_i2c_new_device(adap, &bi, NULL);
> +}
> +EXPORT_SYMBOL(dvb_i2c_attach_tuner);
> +
> +
> +static int
> +probe_tuner(struct i2c_client *client, const struct i2c_device_id *id,
> +	    const struct dvb_i2c_module_param *param,
> +	    struct module *this_module)
> +{
> +	struct dvb_frontend *fe;
> +	struct dvb_i2c_tuner_config *tcfg;

Same here with regards to naming convention.

> +	int ret;
> +
> +	if (!try_module_get(this_module))
> +		return -ENODEV;
> +
> +	tcfg = client->dev.platform_data;
> +	fe = tcfg->fe;
> +	i2c_set_clientdata(client, fe);
> +
> +	if (param->priv_size > 0) {
> +		fe->tuner_priv = kzalloc(param->priv_size, GFP_KERNEL);
> +		if (!fe->tuner_priv) {
> +			ret = -ENOMEM;
> +			goto err_mem;
> +		}
> +	}
> +
> +	if (param->ops.tuner_ops)
> +		memcpy(&fe->ops.tuner_ops, param->ops.tuner_ops,
> +			sizeof(fe->ops.tuner_ops));
> +
> +	ret = 0;
> +	if (param->priv_probe)
> +		ret = param->priv_probe(client, id);
> +	if (ret != 0) {
> +		dev_info(&client->dev, "driver private probe failed.\n");
> +		goto err_priv;
> +	}
> +	return 0;
> +
> +err_priv:
> +	kfree(fe->tuner_priv);
> +err_mem:
> +	fe->tuner_priv = NULL;
> +	module_put(this_module);
> +	return ret;
> +}
> +
> +static int remove_tuner(struct i2c_client *client,
> +			const struct dvb_i2c_module_param *param,
> +			struct module *this_module)
> +{
> +	struct dvb_frontend *fe;
> +
> +	if (param->priv_remove)
> +		param->priv_remove(client);
> +	fe = i2c_get_clientdata(client);
> +	kfree(fe->tuner_priv);
> +	fe->tuner_priv = NULL;
> +	module_put(this_module);
> +	return 0;
> +}
> +
> +
> +static int probe_fe(struct i2c_client *client, const struct i2c_device_id *id,
> +		    const struct dvb_i2c_module_param *param,
> +		    struct module *this_module)
> +{
> +	struct dvb_frontend *fe;
> +	int ret;
> +
> +	if (!try_module_get(this_module))
> +		return -ENODEV;
> +
> +	fe = kzalloc(sizeof(*fe), GFP_KERNEL);
> +	if (!fe) {
> +		ret = -ENOMEM;
> +		goto err_fe_kfree;
> +	}
> +	i2c_set_clientdata(client, fe);
> +	fe->fe_cl = client;
> +
> +	if (param->priv_size > 0) {
> +		fe->demodulator_priv = kzalloc(param->priv_size, GFP_KERNEL);
> +		if (!fe->demodulator_priv) {
> +			ret = -ENOMEM;
> +			goto err_fe_kfree;
> +		}
> +	}
> +
> +	if (param->ops.fe_ops)
> +		memcpy(&fe->ops, param->ops.fe_ops, sizeof(fe->ops));
> +
> +	ret = 0;
> +	if (param->priv_probe)
> +		ret = param->priv_probe(client, id);
> +	if (ret != 0) {
> +		dev_info(&client->dev, "driver private probe failed.\n");
> +		goto err_priv_kfree;
> +	}
> +	return 0;
> +
> +err_priv_kfree:
> +	kfree(fe->demodulator_priv);
> +err_fe_kfree:
> +	kfree(fe);
> +	module_put(this_module);
> +	return ret;
> +}
> +
> +static int remove_fe(struct i2c_client *client,
> +		     const struct dvb_i2c_module_param *param,
> +		     struct module *this_module)
> +{
> +	struct dvb_frontend *fe;
> +
> +	if (param->priv_remove)
> +		param->priv_remove(client);
> +	fe = i2c_get_clientdata(client);
> +	kfree(fe->demodulator_priv);
> +	kfree(fe);
> +	module_put(this_module);
> +	return 0;
> +}
> +
> +
> +int dvb_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id,
> +		  const struct dvb_i2c_module_param *param,
> +		  struct module *this_module)
> +{
> +	return param->is_tuner ? probe_tuner(client, id, param, this_module) :
> +				 probe_fe(client, id, param, this_module);
> +}
> +EXPORT_SYMBOL(dvb_i2c_probe);
> +
> +int dvb_i2c_remove(struct i2c_client *client,
> +		   const struct dvb_i2c_module_param *param,
> +		   struct module *this_module)
> +{
> +	return param->is_tuner ? remove_tuner(client, param, this_module) :
> +				 remove_fe(client, param, this_module);
> +}
> +EXPORT_SYMBOL(dvb_i2c_remove);
> diff --git a/drivers/media/dvb-core/dvb_i2c.h b/drivers/media/dvb-core/dvb_i2c.h
> new file mode 100644
> index 0000000..2bf409d
> --- /dev/null
> +++ b/drivers/media/dvb-core/dvb_i2c.h
> @@ -0,0 +1,110 @@
> +/*
> + * dvb_i2c.h
> + *
> + * Copyright 2014 Akihiro Tsukada <tskd08 AT gmail DOT com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +/* template code for i2c driver modules */
> +
> +#ifndef _DVB_I2C_H_
> +#define _DVB_I2C_H_
> +
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +#include "dvb_frontend.h"
> +
> +/* interface for module clients */
> +
> +struct dvb_frontend *dvb_i2c_attach_fe(struct i2c_adapter *adap,
> +				       const struct i2c_board_info *info,
> +				       const void *cfg, void **out);
> +
> +struct i2c_client *dvb_i2c_attach_tuner(struct i2c_adapter *adap,
> +					const struct i2c_board_info *info,
> +					struct dvb_frontend *fe,
> +					const void *cfg, void **out);
> +
> +/* interface for module drivers */
> +
> +/* data structures that are set to i2c_client.dev.platform_data */
> +
> +struct dvb_i2c_dev_config {
> +	const void *priv_cfg;
> +	/* @out [OUT] pointer to per-device data returned from driver */
> +	void **out;
> +};
> +
> +struct dvb_i2c_tuner_config {
> +	struct dvb_frontend *fe;
> +	struct dvb_i2c_dev_config devcfg;
> +};
> +
> +typedef int (*dvb_i2c_probe_func)(struct i2c_client *client,
> +				  const struct i2c_device_id *id);
> +typedef int (*dvb_i2c_remove_func)(struct i2c_client *client);
> +
> +struct dvb_i2c_module_param {
> +	union {
> +		const struct dvb_frontend_ops *fe_ops;
> +		const struct dvb_tuner_ops *tuner_ops;
> +	} ops;
> +	/* driver private probe/remove functions */
> +	dvb_i2c_probe_func  priv_probe;
> +	dvb_i2c_remove_func priv_remove;
> +
> +	u32 priv_size; /* sizeof(device private data) */
> +	bool is_tuner;
> +};
> +
> +
> +int dvb_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id,
> +		  const struct dvb_i2c_module_param *param,
> +		  struct module *this_module);
> +
> +int dvb_i2c_remove(struct i2c_client *client,
> +		   const struct dvb_i2c_module_param *param,
> +		   struct module *this_module);
> +
> +
> +#define DEFINE_DVB_I2C_MODULE(dname, idtab, param) \
> +static int _##dname##_probe(struct i2c_client *client,\
> +				const struct i2c_device_id *id)\
> +{\
> +	return dvb_i2c_probe(client, id, &(param), THIS_MODULE);\
> +} \
> +\
> +static int _##dname##_remove(struct i2c_client *client)\
> +{\
> +	return dvb_i2c_remove(client, &(param), THIS_MODULE);\
> +} \
> +\
> +MODULE_DEVICE_TABLE(i2c, idtab);\
> +\
> +static struct i2c_driver dname##_driver = {\
> +	.driver = {\
> +		.name = #dname,\
> +	},\
> +	.probe    = _##dname##_probe,\
> +	.remove   = _##dname##_remove,\
> +	.id_table = idtab,\
> +};\
> +\
> +module_i2c_driver(dname##_driver)
> +
> +#endif /* _DVB_I2C_H */


-- 

Cheers,
Mauro
