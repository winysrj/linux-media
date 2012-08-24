Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46753 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2HXGVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 02:21:49 -0400
Received: by weyx8 with SMTP id x8so830016wey.19
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2012 23:21:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345727311-27478-5-git-send-email-elezegarcia@gmail.com>
References: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
	<1345727311-27478-5-git-send-email-elezegarcia@gmail.com>
Date: Fri, 24 Aug 2012 08:21:48 +0200
Message-ID: <CACKLOr0qdyvKt7D_Xnx4ZefgVEd5fHp11j-RCBebV8=JzuEHAw@mail.gmail.com>
Subject: Re: [PATCH 05/10] coda: Remove unneeded struct vb2_queue clear on queue_init()
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
>  drivers/media/platform/coda.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 6908514..3ea822f 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1249,7 +1249,6 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>         struct coda_ctx *ctx = priv;
>         int ret;
>
> -       memset(src_vq, 0, sizeof(*src_vq));
>         src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>         src_vq->io_modes = VB2_MMAP;
>         src_vq->drv_priv = ctx;
> @@ -1261,7 +1260,6 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>         if (ret)
>                 return ret;
>
> -       memset(dst_vq, 0, sizeof(*dst_vq));
>         dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>         dst_vq->io_modes = VB2_MMAP;
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
