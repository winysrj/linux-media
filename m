Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33620 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965865AbcKLNNy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:54 -0500
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
Subject: [PATCHv2 28/32] media: rcar-vin: propagate format to bridge
Date: Sat, 12 Nov 2016 14:12:12 +0100
Message-Id: <20161112131216.22635-29-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI2 bridge needs to know the video format, propagate it after the
video source have had its say on the format.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index e99815f..d363531 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -193,6 +193,21 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		goto done;
 
+	/* If we are part of a CSI2 group update bridge */
+	if (vin_have_bridge(vin)) {
+		struct v4l2_subdev *bridge = vin_to_bridge(vin);
+
+		if (!bridge) {
+			ret = -EINVAL;
+			goto done;
+		}
+
+		format.pad = 0;
+		ret = v4l2_subdev_call(bridge, pad, set_fmt, pad_cfg, &format);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			goto done;
+	}
+
 	v4l2_fill_pix_format(pix, &format.format);
 
 	pix->field = field;
-- 
2.10.2

