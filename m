Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60641 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab2HFMa3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 08:30:29 -0400
Message-ID: <501FB8D9.6060905@iki.fi>
Date: Mon, 06 Aug 2012 15:30:17 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] [media] dvb: get rid of fe_ioctl_override callback
References: <1344190590-10863-1-git-send-email-mchehab@redhat.com> <1344190590-10863-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344190590-10863-3-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2012 09:16 PM, Mauro Carvalho Chehab wrote:
> This callback were meant to allow overriding a FE callback, before its
> call, but it is not really needed, as the callback can be intercepted
> after tuner attachment.
>
> Worse than that, only DVBv3 calls are intercepted this way, so a DVBv5
> application will produce different effects than a DVBv3 one.
>
> So, get rid of it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>   drivers/media/dvb/dvb-core/dvb_frontend.c   | 13 +------------
>   drivers/media/dvb/dvb-core/dvbdev.h         | 21 --------------------
>   drivers/media/dvb/dvb-usb-v2/dvb_usb.h      |  3 ---
>   drivers/media/dvb/dvb-usb-v2/dvb_usb_core.c |  2 --
>   drivers/media/dvb/dvb-usb-v2/mxl111sf.c     | 30 +----------------------------
>   drivers/media/dvb/dvb-usb/dvb-usb-dvb.c     |  1 -
>   drivers/media/dvb/dvb-usb/dvb-usb.h         |  2 --
>   drivers/media/video/cx23885/cx23885-dvb.c   |  3 +--
>   drivers/media/video/cx88/cx88-dvb.c         |  2 +-
>   drivers/media/video/saa7134/saa7134-dvb.c   |  2 +-
>   drivers/media/video/videobuf-dvb.c          | 11 +++--------
>   include/media/videobuf-dvb.h                |  4 +---
>   12 files changed, 9 insertions(+), 85 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 746dfd8..24d4d54 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -2052,18 +2052,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>   	struct dvb_frontend *fe = dvbdev->priv;
>   	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>   	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> -	int cb_err, err = -EOPNOTSUPP;
> -
> -	if (fe->dvb->fe_ioctl_override) {
> -		cb_err = fe->dvb->fe_ioctl_override(fe, cmd, parg,
> -						    DVB_FE_IOCTL_PRE);
> -		if (cb_err < 0)
> -			return cb_err;
> -		if (cb_err > 0)
> -			return 0;
> -		/* fe_ioctl_override returning 0 allows
> -		 * dvb-core to continue handling the ioctl */
> -	}
> +	int err = -EOPNOTSUPP;
>
>   	switch (cmd) {
>   	case FE_GET_INFO: {
> diff --git a/drivers/media/dvb/dvb-core/dvbdev.h b/drivers/media/dvb/dvb-core/dvbdev.h
> index 3b2c137..93a9470 100644
> --- a/drivers/media/dvb/dvb-core/dvbdev.h
> +++ b/drivers/media/dvb/dvb-core/dvbdev.h
> @@ -71,27 +71,6 @@ struct dvb_adapter {
>   	int mfe_shared;			/* indicates mutually exclusive frontends */
>   	struct dvb_device *mfe_dvbdev;	/* frontend device in use */
>   	struct mutex mfe_lock;		/* access lock for thread creation */
> -
> -	/* Allow the adapter/bridge driver to perform an action before and/or
> -	 * after the core handles an ioctl:
> -	 *
> -	 * DVB_FE_IOCTL_PRE indicates that the ioctl has not yet been handled.
> -	 *
> -	 * When DVB_FE_IOCTL_PRE is passed to the callback as the stage arg:
> -	 *
> -	 * return 0 to allow dvb-core to handle the ioctl.
> -	 * return a positive int to prevent dvb-core from handling the ioctl,
> -	 * 	and exit without error.
> -	 * return a negative int to prevent dvb-core from handling the ioctl,
> -	 * 	and return that value as an error.
> -	 *
> -	 * WARNING: Don't use it on newer drivers: this only affects DVBv3
> -	 * calls, and should be removed soon.
> -	 */
> -#define DVB_FE_IOCTL_PRE 0
> -	int (*fe_ioctl_override)(struct dvb_frontend *fe,
> -				 unsigned int cmd, void *parg,
> -				 unsigned int stage);
>   };
>
>
> diff --git a/drivers/media/dvb/dvb-usb-v2/dvb_usb.h b/drivers/media/dvb/dvb-usb-v2/dvb_usb.h
> index 4db591b..53e10c4 100644
> --- a/drivers/media/dvb/dvb-usb-v2/dvb_usb.h
> +++ b/drivers/media/dvb/dvb-usb-v2/dvb_usb.h
> @@ -206,7 +206,6 @@ struct dvb_usb_adapter_properties {
>    * @tuner_attach: called to attach the possible tuners
>    * @frontend_ctrl: called to power on/off active frontend
>    * @streaming_ctrl: called to start/stop the usb streaming of adapter
> - * @fe_ioctl_override: frontend ioctl override. avoid using that is possible
>    * @init: called after adapters are created in order to finalize device
>    *  configuration
>    * @exit: called when driver is unloaded
> @@ -247,8 +246,6 @@ struct dvb_usb_device_properties {
>   	int (*tuner_attach) (struct dvb_usb_adapter *);
>   	int (*frontend_ctrl) (struct dvb_frontend *, int);
>   	int (*streaming_ctrl) (struct dvb_frontend *, int);
> -	int (*fe_ioctl_override) (struct dvb_frontend *,
> -			unsigned int, void *, unsigned int);
>   	int (*init) (struct dvb_usb_device *);
>   	void (*exit) (struct dvb_usb_device *);
>   	int (*get_rc_config) (struct dvb_usb_device *, struct dvb_usb_rc *);
> diff --git a/drivers/media/dvb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/dvb/dvb-usb-v2/dvb_usb_core.c
> index 3224621..a72f9c7 100644
> --- a/drivers/media/dvb/dvb-usb-v2/dvb_usb_core.c
> +++ b/drivers/media/dvb/dvb-usb-v2/dvb_usb_core.c
> @@ -703,8 +703,6 @@ static int dvb_usbv2_adapter_init(struct dvb_usb_device *d)
>   		/* use exclusive FE lock if there is multiple shared FEs */
>   		if (adap->fe[1])
>   			adap->dvb_adap.mfe_shared = 1;
> -
> -		adap->dvb_adap.fe_ioctl_override = d->props->fe_ioctl_override;
>   	}
>
>   	return 0;
> diff --git a/drivers/media/dvb/dvb-usb-v2/mxl111sf.c b/drivers/media/dvb/dvb-usb-v2/mxl111sf.c
> index 861e0ae..efdcb15 100644
> --- a/drivers/media/dvb/dvb-usb-v2/mxl111sf.c
> +++ b/drivers/media/dvb/dvb-usb-v2/mxl111sf.c
> @@ -874,34 +874,12 @@ static int mxl111sf_attach_tuner(struct dvb_usb_adapter *adap)
>   		if (dvb_attach(mxl111sf_tuner_attach, adap->fe[i], state,
>   				&mxl_tuner_config) == NULL)
>   			return -EIO;
> +		adap->fe[i]->ops.read_signal_strength = adap->fe[i]->ops.tuner_ops.get_rf_strength;
>   	}
>
>   	return 0;
>   }
>
> -static int mxl111sf_fe_ioctl_override(struct dvb_frontend *fe,
> -				      unsigned int cmd, void *parg,
> -				      unsigned int stage)
> -{
> -	int err = 0;
> -
> -	switch (stage) {
> -	case DVB_FE_IOCTL_PRE:
> -
> -		switch (cmd) {
> -		case FE_READ_SIGNAL_STRENGTH:
> -			err = fe->ops.tuner_ops.get_rf_strength(fe, parg);
> -			/* If no error occurs, prevent dvb-core from handling
> -			 * this IOCTL, otherwise return the error */
> -			if (0 == err)
> -				err = 1;
> -			break;
> -		}
> -		break;
> -	}
> -	return err;
> -};
> -
>   static u32 mxl111sf_i2c_func(struct i2c_adapter *adapter)
>   {
>   	return I2C_FUNC_I2C;
> @@ -1082,7 +1060,6 @@ static struct dvb_usb_device_properties mxl111sf_props_dvbt = {
>   	.init              = mxl111sf_init,
>   	.streaming_ctrl    = mxl111sf_ep4_streaming_ctrl,
>   	.get_stream_config = mxl111sf_get_stream_config_dvbt,
> -	.fe_ioctl_override = mxl111sf_fe_ioctl_override,
>
>   	.num_adapters = 1,
>   	.adapter = {
> @@ -1124,7 +1101,6 @@ static struct dvb_usb_device_properties mxl111sf_props_atsc = {
>   	.init              = mxl111sf_init,
>   	.streaming_ctrl    = mxl111sf_ep6_streaming_ctrl,
>   	.get_stream_config = mxl111sf_get_stream_config_atsc,
> -	.fe_ioctl_override = mxl111sf_fe_ioctl_override,
>
>   	.num_adapters = 1,
>   	.adapter = {
> @@ -1166,7 +1142,6 @@ static struct dvb_usb_device_properties mxl111sf_props_mh = {
>   	.init              = mxl111sf_init,
>   	.streaming_ctrl    = mxl111sf_ep5_streaming_ctrl,
>   	.get_stream_config = mxl111sf_get_stream_config_mh,
> -	.fe_ioctl_override = mxl111sf_fe_ioctl_override,
>
>   	.num_adapters = 1,
>   	.adapter = {
> @@ -1235,7 +1210,6 @@ static struct dvb_usb_device_properties mxl111sf_props_atsc_mh = {
>   	.init              = mxl111sf_init,
>   	.streaming_ctrl    = mxl111sf_streaming_ctrl_atsc_mh,
>   	.get_stream_config = mxl111sf_get_stream_config_atsc_mh,
> -	.fe_ioctl_override = mxl111sf_fe_ioctl_override,
>
>   	.num_adapters = 1,
>   	.adapter = {
> @@ -1314,7 +1288,6 @@ static struct dvb_usb_device_properties mxl111sf_props_mercury = {
>   	.init              = mxl111sf_init,
>   	.streaming_ctrl    = mxl111sf_streaming_ctrl_mercury,
>   	.get_stream_config = mxl111sf_get_stream_config_mercury,
> -	.fe_ioctl_override = mxl111sf_fe_ioctl_override,
>
>   	.num_adapters = 1,
>   	.adapter = {
> @@ -1385,7 +1358,6 @@ static struct dvb_usb_device_properties mxl111sf_props_mercury_mh = {
>   	.init              = mxl111sf_init,
>   	.streaming_ctrl    = mxl111sf_streaming_ctrl_mercury_mh,
>   	.get_stream_config = mxl111sf_get_stream_config_mercury_mh,
> -	.fe_ioctl_override = mxl111sf_fe_ioctl_override,
>
>   	.num_adapters = 1,
>   	.adapter = {
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> index ddf282f..719413b 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> @@ -106,7 +106,6 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
>   		goto err;
>   	}
>   	adap->dvb_adap.priv = adap;
> -	adap->dvb_adap.fe_ioctl_override = adap->props.fe_ioctl_override;
>
>   	if (adap->dev->props.read_mac_address) {
>   		if (adap->dev->props.read_mac_address(adap->dev,adap->dvb_adap.proposed_mac) == 0)
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
> index 99f9440..aab0f99 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
> @@ -162,8 +162,6 @@ struct dvb_usb_adapter_properties {
>   	int size_of_priv;
>
>   	int (*frontend_ctrl)   (struct dvb_frontend *, int);
> -	int (*fe_ioctl_override) (struct dvb_frontend *,
> -				  unsigned int, void *, unsigned int);
>
>   	int num_frontends;
>   	struct dvb_usb_adapter_fe_properties fe[MAX_NO_OF_FE_PER_ADAP];
> diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
> index cd54268..f3202a5 100644
> --- a/drivers/media/video/cx23885/cx23885-dvb.c
> +++ b/drivers/media/video/cx23885/cx23885-dvb.c
> @@ -1218,8 +1218,7 @@ static int dvb_register(struct cx23885_tsport *port)
>
>   	/* register everything */
>   	ret = videobuf_dvb_register_bus(&port->frontends, THIS_MODULE, port,
> -					&dev->pci->dev, adapter_nr, mfe_shared,
> -					NULL);
> +					&dev->pci->dev, adapter_nr, mfe_shared);
>   	if (ret)
>   		goto frontend_detach;
>
> diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
> index 003937c..d803bba 100644
> --- a/drivers/media/video/cx88/cx88-dvb.c
> +++ b/drivers/media/video/cx88/cx88-dvb.c
> @@ -1578,7 +1578,7 @@ static int dvb_register(struct cx8802_dev *dev)
>
>   	/* register everything */
>   	res = videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
> -		&dev->pci->dev, adapter_nr, mfe_shared, NULL);
> +		&dev->pci->dev, adapter_nr, mfe_shared);
>   	if (res)
>   		goto frontend_detach;
>   	return res;
> diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
> index cc7f3d6..d0f53bb 100644
> --- a/drivers/media/video/saa7134/saa7134-dvb.c
> +++ b/drivers/media/video/saa7134/saa7134-dvb.c
> @@ -1849,7 +1849,7 @@ static int dvb_init(struct saa7134_dev *dev)
>
>   	/* register everything else */
>   	ret = videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
> -					&dev->pci->dev, adapter_nr, 0, NULL);
> +					&dev->pci->dev, adapter_nr, 0);
>
>   	/* this sequence is necessary to make the tda1004x load its firmware
>   	 * and to enter analog mode of hybrid boards
> diff --git a/drivers/media/video/videobuf-dvb.c b/drivers/media/video/videobuf-dvb.c
> index 94d83a4..b7efa45 100644
> --- a/drivers/media/video/videobuf-dvb.c
> +++ b/drivers/media/video/videobuf-dvb.c
> @@ -139,9 +139,7 @@ static int videobuf_dvb_register_adapter(struct videobuf_dvb_frontends *fe,
>   			  struct device *device,
>   			  char *adapter_name,
>   			  short *adapter_nr,
> -			  int mfe_shared,
> -			  int (*fe_ioctl_override)(struct dvb_frontend *,
> -					unsigned int, void *, unsigned int))
> +			  int mfe_shared)
>   {
>   	int result;
>
> @@ -156,7 +154,6 @@ static int videobuf_dvb_register_adapter(struct videobuf_dvb_frontends *fe,
>   	}
>   	fe->adapter.priv = adapter_priv;
>   	fe->adapter.mfe_shared = mfe_shared;
> -	fe->adapter.fe_ioctl_override = fe_ioctl_override;
>
>   	return result;
>   }
> @@ -257,9 +254,7 @@ int videobuf_dvb_register_bus(struct videobuf_dvb_frontends *f,
>   			  void *adapter_priv,
>   			  struct device *device,
>   			  short *adapter_nr,
> -			  int mfe_shared,
> -			  int (*fe_ioctl_override)(struct dvb_frontend *,
> -					unsigned int, void *, unsigned int))
> +			  int mfe_shared)
>   {
>   	struct list_head *list, *q;
>   	struct videobuf_dvb_frontend *fe;
> @@ -273,7 +268,7 @@ int videobuf_dvb_register_bus(struct videobuf_dvb_frontends *f,
>
>   	/* Bring up the adapter */
>   	res = videobuf_dvb_register_adapter(f, module, adapter_priv, device,
> -		fe->dvb.name, adapter_nr, mfe_shared, fe_ioctl_override);
> +		fe->dvb.name, adapter_nr, mfe_shared);
>   	if (res < 0) {
>   		printk(KERN_WARNING "videobuf_dvb_register_adapter failed (errno = %d)\n", res);
>   		return res;
> diff --git a/include/media/videobuf-dvb.h b/include/media/videobuf-dvb.h
> index bf36572..d63965a 100644
> --- a/include/media/videobuf-dvb.h
> +++ b/include/media/videobuf-dvb.h
> @@ -45,9 +45,7 @@ int videobuf_dvb_register_bus(struct videobuf_dvb_frontends *f,
>   			  void *adapter_priv,
>   			  struct device *device,
>   			  short *adapter_nr,
> -			  int mfe_shared,
> -			  int (*fe_ioctl_override)(struct dvb_frontend *,
> -					unsigned int, void *, unsigned int));
> +			  int mfe_shared);
>
>   void videobuf_dvb_unregister_bus(struct videobuf_dvb_frontends *f);

Thant was something I was near to do when implementing dvb-usb-v2. Looks 
correct!

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

regards
Antti

-- 
http://palosaari.fi/
