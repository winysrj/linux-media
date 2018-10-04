Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40526 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbeJDSeJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 14:34:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v3] media: docs: add glossary.rst with common terms used at V4L2 spec
Date: Thu, 04 Oct 2018 14:41:30 +0300
Message-ID: <2646453.94SmjfbUfy@avalon>
In-Reply-To: <02e399c34a614182ecfa4212cc610fe7d57024f4.1537902727.git.mchehab+samsung@kernel.org>
References: <02e399c34a614182ecfa4212cc610fe7d57024f4.1537902727.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

(CC'ing Kieran)

Thank you for the patch.

On Tuesday, 25 September 2018 22:14:51 EEST Mauro Carvalho Chehab wrote:
> From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>=20
> Add a glossary of terms used within the media userspace API
> documentation, as several concepts are complex enough to cause
> misunderstandings.
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>=20
> v3:
>   - Add SPDX header and dual-license the glossary
>   - Make glossary generic enough to be used for all media uAPI
> documentation; - Add a few new items to the glossary, to imply that it
> covers not only V4L2; - Move it to the uAPI document as a hole.
>=20
> v2: Did some changes based on Sakari's feedback.
>=20
>  Documentation/media/media_uapi.rst    |   3 +
>  Documentation/media/uapi/glossary.rst | 162 ++++++++++++++++++++++++++
>  2 files changed, 165 insertions(+)
>  create mode 100644 Documentation/media/uapi/glossary.rst
>=20
> diff --git a/Documentation/media/media_uapi.rst
> b/Documentation/media/media_uapi.rst index 28eb35a1f965..41f091a26003
> 100644
> --- a/Documentation/media/media_uapi.rst
> +++ b/Documentation/media/media_uapi.rst
> @@ -2,6 +2,8 @@
>=20
>  .. include:: <isonum.txt>
>=20
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

Is there an easy way to cross-reference to the glossary when terms are used=
 ?

> diff --git a/Documentation/media/uapi/glossary.rst
> b/Documentation/media/uapi/glossary.rst new file mode 100644
> index 000000000000..9e2a2b29e8b2
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
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +Glossary
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +.. note::
> +
> +   This goal of section is to standardize the terms used within the media
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

Shouldn't all words start with a capital letter ?

> +	A device driver that implements the main logic to talk with
> +	a media hardware.

Terms that are part of the glossary should also be capitalized (and cross-
referenced within the glossary).

Hardware is still uncountable in English. I know we've discussed this=20
previously, but if we want to write a glossary, it should be in English. Ma=
ybe=20
we need to involve a native English speaker here. Kieran ? :-)

Additionally, I don't think the definition is correct. Bridges, as defined =
in=20
V4L2, are opposed to subdevs, while "media hardware" in your definition=20
includes everything. This needs to be clarified.

> +	For V4L2 hardware, this is also known as V4L2 main driver.

Do we use the term V4L2 main driver in the V4L2 spec ?

> +    Consumer Electronics Control API
> +	An API designed to receive and transmit data via a HDMI
> +	CEC interface.

So the definition of "Consumer Electronics Control" is CEC ? :-) It would b=
e=20
more useful to do it the other way around, define CEC as Consumer Electroni=
cs=20
Control, and explain what it is.

> +	See :ref:`cec`.
> +
> +    Device Node
> +	A character device node in the file system used to control and do
> +	input/output data transfers from/to a Kernel driver.

Maybe "and transfer data in and out of a kernel driver" ?

> +
> +    Digital TV API - DVB API

Is DVB the same as Digital TV ? The digital video API (https://linuxtv.org/
downloads/v4l-dvb-apis-new/uapi/v4l/dv-timings.html) is sometimes referred =
to=20
digital TV too. How about standardizing on DVB and avoiding digital TV=20
completely in the specification ?

> +	An API designed to control the media device components related to
> +	digital TV, including frontends, demuxes, streaming, conditional
> +	access, etc.
> +
> +	See :ref:`dvbapi`.
> +
> +    Digital Signal Processor - DSP

Here and below I would put the abbreviation first. If someone looks up a te=
rm=20
in the glossary because they don't know what it means, they're more likely =
to=20
search for the abbreviation, not the full term.

> +	A specialized microprocessor, with its architecture optimized for
> +	the operational needs of digital signal processing.

Stupid question, do we need this entry in the glossary ? The term DSP doesn=
't=20
seem to be used anywhere in the documentation, and in a video context, I=20
expect the definition of ISP to be more relevant.

I also wonder whether we shouldn't drop terms that are defined by the indus=
try=20
(such as DSP, FPGA, I2C, IC, IP core, ISP, Microprocessor, SMBus and SPI), =
and=20
only focus on terms that have a custom definition in the Linux media=20
subsystem.

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
> +    Inter-Integrated Circuit - I=B2C
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
> +    Intelectual property core - IP block
> +	In electronic design a semiconductor intellectual property core,
> +	is a reusable unit of logic, cell, or integrated circuit layout
> +	design that is the intellectual property of one party.
> +	IP cores may be licensed to another party or can be owned
> +	and used by a single party alone.
> +
> +	See
> https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
> +
> +    Image Signal Processor - ISP
> +	A specialised processor that implements a set of algorithms for
> +	processing image data. ISPs may implement algorithms for lens
> +	shading correction, demosaic, scaling and pixel format conversion
> +	as well as produce statistics for the use of the control
> +	algorithms (e.g. automatic exposure, white balance and focus).
> +
> +    Media API
> +	A set of userspace APIs used to control a media hardware.

How about explcitly listing the APIs that the umbrella term "Media API" cov=
ers=20
?

> +	See :ref:`media_uapi`.
> +
> +    Media Controller
> +	An API designed to expose and control devices and sub-devices'
> +	relationships to applications.

What do you mean by "relationships to applications" ?

> +	See :ref:`media_controller`.
> +
> +    Media Hardware
> +	Subset of a hardware that is supported by the Linux Media API.
> +
> +	Includes audio and video capture and playback hardware,
> +	digital and analog TV, camera sensors, ISPs, remote controllers,
> +	codecs, HDMI Consumer Electronics Control, HDMI capture, etc.
> +
> +
> +	See :ref:`media_uapi`.
> +
> +

Extra blank space ?

> +    Microprocessor
> +	An electronic circuitry that carries out the instructions
> +	of a computer program by performing the basic arithmetic, logical,
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
> +	A subset of I=B2C, with defines a stricter usage of the bus.
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
> +       The userspace API defined at :ref:`v4l2spec`, with is used to

s/at/in/

> control
> +       a V4L2 hardware.
> +
> +    V4L2 hardware
> +       Part of a media hardware with is supported by the V4L2
> +       userspace API.

That's kind of a circular definition, isn't it ?

> +    V4L2 main driver
> +	A V4L2 device driver that implements the main logic to talk with
> +	a V4L2 hardware.
> +
> +    V4L2 sub-device
> +	Part of a media hardware that it is implemented by a device

s/it is/is/

> +	driver that is not part of the main V4L2 driver.

I don't think that's correct a V4L2 subdev is a software object, not a piec=
e=20
of hardware.

> +	See :ref:`subdev`.

=2D-=20
Regards,

Laurent Pinchart
