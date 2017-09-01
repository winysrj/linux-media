Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:46914 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751670AbdIAK0p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 06:26:45 -0400
Subject: Re: [PATCH v6 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1504012579.git.mchehab@s-opensource.com>
 <d6ff6eda186d452b9e8902afc2e4011dd6263f1f.1504012579.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c49948fa-7af2-0219-47da-56dead5bbb97@xs4all.nl>
Date: Fri, 1 Sep 2017 12:26:39 +0200
MIME-Version: 1.0
In-Reply-To: <d6ff6eda186d452b9e8902afc2e4011dd6263f1f.1504012579.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/08/17 15:17, Mauro Carvalho Chehab wrote:
> Add a glossary of terms for V4L2, as several concepts are complex
> enough to cause misunderstandings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/uapi/v4l/glossary.rst | 150 ++++++++++++++++++++++++++++++
>  Documentation/media/uapi/v4l/v4l2.rst     |   1 +
>  2 files changed, 151 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/glossary.rst
> 
> diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
> new file mode 100644
> index 000000000000..afafe1bc1894
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/glossary.rst
> @@ -0,0 +1,150 @@
> +========
> +Glossary
> +========
> +
> +.. note::
> +
> +   This goal of section is to standardize the terms used within the V4L2
> +   documentation. It is written incrementally as they are standardized in
> +   the V4L2 documentation. So, it is a Work In Progress.
> +
> +.. Please keep the glossary entries in alphabetical order
> +
> +.. glossary::
> +
> +    Bridge driver
> +	The same as V4L2 main driver.
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
> +	A subset of the media hardware. For example an I²C or SPI device,
> +	or an IP block inside an SoC or FPGA.
> +
> +    Hardware peripheral

As I mentioned before, I really don't like the term 'peripheral'. I am
fine with "Media hardware". A peripheral to me are keyboards, mice, webcams,
printers, etc. Not an SoC with a CSI sensor on the board.

> +	A group of hardware components that together make a larger
> +	user-facing functional peripheral. For instance the SoC ISP IP
> +	cores and external camera sensors together make a
> +	camera hardware peripheral.
> +
> +	Also known as peripheral.
> +
> +    Hardware peripheral control

So this would become "Media hardware control"

> +	Type of control for a hardware peripheral supported by V4L2 drivers.
> +
> +	See :ref:`v4l2_hardware_control`.
> +
> +    Inter-Integrated Circuit - I²C
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

Typo: Intellectual

> +	In electronic design a semiconductor intellectual property core,
> +	is a reusable unit of logic, cell, or integrated circuit layout
> +	design that is the intellectual property of one party.
> +	IP cores may be licensed to another party or can be owned
> +	and used by a single party alone.
> +
> +	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
> +
> +    Image Signal Processor - ISP
> +	A specialised processor that implements a set of algorithms for
> +	processing image data. ISPs may implement algorithms for lens
> +	shading correction, demosaic, scaling and pixel format conversion
> +	as well as produce statistics for the use of the control
> +	algorithms (e.g. automatic exposure, white balance and focus).
> +
> +    Peripheral
> +	The same as hardware peripheral.

I'd drop this.

> +
> +    Media Controller
> +	An API designed to expose and control devices and sub-devices
> +	relationships to applications.
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
> +	A subset of I²C, with defines a stricter usage of the bus.
> +
> +    Serial Peripheral Interface Bus - SPI
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

Do we really need this? If we do, then this description needs to be fixed:
you only say what it isn't controller by, not what actually does control it.

> +
> +    V4L2 device node
> +	A device node that is associated to a V4L2 main driver,
> +	as specified in :ref:`v4l2_device_naming`.
> +
> +    V4L2 hardware
> +	A hardware used to on a media device supported by the V4L2
> +	subsystem.
> +
> +    V4L2 hardware control
> +	The type of hardware control that a device supports.
> +
> +	See :ref:`v4l2_hardware_control`.

??? This is the same as "Hardware peripheral control". I'd stick to just one
term (i.e. "Media hardware control" as I proposed).

> +
> +    V4L2 main driver
> +	The V4L2 device driver that implements the main logic to talk with
> +	the V4L2 hardware.
> +
> +	Also known as bridge driver.
> +
> +	See :ref:`v4l2_hardware_control`.
> +
> +    V4L2 sub-device
> +	Part of the media hardware that it is implemented by a device

it is -> is

I don't think this is right. A V4L2 sub-device not hardware. It represents
a media hardware component and is implemented in a V4L2 sub-device driver.

> +	driver that is not part of the main V4L2 driver.
> +
> +	See :ref:`subdev`.
> +
> +    Vdev-centric

I strongly prefer to call this vdevnode-centric.
'vdev' is too vague and it only works for us because we use 'vdev' in our
code as the name for a video device node structure. End-users has no knowledge
of that.

I agree with the text in patches 2-7, except for the terminology.

If others agree, then once it is changed in a v7 patch series I'll review again
for consistent usage of the terminology.

Regards,

	Hans

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
> 
