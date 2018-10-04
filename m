Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46758 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJDV5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 17:57:07 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v5] media: docs: add glossary.rst with common terms used at V4L2 spec
Date: Thu,  4 Oct 2018 12:03:20 -0300
Message-Id: <44e7493e10f34cacbe7ca27012cd68b1f9446284.1538665378.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Add a glossary of terms used within the media userspace API
documentation, as several concepts are complex enough to cause
misunderstandings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/media_uapi.rst    |   3 +
 Documentation/media/uapi/glossary.rst | 185 ++++++++++++++++++++++++++
 2 files changed, 188 insertions(+)
 create mode 100644 Documentation/media/uapi/glossary.rst

diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index 28eb35a1f965..41f091a26003 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -2,6 +2,8 @@
 
 .. include:: <isonum.txt>
 
+.. _media_uapi:
+
 ########################################
 Linux Media Infrastructure userspace API
 ########################################
@@ -31,3 +33,4 @@ License".
     uapi/cec/cec-api
     uapi/gen-errors
     uapi/fdl-appendix
+    uapi/glossary
diff --git a/Documentation/media/uapi/glossary.rst b/Documentation/media/uapi/glossary.rst
new file mode 100644
index 000000000000..1dce36707509
--- /dev/null
+++ b/Documentation/media/uapi/glossary.rst
@@ -0,0 +1,185 @@
+.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later
+
+.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
+..
+.. For GFDL-1.1-or-later, see:
+..
+.. Permission is granted to copy, distribute and/or modify this document
+.. under the terms of the GNU Free Documentation License, Version 1.1 or
+.. any later version published by the Free Software Foundation, with no
+.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
+.. A copy of the license is included at
+.. Documentation/media/uapi/fdl-appendix.rst.
+
+========
+Glossary
+========
+
+.. note::
+
+   This goal of this section is to standardize the terms used within the media
+   userspace API documentation. It is written incrementally as they are
+   standardized in the media documentation.
+
+   So, it is a Work In Progress.
+
+.. Please keep the glossary entries in alphabetical order
+
+.. glossary::
+
+    Bridge Driver
+	A :term:`device driver` that implements the main logic to talk with
+	media hardware.
+
+    CEC API
+	**Consumer Electronics Control API**
+
+	An API designed to receive and transmit data via an HDMI
+	CEC interface.
+
+	See :ref:`cec`.
+
+    Device Driver
+	Part of the Linux Kernel that implements support for a hardware
+	component.
+
+    Device Node
+	A character device node in the file system used to control and
+	ransfer data in and out of a Kernel driver.
+
+    Digital TV API
+	**Previously known as DVB API**
+
+	An API designed to control a subset of the :term:`Media Hardware`
+	that implements	digital TV.
+
+	See :ref:`dvbapi`.
+
+    DSP
+        **Digital Signal Processor**
+
+	A specialized :term:`Microprocessor`, with its architecture
+	optimized for the operational needs of digital signal processing.
+
+    FPGA
+	**Field-programmable Gate Array**
+
+	An :term:`IC` circuit designed to be configured by a customer or
+	a designer after manufacturing.
+
+	See https://en.wikipedia.org/wiki/Field-programmable_gate_array.
+
+    I²C
+	**Inter-Integrated Circuit**
+
+	A  multi-master, multi-slave, packet switched, single-ended,
+	serial computer bus used to control some hardware components
+	like sub-device hardware components.
+
+	See http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
+
+    IC
+	**Integrated circuit**
+
+	A set of electronic circuits on one small flat piece of
+	semiconductor material, normally silicon.
+
+	Also known as chip.
+
+    IP Block
+	**Intellectual property core**
+
+	In electronic design a semiconductor intellectual property core,
+	is a reusable unit of logic, cell, or integrated circuit layout
+	design that is the intellectual property of one party.
+	IP Blocks may be licensed to another party or can be owned
+	and used by a single party alone.
+
+	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
+
+    ISP
+	**Image Signal Processor**
+
+	A specialized processor that implements a set of algorithms for
+	processing image data. ISPs may implement algorithms for lens
+	shading correction, demosaicing, scaling and pixel format conversion
+	as well as produce statistics for the use of the control
+	algorithms (e.g. automatic exposure, white balance and focus).
+
+    Media API
+	A set of userspace APIs used to control the media hardware. It is
+	composed by:
+
+	  - :term:`CEC API`;
+	  - :term:`Digital TV API`;
+	  - :term:`MC API`;
+	  - :term:`RC API`; and
+	  - :term:`V4L2 API`.
+
+	See :ref:`media_uapi`.
+
+    MC API
+	**Media Controller API**
+
+	An API designed to expose and control the relationships between
+	devices and sub-devices.
+
+	See :ref:`media_controller`.
+
+    Media Hardware
+	Subset of the hardware that is supported by the Linux Media API.
+
+	This includes audio and video capture and playback hardware,
+	digital and analog TV, camera sensors, ISPs, remote controllers,
+	codecs, HDMI Consumer Electronics Control, HDMI capture, etc.
+
+
+	See :ref:`media_uapi`.
+
+    Microprocessor
+	Electronic circuitry that carries out the instructions of a
+	computer program by performing the basic arithmetic, logical,
+	control and input/output (I/O) operations specified by the
+	instructions on a single integrated circuit.
+
+    RC API
+	**Remote Controller API**
+
+	An API designed to receive and transmit data from remote
+	controllers.
+
+	See :ref:`remote_controllers`.
+
+    SMBus
+	A subset of I²C, which defines a stricter usage of the bus.
+
+    SPI
+	**Serial Peripheral Interface Bus**
+
+	Synchronous serial communication interface specification used for
+	short distance communication, primarily in embedded systems.
+
+    SoC
+	**System on a Chip**
+
+	An integrated circuit that integrates all components of a computer
+	or other electronic systems.
+
+    V4L2 API
+	**V4L2 userspace API**
+
+	The userspace API defined in :ref:`v4l2spec`, which is used to
+	control a V4L2 hardware.
+
+    V4L2 Hardware
+	Part of a media hardware with is supported by the :term:`V4L2 API`.
+
+    V4L2 Sub-device
+	V4L2 hardware components that aren't controlled by a
+	:term:`bridge driver`.
+
+    V4L2 Sub-device API
+	Part of the :term:`V4L2 API` which control
+	:term:`V4L2 sub-devices <V4L2 Sub-device>`.
+
+	See :ref:`subdev`.
-- 
2.17.1
