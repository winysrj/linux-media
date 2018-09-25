Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60076 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbeIYSOc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 14:14:32 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 1/3] media: add glossary.rst with common terms used at V4L2 spec
Date: Tue, 25 Sep 2018 09:06:51 -0300
Message-Id: <629351f6ca37592b8345f1d9b691523f5a6a3aa9.1537876293.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537876293.git.mchehab+samsung@kernel.org>
References: <cover.1537876293.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1537876293.git.mchehab+samsung@kernel.org>
References: <cover.1537876293.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Add a glossary of terms for V4L2, as several concepts are complex
enough to cause misunderstandings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/uapi/v4l/glossary.rst | 108 ++++++++++++++++++++++
 Documentation/media/uapi/v4l/v4l2.rst     |   1 +
 2 files changed, 109 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/glossary.rst

diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
new file mode 100644
index 000000000000..3dff6430d79f
--- /dev/null
+++ b/Documentation/media/uapi/v4l/glossary.rst
@@ -0,0 +1,108 @@
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
+    Image Signal Processor - ISP
+	A specialised processor that implements a set of algorithms for
+	processing image data. ISPs may implement algorithms for lens
+	shading correction, demosaic, scaling and pixel format conversion
+	as well as produce statistics for the use of the control
+	algorithms (e.g. automatic exposure, white balance and focus).
+
+    Media Controller
+	An API designed to expose and control devices and sub-devices
+	relationships to applications.
+
+	See :ref:`media_controller`.
+
+    MC-centric
+	V4L2 hardware that requires a Media controller.
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
+    V4L2 main driver
+	The V4L2 device driver that implements the main logic to talk with
+	the V4L2 hardware.
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
