Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33131 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755134AbdJJIvr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 04:51:47 -0400
Date: Tue, 10 Oct 2017 05:51:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: [PATCH v7 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20171010055134.7747e1e1@vento.lan>
In-Reply-To: <20171006102229.evjyn77udfcc76gs@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
        <047245414a82a6553361b1dd3497f796855a657d.1506550930.git.mchehab@s-opensource.com>
        <20171006102229.evjyn77udfcc76gs@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 6 Oct 2017 13:22:29 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> Thanks for continuing the work on this!
> 
> On Wed, Sep 27, 2017 at 07:23:43PM -0300, Mauro Carvalho Chehab wrote:
> > Add a glossary of terms for V4L2, as several concepts are complex
> > enough to cause misunderstandings.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  Documentation/media/uapi/v4l/glossary.rst | 136 ++++++++++++++++++++++++++++++
> >  Documentation/media/uapi/v4l/v4l2.rst     |   1 +
> >  2 files changed, 137 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/glossary.rst
> > 
> > diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
> > new file mode 100644
> > index 000000000000..b6767da1a46e
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/glossary.rst
> > @@ -0,0 +1,136 @@
> > +========
> > +Glossary
> > +========
> > +
> > +.. note::
> > +
> > +   This goal of section is to standardize the terms used within the V4L2
> > +   documentation. It is written incrementally as they are standardized in
> > +   the V4L2 documentation. So, it is a Work In Progress.
> > +
> > +.. Please keep the glossary entries in alphabetical order
> > +
> > +.. glossary::
> > +
> > +    Bridge driver
> > +	The same as V4L2 main driver.  
> 
> Not all V4L2 main drivers can be bridge drivers. Mem-to-mem devices, for
> instance. How about:
> 
> A driver for a device receiving image data from another device (or
> transmitting it to a sub-device) controlled by a sub-device driver. Bridge
> drivers typically act as V4L2 main drivers.
> 
> > +
> > +    Device Node
> > +	A character device node in the file system used to control and do
> > +	input/output data transfers from/to a Kernel driver.
> > +
> > +    Digital Signal Processor - DSP
> > +	A specialized microprocessor, with its architecture optimized for
> > +	the operational needs of digital signal processing.
> > +
> > +    Driver
> > +	The part of the Linux Kernel that implements support
> > +	for a hardware component.
> > +
> > +    Field-programmable Gate Array - FPGA
> > +	A field-programmable gate array (FPGA) is an integrated circuit
> > +	designed to be configured by a customer or a designer after
> > +	manufacturing.
> > +
> > +	See https://en.wikipedia.org/wiki/Field-programmable_gate_array.
> > +
> > +    Hardware component
> > +	A subset of the media hardware. For example an I²C or SPI device,
> > +	or an IP block inside an SoC or FPGA.
> > +
> > +    Image Signal Processor - ISP
> > +	A specialised processor that implements a set of algorithms for
> > +	processing image data. ISPs may implement algorithms for lens
> > +	shading correction, demosaic, scaling and pixel format conversion
> > +	as well as produce statistics for the use of the control
> > +	algorithms (e.g. automatic exposure, white balance and focus).  
> 
> And perhaps add:
> 
> ISP drivers often contain a receiver for image data from external source
> such as a sensor and act as V4L2 main driver.

OK.

> 
> > +
> > +    Inter-Integrated Circuit - I²C
> > +	A  multi-master, multi-slave, packet switched, single-ended,
> > +	serial computer bus used to control V4L2 sub-devices.
> > +
> > +	See http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
> > +
> > +    Integrated circuit - IC
> > +	A set of electronic circuits on one small flat piece of
> > +	semiconductor material, normally silicon.
> > +
> > +	Also known as chip.
> > +
> > +    Intellectual property core - IP core
> > +	In electronic design a semiconductor intellectual property core,
> > +	is a reusable unit of logic, cell, or integrated circuit layout
> > +	design that is the intellectual property of one party.
> > +	IP cores may be licensed to another party or can be owned
> > +	and used by a single party alone.
> > +
> > +	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
> > +
> > +    IP block
> > +	The same as IP core.
> > +
> > +    MC-centric
> > +	V4L2 hardware that requires a Media controller.
> > +
> > +	See :ref:`v4l2_hardware_control`.
> > +
> > +    Media Controller
> > +	An API designed to expose and control devices and sub-devices
> > +	relationships to applications.
> > +
> > +	See :ref:`media_controller`.
> > +
> > +    Media hardware
> > +	A group of hardware components that together make a larger
> > +	user-facing functional media hardware. For instance the SoC ISP IP
> > +	cores and external camera sensors together make a
> > +	camera media hardware.
> > +
> > +    Media hardware control
> > +	Type of control for a media hardware supported by V4L2 drivers.
> > +
> > +	See :ref:`v4l2_hardware_control`.
> > +
> > +    Microprocessor
> > +	An electronic circuitry that carries out the instructions
> > +	of a computer program by performing the basic arithmetic, logical,
> > +	control and input/output (I/O) operations specified by the
> > +	instructions on a single integrated circuit.
> > +
> > +    SMBus
> > +	A subset of I²C, with defines a stricter usage of the bus.
> > +
> > +    Serial Peripheral Interface Bus - SPI
> > +	Synchronous serial communication interface specification used for
> > +	short distance communication, primarily in embedded systems.
> > +
> > +    System on a Chip - SoC
> > +	An integrated circuit that integrates all components of a computer
> > +	or other electronic systems.
> > +
> > +    V4L2 device node
> > +	A device node that is associated to a V4L2 main driver,
> > +	as specified in :ref:`v4l2_device_naming`.
> > +
> > +    V4L2 hardware
> > +	A hardware used to on a media device supported by the V4L2
> > +	subsystem.  
> 
> I'm not sure what this means. Nor I think the proposed term is good for the
> reasons elaborated earlier. "Media hardware" above has similar issues.
> 
> What we would need a name for is a device that consists of other devices
> that are not usable individually, but instead as an ensemble.
> 
> I think "aggregate device", for instance, would be good as it catches the
> essence of the nature of the system. We'd have "Media aggregate device" and
> "V4L2 aggregate device".
> 
> An alternative would be simply to leave this out for now, but then we'll
> have issues elsewhere. I'm certainly open for better options if someone can
> come up with a better name.

I liked Hans proposal for it:

    V4L2 hardware
        Hardware that is controlled by a V4L2 main driver or a V4L2
        sub-device driver. V4L2 hardware is a subset of the
        Media hardware. Often the two are the same, but Media hardware
        can also contain other non-V4L2 hardware such as DVB hardware.

Perhaps we could change it a little bit to contain the word "ensemble",
e. g.:

    V4L2 hardware
	Ensembles the hardware that is controlled by a V4L2 main driver
	and by the associated V4L2 sub-device drivers. V4L2 hardware is
	a subset of the Media hardware. Often the two are the same,
	but Media hardware can also contain other non-V4L2 hardware
	such as DVB hardware.

> 
> > +
> > +    V4L2 main driver
> > +	The V4L2 device driver that implements the main logic to talk with
> > +	the V4L2 hardware.
> > +
> > +	Also known as bridge driver.
> > +
> > +	See :ref:`v4l2_hardware_control`.
> > +
> > +    V4L2 sub-device
> > +	Part of the media hardware that is implemented via a
> > +	V4L2 sub-device driver.
> > +
> > +	See :ref:`subdev`.
> > +
> > +    Vdevnode-centric  
> 
> I think this looks quite awkward. How about "Video device node centric" or
> "Video node centric"? I don't think it'd be too long.

I'll add the full name here and for MC-centric.

> 
> > +	V4L2 hardware that it is controlled via V4L2 device nodes.
> > +
> > +	See :ref:`v4l2_hardware_control`.
> > diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
> > index 2128717299b3..698c060939f0 100644
> > --- a/Documentation/media/uapi/v4l/v4l2.rst
> > +++ b/Documentation/media/uapi/v4l/v4l2.rst
> > @@ -32,6 +32,7 @@ This part describes the Video for Linux API version 2 (V4L2 API) specification.
> >      videodev
> >      capture-example
> >      v4l2grab-example
> > +    glossary
> >      biblio
> >  
> >    
> 

I'm enclosing the diff, against v7, that should hopefully cover all
the points that both you and Hans mentioned.

Thanks,
Mauro


diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
index b6767da1a46e..08980e9cb98e 100644
--- a/Documentation/media/uapi/v4l/glossary.rst
+++ b/Documentation/media/uapi/v4l/glossary.rst
@@ -13,15 +13,20 @@ Glossary
 .. glossary::
 
     Bridge driver
-	The same as V4L2 main driver.
+	A driver that provides a bridge between the CPU's bus to the
+	data and control buses of a media hardware. Often, the
+	bridge driver is the same as V4L2 main driver.
+
+    Chip:
+	See: Integrated circuit.
 
     Device Node
-	A character device node in the file system used to control and do
-	input/output data transfers from/to a Kernel driver.
+	A character device node in the file system used to control and/or
+	do input/output data transfers from/to a Kernel driver.
 
     Digital Signal Processor - DSP
 	A specialized microprocessor, with its architecture optimized for
-	the operational needs of digital signal processing.
+	the operational requirements of digital signal processing.
 
     Driver
 	The part of the Linux Kernel that implements support
@@ -45,9 +50,13 @@ Glossary
 	as well as produce statistics for the use of the control
 	algorithms (e.g. automatic exposure, white balance and focus).
 
+	ISP drivers often contain a receiver for image data from external
+	sources such as sensors and act as V4L2 main driver.
+
     Inter-Integrated Circuit - I²C
 	A  multi-master, multi-slave, packet switched, single-ended,
-	serial computer bus used to control V4L2 sub-devices.
+	serial computer bus. Most V4L2 sub-devices are controlled
+	via this bus.
 
 	See http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
 
@@ -67,23 +76,23 @@ Glossary
 	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
 
     IP block
-	The same as IP core.
-
-    MC-centric
-	V4L2 hardware that requires a Media controller.
-
-	See :ref:`v4l2_hardware_control`.
+	See: IP core.
 
     Media Controller
-	An API designed to expose and control devices and sub-devices
-	relationships to applications.
+	An API designed to expose and control the relationships of the Media
+	Harware to applications.
 
 	See :ref:`media_controller`.
 
+    Media Controller centric - MC-centric
+	V4L2 hardware that requires a Media controller.
+
+	See :ref:`v4l2_hardware_control`.
+
     Media hardware
-	A group of hardware components that together make a larger
-	user-facing functional media hardware. For instance the SoC ISP IP
-	cores and external camera sensors together make a
+	A group of hardware components that together form the
+	functional media hardware. For instance the SoC ISP IP
+	cores and external camera sensors together form the
 	camera media hardware.
 
     Media hardware control
@@ -113,8 +122,10 @@ Glossary
 	as specified in :ref:`v4l2_device_naming`.
 
     V4L2 hardware
-	A hardware used to on a media device supported by the V4L2
-	subsystem.
+	Hardware that is controlled by a V4L2 main driver or a V4L2
+	sub-device driver. V4L2 hardware is a subset of the
+	Media hardware. Often the two are the same, but Media hardware
+	can also contain other non-V4L2 hardware such as DVB hardware.
 
     V4L2 main driver
 	The V4L2 device driver that implements the main logic to talk with
@@ -125,12 +136,15 @@ Glossary
 	See :ref:`v4l2_hardware_control`.
 
     V4L2 sub-device
-	Part of the media hardware that is implemented via a
-	V4L2 sub-device driver.
+	See: :ref:`V4L2 sub-device driver`
+
+    V4L2 sub-device driver
+	A driver for a media component whose bus(es) connects it
+	to the hardware controlled via the V4L2 main driver.
 
 	See :ref:`subdev`.
 
-    Vdevnode-centric
-	V4L2 hardware that it is controlled via V4L2 device nodes.
+    Video device node centric - Vdevnode-centric
+	V4L2 hardware that is controlled via V4L2 device nodes.
 
 	See :ref:`v4l2_hardware_control`.
