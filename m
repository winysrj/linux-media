Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35469 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932100AbdJJIUO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 04:20:14 -0400
Date: Tue, 10 Oct 2017 05:20:00 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v7 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20171010052000.322de12f@vento.lan>
In-Reply-To: <c48ca345-538d-df3f-8888-b207e91e4457@xs4all.nl>
References: <cover.1506550930.git.mchehab@s-opensource.com>
        <047245414a82a6553361b1dd3497f796855a657d.1506550930.git.mchehab@s-opensource.com>
        <c48ca345-538d-df3f-8888-b207e91e4457@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Oct 2017 09:47:13 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/28/2017 12:23 AM, Mauro Carvalho Chehab wrote:
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
> Change this to the more standard phrase:
> 
> See: V4L2 main driver.
> 
> > +
> > +    Device Node
> > +	A character device node in the file system used to control and do  
> 
> and -> and/or
> 
> > +	input/output data transfers from/to a Kernel driver.
> > +
> > +    Digital Signal Processor - DSP
> > +	A specialized microprocessor, with its architecture optimized for
> > +	the operational needs of digital signal processing.  
> 
> I'd say 'requirements' instead of 'needs'. I think that's a better term.
> 
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
> > +
> > +    Inter-Integrated Circuit - I²C
> > +	A  multi-master, multi-slave, packet switched, single-ended,
> > +	serial computer bus used to control V4L2 sub-devices.  
> 
> I'd rephrase this a bit:
> 
> 	A  multi-master, multi-slave, packet switched, single-ended,
> 	serial computer bus. Most V4L2 sub-devices are controlled via
> 	this bus.
> 
> Your text suggested that i2c is used exclusively for V4L2 subdevs, but
> of course it is used for many other devices as well.
> 
> > +
> > +	See http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
> > +
> > +    Integrated circuit - IC
> > +	A set of electronic circuits on one small flat piece of
> > +	semiconductor material, normally silicon.
> > +
> > +	Also known as chip.  
> 
> Perhaps add an entry for 'Chip' as well, with a 'See: Integrated circuit' as
> description? Just to be consistent.
> 
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
> 
> 'See: '
> 
> > +
> > +    MC-centric
> > +	V4L2 hardware that requires a Media controller.
> > +
> > +	See :ref:`v4l2_hardware_control`.
> > +
> > +    Media Controller
> > +	An API designed to expose and control devices and sub-devices
> > +	relationships to applications.  
> 
> This sentence is not clear. I propose this:
> 
> 	An API designed to expose and control the relationships of the Media
> 	Harware to applications.
> 
> > +
> > +	See :ref:`media_controller`.
> > +
> > +    Media hardware
> > +	A group of hardware components that together make a larger
> > +	user-facing functional media hardware. For instance the SoC ISP IP  
> 
> I'd just say "form the functional". The term 'user-facing' is out of place here.
> 
> > +	cores and external camera sensors together make a  
> 
> make a -> form the
> 
> Possible synonym for 'form': 'constitute'. I'm OK with either.
> 
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
> No idea what you mean here. Perhaps this:
> 
> Hardware that is controlled by a V4L2 main driver or a V4L2 sub-device driver.
> V4L2 hardware is a subset of the Media hardware. Often the two are the same,
> but Media hardware can also contain other non-V4L2 hardware such as DVB hardware.
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
> 
> When we talk about 'V4L2 sub-device' we talk about a driver that implement
> the subdev kernel API. I suggest that you change 'V4L2 sub-device' to
> 'V4L2 sub-device driver', then explain that such a driver implements support
> for a Hardware component.
> 
> > +
> > +	See :ref:`subdev`.
> > +
> > +    Vdevnode-centric
> > +	V4L2 hardware that it is controlled via V4L2 device nodes.  
> 
> 'that it' -> 'that'
> 
> This also needs a reference:
> 
> 	See :ref:`v4l2_hardware_control`.
> 
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
> >   
> 
> Regards,
> 
> 	Hans

I agree with all proposed changes. I'm folding the attached patch to it.

Thanks,
Mauro

diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
index b6767da1a46e..e95820d91bac 100644
--- a/Documentation/media/uapi/v4l/glossary.rst
+++ b/Documentation/media/uapi/v4l/glossary.rst
@@ -13,15 +13,18 @@ Glossary
 .. glossary::
 
     Bridge driver
-	The same as V4L2 main driver.
+	See: V4L2 main driver.
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
@@ -47,7 +50,8 @@ Glossary
 
     Inter-Integrated Circuit - I²C
 	A  multi-master, multi-slave, packet switched, single-ended,
-	serial computer bus used to control V4L2 sub-devices.
+	serial computer bus. Most V4L2 sub-device are controlled
+	via this bus.
 
 	See http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
 
@@ -67,7 +71,7 @@ Glossary
 	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
 
     IP block
-	The same as IP core.
+	See: IP core.
 
     MC-centric
 	V4L2 hardware that requires a Media controller.
@@ -75,15 +79,15 @@ Glossary
 	See :ref:`v4l2_hardware_control`.
 
     Media Controller
-	An API designed to expose and control devices and sub-devices
-	relationships to applications.
+	An API designed to expose and control the relationships of the Media
+	Harware to applications.
 
 	See :ref:`media_controller`.
 
     Media hardware
-	A group of hardware components that together make a larger
-	user-facing functional media hardware. For instance the SoC ISP IP
-	cores and external camera sensors together make a
+	A group of hardware components that together form the
+	functional media hardware. For instance the SoC ISP IP
+	cores and external camera sensors together form the
 	camera media hardware.
 
     Media hardware control
@@ -113,8 +117,10 @@ Glossary
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
@@ -125,12 +131,15 @@ Glossary
 	See :ref:`v4l2_hardware_control`.
 
     V4L2 sub-device
-	Part of the media hardware that is implemented via a
-	V4L2 sub-device driver.
+	See: :ref:`V4L2 sub-device driver`
+
+    V4L2 sub-device driver
+	Part of the media hardware that implements support for
+	a hardware component.
 
 	See :ref:`subdev`.
 
     Vdevnode-centric
-	V4L2 hardware that it is controlled via V4L2 device nodes.
+	V4L2 hardware that is controlled via V4L2 device nodes.
 
 	See :ref:`v4l2_hardware_control`.
