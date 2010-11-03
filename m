Return-path: <mchehab@gaivota>
Received: from mail1.matrix-vision.com ([78.47.19.71]:47316 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab0KCM6i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 08:58:38 -0400
Message-ID: <4CD15C7B.2010008@matrix-vision.de>
Date: Wed, 03 Nov 2010 13:58:35 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Bastian Hecht <hechtb@googlemail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OMAP3530 ISP irqs disabled
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com> <AANLkTimDN73S9ZWii80i9LtHtsHtPQPsMdEdGB+C5nYy@mail.gmail.com>
In-Reply-To: <AANLkTimDN73S9ZWii80i9LtHtsHtPQPsMdEdGB+C5nYy@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Bastian Hecht wrote:
> 
> I enabled isr debugging (#define ISP_ISR_DEBUG) and see that only 1
> HS_VS_event is generated per second. 1fps corresponds to my clocking,
> so 1 vs per second is fine. But shouldn't I see about 2000 hs
> interrupts there too? HS_VS_IRQ is described as "HS or VS synchro
> event".

HS_VS_IRQ is _either_ VS _or_ HS interrupts, but not both.  The SYNC_DETECT bits in ISP_CTRL determines which.  For writing into memory, the ISP only needs to react per frame, not per line, so it is set up to trigger on VS.

-- 
Michael Jones

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
