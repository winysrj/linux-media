Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:44092 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab2K1TKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:10:00 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700LI6P8E8G40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:59 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME7006TUP7TOU90@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:59 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 09/12] s5p-csis: Add registers logging for debugging
Date: Wed, 28 Nov 2012 20:09:26 +0100
Message-id: <1354129766-2821-10-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
References: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dump registers contents together with the event counters state
in VIDIOC_LOG_STATUS ioctl.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |   28 +++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 8ec7c3b..8a06f14 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -383,6 +383,30 @@ err:
 	return -ENXIO;
 }
 
+static void dump_regs(struct csis_state *state, const char *label)
+{
+	struct {
+		u32 offset;
+		const char * const name;
+	} registers[] = {
+		{ 0x00, "CTRL" },
+		{ 0x04, "DPHYCTRL" },
+		{ 0x08, "CONFIG" },
+		{ 0x0c, "DPHYSTS" },
+		{ 0x10, "INTMSK" },
+		{ 0x2c, "RESOL" },
+		{ 0x38, "SDW_CONFIG" },
+	};
+	u32 i;
+
+	v4l2_info(&state->sd, "--- %s ---\n", label);
+
+	for (i = 0; i < ARRAY_SIZE(registers); i++) {
+		u32 cfg = s5pcsis_read(state, registers[i].offset);
+		v4l2_info(&state->sd, "%10s: 0x%08x\n", registers[i].name, cfg);
+	}
+}
+
 static void s5pcsis_start_stream(struct csis_state *state)
 {
 	s5pcsis_reset(state);
@@ -583,7 +607,11 @@ static int s5pcsis_log_status(struct v4l2_subdev *sd)
 {
 	struct csis_state *state = sd_to_csis_state(sd);
 
+	mutex_lock(&state->lock);
 	s5pcsis_log_counters(state, true);
+	if (debug && (state->flags & ST_POWERED))
+		dump_regs(state, __func__);
+	mutex_unlock(&state->lock);
 	return 0;
 }
 
-- 
1.7.9.5

