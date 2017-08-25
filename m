Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49389
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754403AbdHYJkN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 05:40:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: "mchehab@s-opensource.com" <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/3] media: open.rst: document devnode-centric and mc-centric types
Date: Fri, 25 Aug 2017 06:40:05 -0300
Message-Id: <bef8524bf9eb1fbf51fff93d59c42602009858c1.1503653839.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503653839.git.mchehab@s-opensource.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1503653839.git.mchehab@s-opensource.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "mchehab@s-opensource.com" <mchehab@s-opensource.com>

When we added support for omap3, back in 2010, we added a new
type of V4L2 devices that aren't fully controlled via the V4L2
device node. Yet, we never made it clear, at the V4L2 spec,
about the differences between both types.

Let's document them with the current implementation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/open.rst | 50 +++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index afd116edb40d..a72d142897c0 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -6,6 +6,56 @@
 Opening and Closing Devices
 ***************************
 
+Types of V4L2 hardware control
+==============================
+
+V4L2 devices are usually complex: they are implemented via a main driver and
+often several additional drivers. The main driver always exposes one or
+more **V4L2 device** devnodes (see :ref:`v4l2_device_naming`).
+
+The other drivers are called **V4L2 sub-devices** and provide control to
+other parts of the hardware usually connected via a serial bus (like
+I²C, SMBus or SPI). They can be implicitly controlled directly by the
+main driver or explicitly through via the **V4L2 sub-device API** interface.
+
+When V4L2 was originally designed, there was only one type of device control.
+The entire device was controlled via the **V4L2 device nodes**. We refer to
+this kind of control as **V4L2 device node centric** (or, simply,
+**vdev-centric**).
+
+Since the end of 2010, a new type of V4L2 device control was added in order
+to support complex devices that are common for embedded systems. Those
+devices are controlled mainly via the media controller and sub-devices.
+So, they're called: **Media controller centric** (or, simply,
+"**MC-centric**").
+
+For **vdev-centric** control, the device and their corresponding hardware
+pipelines are controlled via the **V4L2 device** node. They may optionally
+expose via the :ref:`media controller API <media_controller>`.
+
+For **MC-centric** control, before using the V4L2 device, it is required to
+set the hardware pipelines via the
+:ref:`media controller API <media_controller>`. For those devices, the
+sub-devices' configuration can be controlled via the
+:ref:`sub-device API <subdev>`, with creates one device node per sub device.
+
+In summary, for **MC-centric** devices:
+
+- The **V4L2 device** node is responsible for controlling the streaming
+  features;
+- The **media controller device** is responsible to setup the pipelines;
+- The **V4L2 sub-devices** are responsible for sub-device
+  specific settings.
+
+.. note::
+
+   A **vdev-centric** may optionally expose V4L2 sub-devices via
+   :ref:`sub-device API <subdev>`. In that case, it has to implement
+   the :ref:`media controller API <media_controller>` as well.
+
+
+
+.. _v4l2_device_naming:
 
 Device Naming
 =============
-- 
2.13.3
