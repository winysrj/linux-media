Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34108 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbbICXQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2015 19:16:37 -0400
Received: by lbbmp1 with SMTP id mp1so2394315lbb.1
        for <linux-media@vger.kernel.org>; Thu, 03 Sep 2015 16:16:36 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 2/3] ml86v7667: implement g_std() method
Date: Fri, 04 Sep 2015 02:16:34 +0300
Message-ID: <1725998.gULFgFImHk@wasted.cogentembedded.com>
In-Reply-To: <6015647.cjLjRfTWc7@wasted.cogentembedded.com>
References: <6015647.cjLjRfTWc7@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver was written with the 'soc_camera' use in mind, however the g_std()
video method was forgotten. Implement it at last...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
 drivers/media/i2c/ml86v7667.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: media_tree/drivers/media/i2c/ml86v7667.c
===================================================================
--- media_tree.orig/drivers/media/i2c/ml86v7667.c
+++ media_tree/drivers/media/i2c/ml86v7667.c
@@ -233,6 +233,15 @@ static int ml86v7667_g_mbus_config(struc
 	return 0;
 }
 
+static int ml86v7667_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	struct ml86v7667_priv *priv = to_ml86v7667(sd);
+
+	*std = priv->std;
+
+	return 0;
+}
+
 static int ml86v7667_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct ml86v7667_priv *priv = to_ml86v7667(sd);
@@ -282,6 +291,7 @@ static const struct v4l2_ctrl_ops ml86v7
 };
 
 static struct v4l2_subdev_video_ops ml86v7667_subdev_video_ops = {
+	.g_std = ml86v7667_g_std,
 	.s_std = ml86v7667_s_std,
 	.querystd = ml86v7667_querystd,
 	.g_input_status = ml86v7667_g_input_status,

