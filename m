Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43758 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2DRKEw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 06:04:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: V4L: mt9m032: fix compilation breakage
Date: Wed, 18 Apr 2012 12:05:01 +0200
Message-ID: <4280495.q2ukDEsUSN@avalon>
In-Reply-To: <Pine.LNX.4.64.1204180930170.30514@axis700.grange>
References: <Pine.LNX.4.64.1204180930170.30514@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Wednesday 18 April 2012 09:59:01 Guennadi Liakhovetski wrote:
> Fix the following compilation failure:
> 
> linux-2.6/drivers/media/video/mt9m032.c: In function
> '__mt9m032_get_pad_crop': linux-2.6/drivers/media/video/mt9m032.c:337:
> error: implicit declaration of function 'v4l2_subdev_get_try_crop'
> linux-2.6/drivers/media/video/mt9m032.c:337: warning: return makes pointer
> from integer without a cast linux-2.6/drivers/media/video/mt9m032.c: In
> function '__mt9m032_get_pad_format':
> linux-2.6/drivers/media/video/mt9m032.c:359: error: implicit declaration of
> function 'v4l2_subdev_get_try_format'
> linux-2.6/drivers/media/video/mt9m032.c:359: warning: return makes pointer
> from integer without a cast linux-2.6/drivers/media/video/mt9m032.c: In
> function 'mt9m032_probe': linux-2.6/drivers/media/video/mt9m032.c:767:
> error: 'struct v4l2_subdev' has no member named 'entity'
> linux-2.6/drivers/media/video/mt9m032.c:826: error: 'struct v4l2_subdev'
> has no member named 'entity' linux-2.6/drivers/media/video/mt9m032.c: In
> function 'mt9m032_remove': linux-2.6/drivers/media/video/mt9m032.c:842:
> error: 'struct v4l2_subdev' has no member named 'entity' make[4]: ***
> [drivers/media/video/mt9m032.o] Error 1
> 
> by adding a dependency on VIDEO_V4L2_SUBDEV_API.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Applied to my tree.

-- 
Regards,

Laurent Pinchart

