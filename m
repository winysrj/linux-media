Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD64C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70E6120861
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfAOJnA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 04:43:00 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58480 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbfAOJnA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 04:43:00 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 63C4E277A6D
Message-ID: <b02d553717a5aabf6eb3cb4281e03db84a83b60b.camel@collabora.com>
Subject: Re: [PATCH RFC 2/4] media: v4l2-mem2mem: Add an optional job_done
 operation
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com
Cc:     Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date:   Tue, 15 Jan 2019 06:42:37 -0300
In-Reply-To: <20190114133839.29967-3-paul.kocialkowski@bootlin.com>
References: <20190114133839.29967-1-paul.kocialkowski@bootlin.com>
         <20190114133839.29967-3-paul.kocialkowski@bootlin.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, 2019-01-14 at 14:38 +0100, Paul Kocialkowski wrote:
> Introduce a new optional job_done operation, which allows calling back
> to the driver when a job is done. Since the job might be completed
> from interrupt context where some operations are not available, having
> a callback from non-atomic context allows performing these operations
> upon completion of a job. This is particularly useful for releasing
> access to a reference buffer, which cannot be done in atomic context.
> 

I'm not exactly sure it makes a lot of sense to review this patch,
since the approach could change.

However, let me point out a few fundamental issues here.
 
> Use the already existing v4l2_m2m_device_run_work work queue for that
> and clear the M2M device current context after calling job_done in the
> worker thread, so that the private data can be passed to the operation.
> 
> Delaying the current context clearing should not be a problem since the
> next call to v4l2_m2m_try_run happens right after that.
> 

Careful here. It's misleading to think an event will happen
"right after". I'd say it's either synchronously, or asynchronously.

It's quite the opposite I'd say, the clearing will happen
"who-knows-when the scheduler picks the thread to run" :-)

Before this patch the curr_ctx was cleared in v4l2_m2m_job_finish,
atomically with the ctx job flags clearing and before waking up
threads waiting in v4l2_m2m_cancel_job.

You are now changing this, by clearing curr_ctx in a worker.
It's perfectly possible that v4l2_m2m_try_schedule will run
before the worker, trying to run with the old context, which
apparently would be safely refused.

> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 8 ++++++--
>  include/media/v4l2-mem2mem.h           | 4 ++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 631f4e2aa942..d5bccb0192f9 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -376,6 +376,11 @@ static void v4l2_m2m_device_run_work(struct work_struct *work)
>  	struct v4l2_m2m_dev *m2m_dev =
>  		container_of(work, struct v4l2_m2m_dev, job_work);
>  
> +	if (m2m_dev->m2m_ops->job_done && m2m_dev->curr_ctx)
> +		m2m_dev->m2m_ops->job_done(m2m_dev->curr_ctx->priv);
> +
> +	m2m_dev->curr_ctx = NULL;
> +

I don't think you can access this without taking the job spinlock.

>  	v4l2_m2m_try_run(m2m_dev);
>  }
> 

Aside from this, it seems we might need this hook sooner or later.

Thanks,
Eze

