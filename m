Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48563 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2HUIfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 04:35:43 -0400
Received: by wicr5 with SMTP id r5so4439819wic.1
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 01:35:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345531662-16990-1-git-send-email-richard.zhao@freescale.com>
References: <1345531662-16990-1-git-send-email-richard.zhao@freescale.com>
Date: Tue, 21 Aug 2012 10:35:41 +0200
Message-ID: <CACKLOr37yU-Lsbh+gKuzUG44a9s8s-ur5Fw74Tay=R8fDRBfGg@mail.gmail.com>
Subject: Re: [PATCH] media: coda: remove duplicated call of fh_to_ctx in vidioc_s_fmt_vid_out
From: javier Martin <javier.martin@vista-silicon.com>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.nawrocki@samsung.com, p.zabel@pengutronix.de,
	hans.verkuil@cisco.com, nfleischmann@de.adit-jv.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 August 2012 08:47, Richard Zhao <richard.zhao@freescale.com> wrote:
> Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
> ---
>  drivers/media/platform/coda.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 6908514..69ff0d3 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -501,7 +501,7 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
>         if (ret)
>                 return ret;
>
> -       ret = vidioc_s_fmt(fh_to_ctx(priv), f);
> +       ret = vidioc_s_fmt(ctx, f);
>         if (ret)
>                 ctx->colorspace = f->fmt.pix.colorspace;
>
> --
> 1.7.9.5
>
>

Good catch.

Acked-by: Javier Martin <javier.martin@vista-silicon.com>

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
