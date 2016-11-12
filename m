Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33436 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965778AbcKLNNo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:44 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 12/32] media: rcar-vin: split rvin_s_fmt_vid_cap()
Date: Sat, 12 Nov 2016 14:11:56 +0100
Message-Id: <20161112131216.22635-13-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functionality provided by rvin_s_fmt_vid_cap() will be needed in
other places to add Gen3 support. Split it up in a function which do the
work and one which interface with the v4l2 API.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 51324c6..929f58b 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -313,10 +313,8 @@ static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
 				 &source);
 }
 
-static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
-			      struct v4l2_format *f)
+static int __rvin_s_fmt_vid_cap(struct rvin_dev *vin, struct v4l2_format *f)
 {
-	struct rvin_dev *vin = video_drvdata(file);
 	struct rvin_source_fmt source;
 	int ret;
 
@@ -338,6 +336,14 @@ static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
+			      struct v4l2_format *f)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+
+	return __rvin_s_fmt_vid_cap(vin, f);
+}
+
 static int rvin_g_fmt_vid_cap(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
-- 
2.10.2

