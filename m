Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:46851 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCFXMj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 18:12:39 -0500
Date: Fri, 6 Mar 2009 15:12:36 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: robert.jarzmik@free.fr, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
In-Reply-To: <Pine.LNX.4.64.0903061953170.5665@axis700.grange>
Message-ID: <Pine.LNX.4.58.0903061442240.24268@shell2.speakeasy.net>
References: <1028158815.2045371236327963888.JavaMail.root@zimbra20-e3.priv.proxad.net>
 <Pine.LNX.4.64.0903061953170.5665@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Mar 2009, Guennadi Liakhovetski wrote:
> On Fri, 6 Mar 2009, robert.jarzmik@free.fr wrote:
> >
> > This implies that even if DMA is 8 bytes aligned, width x height should
> > be a multiple of 16, not 8 as I stated in the first git comment. So that
> > would align :
> >  - width on 4 bytes (aligning meaning the lowest multiple of 4 below or equal to width)
> >  - and height on 4 bytes (aligning meaning the lowest multiple of 4 below or equal to height)
> >
> > Do we have an agreement on that specification, so that I can amend the code accordingly ?
>
> Yep, looks good to me.

I like the algorithm I posted, after another small improvement, better.

For instance, if width is aligned by 8 and height by 2, then you have
already have 16 byte alignment and there is no need to align height by 4.
E.g., 168x202 will be kept as 168x202 with my method but the rounding down
method changes it to 168x200.

Another example, take 159x243.  My algorithm produces 160x243, which seems
much better than 156x240, what one gets by rounding each dimention down to
a multiple of four.
