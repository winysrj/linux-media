Return-path: <mchehab@gaivota>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35947 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab0KCN01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 09:26:27 -0400
Received: by gxk23 with SMTP id 23so462656gxk.19
        for <linux-media@vger.kernel.org>; Wed, 03 Nov 2010 06:26:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD15C7B.2010008@matrix-vision.de>
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com>
	<AANLkTimDN73S9ZWii80i9LtHtsHtPQPsMdEdGB+C5nYy@mail.gmail.com>
	<4CD15C7B.2010008@matrix-vision.de>
Date: Wed, 3 Nov 2010 14:26:26 +0100
Message-ID: <AANLkTikG-cOn9s37yfjpfd0=CVXO3NwJF9MRZVv=0YXN@mail.gmail.com>
Subject: Re: OMAP3530 ISP irqs disabled
From: Bastian Hecht <hechtb@googlemail.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

2010/11/3 Michael Jones <michael.jones@matrix-vision.de>:
> Bastian Hecht wrote:
>>
>> I enabled isr debugging (#define ISP_ISR_DEBUG) and see that only 1
>> HS_VS_event is generated per second. 1fps corresponds to my clocking,
>> so 1 vs per second is fine. But shouldn't I see about 2000 hs
>> interrupts there too? HS_VS_IRQ is described as "HS or VS synchro
>> event".
>
> HS_VS_IRQ is _either_ VS _or_ HS interrupts, but not both.  The SYNC_DETECT bits in ISP_CTRL determines which.  For writing into memory, the ISP only needs to react per frame, not per line, so it is set up to trigger on VS.

OK, I see, thank you. Is there a point in the ccdc code where I can
directly look up what is read from the camera pins cam_d*? All the
signals seem to be fine from the camera, I want to check if this is
true and the problem is in the dma part.

- Bastian

> --
> Michael Jones
> MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
> Registergericht: Amtsgericht Stuttgart, HRB 271090
> Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
>
