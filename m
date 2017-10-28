Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:53811 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751893AbdJ1UlR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 16:41:17 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 9/9] media: staging/imx: update TODO
Date: Sat, 28 Oct 2017 13:36:49 -0700
Message-Id: <1509223009-6392-10-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
References: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update TODO file:

- Remove TODO info about the OV564x driver, while this still needs
  to be done (add a OV5642 driver or merge with OV5640 driver), it
  is not relevant here.

- Update TODO about methods for retrieving CSI bus config.

- Add some TODO's about OF graph parsing restrictions.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/TODO | 63 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/imx/TODO b/drivers/staging/media/imx/TODO
index 0bee313..9eb7326 100644
--- a/drivers/staging/media/imx/TODO
+++ b/drivers/staging/media/imx/TODO
@@ -1,19 +1,14 @@
 
-- Clean up and move the ov5642 subdev driver to drivers/media/i2c, or
-  merge support for OV5642 into drivers/media/i2c/ov5640.c, and create
-  the binding docs for it.
-
 - The Frame Interval Monitor could be exported to v4l2-core for
   general use.
 
-- At driver load time, the device-tree node that is the original source
-  (the "sensor"), is parsed to record its media bus configuration, and
-  this info is required in imx-media-csi.c to setup the CSI.
-  Laurent Pinchart argues that instead the CSI subdev should call its
-  neighbor's g_mbus_config op (which should be propagated if necessary)
-  to get this info. However Hans Verkuil is planning to remove the
-  g_mbus_config op. For now this driver uses the parsed DT mbus config
-  method until this issue is resolved.
+- The CSI subdevice parses its nearest upstream neighbor's device-tree
+  bus config in order to setup the CSI. Laurent Pinchart argues that
+  instead the CSI subdev should call its neighbor's g_mbus_config op
+  (which should be propagated if necessary) to get this info. However
+  Hans Verkuil is planning to remove the g_mbus_config op. For now this
+  driver uses the parsed DT bus config method until this issue is
+  resolved.
 
 - This media driver supports inheriting V4L2 controls to the
   video capture devices, from the subdevices in the capture device's
@@ -21,3 +16,47 @@
   link_notify callback when the pipeline is modified. It should be
   decided whether this feature is useful enough to make it generally
   available by exporting to v4l2-core.
+
+- The OF graph is walked at probe time to form the list of fwnodes to
+  be passed to v4l2_async_notifier_register(), starting from the IPU
+  CSI ports. And after all async subdevices have been bound,
+  v4l2_fwnode_parse_link() is used to form the media links between
+  the entities discovered by walking the OF graph.
+
+  While this approach allows support for arbitrary OF graphs, there
+  are some assumptions for this to work:
+
+  1. All port parent nodes reachable in the graph from the IPU CSI
+     ports bind to V4L2 async subdevice drivers.
+
+     If a device has mixed-use ports such as video plus audio, the
+     endpoints from the audio ports are followed to devices that must
+     bind to V4L2 subdevice drivers, and not for example, to an ALSA
+     driver or a non-V4L2 media driver. If the device were bound to
+     such a driver, imx-media would never get an async completion
+     notification because the device fwnode was added to the async
+     list, but the driver does not interface with the V4L2 async
+     framework.
+
+  2. Every port reachable in the graph is treated as a media pad,
+     owned by the V4L2 subdevice that is bound to the port's parent.
+
+     This presents problems for devices that don't make this port = pad
+     assumption. Examples are SMIAPP compatible cameras which define only
+     a single output port node, but which define multiple pads owned
+     by multiple subdevices (pixel-array, binner, scaler). Or video
+     decoders (entity function MEDIA_ENT_F_ATV_DECODER), which also define
+     only a single output port node, but define multiple pads for video,
+     VBI, and audio out.
+
+     A workaround at present is to set the port reg properties to
+     correspond to the media pad index that the port represents. A
+     possible long-term solution is to implement a subdev API that
+     maps a port id to a media pad index.
+
+  3. Every endpoint of a port reachable in the graph is treated as
+     a media link, between V4L2 subdevices that are bound to the
+     port parents of the local and remote endpoints.
+
+     Which means a port must not contain mixed-use endpoints, they
+     must all refer to media links between V4L2 subdevices.
-- 
2.7.4
