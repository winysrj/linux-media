Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64247 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2IORjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 13:39:35 -0400
Received: by lbbgj3 with SMTP id gj3so3418938lbb.19
        for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 10:39:34 -0700 (PDT)
Message-ID: <5054BD53.7060109@gmail.com>
Date: Sat, 15 Sep 2012 19:39:31 +0200
From: Anders Thomson <aeriksson2@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
References: <503F4E19.1050700@gmail.com> <20120915133417.27cb82a1@redhat.com>
In-Reply-To: <20120915133417.27cb82a1@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-09-15 18:34, Mauro Carvalho Chehab wrote:
> >  $ cat /TV_CARD.diff
> >  diff --git a/drivers/media/common/tuners/tda8290.c
> >  b/drivers/media/common/tuners/tda8290.c
> >  index 064d14c..498cc7b 100644
> >  --- a/drivers/media/common/tuners/tda8290.c
> >  +++ b/drivers/media/common/tuners/tda8290.c
> >  @@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
> >
> >                   dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
> >                              priv->i2c_props.adap,&priv->cfg);
> >  +               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new
> >  0x%02x\n",priv->cfg.switch_addr,priv->i2c_props.addr);
> >                   priv->cfg.switch_addr = priv->i2c_props.addr;
> >  +               priv->cfg.switch_addr = 0xc2 / 2;
>
> No, this is wrong. The I2C address is passed by the bridge driver or by
> the tuner_core attachment, being stored at priv->i2c_props.addr.
>
> What's the driver and card you're using?
>
lspci -vv:
03:06.0 Multimedia controller: Philips Semiconductors 
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
         Subsystem: Pinnacle Systems Inc. Device 002f
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64 (21000ns min, 8000ns max)
         Interrupt: pin A routed to IRQ 21
         Region 0: Memory at fdeff000 (32-bit, non-prefetchable) [size=2K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
         Kernel driver in use: saa7134
         Kernel modules: saa7134

Without the patch I get a layer of noise added. Kind of like a weak 
aerial signal to an old analogue TV set.

-Anders
