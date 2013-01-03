Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54006 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3ACK7U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 05:59:20 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG100HLBQIVCKX0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Jan 2013 19:59:19 +0900 (KST)
Received: from amdc1227.localnet ([106.116.147.199])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG100FWZQITKH90@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Jan 2013 19:59:19 +0900 (KST)
From: Tomasz Figa <t.figa@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Vikas C Sajjan <vikas.sajjan@linaro.org>,
	linux-media@vger.kernel.org, tomi.valkeinen@ti.com,
	laurent.pinchart@ideasonboard.com, aditya.ps@samsung.com
Subject: Re: [PATCH 2/2] [RFC] video: display: Adding frame related ops to MIPI
	DSI video source struct
Date: Thu, 03 Jan 2013 11:59:13 +0100
Message-id: <67872310.6yRVsVsClR@amdc1227>
In-reply-to: <1357132642-24588-3-git-send-email-vikas.sajjan@linaro.org>
References: <1357132642-24588-1-git-send-email-vikas.sajjan@linaro.org>
 <1357132642-24588-3-git-send-email-vikas.sajjan@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikas,

On Wednesday 02 of January 2013 18:47:22 Vikas C Sajjan wrote:
> From: Vikas Sajjan <vikas.sajjan@linaro.org>
> 
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  include/video/display.h |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/video/display.h b/include/video/display.h
> index b639fd0..fb2f437 100644
> --- a/include/video/display.h
> +++ b/include/video/display.h
> @@ -117,6 +117,12 @@ struct dsi_video_source_ops {
> 
>  	void (*enable_hs)(struct video_source *src, bool enable);
> 
> +	/* frame related */
> +	int (*get_frame_done)(struct video_source *src);
> +	int (*clear_frame_done)(struct video_source *src);
> +	int (*set_early_blank_mode)(struct video_source *src, int power);
> +	int (*set_blank_mode)(struct video_source *src, int power);
> +

I'm not sure if all those extra ops are needed in any way.

Looking and Exynos MIPI DSIM driver, set_blank_mode is handling only 
FB_BLANK_UNBLANK status, which basically equals to the already existing 
enable operation, while set_early_blank mode handles only 
FB_BLANK_POWERDOWN, being equal to disable callback.

Both get_frame_done and clear_frame_done do not look at anything used at 
the moment and if frame done status monitoring will be ever needed, I 
think a better way should be implemented.

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Linux Platform

