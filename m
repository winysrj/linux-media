Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Tue, 26 Aug 2008 19:17:38 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Oliver Neukum <oliver@neukum.org>
In-Reply-To: <200808261705.58118.oliver@neukum.org>
Message-ID: <alpine.LRH.1.10.0808261900100.18085@pub6.ifh.de>
References: <200808261705.58118.oliver@neukum.org>
MIME-Version: 1.0
Cc: v4l-dvb-maintainer@linuxtv.org, linux-usb <linux-usb@vger.kernel.org>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch]dma on stack in dib0700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This seems to be a big issue then: of course not only this driver 
(dib0700) is affected by that, but also other modules inside the 
dvb-usb-framework (and maybe other I don't even know).

Is there is something generic to be done to avoid this problem rather than 
putting a malloc in each micro-function? What I could think of is 
allocating the buffers "one-time" and re-use them or to allocate them at 
a lower level so that it is not visible and annoying for the developer.

Patrick.


On Tue, 26 Aug 2008, Oliver Neukum wrote:

> USB on some architectures cannot do DMA with buffers on the stack.
> Therefore the dib0700 driver will fail on some architectures. The fix is
> allocating buffers on the stack.
>
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
>
> 	Regards
> 		Oliver
>
> ---
>
> --- linux-2.6.27-rc4/drivers/media/dvb/dvb-usb/dib0700_core.c.alt	2008-08-26 15:31:31.000000000 +0200
> +++ linux-2.6.27-rc4/drivers/media/dvb/dvb-usb/dib0700_core.c	2008-08-26 15:46:32.000000000 +0200
> @@ -77,8 +77,19 @@ int dib0700_ctrl_rd(struct dvb_usb_devic
>
> int dib0700_set_gpio(struct dvb_usb_device *d, enum dib07x0_gpios gpio, u8 gpio_dir, u8 gpio_val)
> {
> -	u8 buf[3] = { REQUEST_SET_GPIO, gpio, ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6) };
> -	return dib0700_ctrl_wr(d,buf,3);
> +	u8 *buf;
> +	int rv;
> +
> +	buf = kmalloc(3, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +	buf[0] = REQUEST_SET_GPIO;
> +	buf[1] = gpio;
> +	buf[2] = ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6);
> +
> +	rv = dib0700_ctrl_wr(d,buf,3);
> +	kfree(buf);
> +	return rv;
> }
>
> /*
> @@ -88,10 +99,15 @@ static int dib0700_i2c_xfer(struct i2c_a
> {
> 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
> 	int i,len;
> -	u8 buf[255];
> +	u8 *buf;
>
> -	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
> +	buf = kmalloc(255, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +	if (mutex_lock_interruptible(&d->i2c_mutex) < 0) {
> +		kfree(buf);
> 		return -EAGAIN;
> +	}
>
> 	for (i = 0; i < num; i++) {
> 		/* fill in the address */
> @@ -121,6 +137,7 @@ static int dib0700_i2c_xfer(struct i2c_a
> 	}
>
> 	mutex_unlock(&d->i2c_mutex);
> +	kfree(buf);
> 	return i;
> }
>
> @@ -137,9 +154,18 @@ struct i2c_algorithm dib0700_i2c_algo =
> int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
> 			struct dvb_usb_device_description **desc, int *cold)
> {
> -	u8 b[16];
> -	s16 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev,0),
> +	u8 *b;
> +	s16 ret;
> +
> +	b = kmalloc(16, GFP_KERNEL);
> +
> +	if (b) {
> +		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev,0),
> 		REQUEST_GET_VERSION, USB_TYPE_VENDOR | USB_DIR_IN, 0, 0, b, 16, USB_CTRL_GET_TIMEOUT);
> +		kfree(b);
> +	} else {
> +		ret = 0;
> +	}
>
> 	deb_info("FW GET_VERSION length: %d\n",ret);
>
> @@ -153,7 +179,12 @@ static int dib0700_set_clock(struct dvb_
> 	u8 pll_src, u8 pll_range, u8 clock_gpio3, u16 pll_prediv,
> 	u16 pll_loopdiv, u16 free_div, u16 dsuScaler)
> {
> -	u8 b[10];
> +	u8 *b;
> +	int rv;
> +
> +	b = kmalloc(10, GFP_KERNEL);
> +	if (!b)
> +		return -ENOMEM;
> 	b[0] = REQUEST_SET_CLOCK;
> 	b[1] = (en_pll << 7) | (pll_src << 6) | (pll_range << 5) | (clock_gpio3 << 4);
> 	b[2] = (pll_prediv >> 8)  & 0xff; // MSB
> @@ -165,7 +196,9 @@ static int dib0700_set_clock(struct dvb_
> 	b[8] = (dsuScaler >> 8)   & 0xff; // MSB
> 	b[9] =  dsuScaler         & 0xff; // LSB
>
> -	return dib0700_ctrl_wr(d, b, 10);
> +	rv = dib0700_ctrl_wr(d, b, 10);
> +	kfree(b);
> +	return rv;
> }
>
> int dib0700_ctrl_clock(struct dvb_usb_device *d, u32 clk_MHz, u8 clock_out_gp3)
> @@ -179,30 +212,40 @@ int dib0700_ctrl_clock(struct dvb_usb_de
>
> static int dib0700_jumpram(struct usb_device *udev, u32 address)
> {
> -	int ret, actlen;
> -	u8 buf[8] = { REQUEST_JUMPRAM, 0, 0, 0,
> -		(address >> 24) & 0xff,
> -		(address >> 16) & 0xff,
> -		(address >> 8)  & 0xff,
> -		 address        & 0xff };
> +	int ret = 0, actlen;
> +	u8 *buf;
> +
> +	buf = kzalloc(8, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	buf[0] = REQUEST_JUMPRAM;
> +	*(u32 *)(buf + 4) = cpu_to_be32(address);
>
> 	if ((ret = usb_bulk_msg(udev, usb_sndbulkpipe(udev, 0x01),buf,8,&actlen,1000)) < 0) {
> 		deb_fw("jumpram to 0x%x failed\n",address);
> -		return ret;
> +		goto out;
> 	}
> 	if (actlen != 8) {
> 		deb_fw("jumpram to 0x%x failed\n",address);
> -		return -EIO;
> +		ret = -EIO;
> +		goto out;
> 	}
> -	return 0;
> +
> +out:
> +	kfree(buf);
> +	return ret;
> }
>
> int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw)
> {
> 	struct hexline hx;
> 	int pos = 0, ret, act_len;
> +	u8 *buf;
>
> -	u8 buf[260];
> +	buf = kmalloc(260, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
>
> 	while ((ret = dvb_usb_get_hexline(fw, &hx, &pos)) > 0) {
> 		deb_fwdata("writing to address 0x%08x (buffer: 0x%02x %02x)\n",hx.addr, hx.len, hx.chk);
> @@ -222,6 +265,7 @@ int dib0700_download_firmware(struct usb
> 			1000);
>
> 		if (ret < 0) {
> +			kfree(buf);
> 			err("firmware download failed at %d with %d",pos,ret);
> 			return ret;
> 		}
> @@ -236,14 +280,19 @@ int dib0700_download_firmware(struct usb
> 	} else
> 		ret = -EIO;
>
> +	kfree(buf);
> 	return ret;
> }
>
> int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
> {
> 	struct dib0700_state *st = adap->dev->priv;
> -	u8 b[4];
> +	u8 *b;
> +	int rv;
>
> +	b = kmalloc(4, GFP_KERNEL);
> +	if (!b)
> +		return -ENOMEM;
> 	b[0] = REQUEST_ENABLE_VIDEO;
> 	b[1] = (onoff << 4) | 0x00; /* this bit gives a kind of command, rather than enabling something or not */
> 	b[2] = (0x01 << 4); /* Master mode */
> @@ -260,18 +309,29 @@ int dib0700_streaming_ctrl(struct dvb_us
>
> 	deb_info("data for streaming: %x %x\n",b[1],b[2]);
>
> -	return dib0700_ctrl_wr(adap->dev, b, 4);
> +	rv = dib0700_ctrl_wr(adap->dev, b, 4);
> +	kfree(b);
> +	return rv;
> }
>
> int dib0700_rc_setup(struct dvb_usb_device *d)
> {
> -	u8 rc_setup[3] = {REQUEST_SET_RC, dvb_usb_dib0700_ir_proto, 0};
> -	int i = dib0700_ctrl_wr(d, rc_setup, 3);
> -	if (i<0) {
> -		err("ir protocol setup failed");
> +	u8 *rc_setup;
> +	int i;
> +
> +	rc_setup = kmalloc(3, GFP_KERNEL);
> +	if (!rc_setup)
> 		return -1;
> -	}
> -	return 0;
> +	rc_setup[0] = REQUEST_SET_RC;
> +	rc_setup[1] = dvb_usb_dib0700_ir_proto;
> +	rc_setup[2] = 0;
> +
> +	i = dib0700_ctrl_wr(d, rc_setup, 3);
> +	kfree(rc_setup);
> +	if (i<0)
> +		err("ir protocol setup failed");
> +
> +	return i >= 0 ? 0 : -1;
> }
>
> static int dib0700_probe(struct usb_interface *intf,
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
