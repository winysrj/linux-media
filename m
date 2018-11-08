Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:51122 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726517AbeKHT0i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 14:26:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] adv*/tc358743/ths8200: fill in min width/height/pixelclock
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <f3960bc7-0e1f-f7eb-3723-5c0c834f50f6@xs4all.nl>
Date: Thu, 8 Nov 2018 10:51:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_dv_timings_cap struct is used to do sanity checks when setting and
enumerating DV timings, ensuring that only valid timings as per the HW
capabilities are allowed.

However, many drivers just filled in 0 for the minimum width, height or
pixelclock frequency. This can cause timings with e.g. 0 as width and height
to be accepted, which will in turn lead to a potential division by zero.

Fill in proper values are minimum boundaries. 640x350 was chosen since it is
the smallest resolution in v4l2-dv-timings.h. Same for 13 MHz as the lowest
pixelclock frequency (it's slightly below the minimum of 13.5 MHz in the
v4l2-dv-timings.h header).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Note: there is another occurrence in vivid-vid-common.c, but that's fixed in
a separate patch that's already part of a pull request.
---
diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 5b008b0002c0..aa8b04cfed0f 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -578,7 +578,7 @@ static const struct v4l2_dv_timings_cap ad9389b_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 25000000, 170000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index f3899cc84e27..88349b5053cc 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -130,7 +130,7 @@ static const struct v4l2_dv_timings_cap adv7511_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, ADV7511_MAX_WIDTH, 0, ADV7511_MAX_HEIGHT,
+	V4L2_INIT_BT_TIMINGS(640, ADV7511_MAX_WIDTH, 350, ADV7511_MAX_HEIGHT,
 		ADV7511_MIN_PIXELCLOCK, ADV7511_MAX_PIXELCLOCK,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 9eb7c70a7712..ff28f5692986 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -766,7 +766,7 @@ static const struct v4l2_dv_timings_cap adv7604_timings_cap_analog = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 25000000, 170000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
@@ -777,7 +777,7 @@ static const struct v4l2_dv_timings_cap adv76xx_timings_cap_digital = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 225000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 25000000, 225000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 4721d49dcf0f..5305c3ad80e6 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -663,7 +663,7 @@ static const struct v4l2_dv_timings_cap adv7842_timings_cap_analog = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 25000000, 170000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
@@ -674,7 +674,7 @@ static const struct v4l2_dv_timings_cap adv7842_timings_cap_digital = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 225000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 25000000, 225000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 41d470d9ca94..00dc930e049f 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -59,7 +59,7 @@ static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
 	/* Pixel clock from REF_01 p. 20. Min/max height/width are unknown */
-	V4L2_INIT_BT_TIMINGS(1, 10000, 1, 10000, 0, 165000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 13000000, 165000000,
 			V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 			V4L2_DV_BT_CAP_PROGRESSIVE |
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 498ad2368cbc..f5ee28058ea2 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -49,7 +49,7 @@ static const struct v4l2_dv_timings_cap ths8200_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1080, 25000000, 148500000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1080, 25000000, 148500000,
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_BT_CAP_PROGRESSIVE)
 };
