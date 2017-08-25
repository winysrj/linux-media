Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50722
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933581AbdHYPMF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 11:12:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 4/7] media: open.rst: document devnode-centric and mc-centric types
Date: Fri, 25 Aug 2017 12:11:54 -0300
Message-Id: <a52e12923a5c89cb22415451a7cb223928b9bcae.1503673702.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503673702.git.mchehab@s-opensource.com>
References: <cover.1503673702.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1503673702.git.mchehab@s-opensource.com>
References: <cover.1503673702.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When we added support for omap3, back in 2010, we added a new
type of V4L2 devices that aren't fully controlled via the V4L2
device node.

Yet, we have never clearly documented in the V4L2 specification
the differences between the two types.

Let's document them based on the the current implementation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/open.rst | 51 +++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 20f9fe29479b..0a92eadfe936 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -7,6 +7,57 @@ Opening and Closing Devices
 ***************************
 
 
+.. _v4l2_hardware_control:
+
+
+Types of V4L2 hardware peripheral control
+=========================================
+
+V4L2 hardware periferal is usually complex: support for it is
+implemented via a V4L2 main driver and often by several additional drivers.
+The main driver always exposes one or more **V4L2 device nodes**
+(see :ref:`v4l2_device_naming`).
+
+The other drivers are called **V4L2 sub-devices** and provide control to
+other hardware components usually connected via a serial bus (like
+I²C, SMBus or SPI). Depending on the main driver, they can be implicitly
+controlled directly by the main driver or explicitly via
+the **V4L2 sub-device API** (see :ref:`subdev`).
+
+When V4L2 was originally designed, there was only one type of
+peripheral control: via the **V4L2 device nodes**. We refer to this kind
+of control as **V4L2 device node centric** (or, simply, **vdev-centric**).
+
+Later (kernel 2.6.39), a new type of periferal control was
+added in order to support complex peripherals that are common for embedded
+systems. Those periferals are controlled mainly via the media
+controller and V4L2 sub-devices. So, they are called:
+**Media controller centric** (or, simply, "**MC-centric**").
+
+For **vdev-centric** hardware peripheral control, the peripheral is
+controlled via the **V4L2 device nodes**. They may optionally support the
+:ref:`media controller API <media_controller>` as well, in order to let
+the application to know with device nodes are available
+(see :ref:`related`).
+
+For **MC-centric** hardware peripheral control, before using the
+peripheral, it is required to set the pipelines via the
+
+:ref:`media controller API <media_controller>`. For those devices, the
+sub-devices' configuration can be controlled via the
+:ref:`sub-device API <subdev>`, whith creates one device node
+per sub-device.
+
+In summary, for **MC-centric** hardware peripheral control:
+
+- The **V4L2 device** node is responsible for controlling the streaming
+  features;
+- The **media controller device** is responsible to setup the pipelines
+  at the peripheral;
+- The **V4L2 sub-devices** are responsible for V4L2 sub-device
+  specific settings at the sub-device hardware components.
+
+
 .. _v4l2_device_naming:
 
 V4L2 Device Node Naming
-- 
2.13.3
