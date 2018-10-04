Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37636 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbeJDUUd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 16:20:33 -0400
Date: Thu, 4 Oct 2018 10:27:06 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v3] media: docs: add glossary.rst with common terms used
 at V4L2 spec
Message-ID: <20181004102706.53d5eb97@coco.lan>
In-Reply-To: <2646453.94SmjfbUfy@avalon>
References: <02e399c34a614182ecfa4212cc610fe7d57024f4.1537902727.git.mchehab+samsung@kernel.org>
        <2646453.94SmjfbUfy@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 04 Oct 2018 14:41:30 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
>=20
> (CC'ing Kieran)
>=20
> Thank you for the patch.
>=20
> On Tuesday, 25 September 2018 22:14:51 EEST Mauro Carvalho Chehab wrote:
> > From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >=20
> > Add a glossary of terms used within the media userspace API
> > documentation, as several concepts are complex enough to cause
> > misunderstandings.
> >=20
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >=20
> > v3:
> >   - Add SPDX header and dual-license the glossary
> >   - Make glossary generic enough to be used for all media uAPI
> > documentation; - Add a few new items to the glossary, to imply that it
> > covers not only V4L2; - Move it to the uAPI document as a hole.
> >=20
> > v2: Did some changes based on Sakari's feedback.
> >=20
> >  Documentation/media/media_uapi.rst    |   3 +
> >  Documentation/media/uapi/glossary.rst | 162 ++++++++++++++++++++++++++
> >  2 files changed, 165 insertions(+)
> >  create mode 100644 Documentation/media/uapi/glossary.rst
> >=20
> > diff --git a/Documentation/media/media_uapi.rst
> > b/Documentation/media/media_uapi.rst index 28eb35a1f965..41f091a26003
> > 100644
> > --- a/Documentation/media/media_uapi.rst
> > +++ b/Documentation/media/media_uapi.rst
> > @@ -2,6 +2,8 @@
> >=20
> >  .. include:: <isonum.txt>
> >=20
> > +.. _media_uapi:
> > +
> >  ########################################
> >  Linux Media Infrastructure userspace API
> >  ########################################
> > @@ -31,3 +33,4 @@ License".
> >      uapi/cec/cec-api
> >      uapi/gen-errors
> >      uapi/fdl-appendix
> > +    uapi/glossary =20
>=20
> Is there an easy way to cross-reference to the glossary when terms are us=
ed ?

According with Sphinx documentation, there is:
	:term:`some glossary term`

But, on the tests I did here, it didn't really work with Sphinx 1.4.

It is actually on my TODO list to seek for a good way to address it
(and to find/replace occurrences of the terms at the documentation
to add cross-refs).

>=20
> > diff --git a/Documentation/media/uapi/glossary.rst
> > b/Documentation/media/uapi/glossary.rst new file mode 100644
> > index 000000000000..9e2a2b29e8b2
> > --- /dev/null
> > +++ b/Documentation/media/uapi/glossary.rst
> > @@ -0,0 +1,162 @@
> > +.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later
> > +
> > +.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
> > +..
> > +.. For GFDL-1.1-or-later, see:
> > +..
> > +.. Permission is granted to copy, distribute and/or modify this docume=
nt
> > +.. under the terms of the GNU Free Documentation License, Version 1.1 =
or
> > +.. any later version published by the Free Software Foundation, with no
> > +.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
> > +.. A copy of the license is included at
> > +.. Documentation/media/uapi/fdl-appendix.rst.
> > +
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +Glossary
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +.. note::
> > +
> > +   This goal of section is to standardize the terms used within the me=
dia
> > +   userspace API documentation. It is written incrementally as they are
> > +   standardized in the media documentation.
> > +
> > +   So, it is a Work In Progress.
> > +
> > +.. Please keep the glossary entries in alphabetical order
> > +
> > +.. glossary::
> > +
> > +    Bridge driver =20
>=20
> Shouldn't all words start with a capital letter ?

I guess it is a matter of preference.

Right now, I'm capitalizing stuff only when they have acronyms
(like Digital Signal Processor - DSP), but I'm ok of doing it
to the other terms as well.

>=20
> > +	A device driver that implements the main logic to talk with
> > +	a media hardware. =20
>=20
> Terms that are part of the glossary should also be capitalized (and cross-
> referenced within the glossary).

For now, it doesn't matter much. When we add cross references, it will use
either :ref: or :term:, so the actual text will be inserted by
Sphinx.

>=20
> Hardware is still uncountable in English. I know we've discussed this=20
> previously, but if we want to write a glossary, it should be in English. =
Maybe=20
> we need to involve a native English speaker here. Kieran ? :-)

