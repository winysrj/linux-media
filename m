Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33611
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752065AbdI0WVw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 18:21:52 -0400
Date: Wed, 27 Sep 2017 19:21:36 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v6 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20170927192136.2d0233f7@recife.lan>
In-Reply-To: <c49948fa-7af2-0219-47da-56dead5bbb97@xs4all.nl>
References: <cover.1504012579.git.mchehab@s-opensource.com>
        <d6ff6eda186d452b9e8902afc2e4011dd6263f1f.1504012579.git.mchehab@s-opensource.com>
        <c49948fa-7af2-0219-47da-56dead5bbb97@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 1 Sep 2017 12:26:39 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 29/08/17 15:17, Mauro Carvalho Chehab wrote:
> > Add a glossary of terms for V4L2, as several concepts are complex
> > enough to cause misunderstandings.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  Documentation/media/uapi/v4l/glossary.rst | 150 ++++++++++++++++++++++++++++++
> >  Documentation/media/uapi/v4l/v4l2.rst     |   1 +
> >  2 files changed, 151 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/glossary.rst
> > 
> > diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
> > new file mode 100644
> > index 000000000000..afafe1bc1894
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/glossary.rst
> > @@ -0,0 +1,150 @@
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
> > +    Hardware peripheral  
> 
> As I mentioned before, I really don't like the term 'peripheral'. I am
> fine with "Media hardware". A peripheral to me are keyboards, mice, webcams,
> printers, etc. Not an SoC with a CSI sensor on the board.
> 
> > +	A group of hardware components that together make a larger
> > +	user-facing functional peripheral. For instance the SoC ISP IP
> > +	cores and external camera sensors together make a
> > +	camera hardware peripheral.
> > +
> > +	Also known as peripheral.
> > +
> > +    Hardware peripheral control  
> 
> So this would become "Media hardware control"
> 
> > +	Type of control for a hardware peripheral supported by V4L2 drivers.
> > +
> > +	See :ref:`v4l2_hardware_control`.
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
> > +    IP block
> > +	The same as IP core.
> > +
> > +    Intelectual property core - IP core  
> 
> Typo: Intellectual
> 
> > +	In electronic design a semiconductor intellectual property core,
> > +	is a reusable unit of logic, cell, or integrated circuit layout
> > +	design that is the intellectual property of one party.
> > +	IP cores may be licensed to another party or can be owned
> > +	and used by a single party alone.
> > +
> > +	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
> > +
> > +    Image Signal Processor - ISP
> > +	A specialised processor that implements a set of algorithms for
> > +	processing image data. ISPs may implement algorithms for lens
> > +	shading correction, demosaic, scaling and pixel format conversion
> > +	as well as produce statistics for the use of the control
> > +	algorithms (e.g. automatic exposure, white balance and focus).
> > +
> > +    Peripheral
> > +	The same as hardware peripheral.  
> 
> I'd drop this.
> 
> > +
> > +    Media Controller
> > +	An API designed to expose and control devices and sub-devices
> > +	relationships to applications.
> > +
> > +	See :ref:`media_controller`.
> > +
> > +    MC-centric
> > +	V4L2 hardware that requires a Media controller.
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
> > +    Sub-device hardware components
> > +	Hardware components that aren't controlled by the
> > +	V4L2 main driver.  
> 
> Do we really need this? If we do, then this description needs to be fixed:
> you only say what it isn't controller by, not what actually does control it.
> 
> > +
> > +    V4L2 device node
> > +	A device node that is associated to a V4L2 main driver,
> > +	as specified in :ref:`v4l2_device_naming`.
> > +
> > +    V4L2 hardware
> > +	A hardware used to on a media device supported by the V4L2
> > +	subsystem.
> > +
> > +    V4L2 hardware control
> > +	The type of hardware control that a device supports.
> > +
> > +	See :ref:`v4l2_hardware_control`.  
> 
> ??? This is the same as "Hardware peripheral control". I'd stick to just one
> term (i.e. "Media hardware control" as I proposed).
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
> > +	Part of the media hardware that it is implemented by a device  
> 
> it is -> is
> 
> I don't think this is right. A V4L2 sub-device not hardware. It represents
> a media hardware component and is implemented in a V4L2 sub-device driver.
> 
> > +	driver that is not part of the main V4L2 driver.
> > +
> > +	See :ref:`subdev`.
> > +
> > +    Vdev-centric  
> 
> I strongly prefer to call this vdevnode-centric.
> 'vdev' is too vague and it only works for us because we use 'vdev' in our
> code as the name for a video device node structure. End-users has no knowledge
> of that.
> 
> I agree with the text in patches 2-7, except for the terminology.
> 
> If others agree, then once it is changed in a v7 patch series I'll review again
> for consistent usage of the terminology.

