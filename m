Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39454 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2GZPzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 11:55:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: #include videodev2.h in omap3isp.h
Date: Thu, 26 Jul 2012 17:55:23 +0200
Message-ID: <5646617.q2lPCR2lR9@avalon>
In-Reply-To: <1343316711-22196-1-git-send-email-michael.jones@matrix-vision.de>
References: <1343316711-22196-1-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Thursday 26 July 2012 17:31:51 Michael Jones wrote:
> include/linux/omap3isp.h uses BASE_VIDIOC_PRIVATE from
> include/linux/videodev2.h but didn't include this file.
> 
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've added the patch to my tree.

> ---
>  include/linux/omap3isp.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/omap3isp.h b/include/linux/omap3isp.h
> index c73a34c..e7a79db 100644
> --- a/include/linux/omap3isp.h
> +++ b/include/linux/omap3isp.h
> @@ -28,6 +28,7 @@
>  #define OMAP3_ISP_USER_H
> 
>  #include <linux/types.h>
> +#include <linux/videodev2.h>
> 
>  /*
>   * Private IOCTLs
-- 
Regards,

Laurent Pinchart

