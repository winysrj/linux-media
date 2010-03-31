Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:61012 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab0CaEMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 00:12:31 -0400
Received: by ewy20 with SMTP id 20so1752207ewy.1
        for <linux-media@vger.kernel.org>; Tue, 30 Mar 2010 21:12:30 -0700 (PDT)
Date: Wed, 31 Mar 2010 13:14:07 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Fix default state Beholder H6 tuner.
Message-ID: <20100331131407.741b7822@glory.loctelecom.ru>
In-Reply-To: <1269942855.3361.7.camel@pc07.localdom.local>
References: <20100330160217.52e26a33@glory.loctelecom.ru>
	<1269942855.3361.7.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann

> Hi,
> 
> Am Dienstag, den 30.03.2010, 16:02 +1000 schrieb Dmitri Belimov:
> > Hi
> > 
> > The hybrid tuner FMD1216MEX_MK3 after cold start has disabled IF.
> > This tuner has internal I2C switch. This switch switch I2C bus
> > between DVB-T and IF part. Default state is DVB-T. When module
> > saa7134 is load it can't find IF tda9887 and disable analog TV mode.
> > 
> > This patch set internal I2C switch of the tuner to IF by send
> > special value to the tuner as for receive analog TV from low band.
> > It can be usefule for other cards.
> > 
> > I didn't set configure a tuner by a tuner model because this tuner
> > can has different I2C address. May be we can do it later after
> > discuss for more robust support a tuners.
> 
> just as a reminder. It is the same for the FMD1216ME hybrid MK3.
> After every boot, analog mode fails with missing tda9887.
> 
> Currently, after tuner modules are not independent anymore, one has to
> reload the saa7134 driver once.
> 
> Relevant code in tuner.core.c.
> 
> 	case TUNER_PHILIPS_FMD1216ME_MK3:
> 		buffer[0] = 0x0b;
> 		buffer[1] = 0xdc;
> 		buffer[2] = 0x9c;
> 		buffer[3] = 0x60;
> 		i2c_master_send(c, buffer, 4);
> 		mdelay(1);
> 		buffer[2] = 0x86;
> 		buffer[3] = 0x54;
> 		i2c_master_send(c, buffer, 4);
> 		if (!dvb_attach(simple_tuner_attach, &t->fe,
> 				t->i2c->adapter, t->i2c->addr,
> t->type)) goto attach_failed;
> 		break;

That is good. I'll try add case TUNER_PHILIPS_FMD1216MEX_MK3 here and test.
This is much better.

With my best regards, Dmitry.

> Hermann
> 
> > diff -r 1ef0265456c8
> > linux/drivers/media/video/saa7134/saa7134-cards.c ---
> > a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Mar
> > 26 00:54:18 2010 -0300 +++
> > b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Mar
> > 28 08:21:10 2010 -0400 @@ -7450,6 +7450,21 @@ } break;
> >  	}
> > +	case SAA7134_BOARD_BEHOLD_H6:
> > +	{
> > +		u8 data[] = { 0x09, 0x9f, 0x86, 0x11};
> > +		struct i2c_msg msg = {.addr = 0x61, .flags =
> > 0, .buf = data,
> > +							.len =
> > sizeof(data)}; +
> > +		/* The tuner TUNER_PHILIPS_FMD1216MEX_MK3 after
> > hardware    */
> > +		/* start has disabled IF and enabled DVB-T. When
> > saa7134    */
> > +		/* scan I2C devices it not detect IF tda9887 and
> > can`t      */
> > +		/* watch TV without software reboot. For solve
> > this problem */
> > +		/* switch the tuner to analog TV mode
> > manually.             */
> > +		if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1)
> > +				printk(KERN_WARNING
> > +				      "%s: Unable to enable IF of
> > the tuner.\n",
> > +				       dev->name);
> > +		break;
> > +	}
> >  	} /* switch() */
> >  
> >  	/* initialize tuner */
> > 
> > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov
> > <d.belimov@gmail.com>
> > 
> > With my best regards, Dmitry.
> 
