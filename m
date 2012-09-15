Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab2IOR6g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 13:58:36 -0400
Date: Sat, 15 Sep 2012 14:58:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Anders Thomson <aeriksson2@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
Message-ID: <20120915145834.0b763f73@redhat.com>
In-Reply-To: <5054BD53.7060109@gmail.com>
References: <503F4E19.1050700@gmail.com>
	<20120915133417.27cb82a1@redhat.com>
	<5054BD53.7060109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Sep 2012 19:39:31 +0200
Anders Thomson <aeriksson2@gmail.com> escreveu:

> On 2012-09-15 18:34, Mauro Carvalho Chehab wrote:
> > >  $ cat /TV_CARD.diff
> > >  diff --git a/drivers/media/common/tuners/tda8290.c
> > >  b/drivers/media/common/tuners/tda8290.c
> > >  index 064d14c..498cc7b 100644
> > >  --- a/drivers/media/common/tuners/tda8290.c
> > >  +++ b/drivers/media/common/tuners/tda8290.c
> > >  @@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
> > >
> > >                   dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
> > >                              priv->i2c_props.adap,&priv->cfg);
> > >  +               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new
> > >  0x%02x\n",priv->cfg.switch_addr,priv->i2c_props.addr);
> > >                   priv->cfg.switch_addr = priv->i2c_props.addr;
> > >  +               priv->cfg.switch_addr = 0xc2 / 2;
> >
> > No, this is wrong. The I2C address is passed by the bridge driver or by
> > the tuner_core attachment, being stored at priv->i2c_props.addr.
> >
> > What's the driver and card you're using?
> >
> lspci -vv:
> 03:06.0 Multimedia controller: Philips Semiconductors 
> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
>          Subsystem: Pinnacle Systems Inc. Device 002f

There are lots of Pinnacle device supported by saa7134 driver. Without its
PCI ID that's not much we can do.

Also, please post the dmesg showing what happens without and with your patch.

Regards,
Mauro
