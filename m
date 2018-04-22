Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36633 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754524AbeDVP4q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 11:56:46 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v3 03/11] media: ov772x: add checks for register read errors
Date: Mon, 23 Apr 2018 00:56:09 +0900
Message-Id: <1524412577-14419-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change adds checks for register read errors and returns correct
error code.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v3
- Add a Reviewed-by: line

 drivers/media/i2c/ov772x.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 2ae730f..f25150d 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1146,7 +1146,7 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
 static int ov772x_video_probe(struct ov772x_priv *priv)
 {
 	struct i2c_client  *client = v4l2_get_subdevdata(&priv->subdev);
-	u8                  pid, ver;
+	int		    pid, ver, midh, midl;
 	const char         *devname;
 	int		    ret;
 
@@ -1156,7 +1156,11 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
 
 	/* Check and show product ID and manufacturer ID. */
 	pid = ov772x_read(client, PID);
+	if (pid < 0)
+		return pid;
 	ver = ov772x_read(client, VER);
+	if (ver < 0)
+		return ver;
 
 	switch (VERSION(pid, ver)) {
 	case OV7720:
@@ -1172,13 +1176,17 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
 		goto done;
 	}
 
+	midh = ov772x_read(client, MIDH);
+	if (midh < 0)
+		return midh;
+	midl = ov772x_read(client, MIDL);
+	if (midl < 0)
+		return midl;
+
 	dev_info(&client->dev,
 		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
-		 devname,
-		 pid,
-		 ver,
-		 ov772x_read(client, MIDH),
-		 ov772x_read(client, MIDL));
+		 devname, pid, ver, midh, midl);
+
 	ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
 done:
-- 
2.7.4
