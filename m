Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53460 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbeJDRtr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 13:49:47 -0400
Date: Thu, 4 Oct 2018 07:56:57 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] media: docs: add glossary.rst with common terms used
 at V4L2 spec
Message-ID: <20181004075657.2313a445@coco.lan>
In-Reply-To: <2df98a95-a7bb-3c01-f07f-27f3bfc849ea@xs4all.nl>
References: <02e399c34a614182ecfa4212cc610fe7d57024f4.1537902727.git.mchehab+samsung@kernel.org>
        <2df98a95-a7bb-3c01-f07f-27f3bfc849ea@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 1 Oct 2018 17:20:26 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/25/2018 09:14 PM, Mauro Carvalho Chehab wrote:
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
> >   - Make glossary generic enough to be used for all media uAPI document=
ation;
> >   - Add a few new items to the glossary, to imply that it covers not on=
ly V4L2;
> >   - Move it to the uAPI document as a hole.
> >=20
> > v2: Did some changes based on Sakari's feedback.
> >=20
> >  Documentation/media/media_uapi.rst    |   3 +
> >  Documentation/media/uapi/glossary.rst | 162 ++++++++++++++++++++++++++
> >  2 files changed, 165 insertions(+)
> >  create mode 100644 Documentation/media/uapi/glossary.rst
> >=20
> > diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/m=
edia_uapi.rst
> > index 28eb35a1f965..41f091a26003 100644
> > --- a/Documentation/media/media_uapi.rst
> > +++ b/Documentation/media/media_uapi.rst
> > @@ -2,6 +2,8 @@
> > =20
> >  .. include:: <isonum.txt>
> > =20
> > +.. _media_uapi:
> > +
> >  ########################################
> >  Linux Media Infrastructure userspace API
> >  ########################################
> > @@ -31,3 +33,4 @@ License".
> >      uapi/cec/cec-api
> >      uapi/gen-errors
> >      uapi/fdl-appendix
> > +    uapi/glossary
> > diff --git a/Documentation/media/uapi/glossary.rst b/Documentation/medi=
a/uapi/glossary.rst
> > new file mode 100644
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
> > +    Bridge driver
> > +	A device driver that implements the main logic to talk with
> > +	a media hardware. =20
>=20
> s/a //
>=20
> > +
> > +	For V4L2 hardware, this is also known as V4L2 main driver. =20
>=20
> s/as/as the/
>=20
> > +
> > +    Consumer Electronics Control API
> > +	An API designed to receive and transmit data via a HDMI
> > +	CEC interface.
> > +
> > +	See :ref:`cec`.
> > +
> > +    Device Node
> > +	A character device node in the file system used to control and do
> > +	input/output data transfers from/to a Kernel driver.
> > +
> > +    Digital TV API - DVB API
> > +	An API designed to control the media device components related to
> > +	digital TV, including frontends, demuxes, streaming, conditional
> > +	access, etc. =20
>=20
> To be added to this glossary in the future:
>=20
> - Frontend
> - Demux
> - Conditional Access

Yeah. The idea here is just to place a boilerplate for it.

We should in the future add more terms to the glossary. After
having the glossary added, it should be reviewed along the other
documents. Then, I'll add digital TV specific terms.

>=20
> > +
> > +	See :ref:`dvbapi`.
> > +
> > +    Digital Signal Processor - DSP
> > +	A specialized microprocessor, with its architecture optimized for
> > +	the operational needs of digital signal processing.
> > +
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
> > +    Intelectual property core - IP block =20
>=20
> Intelectual -> Intellectual
>=20
> > +	In electronic design a semiconductor intellectual property core,
> > +	is a reusable unit of logic, cell, or integrated circuit layout
> > +	design that is the intellectual property of one party.
> > +	IP cores may be licensed to another party or can be owned
> > +	and used by a single party alone.
> > +
> > +	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property=
_core).
> > +
> > +    Image Signal Processor - ISP
> > +	A specialised processor that implements a set of algorithms for
> > +	processing image data. ISPs may implement algorithms for lens
> > +	shading correction, demosaic, scaling and pixel format conversion =20
>=20
> demosaicing
>=20
> > +	as well as produce statistics for the use of the control
> > +	algorithms (e.g. automatic exposure, white balance and focus).
> > +
> > +    Media API
> > +	A set of userspace APIs used to control a media hardware.
> > +
> > +	See :ref:`media_uapi`.
> > +
> > +    Media Controller
> > +	An API designed to expose and control devices and sub-devices'
> > +	relationships to applications. =20
>=20
> I'd rephrase this:
>=20
> 	An API designed to expose and control the relationships between
> 	devices and sub-devices.
>=20
> It's an API, so no need to add 'to applications', since that's already
> implicit in the name 'API'.
>=20
> > +
> > +	See :ref:`media_controller`.
> > +
> > +    Media Hardware
> > +	Subset of a hardware that is supported by the Linux Media API. =20
>=20
> s/a/the/
>=20
> > +
> > +	Includes audio and video capture and playback hardware, =20
>=20
> s/Includes/This includes/
>=20
> > +	digital and analog TV, camera sensors, ISPs, remote controllers,
> > +	codecs, HDMI Consumer Electronics Control, HDMI capture, etc.
> > +
> > +
> > +	See :ref:`media_uapi`.
> > +
> > +
> > +    Microprocessor
> > +	An electronic circuitry that carries out the instructions =20
>=20
> s/An electronic/Electronic/
>=20
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
> > +	A subset of I=C2=B2C, with defines a stricter usage of the bus. =20
>=20
> with -> which
>=20
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
> > +       The userspace API defined at :ref:`v4l2spec`, with is used to c=
ontrol =20
>=20
> with -> which
>=20
> > +       a V4L2 hardware.
> > +
> > +    V4L2 hardware
> > +       Part of a media hardware with is supported by the V4L2 =20
>=20
> with -> which
>=20
> > +       userspace API.
> > +
> > +    V4L2 main driver
> > +	A V4L2 device driver that implements the main logic to talk with
> > +	a V4L2 hardware. =20
>=20
> s/a//
>=20
> > +
> > +    V4L2 sub-device
> > +	Part of a media hardware that it is implemented by a device =20
>=20
> s/a/the/
> s/it//
>=20
> > +	driver that is not part of the main V4L2 driver.
> > +
> > +	See :ref:`subdev`.
> >  =20
>=20
> Regards,
>=20
> 	Hans


