Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:44054 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbeDLJPu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 05:15:50 -0400
Received: by mail-ua0-f194.google.com with SMTP id r16so3012330uak.11
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 02:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-28-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-28-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@google.com>
Date: Thu, 12 Apr 2018 09:15:38 +0000
Message-ID: <CAAFQd5DsctmO4WNq+WWWK82+1nbwcnFk6aC6g9D0R4o0f4LbAw@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 27/29] vim2m: support requests
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> Add support for requests to vim2m.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   drivers/media/platform/vim2m.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)

> diff --git a/drivers/media/platform/vim2m.c
b/drivers/media/platform/vim2m.c
> index 9b18b32c255d..2dcf0ea85705 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -387,8 +387,26 @@ static void device_run(void *priv)
>          src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>          dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);

> +       /* Apply request if needed */
> +       if (src_buf->vb2_buf.req_obj.req)
> +               v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
> +                                       &ctx->hdl);
> +       if (dst_buf->vb2_buf.req_obj.req &&
> +           dst_buf->vb2_buf.req_obj.req != src_buf->vb2_buf.req_obj.req)
> +               v4l2_ctrl_request_setup(dst_buf->vb2_buf.req_obj.req,
> +                                       &ctx->hdl);

I'm not sure I understand what's going on here. How is it possible that we
have 2 different requests?

Best regards,
Tomasz