I'll replace:

	a media hardware -> media hardware

>=20
> Additionally, I don't think the definition is correct. Bridges, as define=
d in=20
> V4L2, are opposed to subdevs, while "media hardware" in your definition=20
> includes everything. This needs to be clarified.

Please notice that the goal of this glossary is to be generic, and not
specific to V4L2. Extra care should be taken if we want to talk about
"subdevs" here, as such concept doesn't exist on DVB, CEC or RC (but
"main driver" does).

Also, I don't think that a subdev driver would fit into
"implements the main logic to talk with media hardware."

Anyway, if you have a better definition, feel free to suggest.


>=20
> > +	For V4L2 hardware, this is also known as V4L2 main driver. =20
>=20
> Do we use the term V4L2 main driver in the V4L2 spec ?

Right now, I don't think we use, but this is something that we'll
need to, in order to define hardware controls.

Anyway, I'll remove the reference for a V4L2 hardware from this patch,
moving to the one that talks about vdev-centric/mc-centric.

>=20
> > +    Consumer Electronics Control API
> > +	An API designed to receive and transmit data via a HDMI
> > +	CEC interface. =20
>=20
> So the definition of "Consumer Electronics Control" is CEC ? :-) It would=
 be=20
> more useful to do it the other way around, define CEC as Consumer Electro=
nics=20
> Control, and explain what it is.

Just like I answered to Hans with regards to Digital TV API, this is just
a boilerplate for CEC-related stuff.

The terms used by CEC should be added on a future patch.

>=20
> > +	See :ref:`cec`.
> > +
> > +    Device Node
> > +	A character device node in the file system used to control and do
> > +	input/output data transfers from/to a Kernel driver. =20
>=20
> Maybe "and transfer data in and out of a kernel driver" ?

Works for me.

>=20
> > +
> > +    Digital TV API - DVB API =20
>=20
> Is DVB the same as Digital TV ? The digital video API (https://linuxtv.or=
g/
> downloads/v4l-dvb-apis-new/uapi/v4l/dv-timings.html) is sometimes referre=
d to=20
> digital TV too. How about standardizing on DVB and avoiding digital TV=20
> completely in the specification ?

Actually, we did the reverse. This was known as DVB API, but, as DVB
is a specific TV standard, used mainly in Europe, and the API was
extended to work also with non-European standards, we replaced

	DVB -> Digital TV (or DTV)=20

at the docs at the places it wouldn't be breaking userspace or
when it refers to the European standard.

>=20
> > +	An API designed to control the media device components related to
> > +	digital TV, including frontends, demuxes, streaming, conditional
> > +	access, etc.
> > +
> > +	See :ref:`dvbapi`.
> > +
> > +    Digital Signal Processor - DSP =20
>=20
> Here and below I would put the abbreviation first. If someone looks up a =
term=20
> in the glossary because they don't know what it means, they're more likel=
y to=20
> search for the abbreviation, not the full term.

Makes sense.

>=20
> > +	A specialized microprocessor, with its architecture optimized for
> > +	the operational needs of digital signal processing. =20
>=20
> Stupid question, do we need this entry in the glossary ? The term DSP doe=
sn't=20
> seem to be used anywhere in the documentation, and in a video context, I=
=20
> expect the definition of ISP to be more relevant.

It is used inside the glossary to define other terms. Also, we may
need to use it when talking about codecs.

>=20
> I also wonder whether we shouldn't drop terms that are defined by the ind=
ustry=20
> (such as DSP, FPGA, I2C, IC, IP core, ISP, Microprocessor, SMBus and SPI)=
, and=20
> only focus on terms that have a custom definition in the Linux media=20
> subsystem.

I don't think it hurts to have definitions for them. IMO, if we use a term,
we need to define it, in order to let clear about what we're talking about.
That also helps new Kernel developers to start understanding our documentat=
ion.

IMHO, it is complex enough to justify such glossary.

