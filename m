Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47435 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2GEQgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 12:36:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media ML <linux-media@vger.kernel.org>
Subject: Re: capture_mem limitations in OMAP ISP
Date: Thu, 05 Jul 2012 18:36:24 +0200
Message-ID: <2278346.UGGOgjoZYS@avalon>
In-Reply-To: <4FF2BF79.2020302@matrix-vision.de>
References: <4FF2BF79.2020302@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Tuesday 03 July 2012 11:46:33 Michael Jones wrote:
> Hi Laurent & co.,
> 
> I'm looking at the memory limitations in the omap3isp driver. 'struct
> isp_video' contains member 'capture_mem', which is set separately for each
> of our v4l2 video device nodes. The CCDC, for example, has capture_mem =
> 4096 * 4096 * 3 = 48MB, while the previewer and resizer each have twice
> that. Where do these numbers come from?

That's mostly historical. When developing the driver for the N900 we set a 
limit to avoid putting too much pressure on the system memory, and 3x8MP 
buffers was considered to be enough.

We could raise the limit, remove it completely, or implement a policy 
mechanism to let a privileged userspace application specify limits. The later 
might be interesting as a core V4L2 mechanism.

> Is the CCDC incapable of DMA'ing more than 48MB into memory? I know that
> ISP_VIDEO_MAX_BUFFERS also limits the # of buffers, but I assume this is
> basically an arbitrary number so we can have a finite array of
> isp_video_buffer's. The 48MB, on the other hand, looks like it might have a
> good reason.

-- 
Regards,

Laurent Pinchart

