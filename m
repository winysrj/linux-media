Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60248 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbeEMTZc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 15:25:32 -0400
Date: Sun, 13 May 2018 16:25:27 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com, crope@iki.fi
Subject: Re: [PATCH v6 3/5] dvb-usb/friio, dvb-usb-v2/gl861: decompose friio
 and merge with gl861
Message-ID: <20180513162527.46590f36@vento.lan>
In-Reply-To: <75102816-67d1-56d2-6bd7-46d4fe9ce437@gmail.com>
References: <20180408172138.9974-1-tskd08@gmail.com>
        <20180408172138.9974-4-tskd08@gmail.com>
        <20180505081217.280864d9@vento.lan>
        <75102816-67d1-56d2-6bd7-46d4fe9ce437@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 May 2018 03:13:44 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> Hi,
> thanks for the review.
> 
> >> +gl861_i2c_rawwrite(struct dvb_usb_device *d, u8 addr, u8 *wbuf, u16 wlen)>> +{>> +	u8 *buf;>> +	int ret;>> +>> +	buf = kmalloc(wlen, GFP_KERNEL);>> +	if (!buf)>> +		return -ENOMEM;>> +>> +	usleep_range(1000, 2000); /* avoid I2C errors */> > I guess this is probably also at the original code, but it seems really> weird to sleep here just after kmalloc().> > I would move any need for sleeps to the i2c xfer function, where it> makes clearer why it is needed and where. Same applies to other> usleep_range() calls at the functions below.  
> those sleeps are for placing time gap between consecutive i2c transactions,
> but I agree that they should be moved to the i2c_xfer loop.
> I'll fix them in the next version.

Ok, thanks!

> 
> >> +/*
> >> + * In Friio,
> >> + * I2C commnucations to the tuner are relay'ed via the demod (via the bridge),
> >> + * so its encapsulation to USB message is different from the one to the demod.  
> > 
> > This is quite common. I guess the rationale of using the demod's I2C mux
> > is to avoid noise at the tuner when there are I2C traffic that aren't related
> > to it.
> > 
> > You should probably implement it via I2C_MUX support.  
> 
> I know that the i2c bus structure is common,
> but as I wrote to Antti before,
> i2c transactions to the tuner use the different USB transactions with
> different 'request' value from the one used in the other demod transactions.
> 
> Here is the packet log example (I posted to linux-media before):
> "Re: [PATCH v4] dvb-usb/friio, dvb-usb-v2/gl861: decompose friio and merge with gl861"
> Message ID: <f047a680-436b-bf40-ae0a-68279366b668@gmail.com>
> Sent on: Sun, 1 Apr 2018 00:30:49 +0900
> 
> I still do not understand how this can be implemented with I2C_MUX,
> or in the demod/tuner drivers.
> i2c to the tuner does not need gating/arbitration/locking,
> only needs to access via the demod reg,
> which is already implemented in the adapter by the demod,
> but it must be sent in the distinct USB transaction with its own 'request' value.

So what? Take a look, for example, at em28xx implementation:
	drivers/media/usb/em28xx/em28xx-i2c.c

It has different functions for bus A (with is common on all em28xx
chipsets) and for bus B (with is present only on newer chips).

If you see at I2C xfer implementation, you'll see that the logic
there handles the bus:

static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
			   struct i2c_msg msgs[], int num)
{
...
	/* Switch I2C bus if needed */
	if (bus != dev->cur_i2c_bus &&
	    i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX) {
		if (bus == 1)
			reg = EM2874_I2C_SECONDARY_BUS_SELECT;
		else
			reg = 0;
		em28xx_write_reg_bits(dev, EM28XX_R06_I2C_CLK, reg,
				      EM2874_I2C_SECONDARY_BUS_SELECT);
		dev->cur_i2c_bus = bus;
	}
...

		} else if (msgs[i].flags & I2C_M_RD) {
			/* read bytes */
			rc = i2c_recv_bytes(i2c_bus, msgs[i]);

There, not only the I2C bus need to be known by the routines,
but also switching from one bus to the other requires a register
write, depending on the device type (as can be seen when the I2C
buses are reigstered, at em28xx_cards.c:

	/* register i2c bus 0 */
	if (dev->board.is_em2800)
		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM2800);
	else
		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM28XX);
	if (retval < 0) {
		dev_err(&dev->intf->dev,
			"%s: em28xx_i2c_register bus 0 - error [%d]!\n",
		       __func__, retval);
		return retval;
	}

	/* register i2c bus 1 */
	if (dev->def_i2c_bus) {
		if (dev->is_em25xx)
			retval = em28xx_i2c_register(dev, 1,
						     EM28XX_I2C_ALGO_EM25XX_BUS_B);
		else
			retval = em28xx_i2c_register(dev, 1,
						     EM28XX_I2C_ALGO_EM28XX);
		if (retval < 0) {
			dev_err(&dev->intf->dev,
				"%s: em28xx_i2c_register bus 1 - error [%d]!\n",
				__func__, retval);

			em28xx_i2c_unregister(dev, 0);

			return retval;
		}
	}

