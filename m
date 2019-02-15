Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E202AC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 15:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B97C02192D
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 15:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388540AbfBOPw0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 10:52:26 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57824 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732387AbfBOPwZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 10:52:25 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 5823D273041
Message-ID: <672eb573c6da3c509b8e0bbc074fff0de58b326f.camel@collabora.com>
Subject: Re: [PATCH 1/1] v4l: ioctl: Validate num_planes before using it
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc:     Thierry Reding <treding@nvidia.com>
Date:   Fri, 15 Feb 2019 12:52:14 -0300
In-Reply-To: <20190110124319.22230-1-sakari.ailus@linux.intel.com>
References: <20190110124319.22230-1-sakari.ailus@linux.intel.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-01-10 at 14:43 +0200, Sakari Ailus wrote:
> The for loop to reset the memory of the plane reserved fields runs over
> num_planes provided by the user without validating it. Ensure num_planes
> is no more than VIDEO_MAX_PLANES before the loop.
> 
> Fixes: 4e1e0eb0e074 ("media: v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields")
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi folks,
> 
> This patch goes on top of Thierry's patch "media: v4l2-ioctl: Clear only
> per-plane reserved fields".
> 
>  drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 392f1228af7b5..9e68a608ac6d3 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1551,6 +1551,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> +			break;
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
> @@ -1581,6 +1583,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> +			break;
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
> @@ -1648,6 +1652,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> +			break;
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
> @@ -1678,6 +1684,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> +			break;
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);

I'm under the impression this commit is causing the following v4l2-compliance warning:

TRY_FMT cannot handle an invalid pixelformat.
This may or may not be a problem. For more information see:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html

This applies to try_fmt and s_fmt.

After checking the v4l2 spec, it seems we can only error on a bad type field [1]:

"Drivers should not return an error code unless the type field is invalid".

Perhaps we can clamp num_planes to VIDEO_MAX_PLANES, instead of erroring out?

[1] https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-fmt.html

Regards,
Eze

