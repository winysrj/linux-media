Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55770 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbeK3GWx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 01:22:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        rajmohan.mani@intel.com, jian.xu.zheng@intel.com,
        jerry.w.hu@intel.com, tuukka.toivonen@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com
Subject: Re: [PATCH v7 01/16] v4l: Add Intel IPU3 meta buffer formats
Date: Thu, 29 Nov 2018 21:16:51 +0200
Message-ID: <3858085.x2vJft3ZLq@avalon>
In-Reply-To: <1540851790-1777-2-git-send-email-yong.zhi@intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <1540851790-1777-2-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Yong,

Thank you for the patch.

On Tuesday, 30 October 2018 00:22:55 EET Yong Zhi wrote:
> Add IPU3-specific meta formats for parameter
> processing and 3A, DVS statistics:

Unless I'm mistaken DVS support has been removed. You can write this as

Add IPU3-specific meta formats for processing parameters and 3A
statistics.

> 
>   V4L2_META_FMT_IPU3_PARAMS
>   V4L2_META_FMT_IPU3_STAT_3A
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 2 ++
>  include/uapi/linux/videodev2.h       | 4 ++++
>  2 files changed, 6 insertions(+)

I would squash this with patch 03/16.

> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index 6489f25..abff64b 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1299,6 +1299,8 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
> case V4L2_META_FMT_VSP1_HGO:	descr = "R-Car VSP1 1-D Histogram"; break;
> case V4L2_META_FMT_VSP1_HGT:	descr = "R-Car VSP1 2-D Histogram"; break;
> case V4L2_META_FMT_UVC:		descr = "UVC payload header metadata"; break;
> +	case V4L2_META_FMT_IPU3_PARAMS:	descr = "IPU3 processing parameters";
> break;
> +	case V4L2_META_FMT_IPU3_STAT_3A:	descr = "IPU3 3A statistics"; break;
> 
>  	default:
>  		/* Compressed formats */
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index f0a968a..bdccd7a 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -718,6 +718,10 @@ struct v4l2_pix_format {
>  #define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC
> Payload Header metadata */ #define V4L2_META_FMT_D4XX       
> v4l2_fourcc('D', '4', 'X', 'X') /* D4XX Payload Header metadata */
> 
> +/* Vendor specific - used for IPU3 camera sub-system */
> +#define V4L2_META_FMT_IPU3_PARAMS	v4l2_fourcc('i', 'p', '3', 'p') /* IPU3
> params */

Maybe "IPU3 processing parameters" in full ?

Apart from that the patch looks good to me.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +#define V4L2_META_FMT_IPU3_STAT_3A	v4l2_fourcc('i', 'p', '3', 's') /* IPU3
> 3A statistics */
> +
>  /* priv field value to indicates that subsequent fields are valid. */
>  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe


-- 
Regards,

Laurent Pinchart
