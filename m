Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40464 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbeLDJ4F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 04:56:05 -0500
Date: Tue, 4 Dec 2018 10:56:03 +0100
From: Victor Toso <victortoso@redhat.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH dvb v1 3/4] media: dvb-usb-v2: remove __func__ from
 dev_dbg()
Message-ID: <20181204095603.qzubs6gw2gmhkv5w@wingsuit>
References: <20181030161451.4560-1-victortoso@redhat.com>
 <20181030161451.4560-4-victortoso@redhat.com>
 <20181127103244.euayq5jmclchh6mv@gofer.mess.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="svp5s54hirmux5a7"
Content-Disposition: inline
In-Reply-To: <20181127103244.euayq5jmclchh6mv@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--svp5s54hirmux5a7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sean,

Thanks for taking time to review those patches.

On Tue, Nov 27, 2018 at 10:32:44AM +0000, Sean Young wrote:
> On Tue, Oct 30, 2018 at 05:14:50PM +0100, Victor Toso wrote:
> > From: Victor Toso <me@victortoso.com>
> >=20
> > As dynamic debug can be instructed to add the function name to the
> > debug output using +f switch, we can remove __func__ from all
> > dev_dbg() calls. If not, a user that sets +f in dynamic debug would
> > get duplicated function name.
> >=20
> > Signed-off-by: Victor Toso <me@victortoso.com>
> > ---
> >  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 105 ++++++++++----------
> >  drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c  |   7 +-
> >  2 files changed, 55 insertions(+), 57 deletions(-)
> >=20
> > diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/medi=
a/usb/dvb-usb-v2/dvb_usb_core.c
> > index d55ef016d418..ad554668cc86 100644
> > --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> > +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> > @@ -37,7 +37,7 @@ static int dvb_usbv2_download_firmware(struct dvb_usb=
_device *d,
> >  {
> >  	int ret;
> >  	const struct firmware *fw;
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
>=20
> How about "downloading firmware", or maybe deleting the line
> completely?

Ok

> Without dynamic debug enabled, you end up with a pretty useless
> debug message now. I think it would be better to convert these
> debug lines to useful messages, rather than "executing this
> line of code". Some of them should probably be deleted.

Yes, some of those debug lines are not useful without dynamic
debug.  Some messages can be improved.

> >  	if (!d->props->download_firmware) {
> >  		ret =3D -EINVAL;
> > @@ -62,14 +62,14 @@ static int dvb_usbv2_download_firmware(struct dvb_u=
sb_device *d,
> > =20
> >  	return ret;
> >  err:
> > -	dev_dbg(&d->udev->dev, "%s: failed=3D%d\n", __func__, ret);
> > +	dev_dbg(&d->udev->dev, "failed=3D%d\n", ret);
>=20
> Again, just say what failed here. Ideally debug messages should
> be useful and not just "hit this line of code".
>=20
> Sean

I'll go over all of them again and send a new version.

Cheers,
Victor

> >  	return ret;
> >  }
> > =20
> >  static int dvb_usbv2_i2c_init(struct dvb_usb_device *d)
> >  {
> >  	int ret;
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	if (!d->props->i2c_algo)
> >  		return 0;
> > @@ -87,13 +87,13 @@ static int dvb_usbv2_i2c_init(struct dvb_usb_device=
 *d)
> > =20
> >  	return 0;
> >  err:
> > -	dev_dbg(&d->udev->dev, "%s: failed=3D%d\n", __func__, ret);
> > +	dev_dbg(&d->udev->dev, "failed=3D%d\n", ret);
> >  	return ret;
> >  }
> > =20
> >  static int dvb_usbv2_i2c_exit(struct dvb_usb_device *d)
> >  {
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	if (d->i2c_adap.algo)
> >  		i2c_del_adapter(&d->i2c_adap);
> > @@ -133,7 +133,7 @@ static int dvb_usbv2_remote_init(struct dvb_usb_dev=
ice *d)
> >  {
> >  	int ret;
> >  	struct rc_dev *dev;
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	if (dvb_usbv2_disable_rc_polling || !d->props->get_rc_config)
> >  		return 0;
> > @@ -188,13 +188,13 @@ static int dvb_usbv2_remote_init(struct dvb_usb_d=
evice *d)
> > =20
> >  	return 0;
> >  err:
> > -	dev_dbg(&d->udev->dev, "%s: failed=3D%d\n", __func__, ret);
> > +	dev_dbg(&d->udev->dev, "failed=3D%d\n", ret);
> >  	return ret;
> >  }
> > =20
> >  static int dvb_usbv2_remote_exit(struct dvb_usb_device *d)
> >  {
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	if (d->rc_dev) {
> >  		cancel_delayed_work_sync(&d->rc_query_work);
> > @@ -232,7 +232,7 @@ static void dvb_usb_data_complete_raw(struct usb_da=
ta_stream *stream, u8 *buf,
> > =20
> >  static int dvb_usbv2_adapter_stream_init(struct dvb_usb_adapter *adap)
> >  {
> > -	dev_dbg(&adap_to_d(adap)->udev->dev, "%s: adap=3D%d\n", __func__,
> > +	dev_dbg(&adap_to_d(adap)->udev->dev, "adap=3D%d\n",
> >  			adap->id);
> > =20
> >  	adap->stream.udev =3D adap_to_d(adap)->udev;
> > @@ -244,7 +244,7 @@ static int dvb_usbv2_adapter_stream_init(struct dvb=
_usb_adapter *adap)
> > =20
> >  static int dvb_usbv2_adapter_stream_exit(struct dvb_usb_adapter *adap)
> >  {
> > -	dev_dbg(&adap_to_d(adap)->udev->dev, "%s: adap=3D%d\n", __func__,
> > +	dev_dbg(&adap_to_d(adap)->udev->dev, "adap=3D%d\n",
> >  			adap->id);
> > =20
> >  	return usb_urb_exitv2(&adap->stream);
> > @@ -257,8 +257,8 @@ static int dvb_usb_start_feed(struct dvb_demux_feed=
 *dvbdmxfeed)
> >  	int ret =3D 0;
> >  	struct usb_data_stream_properties stream_props;
> >  	dev_dbg(&d->udev->dev,
> > -			"%s: adap=3D%d active_fe=3D%d feed_type=3D%d setting pid [%s]: %04x=
 (%04d) at index %d\n",
> > -			__func__, adap->id, adap->active_fe, dvbdmxfeed->type,
> > +			"adap=3D%d active_fe=3D%d feed_type=3D%d setting pid [%s]: %04x (%0=
4d) at index %d\n",
> > +			adap->id, adap->active_fe, dvbdmxfeed->type,
> >  			adap->pid_filtering ? "yes" : "no", dvbdmxfeed->pid,
> >  			dvbdmxfeed->pid, dvbdmxfeed->index);
> > =20
> > @@ -334,7 +334,7 @@ static int dvb_usb_start_feed(struct dvb_demux_feed=
 *dvbdmxfeed)
> >  	}
> > =20
> >  	if (ret)
> > -		dev_dbg(&d->udev->dev, "%s: failed=3D%d\n", __func__, ret);
> > +		dev_dbg(&d->udev->dev, "failed=3D%d\n", ret);
> >  	return ret;
> >  }
> > =20
> > @@ -344,8 +344,8 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed =
*dvbdmxfeed)
> >  	struct dvb_usb_device *d =3D adap_to_d(adap);
> >  	int ret =3D 0;
> >  	dev_dbg(&d->udev->dev,
> > -			"%s: adap=3D%d active_fe=3D%d feed_type=3D%d setting pid [%s]: %04x=
 (%04d) at index %d\n",
> > -			__func__, adap->id, adap->active_fe, dvbdmxfeed->type,
> > +			"adap=3D%d active_fe=3D%d feed_type=3D%d setting pid [%s]: %04x (%0=
4d) at index %d\n",
> > +			adap->id, adap->active_fe, dvbdmxfeed->type,
> >  			adap->pid_filtering ? "yes" : "no", dvbdmxfeed->pid,
> >  			dvbdmxfeed->pid, dvbdmxfeed->index);
> > =20
> > @@ -393,7 +393,7 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed =
*dvbdmxfeed)
> >  skip_feed_stop:
> > =20
> >  	if (ret)
> > -		dev_dbg(&d->udev->dev, "%s: failed=3D%d\n", __func__, ret);
> > +		dev_dbg(&d->udev->dev, "failed=3D%d\n", ret);
> >  	return ret;
> >  }
> > =20
> > @@ -446,13 +446,13 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_=
usb_adapter *adap)
> >  	int ret;
> >  	struct dvb_usb_device *d =3D adap_to_d(adap);
> > =20
> > -	dev_dbg(&d->udev->dev, "%s: adap=3D%d\n", __func__, adap->id);
> > +	dev_dbg(&d->udev->dev, "adap=3D%d\n", adap->id);
> > =20
> >  	ret =3D dvb_register_adapter(&adap->dvb_adap, d->name, d->props->owne=
r,
> >  			&d->udev->dev, d->props->adapter_nr);
> >  	if (ret < 0) {
> > -		dev_dbg(&d->udev->dev, "%s: dvb_register_adapter() failed=3D%d\n",
> > -				__func__, ret);
> > +		dev_dbg(&d->udev->dev, "dvb_register_adapter() failed=3D%d\n",
> > +				ret);
> >  		goto err_dvb_register_adapter;
> >  	}
> > =20
> > @@ -460,8 +460,8 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_us=
b_adapter *adap)
> > =20
> >  	ret =3D dvb_usbv2_media_device_init(adap);
> >  	if (ret < 0) {
> > -		dev_dbg(&d->udev->dev, "%s: dvb_usbv2_media_device_init() failed=3D%=
d\n",
> > -				__func__, ret);
> > +		dev_dbg(&d->udev->dev, "dvb_usbv2_media_device_init() failed=3D%d\n",
> > +				ret);
> >  		goto err_dvb_register_mc;
> >  	}
> > =20
> > @@ -523,7 +523,7 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_us=
b_adapter *adap)
> > =20
> >  static int dvb_usbv2_adapter_dvb_exit(struct dvb_usb_adapter *adap)
> >  {
> > -	dev_dbg(&adap_to_d(adap)->udev->dev, "%s: adap=3D%d\n", __func__,
> > +	dev_dbg(&adap_to_d(adap)->udev->dev, "adap=3D%d\n",
> >  			adap->id);
> > =20
> >  	if (adap->dvb_adap.priv) {
> > @@ -548,7 +548,7 @@ static int dvb_usbv2_device_power_ctrl(struct dvb_u=
sb_device *d, int onoff)
> > =20
> >  	if (d->powered =3D=3D 0 || (onoff && d->powered =3D=3D 1)) {
> >  		/* when switching from 1 to 0 or from 0 to 1 */
> > -		dev_dbg(&d->udev->dev, "%s: power=3D%d\n", __func__, onoff);
> > +		dev_dbg(&d->udev->dev, "power=3D%d\n", onoff);
> >  		if (d->props->power_ctrl) {
> >  			ret =3D d->props->power_ctrl(d, onoff);
> >  			if (ret < 0)
> > @@ -558,7 +558,7 @@ static int dvb_usbv2_device_power_ctrl(struct dvb_u=
sb_device *d, int onoff)
> > =20
> >  	return 0;
> >  err:
> > -	dev_dbg(&d->udev->dev, "%s: failed=3D%d\n", __func__, ret);
> > +	dev_dbg(&d->udev->dev, "failed=3D%d\n", ret);
> >  	return ret;
> >  }
> > =20
> > @@ -567,7 +567,7 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
> >  	int ret;
> >  	struct dvb_usb_adapter *adap =3D fe->dvb->priv;
> >  	struct dvb_usb_device *d =3D adap_to_d(adap);
> > -	dev_dbg(&d->udev->dev, "%s: adap=3D%d fe=3D%d\n", __func__, adap->id,
> > +	dev_dbg(&d->udev->dev, "adap=3D%d fe=3D%d\n", adap->id,
> >  			fe->id);
> > =20
> >  	if (!adap->suspend_resume_active) {
> > @@ -597,7 +597,7 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
> >  		wake_up_bit(&adap->state_bits, ADAP_INIT);
> >  	}
> > =20
> > -	dev_dbg(&d->udev->dev, "%s: ret=3D%d\n", __func__, ret);
> > +	dev_dbg(&d->udev->dev, "ret=3D%d\n", ret);
> >  	return ret;
> >  }
> > =20
> > @@ -606,7 +606,7 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
> >  	int ret;
> >  	struct dvb_usb_adapter *adap =3D fe->dvb->priv;
> >  	struct dvb_usb_device *d =3D adap_to_d(adap);
> > -	dev_dbg(&d->udev->dev, "%s: adap=3D%d fe=3D%d\n", __func__, adap->id,
> > +	dev_dbg(&d->udev->dev, "adap=3D%d fe=3D%d\n", adap->id,
> >  			fe->id);
> > =20
> >  	if (!adap->suspend_resume_active) {
> > @@ -637,7 +637,7 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
> >  		wake_up_bit(&adap->state_bits, ADAP_SLEEP);
> >  	}
> > =20
> > -	dev_dbg(&d->udev->dev, "%s: ret=3D%d\n", __func__, ret);
> > +	dev_dbg(&d->udev->dev, "ret=3D%d\n", ret);
> >  	return ret;
> >  }
> > =20
> > @@ -645,7 +645,7 @@ static int dvb_usbv2_adapter_frontend_init(struct d=
vb_usb_adapter *adap)
> >  {
> >  	int ret, i, count_registered =3D 0;
> >  	struct dvb_usb_device *d =3D adap_to_d(adap);
> > -	dev_dbg(&d->udev->dev, "%s: adap=3D%d\n", __func__, adap->id);
> > +	dev_dbg(&d->udev->dev, "adap=3D%d\n", adap->id);
> > =20
> >  	memset(adap->fe, 0, sizeof(adap->fe));
> >  	adap->active_fe =3D -1;
> > @@ -654,13 +654,12 @@ static int dvb_usbv2_adapter_frontend_init(struct=
 dvb_usb_adapter *adap)
> >  		ret =3D d->props->frontend_attach(adap);
> >  		if (ret < 0) {
> >  			dev_dbg(&d->udev->dev,
> > -					"%s: frontend_attach() failed=3D%d\n",
> > -					__func__, ret);
> > +					"frontend_attach() failed=3D%d\n",
> > +					ret);
> >  			goto err_dvb_frontend_detach;
> >  		}
> >  	} else {
> > -		dev_dbg(&d->udev->dev, "%s: frontend_attach() do not exists\n",
> > -				__func__);
> > +		dev_dbg(&d->udev->dev, "frontend_attach() do not exists\n");
> >  		ret =3D 0;
> >  		goto err;
> >  	}
> > @@ -687,8 +686,8 @@ static int dvb_usbv2_adapter_frontend_init(struct d=
vb_usb_adapter *adap)
> >  	if (d->props->tuner_attach) {
> >  		ret =3D d->props->tuner_attach(adap);
> >  		if (ret < 0) {
> > -			dev_dbg(&d->udev->dev, "%s: tuner_attach() failed=3D%d\n",
> > -					__func__, ret);
> > +			dev_dbg(&d->udev->dev, "tuner_attach() failed=3D%d\n",
> > +					ret);
> >  			goto err_dvb_unregister_frontend;
> >  		}
> >  	}
> > @@ -714,7 +713,7 @@ static int dvb_usbv2_adapter_frontend_init(struct d=
vb_usb_adapter *adap)
> >  	}
> > =20
> >  err:
> > -	dev_dbg(&d->udev->dev, "%s: failed=3D%d\n", __func__, ret);
> > +	dev_dbg(&d->udev->dev, "failed=3D%d\n", ret);
> >  	return ret;
> >  }
> > =20
> > @@ -723,7 +722,7 @@ static int dvb_usbv2_adapter_frontend_exit(struct d=
vb_usb_adapter *adap)
> >  	int ret, i;
> >  	struct dvb_usb_device *d =3D adap_to_d(adap);
> > =20
> > -	dev_dbg(&d->udev->dev, "%s: adap=3D%d\n", __func__, adap->id);
> > +	dev_dbg(&d->udev->dev, "adap=3D%d\n", adap->id);
> > =20
> >  	for (i =3D MAX_NO_OF_FE_PER_ADAP - 1; i >=3D 0; i--) {
> >  		if (adap->fe[i]) {
> > @@ -735,8 +734,8 @@ static int dvb_usbv2_adapter_frontend_exit(struct d=
vb_usb_adapter *adap)
> >  	if (d->props->tuner_detach) {
> >  		ret =3D d->props->tuner_detach(adap);
> >  		if (ret < 0) {
> > -			dev_dbg(&d->udev->dev, "%s: tuner_detach() failed=3D%d\n",
> > -					__func__, ret);
> > +			dev_dbg(&d->udev->dev, "tuner_detach() failed=3D%d\n",
> > +					ret);
> >  		}
> >  	}
> > =20
> > @@ -744,8 +743,8 @@ static int dvb_usbv2_adapter_frontend_exit(struct d=
vb_usb_adapter *adap)
> >  		ret =3D d->props->frontend_detach(adap);
> >  		if (ret < 0) {
> >  			dev_dbg(&d->udev->dev,
> > -					"%s: frontend_detach() failed=3D%d\n",
> > -					__func__, ret);
> > +					"frontend_detach() failed=3D%d\n",
> > +					ret);
> >  		}
> >  	}
> > =20
> > @@ -825,14 +824,14 @@ static int dvb_usbv2_adapter_init(struct dvb_usb_=
device *d)
> > =20
> >  	return 0;
> >  err:
> > -	dev_dbg(&d->udev->dev, "%s: failed=3D%d\n", __func__, ret);
> > +	dev_dbg(&d->udev->dev, "failed=3D%d\n", ret);
> >  	return ret;
> >  }
> > =20
> >  static int dvb_usbv2_adapter_exit(struct dvb_usb_device *d)
> >  {
> >  	int i;
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	for (i =3D MAX_NO_OF_ADAPTER_PER_DEVICE - 1; i >=3D 0; i--) {
> >  		if (d->adapter[i].props) {
> > @@ -849,7 +848,7 @@ static int dvb_usbv2_adapter_exit(struct dvb_usb_de=
vice *d)
> >  /* general initialization functions */
> >  static int dvb_usbv2_exit(struct dvb_usb_device *d)
> >  {
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	dvb_usbv2_remote_exit(d);
> >  	dvb_usbv2_adapter_exit(d);
> > @@ -861,7 +860,7 @@ static int dvb_usbv2_exit(struct dvb_usb_device *d)
> >  static int dvb_usbv2_init(struct dvb_usb_device *d)
> >  {
> >  	int ret;
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	dvb_usbv2_device_power_ctrl(d, 1);
> > =20
> > @@ -894,7 +893,7 @@ static int dvb_usbv2_init(struct dvb_usb_device *d)
> >  	return 0;
> >  err:
> >  	dvb_usbv2_device_power_ctrl(d, 0);
> > -	dev_dbg(&d->udev->dev, "%s: failed=3D%d\n", __func__, ret);
> > +	dev_dbg(&d->udev->dev, "failed=3D%d\n", ret);
> >  	return ret;
> >  }
> > =20
> > @@ -907,7 +906,7 @@ int dvb_usbv2_probe(struct usb_interface *intf,
> >  	struct dvb_usb_driver_info *driver_info =3D
> >  			(struct dvb_usb_driver_info *) id->driver_info;
> > =20
> > -	dev_dbg(&udev->dev, "%s: bInterfaceNumber=3D%d\n", __func__,
> > +	dev_dbg(&udev->dev, "bInterfaceNumber=3D%d\n",
> >  			intf->cur_altsetting->desc.bInterfaceNumber);
> > =20
> >  	if (!id->driver_info) {
> > @@ -1010,7 +1009,7 @@ int dvb_usbv2_probe(struct usb_interface *intf,
> >  err_kfree_d:
> >  	kfree(d);
> >  err:
> > -	dev_dbg(&udev->dev, "%s: failed=3D%d\n", __func__, ret);
> > +	dev_dbg(&udev->dev, "failed=3D%d\n", ret);
> >  	return ret;
> >  }
> >  EXPORT_SYMBOL(dvb_usbv2_probe);
> > @@ -1021,7 +1020,7 @@ void dvb_usbv2_disconnect(struct usb_interface *i=
ntf)
> >  	const char *devname =3D kstrdup(dev_name(&d->udev->dev), GFP_KERNEL);
> >  	const char *drvname =3D d->name;
> > =20
> > -	dev_dbg(&d->udev->dev, "%s: bInterfaceNumber=3D%d\n", __func__,
> > +	dev_dbg(&d->udev->dev, "bInterfaceNumber=3D%d\n",
> >  			intf->cur_altsetting->desc.bInterfaceNumber);
> > =20
> >  	if (d->props->exit)
> > @@ -1046,7 +1045,7 @@ int dvb_usbv2_suspend(struct usb_interface *intf,=
 pm_message_t msg)
> >  	struct dvb_usb_device *d =3D usb_get_intfdata(intf);
> >  	int ret =3D 0, i, active_fe;
> >  	struct dvb_frontend *fe;
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	/* stop remote controller poll */
> >  	if (d->rc_polling_active)
> > @@ -1076,7 +1075,7 @@ static int dvb_usbv2_resume_common(struct dvb_usb=
_device *d)
> >  {
> >  	int ret =3D 0, i, active_fe;
> >  	struct dvb_frontend *fe;
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	for (i =3D 0; i < MAX_NO_OF_ADAPTER_PER_DEVICE; i++) {
> >  		active_fe =3D d->adapter[i].active_fe;
> > @@ -1106,7 +1105,7 @@ static int dvb_usbv2_resume_common(struct dvb_usb=
_device *d)
> >  int dvb_usbv2_resume(struct usb_interface *intf)
> >  {
> >  	struct dvb_usb_device *d =3D usb_get_intfdata(intf);
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	return dvb_usbv2_resume_common(d);
> >  }
> > @@ -1116,7 +1115,7 @@ int dvb_usbv2_reset_resume(struct usb_interface *=
intf)
> >  {
> >  	struct dvb_usb_device *d =3D usb_get_intfdata(intf);
> >  	int ret;
> > -	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> > +	dev_dbg(&d->udev->dev, "\n");
> > =20
> >  	dvb_usbv2_device_power_ctrl(d, 1);
> > =20
> > diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media=
/usb/dvb-usb-v2/dvb_usb_urb.c
> > index 5bafeb6486be..f24513159470 100644
> > --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
> > +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
> > @@ -28,11 +28,11 @@ static int dvb_usb_v2_generic_io(struct dvb_usb_dev=
ice *d,
> > =20
> >  	if (!wbuf || !wlen || !d->props->generic_bulk_ctrl_endpoint ||
> >  			!d->props->generic_bulk_ctrl_endpoint_response) {
> > -		dev_dbg(&d->udev->dev, "%s: failed=3D%d\n", __func__, -EINVAL);
> > +		dev_dbg(&d->udev->dev, "failed=3D%d\n", -EINVAL);
> >  		return -EINVAL;
> >  	}
> > =20
> > -	dev_dbg(&d->udev->dev, "%s: >>> %*ph\n", __func__, wlen, wbuf);
> > +	dev_dbg(&d->udev->dev, ">>> %*ph\n", wlen, wbuf);
> > =20
> >  	ret =3D usb_bulk_msg(d->udev, usb_sndbulkpipe(d->udev,
> >  			d->props->generic_bulk_ctrl_endpoint), wbuf, wlen,
> > @@ -58,8 +58,7 @@ static int dvb_usb_v2_generic_io(struct dvb_usb_devic=
e *d,
> >  					"%s: 2nd usb_bulk_msg() failed=3D%d\n",
> >  					KBUILD_MODNAME, ret);
> > =20
> > -		dev_dbg(&d->udev->dev, "%s: <<< %*ph\n", __func__,
> > -				actual_length, rbuf);
> > +		dev_dbg(&d->udev->dev, "<<< %*ph\n", actual_length, rbuf);
> >  	}
> > =20
> >  	return ret;
> > --=20
> > 2.17.2

--svp5s54hirmux5a7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEIG07NS9WbzsOZXLpl9kSPeN6SE8FAlwGTzIACgkQl9kSPeN6
SE/FLRAAi6c6s5PJ39ye4tm2xUkYBxL7TYOs0po5WzjqiY09/4eqTpGpml+COmCi
e0JBxCtNFFfoO8Sw+GEFoV6JA2dJIzShrYOjU69Qmm68PKXZ6mVxO7vuY57K4wdd
ws7dhud6Nk4tV003k4PBatqt5Q/eo/IH4j96qdrHLW1TyG8IZVJktI5AYMcHxBOJ
LNj0XPcAewZgwypKAAcqg/v9uaGhL0Lzo+4UgcpPF7npLIHTXLzkDz24m9ZeB4py
k1dv6TdS6FNKYdPL1gIFicXWgPeX+hkn9Pf4/Z+7HD25amGtELobZFo8HMv/wD4f
jTES8V0yrd16hxSGlr7JO0GJhAQrT/g0nMTt55gX/zV2oOaIlx7Wf7acSKNCTMsZ
AFKjgrtGb9Sgu3ARiqeB6JqrMENbMqgDg1K0Mnt3lksbm3WbOjBHO5nk6dD3zpZV
f+7omqFiXU0ksOzYk+RYORT8y7wjL+P8KkOMqHItbzDLQKfdfxc0K3Ge2TickpD5
GVxoFcqVwwcAoo7uXhmad7LIzRXQifR36K/7DcJUjF9KGv2BFj7HYnl2R+oDBA2j
X5gPU91Y1YpH+Mzy2ziBdNrzpEWlaoJEaKT78jYG2GTweGpV1Q0y4bgYBiAEyXqi
LV35BsmQl8QLCcWgrfd5iXifiLGd4wBiazAK3v6zF0LZEAKp32I=
=YylU
-----END PGP SIGNATURE-----

--svp5s54hirmux5a7--
