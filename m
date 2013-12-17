Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1380 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3LQHc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 02:32:58 -0500
Message-ID: <52AFFE0A.20302@xs4all.nl>
Date: Tue, 17 Dec 2013 08:32:26 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v3 4/7] v4l: define own IOCTL ops for SDR FMT
References: <1387231688-8647-1-git-send-email-crope@iki.fi> <1387231688-8647-5-git-send-email-crope@iki.fi>
In-Reply-To: <1387231688-8647-5-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2013 11:08 PM, Antti Palosaari wrote:
> Use own format ops for SDR data:
> vidioc_enum_fmt_sdr_cap
> vidioc_g_fmt_sdr_cap
> vidioc_s_fmt_sdr_cap
> vidioc_try_fmt_sdr_cap
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  include/media/v4l2-ioctl.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index e0b74a4..8be32f5 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -40,6 +40,8 @@ struct v4l2_ioctl_ops {
>  					      struct v4l2_fmtdesc *f);
>  	int (*vidioc_enum_fmt_vid_out_mplane)(struct file *file, void *fh,
>  					      struct v4l2_fmtdesc *f);
> +	int (*vidioc_enum_fmt_sdr_cap)     (struct file *file, void *fh,
> +					    struct v4l2_fmtdesc *f);
>  
>  	/* VIDIOC_G_FMT handlers */
>  	int (*vidioc_g_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -62,6 +64,8 @@ struct v4l2_ioctl_ops {
>  					   struct v4l2_format *f);
>  	int (*vidioc_g_fmt_vid_out_mplane)(struct file *file, void *fh,
>  					   struct v4l2_format *f);
> +	int (*vidioc_g_fmt_sdr_cap)    (struct file *file, void *fh,
> +					struct v4l2_format *f);
>  
>  	/* VIDIOC_S_FMT handlers */
>  	int (*vidioc_s_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -84,6 +88,8 @@ struct v4l2_ioctl_ops {
>  					   struct v4l2_format *f);
>  	int (*vidioc_s_fmt_vid_out_mplane)(struct file *file, void *fh,
>  					   struct v4l2_format *f);
> +	int (*vidioc_s_fmt_sdr_cap)    (struct file *file, void *fh,
> +					struct v4l2_format *f);
>  
>  	/* VIDIOC_TRY_FMT handlers */
>  	int (*vidioc_try_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -106,6 +112,8 @@ struct v4l2_ioctl_ops {
>  					     struct v4l2_format *f);
>  	int (*vidioc_try_fmt_vid_out_mplane)(struct file *file, void *fh,
>  					     struct v4l2_format *f);
> +	int (*vidioc_try_fmt_sdr_cap)    (struct file *file, void *fh,
> +					  struct v4l2_format *f);
>  
>  	/* Buffer handlers */
>  	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
> 

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
