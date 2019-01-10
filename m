Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9AFC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FE1A214C6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfAJMIN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 07:08:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:37639 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbfAJMIN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 07:08:13 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 04:08:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,461,1539673200"; 
   d="scan'208";a="105550322"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga007.jf.intel.com with ESMTP; 10 Jan 2019 04:08:11 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 7A031209AC; Thu, 10 Jan 2019 14:08:10 +0200 (EET)
Date:   Thu, 10 Jan 2019 14:08:10 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: v4l2-ioctl: Clear only per-plane reserved fields
Message-ID: <20190110120809.56yubs7k4wxvdzmn@paasikivi.fi.intel.com>
References: <20190110104839.31822-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190110104839.31822-1-thierry.reding@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 10, 2019 at 11:48:39AM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Currently the IOCTL code clears everything after the per-plane
> bytesperline field in struct v4l2_format. The intent was to only clear
> the per-plane reserved fields since there is data in struct v4l2_format
> after the per-plane format data that userspace may have filled in.
> 
> Fixes: 4e1e0eb0e074 ("media: v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields")
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Good catch!

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index df4259802756..e00aa2fe3e8f 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1553,7 +1553,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> -			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
> +			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  		if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
> @@ -1583,7 +1583,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> -			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
> +			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>  		if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
> @@ -1650,7 +1650,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> -			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
> +			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  		if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
> @@ -1680,7 +1680,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> -			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
> +			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>  		if (unlikely(!ops->vidioc_try_fmt_vid_out_overlay))
> -- 
> 2.19.1
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
