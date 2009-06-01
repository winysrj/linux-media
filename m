Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:43919 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbZFAAsn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 20:48:43 -0400
Subject: Re: [PATCH] xc2028: Add support for Taiwan 6 MHz DVB-T
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Terry Wu <terrywu2009@gmail.com>
In-Reply-To: <20090531163335.4c13546e@pedra.chehab.org>
References: <1243773703.3133.24.camel@palomino.walls.org>
	 <20090531102220.2ebf15ca@pedra.chehab.org>
	 <1243791558.3147.38.camel@palomino.walls.org>
	 <20090531163335.4c13546e@pedra.chehab.org>
Content-Type: text/plain
Date: Sun, 31 May 2009 20:50:14 -0400
Message-Id: <1243817414.3140.68.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-05-31 at 16:33 -0300, Mauro Carvalho Chehab wrote:
> Em Sun, 31 May 2009 13:39:18 -0400
> Andy Walls <awalls@radix.net> escreveu:
> 
> > > Hmm... why are you asking for the QAM firmware here? Shouldn't it be at FE_QAM?
> > 
> > I think I can provide a little insight:
> > 
> > They way I understood things is that DVB-T demodulators (like the
> > ZarLink used for the DTV1800 - zl10353 driver) are always of type
> > FE_OFDM.  The OFDM subcarriers for DVB-T can be modulated with QPSK or
> > QAM (I think there is a hierarchical modulation scheme - I have to do
> > more reading).
> > 
> > In the Linux dvb frontend drivers, the FE_QAM type is used for only for
> > cable TV (DVB-C) frontends.
> > 
> > 
> > My questions:
> > Is OFDM used for other Digital TV aside from DVB-T?
> > 
> > Does the XC20208 have firmware explcitily for OFDM irrespective of the
> > subcarrier modulation?
> > 
> > 
> > Here is a list of DVB deployment reports:
> > 
> > http://www.dvb.org/dvb-deployment-data.xls
> > 
> > Columns Q, R and U show these countries as DVB-T in a 6 MHz bandwidth
> > 
> > Taiwan: ~8000 subcarriers, 16 QAM
> > Uruguay: ~2000 subcarriers, 16 QAM and 64 QAM
> > 
> > 
> > So both of the currently deployed DVB-T systems using 6 MHz use QAM
> > subcarriers.
> > 
> > The only deployments using QPSK are using it in an 8 MHz bandwidth for
> > mobile services.
> > 
> > All the DVB demods in the v4l-dvb source tree that are FE_OFDM are
> > marked FE_CAN_QAM_{16,64,AUTO}, except in
> > 
> > 	v4l-dvb/linux/drivers/media/dvb/frontends/cx22700.c
> > 
> > the CX22700 is not marked FE_CAN_QAM_AUTO.
> 
> After reviewing your table, I agree that we should load the QAM firmware every time that
> 6 MHz of Bandwidth is selected. Terry's report also helps to solve the mystery with
> the QAM firmwares that exist only for 6 MHz: they are there for OFTM with QAM modulation, and
> not for Cable QAM. Other independent tests confirmed that QAM for cable doesn't work.

Well, the XC3028 is supposed to support DVB-C and DOCSIS in 6 MHz and
DVB-C in 8 MHz:

http://www.xceive.com/docs/XC3028_prodbrief.pdf

So FE_QAM is a valid Linux demod type to use with an XC3028, isn't it?

However, I was under the impression that DVB-C isn't as widely deployed
as what has been standardized in ITU-T J.83: Annex A (Europe), B (North
America QAM), C (Japan), or D (North America 16-VSB).


If we don't know how to make the XC3028 work with the DVB-C demod's
marked FE_QAM:

[andy@palomino frontends]$ grep -B1 '\.type.*= FE_QAM' * 
at76c651.c-		.name = "Atmel AT76C651B DVB-C",
at76c651.c:		.type = FE_QAM,
--
dvb_dummy_fe.c-		.name			= "Dummy DVB-C",
dvb_dummy_fe.c:		.type			= FE_QAM,
--
stv0297.c-		 .name = "ST STV0297 DVB-C",
stv0297.c:		 .type = FE_QAM,
--
tda10021.c-		.name = "Philips TDA10021 DVB-C",
tda10021.c:		.type = FE_QAM,
--
tda10023.c-		.name = "Philips TDA10023 DVB-C",
tda10023.c:		.type = FE_QAM,
--
ves1820.c-		.name = "VLSI VES1820 DVB-C",
ves1820.c:		.type = FE_QAM,

then I guess I'm OK with the change you have.  I also can't seem to find
any place in the codebase where xc2028_attach is called when attaching
one of these demods (although the Flexicop stuff was confusing).  So I
don't think anything will break.


> However, the selection of D2633 and D2620 will depend on what demod you'll
> have, since, AFAIK, this is related to the output power level. So, this should
> be selected at the boards level.

> Also, there's no need to set DTV6, since this is already done inside
> xc2028_set_params, on the next switch().

I have no spec sheets for the XC3028, nor do I really understand what
all these flags are for, in this driver.  I defer to you and Terry.

The choice not to set D26xx here will actually not affect Miroslav's
DTV-1800H patch that's been in discussion on the list.  That patch sets
the ctrl.demod = XC3028_FE_ZARLINK456 and leaves the ctrl.type =
XC3028_AUTO (since cx88_setup_xc3028 memset()'s the ctrl to 0's).  Then
of course xc2028_set_params() detects this condition and selects D2633
anyway.... :)


Regards,
Andy

> So, the proper patch to tuner-xc3028 seems to be the enclosed one.
> 
> If both of you and Terry agree, I'll apply this one at the tree.
> 
> Cheers,
> Mauro.
> 
> 
> diff --git a/linux/drivers/media/common/tuners/tuner-xc2028.c b/linux/drivers/media/common/tuners/tuner-xc2028.c
> --- a/linux/drivers/media/common/tuners/tuner-xc2028.c
> +++ b/linux/drivers/media/common/tuners/tuner-xc2028.c
> @@ -1026,21 +1026,20 @@ static int xc2028_set_params(struct dvb_
>  	switch(fe->ops.info.type) {
>  	case FE_OFDM:
>  		bw = p->u.ofdm.bandwidth;
> -		break;
> -	case FE_QAM:
> -		tuner_info("WARN: There are some reports that "
> -			   "QAM 6 MHz doesn't work.\n"
> -			   "If this works for you, please report by "
> -			   "e-mail to: v4l-dvb-maintainer@linuxtv.org\n");
> -		bw = BANDWIDTH_6_MHZ;
> -		type |= QAM;
> +		/*
> +		 * The only countries with 6MHz seem to be Taiwan/Uruguay.
> +		 * Both seem to require QAM firmware for OFDM decoding
> +		 * Tested in Taiwan by Terry Wu <terrywu2009@gmail.com>
> +		 */
> +		if (bw == BANDWIDTH_6_MHZ)
> +			type |= QAM;
>  		break;
>  	case FE_ATSC:
>  		bw = BANDWIDTH_6_MHZ;
>  		/* The only ATSC firmware (at least on v2.7) is D2633 */
>  		type |= ATSC | D2633;
>  		break;
> -	/* DVB-S is not supported */
> +	/* DVB-S and pure QAM (FE_QAM) are not supported */
>  	default:
>  		return -EINVAL;
>  	}
> 
> 
> 
> 
> Cheers,
> Mauro
> 

