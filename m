Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53596
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752183AbdHZLxf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 07:53:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v4 1/7] media: add glossary.rst with a glossary of terms used at V4L2 spec
Date: Sat, 26 Aug 2017 08:53:19 -0300
Message-Id: <e529a2ac2346e50c5c314d1f1352d88fdb7180c4.1503747774.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503747774.git.mchehab@s-opensource.com>
References: <cover.1503747774.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1503747774.git.mchehab@s-opensource.com>
References: <cover.1503747774.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a glossary of terms for V4L2, as several concepts are complex
enough to cause misunderstandings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/glossary.rst | 98 +++++++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/v4l2.rst     |  1 +
 2 files changed, 99 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/glossary.rst

diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
new file mode 100644
index 000000000000..e55cd357dad3
--- /dev/null
+++ b/Documentation/media/uapi/v4l/glossary.rst
@@ -0,0 +1,98 @@
+========
+Glossary
+========
+
+.. note::
+
+   This goal of section is to standardize the terms used within the V4L2
+   documentation. It is written incrementally as they're standardized at
+   the V4L2 documentation. So, it is an incomplete Work In Progress.
+
+.. Please keep the glossary entries in alphabetical order
+
+.. glossary::
+
+    Bridge driver
+	 The same as V4L2 main driver.
+
+    Device Node
+	 A character device node at the file system used to control and do
+	 input/output data transfers to a Kernel driver.
+
+    Driver
+	 The part of the Linux Kernel that implements support
+	 for a hardware component.
+
+    Inter-Integrated Circuit - I²C
+	 A  multi-master, multi-slave, packet switched, single-ended,
+	 serial computer bus used to control V4L2 sub-devices
+
+    Hardware component
+	 a subset of the media hardware.
+
+    Hardware peripheral
+	 A group of hardware components that together make a larger
+	 user-facing functional peripheral. For instance the SoC ISP IP
+	 cores and external camera sensors together make a
+	 camera hardware peripheral.
+	 Also known as peripheral.
+
+    Hardware peripheral control
+	 Type of control that it is possible for a V4L2 hardware peripheral.
+
+	 See :ref:`v4l2_hardware_control`.
+
+    Peripheral
+	 The same as hardware peripheral.
+
+    Media Controller
+	 An API used to identify the hardware components.
+
+	 See :ref:`media_controller`.
+
+    MC-centric
+	 V4L2 hardware that requires a Media controller to be controlled.
+
+	 See :ref:`v4l2_hardware_control`.
+
+    SMBus
+	 A subset of I²C, with defines a stricter usage of the bus.
+
+    Serial Peripheral Interface Bus - SPI
+	 Synchronous serial communication interface specification used for
+	 short distance communication, primarily in embedded systems.
+
+    Sub-device hardware components
+	 hardware components that aren't controlled by the
+	 V4L2 main driver.
+
+    V4L2 device node
+	 A device node that it is associated to a V4L2 main driver,
+	 as specified at :ref:`v4l2_device_naming`.
+
+    V4L2 hardware
+	 A hardware used to on a media device supported by the V4L2
+	 subsystem.
+
+    V4L2 hardware control
+	 The type of hardware control that a device supports.
+
+	 See :ref:`v4l2_hardware_control`.
+
+    V4L2 main driver
+	 The V4L2 device driver that implements the main logic to talk with
+	 the V4L2 hardware.
+	 Also known as bridge driver.
+
+	 See :ref:`v4l2_hardware_control`.
+
+    V4L2 sub-device
+	 part of the media hardware that it is implemented by a device
+	 driver that is not part of the main V4L2 driver.
+
+	 See :ref:`subdev`.
+
+    Vdev-centric
+	 V4L2 hardware that it is controlled via V4L2 device nodes.
+
+	 See :ref:`v4l2_hardware_control`.
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index f52a11c949d3..1ee4b86d18e1 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -31,6 +31,7 @@ This part describes the Video for Linux API version 2 (V4L2 API) specification.
     videodev
     capture-example
     v4l2grab-example
+    glossary
     biblio
 
 
-- 
2.13.3
