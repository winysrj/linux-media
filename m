Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3032 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaCKMX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 08:23:58 -0400
Message-ID: <531F0029.3040906@xs4all.nl>
Date: Tue, 11 Mar 2014 13:23:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: k.debski@samsung.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 09/14] v4l: ti-vpe: report correct capabilities in
 querycap
References: <1393922965-15967-1-git-send-email-archit@ti.com> <1394526833-24805-1-git-send-email-archit@ti.com> <1394526833-24805-10-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-10-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/14 09:33, Archit Taneja wrote:
> querycap currently returns V4L2_CAP_VIDEO_M2M as a capability, this should be
> V4L2_CAP_VIDEO_M2M_MPLANE instead, as the driver supports multiplanar formats.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/platform/ti-vpe/vpe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 4abb85c..46b9d44 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1347,7 +1347,7 @@ static int vpe_querycap(struct file *file, void *priv,
>  	strncpy(cap->driver, VPE_MODULE_NAME, sizeof(cap->driver) - 1);
>  	strncpy(cap->card, VPE_MODULE_NAME, sizeof(cap->card) - 1);
>  	strlcpy(cap->bus_info, VPE_MODULE_NAME, sizeof(cap->bus_info));
> -	cap->device_caps  = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
> +	cap->device_caps  = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
>  	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>  	return 0;
>  }
> 