Addressed all above comments. The diff with regards to the previous
series is enclosed. I'll be sending the patches with those changes in
a few.

Regards,
Mauro


diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
index afafe1bc1894..b6767da1a46e 100644
--- a/Documentation/media/uapi/v4l/glossary.rst
+++ b/Documentation/media/uapi/v4l/glossary.rst
@@ -38,18 +38,12 @@ Glossary
 	A subset of the media hardware. For example an I²C or SPI device,
 	or an IP block inside an SoC or FPGA.
 
-    Hardware peripheral
-	A group of hardware components that together make a larger
-	user-facing functional peripheral. For instance the SoC ISP IP
-	cores and external camera sensors together make a
-	camera hardware peripheral.
-
-	Also known as peripheral.
-
-    Hardware peripheral control
-	Type of control for a hardware peripheral supported by V4L2 drivers.
-
-	See :ref:`v4l2_hardware_control`.
+    Image Signal Processor - ISP
+	A specialised processor that implements a set of algorithms for
+	processing image data. ISPs may implement algorithms for lens
+	shading correction, demosaic, scaling and pixel format conversion
+	as well as produce statistics for the use of the control
+	algorithms (e.g. automatic exposure, white balance and focus).
 
     Inter-Integrated Circuit - I²C
 	A  multi-master, multi-slave, packet switched, single-ended,
@@ -63,10 +57,7 @@ Glossary
 
 	Also known as chip.
 
-    IP block
-	The same as IP core.
-
-    Intelectual property core - IP core
+    Intellectual property core - IP core
 	In electronic design a semiconductor intellectual property core,
 	is a reusable unit of logic, cell, or integrated circuit layout
 	design that is the intellectual property of one party.
@@ -75,15 +66,13 @@ Glossary
 
 	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
 
-    Image Signal Processor - ISP
-	A specialised processor that implements a set of algorithms for
-	processing image data. ISPs may implement algorithms for lens
-	shading correction, demosaic, scaling and pixel format conversion
-	as well as produce statistics for the use of the control
-	algorithms (e.g. automatic exposure, white balance and focus).
+    IP block
+	The same as IP core.
 
-    Peripheral
-	The same as hardware peripheral.
+    MC-centric
+	V4L2 hardware that requires a Media controller.
+
+	See :ref:`v4l2_hardware_control`.
 
     Media Controller
 	An API designed to expose and control devices and sub-devices
@@ -91,8 +80,14 @@ Glossary
 
 	See :ref:`media_controller`.
 
-    MC-centric
-	V4L2 hardware that requires a Media controller.
+    Media hardware
+	A group of hardware components that together make a larger
+	user-facing functional media hardware. For instance the SoC ISP IP
+	cores and external camera sensors together make a
+	camera media hardware.
+
+    Media hardware control
+	Type of control for a media hardware supported by V4L2 drivers.
 
 	See :ref:`v4l2_hardware_control`.
 
@@ -113,10 +108,6 @@ Glossary
 	An integrated circuit that integrates all components of a computer
 	or other electronic systems.
 
-    Sub-device hardware components
-	Hardware components that aren't controlled by the
-	V4L2 main driver.
-
     V4L2 device node
 	A device node that is associated to a V4L2 main driver,
 	as specified in :ref:`v4l2_device_naming`.
