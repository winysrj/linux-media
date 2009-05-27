Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:53335 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756695AbZE0AQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 20:16:27 -0400
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
From: hermann pitton <hermann-pitton@arcor.de>
To: Martin Dauskardt <martin.dauskardt@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@radix.net>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, linux-media@vger.kernel.org
In-Reply-To: <200905262221.31409.martin.dauskardt@gmx.de>
References: <200905210909.43333.martin.dauskardt@gmx.de>
	 <1243287953.3744.93.camel@pc07.localdom.local>
	 <1243298465.3703.8.camel@pc07.localdom.local>
	 <200905262221.31409.martin.dauskardt@gmx.de>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 27 May 2009 02:15:29 +0200
Message-Id: <1243383329.6682.27.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 26.05.2009, 22:21 +0200 schrieb Martin Dauskardt:
> I should add that the picture quality is with all tested tuner types worse 
> than with my PVR250/350. I don't know if a PVR150 is in generally worse than 
> a PVR250. I can't call it really noisy, but in german I would say the picture 
> is a little bit "grobkörnig". It really needs a temporal filter setting of 
> value 8 or more, while my other PVR cards have a nice quality even with value 
> 0. 
> 
> I will test whatever you guys want me to test :-)  But I am not a programmer, 
> so I need detailled instructions what to patch.
> 
> My next step will be testing an older v4l2 with an 2.6.27 kernel to see if the 
> audio problem still exists.

Martin, that seems the right way to start and there is no need to hurry.

If nobody has a datasheet, and I can imagine that such an early RF loop
through tuner has some specials, you are still in a difficult testing
field, even if only on PAL BG for now. Is RF out is active would be
still interesting to know.

If on the same RF signal quality, means no more passive RF splitter in
between, I don't know what we can expect, but for example the FM1216ME
and the FMD1216ME hybrid MK3s do perform excellent and don't have this
"grobkörnige" (grainy?) picture, which you often see on cheaper tuners.

As far as I know, not any such complaints about the MK4s so far too.

Dmitry has some MK3 variant, where the first time on a Philips tuner
Chinese SAW filters are employed instead of the original EPCOS filters.

The question, if that could cause performance/sensitivity losses, is not
yet answered. Also if this is related to the SECAM DK tweaks he needs.

I would start testing for different sound quality between tuner 56 and
38. Beginning silence on old B/W mono broadcasts could make a difference
I somehow have in mind.

If 56 still has no sound at all, that should indicate a major technical
change compared to prior tuners.

Cheers,
Hermann
 

