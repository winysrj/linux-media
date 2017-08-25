Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50110
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755111AbdHYMwy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 08:52:54 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: "mchehab@s-opensource.com" <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 2/3] media: open.rst: document devnode-centric and mc-centric types
Date: Fri, 25 Aug 2017 09:52:41 -0300
Message-Id: <e789d3d71c7f784d17ffcd8389ce56ae950f736e.1503665390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503665390.git.mchehab@s-opensource.com>
References: <cover.1503665390.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1503665390.git.mchehab@s-opensource.com>
References: <cover.1503665390.git.mchehab@s-opensource.com>
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
 Documentation/media/uapi/v4l/open.rst | 53 +++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 9b98d10d5153..bbd1887f83a0 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -6,6 +6,59 @@
 Opening and Closing Devices
 ***************************
 
+Types of V4L2 hardware control
+==============================
+
+V4L2 hardware is usually complex: support for the hardware is implemented
+via a main driver (also known as bridge driver) and often several
+additional drivers. The main driver always exposes one or
+more **V4L2 device nodes** (see :ref:`v4l2_device_naming`).
+
+The other drivers are called **V4L2 sub-devices** and provide control to
+other parts of the hardware usually connected via a serial bus (like
+I²C, SMBus or SPI). Depending on the main driver, they can be implicitly
+controlled directly by the main driver or explicitly via
+the **V4L2 sub-device API** (see :ref:`subdev`).
+
+When V4L2 was originally designed, there was only one type of hardware
+control. The entire V4L2 hardware is controlled via the
+**V4L2 device nodes**. We refer to this kind of control as
+**V4L2 device node centric** (or, simply, **vdev-centric**).
+
+Since the end of 2010, a new type of V4L2 hardware control was added, in
+order to support complex devices that are common for embedded systems.
+Those hardware are controlled mainly via the media controller and
+sub-devices. So, they are called: **Media controller centric**
+(or, simply, "**MC-centric**").
+
+For **vdev-centric** hardware control, the hardware is controlled via
+the **V4L2 device nodes**. They may optionally support the
+:ref:`media controller API <media_controller>` as well, in order to let
+the application to know with device nodes are available.
+
+.. note::
+
+   A **vdev-centric** may optionally expose V4L2 sub-devices via
+   :ref:`sub-device API <subdev>`. In that case, it has to implement
+   the :ref:`media controller API <media_controller>` as well.
+
+For **MC-centric** hardware control, before using the V4L2 hardware,
+it is required to set the pipelines via the
+:ref:`media controller API <media_controller>`. For those devices, the
+sub-devices' configuration can be controlled via the
+:ref:`sub-device API <subdev>`, whith creates one device node
+per sub-device.
+
+In summary, for **MC-centric** hardware control:
+
+- The **V4L2 device** node is responsible for controlling the streaming
+  features;
+- The **media controller device** is responsible to setup the pipelines;
+- The **V4L2 sub-devices** are responsible for sub-device
+  specific settings.
+
+
+.. _v4l2_device_naming:
 
 V4L2 Device Node Naming
 =======================
-- 
2.13.3
