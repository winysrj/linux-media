Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2897 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2EKHzp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 15/16] hexium-orion: fix incorrect input table.
Date: Fri, 11 May 2012 09:55:09 +0200
Message-Id: <92ee7aee2072faa19782b564c2f94660710c15a6.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix the standard and audioset values.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/hexium_orion.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/hexium_orion.c b/drivers/media/video/hexium_orion.c
index e549339..a1eb26d 100644
--- a/drivers/media/video/hexium_orion.c
+++ b/drivers/media/video/hexium_orion.c
@@ -41,15 +41,15 @@ static int hexium_num;
 
 #define HEXIUM_INPUTS	9
 static struct v4l2_input hexium_inputs[HEXIUM_INPUTS] = {
-	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
 };
 
 #define HEXIUM_AUDIOS	0
-- 
1.7.10

