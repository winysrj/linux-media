Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62128 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2IKKl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 06:41:26 -0400
Received: by oago6 with SMTP id o6so147876oag.19
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 03:41:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347291000-340-7-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
	<1347291000-340-7-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 11 Sep 2012 12:41:25 +0200
Message-ID: <CACKLOr0WWxxKoY7y25gZ5kDqSkFaCmgZv3ktmGwGit_kr4swhg@mail.gmail.com>
Subject: Re: [PATCH v4 06/16] media: coda: keep track of active instances
From: javier Martin <javier.martin@vista-silicon.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 September 2012 17:29, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Determining the next free instance just by incrementing and decrementing
> an instance counter does not work: if there are two instances opened,
> 0 and 1, and instance 0 is released, the next call to coda_open will
> create a new instance with index 1, but instance 1 is already in use.
>
> Instead, scan a bitfield of active instances to determine the first
> free instance index.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c |   21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index d069787..159df08 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -134,7 +134,8 @@ struct coda_dev {
>         struct mutex            dev_mutex;
>         struct v4l2_m2m_dev     *m2m_dev;
>         struct vb2_alloc_ctx    *alloc_ctx;
> -       int                     instances;
> +       struct list_head        instances;
> +       unsigned long           instance_mask;
>  };
>
>  struct coda_params {
> @@ -152,6 +153,7 @@ struct coda_params {
>
>  struct coda_ctx {
>         struct coda_dev                 *dev;
> +       struct list_head                list;
>         int                             aborting;
>         int                             rawstreamon;
>         int                             compstreamon;
> @@ -1357,14 +1359,22 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>         return vb2_queue_init(dst_vq);
>  }
>
> +static int coda_next_free_instance(struct coda_dev *dev)
> +{
> +       return ffz(dev->instance_mask);
> +}
> +
>  static int coda_open(struct file *file)
>  {
>         struct coda_dev *dev = video_drvdata(file);
>         struct coda_ctx *ctx = NULL;
>         int ret = 0;
> +       int idx;
>
> -       if (dev->instances >= CODA_MAX_INSTANCES)
> +       idx = coda_next_free_instance(dev);
> +       if (idx >= CODA_MAX_INSTANCES)
>                 return -EBUSY;
> +       set_bit(idx, &dev->instance_mask);
>
>         ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
>         if (!ctx)
> @@ -1374,6 +1384,7 @@ static int coda_open(struct file *file)
>         file->private_data = &ctx->fh;
>         v4l2_fh_add(&ctx->fh);
>         ctx->dev = dev;
> +       ctx->idx = idx;
>
>         set_default_params(ctx);
>         ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
> @@ -1402,7 +1413,7 @@ static int coda_open(struct file *file)
>         }
>
>         coda_lock(ctx);
> -       ctx->idx = dev->instances++;
> +       list_add(&ctx->list, &dev->instances);
>         coda_unlock(ctx);
>
>         clk_prepare_enable(dev->clk_per);
> @@ -1429,7 +1440,7 @@ static int coda_release(struct file *file)
>                  ctx);
>
>         coda_lock(ctx);
> -       dev->instances--;
> +       list_del(&ctx->list);
>         coda_unlock(ctx);
>
>         dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
> @@ -1440,6 +1451,7 @@ static int coda_release(struct file *file)
>         clk_disable_unprepare(dev->clk_ahb);
>         v4l2_fh_del(&ctx->fh);
>         v4l2_fh_exit(&ctx->fh);
> +       clear_bit(ctx->idx, &dev->instance_mask);
>         kfree(ctx);
>
>         return 0;
> @@ -1822,6 +1834,7 @@ static int __devinit coda_probe(struct platform_device *pdev)
>         }
>
>         spin_lock_init(&dev->irqlock);
> +       INIT_LIST_HEAD(&dev->instances);
>
>         dev->plat_dev = pdev;
>         dev->clk_per = devm_clk_get(&pdev->dev, "per");
> --
> 1.7.10.4
>

Tested-by: Javier Martin <javier.martin@vista-silicon.com

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