> 
> >> +/* init/config of Friio demod chip(?) */
> >> +static int friio_reset(struct dvb_usb_device *d)
> >> +{
> >> +	int i, ret;
> >> +	u8 wbuf[2], rbuf[2];
> >> +
> >> +	static const u8 friio_init_cmds[][2] = {
> >> +		{0x33, 0x08}, {0x37, 0x40}, {0x3a, 0x1f}, {0x3b, 0xff},
> >> +		{0x3c, 0x1f}, {0x3d, 0xff}, {0x38, 0x00}, {0x35, 0x00},
> >> +		{0x39, 0x00}, {0x36, 0x00},
> >> +	};
> >> +
> >> +	ret = usb_set_interface(d->udev, 0, 0);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	wbuf[0] = 0x11;
> >> +	wbuf[1] = 0x02;
> >> +	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +	usleep_range(2000, 3000);
> >> +
> >> +	wbuf[0] = 0x11;
> >> +	wbuf[1] = 0x00;
> >> +	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +	usleep_range(1000, 2000);  
> > 
> > Hmm... you had already usleeps() all over I2C xfer routines. Why adding
> > extra sleeps here?  
> 
> Those sleeps were added to (roughly) simulate the timing
> seen in the packet capture logs on a Windows box.
> They certainly include the time for application processing,
> but may include the necessary wait time after each command/i2c-transaction,
> so they are kept for safety.

Yes, but you have sleeps there and also at the I2C register setting
routines. Having both seems weird.

> 
> > Also, why isn't it calling i2c_transfer() instead of gl861_i2c_msg()?
> > Same applies to other similar calls.  
> 
> Because friio_reset can be called in the following trace:
> friio_reset
> friio_power_ctrl
> d->props->power_ctrl
> dvb_usbv2_device_power_ctrl
> dvb_usbv2_init
> 
> and in dvb_usbv2_init, dvb_usbv2_device_power_ctrl is called
> BEFORE i2c adapter initialization (dvb_usbv2_i2c_init).

Ah, I see. Please document it then.

> 
> >> +static int friio_tuner_detach(struct dvb_usb_adapter *adap)
> >> +{
> >> +	struct friio_priv *priv;
> >> +
> >> +	priv = adap_to_priv(adap);
> >> +#ifndef CONFIG_MEDIA_ATTACH
> >> +	/* Note:
> >> +	 * When CONFIG_MEDIA_ATTACH is defined,
> >> +	 * the tuner module is already "put" by the following call trace:
> >> +	 *
> >> +	 * symbol_put_addr(fe->ops.tuner_ops.release)
> >> +	 * dvb_frontend_invoke_release(fe, fe->ops.tuner_ops.release)
> >> +	 * dvb_frontend_detach(fe)
> >> +	 * dvb_usbv2_adapter_frontend_exit(adap)
> >> +	 * dvb_usbv2_adapter_exit(d)
> >> +	 * dvb_usbv2_exit(d)
> >> +	 * dvb_usbv2_disconnect(intf)
> >> +	 *
> >> +	 * Since the tuner driver of Friio (dvb-pll) has .release defined,
> >> +	 * dvb_module_release() should be skipped if CONFIG_MEDIA_ATTACH,
> >> +	 * to avoid double-putting the module.
> >> +	 * Even without dvb_module_release(),
> >> +	 * the tuner i2c device is automatically unregistered
> >> +	 * when its i2c adapter is unregistered with the demod i2c device.
> >> +	 *
> >> +	 * The same "double-putting" can happen to the demod module as well,
> >> +	 * but tc90522 does not define any _invoke_release()'ed functions,
> >> +	 * thus Friio is not affected.
> >> +	 */
> >> +	dvb_module_release(priv->i2c_client_tuner);
> >> +#endif  
> > 
> > This looks really weird to me... why only at this driver we need this?
> > If we have some issues at the DVB core - or at dvb-usb-v2, the fix should
> > be there, and not here.  
> 
> dvb-usb-v2 handles attach/detach of frontend/tuner driver modules
> on behalf of each bridge driver.
> 
> While sub drivers are attached via d->props->{frontend, tuner}_attach,
> they are implicitly 'dvb_detach'ed in dvb_frontend_detach() on disconnect,
> not detached explicitly in d->props->{frontend, tuner}_detach().
> But i2c drivers need to be 'dvb_module_release'ed in those *_detach(),
> so any i2c drivers that define any 'implicitly detached' ops function
> would be affected by this double-put problem.
> (I suspect that even legacy dvb_attached drivers are also affected
> if they define both ops{.detach, .release, ...} functions,
> but there seems to be no such drivers currently.)
> 
> Fix in dvb-core/dvb-usb-v2 would be too complicated
> for this (transient?) problem, since it will get unnecessary
> once all dvb_attach's are replaced and removed.
> 
> so I am going to fix it in the tuner driver (dvb_pll) instead,
> like af9013 or ts2020 drivers,
> by clearing tuner_ops.release and moving its code to i2c .remove().

Ok.

> 
> regards,
> Akihiro



Thanks,
Mauro
