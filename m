Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:32898 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932900AbcIBQqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 12:46:55 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, hans.verkuil@cisco.com
Cc: slongerbeam@gmail.com, lars@metafoo.de, mchehab@kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 3/6] media: rcar-vin: allow field to be changed
Date: Fri,  2 Sep 2016 18:44:58 +0200
Message-Id: <20160902164501.19535-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160902164501.19535-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160902164501.19535-1-niklas.soderlund+renesas@ragnatech.se>
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
index 62ca7e3..88bfee3 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -102,6 +102,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	struct v4l2_subdev_format format = {
 		.which = which,
 	};
+	enum v4l2_field field;
 	int ret;
 
 	sd = vin_to_source(vin);
@@ -114,12 +115,16 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	format.pad = vin->src_pad_idx;
 
+	field = pix->field;
+
 	ret = v4l2_subdev_call(sd, pad, set_fmt, pad_cfg, &format);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		goto done;
 
 	v4l2_fill_pix_format(pix, &format.format);
 
+	pix->field = field;
+
 	source->width = pix->width;
 	source->height = pix->height;
 
@@ -143,6 +148,10 @@ static int __rvin_try_format(struct rvin_dev *vin,
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
2.9.3

