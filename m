Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47851 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2IZJsR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 05:48:17 -0400
Received: by wibhr7 with SMTP id hr7so481354wib.1
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 02:48:16 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, mchehab@infradead.org, hverkuil@xs4all.nl,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/5] media: ov7670: make try_fmt() consistent with 'min_height' and 'min_width'.
Date: Wed, 26 Sep 2012 11:47:54 +0200
Message-Id: <1348652877-25816-3-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'min_height' and 'min_width' are variables that allow to specify the minimum
resolution that the sensor will achieve. This patch make v4l2 fmt callbacks
consider this parameters in order to return valid data to user space.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/i2c/ov7670.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 0478a7b..627fe5f 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -812,10 +812,11 @@ static int ov7670_try_fmt_internal(struct v4l2_subdev *sd,
 		struct ov7670_format_struct **ret_fmt,
 		struct ov7670_win_size **ret_wsize)
 {
-	int index;
+	int index, i;
 	struct ov7670_win_size *wsize;
 	struct ov7670_info *info = to_state(sd);
 	int n_win_sizes = ARRAY_SIZE(ov7670_win_sizes[info->model]);
+	int win_sizes_limit = n_win_sizes;
 
 	for (index = 0; index < N_OV7670_FMTS; index++)
 		if (ov7670_formats[index].mbus_code == fmt->code)
@@ -831,15 +832,30 @@ static int ov7670_try_fmt_internal(struct v4l2_subdev *sd,
 	 * Fields: the OV devices claim to be progressive.
 	 */
 	fmt->field = V4L2_FIELD_NONE;
+
+	/*
+	 * Don't consider values that don't match min_height and min_width
+	 * constraints.
+	 */
+	if (info->min_width || info->min_height)
+		for (i = 0; i < n_win_sizes; i++) {
+			wsize = ov7670_win_sizes[info->model] + i;
+
+			if (wsize->width < info->min_width ||
+				wsize->height < info->min_height) {
+				win_sizes_limit = i;
+				break;
+			}
+		}
 	/*
 	 * Round requested image size down to the nearest
 	 * we support, but not below the smallest.
 	 */
 	for (wsize = ov7670_win_sizes[info->model];
-	     wsize < ov7670_win_sizes[info->model] + n_win_sizes; wsize++)
+	     wsize < ov7670_win_sizes[info->model] + win_sizes_limit; wsize++)
 		if (fmt->width >= wsize->width && fmt->height >= wsize->height)
 			break;
-	if (wsize >= ov7670_win_sizes[info->model] + n_win_sizes)
+	if (wsize >= ov7670_win_sizes[info->model] + win_sizes_limit)
 		wsize--;   /* Take the smallest one */
 	if (ret_wsize != NULL)
 		*ret_wsize = wsize;
-- 
1.7.9.5

