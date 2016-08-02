Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:52979 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965289AbcHBOvm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 10:51:42 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 2/7] media: rcar-vin: allow field to be changed
Date: Tue,  2 Aug 2016 16:51:02 +0200
Message-Id: <20160802145107.24829-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver forced whatever field was set by the source subdevice to be
used. This patch allows the user to change from the default field.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 10a5c10..6d4086a 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -102,6 +102,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	struct v4l2_subdev_format format = {
 		.which = which,
 	};
+	enum v4l2_field field;
 	int ret;
 
 	sd = vin_to_source(vin);
@@ -114,6 +115,8 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	format.pad = vin->src_pad_idx;
 
+	field = pix->field;
+
 	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
 					 pad_cfg, &format);
 	if (ret < 0)
@@ -121,6 +124,8 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	v4l2_fill_pix_format(pix, &format.format);
 
+	pix->field = field;
+
 	source->width = pix->width;
 	source->height = pix->height;
 
@@ -144,6 +149,10 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	rwidth = pix->width;
 	rheight = pix->height;
 
+	/* Keep current field if no specific one is asked for */
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = vin->format.field;
+
 	/*
 	 * Retrieve format information and select the current format if the
 	 * requested format isn't supported.
-- 
2.9.0

