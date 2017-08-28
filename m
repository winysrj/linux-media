Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58259
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751290AbdH1MyL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 08:54:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 1/7] media: add glossary.rst with a glossary of terms used at V4L2 spec
Date: Mon, 28 Aug 2017 09:53:55 -0300
Message-Id: <65af989db9cc5479b863657add04940ae6de9d5c.1503924361.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503924361.git.mchehab@s-opensource.com>
References: <cover.1503924361.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1503924361.git.mchehab@s-opensource.com>
References: <cover.1503924361.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a glossary of terms for V4L2, as several concepts are complex
enough to cause misunderstandings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/glossary.rst | 147 ++++++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/v4l2.rst     |   1 +
 2 files changed, 148 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/glossary.rst

diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
new file mode 100644
index 000000000000..0b6ab5adec81
--- /dev/null
+++ b/Documentation/media/uapi/v4l/glossary.rst
@@ -0,0 +1,147 @@
+========
+Glossary
+========
+
+.. note::
+
+   This goal of section is to standardize the terms used within the V4L2
+   documentation. It is written incrementally as they are standardized in
+   the V4L2 documentation. So, it is a Work In Progress.
+
+.. Please keep the glossary entries in alphabetical order
+
+.. glossary::
+
+    Bridge driver
+	The same as V4L2 main driver.
+
+    Device Node
+	A character device node in the file system used to control and do
+	input/output data transfers from/to a Kernel driver.
+
+    Digital Signal Processor - DSP
+	A specialized microprocessor, with its architecture optimized for
+	the operational needs of digital signal processing.
+
+    Driver
+	The part of the Linux Kernel that implements support
+	for a hardware component.
+
+    Field-programmable Gate Array - FPGA
+	A field-programmable gate array (FPGA) is an integrated circuit
+	designed to be configured by a customer or a designer after
+	manufacturing.
+
+	See https://en.wikipedia.org/wiki/Field-programmable_gate_array.
+
+    Hardware component
+	A subset of the media hardware. For example an I²C or SPI device,
+	or an IP block inside an SoC or FPGA.
+
+    Hardware peripheral
+	A group of hardware components that together make a larger
+	user-facing functional peripheral. For instance the SoC ISP IP
+	cores and external camera sensors together make a
+	camera hardware peripheral.
+
+	Also known as peripheral.
+
+    Hardware peripheral control
+	Type of control for a hardware peripheral supported by V4L2 drivers.
+
+	See :ref:`v4l2_hardware_control`.
+
+    Inter-Integrated Circuit - I²C
+	A  multi-master, multi-slave, packet switched, single-ended,
+	serial computer bus used to control V4L2 sub-devices.
+
+	See http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
+
+    Integrated circuit - IC
+	A set of electronic circuits on one small flat piece of
+	semiconductor material, normally silicon.
+
+	Also known as chip.
+
+    IP block
+	The same as IP core.
+
+    Intelectual property core - IP core
+	In electronic design a semiconductor intellectual property core,
+	is a reusable unit of logic, cell, or integrated circuit layout
+	design that is the intellectual property of one party.
+	IP cores may be licensed to another party or can be owned
+	and used by a single party alone.
+
+	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
+
+    Image processor - ISP
+	A specialized digital signal processor used for image processing
+	in digital cameras, mobile phones or other devices.
+
+    Peripheral
+	The same as hardware peripheral.
+
+    Media Controller
+	An API used to identify the hardware components and (optionally)
+	change the links between hardware components.
+
+	See :ref:`media_controller`.
+
+    MC-centric
+	V4L2 hardware that requires a Media controller.
+
+	See :ref:`v4l2_hardware_control`.
+
+    Microprocessor
+	An electronic circuitry that carries out the instructions
+	of a computer program by performing the basic arithmetic, logical,
+	control and input/output (I/O) operations specified by the
+	instructions on a single integrated circuit.
+
+    SMBus
+	A subset of I²C, with defines a stricter usage of the bus.
+
+    Serial Peripheral Interface Bus - SPI
+	Synchronous serial communication interface specification used for
+	short distance communication, primarily in embedded systems.
+
+    System on a Chip - SoC
+	An integrated circuit that integrates all components of a computer
+	or other electronic systems.
+
+    Sub-device hardware components
+	Hardware components that aren't controlled by the
+	V4L2 main driver.
+
+    V4L2 device node
+	A device node that is associated to a V4L2 main driver,
+	as specified in :ref:`v4l2_device_naming`.
+
+    V4L2 hardware
+	A hardware used to on a media device supported by the V4L2
+	subsystem.
+
+    V4L2 hardware control
+	The type of hardware control that a device supports.
+
+	See :ref:`v4l2_hardware_control`.
+
+    V4L2 main driver
+	The V4L2 device driver that implements the main logic to talk with
+	the V4L2 hardware.
+
+	Also known as bridge driver.
+
+	See :ref:`v4l2_hardware_control`.
+
+    V4L2 sub-device
+	Part of the media hardware that it is implemented by a device
+	driver that is not part of the main V4L2 driver.
+
+	See :ref:`subdev`.
+
+    Vdev-centric
+	V4L2 hardware that it is controlled via V4L2 device nodes.
+
+	See :ref:`v4l2_hardware_control`.
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
2.13.5
