Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55946 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab2IKKlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 06:41:46 -0400
Received: by obbuo13 with SMTP id uo13so481909obb.19
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 03:41:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347291000-340-8-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
	<1347291000-340-8-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 11 Sep 2012 12:41:45 +0200
Message-ID: <CACKLOr3e+FL=0zJPOJvh2YMudEedrFFEeLeaTFZdPt6mP1dxAA@mail.gmail.com>
Subject: Re: [PATCH v4 07/16] media: coda: stop all queues in case of lockup
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
> Add a 1 second timeout for each PIC_RUN command to the CODA. In
> case it locks up, stop all queues and dequeue remaining buffers.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v3:
>  - Add struct coda_dev *dev pointer in coda_start_streaming.
>  - Call cancel_delayed_work in coda_stop_streaming and in coda_irq_handler.
>  - Lock the device mutex in coda_timeout to avoid a race with coda_release.
> ---
>  drivers/media/platform/coda.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 159df08..7f6ec3a 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -136,6 +136,7 @@ struct coda_dev {
>         struct vb2_alloc_ctx    *alloc_ctx;
>         struct list_head        instances;
>         unsigned long           instance_mask;
> +       struct delayed_work     timeout;
>  };
>
>  struct coda_params {
> @@ -722,6 +723,9 @@ static void coda_device_run(void *m2m_priv)
>                                 CODA7_REG_BIT_AXI_SRAM_USE);
>         }
>
> +       /* 1 second timeout in case CODA locks up */
> +       schedule_delayed_work(&dev->timeout, HZ);
> +
>         coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
>  }
>
> @@ -1208,6 +1212,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
>  static int coda_stop_streaming(struct vb2_queue *q)
>  {
>         struct coda_ctx *ctx = vb2_get_drv_priv(q);
> +       struct coda_dev *dev = ctx->dev;
>
>         if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
>                 v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> @@ -1220,6 +1225,8 @@ static int coda_stop_streaming(struct vb2_queue *q)
>         }
>
>         if (!ctx->rawstreamon && !ctx->compstreamon) {
> +               cancel_delayed_work(&dev->timeout);
> +
>                 v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>                          "%s: sent command 'SEQ_END' to coda\n", __func__);
>                 if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
> @@ -1492,6 +1499,8 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
>         u32 wr_ptr, start_ptr;
>         struct coda_ctx *ctx;
>
> +       __cancel_delayed_work(&dev->timeout);
> +
>         /* read status register to attend the IRQ */
>         coda_read(dev, CODA_REG_BIT_INT_STATUS);
>         coda_write(dev, CODA_REG_BIT_INT_CLEAR_SET,
> @@ -1564,6 +1573,22 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
>         return IRQ_HANDLED;
>  }
>
> +static void coda_timeout(struct work_struct *work)
> +{
> +       struct coda_ctx *ctx;
> +       struct coda_dev *dev = container_of(to_delayed_work(work),
> +                                           struct coda_dev, timeout);
> +
> +       v4l2_err(&dev->v4l2_dev, "CODA PIC_RUN timeout, stopping all streams\n");
> +
> +       mutex_lock(&dev->dev_mutex);
> +       list_for_each_entry(ctx, &dev->instances, list) {
> +               v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +               v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +       }
> +       mutex_unlock(&dev->dev_mutex);
> +}
> +
>  static u32 coda_supported_firmwares[] = {
>         CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
>         CODA_FIRMWARE_VERNUM(CODA_7541, 13, 4, 29),
> @@ -1835,6 +1860,7 @@ static int __devinit coda_probe(struct platform_device *pdev)
>
>         spin_lock_init(&dev->irqlock);
>         INIT_LIST_HEAD(&dev->instances);
> +       INIT_DELAYED_WORK(&dev->timeout, coda_timeout);
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
