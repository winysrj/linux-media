Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0ELUjF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 16:39:05 -0400
Message-ID: <4BEB11E5.8090504@infradead.org>
Date: Wed, 12 May 2010 17:39:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] checkstack fixes for drivers/media/dvb
References: <20100512185311.20801.86954.sendpatchset@prarit.bos.redhat.com>
In-Reply-To: <20100512185311.20801.86954.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prarit Bhargava wrote:
> When compiling 2.6.34-rc7 I see the following warnings
> 
> drivers/media/dvb/frontends/dib3000mc.c: In function 'dib3000mc_i2c_enumeration':
> drivers/media/dvb/frontends/dib3000mc.c:853: warning: the frame size of 2224 bytes is larger than 2048 bytes
> drivers/media/dvb/frontends/dib7000p.c: In function 'dib7000p_i2c_enumeration':
> drivers/media/dvb/frontends/dib7000p.c:1346: warning: the frame size of 2304 bytes is larger than 2048 bytes
> 
> because the dib*_state structs are large and they are alloc'd on the stack.
> 
> This patch moves the structures off the stack.

Hi Prarit,

Thanks for the patch, but I've received two patches to fix the same thing some time ago.
Unfortunately, it took a long time to be merged, since I was waiting for the driver
maintainer's ack. It is at those changesets:

http://git.linuxtv.org/v4l-dvb.git?a=commit;h=65483f7e5f3e169ea038de26068395231dd3b13b
http://git.linuxtv.org/v4l-dvb.git?a=commit;h=370c0cb185d4fccfb2c66fbe94b48579d4c5fa1c

> 
> I also noticed that the cxusb driver doesn't check the return value from
> dib7000p_i2c_enumeration().

