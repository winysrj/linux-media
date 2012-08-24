Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50606 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab2HXGWg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 02:22:36 -0400
Received: by wibhr14 with SMTP id hr14so489830wib.1
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2012 23:22:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345727311-27478-7-git-send-email-elezegarcia@gmail.com>
References: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
	<1345727311-27478-7-git-send-email-elezegarcia@gmail.com>
Date: Fri, 24 Aug 2012 08:22:35 +0200
Message-ID: <CACKLOr0-1QncE17Ufr1m0zn47ZOZoG6dtOusNq+_hO+D8SOLhg@mail.gmail.com>
Subject: Re: [PATCH 07/10] mem2mem-emmaprp: Remove unneeded struct vb2_queue
 clear on queue_init()
From: javier Martin <javier.martin@vista-silicon.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 August 2012 15:08, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> queue_init() is always called by v4l2_m2m_ctx_init(), which allocates
> a context struct v4l2_m2m_ctx with kzalloc.
> Therefore, there is no need to clear vb2_queue src/dst structs.
>
> Cc: Javier Martin <javier.martin@vista-silicon.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>  drivers/media/platform/mx2_emmaprp.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
> index dab380a..59aaca4 100644
> --- a/drivers/media/platform/mx2_emmaprp.c
> +++ b/drivers/media/platform/mx2_emmaprp.c
> @@ -757,7 +757,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>         struct emmaprp_ctx *ctx = priv;
>         int ret;
>
> -       memset(src_vq, 0, sizeof(*src_vq));
>         src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>         src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
>         src_vq->drv_priv = ctx;
> @@ -769,7 +768,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>         if (ret)
>                 return ret;
>
> -       memset(dst_vq, 0, sizeof(*dst_vq));
>         dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>         dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
>         dst_vq->drv_priv = ctx;
> --
> 1.7.8.6
>

Acked-By: Javier Martin <javier.martin@vista-silicon.com>

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
