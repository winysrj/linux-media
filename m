Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:59062 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdK0NZy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 08:25:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] [media] staging: imx: use ktime_t for timestamps
Date: Mon, 27 Nov 2017 14:20:00 +0100
Message-Id: <20171127132027.1734806-8-arnd@arndb.de>
In-Reply-To: <20171127132027.1734806-1-arnd@arndb.de>
References: <20171127132027.1734806-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The imx media driver passes around monotonic timestamps in the deprecated
'timespec' format. This is not a problem for the driver, as they won't
overflow, but moving to either timespec64 or ktime_t is preferred.

I'm picking ktime_t for simplicity here. frame_interval_monitor() is
the main function that changes, as it tries to compare a time interval
in microseconds. The algorithm slightly changes here, to avoid 64-bit
division. The code previously assumed that the error was at most 32-bit
worth of microseconds here, so I'm making the same assumption but add
an explicit test for it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/imx/imx-media-csi.c |  8 ++------
 drivers/staging/media/imx/imx-media-fim.c | 30 +++++++++++++++++-------------
 drivers/staging/media/imx/imx-media.h     |  2 +-
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index bb1d6dafca83..26994b429cf2 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -207,13 +207,9 @@ static irqreturn_t csi_idmac_eof_interrupt(int irq, void *dev_id)
 		goto unlock;
 	}
 
-	if (priv->fim) {
-		struct timespec cur_ts;
-
-		ktime_get_ts(&cur_ts);
+	if (priv->fim)
 		/* call frame interval monitor */
-		imx_media_fim_eof_monitor(priv->fim, &cur_ts);
-	}
+		imx_media_fim_eof_monitor(priv->fim, ktime_get());
 
 	csi_vb2_buf_done(priv);
 
diff --git a/drivers/staging/media/imx/imx-media-fim.c b/drivers/staging/media/imx/imx-media-fim.c
index 47275ef803f3..6df189135db8 100644
--- a/drivers/staging/media/imx/imx-media-fim.c
+++ b/drivers/staging/media/imx/imx-media-fim.c
@@ -66,7 +66,7 @@ struct imx_media_fim {
 	int               icap_flags;
 
 	int               counter;
-	struct timespec   last_ts;
+	ktime_t		  last_ts;
 	unsigned long     sum;       /* usec */
 	unsigned long     nominal;   /* usec */
 
@@ -147,22 +147,26 @@ static void send_fim_event(struct imx_media_fim *fim, unsigned long error)
  * (presumably random) interrupt latency.
  */
 static void frame_interval_monitor(struct imx_media_fim *fim,
-				   struct timespec *ts)
+				   ktime_t timestamp)
 {
-	unsigned long interval, error, error_avg;
+	long long interval, error;
+	unsigned long error_avg;
 	bool send_event = false;
-	struct timespec diff;
 
 	if (!fim->enabled || ++fim->counter <= 0)
 		goto out_update_ts;
 
-	diff = timespec_sub(*ts, fim->last_ts);
-	interval = diff.tv_sec * 1000 * 1000 + diff.tv_nsec / 1000;
-	error = abs(interval - fim->nominal);
+	/* max error is less than l00µs, so use 32-bit division or fail */
+	interval = ktime_to_ns(ktime_sub(timestamp, fim->last_ts));
+	error = abs(interval - NSEC_PER_USEC * (u64)fim->nominal);
+	if (error > U32_MAX)
+		error = U32_MAX;
+	else
+		error = abs((u32)error / NSEC_PER_USEC);
 
 	if (fim->tolerance_max && error >= fim->tolerance_max) {
 		dev_dbg(fim->sd->dev,
-			"FIM: %lu ignored, out of tolerance bounds\n",
+			"FIM: %llu ignored, out of tolerance bounds\n",
 			error);
 		fim->counter--;
 		goto out_update_ts;
@@ -184,7 +188,7 @@ static void frame_interval_monitor(struct imx_media_fim *fim,
 	}
 
 out_update_ts:
-	fim->last_ts = *ts;
+	fim->last_ts = timestamp;
 	if (send_event)
 		send_fim_event(fim, error_avg);
 }
@@ -195,14 +199,14 @@ static void frame_interval_monitor(struct imx_media_fim *fim,
  * to interrupt latency.
  */
 static void fim_input_capture_handler(int channel, void *dev_id,
-				      struct timespec *ts)
+				      ktime_t timestamp)
 {
 	struct imx_media_fim *fim = dev_id;
 	unsigned long flags;
 
 	spin_lock_irqsave(&fim->lock, flags);
 
-	frame_interval_monitor(fim, ts);
+	frame_interval_monitor(fim, timestamp);
 
 	if (!completion_done(&fim->icap_first_event))
 		complete(&fim->icap_first_event);
@@ -405,14 +409,14 @@ static int init_fim_controls(struct imx_media_fim *fim)
  * the frame_interval_monitor() is called by the input capture event
  * callback handler in that case.
  */
-void imx_media_fim_eof_monitor(struct imx_media_fim *fim, struct timespec *ts)
+void imx_media_fim_eof_monitor(struct imx_media_fim *fim, ktime_t timestamp)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&fim->lock, flags);
 
 	if (!icap_enabled(fim))
-		frame_interval_monitor(fim, ts);
+		frame_interval_monitor(fim, timestamp);
 
 	spin_unlock_irqrestore(&fim->lock, flags);
 }
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index d409170632bd..ac3ab115394f 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -280,7 +280,7 @@ int imx_media_pipeline_set_stream(struct imx_media_dev *imxmd,
 
 /* imx-media-fim.c */
 struct imx_media_fim;
-void imx_media_fim_eof_monitor(struct imx_media_fim *fim, struct timespec *ts);
+void imx_media_fim_eof_monitor(struct imx_media_fim *fim, ktime_t timestamp);
 int imx_media_fim_set_stream(struct imx_media_fim *fim,
 			     const struct v4l2_fract *frame_interval,
 			     bool on);
-- 
2.9.0
