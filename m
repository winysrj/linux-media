Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6404C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9962C20651
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfANNjZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:39:25 -0500
Received: from mail.bootlin.com ([62.4.15.54]:51462 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfANNjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 08:39:03 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 4C011209D7; Mon, 14 Jan 2019 14:39:01 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-45-241.w90-88.abo.wanadoo.fr [90.88.163.241])
        by mail.bootlin.com (Postfix) with ESMTPSA id CFB9F206F9;
        Mon, 14 Jan 2019 14:39:00 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com
Cc:     Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH RFC 2/4] media: v4l2-mem2mem: Add an optional job_done operation
Date:   Mon, 14 Jan 2019 14:38:37 +0100
Message-Id: <20190114133839.29967-3-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190114133839.29967-1-paul.kocialkowski@bootlin.com>
References: <20190114133839.29967-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Introduce a new optional job_done operation, which allows calling back
to the driver when a job is done. Since the job might be completed
from interrupt context where some operations are not available, having
a callback from non-atomic context allows performing these operations
upon completion of a job. This is particularly useful for releasing
access to a reference buffer, which cannot be done in atomic context.

Use the already existing v4l2_m2m_device_run_work work queue for that
and clear the M2M device current context after calling job_done in the
worker thread, so that the private data can be passed to the operation.

Delaying the current context clearing should not be a problem since the
next call to v4l2_m2m_try_run happens right after that.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 8 ++++++--
 include/media/v4l2-mem2mem.h           | 4 ++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 631f4e2aa942..d5bccb0192f9 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -376,6 +376,11 @@ static void v4l2_m2m_device_run_work(struct work_struct *work)
 	struct v4l2_m2m_dev *m2m_dev =
 		container_of(work, struct v4l2_m2m_dev, job_work);
 
+	if (m2m_dev->m2m_ops->job_done && m2m_dev->curr_ctx)
+		m2m_dev->m2m_ops->job_done(m2m_dev->curr_ctx->priv);
+
+	m2m_dev->curr_ctx = NULL;
+
 	v4l2_m2m_try_run(m2m_dev);
 }
 
@@ -431,8 +436,7 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 	list_del(&m2m_dev->curr_ctx->queue);
 	m2m_dev->curr_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
 	wake_up(&m2m_dev->curr_ctx->finished);
-	m2m_dev->curr_ctx = NULL;
-
+	/* The current context pointer is cleared after the job_done step. */
 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
 
 	/* This instance might have more buffers ready, but since we do not
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 43e447dcf69d..261bcd661b2d 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -40,11 +40,15 @@
  *		v4l2_m2m_job_finish() (as if the transaction ended normally).
  *		This function does not have to (and will usually not) wait
  *		until the device enters a state when it can be stopped.
+ * @job_done:	optional. Informs the driver that the current job was completed.
+ *		This can be useful to release access to extra buffers that were
+ *		required for the job, such as reference buffers for decoding.
  */
 struct v4l2_m2m_ops {
 	void (*device_run)(void *priv);
 	int (*job_ready)(void *priv);
 	void (*job_abort)(void *priv);
+	void (*job_done)(void *priv);
 };
 
 struct video_device;
-- 
2.20.1

