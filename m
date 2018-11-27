Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49333 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbeK0VaN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:30:13 -0500
Date: Tue, 27 Nov 2018 10:32:44 +0000
From: Sean Young <sean@mess.org>
To: Victor Toso <victortoso@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH dvb v1 3/4] media: dvb-usb-v2: remove __func__ from
 dev_dbg()
Message-ID: <20181127103244.euayq5jmclchh6mv@gofer.mess.org>
References: <20181030161451.4560-1-victortoso@redhat.com>
 <20181030161451.4560-4-victortoso@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030161451.4560-4-victortoso@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 30, 2018 at 05:14:50PM +0100, Victor Toso wrote:
> From: Victor Toso <me@victortoso.com>
> 
> As dynamic debug can be instructed to add the function name to the
> debug output using +f switch, we can remove __func__ from all
> dev_dbg() calls. If not, a user that sets +f in dynamic debug would
> get duplicated function name.
> 
> Signed-off-by: Victor Toso <me@victortoso.com>
> ---
>  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 105 ++++++++++----------
>  drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c  |   7 +-
>  2 files changed, 55 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> index d55ef016d418..ad554668cc86 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> @@ -37,7 +37,7 @@ static int dvb_usbv2_download_firmware(struct dvb_usb_device *d,
>  {
>  	int ret;
>  	const struct firmware *fw;
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");

How about "downloading firmware", or maybe deleting the line completely?

Without dynamic debug enabled, you end up with a pretty useless debug
message now. I think it would be better to convert these debug lines
to useful messages, rather than "executing this line of code". Some of
them should probably be deleted.

>  
>  	if (!d->props->download_firmware) {
>  		ret = -EINVAL;
> @@ -62,14 +62,14 @@ static int dvb_usbv2_download_firmware(struct dvb_usb_device *d,
>  
>  	return ret;
>  err:
> -	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&d->udev->dev, "failed=%d\n", ret);

Again, just say what failed here. Ideally debug messages should be useful and
not just "hit this line of code".


Sean

>  	return ret;
>  }
>  
>  static int dvb_usbv2_i2c_init(struct dvb_usb_device *d)
>  {
>  	int ret;
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	if (!d->props->i2c_algo)
>  		return 0;
> @@ -87,13 +87,13 @@ static int dvb_usbv2_i2c_init(struct dvb_usb_device *d)
>  
>  	return 0;
>  err:
> -	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&d->udev->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
>  static int dvb_usbv2_i2c_exit(struct dvb_usb_device *d)
>  {
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	if (d->i2c_adap.algo)
>  		i2c_del_adapter(&d->i2c_adap);
> @@ -133,7 +133,7 @@ static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
>  {
>  	int ret;
>  	struct rc_dev *dev;
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	if (dvb_usbv2_disable_rc_polling || !d->props->get_rc_config)
>  		return 0;
> @@ -188,13 +188,13 @@ static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
>  
>  	return 0;
>  err:
> -	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&d->udev->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
>  static int dvb_usbv2_remote_exit(struct dvb_usb_device *d)
>  {
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	if (d->rc_dev) {
>  		cancel_delayed_work_sync(&d->rc_query_work);
> @@ -232,7 +232,7 @@ static void dvb_usb_data_complete_raw(struct usb_data_stream *stream, u8 *buf,
>  
>  static int dvb_usbv2_adapter_stream_init(struct dvb_usb_adapter *adap)
>  {
> -	dev_dbg(&adap_to_d(adap)->udev->dev, "%s: adap=%d\n", __func__,
> +	dev_dbg(&adap_to_d(adap)->udev->dev, "adap=%d\n",
>  			adap->id);
>  
>  	adap->stream.udev = adap_to_d(adap)->udev;
> @@ -244,7 +244,7 @@ static int dvb_usbv2_adapter_stream_init(struct dvb_usb_adapter *adap)
>  
>  static int dvb_usbv2_adapter_stream_exit(struct dvb_usb_adapter *adap)
>  {
> -	dev_dbg(&adap_to_d(adap)->udev->dev, "%s: adap=%d\n", __func__,
> +	dev_dbg(&adap_to_d(adap)->udev->dev, "adap=%d\n",
>  			adap->id);
>  
>  	return usb_urb_exitv2(&adap->stream);
> @@ -257,8 +257,8 @@ static int dvb_usb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
>  	int ret = 0;
>  	struct usb_data_stream_properties stream_props;
>  	dev_dbg(&d->udev->dev,
> -			"%s: adap=%d active_fe=%d feed_type=%d setting pid [%s]: %04x (%04d) at index %d\n",
> -			__func__, adap->id, adap->active_fe, dvbdmxfeed->type,
> +			"adap=%d active_fe=%d feed_type=%d setting pid [%s]: %04x (%04d) at index %d\n",
> +			adap->id, adap->active_fe, dvbdmxfeed->type,
>  			adap->pid_filtering ? "yes" : "no", dvbdmxfeed->pid,
>  			dvbdmxfeed->pid, dvbdmxfeed->index);
>  
> @@ -334,7 +334,7 @@ static int dvb_usb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
>  	}
>  
>  	if (ret)
> -		dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +		dev_dbg(&d->udev->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -344,8 +344,8 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
>  	struct dvb_usb_device *d = adap_to_d(adap);
>  	int ret = 0;
>  	dev_dbg(&d->udev->dev,
> -			"%s: adap=%d active_fe=%d feed_type=%d setting pid [%s]: %04x (%04d) at index %d\n",
> -			__func__, adap->id, adap->active_fe, dvbdmxfeed->type,
> +			"adap=%d active_fe=%d feed_type=%d setting pid [%s]: %04x (%04d) at index %d\n",
> +			adap->id, adap->active_fe, dvbdmxfeed->type,
>  			adap->pid_filtering ? "yes" : "no", dvbdmxfeed->pid,
>  			dvbdmxfeed->pid, dvbdmxfeed->index);
>  
> @@ -393,7 +393,7 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
>  skip_feed_stop:
>  
>  	if (ret)
> -		dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +		dev_dbg(&d->udev->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -446,13 +446,13 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
>  	int ret;
>  	struct dvb_usb_device *d = adap_to_d(adap);
>  
> -	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, adap->id);
> +	dev_dbg(&d->udev->dev, "adap=%d\n", adap->id);
>  
>  	ret = dvb_register_adapter(&adap->dvb_adap, d->name, d->props->owner,
>  			&d->udev->dev, d->props->adapter_nr);
>  	if (ret < 0) {
> -		dev_dbg(&d->udev->dev, "%s: dvb_register_adapter() failed=%d\n",
> -				__func__, ret);
> +		dev_dbg(&d->udev->dev, "dvb_register_adapter() failed=%d\n",
> +				ret);
>  		goto err_dvb_register_adapter;
>  	}
>  
> @@ -460,8 +460,8 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
>  
>  	ret = dvb_usbv2_media_device_init(adap);
>  	if (ret < 0) {
> -		dev_dbg(&d->udev->dev, "%s: dvb_usbv2_media_device_init() failed=%d\n",
> -				__func__, ret);
> +		dev_dbg(&d->udev->dev, "dvb_usbv2_media_device_init() failed=%d\n",
> +				ret);
>  		goto err_dvb_register_mc;
>  	}
>  
> @@ -523,7 +523,7 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
>  
>  static int dvb_usbv2_adapter_dvb_exit(struct dvb_usb_adapter *adap)
>  {
> -	dev_dbg(&adap_to_d(adap)->udev->dev, "%s: adap=%d\n", __func__,
> +	dev_dbg(&adap_to_d(adap)->udev->dev, "adap=%d\n",
>  			adap->id);
>  
>  	if (adap->dvb_adap.priv) {
> @@ -548,7 +548,7 @@ static int dvb_usbv2_device_power_ctrl(struct dvb_usb_device *d, int onoff)
>  
>  	if (d->powered == 0 || (onoff && d->powered == 1)) {
>  		/* when switching from 1 to 0 or from 0 to 1 */
> -		dev_dbg(&d->udev->dev, "%s: power=%d\n", __func__, onoff);
> +		dev_dbg(&d->udev->dev, "power=%d\n", onoff);
>  		if (d->props->power_ctrl) {
>  			ret = d->props->power_ctrl(d, onoff);
>  			if (ret < 0)
> @@ -558,7 +558,7 @@ static int dvb_usbv2_device_power_ctrl(struct dvb_usb_device *d, int onoff)
>  
>  	return 0;
>  err:
> -	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&d->udev->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -567,7 +567,7 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
>  	int ret;
>  	struct dvb_usb_adapter *adap = fe->dvb->priv;
>  	struct dvb_usb_device *d = adap_to_d(adap);
> -	dev_dbg(&d->udev->dev, "%s: adap=%d fe=%d\n", __func__, adap->id,
> +	dev_dbg(&d->udev->dev, "adap=%d fe=%d\n", adap->id,
>  			fe->id);
>  
>  	if (!adap->suspend_resume_active) {
> @@ -597,7 +597,7 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
>  		wake_up_bit(&adap->state_bits, ADAP_INIT);
>  	}
>  
> -	dev_dbg(&d->udev->dev, "%s: ret=%d\n", __func__, ret);
> +	dev_dbg(&d->udev->dev, "ret=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -606,7 +606,7 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
>  	int ret;
>  	struct dvb_usb_adapter *adap = fe->dvb->priv;
>  	struct dvb_usb_device *d = adap_to_d(adap);
> -	dev_dbg(&d->udev->dev, "%s: adap=%d fe=%d\n", __func__, adap->id,
> +	dev_dbg(&d->udev->dev, "adap=%d fe=%d\n", adap->id,
>  			fe->id);
>  
>  	if (!adap->suspend_resume_active) {
> @@ -637,7 +637,7 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
>  		wake_up_bit(&adap->state_bits, ADAP_SLEEP);
>  	}
>  
> -	dev_dbg(&d->udev->dev, "%s: ret=%d\n", __func__, ret);
> +	dev_dbg(&d->udev->dev, "ret=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -645,7 +645,7 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
>  {
>  	int ret, i, count_registered = 0;
>  	struct dvb_usb_device *d = adap_to_d(adap);
> -	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, adap->id);
> +	dev_dbg(&d->udev->dev, "adap=%d\n", adap->id);
>  
>  	memset(adap->fe, 0, sizeof(adap->fe));
>  	adap->active_fe = -1;
> @@ -654,13 +654,12 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
>  		ret = d->props->frontend_attach(adap);
>  		if (ret < 0) {
>  			dev_dbg(&d->udev->dev,
> -					"%s: frontend_attach() failed=%d\n",
> -					__func__, ret);
> +					"frontend_attach() failed=%d\n",
> +					ret);
>  			goto err_dvb_frontend_detach;
>  		}
>  	} else {
> -		dev_dbg(&d->udev->dev, "%s: frontend_attach() do not exists\n",
> -				__func__);
> +		dev_dbg(&d->udev->dev, "frontend_attach() do not exists\n");
>  		ret = 0;
>  		goto err;
>  	}
> @@ -687,8 +686,8 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
>  	if (d->props->tuner_attach) {
>  		ret = d->props->tuner_attach(adap);
>  		if (ret < 0) {
> -			dev_dbg(&d->udev->dev, "%s: tuner_attach() failed=%d\n",
> -					__func__, ret);
> +			dev_dbg(&d->udev->dev, "tuner_attach() failed=%d\n",
> +					ret);
>  			goto err_dvb_unregister_frontend;
>  		}
>  	}
> @@ -714,7 +713,7 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
>  	}
>  
>  err:
> -	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&d->udev->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -723,7 +722,7 @@ static int dvb_usbv2_adapter_frontend_exit(struct dvb_usb_adapter *adap)
>  	int ret, i;
>  	struct dvb_usb_device *d = adap_to_d(adap);
>  
> -	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, adap->id);
> +	dev_dbg(&d->udev->dev, "adap=%d\n", adap->id);
>  
>  	for (i = MAX_NO_OF_FE_PER_ADAP - 1; i >= 0; i--) {
>  		if (adap->fe[i]) {
> @@ -735,8 +734,8 @@ static int dvb_usbv2_adapter_frontend_exit(struct dvb_usb_adapter *adap)
>  	if (d->props->tuner_detach) {
>  		ret = d->props->tuner_detach(adap);
>  		if (ret < 0) {
> -			dev_dbg(&d->udev->dev, "%s: tuner_detach() failed=%d\n",
> -					__func__, ret);
> +			dev_dbg(&d->udev->dev, "tuner_detach() failed=%d\n",
> +					ret);
>  		}
>  	}
>  
> @@ -744,8 +743,8 @@ static int dvb_usbv2_adapter_frontend_exit(struct dvb_usb_adapter *adap)
>  		ret = d->props->frontend_detach(adap);
>  		if (ret < 0) {
>  			dev_dbg(&d->udev->dev,
> -					"%s: frontend_detach() failed=%d\n",
> -					__func__, ret);
> +					"frontend_detach() failed=%d\n",
> +					ret);
>  		}
>  	}
>  
> @@ -825,14 +824,14 @@ static int dvb_usbv2_adapter_init(struct dvb_usb_device *d)
>  
>  	return 0;
>  err:
> -	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&d->udev->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
>  static int dvb_usbv2_adapter_exit(struct dvb_usb_device *d)
>  {
>  	int i;
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	for (i = MAX_NO_OF_ADAPTER_PER_DEVICE - 1; i >= 0; i--) {
>  		if (d->adapter[i].props) {
> @@ -849,7 +848,7 @@ static int dvb_usbv2_adapter_exit(struct dvb_usb_device *d)
>  /* general initialization functions */
>  static int dvb_usbv2_exit(struct dvb_usb_device *d)
>  {
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	dvb_usbv2_remote_exit(d);
>  	dvb_usbv2_adapter_exit(d);
> @@ -861,7 +860,7 @@ static int dvb_usbv2_exit(struct dvb_usb_device *d)
>  static int dvb_usbv2_init(struct dvb_usb_device *d)
>  {
>  	int ret;
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	dvb_usbv2_device_power_ctrl(d, 1);
>  
> @@ -894,7 +893,7 @@ static int dvb_usbv2_init(struct dvb_usb_device *d)
>  	return 0;
>  err:
>  	dvb_usbv2_device_power_ctrl(d, 0);
> -	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&d->udev->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -907,7 +906,7 @@ int dvb_usbv2_probe(struct usb_interface *intf,
>  	struct dvb_usb_driver_info *driver_info =
>  			(struct dvb_usb_driver_info *) id->driver_info;
>  
> -	dev_dbg(&udev->dev, "%s: bInterfaceNumber=%d\n", __func__,
> +	dev_dbg(&udev->dev, "bInterfaceNumber=%d\n",
>  			intf->cur_altsetting->desc.bInterfaceNumber);
>  
>  	if (!id->driver_info) {
> @@ -1010,7 +1009,7 @@ int dvb_usbv2_probe(struct usb_interface *intf,
>  err_kfree_d:
>  	kfree(d);
>  err:
> -	dev_dbg(&udev->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&udev->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  EXPORT_SYMBOL(dvb_usbv2_probe);
> @@ -1021,7 +1020,7 @@ void dvb_usbv2_disconnect(struct usb_interface *intf)
>  	const char *devname = kstrdup(dev_name(&d->udev->dev), GFP_KERNEL);
>  	const char *drvname = d->name;
>  
> -	dev_dbg(&d->udev->dev, "%s: bInterfaceNumber=%d\n", __func__,
> +	dev_dbg(&d->udev->dev, "bInterfaceNumber=%d\n",
>  			intf->cur_altsetting->desc.bInterfaceNumber);
>  
>  	if (d->props->exit)
> @@ -1046,7 +1045,7 @@ int dvb_usbv2_suspend(struct usb_interface *intf, pm_message_t msg)
>  	struct dvb_usb_device *d = usb_get_intfdata(intf);
>  	int ret = 0, i, active_fe;
>  	struct dvb_frontend *fe;
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	/* stop remote controller poll */
>  	if (d->rc_polling_active)
> @@ -1076,7 +1075,7 @@ static int dvb_usbv2_resume_common(struct dvb_usb_device *d)
>  {
>  	int ret = 0, i, active_fe;
>  	struct dvb_frontend *fe;
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	for (i = 0; i < MAX_NO_OF_ADAPTER_PER_DEVICE; i++) {
>  		active_fe = d->adapter[i].active_fe;
> @@ -1106,7 +1105,7 @@ static int dvb_usbv2_resume_common(struct dvb_usb_device *d)
>  int dvb_usbv2_resume(struct usb_interface *intf)
>  {
>  	struct dvb_usb_device *d = usb_get_intfdata(intf);
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	return dvb_usbv2_resume_common(d);
>  }
> @@ -1116,7 +1115,7 @@ int dvb_usbv2_reset_resume(struct usb_interface *intf)
>  {
>  	struct dvb_usb_device *d = usb_get_intfdata(intf);
>  	int ret;
> -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +	dev_dbg(&d->udev->dev, "\n");
>  
>  	dvb_usbv2_device_power_ctrl(d, 1);
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
> index 5bafeb6486be..f24513159470 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
> @@ -28,11 +28,11 @@ static int dvb_usb_v2_generic_io(struct dvb_usb_device *d,
>  
>  	if (!wbuf || !wlen || !d->props->generic_bulk_ctrl_endpoint ||
>  			!d->props->generic_bulk_ctrl_endpoint_response) {
> -		dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, -EINVAL);
> +		dev_dbg(&d->udev->dev, "failed=%d\n", -EINVAL);
>  		return -EINVAL;
>  	}
>  
> -	dev_dbg(&d->udev->dev, "%s: >>> %*ph\n", __func__, wlen, wbuf);
> +	dev_dbg(&d->udev->dev, ">>> %*ph\n", wlen, wbuf);
>  
>  	ret = usb_bulk_msg(d->udev, usb_sndbulkpipe(d->udev,
>  			d->props->generic_bulk_ctrl_endpoint), wbuf, wlen,
> @@ -58,8 +58,7 @@ static int dvb_usb_v2_generic_io(struct dvb_usb_device *d,
>  					"%s: 2nd usb_bulk_msg() failed=%d\n",
>  					KBUILD_MODNAME, ret);
>  
> -		dev_dbg(&d->udev->dev, "%s: <<< %*ph\n", __func__,
> -				actual_length, rbuf);
> +		dev_dbg(&d->udev->dev, "<<< %*ph\n", actual_length, rbuf);
>  	}
>  
>  	return ret;
> -- 
> 2.17.2
