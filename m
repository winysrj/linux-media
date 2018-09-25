Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33160 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729098AbeIYVCB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 17:02:01 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v2] media: docs: add glossary.rst with common terms used at V4L2 spec
Date: Tue, 25 Sep 2018 11:53:53 -0300
Message-Id: <564f8903b2eead7a8b75becbe0f30d820a7b8615.1537886957.git.mchehab+samsung@kernel.org>
In-Reply-To: <20180925110643.5ba20bda@coco.lan>
References: <20180925110643.5ba20bda@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Add a glossary of terms for V4L2, as several concepts are complex
enough to cause misunderstandings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---

v2.: Did some changes based on Sakari's feedback.

 Documentation/media/media_uapi.rst        |   2 +
 Documentation/media/uapi/v4l/glossary.rst | 118 ++++++++++++++++++++++
 Documentation/media/uapi/v4l/v4l2.rst     |   1 +
 3 files changed, 121 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/glossary.rst

diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index 28eb35a1f965..aebe48b98ad3 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -2,6 +2,8 @@
 
 .. include:: <isonum.txt>
 
+.. _media_uapi:
+
 ########################################
 Linux Media Infrastructure userspace API
 ########################################
diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
new file mode 100644
index 000000000000..d91833255404
--- /dev/null
+++ b/Documentation/media/uapi/v4l/glossary.rst
@@ -0,0 +1,118 @@
+========
+Glossary
+========
+
+.. note::
+
+   This goal of section is to standardize the terms used within the media
+   userspace API documentation. It is written incrementally as they are
+   standardized in the media documentation. So, it is a Work In Progress.
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
+    Intelectual property core - IP block
+	In electronic design a semiconductor intellectual property core,
+	is a reusable unit of logic, cell, or integrated circuit layout
+	design that is the intellectual property of one party.
+	IP cores may be licensed to another party or can be owned
+	and used by a single party alone.
+
+	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
+
+    Image Signal Processor - ISP
+	A specialised processor that implements a set of algorithms for
+	processing image data. ISPs may implement algorithms for lens
+	shading correction, demosaic, scaling and pixel format conversion
+	as well as produce statistics for the use of the control
+	algorithms (e.g. automatic exposure, white balance and focus).
+
+    Media Controller
+	An API designed to expose and control devices and sub-devices'
+	relationships to applications.
+
+	See :ref:`media_controller`.
+
+    Media Hardware
+        The parts of a hardware that are supported by the Linux
+	media API (see :ref:`media_uapi`).
+
+	Includes audio and video capture and playback hardware,
+	digital and analog TV, camera sensors, ISPs, remote controllers,
+	codecs, HDMI Consumer Electronics Control, HDMI capture, etc.
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
+	V4L2 hardware components that aren't controlled by the
+	V4L2 main driver.
+
+    V4L2 userspace API - V4L2 API
+       The userspace API defined at :ref:`v4l2spec`, with is used
+       to control a V4L2 hardware.
+
+    V4L2 hardware
+       Part of the media hardware with is supported by the V4L2
+       userspace API.
+
+    V4L2 main driver
+	The V4L2 device driver that implements the main logic to talk with
+	a V4L2 hardware.
+
+	Also known as bridge driver.
+
+    V4L2 sub-device
+	Part of the media hardware that it is implemented by a device
+	driver that is not part of the main V4L2 driver.
+
+	See :ref:`subdev`.
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index b89e5621ae69..74b397a8d033 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -32,6 +32,7 @@ This part describes the Video for Linux API version 2 (V4L2 API) specification.
     videodev
     capture-example
     v4l2grab-example
+    glossary
     biblio
 
 
-- 
2.17.1