Except for the Digital TV new terms, all suggestions accepted.
I'm enclosing the diff against v3.

Thanks,
Mauro

-


diff --git a/Documentation/media/uapi/glossary.rst b/Documentation/media/ua=
pi/glossary.rst
index 9e2a2b29e8b2..4307decd345f 100644
--- a/Documentation/media/uapi/glossary.rst
+++ b/Documentation/media/uapi/glossary.rst
@@ -29,9 +29,9 @@ Glossary
=20
     Bridge driver
 	A device driver that implements the main logic to talk with
-	a media hardware.
+	media hardware.
=20
-	For V4L2 hardware, this is also known as V4L2 main driver.
+	For V4L2 hardware, this is also known as the V4L2 main driver.
=20
     Consumer Electronics Control API
 	An API designed to receive and transmit data via a HDMI
@@ -78,7 +78,7 @@ Glossary
=20
 	Also known as chip.
=20
-    Intelectual property core - IP block
+    Intellectual property core - IP block
 	In electronic design a semiconductor intellectual property core,
 	is a reusable unit of logic, cell, or integrated circuit layout
 	design that is the intellectual property of one party.
@@ -90,7 +90,7 @@ Glossary
     Image Signal Processor - ISP
 	A specialised processor that implements a set of algorithms for
 	processing image data. ISPs may implement algorithms for lens
-	shading correction, demosaic, scaling and pixel format conversion
+	shading correction, demosaicing, scaling and pixel format conversion
 	as well as produce statistics for the use of the control
 	algorithms (e.g. automatic exposure, white balance and focus).
=20
@@ -100,15 +100,15 @@ Glossary
 	See :ref:`media_uapi`.
=20
     Media Controller
-	An API designed to expose and control devices and sub-devices'
-	relationships to applications.
+	An API designed to expose and control the relationships between
+	devices and sub-devices.
=20
 	See :ref:`media_controller`.
=20
     Media Hardware
-	Subset of a hardware that is supported by the Linux Media API.
+	Subset of the hardware that is supported by the Linux Media API.
=20
-	Includes audio and video capture and playback hardware,
+	This includes audio and video capture and playback hardware,
 	digital and analog TV, camera sensors, ISPs, remote controllers,
 	codecs, HDMI Consumer Electronics Control, HDMI capture, etc.
=20
@@ -117,8 +117,8 @@ Glossary
=20
=20
     Microprocessor
-	An electronic circuitry that carries out the instructions
-	of a computer program by performing the basic arithmetic, logical,
+	Electronic circuitry that carries out the instructions of a
+	computer program by performing the basic arithmetic, logical,
 	control and input/output (I/O) operations specified by the
 	instructions on a single integrated circuit.
=20
@@ -129,7 +129,7 @@ Glossary
 	See :ref:`remote_controllers`.
=20
     SMBus
-	A subset of I=C2=B2C, with defines a stricter usage of the bus.
+	A subset of I=C2=B2C, whith defines a stricter usage of the bus.
=20
     Serial Peripheral Interface Bus - SPI
 	Synchronous serial communication interface specification used for
@@ -144,19 +144,19 @@ Glossary
 	V4L2 main driver.
=20
     V4L2 userspace API - V4L2 API
-       The userspace API defined at :ref:`v4l2spec`, with is used to contr=
ol
-       a V4L2 hardware.
+	The userspace API defined at :ref:`v4l2spec`, whith is used to
+	control a V4L2 hardware.
=20
     V4L2 hardware
-       Part of a media hardware with is supported by the V4L2
-       userspace API.
+	Part of a media hardware with is supported by the V4L2
+	userspace API.
=20
     V4L2 main driver
 	A V4L2 device driver that implements the main logic to talk with
-	a V4L2 hardware.
+	V4L2 hardware.
=20
     V4L2 sub-device
-	Part of a media hardware that it is implemented by a device
+	Part of the media hardware that is implemented by a device
 	driver that is not part of the main V4L2 driver.
=20
 	See :ref:`subdev`.
