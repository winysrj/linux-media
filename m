Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48638 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbaGWNRF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 09:17:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 00/28] IPUv3 prep for video capture
Date: Wed, 23 Jul 2014 15:17:18 +0200
Message-ID: <351532437.crZknhrhTe@avalon>
In-Reply-To: <53C8359C.1030005@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com> <53C7AF39.20608@xs4all.nl> <53C8359C.1030005@mentor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thursday 17 July 2014 13:44:12 Steve Longerbeam wrote:
> On 07/17/2014 04:10 AM, Hans Verkuil wrote:
> > Hi Steve,
> > 
> > I don't know what your plan is, but when you want to mainline this it is
> > the gpu subsystem that needs to review it. I noticed it wasn't
> > cross-posted
> > to the dri-devel mailinglist.
> 
> Hi Hans,
> 
> I'm reworking these patches, I've merged in some of the changes
> posted by Philip Zabel ("[RFC PATCH 00/26] i.MX5/6 IPUv3 CSI/IC"),
> specifically I've decided to use their version of ipu-ic.c, and
> also brought in their video-mux subdev driver. So I'm fine with
> cancelling this patch set.
> 
> When/if I post the reworked v4l2 drivers that implement the media
> entity/device framework I will post the ipu-v3 specific changes
> to dri-devel as well.
> 
> The reason I like Philip's version of ipu-ic is that it implements
> tiling to allow resizing output frames larger than 1024x1024. We
> (Mentor Graphics) did the same IC tiling, but it was done inside
> a separate mem2mem driver. By moving the tiling into ipu-ic, it
> allows >1024x1024 resizing to be part of an imx-ipuv3-ic media
> entity, and this entity can be part of multiple video pipelines
> (capture, video output, mem2mem).
> 
> > I am a bit worried about the amount of v4l2-specific stuff that is going
> > into drivers/gpu/ipu-v3. Do things like csc and csi really belong there
> > instead of under drivers/media?
> 
> The current philosophy of the ipu-v3 driver seems to be that it is a
> library of IPU register-level primitives, so ipu-csi and ipu-ic follow
> that model. There will be nothing v4l2-specific in ipu-csi and ipu-ic,
> although the v4l2 subdev's will be the only clients of ipu-csi and
> ipu-ic.

I have a bit of trouble following up, due to my lack of knowledge of the 
Freescale platforms. It would help if you could explain briefly how the 
various IPU modules interact with each other at the hardware and software 
level, and what the acronyms stand for (I assume IPU means Image Processing 
Unit, CSI means Camera Serial Interface, but I don't know what IC is in this 
context).

Are the CSI receivers linked to the graphics IP cores at the hardware level ?

> > Let me know if this was just preliminary code, or if this was intended to
> > be the final code. I suspect the former.
> 
> This is all been reworked so go ahead and cancel it.

-- 
Regards,

Laurent Pinchart

