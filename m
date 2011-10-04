Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910Ab1JDTxb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Oct 2011 15:53:31 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p94JrVdk028875
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 4 Oct 2011 15:53:31 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv2 7/8] [media] msp3400: Add standards detection to the driver
Date: Tue,  4 Oct 2011 16:53:19 -0300
Message-Id: <1317758000-21154-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1317758000-21154-6-git-send-email-mchehab@redhat.com>
References: <1317758000-21154-1-git-send-email-mchehab@redhat.com>
 <1317758000-21154-2-git-send-email-mchehab@redhat.com>
 <1317758000-21154-3-git-send-email-mchehab@redhat.com>
 <1317758000-21154-4-git-send-email-mchehab@redhat.com>
 <1317758000-21154-5-git-send-email-mchehab@redhat.com>
 <1317758000-21154-6-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As msp3400 allows standards detection, add support for it. That
efectivelly means that devices with msp3400 can now implement
VIDIOC_QUERYSTD, and it will provide very good detection for
the standard, specially if combined with a video decoder detection.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/msp3400-driver.c   |   20 +++++++
 drivers/media/video/msp3400-driver.h   |    2 +-
 drivers/media/video/msp3400-kthreads.c |   86 +++++++++++++++++++++++--------
 3 files changed, 85 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/video/msp3400-driver.c
index c43c81f..d0f5388 100644
--- a/drivers/media/video/msp3400-driver.c
+++ b/drivers/media/video/msp3400-driver.c
@@ -426,6 +426,20 @@ static int msp_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *freq)
 	return 0;
 }
 
