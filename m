Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64539 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2EXPQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:16:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4J0065T9199O80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4J00E6M92L4D@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:58 +0100 (BST)
Date: Thu, 24 May 2012 17:15:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/7] s5p-fimc: Prevent lock-up in multiple sensor systems
In-reply-to: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1337872556-26406-6-git-send-email-s.nawrocki@samsung.com>
References: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The camera clocks managed by the driver were improperly reference counted
and remained disabled when multiple video nodes were opened simultaneously.
It manifested itself with following warning:

 [12.920000] WARNING: at drivers/media/video/s5p-fimc/fimc-mdevice.c:787 __fimc_md_set_camclk+0x1c0/0x1dc()
 [13.005000] Modules linked in:
 [13.005000] Backtrace:
 [13.040000] [<c0013084>] (dump_backtrace+0x0/0x10c) from [<c0454b70>] (dump_stack+0x18/0x1c)
 [13.070000]  r7:00000009 r6:00000313 r5:c02d576c r4:00000000
 [13.155000] [<c0454b58>] (dump_stack+0x0/0x1c) from [<c0022ec4>] (warn_slowpath_common+0x54/0x6c)
 [13.285000] [<c0022e70>] (warn_slowpath_common+0x0/0x6c) from [<c0022f00>] (warn_slowpath_null+0x24/0x2c)
 [13.360000]  r9:e1981010 r8:00000000 r7:c061d3fc r6:e1981010 r5:e1981030
 [13.430000] r4:00000000
 [13.430000] [<c0022edc>] (warn_slowpath_null+0x0/0x2c) from [<c02d576c>] (__fimc_md_set_camclk+0x1c0/0x1dc)
 [13.550000] [<c02d55ac>] (__fimc_md_set_camclk+0x0/0x1dc) from [<c02d57b0>] (fimc_md_set_camclk+0x28/0x2c)
 [13.630000] [<c02d5788>] (fimc_md_set_camclk+0x0/0x2c) from [<c02d57e8>] (__fimc_pipeline_shutdown+0x34/0x50)
 [13.705000] [<c02d57b4>] (__fimc_pipeline_shutdown+0x0/0x50) from [<c02d5844>] (fimc_pipeline_shutdown+0x40/0x58)
 [13.765000]  r5:e2391200 r4:e2357704
 [13.805000] [<c02d5804>] (fimc_pipeline_shutdown+0x0/0x58) from [<c02d4754>] (fimc_capture_close+0xcc/0xe4)
 [13.915000]  r5:e1b396c0 r4:e2357410
 [13.915000] [<c02d4688>] (fimc_capture_close+0x0/0xe4) from [<c02b2d5c>] (v4l2_release+0x5c/0x80)
 [13.970000]  r7:00000010 r6:e1d2d990 r5:e1b396c0 r4:e2394800
 [14.000000] [<c02b2d00>] (v4l2_release+0x0/0x80) from [<c00b66cc>] (fput+0xc0/0x22c)
 [14.015000]  r5:c157ef30 r4:e1b396c0
 [14.015000] [<c00b660c>] (fput+0x0/0x22c) from [<c00b2ca0>] (filp_close+0x60/0x80)
 [14.080000] [<c00b2c40>] (filp_close+0x0/0x80) from [<c00b2d78>] (sys_close+0xb8/0xf4)
 [14.125000]  r7:00000001 r6:e1b396c0 r5:c1400340 r4:c1400300
 [14.125000] [<c00b2cc0>] (sys_close+0x0/0xf4) from [<c000f300>] (ret_fast_syscall+0x0/0x30)
 [14.205000]  r7:00000006 r6:beee5b94 r5:00000003 r4:b6f64fac

Fix this, as well as potential memory leaks due to not calling
v4l2_fh_release() on some error paths.

Also remove some error logs printed for events that aren't critical and
are normal conditions for some system configurations.

Also check if the device have been properly run-time enabled during
video node open.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   46 ++++++++++++++-------------
 drivers/media/video/s5p-fimc/fimc-lite.c    |   14 ++++----
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   19 ++++-------
 drivers/media/video/s5p-fimc/fimc-mdevice.h |    2 --
 4 files changed, 38 insertions(+), 43 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 0fd12df..71e4838 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -480,37 +480,39 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc);
 static int fimc_capture_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	int ret = v4l2_fh_open(file);
-
-	if (ret)
-		return ret;
+	int ret;
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
-	/* Return if the corresponding video mem2mem node is already opened. */
 	if (fimc_m2m_active(fimc))
 		return -EBUSY;
 
 	set_bit(ST_CAPT_BUSY, &fimc->state);
