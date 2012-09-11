Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33320 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab2IKKlI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 06:41:08 -0400
Received: by obbuo13 with SMTP id uo13so481295obb.19
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 03:41:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347291000-340-6-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
	<1347291000-340-6-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 11 Sep 2012 12:41:08 +0200
Message-ID: <CACKLOr1=uCp_Zuwr7hJbPnAxRx4gAFruXYbsW4vQZA2Aa7KoWA@mail.gmail.com>
Subject: Re: [PATCH v4 05/16] media: coda: ignore coda busy status in coda_job_ready
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
> job_ready is supposed to signal whether a context is ready to be
> added to the job queue, not whether the CODA is ready to run it
> immediately.
> Calling v4l2_m2m_job_finish at the end of coda_irq_handler already
> guarantees that the coda is ready when v4l2-mem2mem eventually tries
> to run the next queued job.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c |    6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index f4b4a6f..d069787 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -738,12 +738,6 @@ static int coda_job_ready(void *m2m_priv)
>                 return 0;
>         }
>
> -       if (coda_isbusy(ctx->dev)) {
> -               v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> -                        "not ready: coda is still busy.\n");
> -               return 0;
> -       }
> -
>         v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>                         "job ready\n");
>         return 1;
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
