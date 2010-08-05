Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab0HENIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Aug 2010 09:08:01 -0400
Message-ID: <4C5AB7DB.7030306@infradead.org>
Date: Thu, 05 Aug 2010 10:08:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: V4L Kconfig defaults
References: <Pine.LNX.4.64.1008051214310.19691@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1008051214310.19691@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-08-2010 07:32, Guennadi Liakhovetski escreveu:
> Hi Mauro
> 
> At some point the usefullness of the VIDEO_HELPER_CHIPS_AUTO option has 
> been questioned and a patch has even been submitted to disable this on 
> embedded systems [1], which, somehow, doesn't seem to have been 
> successful, even though there haven't been any objections. Or was I 
> expected to push it via my tree?

I always expect patches from you via your tree.

> Now, since a few kernel versions there are _many_ more of "default y" 
> options in drivers/media/*/Kconfig around IR / remote drivers. Can we kill 
> them (defaults, of course, not drivers), please?

Hmm... those IR default's should be changed. Yet, the decoders should default to y,
if IR_CORE is selected, as otherwise remote controllers that outputs data in raw
mode won't work (and most drivers that have IR support have some models that use
raw mode). Maybe we can create a IR_CORE_RAW to do the trick. We need to 
think a little more about that.

> 
> Thanks
> Guennadi
> 
> [1] http://article.gmane.org/gmane.linux.kernel.embedded/2721

Cheers,
Mauro
