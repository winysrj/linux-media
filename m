Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34921 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754797AbdCJEyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 23:54:25 -0500
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
Subject: [PATCH v5 18/39] [media] v4l: subdev: Add function to validate frame interval
Date: Thu,  9 Mar 2017 20:52:58 -0800
Message-Id: <1489121599-23206-19-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the pads on both sides of a link specify a frame interval, then
those frame intervals should match. Create the exported function
v4l2_subdev_link_validate_frame_interval() to verify this. This
function can be called in a subdevice's media_entity_operations
or v4l2_subdev_pad_ops link_validate callbacks.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 50 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-subdev.h           | 10 +++++++
 2 files changed, 60 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index da78497..7a0f387 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -521,6 +521,25 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate_default);
 
 static int
+v4l2_subdev_link_validate_get_fi(struct media_pad *pad,
+				 struct v4l2_subdev_frame_interval *fi)
+{
+	if (is_media_entity_v4l2_subdev(pad->entity)) {
+		struct v4l2_subdev *sd =
+			media_entity_to_v4l2_subdev(pad->entity);
+
+		fi->pad = pad->index;
+		return v4l2_subdev_call(sd, video, g_frame_interval, fi);
+	}
+
+	WARN(pad->entity->function != MEDIA_ENT_F_IO_V4L,
+	     "Driver bug! Wrong media entity type 0x%08x, entity %s\n",
+	     pad->entity->function, pad->entity->name);
+
+	return -EINVAL;
+}
+
+static int
 v4l2_subdev_link_validate_get_format(struct media_pad *pad,
 				     struct v4l2_subdev_format *fmt)
 {
@@ -540,6 +559,37 @@ v4l2_subdev_link_validate_get_format(struct media_pad *pad,
 	return -EINVAL;
 }
 
+int v4l2_subdev_link_validate_frame_interval(struct media_link *link)
+{
+	struct v4l2_subdev_frame_interval src_fi, sink_fi;
+	unsigned long src_usec, sink_usec;
+	int rval;
+
+	rval = v4l2_subdev_link_validate_get_fi(link->source, &src_fi);
+	if (rval < 0)
+		return 0;
+
+	rval = v4l2_subdev_link_validate_get_fi(link->sink, &sink_fi);
+	if (rval < 0)
+		return 0;
+
+	if (src_fi.interval.numerator == 0   ||
+	    src_fi.interval.denominator == 0 ||
+	    sink_fi.interval.numerator == 0  ||
+	    sink_fi.interval.denominator == 0)
+		return -EPIPE;
+
+	src_usec = DIV_ROUND_CLOSEST_ULL(
+		(u64)src_fi.interval.numerator * USEC_PER_SEC,
+		src_fi.interval.denominator);
+	sink_usec = DIV_ROUND_CLOSEST_ULL(
+		(u64)sink_fi.interval.numerator * USEC_PER_SEC,
+		sink_fi.interval.denominator);
+
+	return (src_usec != sink_usec) ? -EPIPE : 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate_frame_interval);
+
 int v4l2_subdev_link_validate(struct media_link *link)
 {
 	struct v4l2_subdev *sink;
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 0ab1c5d..60c941d 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -929,6 +929,16 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 				      struct v4l2_subdev_format *sink_fmt);
 
 /**
+ * v4l2_subdev_link_validate_frame_interval - validates a media link
+ *
+ * @link: pointer to &struct media_link
+ *
+ * This function ensures that the frame intervals, if specified by
+ * both the source and sink subdevs of the link, are equal.
+ */
+int v4l2_subdev_link_validate_frame_interval(struct media_link *link);
+
+/**
  * v4l2_subdev_link_validate - validates a media link
  *
  * @link: pointer to &struct media_link
-- 
2.7.4
