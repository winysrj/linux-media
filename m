Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46393 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaCJP4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 11:56:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [REVIEW PATCH 0/3] Add g_tvnorms video op
Date: Mon, 10 Mar 2014 16:57:55 +0100
Message-ID: <18601545.kD0Wux3ZFv@avalon>
In-Reply-To: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl>
References: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patches.

On Monday 17 February 2014 12:44:11 Hans Verkuil wrote:
> This patch series addresses a problem that was exposed by commit a5338190e.
> The issue is that soc_camera implements s/g_std ioctls and just forwards
> those to the subdev, whether or not the subdev actually implements them.
> 
> In addition, tvnorms is never set, so even if the subdev implements the
> s/g_std the ENUMSTD ioctl will not report anything.
> 
> The solution is to add a g_tvnorms video op to v4l2_subdev (there was
> already a g_tvnorms_output, so that fits nicely) and to let soc_camera call
> that so the video_device tvnorms field is set correctly.
> 
> Before registering the video node it will check if tvnorms == 0 and disable
> the STD ioctls if that's the case.
> 
> While this problem cropped up in soc_camera it is really a problem for any
> generic bridge driver, so this is useful to have.
> 
> Note that it is untested. The plan is that Laurent tests and Guennadi pulls
> it into his tree.

I've tested the series on v3.10 with the atmel-isi driver. Without the patches 
applied ENUMSTD returns -ENODATA, and with the patches applied it returns -
ENOTTY.

Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