Randy's patch also added a test for it, but without the warning printk. It may be a good
idea to have that warning. So, please be free to send it as a separate patch if you also
think so.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
> index 960376d..8141b10 100644
> --- a/drivers/media/dvb/dvb-usb/cxusb.c
> +++ b/drivers/media/dvb/dvb-usb/cxusb.c
> @@ -1025,8 +1025,11 @@ static int cxusb_dualdig4_rev2_frontend_attach(struct dvb_usb_adapter *adap)
>  
>  	cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
>  
> -	dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
> -				 &cxusb_dualdig4_rev2_config);
> +	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
> +				     &cxusb_dualdig4_rev2_config)) {
> +		printk(KERN_WARNING "Unable to enumerate dib7000p\n");
> +		return -ENODEV;
> +	}
>  
>  	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
>  			      &cxusb_dualdig4_rev2_config);
> diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
> index 40a0998..6a178f1 100644
> --- a/drivers/media/dvb/frontends/dib3000mc.c
> +++ b/drivers/media/dvb/frontends/dib3000mc.c
> @@ -814,42 +814,52 @@ EXPORT_SYMBOL(dib3000mc_set_config);
>  
>  int dib3000mc_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib3000mc_config cfg[])
>  {
> -	struct dib3000mc_state st = { .i2c_adap = i2c };
> +	struct dib3000mc_state *st;
>  	int k;
>  	u8 new_addr;
> -
>  	static u8 DIB3000MC_I2C_ADDRESS[] = {20,22,24,26};
>  
> +	st = kzalloc(sizeof(*st), GFP_KERNEL);
> +	if (!st)
> +		return -ENOMEM;
> +	st->i2c_adap = i2c;
> +
>  	for (k = no_of_demods-1; k >= 0; k--) {
> -		st.cfg = &cfg[k];
> +		st->cfg = &cfg[k];
>  
>  		/* designated i2c address */
> -		new_addr          = DIB3000MC_I2C_ADDRESS[k];
> -		st.i2c_addr = new_addr;
> -		if (dib3000mc_identify(&st) != 0) {
> -			st.i2c_addr = default_addr;
> -			if (dib3000mc_identify(&st) != 0) {
> -				dprintk("-E-  DiB3000P/MC #%d: not identified\n", k);
> +		new_addr = DIB3000MC_I2C_ADDRESS[k];
> +		st->i2c_addr = new_addr;
> +		if (dib3000mc_identify(st) != 0) {
> +			st->i2c_addr = default_addr;
> +			if (dib3000mc_identify(st) != 0) {
> +				dprintk("-E-  DiB3000P/MC #%d: not"
> +					" identified\n", k);
> +				kfree(st);
>  				return -ENODEV;
>  			}
>  		}
>  
> -		dib3000mc_set_output_mode(&st, OUTMODE_MPEG2_PAR_CONT_CLK);
> +		dib3000mc_set_output_mode(st, OUTMODE_MPEG2_PAR_CONT_CLK);
>  
> -		// set new i2c address and force divstr (Bit 1) to value 0 (Bit 0)
> -		dib3000mc_write_word(&st, 1024, (new_addr << 3) | 0x1);
> -		st.i2c_addr = new_addr;
> +		/* set new i2c address and force divstr (Bit 1) to
> +		 * value 0 (Bit 0)
> +		 */
> +		dib3000mc_write_word(st, 1024, (new_addr << 3) | 0x1);
> +		st->i2c_addr = new_addr;
>  	}
>  
>  	for (k = 0; k < no_of_demods; k++) {
> -		st.cfg = &cfg[k];
> -		st.i2c_addr = DIB3000MC_I2C_ADDRESS[k];
> +		st->cfg = &cfg[k];
> +		st->i2c_addr = DIB3000MC_I2C_ADDRESS[k];
>  
> -		dib3000mc_write_word(&st, 1024, st.i2c_addr << 3);
> +		dib3000mc_write_word(st, 1024, st->i2c_addr << 3);
>  
>  		/* turn off data output */
> -		dib3000mc_set_output_mode(&st, OUTMODE_HIGH_Z);
> +		dib3000mc_set_output_mode(st, OUTMODE_HIGH_Z);
>  	}
> +
> +	kfree(st);
>  	return 0;
>  }
>  EXPORT_SYMBOL(dib3000mc_i2c_enumeration);
> diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
> index 85468a4..08ea982 100644
> --- a/drivers/media/dvb/frontends/dib7000p.c
> +++ b/drivers/media/dvb/frontends/dib7000p.c
> @@ -1322,48 +1322,59 @@ int dib7000p_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
>  }
>  EXPORT_SYMBOL(dib7000p_pid_filter);
>  
> -int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[])
> +int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods,
> +			     u8 default_addr, struct dib7000p_config cfg[])
>  {
> -	struct dib7000p_state st = { .i2c_adap = i2c };
> +	struct dib7000p_state *st;
>  	int k = 0;
>  	u8 new_addr = 0;
>  
> +	st = kmalloc(sizeof(*st), GFP_KERNEL);
> +	if (!st)
> +		return -ENOMEM;
> +	st->i2c_adap = i2c;
> +
>  	for (k = no_of_demods-1; k >= 0; k--) {
> -		st.cfg = cfg[k];
> +		st->cfg = cfg[k];
>  
>  		/* designated i2c address */
> -		new_addr          = (0x40 + k) << 1;
> -		st.i2c_addr = new_addr;
> -		dib7000p_write_word(&st, 1287, 0x0003); /* sram lead in, rdy */
> -		if (dib7000p_identify(&st) != 0) {
> -			st.i2c_addr = default_addr;
> -			dib7000p_write_word(&st, 1287, 0x0003); /* sram lead in, rdy */
> -			if (dib7000p_identify(&st) != 0) {
> +		new_addr = (0x40 + k) << 1;
> +		st->i2c_addr = new_addr;
> +		dib7000p_write_word(st, 1287, 0x0003); /* sram lead in, rdy */
> +		if (dib7000p_identify(st) != 0) {
> +			st->i2c_addr = default_addr;
> +			/* sram lead in, rdy */
> +			dib7000p_write_word(st, 1287, 0x0003);
> +			if (dib7000p_identify(st) != 0) {
>  				dprintk("DiB7000P #%d: not identified\n", k);
> +				kfree(st);
>  				return -EIO;
>  			}
>  		}
>  
> -		/* start diversity to pull_down div_str - just for i2c-enumeration */
> -		dib7000p_set_output_mode(&st, OUTMODE_DIVERSITY);
> +		/* start diversity to pull_down div_str - just for
> +		 * i2c-enumeration
> +		 */
> +		dib7000p_set_output_mode(st, OUTMODE_DIVERSITY);
>  
>  		/* set new i2c address and force divstart */
> -		dib7000p_write_word(&st, 1285, (new_addr << 2) | 0x2);
> +		dib7000p_write_word(st, 1285, (new_addr << 2) | 0x2);
>  
>  		dprintk("IC %d initialized (to i2c_address 0x%x)", k, new_addr);
>  	}
>  
>  	for (k = 0; k < no_of_demods; k++) {
> -		st.cfg = cfg[k];
> -		st.i2c_addr = (0x40 + k) << 1;
> +		st->cfg = cfg[k];
> +		st->i2c_addr = (0x40 + k) << 1;
>  
> -		// unforce divstr
> -		dib7000p_write_word(&st, 1285, st.i2c_addr << 2);
> +		/* unforce divstr */
> +		dib7000p_write_word(st, 1285, st->i2c_addr << 2);
>  
>  		/* deactivate div - it was just for i2c-enumeration */
> -		dib7000p_set_output_mode(&st, OUTMODE_HIGH_Z);
> +		dib7000p_set_output_mode(st, OUTMODE_HIGH_Z);
>  	}
>  
> +	kfree(st);
>  	return 0;
>  }
>  EXPORT_SYMBOL(dib7000p_i2c_enumeration);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
