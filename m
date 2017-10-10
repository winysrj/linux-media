Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63629 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751574AbdJJLpj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 07:45:39 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v8 1/7] media: add glossary.rst with a glossary of terms used at V4L2 spec
Date: Tue, 10 Oct 2017 08:45:17 -0300
Message-Id: <4df5dd598922e05527bbf7ee9fde4c5ea9be5f7b.1507635716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507635716.git.mchehab@s-opensource.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1507635716.git.mchehab@s-opensource.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a glossary of terms for V4L2, as several concepts are complex
enough to cause misunderstandings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/glossary.rst | 167 ++++++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/v4l2.rst     |   1 +
 2 files changed, 168 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/glossary.rst

diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
new file mode 100644
index 000000000000..a5a832b4dda5
--- /dev/null
+++ b/Documentation/media/uapi/v4l/glossary.rst
@@ -0,0 +1,167 @@
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
+	A driver that provides a bridge between the CPU's bus to the
+	data and control buses of a :term:`media hardware`. Often, the
+	bridge driver is the same as :term:`V4L2 main driver`.
+
+    Chip
+	:See: :term:`Integrated circuit`.
+
+    Device Driver
+    Driver
+	The part of the Linux Kernel that implements support
+	for a :term:`hardware component`.
+
+    Device Node
+	A character device node in the file system used to control and/or
+	do input/output data transfers from/to a Kernel driver.
+
+    Digital Signal Processor
+    DSP
+	A specialized :term:`microprocessor`, with its architecture optimized
+	for the operational requirements of digital signal processing.
+
+    Field-programmable Gate Array
+    FPGA
+	A field-programmable gate array (FPGA) is an :term:`integrated circuit`
+	designed to be configured by a customer or a designer after
+	manufacturing.
+
+	:See: https://en.wikipedia.org/wiki/Field-programmable_gate_array.
+
+    Hardware component
+	A subset of the :term:`media hardware`. For example an :term:`I²C`
+	or :term:`SPI` device, or an :term:`IP block` inside an
+	:term:`SoC` or :term:`FPGA`.
+
+    Image Signal Processor
+    ISP
+	A specialized :term:`microprocessor` that implements a set of
+	algorithms for processing image data. ISPs may implement algorithms
+	for lens shading correction, demosaic, scaling and pixel format
+	conversion as well as produce statistics for the use of the control
+	algorithms (e.g. automatic exposure, white balance and focus).
+
+	ISP drivers often contain a receiver for image data from external
+	sources such as sensors and act as :term:`V4L2 main driver`.
+
+    Integrated circuit
+    IC
+	A set of electronic circuits on one small flat piece of
+	semiconductor material, normally silicon.
+
+	Also known as :term:`chip`.
+
+    Intellectual property core
+    IP core
+	In electronic design a semiconductor intellectual property core,
+	is a reusable unit of logic, cell, or integrated circuit layout
+	design that is the intellectual property of one party.
+	IP cores may be licensed to another party or can be owned
+	and used by a single party alone.
+
+	:See: https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
+
+    Inter-Integrated Circuit
+    I²C
+	A  multi-master, multi-slave, packet switched, single-ended,
+	serial computer bus. A :term:`V4L2 sub-device driver` usually is
+	controlled via this bus.
+
+	:See: http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
+
+    IP block
+	:See: :term:`IP core`.
+
+    Media controller
+    MC
+	An API designed to expose and control the relationships of the
+	:term:`media hardware` to applications.
+
+	:See: :ref:`media_controller`.
+
+    Media controller centric
+    MC-centric
+	:term:`V4L2 hardware` that requires a :term:`media controller`.
+
+	:See: :ref:`v4l2_hardware_control`.
+
+    Media hardware
+	A group of hardware components that together form the
+	functional media hardware. For instance the :term:`SoC`
+	:term:`ISP` :term:`IP cores <ip core>` and external camera
+	sensors together form the camera media hardware.
+
+    Media hardware control
+	Type of control for a :term:`media hardware` supported a
+	V4L2 :term:`driver`.
+
+	:See: :ref:`v4l2_hardware_control`.
+
+    Microprocessor
+	An electronic circuitry that carries out the instructions
+	of a computer program by performing the basic arithmetic, logical,
+	control and input/output (I/O) operations specified by the
+	instructions on a single :term:`integrated circuit`.
+
+    SMBus
+	A subset of :term:`I²C`, with defines a stricter usage of the bus.
+
+    Serial Peripheral Interface
+    SPI
+	Synchronous serial communication interface specification used for
+	short distance communication, primarily in embedded systems.
+
+    System on a Chip
+    SoC
+	An :term:`integrated circuit` that integrates all components of a
+	computer or other electronic systems.
+
+    V4L2 device node
+	A :term:`device node` that is associated to a
+	:term:`V4L2 main driver`, as specified in :ref:`v4l2_device_naming`.
+
+    V4L2 hardware
+	Hardware that is controlled by a :term:`V4L2 main driver` or a
+	:term:`V4L2 sub-device driver`. V4L2 hardware is a subset of the
+	:term:`media hardware`. Often the two are the same, but
+	:term:`media hardware` can also contain other non-V4L2 hardware
+	such as Digital TV hardware.
+
+    V4L2 main driver
+	The V4L2 :term:`device driver` that implements the main logic to
+	talk with the :term:`V4L2 hardware`.
+
+	Often, the same as :term:`bridge driver`.
+
+	:See: :ref:`v4l2_hardware_control`.
+
+    V4L2 sub-device
+	:See: :term:`V4L2 sub-device driver`.
+
+    V4L2 sub-device driver
+	A :term:`driver` for a :term:`media hardware` whose bus(es)
+	connects it to the hardware controlled via the
+	:term:`V4L2 main driver`.
+
+	:See: :ref:`subdev`.
+
+    Video device node centric
+    Vdevnode-centric
+	:term:`V4L2 hardware` that is controlled via
+	:term:`V4L2 device nodes <v4l2 device node>`.
+
+	:See: :ref:`v4l2_hardware_control`.
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index 2128717299b3..698c060939f0 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -32,6 +32,7 @@ This part describes the Video for Linux API version 2 (V4L2 API) specification.
     videodev
     capture-example
     v4l2grab-example
+    glossary
     biblio
 
 
-- 
2.13.6
