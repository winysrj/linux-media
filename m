Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50464 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0KDDan (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 23:30:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP3530 ISP irqs disabled
Date: Thu, 4 Nov 2010 04:30:49 +0100
Cc: Michael Jones <michael.jones@matrix-vision.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com> <4CD15C7B.2010008@matrix-vision.de> <AANLkTikG-cOn9s37yfjpfd0=CVXO3NwJF9MRZVv=0YXN@mail.gmail.com>
In-Reply-To: <AANLkTikG-cOn9s37yfjpfd0=CVXO3NwJF9MRZVv=0YXN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011040430.50216.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Bastian,

On Wednesday 03 November 2010 14:26:26 Bastian Hecht wrote:
> 2010/11/3 Michael Jones <michael.jones@matrix-vision.de>:
> > Bastian Hecht wrote:
> >> I enabled isr debugging (#define ISP_ISR_DEBUG) and see that only 1
> >> HS_VS_event is generated per second. 1fps corresponds to my clocking,
> >> so 1 vs per second is fine. But shouldn't I see about 2000 hs
> >> interrupts there too? HS_VS_IRQ is described as "HS or VS synchro
> >> event".
> > 
> > HS_VS_IRQ is _either_ VS _or_ HS interrupts, but not both.  The
> > SYNC_DETECT bits in ISP_CTRL determines which.  For writing into memory,
> > the ISP only needs to react per frame, not per line, so it is set up to
> > trigger on VS.
> 
> OK, I see, thank you. Is there a point in the ccdc code where I can
> directly look up what is read from the camera pins cam_d*? All the
> signals seem to be fine from the camera, I want to check if this is
> true and the problem is in the dma part.

No, the signals are not accessible directly in the ISP. What you could do, 
however, is read them as GPIOs.

-- 
Regards,

Laurent Pinchart
