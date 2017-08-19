Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57904
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750854AbdHSKSH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 06:18:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by osg.samsung.com (Postfix) with ESMTP id 90731A0CAD
        for <linux-media@vger.kernel.org>; Sat, 19 Aug 2017 10:18:35 +0000 (UTC)
Received: from osg.samsung.com ([127.0.0.1])
        by localhost (s-opensource.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oYyDddDCWS7g for <linux-media@vger.kernel.org>;
        Sat, 19 Aug 2017 10:18:35 +0000 (UTC)
Received: from vento.lan (unknown [189.61.49.22])
        by osg.samsung.com (Postfix) with ESMTPSA id 5489BA06C2
        for <linux-media@vger.kernel.org>; Sat, 19 Aug 2017 10:18:34 +0000 (UTC)
From: Mauro Carvalho Chehab <mchehab@s-opensource.com> (by way of Mauro
        Carvalho Chehab <mchehab@s-opensource.com>)
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Date: Sat, 19 Aug 2017 07:04:40 -0300
Message-Id: <bd5323f2ca5d4693f1f4dcdc7b41389144340f51.1503136835.git.mchehab@s-opensource.com>
Subject: [PATCH RFC] media: open.rst: document devnode-centric and
 mc-centric types
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When we added support for omap3, back in 2010, we added a new
type of V4L2 devices that aren't fully controlled via the V4L2
device node. Yet, we never made it clear, at the V4L2 spec,
about the differences between both types.

Let's document them with the current implementation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

This patch is a result of this week's discussion we had with regards to merging
a patch series from Sakari documenting the need of propagating streaming
control between sub-devices on some complex mc-centric devices.

One big gap on our documentation popped up: while we have distinct behavior
for mc-centric and devnode-centric types of V4L2 devices, we never clearly
documented about that.

This RFC patch is a first attempt to have a definition of those types, and to
standardize the names we use to distinguish between those types.

Comments are welcome.


 Documentation/media/uapi/v4l/open.rst | 37 +++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index afd116edb40d..9cf4f74c466a 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -6,6 +6,43 @@
 Opening and Closing Devices
 ***************************
 
+Types of V4L2 devices
+=====================
+
+V4L2 devices are usually complex: they're implemented via a main driver and
+several other drivers. The main driver always exposes a V4L2 device node
+(see :ref:`v4l2_device_naming`). The other devices are called **sub-devices**.
+They are usually controlled via a serial bus (I2C or SMBus).
+
+When V4L2 started, there was only one type of device, fully controlled via
+V4L2 device nodes. We call those devices as **devnode-centric devices**.
+Since the end of 2010, a new type of V4L2 device was added, in order to
+support complex devices that are common on embedded systems. Those devices
+are controlled mainly via the media controller. So, they're called:
+**mc-centric devices**.
+
+On a **devnode-centric device**, the device and their corresponding hardware
+pipelines are controlled via the V4L2 device node. They may optionally
+expose the hardware pipelines via the
+:ref:`media controller API <media_controller>`.
+
+On a **mc-centric device**, before using the V4L2 device, it is required to
+set the hardware pipelines via the
+:ref:`media controller API <media_controller>`. On those devices, the
+sub-devices' configuration can be controlled via the
+:ref:`sub-device API <subdev>`, with creates one device node per sub device.
+On such devices, the V4L2 device node is mainly responsible for controlling
+the streaming features, while the media controller and the subdevices device
+nodes are responsible for configuring the hardware.
+
+.. note::
+
+   Currently, it is forbidden for a **devnode-centric device** to expose
+   subdevices via :ref:`sub-device API <subdev>`, although this might
+   change in the future.
+
+
+.. _v4l2_device_naming:
 
 Device Naming
 =============
-- 
2.13.3
