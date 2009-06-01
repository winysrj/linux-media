Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:62452 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690AbZFAKpA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2009 06:45:00 -0400
Subject: Re: [PATCH] xc2028: Add support for Taiwan 6 MHz DVB-T
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Terry Wu <terrywu2009@gmail.com>
In-Reply-To: <1243817414.3140.68.camel@palomino.walls.org>
References: <1243773703.3133.24.camel@palomino.walls.org>
	 <20090531102220.2ebf15ca@pedra.chehab.org>
	 <1243791558.3147.38.camel@palomino.walls.org>
	 <20090531163335.4c13546e@pedra.chehab.org>
	 <1243817414.3140.68.camel@palomino.walls.org>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 06:45:38 -0400
Message-Id: <1243853138.3139.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-05-31 at 20:50 -0400, Andy Walls wrote^Wescreveu:
> On Sun, 2009-05-31 at 16:33 -0300, Mauro Carvalho Chehab wrote:
> > Em Sun, 31 May 2009 13:39:18 -0400
> > Andy Walls <awalls@radix.net> escreveu:
> > 
> 
> then I guess I'm OK with the change you have. 

Hmmm. Maybe not.

> 
> > So, the proper patch to tuner-xc3028 seems to be the enclosed one.
> > 
> > If both of you and Terry agree, I'll apply this one at the tree.

I have to do more looking.  The 

 
> > +   } else if (priv->cur_fw.type & DTV6) {
> > +           /* For Taiwan DVB-T 6 MHz bandwidth - Terry Wu */
> > +           offset = 1750000;

offset part of Terry's patch is missing from yours.  Based on what I now
know, I think setting the offset is necessary for 6 MHz DVB-T (DTV6) to
work.  I'll try to resubmit something tonight.

Regards,
Andy

> > Cheers,
> > Mauro.
> > 
> > 
> > diff --git a/linux/drivers/media/common/tuners/tuner-xc2028.c b/linux/drivers/media/common/tuners/tuner-xc2028.c
> > --- a/linux/drivers/media/common/tuners/tuner-xc2028.c
> > +++ b/linux/drivers/media/common/tuners/tuner-xc2028.c
> > @@ -1026,21 +1026,20 @@ static int xc2028_set_params(struct dvb_
> >  	switch(fe->ops.info.type) {
> >  	case FE_OFDM:
> >  		bw = p->u.ofdm.bandwidth;
> > -		break;
> > -	case FE_QAM:
> > -		tuner_info("WARN: There are some reports that "
> > -			   "QAM 6 MHz doesn't work.\n"
> > -			   "If this works for you, please report by "
> > -			   "e-mail to: v4l-dvb-maintainer@linuxtv.org\n");
> > -		bw = BANDWIDTH_6_MHZ;
> > -		type |= QAM;
> > +		/*
> > +		 * The only countries with 6MHz seem to be Taiwan/Uruguay.
> > +		 * Both seem to require QAM firmware for OFDM decoding
> > +		 * Tested in Taiwan by Terry Wu <terrywu2009@gmail.com>
> > +		 */
> > +		if (bw == BANDWIDTH_6_MHZ)
> > +			type |= QAM;
> >  		break;
> >  	case FE_ATSC:
> >  		bw = BANDWIDTH_6_MHZ;
> >  		/* The only ATSC firmware (at least on v2.7) is D2633 */
> >  		type |= ATSC | D2633;
> >  		break;
> > -	/* DVB-S is not supported */
> > +	/* DVB-S and pure QAM (FE_QAM) are not supported */
> >  	default:
> >  		return -EINVAL;
> >  	}
> > 
> > 
> > 
> > 
> > Cheers,
> > Mauro
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

