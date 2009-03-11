Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:45345 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbZCKVV2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 17:21:28 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] pxa_camera: Redesign DMA handling
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903091023540.3992@axis700.grange>
	<87sklms9ni.fsf@free.fr>
	<Pine.LNX.4.64.0903092310510.5857@axis700.grange>
	<87r615hwzb.fsf@free.fr>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 11 Mar 2009 22:21:16 +0100
In-Reply-To: <87r615hwzb.fsf@free.fr> (Robert Jarzmik's message of "Tue\, 10 Mar 2009 22\:46\:48 +0100")
Message-ID: <873adjhi2b.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>  It is the result of our conversation about "hot DMA linking". I tested both
> paths (the optimal one and the one where DMA stops while queuing =>
> cf. pxa_camera_check_link_miss) for RGB565 format.  I'll test further for
> YUV422P ...

Well, surprise surprise with the YUV422P format. We're not done yet ...

There is a little issue with overrun : buf->active_dma is cleared in dma irq
handler (for example suppose is cleared of DMA_U which finished first). Then an
overrun occurs, and we restart that frame ...

We should have reset buf->active_dma to DMA_Y | DMA_U | DMA_V.
I think same thing applies to the "hot chain" link miss restart.

The non-regression tests are not yet finished ... exciting, isn't it ? :)

Cheers.

--
Robert