-	pm_runtime_get_sync(&fimc->pdev->dev);
-
-	if (++fimc->vid_cap.refcnt == 1) {
-		ret = fimc_pipeline_initialize(&fimc->pipeline,
-			       &fimc->vid_cap.vfd->entity, true);
-		if (ret < 0) {
-			dev_err(&fimc->pdev->dev,
-				"Video pipeline initialization failed\n");
-			clear_bit(ST_CAPT_BUSY, &fimc->state);
-			pm_runtime_put_sync(&fimc->pdev->dev);
-			fimc->vid_cap.refcnt--;
-			v4l2_fh_release(file);
-			return ret;
-		}
-		ret = fimc_capture_ctrls_create(fimc);
+	ret = pm_runtime_get_sync(&fimc->pdev->dev);
+	if (ret < 0)
+		return ret;
+
+	ret = v4l2_fh_open(file);
+	if (ret)
+		return ret;
+
+	if (++fimc->vid_cap.refcnt != 1)
+		return 0;
 
-		if (!ret && !fimc->vid_cap.user_subdev_api)
-			ret = fimc_capture_set_default_format(fimc);
+	ret = fimc_pipeline_initialize(&fimc->pipeline,
+				       &fimc->vid_cap.vfd->entity, true);
+	if (ret < 0) {
+		clear_bit(ST_CAPT_BUSY, &fimc->state);
+		pm_runtime_put_sync(&fimc->pdev->dev);
+		fimc->vid_cap.refcnt--;
+		v4l2_fh_release(file);
+		return ret;
 	}
+	ret = fimc_capture_ctrls_create(fimc);
+
+	if (!ret && !fimc->vid_cap.user_subdev_api)
+		ret = fimc_capture_set_default_format(fimc);
+
 	return ret;
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 400d701a..bbe93e4 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -451,21 +451,23 @@ static void fimc_lite_clear_event_counters(struct fimc_lite *fimc)
 static int fimc_lite_open(struct file *file)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-	int ret = v4l2_fh_open(file);
-
-	if (ret)
-		return ret;
+	int ret;
 
 	set_bit(ST_FLITE_IN_USE, &fimc->state);
-	pm_runtime_get_sync(&fimc->pdev->dev);
+	ret = pm_runtime_get_sync(&fimc->pdev->dev);
+	if (ret < 0)
+		return ret;
 
 	if (++fimc->ref_count != 1 || fimc->out_path != FIMC_IO_DMA)
+		return 0;
+
+	ret = v4l2_fh_open(file);
+	if (ret < 0)
 		return ret;
 
 	ret = fimc_pipeline_initialize(&fimc->pipeline, &fimc->vfd->entity,
 				       true);
 	if (ret < 0) {
-		v4l2_err(fimc->vfd, "Video pipeline initialization failed\n");
 		pm_runtime_put_sync(&fimc->pdev->dev);
 		fimc->ref_count--;
 		v4l2_fh_release(file);
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index dffe4da..52cef48 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -741,8 +741,8 @@ static void fimc_md_put_clocks(struct fimc_md *fmd)
 }
 
 static int __fimc_md_set_camclk(struct fimc_md *fmd,
-					 struct fimc_sensor_info *s_info,
-					 bool on)
+				struct fimc_sensor_info *s_info,
+				bool on)
 {
 	struct s5p_fimc_isp_info *pdata = s_info->pdata;
 	struct fimc_camclk_info *camclk;
@@ -751,12 +751,10 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 	if (WARN_ON(pdata->clk_id >= FIMC_MAX_CAMCLKS) || fmd == NULL)
 		return -EINVAL;
 
-	if (s_info->clk_on == on)
-		return 0;
 	camclk = &fmd->camclk[pdata->clk_id];
 
-	dbg("camclk %d, f: %lu, clk: %p, on: %d",
-	    pdata->clk_id, pdata->clk_frequency, camclk, on);
+	dbg("camclk %d, f: %lu, use_count: %d, on: %d",
+	    pdata->clk_id, pdata->clk_frequency, camclk->use_count, on);
 
 	if (on) {
 		if (camclk->use_count > 0 &&
@@ -767,11 +765,9 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 			clk_set_rate(camclk->clock, pdata->clk_frequency);
 			camclk->frequency = pdata->clk_frequency;
 			ret = clk_enable(camclk->clock);
+			dbg("Enabled camclk %d: f: %lu", pdata->clk_id,
+			    clk_get_rate(camclk->clock));
 		}
-		s_info->clk_on = 1;
-		dbg("Enabled camclk %d: f: %lu", pdata->clk_id,
-		    clk_get_rate(camclk->clock));
-
 		return ret;
 	}
 
@@ -780,7 +776,6 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 
 	if (--camclk->use_count == 0) {
 		clk_disable(camclk->clock);
-		s_info->clk_on = 0;
 		dbg("Disabled camclk %d", pdata->clk_id);
 	}
 	return ret;
@@ -796,8 +791,6 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
  * devices to which sensors can be attached, either directly or through
  * the MIPI CSI receiver. The clock is allowed here to be used by
  * multiple sensors concurrently if they use same frequency.
- * The per sensor subdev clk_on attribute helps to synchronize accesses
- * to the sclk_cam clocks from the video and media device nodes.
  * This function should only be called when the graph mutex is held.
  */
 int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/video/s5p-fimc/fimc-mdevice.h
index 3b8a349..1f5dbaf 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.h
@@ -47,7 +47,6 @@ struct fimc_camclk_info {
  * @pdata: sensor's atrributes passed as media device's platform data
  * @subdev: image sensor v4l2 subdev
  * @host: fimc device the sensor is currently linked to
- * @clk_on: sclk_cam clock's state associated with this subdev
  *
  * This data structure applies to image sensor and the writeback subdevs.
  */
@@ -55,7 +54,6 @@ struct fimc_sensor_info {
 	struct s5p_fimc_isp_info *pdata;
 	struct v4l2_subdev *subdev;
 	struct fimc_dev *host;
-	bool clk_on;
 };
 
 /**
-- 
1.7.10