@@ -125,11 +116,6 @@ Glossary
 	A hardware used to on a media device supported by the V4L2
 	subsystem.
 
-    V4L2 hardware control
-	The type of hardware control that a device supports.
-
-	See :ref:`v4l2_hardware_control`.
-
     V4L2 main driver
 	The V4L2 device driver that implements the main logic to talk with
 	the V4L2 hardware.
@@ -139,12 +125,12 @@ Glossary
 	See :ref:`v4l2_hardware_control`.
 
     V4L2 sub-device
-	Part of the media hardware that it is implemented by a device
-	driver that is not part of the main V4L2 driver.
+	Part of the media hardware that is implemented via a
+	V4L2 sub-device driver.
 
 	See :ref:`subdev`.
 
-    Vdev-centric
+    Vdevnode-centric
 	V4L2 hardware that it is controlled via V4L2 device nodes.
 
 	See :ref:`v4l2_hardware_control`.
diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 250f0b865943..ed011ed123cc 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -10,8 +10,8 @@ Opening and Closing Devices
 .. _v4l2_hardware_control:
 
 
-Types of V4L2 hardware peripheral control
-=========================================
+Types of V4L2 media hardware control
+====================================
 
 V4L2 hardware periferal is usually complex: support for it is
 implemented via a V4L2 main driver and often by several additional drivers.
@@ -26,22 +26,22 @@ controlled directly by the main driver or explicitly via
 the **V4L2 sub-device API** (see :ref:`subdev`).
 
 When V4L2 was originally designed, there was only one type of
-peripheral control: via the **V4L2 device nodes**. We refer to this kind
-of control as **V4L2 device node centric** (or, simply, "**vdev-centric**").
+media hardware control: via the **V4L2 device nodes**. We refer to this kind
+of control as **V4L2 device node centric** (or, simply, "**vdevnode-centric**").
 
 Later (kernel 2.6.39), a new type of periferal control was
-added in order to support complex peripherals that are common for embedded
+added in order to support complex media hardware that are common for embedded
 systems. This type of periferal is controlled mainly via the media
 controller and V4L2 sub-devices. So, it is called
 **Media controller centric** (or, simply, "**MC-centric**") control.
 
-For **vdev-centric** hardware peripheral control, the peripheral is
+For **vdevnode-centric** media hardware control, the media hardware is
 controlled via the **V4L2 device nodes**. They may optionally support the
 :ref:`media controller API <media_controller>` as well,
 in order to inform the application which device nodes are available
 (see :ref:`related`).
 
-For **MC-centric** hardware peripheral control it is required to configure
+For **MC-centric** media hardware control it is required to configure
 the pipelines via the :ref:`media controller API <media_controller>` before
 the periferal can be used. For such devices, the sub-devices' configuration
 can be controlled via the :ref:`sub-device API <subdev>`, which creates one
@@ -49,14 +49,14 @@ device node per sub-device.
 
 .. note::
 
-   A **vdev-centric** may also optionally expose V4L2 sub-devices via
+   A **vdevnode-centric** may also optionally expose V4L2 sub-devices via
    :ref:`sub-device API <subdev>`. In that case, it has to implement
    the :ref:`media controller API <media_controller>` as well.
 
 
 .. attention::
 
-   Devices that require **MC-centric** hardware peripheral control should
+   Devices that require **MC-centric** media hardware control should
    report a ``V4L2_MC_CENTRIC`` :c:type:`v4l2_capability` flag
    (see :ref:`VIDIOC_QUERYCAP`).
 
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index cf69a5e33df2..944bc5ba484f 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -257,7 +257,7 @@ specification the ioctl returns an ``EINVAL`` error code.
     * - ``V4L2_MC_CENTRIC``
       - 0x20000000
       - Indicates that the device require **MC-centric** hardware
-        control, and thus can't be used by **vdev-centric** applications.
+        control, and thus can't be used by **vdevnode-centric** applications.
         See :ref:`v4l2_hardware_control` for more details.
     * - ``V4L2_CAP_DEVICE_CAPS``
       - 0x80000000



Thanks,
Mauro
