Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E0DC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 11:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43887214DA
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 11:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbfAJLrv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:47:51 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:34187 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728484AbfAJLrv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 06:47:51 -0500
Received: from [IPv6:2001:420:44c1:2579:595e:33cd:95d8:785f] ([IPv6:2001:420:44c1:2579:595e:33cd:95d8:785f])
        by smtp-cloud9.xs4all.net with ESMTPA
        id hYoLgajKDMWvEhYoOgWzWA; Thu, 10 Jan 2019 12:47:49 +0100
Subject: Re: [PATCH] media: v4l2-ioctl: Clear only per-plane reserved fields
To:     Thierry Reding <thierry.reding@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20190110104839.31822-1-thierry.reding@gmail.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <b5246e43-ccf2-a507-9d89-325f3570783f@xs4all.nl>
Date:   Thu, 10 Jan 2019 12:47:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190110104839.31822-1-thierry.reding@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMGtVPLZ58ecyYVaP2B0p2UY8khUBU8X6gRRWLgHgbSlghXBcyMaH9onQMQ5BMKS+UW2Os+W/b2Ofzw2u77c5CecAkfZYRBB65fS/xtwblIEnKzi37RT
 kXqMpVZ5dYW6YQG5yAlAB/3sA6I78v/NC9OOXRPqxrOXg3ZicVyhzZWKbeprtjspOs2RSY0cuUWZcc2ezT4YHMhk9GnB7xailUuUDbJLuuUGzkBzo+7q+dhl
 Lw+qKynW9foFUw+KVUON2zC/7lpvkIkOA8vBFYkQpiJ8mx6Tr/GtjrvfgMlci0oJ2M1Z+K4iGQoPwqvWr6UhzELN8hAu9FtWKdvL8XmVWZbUt+guPTp+urnv
 zTW7lW1EUxqqMWyH483ak4P2A51W4yKr8ZzV4thMEYpihGo6aB4lvNgMCthlJMT4LagFVjtxAuc7whFllEtYnimmm9zdhFjQgZjQP4BqrLy0XertEiaCgk8o
 iHGRyMGhroG3bAdj
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/10/19 11:48, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Currently the IOCTL code clears everything after the per-plane
> bytesperline field in struct v4l2_format. The intent was to only clear
> the per-plane reserved fields since there is data in struct v4l2_format
> after the per-plane format data that userspace may have filled in.
> 
> Fixes: 4e1e0eb0e074 ("media: v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields")
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Erm, oops! I should have seen that when reviewing that patch.

I'll make a pull request for 5.0 asap.

Thank you,

	Hans

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
> 