+static int msp_querystd(struct v4l2_subdev *sd, v4l2_std_id *id)
+{
+	struct msp_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	*id &= state->detected_std;
+
+	v4l_dbg(2, msp_debug, client,
+		"detected standard: %s(0x%08Lx)\n",
+		msp_standard_std_name(state->std), state->detected_std);
+
+	return 0;
+}
+
 static int msp_s_std(struct v4l2_subdev *sd, v4l2_std_id id)
 {
 	struct msp_state *state = to_state(sd);
@@ -616,6 +630,10 @@ static const struct v4l2_subdev_core_ops msp_core_ops = {
 	.s_std = msp_s_std,
 };
 
+static const struct v4l2_subdev_video_ops msp_video_ops = {
+	.querystd = msp_querystd,
+};
+
 static const struct v4l2_subdev_tuner_ops msp_tuner_ops = {
 	.s_frequency = msp_s_frequency,
 	.g_tuner = msp_g_tuner,
@@ -630,6 +648,7 @@ static const struct v4l2_subdev_audio_ops msp_audio_ops = {
 
 static const struct v4l2_subdev_ops msp_ops = {
 	.core = &msp_core_ops,
+	.video = &msp_video_ops,
 	.tuner = &msp_tuner_ops,
 	.audio = &msp_audio_ops,
 };
@@ -664,6 +683,7 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	v4l2_i2c_subdev_init(sd, client, &msp_ops);
 
 	state->v4l2_std = V4L2_STD_NTSC;
+	state->detected_std = V4L2_STD_ALL;
 	state->audmode = V4L2_TUNER_MODE_STEREO;
 	state->input = -1;
 	state->i2s_mode = 0;
diff --git a/drivers/media/video/msp3400-driver.h b/drivers/media/video/msp3400-driver.h
index 32a478e..831e8db 100644
--- a/drivers/media/video/msp3400-driver.h
+++ b/drivers/media/video/msp3400-driver.h
@@ -75,7 +75,7 @@ struct msp_state {
 	int opmode;
 	int std;
 	int mode;
-	v4l2_std_id v4l2_std;
+	v4l2_std_id v4l2_std, detected_std;
 	int nicam_on;
 	int acb;
 	int in_scart;
diff --git a/drivers/media/video/msp3400-kthreads.c b/drivers/media/video/msp3400-kthreads.c
index 80387e2..f8b5171 100644
--- a/drivers/media/video/msp3400-kthreads.c
+++ b/drivers/media/video/msp3400-kthreads.c
@@ -37,29 +37,49 @@ static struct {
 	int retval;
 	int main, second;
 	char *name;
+	v4l2_std_id std;
 } msp_stdlist[] = {
-	{ 0x0000, 0, 0, "could not detect sound standard" },
-	{ 0x0001, 0, 0, "autodetect start" },
-	{ 0x0002, MSP_CARRIER(4.5), MSP_CARRIER(4.72), "4.5/4.72  M Dual FM-Stereo" },
-	{ 0x0003, MSP_CARRIER(5.5), MSP_CARRIER(5.7421875), "5.5/5.74  B/G Dual FM-Stereo" },
-	{ 0x0004, MSP_CARRIER(6.5), MSP_CARRIER(6.2578125), "6.5/6.25  D/K1 Dual FM-Stereo" },
-	{ 0x0005, MSP_CARRIER(6.5), MSP_CARRIER(6.7421875), "6.5/6.74  D/K2 Dual FM-Stereo" },
-	{ 0x0006, MSP_CARRIER(6.5), MSP_CARRIER(6.5), "6.5  D/K FM-Mono (HDEV3)" },
-	{ 0x0007, MSP_CARRIER(6.5), MSP_CARRIER(5.7421875), "6.5/5.74  D/K3 Dual FM-Stereo" },
-	{ 0x0008, MSP_CARRIER(5.5), MSP_CARRIER(5.85), "5.5/5.85  B/G NICAM FM" },
-	{ 0x0009, MSP_CARRIER(6.5), MSP_CARRIER(5.85), "6.5/5.85  L NICAM AM" },
-	{ 0x000a, MSP_CARRIER(6.0), MSP_CARRIER(6.55), "6.0/6.55  I NICAM FM" },
-	{ 0x000b, MSP_CARRIER(6.5), MSP_CARRIER(5.85), "6.5/5.85  D/K NICAM FM" },
-	{ 0x000c, MSP_CARRIER(6.5), MSP_CARRIER(5.85), "6.5/5.85  D/K NICAM FM (HDEV2)" },
-	{ 0x000d, MSP_CARRIER(6.5), MSP_CARRIER(5.85), "6.5/5.85  D/K NICAM FM (HDEV3)" },
-	{ 0x0020, MSP_CARRIER(4.5), MSP_CARRIER(4.5), "4.5  M BTSC-Stereo" },
-	{ 0x0021, MSP_CARRIER(4.5), MSP_CARRIER(4.5), "4.5  M BTSC-Mono + SAP" },
-	{ 0x0030, MSP_CARRIER(4.5), MSP_CARRIER(4.5), "4.5  M EIA-J Japan Stereo" },
-	{ 0x0040, MSP_CARRIER(10.7), MSP_CARRIER(10.7), "10.7  FM-Stereo Radio" },
-	{ 0x0050, MSP_CARRIER(6.5), MSP_CARRIER(6.5), "6.5  SAT-Mono" },
-	{ 0x0051, MSP_CARRIER(7.02), MSP_CARRIER(7.20), "7.02/7.20  SAT-Stereo" },
-	{ 0x0060, MSP_CARRIER(7.2), MSP_CARRIER(7.2), "7.2  SAT ADR" },
-	{     -1, 0, 0, NULL }, /* EOF */
+	{ 0x0000, 0, 0, "could not detect sound standard", V4L2_STD_ALL },
+	{ 0x0001, 0, 0, "autodetect start", V4L2_STD_ALL },
+	{ 0x0002, MSP_CARRIER(4.5), MSP_CARRIER(4.72),
+	  "4.5/4.72  M Dual FM-Stereo", V4L2_STD_MN },
+	{ 0x0003, MSP_CARRIER(5.5), MSP_CARRIER(5.7421875),
+	  "5.5/5.74  B/G Dual FM-Stereo", V4L2_STD_BG },
+	{ 0x0004, MSP_CARRIER(6.5), MSP_CARRIER(6.2578125),
+	  "6.5/6.25  D/K1 Dual FM-Stereo", V4L2_STD_DK },
+	{ 0x0005, MSP_CARRIER(6.5), MSP_CARRIER(6.7421875),
+	  "6.5/6.74  D/K2 Dual FM-Stereo", V4L2_STD_DK },
+	{ 0x0006, MSP_CARRIER(6.5), MSP_CARRIER(6.5),
+	  "6.5  D/K FM-Mono (HDEV3)", V4L2_STD_DK },
+	{ 0x0007, MSP_CARRIER(6.5), MSP_CARRIER(5.7421875),
+	  "6.5/5.74  D/K3 Dual FM-Stereo", V4L2_STD_DK },
+	{ 0x0008, MSP_CARRIER(5.5), MSP_CARRIER(5.85),
+	  "5.5/5.85  B/G NICAM FM", V4L2_STD_BG },
+	{ 0x0009, MSP_CARRIER(6.5), MSP_CARRIER(5.85),
+	  "6.5/5.85  L NICAM AM", V4L2_STD_L },
+	{ 0x000a, MSP_CARRIER(6.0), MSP_CARRIER(6.55),
+	  "6.0/6.55  I NICAM FM", V4L2_STD_PAL_I },
+	{ 0x000b, MSP_CARRIER(6.5), MSP_CARRIER(5.85),
+	  "6.5/5.85  D/K NICAM FM", V4L2_STD_DK },
+	{ 0x000c, MSP_CARRIER(6.5), MSP_CARRIER(5.85),
+	  "6.5/5.85  D/K NICAM FM (HDEV2)", V4L2_STD_DK },
+	{ 0x000d, MSP_CARRIER(6.5), MSP_CARRIER(5.85),
+	  "6.5/5.85  D/K NICAM FM (HDEV3)", V4L2_STD_DK },
+	{ 0x0020, MSP_CARRIER(4.5), MSP_CARRIER(4.5),
+	  "4.5  M BTSC-Stereo", V4L2_STD_MTS },
+	{ 0x0021, MSP_CARRIER(4.5), MSP_CARRIER(4.5),
+	  "4.5  M BTSC-Mono + SAP", V4L2_STD_MTS },
+	{ 0x0030, MSP_CARRIER(4.5), MSP_CARRIER(4.5),
+	  "4.5  M EIA-J Japan Stereo", V4L2_STD_NTSC_M_JP },
+	{ 0x0040, MSP_CARRIER(10.7), MSP_CARRIER(10.7),
+	  "10.7  FM-Stereo Radio", V4L2_STD_ALL },
+	{ 0x0050, MSP_CARRIER(6.5), MSP_CARRIER(6.5),
+	  "6.5  SAT-Mono", V4L2_STD_ALL },
+	{ 0x0051, MSP_CARRIER(7.02), MSP_CARRIER(7.20),
+	  "7.02/7.20  SAT-Stereo", V4L2_STD_ALL },
+	{ 0x0060, MSP_CARRIER(7.2), MSP_CARRIER(7.2),
+	  "7.2  SAT ADR", V4L2_STD_ALL },
+	{     -1, 0, 0, NULL, 0 }, /* EOF */
 };
 
 static struct msp3400c_init_data_dem {
@@ -156,6 +176,16 @@ const char *msp_standard_std_name(int std)
 	return "unknown";
 }
 
+static v4l2_std_id msp_standard_std(int std)
+{
+	int i;
+
+	for (i = 0; msp_stdlist[i].name != NULL; i++)
+		if (msp_stdlist[i].retval == std)
+			return msp_stdlist[i].std;
+	return V4L2_STD_ALL;
+}
+
 static void msp_set_source(struct i2c_client *client, u16 src)
 {
 	struct msp_state *state = to_state(i2c_get_clientdata(client));
@@ -479,6 +509,7 @@ int msp3400c_thread(void *data)
 	int count, max1, max2, val1, val2, val, i;
 
 	v4l_dbg(1, msp_debug, client, "msp3400 daemon started\n");
+	state->detected_std = V4L2_STD_ALL;
 	set_freezable();
 	for (;;) {
 		v4l_dbg(2, msp_debug, client, "msp3400 thread: sleep\n");
@@ -579,6 +610,7 @@ restart:
 		state->main = msp3400c_carrier_detect_main[max1].cdo;
 		switch (max1) {
 		case 1: /* 5.5 */
+			state->detected_std = V4L2_STD_BG | V4L2_STD_PAL_H;
 			if (max2 == 0) {
 				/* B/G FM-stereo */
 				state->second = msp3400c_carrier_detect_55[max2].cdo;
@@ -596,6 +628,7 @@ restart:
 			break;
 		case 2: /* 6.0 */
 			/* PAL I NICAM */
+			state->detected_std = V4L2_STD_PAL_I;
 			state->second = MSP_CARRIER(6.552);
 			msp3400c_set_mode(client, MSP_MODE_FM_NICAM2);
 			state->nicam_on = 1;
@@ -607,22 +640,26 @@ restart:
 				state->second = msp3400c_carrier_detect_65[max2].cdo;
 				msp3400c_set_mode(client, MSP_MODE_FM_TERRA);
 				state->watch_stereo = 1;
+				state->detected_std = V4L2_STD_DK;
 			} else if (max2 == 0 && (state->v4l2_std & V4L2_STD_SECAM)) {
 				/* L NICAM or AM-mono */
 				state->second = msp3400c_carrier_detect_65[max2].cdo;
 				msp3400c_set_mode(client, MSP_MODE_AM_NICAM);
 				state->watch_stereo = 1;
+				state->detected_std = V4L2_STD_L;
 			} else if (max2 == 0 && state->has_nicam) {
 				/* D/K NICAM */
 				state->second = msp3400c_carrier_detect_65[max2].cdo;
 				msp3400c_set_mode(client, MSP_MODE_FM_NICAM1);
 				state->nicam_on = 1;
 				state->watch_stereo = 1;
+				state->detected_std = V4L2_STD_DK;
 			} else {
 				goto no_second;
 			}
 			break;
 		case 0: /* 4.5 */
+			state->detected_std = V4L2_STD_MN;
 		default:
 no_second:
 			state->second = msp3400c_carrier_detect_main[max1].cdo;
@@ -662,6 +699,7 @@ int msp3410d_thread(void *data)
 	int val, i, std, count;
 
 	v4l_dbg(1, msp_debug, client, "msp3410 daemon started\n");
+	state->detected_std = V4L2_STD_ALL;
 	set_freezable();
 	for (;;) {
 		v4l_dbg(2, msp_debug, client, "msp3410 thread: sleep\n");
@@ -743,6 +781,8 @@ restart:
 					msp_stdlist[8].name : "unknown", val);
 			state->std = val = 0x0009;
 			msp_write_dem(client, 0x20, val);
+		} else {
+			state->detected_std = msp_standard_std(state->std);
 		}
 
 		/* set stereo */
@@ -957,6 +997,7 @@ int msp34xxg_thread(void *data)
 	int val, i;
 
 	v4l_dbg(1, msp_debug, client, "msp34xxg daemon started\n");
+	state->detected_std = V4L2_STD_ALL;
 	set_freezable();
 	for (;;) {
 		v4l_dbg(2, msp_debug, client, "msp34xxg thread: sleep\n");
@@ -1013,6 +1054,7 @@ unmute:
 		v4l_dbg(1, msp_debug, client,
 			"detected standard: %s (0x%04x)\n",
 			msp_standard_std_name(state->std), state->std);
+		state->detected_std = msp_standard_std(state->std);
 
 		if (state->std == 9) {
 			/* AM NICAM mode */
-- 
1.7.6.4

