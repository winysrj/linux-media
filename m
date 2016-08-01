Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44033 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbcHAIe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 04:34:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/3] soc-camera/sh_mobile_csi2: remove unused driver
Date: Mon, 01 Aug 2016 11:34:26 +0300
Message-ID: <8220966.xMzG3XxcmY@avalon>
In-Reply-To: <1470038065-30789-4-git-send-email-hverkuil@xs4all.nl>
References: <1470038065-30789-1-git-send-email-hverkuil@xs4all.nl> <1470038065-30789-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 01 Aug 2016 09:54:25 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The sh_mobile_csi2 isn't used anymore (was it ever?), so remove it.
> Especially since the soc-camera framework is being deprecated.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/soc_camera/Kconfig          |   7 -
>  drivers/media/platform/soc_camera/Makefile         |   1 -
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     | 229 +-----------
>  drivers/media/platform/soc_camera/sh_mobile_csi2.c | 400 ------------------
>  include/media/drv-intf/sh_mobile_ceu.h             |   1 -
>  include/media/drv-intf/sh_mobile_csi2.h            |  48 ---
>  6 files changed, 10 insertions(+), 676 deletions(-)
>  delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_csi2.c
>  delete mode 100644 include/media/drv-intf/sh_mobile_c

Any plan for the sh_mobile_ceu_camera driver by the way ?

-- 
Regards,

Laurent Pinchart

