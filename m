Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0053.outbound.protection.outlook.com ([104.47.41.53]:1440
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750762AbeBGW3z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 17:29:55 -0500
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satishna@xilinx.com>
Subject: [PATCH 7/8] v4l: xilinx: dma: Add scaling and padding factor functions
Date: Wed, 7 Feb 2018 14:29:37 -0800
Message-ID: <1518042578-22771-8-git-send-email-satishna@xilinx.com>
In-Reply-To: <1518042578-22771-1-git-send-email-satishna@xilinx.com>
References: <1518042578-22771-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

scaling_factor function returns multiplying factor to calculate
bytes per component based on color format.
For eg. scaling factor of YUV420 8 bit format is 1
so multiplying factor is 1 (8/8)
scaling factor of YUV420 10 bit format is 1.25 (10/8)

padding_factor function returns multiplying factor to calculate
actual width of video according to color format.
For eg. padding factor of YUV420 8 bit format: 8 bits per 1 component
no padding bits here, so multiplying factor is 1
padding factor of YUV422 10 bit format: 32 bits per 3 components
each component is 10 bit and the factor is 32/30

Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-vip.c | 43 ++++++++++++++++++++++++++=
++++
 drivers/media/platform/xilinx/xilinx-vip.h |  2 ++
 2 files changed, 45 insertions(+)

diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/pla=
tform/xilinx/xilinx-vip.c
index 51b7ef6..7543b75 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.c
+++ b/drivers/media/platform/xilinx/xilinx-vip.c
@@ -94,6 +94,49 @@ const struct xvip_video_format *xvip_get_format_by_fourc=
c(u32 fourcc)
 EXPORT_SYMBOL_GPL(xvip_get_format_by_fourcc);

 /**
+ * xvip_bpl_scaling_factor - Retrieve bpl scaling factor for a 4CC
+ * @fourcc: the format 4CC
+ *
+ * Return: Return numerator and denominator values by address
+ */
+void xvip_bpl_scaling_factor(u32 fourcc, u32 *numerator, u32 *denominator)
+{
+       switch (fourcc) {
+       case V4L2_PIX_FMT_XV15M:
+               *numerator =3D 10;
+               *denominator =3D 8;
+               break;
+       default:
+               *numerator   =3D 1;
+               *denominator =3D 1;
+               break;
+       }
+}
+EXPORT_SYMBOL_GPL(xvip_bpl_scaling_factor);
+
+/**
+ * xvip_width_padding_factor - Retrieve width's padding factor for a 4CC
+ * @fourcc: the format 4CC
+ *
+ * Return: Return numerator and denominator values by address
+ */
+void xvip_width_padding_factor(u32 fourcc, u32 *numerator, u32 *denominato=
r)
+{
+       switch (fourcc) {
+       case V4L2_PIX_FMT_XV15M:
+               /* 32 bits are required per 30 bits of data */
+               *numerator =3D 32;
+               *denominator =3D 30;
+               break;
+       default:
+               *numerator   =3D 1;
+               *denominator =3D 1;
+               break;
+       }
+}
+EXPORT_SYMBOL_GPL(xvip_width_padding_factor);
+
+/**
  * xvip_of_get_format - Parse a device tree node and return format informa=
tion
  * @node: the device tree node
  *
diff --git a/drivers/media/platform/xilinx/xilinx-vip.h b/drivers/media/pla=
tform/xilinx/xilinx-vip.h
index 006dcf77..26fada7 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.h
+++ b/drivers/media/platform/xilinx/xilinx-vip.h
@@ -135,6 +135,8 @@ struct xvip_video_format {
 const struct xvip_video_format *xvip_get_format_by_code(unsigned int code)=
;
 const struct xvip_video_format *xvip_get_format_by_fourcc(u32 fourcc);
 const struct xvip_video_format *xvip_of_get_format(struct device_node *nod=
e);
+void xvip_bpl_scaling_factor(u32 fourcc, u32 *numerator, u32 *denominator)=
;
+void xvip_width_padding_factor(u32 fourcc, u32 *numerator, u32 *denominato=
r);
 void xvip_set_format_size(struct v4l2_mbus_framefmt *format,
                          const struct v4l2_subdev_format *fmt);
 int xvip_enum_mbus_code(struct v4l2_subdev *subdev,
--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
