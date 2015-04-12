Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44260 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbbDLNDI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2015 09:03:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 7/7] v4l2: remove g/s_crop and cropcap from video ops
Date: Sun, 12 Apr 2015 16:03:35 +0300
Message-ID: <5051108.JvQ4aMPQqk@avalon>
In-Reply-To: <1428574888-46407-8-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl> <1428574888-46407-8-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 09 April 2015 12:21:28 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Replace all calls to g/s_crop and cropcap by calls to the
> get/set_selection pad ops.
> 
> Remove the old g/s_crop and cropcap video ops since they are now no
> longer used.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/ak881x.c                         |  28 +++--
>  drivers/media/i2c/soc_camera/imx074.c              |  42 +++----
>  drivers/media/i2c/soc_camera/mt9m001.c             |  70 ++++++-----
>  drivers/media/i2c/soc_camera/mt9m111.c             |  57 ++++-----
>  drivers/media/i2c/soc_camera/mt9t031.c             |  52 +++++----
>  drivers/media/i2c/soc_camera/mt9t112.c             |  60 +++++-----
>  drivers/media/i2c/soc_camera/mt9v022.c             |  68 ++++++-----
>  drivers/media/i2c/soc_camera/ov2640.c              |  41 +++----
>  drivers/media/i2c/soc_camera/ov5642.c              |  53 +++++----
>  drivers/media/i2c/soc_camera/ov6650.c              |  74 ++++++------
>  drivers/media/i2c/soc_camera/ov772x.c              |  44 ++++---
>  drivers/media/i2c/soc_camera/ov9640.c              |  41 +++----
>  drivers/media/i2c/soc_camera/ov9740.c              |  41 +++----
>  drivers/media/i2c/soc_camera/rj54n1cb0c.c          |  52 +++++----
>  drivers/media/i2c/soc_camera/tw9910.c              |  47 +++-----
>  drivers/media/i2c/tvp5150.c                        |  81 +++++++------
>  drivers/media/platform/omap3isp/ispvideo.c         |  88 +++++++++-----

The OMAP3 ISP set crop implementation (as well as the OMAP4 ISS 
implementation, as the code has been copied) is a leftover that should be 
removed. Your patch doesn't hurt though, so

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

for those two drivers.

I'll post a separate patch to remove set_selection on top of this patch 
series.

>  drivers/media/platform/sh_vou.c                    |  13 ++-
>  drivers/media/platform/soc_camera/mx2_camera.c     |  18 ++-
>  drivers/media/platform/soc_camera/mx3_camera.c     |  18 ++-
>  drivers/media/platform/soc_camera/omap1_camera.c   |  23 ++--
>  drivers/media/platform/soc_camera/pxa_camera.c     |  17 ++-
>  drivers/media/platform/soc_camera/rcar_vin.c       |  26 ++---
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |  32 +++--
>  drivers/media/platform/soc_camera/soc_camera.c     | 130 +++++-------------
>  .../platform/soc_camera/soc_camera_platform.c      |  45 +++----
>  drivers/media/platform/soc_camera/soc_scale_crop.c |  85 ++++++++------
>  drivers/media/platform/soc_camera/soc_scale_crop.h |   6 +-
>  drivers/staging/media/omap4iss/iss_video.c         |  88 +++++++++-----
>  include/media/soc_camera.h                         |   7 +-
>  include/media/v4l2-subdev.h                        |   3 -
>  31 files changed, 735 insertions(+), 715 deletions(-)

-- 
Regards,

Laurent Pinchart

