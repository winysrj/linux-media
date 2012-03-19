Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38274 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab2CSXVi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 19:21:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media ML <linux-media@vger.kernel.org>
Subject: Re: reading config parameters of omap3-isp subdevs
Date: Tue, 20 Mar 2012 00:22:04 +0100
Message-ID: <6085689.3CUf0tMs8E@avalon>
In-Reply-To: <4F6348D7.9070409@matrix-vision.de>
References: <4F6348D7.9070409@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Friday 16 March 2012 15:06:15 Michael Jones wrote:
> Hi all,
> 
> I am playing around with some parameters in the previewer on the ISP. With
> ioctl VIDIOC_OMAP3ISP_PRV_CFG I am able to write the various parameters but
> what I'm missing is a way to read them. For example, I have no way to adjust
> only coef2 in 'struct omap3isp_prev_wbal' while leaving the others
> unchanged. If I could first read the whole omap3isp_prev_wbal structure,
> then I could change just the things I want to change. This seems like it
> would be common functionality for such ioctls. I didn't find any previous
> discussion related to this.
> 
> I could imagine either adding a r/w flag to 'struct
> omap3isp_prev_update_config' or adding a new ioctl entirely. I think I
> would prefer the r/w flag.  Feedback?
> 
> I noticed that other ISP subdevs have similar ioctls.  Perhaps a similar
> thing would be useful there, but right now I'm only looking at the
> previewer.

Adding a R/W bit to the flag argument should indeed work. However, I'm 
wondering what your use case for reading parameters back is. The preview 
engine parameter structures seem pretty-much self-contained to me, I'm not 
sure it would make sense to only modify one of the parameters.

-- 
Regards,

Laurent Pinchart

