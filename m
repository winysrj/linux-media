Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1288 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966093Ab3E2OTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 13/14] tvp5150: fix s_std support
Date: Wed, 29 May 2013 16:19:06 +0200
Message-Id: <1369837147-8747-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- do exact matching for special formats like PAL-M
- drop autodetect support: it's non-standard, and it is bogus as well since there
  is no way to get back the detected standard since neither g_std nor querystd are
  implemented.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/tvp5150.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index b3cf266..0e95e5e 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -727,13 +727,11 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 
 	/* First tests should be against specific std */
 
-	if (std == V4L2_STD_ALL) {
-		fmt = VIDEO_STD_AUTO_SWITCH_BIT;	/* Autodetect mode */
-	} else if (std & V4L2_STD_NTSC_443) {
+	if (std == V4L2_STD_NTSC_443) {
 		fmt = VIDEO_STD_NTSC_4_43_BIT;
-	} else if (std & V4L2_STD_PAL_M) {
+	} else if (std == V4L2_STD_PAL_M) {
 		fmt = VIDEO_STD_PAL_M_BIT;
-	} else if (std & (V4L2_STD_PAL_N | V4L2_STD_PAL_Nc)) {
+	} else if (std == V4L2_STD_PAL_N || std == V4L2_STD_PAL_Nc) {
 		fmt = VIDEO_STD_PAL_COMBINATION_N_BIT;
 	} else {
 		/* Then, test against generic ones */
-- 
1.7.10.4

