Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f54.google.com ([209.85.160.54]:36542 "EHLO
        mail-pl0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbeFDRP6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 13:15:58 -0400
Received: by mail-pl0-f54.google.com with SMTP id v24-v6so20099307plo.3
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 10:15:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180604114648.26159-33-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl> <20180604114648.26159-33-hverkuil@xs4all.nl>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Mon, 4 Jun 2018 14:15:57 -0300
Message-ID: <CAAEAJfAqvcKDM3oYUR8BhLrEE8W1sOeRnWJ1s7Z1gqR1E0okLQ@mail.gmail.com>
Subject: Re: [PATCHv15 32/35] vim2m: support requests
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 June 2018 at 08:46, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Add support for requests to vim2m.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/vim2m.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2=
m.c
> index 5cb077294734..1efc8033320f 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -380,8 +380,18 @@ static void device_run(void *priv)
>         src_buf =3D v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>         dst_buf =3D v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
>
> +       /* Apply request controls if needed */
> +       if (src_buf->vb2_buf.req_obj.req)

Nit: it seems we don't need this check?

> +               v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
> +                                       &ctx->hdl);
> +
>         device_process(ctx, src_buf, dst_buf);
>
> +       /* Complete request controls if needed */
> +       if (src_buf->vb2_buf.req_obj.req)

Ditto.

> +               v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
> +                                       &ctx->hdl);
> +
>         /* Run delayed work, which simulates a hardware irq  */
>         schedule_delayed_work(&dev->work_run, msecs_to_jiffies(ctx->trans=
time));
>  }


--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
