Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:51256 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZCEVWg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 16:22:36 -0500
Date: Thu, 5 Mar 2009 13:22:32 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
In-Reply-To: <873adrekwj.fsf@free.fr>
Message-ID: <Pine.LNX.4.58.0903051317010.24268@shell2.speakeasy.net>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903052119590.4980@axis700.grange> <873adrekwj.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Robert Jarzmik wrote:
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>
> > This is not a review yet - just an explanation why I was suggesting to
> > adjust height and width - you say yourself, that YUV422P (I think, this is
> > wat you meant, not just YUV422) requires planes to immediately follow one
> > another. But you have to align them on 8 byte boundary for DMA, so, you
> > violate the standard, right? If so, I would rather suggest to adjust width
> > and height for planar formats to comply to the standard. Or have I
> > misunderstood you?
> No, you understand perfectly.
>
> And now, what do we do :
>  - adjust height ?
>  - adjust height ?
>  - adjust both ?
>
> I couldn't decide which one, any hint ?

Shame the planes have to be contiguous.  Software like ffmpeg doesn't
require this and could handle planes with gaps between them without
trouble.  Plans aligned on 8 bytes boundaries would probably be faster in
fact.  Be better if v4l2_buffer gave us offsets for each plane.

If you must adjust, probably better to adjust both.
