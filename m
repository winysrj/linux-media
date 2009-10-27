Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39643 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZJ0MG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 08:06:59 -0400
Date: Tue, 27 Oct 2009 10:06:22 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: =?us-ascii?B?THVrX19fXw==?= Karas <lukas.karas@centrum.cz>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] add support for IR on FlyDVB Trio (saa7134)
Message-ID: <20091027100622.6de8899d@pedra.chehab.org>
In-Reply-To: <200909101412.07415.lukas.karas@centrum.cz>
References: <200909101412.07415.lukas.karas@centrum.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kukáš,

Your patch were line-wrapped, so, I can't apply it. Could you please re-submit
if it weren't already merged?

Cheers,
Mauro.

Em Thu, 10 Sep 2009 14:12:07 +0200
Lukáš Karas <lukas.karas@centrum.cz> escreveu:

> Hi all, here is patch for driver saa7134, that add support for IR reciever 
> on card LifeView FlyDVB Trio. 
> 
> I tested it on kernel 2.6.30
> 
> 
> Signed-off-by: Lukas Karas <lukas.karas@centrum.cz>
> diff -uprN video.13c47deee3b1/ir-kbd-i2c.c video/ir-kbd-i2c.c
> --- video.13c47deee3b1/ir-kbd-i2c.c	2009-09-07 15:38:46.000000000 +0200
> +++ video/ir-kbd-i2c.c	2009-09-08 22:23:34.000000000 +0200
> @@ -438,6 +438,7 @@ static int ir_probe(struct i2c_client *c
>  		ir_type     = IR_TYPE_RC5;
>  		ir_codes    = &ir_codes_fusionhdtv_mce_table;
>  		break;
> +	case 0x0b:
>  	case 0x7a:
>  	case 0x47:
>  	case 0x71:
> @@ -467,7 +468,7 @@ static int ir_probe(struct i2c_client *c
>  		ir_codes    = &ir_codes_avermedia_cardbus_table;
>  		break;
>  	default:
> -		dprintk(1, DEVNAME ": Unsupported i2c address 0x%02x\n", addr);
> +		dprintk(1, "Unsupported i2c address 0x%02x\n", addr);
>  		err = -ENODEV;
>  		goto err_out_free;
>  	}
> @@ -514,7 +515,7 @@ static int ir_probe(struct i2c_client *c
> 
>  	/* Make sure we are all setup before going on */
>  	if (!name || !ir->get_key || !ir_codes) {
> -		dprintk(1, DEVNAME ": Unsupported device at address 0x%02x\n",
> +		dprintk(1, "Unsupported device at address 0x%02x\n",
>  			addr);
>  		err = -ENODEV;
>  		goto err_out_free;
> @@ -722,6 +723,30 @@ static int ir_probe(struct i2c_adapter *
>  			ir_attach(adap, msg[0].addr, 0, 0);
>  	}
> 
> +	/* special case for LifeView FlyDVB Trio */
> +	if (adap->id == I2C_HW_SAA7134) {
> +		u8 temp = 0;
> +		msg.buf = &temp;
> +		msg.addr = 0x0b;
> +		msg.len = 1;
> +		msg.flags = 0;
> +
> +		/* send weak up message to pic16C505 chip @ LifeView FlyDVB Trio */
> +		if (1 != i2c_transfer(adap,&msg,1)) {
> +			dprintk(1,"send wake up byte to pic16C505 failed\n");
> +		}else{
> +			msg.flags = I2C_M_RD;
> +			rc = i2c_transfer(adap, &msg, 1);
> +			dprintk(1, "probe 0x%02x @ %s: %s\n",
> +					msg.addr, adap->name,
> +					(1 == rc) ? "yes" : "no");
> +					if (1 == rc)
> +						ir_attach(adap, msg.addr, 0, 0);
> +		}
> +		msg.len = 0;
> +		msg.flags = I2C_M_RD;
> +	}
> +
>  	return 0;
>  }
>  #else
> diff -uprN video.13c47deee3b1/saa7134/saa7134-cards.c video/saa7134/saa7134-
> cards.c
> --- video.13c47deee3b1/saa7134/saa7134-cards.c	2009-09-07 15:38:46.000000000 
> +0200
> +++ video/saa7134/saa7134-cards.c	2009-09-09 00:45:09.000000000 +0200
> @@ -7212,9 +7212,27 @@ int saa7134_board_init2(struct saa7134_d
>  	}
>  	case SAA7134_BOARD_FLYDVB_TRIO:
>  	{
> +		u8 temp = 0;
> +		int rc;
>  		u8 data[] = { 0x3c, 0x33, 0x62};
>  		struct i2c_msg msg = {.addr=0x09, .flags=0, .buf=data, .len = sizeof(data)};
>  		i2c_transfer(&dev->i2c_adap, &msg, 1);
> +
> +		/* send weak up message to pic16C505 chip @ LifeView FlyDVB Trio */
> +		msg.buf = &temp;
> +		msg.addr = 0x0b;
> +		msg.len = 1;
> +		if (1 != i2c_transfer(&dev->i2c_adap,&msg,1)) {
> +			printk(KERN_WARNING "%s: send wake up byte to pic16C505 
> +				(IR chip) failed\n", dev->name);
> +		}else{
> +			msg.flags = I2C_M_RD;
> +			rc = i2c_transfer(&dev->i2c_adap, &msg, 1);
> +			printk(KERN_INFO "%s: probe IR chip @ i2c 0x%02x: %s\n",
> +				   dev->name, msg.addr,(1 == rc) ? "yes" : "no");
> +				   if (rc == 1)
> +					   dev->has_remote = SAA7134_REMOTE_I2C;
> +		}
>  		break;
>  	}
>  	case SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331:
> diff -uprN video.13c47deee3b1/saa7134/saa7134-input.c video/saa7134/saa7134-
> input.c
> --- video.13c47deee3b1/saa7134/saa7134-input.c	2009-09-07 15:38:46.000000000 
> +0200
> +++ video/saa7134/saa7134-input.c	2009-09-08 22:56:02.000000000 +0200
> @@ -132,6 +132,72 @@ static int build_key(struct saa7134_dev
> 
>  /* --------------------- Chip specific I2C key builders ----------------- */
> 
> +static int get_key_flydvb_trio(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
> +{
> +	int gpio;
> +	int attempt = 0;
> +	unsigned char b;
> +
> +	/* We need this to access GPI Used by the saa_readl macro. */
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
> +	struct saa7134_dev *dev = ir->c.adapter->algo_data;
> +#else
> +	struct saa7134_dev *dev = ir->c->adapter->algo_data;
> +#endif
> +
> +	if (dev == NULL) {
> +		dprintk ("get_key_flydvb_trio: "
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
> +		"gir->c.adapter->algo_data is NULL!\n");
> +#else
> +		"gir->c->adapter->algo_data is NULL!\n");
> +#endif
> +		return -EIO;
> +	}
> +
> +	/* rising SAA7134_GPIGPRESCAN reads the status */
> +	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
> +	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
> +
> +	gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);
> +
> +	if (0x40000 &~ gpio)
> +		return 0; /* No button press */
> +
> +	/* No button press - only before first key pressed */
> +	if (b == 0xFF)
> +		return 0;
> +
> +	/* poll IR chip */
> +	/* weak up the IR chip */
> +	b = 0;
> +
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
> +	while(1 != i2c_master_send(&ir->c, &b,1)) {
> +#else
> +	while(1 != i2c_master_send(ir->c, &b,1)) {
> +#endif
> +	if ((attempt++) < 10){
> +			msleep(10); /* wait a bit for next attempt - I don't know how make it 
> better */
> +			continue;
> +		}
> +		i2cdprintk("send wake up byte to pic16C505 (IR chip) 
> +			failed %dx\n", attempt);
> +		return -EIO;
> +	}
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
> +	if (1 != i2c_master_recv(&ir->c, &b, 1)) {
> +#else
> +	if (1 != i2c_master_recv(ir->c, &b, 1)) {
> +#endif
> +		i2cdprintk("read error\n");
> +		return -EIO;
> +	}
> +
> +	*ir_key = b;
> +	*ir_raw = b;
> +	return 1;
> +}
> +
>  static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, u32 *ir_key,
>  				       u32 *ir_raw)
>  {
> @@ -874,6 +940,18 @@ void saa7134_probe_i2c_ir(struct saa7134
>  		dev->info.addr = 0x40;
>  #endif
>  		break;
> +	case SAA7134_BOARD_FLYDVB_TRIO:
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
> +		snprintf(ir->c.name, sizeof(ir->c.name), "FlyDVB Trio");
> +		ir->get_key   = get_key_flydvb_trio;
> +		ir->ir_codes  = ir_codes_flydvb_table;
> +#else
> +		dev->init_data.name = "FlyDVB Trio";
> +		dev->init_data.get_key = get_key_flydvb_trio;
> +		dev->init_data.ir_codes = &ir_codes_flydvb_table;
> +		dev->info.addr = 0x0b;
> +#endif
> +		break;
>  	}
> 
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
