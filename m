Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33734 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2KSWGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 17:06:38 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1380198eek.19
        for <linux-media@vger.kernel.org>; Mon, 19 Nov 2012 14:06:37 -0800 (PST)
Message-ID: <50AAAD6A.80709@gmail.com>
Date: Mon, 19 Nov 2012 23:06:34 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, shaik.samsung@gmail.com,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] [media] exynos-gsc: propagate timestamps from src to
 dst buffers
References: <1352270424-14683-1-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1352270424-14683-1-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 11/07/2012 07:40 AM, Shaik Ameer Basha wrote:
> Make gsc-m2m propagate the timestamp field from source to destination
> buffers

We probably need some means for letting know the mem-to-mem drivers and
applications whether timestamps are copied from OUTPUT to CAPTURE or not.
Timestamps at only OUTPUT interface are normally used to control buffer
processing time [1].


"struct timeval	timestamp	 	

For input streams this is the system time (as returned by the 
gettimeofday()
function) when the first data byte was captured. For output streams the 
data
will not be displayed before this time, secondary to the nominal frame rate
determined by the current video standard in enqueued order. Applications 
can
for example zero this field to display frames as soon as possible. The 
driver
stores the time at which the first data byte was actually sent out in the
timestamp field. This permits applications to monitor the drift between the
video and system clock."

In some use cases it might be useful to know exact frame processing time,
where driver would be filling OUTPUT and CAPTURE value with exact monotonic
clock values corresponding to a frame processing start and end time.

[1] http://linuxtv.org/downloads/v4l-dvb-apis/buffer.html#v4l2-buffer

For the time being I'm OK with this patch, just one comment below...

> Signed-off-by: John Sheu<sheu@google.com>
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> ---
>   drivers/media/platform/exynos-gsc/gsc-m2m.c |   19 ++++++++++++-------
>   1 files changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> index 047f0f0..1139276 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> @@ -99,22 +99,27 @@ static void gsc_m2m_job_abort(void *priv)
>   		gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
>   }
>
> -static int gsc_fill_addr(struct gsc_ctx *ctx)
> +static int gsc_get_bufs(struct gsc_ctx *ctx)
>   {
>   	struct gsc_frame *s_frame, *d_frame;
> -	struct vb2_buffer *vb = NULL;
> +	struct vb2_buffer *src_vb, *dst_vb;
>   	int ret;
>
>   	s_frame =&ctx->s_frame;
>   	d_frame =&ctx->d_frame;
>
> -	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> -	ret = gsc_prepare_addr(ctx, vb, s_frame,&s_frame->addr);
> +	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	ret = gsc_prepare_addr(ctx, src_vb, s_frame,&s_frame->addr);

Might be better to just return any error code

    	if (ret)
   		return ret;

> +	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +	ret |= gsc_prepare_addr(ctx, dst_vb, d_frame,&d_frame->addr);

...rather than obfuscating the return value here.

>   	if (ret)
>   		return ret;
>
> -	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> -	return gsc_prepare_addr(ctx, vb, d_frame,&d_frame->addr);
> +	memcpy(&dst_vb->v4l2_buf.timestamp,&src_vb->v4l2_buf.timestamp,
> +		sizeof(dst_vb->v4l2_buf.timestamp));

Is there any advantage of memcpy over simple assignment

	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;

?
> +	return 0;
>   }
>
>   static void gsc_m2m_device_run(void *priv)
> @@ -148,7 +153,7 @@ static void gsc_m2m_device_run(void *priv)
>   		goto put_device;
>   	}
>
> -	ret = gsc_fill_addr(ctx);
> +	ret = gsc_get_bufs(ctx);
>   	if (ret) {
>   		pr_err("Wrong address");
>   		goto put_device;

--

Thanks,
Sylwester
