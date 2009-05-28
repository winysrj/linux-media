Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:38157 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbZE1JYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 05:24:18 -0400
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Dmitri Belimov <d.belimov@gmail.com>
Cc: Ant <ant@symons.net.au>, Andy Walls <awalls@radix.net>,
	Martin Dauskardt <martin.dauskardt@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, linux-media@vger.kernel.org
In-Reply-To: <200905270809.53056.hverkuil@xs4all.nl>
References: <200905210909.43333.martin.dauskardt@gmx.de>
	 <1243389830.4046.52.camel@palomino.walls.org>
	 <4A1CB353.7020906@symons.net.au>  <200905270809.53056.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 May 2009 11:21:38 +0200
Message-Id: <1243502498.3722.17.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 27.05.2009, 08:09 +0200 schrieb Hans Verkuil:
> On Wednesday 27 May 2009 05:28:19 Ant wrote:
> > Andy Walls wrote:
> > > Hermann,
> > >
> > > There is an FQ1216LME MK3 data sheet here:
> > >
> > > http://dl.ivtvdriver.org/datasheets/tuners/FQ1216LME%20Mk3.pdf
> > >
> > > Is it safe to assume that the MK5 is not very different from the MK3?
> >
> > I am no expert on the subject, but I found this reference to the MK3 vs
> > MK5:
> >
> > http://www.nxp.com/acrobat_download/other/products/rf/fq_mk5.pdf
> >
> > Where it says
> >
> > "The FQ1200 MK5 family is identical in footprint to the
> > FQ1200 MK3 series, ensuring a quick drop-in replacement."
> >
> > If the MK5 family is designed as a drop in replacement for the MK3
> > family, I would think there is a good chance it functions exactly the
> > same.
> >
> > Anthony
> 
> And in addition I have the datasheets for the FM1216ME_MK3, FM1216ME_MK5 and 
> FQ1236MK5. All combined should give enough information to deduce what if 
> any the changes are between the FQ1216LME MK3 and MK5.
> 
> Please mail me who wants these datasheets and I'll send them to you.
> 
> Regards,
> 
> 	Hans

on the FQ1216AME.pdf I read it has an on average 10dB LNA for extra high
sensitivity and that there must be taken care not to apply to large
signals.

This obviously results in this recommendation for IF TOP.

* For optimum setting between overall picture quality and signal
handling to fulfill CISPR20/EN55020
requirements, we recommend to use these settings below .
 However we recommend customers have the choice to make their own
setting based on their own
application. For example, for cable TV networks, the TOP has to be –4 dB
or lower to prevent intermodulation problems.

Likely this is the same on the MK5 and with this background it is clear
what Dmitry is talking about these tuners! Nobody mentioned the LNA so
far.

Also, on a first look at the FQ1216LME MK3 pdf, loopthrough is active.

And on that one.

Important !!
The FQ1216LME uses the narrowband mode. So the internal AGC mode must be
switched off. This
is done by setting the I AGC to 0 by setting AL2=1, AL1=1, AL0=0.
At the same time the bits C0 to C6 (IF TOP) must be set according to the
table on Pg16.
This disables the internal AGC detector and activates the narrowband
AGC. The TOP is
recommended to be set to +4 dB in order to fulfil EN55020.
See the programming examples on Pg 19.

So we have tuners needing at least the tda9887 "adjust option" and
better have their own entry. Seeing now also port2=1 for the AME MK4
except for Secam L', all makes sense.

Cheers,
Hermann



	

