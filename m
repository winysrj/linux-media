Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47344 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728948AbeHFXNn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 19:13:43 -0400
Message-ID: <6f89eb878e7c7070401e718122617e92577174e8.camel@collabora.com>
Subject: Re: [PATCHv17 31/34] vim2m: support requests
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 06 Aug 2018 18:02:41 -0300
In-Reply-To: <20180804124526.46206-32-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
         <20180804124526.46206-32-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Hans,

Just a small nit.

On Sat, 2018-08-04 at 14:45 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add support for requests to vim2m.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/vim2m.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index 6f87ef025ff1..3b8df2c9d24a 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -379,8 +379,18 @@ static void device_run(void *priv)
>  	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>  	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
>  
> +	/* Apply request controls if needed */
> +	if (src_buf->vb2_buf.req_obj.req)

Seems v4l2_ctrl_request_setup checks for null parameters,
so the check is not needed.

> +		v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +
>  	device_process(ctx, src_buf, dst_buf);
>  
> +	/* Complete request controls if needed */
> +	if (src_buf->vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +
> 

Ditto.