>=20
> > +    Driver
> > +	Part of the Linux Kernel that implements support for a hardware
> > +	component.
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
> > +	serial computer bus used to control some hardware components
> > +	like sub-device hardware components.
> > +
> > +	See http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
> > +
> > +    Integrated circuit - IC
> > +	A set of electronic circuits on one small flat piece of
> > +	semiconductor material, normally silicon.
> > +
> > +	Also known as chip.
> > +
> > +    Intelectual property core - IP block
> > +	In electronic design a semiconductor intellectual property core,
> > +	is a reusable unit of logic, cell, or integrated circuit layout
> > +	design that is the intellectual property of one party.
> > +	IP cores may be licensed to another party or can be owned
> > +	and used by a single party alone.
> > +
> > +	See
> > https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
> > +
> > +    Image Signal Processor - ISP
> > +	A specialised processor that implements a set of algorithms for
> > +	processing image data. ISPs may implement algorithms for lens
> > +	shading correction, demosaic, scaling and pixel format conversion
> > +	as well as produce statistics for the use of the control
> > +	algorithms (e.g. automatic exposure, white balance and focus).
> > +
> > +    Media API
> > +	A set of userspace APIs used to control a media hardware. =20
>=20
> How about explcitly listing the APIs that the umbrella term "Media API" c=
overs=20
> ?

Makes sense. I'll add.

>=20
> > +	See :ref:`media_uapi`.
> > +
> > +    Media Controller
> > +	An API designed to expose and control devices and sub-devices'
> > +	relationships to applications. =20
>=20
> What do you mean by "relationships to applications" ?

This was proposed by Sakari. Hans proposed a new definition for it:

    Media Controller
        An API designed to expose and control the relationships between
        devices and sub-devices.

        See :ref:`media_controller`.

>=20
> > +	See :ref:`media_controller`.
> > +
> > +    Media Hardware
> > +	Subset of a hardware that is supported by the Linux Media API.
> > +
> > +	Includes audio and video capture and playback hardware,
> > +	digital and analog TV, camera sensors, ISPs, remote controllers,
> > +	codecs, HDMI Consumer Electronics Control, HDMI capture, etc.
> > +
> > +
> > +	See :ref:`media_uapi`.
> > +
> > + =20
>=20
> Extra blank space ?

Yes, already removed.

>=20
> > +    Microprocessor
> > +	An electronic circuitry that carries out the instructions
> > +	of a computer program by performing the basic arithmetic, logical,
> > +	control and input/output (I/O) operations specified by the
> > +	instructions on a single integrated circuit.
> > +
> > +    Remote Controller API
> > +	An API designed to receive and transmit data from remote
> > +	controllers.
> > +
> > +	See :ref:`remote_controllers`.
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
> > +	V4L2 hardware components that aren't controlled by a
> > +	V4L2 main driver.
> > +
> > +    V4L2 userspace API - V4L2 API
> > +       The userspace API defined at :ref:`v4l2spec`, with is used to =
=20
>=20
> s/at/in/

ok.

>=20
> > control
> > +       a V4L2 hardware.
> > +
> > +    V4L2 hardware
> > +       Part of a media hardware with is supported by the V4L2
> > +       userspace API. =20
>=20
> That's kind of a circular definition, isn't it ?

I don't think so. The only thing that defines a "V4L2 hardware"
(or whatever other term it would be used to describe a hardware
subset that is used by V4L2) is really the API.

There are *lots* of cases where the same IC has support for
V4L2, RC, ALSA and DVB, all integrated. On several cases, the
hardware it just a microcontroller (or FPGA) with I/O pins and
the needed logic to control audio, video streaming and remote
controllers.

For example, an em28xx chip has internally a firmware that uses=20
an 8051-based CPU, having pins that are used for RC, analog and
digital TV.

[1] http://standwell.cn/Uploadfiles/20151022154755309.pdf

> > +    V4L2 main driver
> > +	A V4L2 device driver that implements the main logic to talk with
> > +	a V4L2 hardware.
> > +
> > +    V4L2 sub-device
> > +	Part of a media hardware that it is implemented by a device =20
>=20
> s/it is/is/

Ok.

>=20
> > +	driver that is not part of the main V4L2 driver. =20
>=20
> I don't think that's correct a V4L2 subdev is a software object, not a pi=
ece=20
> of hardware.

It is a software object used to control part of the hardware.

Also, usually, it is a way easier to identify what part of
the hardware is controlled by a V4L2 subdev than what part
is controlled by a main driver.

Think for example on a sensor subdev - with controls=20
something that it is physically distinct from an IP block
inside some SoC.

Do you have a better definition?


>=20
> > +	See :ref:`subdev`. =20
>=20



Thanks,
Mauro
