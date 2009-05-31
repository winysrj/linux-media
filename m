Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:33671 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbZEaRic (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 13:38:32 -0400
Subject: Re: [PATCH] xc2028: Add support for Taiwan 6 MHz DVB-T
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Terry Wu <terrywu2009@gmail.com>
In-Reply-To: <20090531102220.2ebf15ca@pedra.chehab.org>
References: <1243773703.3133.24.camel@palomino.walls.org>
	 <20090531102220.2ebf15ca@pedra.chehab.org>
Content-Type: text/plain
Date: Sun, 31 May 2009 13:39:18 -0400
Message-Id: <1243791558.3147.38.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-05-31 at 10:22 -0300, Mauro Carvalho Chehab wrote:
> Em Sun, 31 May 2009 08:41:43 -0400
> Andy Walls <awalls@radix.net> escreveu:
> 
> > This is a patch with changes provided by Terry Wu to support 6 MHz DVB-T
> > as is deployed in Taiwan.
> > 
> > 
> > I took quick look at the changes and they look OK to me, but I'm no
> > expert on the XC2028/XC3028 deivces.
> > 
> > My one observation is that the change assumes all COFDM frontends can
> > support QAM (FE_CAN_QAM..).  This is apparently the case looking through
> > all the Linux supported FE_OFDM frontends, and it seems like a
> > reasonable assumption to me.
> > 
> > 
> > Terry,
> > 
> > Please check the diff below, to make sure I captured all your changes.
> > 
> > For inclusion into the kernel, you will need to provide a
> > "Signed-off-by:" in a rely to this patch list posting.  Please see:
> > 
> > http://www.linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Developer.27s_Certificate_of_Origin_1.1
> > 
> > 
> > Regards,
> > Andy
> > 
> > 
> > diff -r 8291f6042c9a linux/drivers/media/common/tuners/tuner-xc2028.c
> > --- a/linux/drivers/media/common/tuners/tuner-xc2028.c	Fri May 29 21:19:25 2009 -0400
> > +++ b/linux/drivers/media/common/tuners/tuner-xc2028.c	Sun May 31 08:29:32 2009 -0400
> > @@ -925,6 +925,9 @@
> >  		rc = send_seq(priv, {0x00, 0x00});
> >  	} else if (priv->cur_fw.type & ATSC) {
> >  		offset = 1750000;
> > +	} else if (priv->cur_fw.type & DTV6) {
> > +		/* For Taiwan DVB-T 6 MHz bandwidth - Terry Wu */
> > +		offset = 1750000;
> 
> This is wrong, since it will break xc3028 for all other DVB-T standards.
> The offset depends on the demod type. He probably choose the wrong IF for the demod.
> 
> Terry, please provide your boards entry for us to help you to properly set it.

> >  	} else {
> >  		offset = 2750000;
> >  		/*
> > @@ -1026,6 +1029,11 @@
> >  	switch(fe->ops.info.type) {
> >  	case FE_OFDM:
> >  		bw = p->u.ofdm.bandwidth;
> > +		/* For Taiwan DVB-T 6 MHz bandwidth - Terry Wu */
> > +		if (bw == BANDWIDTH_6_MHZ) {
> > +			type |= (DTV6|QAM|D2633);
> > +			priv->ctrl.type = XC2028_D2633;
> > +		}
> 
> Hmm... why are you asking for the QAM firmware here? Shouldn't it be at FE_QAM?

I think I can provide a little insight:

They way I understood things is that DVB-T demodulators (like the
ZarLink used for the DTV1800 - zl10353 driver) are always of type
FE_OFDM.  The OFDM subcarriers for DVB-T can be modulated with QPSK or
QAM (I think there is a hierarchical modulation scheme - I have to do
more reading).

In the Linux dvb frontend drivers, the FE_QAM type is used for only for
cable TV (DVB-C) frontends.


My questions:
Is OFDM used for other Digital TV aside from DVB-T?

Does the XC20208 have firmware explcitily for OFDM irrespective of the
subcarrier modulation?


Here is a list of DVB deployment reports:

http://www.dvb.org/dvb-deployment-data.xls

Columns Q, R and U show these countries as DVB-T in a 6 MHz bandwidth

Taiwan: ~8000 subcarriers, 16 QAM
Uruguay: ~2000 subcarriers, 16 QAM and 64 QAM


So both of the currently deployed DVB-T systems using 6 MHz use QAM
subcarriers.

The only deployments using QPSK are using it in an 8 MHz bandwidth for
mobile services.

All the DVB demods in the v4l-dvb source tree that are FE_OFDM are
marked FE_CAN_QAM_{16,64,AUTO}, except in

	v4l-dvb/linux/drivers/media/dvb/frontends/cx22700.c

the CX22700 is not marked FE_CAN_QAM_AUTO.

Regards,
Andy

> This will also break for other countries with 6 MHz bw. Also, priv->ctrl should
> be set inside your board definitions.
> 
> Could you please provide us more info about the DVB-T standard in Taiwan?
> 
> >  		break;
> >  	case FE_QAM:
> >  		tuner_info("WARN: There are some reports that "
> > 
> > 
> 
> 
> 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

