Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41978 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729180AbeIYUPG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 16:15:06 -0400
Date: Tue, 25 Sep 2018 11:07:05 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/3] media: add glossary.rst with common terms used at
 V4L2 spec
Message-ID: <20180925110643.5ba20bda@coco.lan>
In-Reply-To: <20180925130357.fs42d3dnypolejgf@valkosipuli.retiisi.org.uk>
References: <cover.1537876293.git.mchehab+samsung@kernel.org>
        <629351f6ca37592b8345f1d9b691523f5a6a3aa9.1537876293.git.mchehab+samsung@kernel.org>
        <20180925130357.fs42d3dnypolejgf@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Sep 2018 16:03:57 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
>=20
> Thanks for the set! A few quick comments below, mainly additions and lang=
uage.
>=20
> On Tue, Sep 25, 2018 at 09:06:51AM -0300, Mauro Carvalho Chehab wrote:
> > From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >=20
> > Add a glossary of terms for V4L2, as several concepts are complex
> > enough to cause misunderstandings.
> >=20
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  Documentation/media/uapi/v4l/glossary.rst | 108 ++++++++++++++++++++++
> >  Documentation/media/uapi/v4l/v4l2.rst     |   1 +
> >  2 files changed, 109 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/glossary.rst
> >=20
> > diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/=
media/uapi/v4l/glossary.rst
> > new file mode 100644
> > index 000000000000..3dff6430d79f
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/glossary.rst
> > @@ -0,0 +1,108 @@
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +Glossary
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +.. note::
> > +
> > +   This goal of section is to standardize the terms used within the V4=
L2
> > +   documentation. It is written incrementally as they are standardized=
 in
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
> > +    Inter-Integrated Circuit - I=C2=B2C
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
> > +	In electronic design a semiconductor intellectual property core,
> > +	is a reusable unit of logic, cell, or integrated circuit layout
> > +	design that is the intellectual property of one party.
> > +	IP cores may be licensed to another party or can be owned
> > +	and used by a single party alone. =20
>=20
> "Intellectual property" is not really the main point here, but I don't
> object. You could use "hardware block" as well; I think that could be more
> commonly used.
>=20
> Either way, we should be fine with just one of "IP block" and "IP core".

Let's stick with IP block then. "IP is "Intelectual Property", so we
need to use it at the glossary.

>=20
> > +
> > +	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property=
_core).
> > +
> > +    Image Signal Processor - ISP
> > +	A specialised processor that implements a set of algorithms for
> > +	processing image data. ISPs may implement algorithms for lens
> > +	shading correction, demosaic, scaling and pixel format conversion
> > +	as well as produce statistics for the use of the control
> > +	algorithms (e.g. automatic exposure, white balance and focus).
> > +
> > +    Media Controller
> > +	An API designed to expose and control devices and sub-devices
> > +	relationships to applications.
> > +
> > +	See :ref:`media_controller`. =20
>=20
> Could you also add:
>=20
> Media device
>=20
> 	A device node that implements the Media controller interface. Used
> 	to access the Media device complex besides the V4L2 and V4L2
> 	sub-device nodes.
>=20
> Media hardware complex
>=20
> 	A collection of hardware components that together constitute an
> 	complex that can be seen as a single device. An example of this is
> 	a raw Bayer camera and an ISP that processes the images from the
> 	camera before writing them to system memory.

I prefer to keep those more polemic terms to a next patchset.

Yeah, I know that we ended by coming with that "complex" term,
but the more I heard it, the less I like using it on that context.

Anyway, I'm having some ideas that could prevent us the need
of using a complex[1] term like that, but for now, let's skip this
discussion, merging only the parts that won't cause discussions.=20

[1] "complex" in the sense that it produces complex discussions.

>=20
> > +
> > +    MC-centric
> > +	V4L2 hardware that requires a Media controller. =20
>=20
> How about:
>=20
> Hardware the image data pipeline configuration of which requires the use =
of
> Media controller and V4L2 sub-device interfaces.

Sounds ok, but, if we add something like that, we need to define what=20
is a "V4L2 sub-device interface".

Anyway, I should have been removed this one from here, as this
should belong to the next patch series, together with the addition
of such concept.

> > +
> > +    Microprocessor
> > +	An electronic circuitry that carries out the instructions
> > +	of a computer program by performing the basic arithmetic, logical,
> > +	control and input/output (I/O) operations specified by the
> > +	instructions on a single integrated circuit.
> > +
> > +    SMBus
> > +	A subset of I=C2=B2C, with defines a stricter usage of the bus.
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

Here, it should be, instead:

	V4L2 hardware components that aren't controlled by the
	V4L2 main driver.

(for a discussion about V4L2 hardware, see below).

> > +
> > +    V4L2 main driver
> > +	The V4L2 device driver that implements the main logic to talk with
> > +	the V4L2 hardware. =20
>=20
> How about:
>=20
> V4L2 hardware -> hardware
>=20
> There's no "V4L2 hardware" as such.

While this glossary is now being added to just the V4L2 side, if
done right, it could be a common glossary for the entire media API
set. So, let's be very precise to the parts of it that are V4L2
specific from others that would cover the entire media hardware.

Imagine a (fictional) peripheral device that it is an union of
all devices we have on media, e. g. a single device that would
have:

	- Camera sensors;
	- Video capture and output;
	- HDMI capture;
	- codecs;
	- m2m;
	- ISP;
	- CEC;
	- Audio inputs and outputs;
	- Radio;
	- Software Defined Radio;
	- Analog TV;
	- Digital TV;
	- Remote Controller.

We need a term to refer to the subset of such hardware that is supported
via the V4L2 API.

We ended by defining such hardware subset as "V4L2 hardware", in order
to distinguish it from the part of the media hardware that is not
supported by the V4L2 API, like Remote Controller, CEC, "Digital TV",
etc.

Just as a reminder, in the past I guess someone proposed to use
a term like "Video hardware". It has the problem of not covering=20
radio or analog TV parts of the device.

> > +
> > +	Also known as bridge driver.
> > +
> > +    V4L2 sub-device
> > +	Part of the media hardware that it is implemented by a device
> > +	driver that is not part of the main V4L2 driver. =20
>=20
> I would agree with the definition if this were the kernel documentation.
> Towards user space the API matters. How about:
>=20
> Control interface for V4L2 sub-devices that are a part of the Media
> device.

There's no definition for "Media device" at the glossary (and a
definition for it should include CEC, Remote Controller, Digital TV,
etc). With a definition like that, your proposal is wrong, as not
all other components of a media hardware is controlled by the V4L2
sub-device API.

Btw, I guess we can just remove this one, as we have already
a definition for "Sub-device hardware components" that sounds
clear enough.


>=20
> > +
> > +	See :ref:`subdev`.
> > diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/medi=
a/uapi/v4l/v4l2.rst
> > index b89e5621ae69..74b397a8d033 100644
> > --- a/Documentation/media/uapi/v4l/v4l2.rst
> > +++ b/Documentation/media/uapi/v4l/v4l2.rst
> > @@ -32,6 +32,7 @@ This part describes the Video for Linux API version 2=
 (V4L2 API) specification.
> >      videodev
> >      capture-example
> >      v4l2grab-example
> > +    glossary
> >      biblio
> > =20
> >   =20
>=20

I'll send soon a version 2 of this patch.

Thanks,
Mauro
