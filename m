Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38701 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab2ICMBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 08:01:14 -0400
Received: by wibhr14 with SMTP id hr14so3971592wib.1
        for <linux-media@vger.kernel.org>; Mon, 03 Sep 2012 05:01:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346400670-16002-8-git-send-email-p.zabel@pengutronix.de>
References: <1346400670-16002-1-git-send-email-p.zabel@pengutronix.de>
	<1346400670-16002-8-git-send-email-p.zabel@pengutronix.de>
Date: Mon, 3 Sep 2012 14:01:12 +0200
Message-ID: <CACKLOr1jbotK2z4icas+1DGANGh=0xykBxXCTSGfVay6zq647A@mail.gmail.com>
Subject: Re: [PATCH v3 07/16] media: coda: stop all queues in case of lockup
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

Hi Philipp,

On 31 August 2012 10:11, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Add a 1 second timeout for each PIC_RUN command to the CODA. In
> case it locks up, stop all queues and dequeue remaining buffers.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v2:
>  - Call cancel_delayed_work in coda_stop_streaming instead of coda_irq_handler.
> ---
>  drivers/media/platform/coda.c |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 7bc2d87..6e3f026 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -137,6 +137,7 @@ struct coda_dev {
>         struct vb2_alloc_ctx    *alloc_ctx;
>         struct list_head        instances;
>         unsigned long           instance_mask;
> +       struct delayed_work     timeout;
>  };
>
>  struct coda_params {
> @@ -723,6 +724,9 @@ static void coda_device_run(void *m2m_priv)
>                                 CODA7_REG_BIT_AXI_SRAM_USE);
>         }
>
> +       /* 1 second timeout in case CODA locks up */
> +       schedule_delayed_work(&dev->timeout, HZ);
> +
>         coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
>  }
>
> @@ -1221,6 +1225,8 @@ static int coda_stop_streaming(struct vb2_queue *q)
>         }
>
>         if (!ctx->rawstreamon && !ctx->compstreamon) {
> +               cancel_delayed_work(&dev->timeout);
> +

This breaks compilation. There is no such variable 'dev' in this
function at this time.
I see you add it later in patch 9 but I think we should avoid breaking
bisect as long as possible.

  CC      drivers/media/video/coda.o
drivers/media/video/coda.c: In function 'coda_stop_streaming':
drivers/media/video/coda.c:1227: error: 'dev' undeclared (first use in
this function)
drivers/media/video/coda.c:1227: error: (Each undeclared identifier is
reported only once
drivers/media/video/coda.c:1227: error: for each function it appears in.)

Could you please add it in this patch instead?


>                 v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>                          "%s: sent command 'SEQ_END' to coda\n", __func__);
>                 if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
> @@ -1565,6 +1571,20 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
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
> +       list_for_each_entry(ctx, &dev->instances, list) {
> +               v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +               v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +       }
> +}
> +
>  static u32 coda_supported_firmwares[] = {
>         CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
>         CODA_FIRMWARE_VERNUM(CODA_7541, 13, 4, 29),
> @@ -1836,6 +1856,7 @@ static int __devinit coda_probe(struct platform_device *pdev)
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



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
