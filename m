Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2IOWZe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 18:25:34 -0400
Date: Sat, 15 Sep 2012 19:25:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Anders Thomson <aeriksson2@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
Message-ID: <20120915192530.74aedaa6@redhat.com>
In-Reply-To: <5054C521.1090200@gmail.com>
References: <503F4E19.1050700@gmail.com>
	<20120915133417.27cb82a1@redhat.com>
	<5054BD53.7060109@gmail.com>
	<20120915145834.0b763f73@redhat.com>
	<5054C521.1090200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Sep 2012 20:12:49 +0200
Anders Thomson <aeriksson2@gmail.com> escreveu:

> On 2012-09-15 19:58, Mauro Carvalho Chehab wrote:
> > Em Sat, 15 Sep 2012 19:39:31 +0200
> > Anders Thomson<aeriksson2@gmail.com>  escreveu:
> >
> > >  On 2012-09-15 18:34, Mauro Carvalho Chehab wrote:
> > >  >  >   $ cat /TV_CARD.diff
> > >  >  >   diff --git a/drivers/media/common/tuners/tda8290.c
> > >  >  >   b/drivers/media/common/tuners/tda8290.c
> > >  >  >   index 064d14c..498cc7b 100644
> > >  >  >   --- a/drivers/media/common/tuners/tda8290.c
> > >  >  >   +++ b/drivers/media/common/tuners/tda8290.c
> > >  >  >   @@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
> > >  >  >
> > >  >  >                    dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
> > >  >  >                               priv->i2c_props.adap,&priv->cfg);
> > >  >  >   +               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new
> > >  >  >   0x%02x\n",priv->cfg.switch_addr,priv->i2c_props.addr);
> > >  >  >                    priv->cfg.switch_addr = priv->i2c_props.addr;
> > >  >  >   +               priv->cfg.switch_addr = 0xc2 / 2;
> > >  >
> > >  >  No, this is wrong. The I2C address is passed by the bridge driver or by
> > >  >  the tuner_core attachment, being stored at priv->i2c_props.addr.
> > >  >
> > >  >  What's the driver and card you're using?
> > >  >
> > >  lspci -vv:
> > >  03:06.0 Multimedia controller: Philips Semiconductors
> > >  SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
> > >           Subsystem: Pinnacle Systems Inc. Device 002f
> >
> > There are lots of Pinnacle device supported by saa7134 driver. Without its
> > PCI ID that's not much we can do.
> That here, right?
> lspci -nvv:
> 03:06.0 0480: 1131:7133 (rev d1)
>          Subsystem: 11bd:002f
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>          Latency: 64 (21000ns min, 8000ns max)
>          Interrupt: pin A routed to IRQ 21
>          Region 0: Memory at fdeff000 (32-bit, non-prefetchable) [size=2K]
>          Capabilities: [40] Power Management version 2
>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
>          Kernel driver in use: saa7134
>          Kernel modules: saa7134
> 
> 
> 
> 
> > Also, please post the dmesg showing what happens without and with your patch.
> Coming. Hold on...

Thanks!

Please try the enclosed patch.

-

[PATCH] tda8290: Fix lna switch address

When LNA is configured with config 1 or config 2, tda827x driver
will use the LNA switch_addr. However, this is not happening for
all devices using such config, as reported by Anders. According
to him, he is experiencing bad tuning with this code since
Kenrel 2.6.26.

Reported-by: Anders Thomson <aeriksson2@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index 8c48521..bedc6ce 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -627,6 +627,9 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
 		return -EREMOTEIO;
 	}
 
+	if (priv->cfg.config == 1 || priv->cfg.config == 2)
+		priv->cfg.switch_addr = priv->i2c_props.addr;
+
 	if ((data == 0x83) || (data == 0x84)) {
 		priv->ver |= TDA18271;
 		tda829x_tda18271_config.config = priv->cfg.config;
@@ -640,7 +643,6 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
 
 		dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
 			   priv->i2c_props.adap, &priv->cfg);
-		priv->cfg.switch_addr = priv->i2c_props.addr;
 	}
 	if (fe->ops.tuner_ops.init)
 		fe->ops.tuner_ops.init(fe);


-- 
Regards,
Mauro
