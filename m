Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44515 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbeI3CYu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 22:24:50 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [RESEND PATCH v7 14/17] media: staging/imx: TODO: Remove one assumption about OF graph parsing
Date: Sat, 29 Sep 2018 12:54:17 -0700
Message-Id: <20180929195420.28579-15-slongerbeam@gmail.com>
In-Reply-To: <20180929195420.28579-1-slongerbeam@gmail.com>
References: <20180929195420.28579-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The move to subdev notifiers fixes one assumption of OF graph parsing.
If a subdevice has non-video related ports, the subdev driver knows not
to follow those ports when adding remote devices to its subdev notifier.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/TODO | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/imx/TODO b/drivers/staging/media/imx/TODO
index 9eb7326f3fc6..aeeb15494a49 100644
--- a/drivers/staging/media/imx/TODO
+++ b/drivers/staging/media/imx/TODO
@@ -17,29 +17,15 @@
   decided whether this feature is useful enough to make it generally
   available by exporting to v4l2-core.
 
-- The OF graph is walked at probe time to form the list of fwnodes to
-  be passed to v4l2_async_notifier_register(), starting from the IPU
-  CSI ports. And after all async subdevices have been bound,
-  v4l2_fwnode_parse_link() is used to form the media links between
-  the entities discovered by walking the OF graph.
+- After all async subdevices have been bound, v4l2_fwnode_parse_link()
+  is used to form the media links between the devices discovered in
+  the OF graph.
 
   While this approach allows support for arbitrary OF graphs, there
   are some assumptions for this to work:
 
-  1. All port parent nodes reachable in the graph from the IPU CSI
-     ports bind to V4L2 async subdevice drivers.
-
-     If a device has mixed-use ports such as video plus audio, the
-     endpoints from the audio ports are followed to devices that must
-     bind to V4L2 subdevice drivers, and not for example, to an ALSA
-     driver or a non-V4L2 media driver. If the device were bound to
-     such a driver, imx-media would never get an async completion
-     notification because the device fwnode was added to the async
-     list, but the driver does not interface with the V4L2 async
-     framework.
-
-  2. Every port reachable in the graph is treated as a media pad,
-     owned by the V4L2 subdevice that is bound to the port's parent.
+  1. If a port owned by a device in the graph has endpoint nodes, the
+     port is treated as a media pad.
 
      This presents problems for devices that don't make this port = pad
      assumption. Examples are SMIAPP compatible cameras which define only
@@ -54,9 +40,8 @@
      possible long-term solution is to implement a subdev API that
      maps a port id to a media pad index.
 
-  3. Every endpoint of a port reachable in the graph is treated as
-     a media link, between V4L2 subdevices that are bound to the
-     port parents of the local and remote endpoints.
+  2. Every endpoint of a port owned by a device in the graph is treated
+     as a media link.
 
      Which means a port must not contain mixed-use endpoints, they
      must all refer to media links between V4L2 subdevices.
-- 
2.17.1
