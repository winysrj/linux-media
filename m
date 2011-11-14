Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55249 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab1KNWZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 17:25:41 -0500
Received: by wyh15 with SMTP id 15so6423195wyh.19
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 14:25:40 -0800 (PST)
Message-ID: <4ec1955e.e813b40a.37be.3fce@mx.google.com>
Subject: Re: [PATCH FOR 3.2 FIX] af9015: limit I2C access to keep FW happy
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Mon, 14 Nov 2011 22:25:29 +0000
In-Reply-To: <4EC01857.5050000@iki.fi>
References: <4EC014E5.5090303@iki.fi> <4EC01857.5050000@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2011-11-13 at 21:19 +0200, Antti Palosaari wrote:
> Mauro,
> Don't still but that to the 3.2 as fix. It is not much tested and not 
> critical so better put it master for some more testing.
> 
> regards
> Antti
> 
> On 11/13/2011 09:05 PM, Antti Palosaari wrote:
> > AF9015 firmware does not like if it gets interrupted by I2C adapter
> > request on some critical phases. During normal operation I2C adapter
> > is used only 2nd demodulator and tuner on dual tuner devices.
> >
> > Override demodulator callbacks and use mutex for limit access to
> > those "critical" paths to keep AF9015 happy.
> >
> > Signed-off-by: Antti Palosaari<crope@iki.fi>
> > ---
> >   drivers/media/dvb/dvb-usb/af9015.c |   97 ++++++++++++++++++++++++++++++++++++
> >   drivers/media/dvb/dvb-usb/af9015.h |    7 +++
> >   2 files changed, 104 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> > index c6c275b..033aa8a 100644
> > --- a/drivers/media/dvb/dvb-usb/af9015.c
> > +++ b/drivers/media/dvb/dvb-usb/af9015.c
> > @@ -1093,9 +1093,80 @@ error:
> >   	return ret;
> >   }
> >
> > +/* override demod callbacks for resource locking */
> > +static int af9015_af9013_set_frontend(struct dvb_frontend *fe,
> > +	struct dvb_frontend_parameters *params)
> > +{
> > +	int ret;
> > +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> > +	struct af9015_state *priv = adap->dev->priv;
> > +
> > +	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
> > +		return -EAGAIN;
> > +
> > +	ret = priv->set_frontend[adap->id](fe, params);
> > +
> > +	mutex_unlock(&adap->dev->usb_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +/* override demod callbacks for resource locking */
> > +static int af9015_af9013_read_status(struct dvb_frontend *fe,
> > +	fe_status_t *status)
> > +{
> > +	int ret;
> > +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> > +	struct af9015_state *priv = adap->dev->priv;
> > +
> > +	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
> > +		return -EAGAIN;
> > +
> > +	ret = priv->read_status[adap->id](fe, status);
> > +
> > +	mutex_unlock(&adap->dev->usb_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +/* override demod callbacks for resource locking */
> > +static int af9015_af9013_init(struct dvb_frontend *fe)
> > +{
> > +	int ret;
> > +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> > +	struct af9015_state *priv = adap->dev->priv;
> > +
> > +	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
> > +		return -EAGAIN;
> > +
> > +	ret = priv->init[adap->id](fe);
> > +
> > +	mutex_unlock(&adap->dev->usb_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +/* override demod callbacks for resource locking */
> > +static int af9015_af9013_sleep(struct dvb_frontend *fe)
> > +{
> > +	int ret;
> > +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> > +	struct af9015_state *priv = adap->dev->priv;
> > +
> > +	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
> > +		return -EAGAIN;
> > +
> > +	ret = priv->init[adap->id](fe);
> > +
> > +	mutex_unlock(&adap->dev->usb_mutex);
> > +
> > +	return ret;
> > +}
> > +
> >   static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
> >   {
> >   	int ret;
> > +	struct af9015_state *state = adap->dev->priv;
> >
> >   	if (adap->id == 1) {
> >   		/* copy firmware to 2nd demodulator */
> > @@ -1116,6 +1187,32 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
> >   	adap->fe_adap[0].fe = dvb_attach(af9013_attach,&af9015_af9013_config[adap->id],
> >   		&adap->dev->i2c_adap);
> >
> > +	/*
> > +	 * AF9015 firmware does not like if it gets interrupted by I2C adapter
> > +	 * request on some critical phases. During normal operation I2C adapter
> > +	 * is used only 2nd demodulator and tuner on dual tuner devices.
> > +	 * Override demodulator callbacks and use mutex for limit access to
> > +	 * those "critical" paths to keep AF9015 happy.
> > +	 * Note: we abuse unused usb_mutex here.
> > +	 */
> > +	if (adap->fe_adap[0].fe) {
> > +		state->set_frontend[adap->id] =
> > +			adap->fe_adap[0].fe->ops.set_frontend;
> > +		adap->fe_adap[0].fe->ops.set_frontend =
> > +			af9015_af9013_set_frontend;
> > +
> > +		state->read_status[adap->id] =
> > +			adap->fe_adap[0].fe->ops.read_status;
> > +		adap->fe_adap[0].fe->ops.read_status =
> > +			af9015_af9013_read_status;
> > +
> > +		state->init[adap->id] = adap->fe_adap[0].fe->ops.init;
> > +		adap->fe_adap[0].fe->ops.init = af9015_af9013_init;
> > +
> > +		state->sleep[adap->id] = adap->fe_adap[0].fe->ops.sleep;
> > +		adap->fe_adap[0].fe->ops.sleep = af9015_af9013_sleep;
> > +	}
> > +
> >   	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
> >   }
> >

I have tried this patch, while it initially got MythTV working, there is
too many call backs and some failed to acquire the lock. The device
became unstable on both single and dual devices. 

The callbacks

af9015_af9013_read_status, 
af9015_af9013_init
af9015_af9013_sleep

had to be removed.

I take your point, a call back can be an alternative.

The patch didn't stop the firmware fails either.

The af9015 usb bridge on the whole is so unstable in its early stages,
especially on a cold boot and when the USB controller has another device
on it, such as card reader or wifi device.

I am, at the moment looking to see if the fails are due to interface 1
being claimed by HID.

Regards

Malcolm

