Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48728 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750796AbdH2Hrw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 03:47:52 -0400
Date: Tue, 29 Aug 2017 10:47:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: [PATCH v5 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20170829074748.yldwq2gktgefzuaa@valkosipuli.retiisi.org.uk>
References: <cover.1503924361.git.mchehab@s-opensource.com>
 <65af989db9cc5479b863657add04940ae6de9d5c.1503924361.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65af989db9cc5479b863657add04940ae6de9d5c.1503924361.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the update. A few comments below.

On Mon, Aug 28, 2017 at 09:53:55AM -0300, Mauro Carvalho Chehab wrote:
> Add a glossary of terms for V4L2, as several concepts are complex
> enough to cause misunderstandings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/uapi/v4l/glossary.rst | 147 ++++++++++++++++++++++++++++++
>  Documentation/media/uapi/v4l/v4l2.rst     |   1 +
>  2 files changed, 148 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/glossary.rst
> 
> diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
> new file mode 100644
> index 000000000000..0b6ab5adec81
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/glossary.rst
> @@ -0,0 +1,147 @@
> +========
> +Glossary
> +========
> +
> +.. note::
> +
> +   This goal of section is to standardize the terms used within the V4L2
> +   documentation. It is written incrementally as they are standardized in
> +   the V4L2 documentation. So, it is a Work In Progress.

I'd leave the WiP part out.

> +
> +.. Please keep the glossary entries in alphabetical order
> +
> +.. glossary::
> +
> +    Bridge driver
> +	The same as V4L2 main driver.

I've understood bridges being essentially a bus receiver + DMA. Most ISPs
contain both but have more than that. How about:

A driver for a bus (e.g. parallel, CSI-2) receiver and DMA. Bridge drivers
typically act as V4L2 main drivers.

> +
> +    Device Node
> +	A character device node in the file system used to control and do
> +	input/output data transfers from/to a Kernel driver.
> +
> +    Digital Signal Processor - DSP
> +	A specialized microprocessor, with its architecture optimized for
> +	the operational needs of digital signal processing.
> +
> +    Driver
> +	The part of the Linux Kernel that implements support
> +	for a hardware component.
> +
> +    Field-programmable Gate Array - FPGA
> +	A field-programmable gate array (FPGA) is an integrated circuit
> +	designed to be configured by a customer or a designer after
> +	manufacturing.
> +
> +	See https://en.wikipedia.org/wiki/Field-programmable_gate_array.
> +
> +    Hardware component
> +	A subset of the media hardware. For example an I�C or SPI device,
> +	or an IP block inside an SoC or FPGA.
> +
> +    Hardware peripheral
> +	A group of hardware components that together make a larger
> +	user-facing functional peripheral. For instance the SoC ISP IP
> +	cores and external camera sensors together make a
> +	camera hardware peripheral.
> +
> +	Also known as peripheral.

Aren't peripherals usually understood to be devices that you can plug into
a computer? Such as a printer, or a... floppy drive?

I certainly wouldn't call this a peripheral. How about "aggregate device"?
We haven't used that before, but I think it relatively well catches the
meaning without being excessively elaborate.

> +
> +    Hardware peripheral control
> +	Type of control for a hardware peripheral supported by V4L2 drivers.
> +
> +	See :ref:`v4l2_hardware_control`.
> +
> +    Inter-Integrated Circuit - I�C
> +	A  multi-master, multi-slave, packet switched, single-ended,
> +	serial computer bus used to control V4L2 sub-devices.
> +
> +	See http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
> +
> +    Integrated circuit - IC
> +	A set of electronic circuits on one small flat piece of
> +	semiconductor material, normally silicon.
> +
> +	Also known as chip.
> +
> +    IP block
> +	The same as IP core.
> +
> +    Intelectual property core - IP core
> +	In electronic design a semiconductor intellectual property core,
> +	is a reusable unit of logic, cell, or integrated circuit layout
> +	design that is the intellectual property of one party.
> +	IP cores may be licensed to another party or can be owned
> +	and used by a single party alone.
> +
> +	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
> +
> +    Image processor - ISP

"Image signal processor"

> +	A specialized digital signal processor used for image processing
> +	in digital cameras, mobile phones or other devices.

Traditional ISPs aren't programmable in the sense that you could execute
code in them. Instead, they implement a set of image processing algorithms
the parameters of which you can specify. How about:

A specialised processor that implements a set of algorithms for processing
image data. ISPs may implement algorithms for lens shading correction,
demosaic, scaling and pixel format conversion as well as produce statistics
for the use of the control algorithms (e.g. automatic exposure, white
balance and focus).

> +
> +    Peripheral
> +	The same as hardware peripheral.

Peripheral generally is a very seldom used term nowadays, perhaps because
mostly you don't need to explicitly refer to external devices. I'd just
leave it out.

> +
> +    Media Controller
> +	An API used to identify the hardware components and (optionally)
> +	change the links between hardware components.

IMO glossary is not where optional and mandatory parts of APIs should be
discussed. Just the scope. I.e. I'd leave "(optionally)" out. Change ->
configure.

The links are also between media entities, not hardware components. It is
not uncommon that a driver for a hardware component exposes several
sub-devices for the same component.

> +
> +	See :ref:`media_controller`.
> +
> +    MC-centric
> +	V4L2 hardware that requires a Media controller.
> +
> +	See :ref:`v4l2_hardware_control`.
> +
> +    Microprocessor
> +	An electronic circuitry that carries out the instructions
> +	of a computer program by performing the basic arithmetic, logical,
> +	control and input/output (I/O) operations specified by the
> +	instructions on a single integrated circuit.
> +
> +    SMBus
> +	A subset of I�C, with defines a stricter usage of the bus.
> +
> +    Serial Peripheral Interface Bus - SPI

We don't have "Bus" in I�C, I'd leave it out here, too.

> +	Synchronous serial communication interface specification used for
> +	short distance communication, primarily in embedded systems.
> +
> +    System on a Chip - SoC
> +	An integrated circuit that integrates all components of a computer
> +	or other electronic systems.
> +
> +    Sub-device hardware components
> +	Hardware components that aren't controlled by the
> +	V4L2 main driver.
> +
> +    V4L2 device node
> +	A device node that is associated to a V4L2 main driver,
> +	as specified in :ref:`v4l2_device_naming`.

This will be confusing. Many sub-device nodes are exposed by so-called main
drivers.

I'd understand this as any device node type that is exposed by V4L2. In
general there should not be limitation on this, although video device nodes
are effectively only exposed by main drivers.

> +
> +    V4L2 hardware
> +	A hardware used to on a media device supported by the V4L2
> +	subsystem.
> +
> +    V4L2 hardware control
> +	The type of hardware control that a device supports.
> +
> +	See :ref:`v4l2_hardware_control`.
> +
> +    V4L2 main driver
> +	The V4L2 device driver that implements the main logic to talk with
> +	the V4L2 hardware.
> +
> +	Also known as bridge driver.

Is UVC driver a bridge driver? How about instead:

Bridge and ISP drivers typically are V4L2 main drivers.

> +
> +	See :ref:`v4l2_hardware_control`.
> +
> +    V4L2 sub-device
> +	Part of the media hardware that it is implemented by a device
> +	driver that is not part of the main V4L2 driver.

How about:

V4L2 abstraction for a hardware component which is functionally or
physically separate from the DMA engine.

> +
> +	See :ref:`subdev`.
> +
> +    Vdev-centric
> +	V4L2 hardware that it is controlled via V4L2 device nodes.
> +
> +	See :ref:`v4l2_hardware_control`.
> diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
> index f52a11c949d3..1ee4b86d18e1 100644
> --- a/Documentation/media/uapi/v4l/v4l2.rst
> +++ b/Documentation/media/uapi/v4l/v4l2.rst
> @@ -31,6 +31,7 @@ This part describes the Video for Linux API version 2 (V4L2 API) specification.
>      videodev
>      capture-example
>      v4l2grab-example
> +    glossary
>      biblio
>  
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
