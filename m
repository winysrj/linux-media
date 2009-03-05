Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:34630 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbZCEVKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 16:10:17 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903052119590.4980@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 05 Mar 2009 22:10:04 +0100
In-Reply-To: <Pine.LNX.4.64.0903052119590.4980@axis700.grange> (Guennadi Liakhovetski's message of "Thu\, 5 Mar 2009 21\:29\:06 +0100 \(CET\)")
Message-ID: <873adrekwj.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> This is not a review yet - just an explanation why I was suggesting to 
> adjust height and width - you say yourself, that YUV422P (I think, this is 
> wat you meant, not just YUV422) requires planes to immediately follow one 
> another. But you have to align them on 8 byte boundary for DMA, so, you 
> violate the standard, right? If so, I would rather suggest to adjust width 
> and height for planar formats to comply to the standard. Or have I 
> misunderstood you?
No, you understand perfectly.

And now, what do we do :
 - adjust height ?
 - adjust height ?
 - adjust both ?

I couldn't decide which one, any hint ?

--
Robert
