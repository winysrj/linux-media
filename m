Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34098 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753326AbdC1AnC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 20:43:02 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v6 38/39] media: imx-ic-prpencvf: add frame size enumeration
Date: Mon, 27 Mar 2017 17:40:55 -0700
Message-Id: <1490661656-10318-39-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add frame size enumeration operation. The PRP ENC/VF subdevices
are scalers, so they can output a continuous range of widths/
heights on their source pads.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 40 +++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 4123b03..860b406 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -875,6 +875,45 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static int prp_enum_frame_size(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct prp_priv *priv = sd_to_priv(sd);
+	struct v4l2_subdev_format format = {0};
+	const struct imx_media_pixfmt *cc;
+	int ret = 0;
+
+	if (fse->pad >= PRPENCVF_NUM_PADS || fse->index != 0)
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+
+	format.pad = fse->pad;
+	format.which = fse->which;
+	format.format.code = fse->code;
+	format.format.width = 1;
+	format.format.height = 1;
+	prp_try_fmt(priv, cfg, &format, &cc);
+	fse->min_width = format.format.width;
+	fse->min_height = format.format.height;
+
+	if (format.format.code != fse->code) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	format.format.code = fse->code;
+	format.format.width = -1;
+	format.format.height = -1;
+	prp_try_fmt(priv, cfg, &format, &cc);
+	fse->max_width = format.format.width;
+	fse->max_height = format.format.height;
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
 static int prp_link_setup(struct media_entity *entity,
 			  const struct media_pad *local,
 			  const struct media_pad *remote, u32 flags)
@@ -1125,6 +1164,7 @@ static void prp_unregistered(struct v4l2_subdev *sd)
 
 static struct v4l2_subdev_pad_ops prp_pad_ops = {
 	.enum_mbus_code = prp_enum_mbus_code,
+	.enum_frame_size = prp_enum_frame_size,
 	.get_fmt = prp_get_fmt,
 	.set_fmt = prp_set_fmt,
 	.link_validate = prp_link_validate,
-- 
2.7.4
