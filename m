Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1419 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3BPJ2q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:28:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/18] davinci_vpfe: fix copy-paste errors in several comments.
Date: Sat, 16 Feb 2013 10:28:07 +0100
Message-Id: <435f6000435782780f3eb57633664517306a8e29.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This removes some incorrect dv_preset references left over from copy-and-paste
errors.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 99ccbeb..19dc5b0 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1016,12 +1016,12 @@ vpfe_query_dv_timings(struct file *file, void *fh,
 }
 
 /*
- * vpfe_s_dv_timings() - set dv_preset on external subdev
+ * vpfe_s_dv_timings() - set dv_timings on external subdev
  * @file: file pointer
  * @priv: void pointer
  * @timings: pointer to v4l2_dv_timings structure
  *
- * set dv_timings pointed by preset on external subdev through
+ * set dv_timings pointed by timings on external subdev through
  * v4l2_device_call_until_err, this configures amplifier also
  *
  * Return 0 on success, error code otherwise
@@ -1042,12 +1042,12 @@ vpfe_s_dv_timings(struct file *file, void *fh,
 }
 
 /*
- * vpfe_g_dv_timings() - get dv_preset which is set on external subdev
+ * vpfe_g_dv_timings() - get dv_timings which is set on external subdev
  * @file: file pointer
  * @priv: void pointer
  * @timings: pointer to v4l2_dv_timings structure
  *
- * get dv_preset which is set on external subdev through
+ * get dv_timings which is set on external subdev through
  * v4l2_subdev_call
  *
  * Return 0 on success, error code otherwise
@@ -1423,7 +1423,7 @@ static int vpfe_dqbuf(struct file *file, void *priv,
 }
 
 /*
- * vpfe_streamon() - get dv_preset which is set on external subdev
+ * vpfe_streamon() - start streaming
  * @file: file pointer
  * @priv: void pointer
  * @buf_type: enum v4l2_buf_type
@@ -1472,7 +1472,7 @@ static int vpfe_streamon(struct file *file, void *priv,
 }
 
 /*
- * vpfe_streamoff() - get dv_preset which is set on external subdev
+ * vpfe_streamoff() - stop streaming
  * @file: file pointer
  * @priv: void pointer
  * @buf_type: enum v4l2_buf_type
-- 
1.7.10.4

