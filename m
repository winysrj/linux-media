Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:55150 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727183AbeJDSEJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 14:04:09 -0400
Subject: Re: [PATCH v4] media: docs: add glossary.rst with common terms used
 at V4L2 spec
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <2df98a95-a7bb-3c01-f07f-27f3bfc849ea@xs4all.nl>
 <b187d9aa4b64fca3aae89830418d9e8f94953c16.1538650650.git.mchehab+samsung@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ddebe88a-57c5-c217-0e2e-66074994effe@xs4all.nl>
Date: Thu, 4 Oct 2018 13:11:12 +0200
MIME-Version: 1.0
In-Reply-To: <b187d9aa4b64fca3aae89830418d9e8f94953c16.1538650650.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/18 12:58, Mauro Carvalho Chehab wrote:
> From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> Add a glossary of terms used within the media userspace API
> documentation, as several concepts are complex enough to cause
> misunderstandings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  Documentation/media/media_uapi.rst    |   3 +
>  Documentation/media/uapi/glossary.rst | 162 ++++++++++++++++++++++++++
>  2 files changed, 165 insertions(+)
>  create mode 100644 Documentation/media/uapi/glossary.rst
> 
> diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
> index 28eb35a1f965..41f091a26003 100644
> --- a/Documentation/media/media_uapi.rst
> +++ b/Documentation/media/media_uapi.rst
> @@ -2,6 +2,8 @@
>  
>  .. include:: <isonum.txt>
>  
> +.. _media_uapi:
> +
>  ########################################
>  Linux Media Infrastructure userspace API
>  ########################################
> @@ -31,3 +33,4 @@ License".
>      uapi/cec/cec-api
>      uapi/gen-errors
>      uapi/fdl-appendix
> +    uapi/glossary
> diff --git a/Documentation/media/uapi/glossary.rst b/Documentation/media/uapi/glossary.rst
> new file mode 100644
> index 000000000000..4307decd345f
> --- /dev/null
> +++ b/Documentation/media/uapi/glossary.rst
> @@ -0,0 +1,162 @@
> +.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later
> +
> +.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
> +..
> +.. For GFDL-1.1-or-later, see:
> +..
> +.. Permission is granted to copy, distribute and/or modify this document
> +.. under the terms of the GNU Free Documentation License, Version 1.1 or
> +.. any later version published by the Free Software Foundation, with no
> +.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
> +.. A copy of the license is included at
> +.. Documentation/media/uapi/fdl-appendix.rst.
> +
> +========
> +Glossary
> +========
> +
> +.. note::
> +
> +   This goal of section is to standardize the terms used within the media

The goal of this section

(Huh, was wrong in v3 as well, I completely read over this at the time!)

> +   userspace API documentation. It is written incrementally as they are
> +   standardized in the media documentation.
> +
> +   So, it is a Work In Progress.
> +
> +.. Please keep the glossary entries in alphabetical order
> +
> +.. glossary::
> +
> +    Bridge driver
> +	A device driver that implements the main logic to talk with
> +	media hardware.
> +
> +	For V4L2 hardware, this is also known as the V4L2 main driver.
> +
> +    Consumer Electronics Control API
> +	An API designed to receive and transmit data via a HDMI

a HDMI -> an HDMI

(when you pronounce it 'HDMI' starts with a vowel, hence the 'an')

> +	CEC interface.
> +
> +	See :ref:`cec`.
> +
> +    Device Node
> +	A character device node in the file system used to control and do
> +	input/output data transfers from/to a Kernel driver.
> +
> +    Digital TV API - DVB API
> +	An API designed to control the media device components related to
> +	digital TV, including frontends, demuxes, streaming, conditional
> +	access, etc.
> +
> +	See :ref:`dvbapi`.
> +
> +    Digital Signal Processor - DSP
> +	A specialized microprocessor, with its architecture optimized for
> +	the operational needs of digital signal processing.
> +
> +    Driver
> +	Part of the Linux Kernel that implements support for a hardware
> +	component.
> +
> +    Field-programmable Gate Array - FPGA
> +	A field-programmable gate array (FPGA) is an integrated circuit
> +	designed to be configured by a customer or a designer after
> +	manufacturing.
> +
> +	See https://en.wikipedia.org/wiki/Field-programmable_gate_array.
> +
> +    Inter-Integrated Circuit - I²C
> +	A  multi-master, multi-slave, packet switched, single-ended,
> +	serial computer bus used to control some hardware components
> +	like sub-device hardware components.
> +
> +	See http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
> +
> +    Integrated circuit - IC
> +	A set of electronic circuits on one small flat piece of
> +	semiconductor material, normally silicon.
> +
> +	Also known as chip.
> +
> +    Intellectual property core - IP block
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
> +	shading correction, demosaicing, scaling and pixel format conversion
> +	as well as produce statistics for the use of the control
> +	algorithms (e.g. automatic exposure, white balance and focus).
> +
> +    Media API
> +	A set of userspace APIs used to control a media hardware.
> +
> +	See :ref:`media_uapi`.
> +
> +    Media Controller
> +	An API designed to expose and control the relationships between
> +	devices and sub-devices.
> +
> +	See :ref:`media_controller`.
> +
> +    Media Hardware
> +	Subset of the hardware that is supported by the Linux Media API.
> +
> +	This includes audio and video capture and playback hardware,
> +	digital and analog TV, camera sensors, ISPs, remote controllers,
> +	codecs, HDMI Consumer Electronics Control, HDMI capture, etc.
> +

You can delete one empty line here.

> +
> +	See :ref:`media_uapi`.
> +
> +
> +    Microprocessor
> +	Electronic circuitry that carries out the instructions of a
> +	computer program by performing the basic arithmetic, logical,
> +	control and input/output (I/O) operations specified by the
> +	instructions on a single integrated circuit.
> +
> +    Remote Controller API
> +	An API designed to receive and transmit data from remote
> +	controllers.
> +
> +	See :ref:`remote_controllers`.
> +
> +    SMBus
> +	A subset of I²C, whith defines a stricter usage of the bus.

whith -> which

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
> +	V4L2 hardware components that aren't controlled by a
> +	V4L2 main driver.
> +
> +    V4L2 userspace API - V4L2 API
> +	The userspace API defined at :ref:`v4l2spec`, whith is used to

whith -> which

> +	control a V4L2 hardware.
> +
> +    V4L2 hardware
> +	Part of a media hardware with is supported by the V4L2
> +	userspace API.
> +
> +    V4L2 main driver
> +	A V4L2 device driver that implements the main logic to talk with
> +	V4L2 hardware.
> +
> +    V4L2 sub-device
> +	Part of the media hardware that is implemented by a device
> +	driver that is not part of the main V4L2 driver.
> +
> +	See :ref:`subdev`.
> 

Regards,

	Hans
