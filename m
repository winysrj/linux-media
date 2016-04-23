Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35339 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbcDWAW4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 20:22:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCHv3 08/12] media/platform: convert drivers to use the new vb2_queue dev field
Date: Sat, 23 Apr 2016 03:23:15 +0300
Message-ID: <3227056.FQFfBplq5V@avalon>
In-Reply-To: <1461314299-36126-9-git-send-email-hverkuil@xs4all.nl>
References: <1461314299-36126-1-git-send-email-hverkuil@xs4all.nl> <1461314299-36126-9-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 22 Apr 2016 10:38:15 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Stop using alloc_ctx and just fill in the device pointer.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Javier Martin <javier.martin@vista-silicon.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/platform/m2m-deinterlace.c        | 15 ++-------------
>  drivers/media/platform/marvell-ccic/mcam-core.c | 24 +--------------------
>  drivers/media/platform/marvell-ccic/mcam-core.h |  2 --
>  drivers/media/platform/mx2_emmaprp.c            | 17 +++--------------
>  drivers/media/platform/omap3isp/ispvideo.c      | 12 ++----------
>  drivers/media/platform/omap3isp/ispvideo.h      |  1 -
>  drivers/media/platform/rcar_jpu.c               | 22 ++++------------------
>  drivers/media/platform/sh_veu.c                 | 17 +++--------------
>  drivers/media/platform/sh_vou.c                 | 14 ++------------
>  9 files changed, 17 insertions(+), 107 deletions(-)

For the omap3isp and rcar_jpu drivers, pending a fix for the problem I 
mentioned in a reply to patch 01/12,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

