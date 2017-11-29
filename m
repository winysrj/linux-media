Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57365 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753580AbdK2MIT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 07:08:19 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 6/7] media: exynos4-is: fix kernel-doc warnings
Date: Wed, 29 Nov 2017 07:08:09 -0500
Message-Id: <103fee5da9bdde4ed9b1dfa56c078022008de2dd.1511952403.git.mchehab@s-opensource.com>
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those kernel-doc warnings:

    drivers/media/platform/exynos4-is/mipi-csis.c:229: warning: No description found for parameter 'clk_frequency'
    drivers/media/platform/exynos4-is/mipi-csis.c:229: warning: Excess struct member 'clock_frequency' description in 'csis_state'
    drivers/media/platform/exynos4-is/media-dev.c:69: warning: No description found for parameter 'p'
    drivers/media/platform/exynos4-is/media-dev.c:160: warning: No description found for parameter 'p'
    drivers/media/platform/exynos4-is/media-dev.c:160: warning: No description found for parameter 'on'
    drivers/media/platform/exynos4-is/media-dev.c:160: warning: Excess function parameter 'fimc' description in 'fimc_pipeline_s_power'
    drivers/media/platform/exynos4-is/media-dev.c:160: warning: Excess function parameter 'state' description in 'fimc_pipeline_s_power'
    drivers/media/platform/exynos4-is/media-dev.c:229: warning: No description found for parameter 'ep'
    drivers/media/platform/exynos4-is/media-dev.c:260: warning: No description found for parameter 'ep'
    drivers/media/platform/exynos4-is/media-dev.c:260: warning: Excess function parameter 'fimc' description in '__fimc_pipeline_close'
    drivers/media/platform/exynos4-is/media-dev.c:288: warning: No description found for parameter 'ep'
    drivers/media/platform/exynos4-is/media-dev.c:288: warning: Excess function parameter 'pipeline' description in '__fimc_pipeline_s_stream'
    drivers/media/platform/exynos4-is/media-dev.c:916: warning: No description found for parameter 'fmd'
    drivers/media/platform/exynos4-is/fimc-capture.c:155: warning: No description found for parameter 'ctx'
    drivers/media/platform/exynos4-is/fimc-capture.c:868: warning: No description found for parameter 'num_planes'
    drivers/media/platform/exynos4-is/fimc-capture.c:1108: warning: No description found for parameter 'fimc'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |  3 +++
 drivers/media/platform/exynos4-is/media-dev.c    | 11 +++++++----
 drivers/media/platform/exynos4-is/mipi-csis.c    |  2 +-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 948fe01f6c96..ed9302caa004 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -146,6 +146,7 @@ static int fimc_stop_capture(struct fimc_dev *fimc, bool suspend)
 
 /**
  * fimc_capture_config_update - apply the camera interface configuration
+ * @ctx: FIMC capture context
  *
  * To be called from within the interrupt handler with fimc.slock
  * spinlock held. It updates the camera pixel crop, rotation and
@@ -858,6 +859,7 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
  * fimc_get_sensor_frame_desc - query the sensor for media bus frame parameters
  * @sensor: pointer to the sensor subdev
  * @plane_fmt: provides plane sizes corresponding to the frame layout entries
+ * @num_planes: number of planes
  * @try: true to set the frame parameters, false to query only
  *
  * This function is used by this driver only for compressed/blob data formats.
@@ -1101,6 +1103,7 @@ static int fimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
 /**
  * fimc_pipeline_validate - check for formats inconsistencies
  *                          between source and sink pad of each link
+ * @fimc:	the FIMC device this context applies to
  *
  * Return 0 if all formats match or -EPIPE otherwise.
  */
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index c15596b56dc9..0ef583cfc424 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -60,6 +60,7 @@ static void __setup_sensor_notification(struct fimc_md *fmd,
 
 /**
  * fimc_pipeline_prepare - update pipeline information with subdevice pointers
+ * @p: fimc pipeline
  * @me: media entity terminating the pipeline
  *
  * Caller holds the graph mutex.
@@ -151,8 +152,8 @@ static int __subdev_set_power(struct v4l2_subdev *sd, int on)
 
 /**
  * fimc_pipeline_s_power - change power state of all pipeline subdevs
- * @fimc: fimc device terminating the pipeline
- * @state: true to power on, false to power off
+ * @p: fimc device terminating the pipeline
+ * @on: true to power on, false to power off
  *
  * Needs to be called with the graph mutex held.
  */
@@ -219,6 +220,7 @@ static int __fimc_pipeline_enable(struct exynos_media_pipeline *ep,
 /**
  * __fimc_pipeline_open - update the pipeline information, enable power
  *                        of all pipeline subdevs and the sensor clock
+ * @ep: fimc device terminating the pipeline
  * @me: media entity to start graph walk with
  * @prepare: true to walk the current pipeline and acquire all subdevs
  *
@@ -252,7 +254,7 @@ static int __fimc_pipeline_open(struct exynos_media_pipeline *ep,
 
 /**
  * __fimc_pipeline_close - disable the sensor clock and pipeline power
- * @fimc: fimc device terminating the pipeline
+ * @ep: fimc device terminating the pipeline
  *
  * Disable power of all subdevs and turn the external sensor clock off.
  */
@@ -281,7 +283,7 @@ static int __fimc_pipeline_close(struct exynos_media_pipeline *ep)
 
 /**
  * __fimc_pipeline_s_stream - call s_stream() on pipeline subdevs
- * @pipeline: video pipeline structure
+ * @ep: video pipeline structure
  * @on: passed as the s_stream() callback argument
  */
 static int __fimc_pipeline_s_stream(struct exynos_media_pipeline *ep, bool on)
@@ -902,6 +904,7 @@ static int __fimc_md_create_fimc_is_links(struct fimc_md *fmd)
 
 /**
  * fimc_md_create_links - create default links between registered entities
+ * @fmd: fimc media device
  *
  * Parallel interface sensor entities are connected directly to FIMC capture
  * entities. The sensors using MIPI CSIS bus are connected through immutable
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 560aadabcb11..cba46a656338 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -189,7 +189,7 @@ struct csis_drvdata {
  * @irq: requested s5p-mipi-csis irq number
  * @interrupt_mask: interrupt mask of the all used interrupts
  * @flags: the state variable for power and streaming control
- * @clock_frequency: device bus clock frequency
+ * @clk_frequency: device bus clock frequency
  * @hs_settle: HS-RX settle time
  * @num_lanes: number of MIPI-CSI data lanes used
  * @max_num_lanes: maximum number of MIPI-CSI data lanes supported
-- 
2.14.3
