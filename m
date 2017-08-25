Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40784 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754783AbdHYN4l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 09:56:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 1/3] media: open.rst: document devnode-centric and mc-centric types
Date: Fri, 25 Aug 2017 16:57:12 +0300
Message-ID: <3557785.Q2WiA7Eg9u@avalon>
In-Reply-To: <20170825103823.29bb2373@vento.lan>
References: <cover.1503653839.git.mchehab@s-opensource.com> <14323646.WPb2L3qxUc@avalon> <20170825103823.29bb2373@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday, 25 August 2017 16:38:23 EEST Mauro Carvalho Chehab wrote:
> Em Fri, 25 Aug 2017 16:11:15 +0300 Laurent Pinchart escreveu:
> > On Friday, 25 August 2017 12:40:05 EEST Mauro Carvalho Chehab wrote:
> >> From: "mchehab@s-opensource.com" <mchehab@s-opensource.com>
> >>=20
> >> When we added support for omap3, back in 2010, we added a new
> >> type of V4L2 devices that aren't fully controlled via the V4L2
> >> device node. Yet, we never made it clear, at the V4L2 spec,
> >> about the differences between both types.
> >=20
> > Nitpicking (and there will be lots of nitpicking in this review as I th=
ink
> > it's very important to get this piece of the documentation right down to
> > details):
> >
> Sure.
>=20
> > s/at the V4L2 spec/in the V4L2 spec/
> >=20
> > "make it clear about" doesn't sound good to me. How about the following=
 ?
> >=20
> > "Yet, we have never clearly documented in the V4L2 specification the
> > differences between the two types."
> >=20
> >> Let's document them with the current implementation.
> >=20
> > s/with the/based on the/
>=20
> OK.
>=20
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >> ---
> >>=20
> >>  Documentation/media/uapi/v4l/open.rst | 50 ++++++++++++++++++++++++++=
+++
> >>  1 file changed, 50 insertions(+)
> >>=20
> >> diff --git a/Documentation/media/uapi/v4l/open.rst
> >> b/Documentation/media/uapi/v4l/open.rst index afd116edb40d..a72d142897=
c0
> >> 100644
> >> --- a/Documentation/media/uapi/v4l/open.rst
> >> +++ b/Documentation/media/uapi/v4l/open.rst
> >> @@ -6,6 +6,56 @@
> >>  Opening and Closing Devices
> >>  ***************************
> >>=20
> >> +Types of V4L2 hardware control
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +V4L2 devices are usually complex: they are implemented via a main
> >> driver and
> >> +often several additional drivers. The main driver always exposes one =
or
> >> +more **V4L2 device** devnodes (see :ref:`v4l2_device_naming`).
> >=20
> > First of all, as stated in a previous e-mail, I think we should start by
> > defining the terms we are going to use.
>=20
> Well, we can add a Glossary at the spec, but this is a huge work,
> as we'll need to seek for other terms and to adjust all references
> to use the Glossary wording. This is a separate work than what this
> patch proposes to solve.
>=20
> Yet, I agree that ambiguity should be solved. I believe that the
> second version of this patch series address it.

As discussed over IRC we don't need a full glossary. We can start with=20
definitions of the terms we use here, and enrich it incrementally in the=20
future.

> > The word "device" is ambiguous, it can mean
> >=20
> > - device node
> >=20
> > The /dev device node through which a character- or block-based API is
> > exposed through userspace.
> >=20
> > The term "device node" is commonly used in the kernel, I think we can u=
se
> > it as-is without ambiguity.
>=20
> Yes. IMO, we should use:
>=20
> - "device node" when it may refer to any device node,
>   including mc and subdev;
> - "V4L2 device node" when it refers only to the devices that are now
>   described at the "V4L2 Device Node Naming" section (see patch 1 of the
>   new patch series).

And "V4L2 subdev device node" and "MC device node" when we want to refer=20
specifically to the /dev/v4l-subdev* and /dev/media* device nodes ?

> > - kernel struct device
> >=20
> > An instance of the kernel struct device. Kernel devices are used to
> > represent hardware devices (and are then embedded in bus-specific device
> > structure such as platform_device, pci_device or i2c_client) and logical
> > devices (and are then embedded in class-spcific device structures such =
as
> > struct video_device or struct net_device).
> >=20
> > For now I believe this isn't relevant to the V4L2 userspace API
> > discussion, so we can leave it out.
>=20
> Yes. Let's leave it out.
>=20
> > - hardware device
> >=20
> > The hardware counterpart of the first category of the kernel struct
> > device, a hardware (and thus physical) device such as an SoC IP core or
> > an I2C chip.
> >=20
> > We could call this "hardware device" or "hardware component". Other
> > proposals are welcome.
>=20
> as proposed by Hans, on the newer version, we're just using "hardware".

Hardware is very generic too. A PCI capture card is hardware, an antenna=20
connector is hardware, a TV tuner is hardware, a DMA engine is hardware.

The distinction between components and peripherals is in my opinion importa=
nt,=20
otherwise we wouldn't have both struct video_device and struct v4l2_device.=
=20
Userspace middleware developers (I include libv4l2 in this category) will b=
e=20
more interested in components, which applications developers will be more=20
interested in peripherals. In the longer term, we should introduce a=20
peripheral concept for userspace too (in the interface between middlewares =
and=20
applications), the same way we have done it in the kernel with struct=20
v4l2_device.

> > - hardware peripheral
> >=20
> > A group of hardware devices that together make a larger user-facing
> > functional peripheral. For instance the SoC ISP IP cores and external
> > camera sensors together make a camera peripheral.
> >=20
> > If we call the previous device a "hardware component" this could be cal=
led
> > "hardware device". Otherwise "hardware peripheral" is a possible name, =
but
> > we can probably come up with a better name.
> >=20
> > - software peripheral
> >=20
> > The software counterpart of the hardware peripheral. In V4L2 this is
> > modeled by a struct v4l2_device, often associated with a struct
> > media_device.
> >=20
> > I don't like the name "software peripheral", other proposals are welcom=
e.
>=20
> I don't see the need of using those "peripheral" wording terms in this
> chapter. Let's leave it out for now.

I think they're needed. When you talk about pipeline configuration for=20
instance, you talk about peripherals. Individual components don't have=20
pipelines, they are assembled in a pipeline in a peripheral. For instance,=
=20
when you say "The entire device was controlled via the V4L2 device nodes", =
the=20
usage of the word "device" is ambiguous. I think we should avoid using=20
"device" without any qualifier except in context where there can be no=20
confusion (for instance in a section that repeatedly talk about device node=
s=20
and devices nodes only, the word "device" could be used in some places as a=
=20
shortcut).

> > Once we agree on names and definitions I'll comment on the reworked
> > version of this patch, as it's pointless to bikeshed the wording without
> > first agreeing on clear definitions of the concepts we're discussing.
> > Please still see below for a few comments not related to particular
> > wording.
> >=20
> >> +The other drivers are called **V4L2 sub-devices** and provide control
> >> to
> >> +other parts of the hardware usually connected via a serial bus (like
> >> +I=B2C, SMBus or SPI). They can be implicitly controlled directly by t=
he
> >> +main driver or explicitly through via the **V4L2 sub-device API**
> >> interface.
> > > +
> >> +When V4L2 was originally designed, there was only one type of device
> >> control.
> >> +The entire device was controlled via the **V4L2 device nodes**. We
> >> refer to
> >> +this kind of control as **V4L2 device node centric** (or, simply,
> >> +**vdev-centric**).
> >> +
> >> +Since the end of 2010, a new type of V4L2 device control was added in
> >> order
> >> +to support complex devices that are common for embedded systems. Those
> >> +devices are controlled mainly via the media controller and sub-device=
s.
> >> +So, they're called: **Media controller centric** (or, simply,
> > > +"**MC-centric**").
> >=20
> > Do we really need to explain the development history with dates ? I don=
't
> > think it helps understanding the separation between vdev-centric and MC-
> > centric devices.
>=20
> No, but it helps to identify when drivers became incompatible with
> generic apps. We could, instead point on what Kernel version it
> happened. That probably makes more sense and will match the history
> part of the spec.

That was v2.6.39. Do you expect userspace developers to target kernels olde=
r=20
than that ? :-)

> > For instance the previous paragraph that explains that V4L2
> > originally had a single type of device control that we now call
> > vdev-centric doesn't really help understanding what a vdev-centric devi=
ce
> > is.
> >=20
> > It would be clearer in my opinion to explain the two kind of devices wi=
th
> > an associated use case, without referring to the history.
>=20
> The history is important for app developers, as they need to know
> what Kernel versions are affected by V4L2 device nodes that look
> like vdev-centric ones but aren't.
>=20
> Yet, you're right on one point: the date doesn't matter, but, instead,
> the Kernel version where the first mc-centric driver were added.
>=20
> >> +For **vdev-centric** control, the device and their corresponding
> >> hardware
> >> +pipelines are controlled via the **V4L2 device** node. They may
> >> optionally
> >> +expose via the :ref:`media controller API <media_controller>`.
> >> +
> >> +For **MC-centric** control, before using the V4L2 device, it is
> >> required to +set the hardware pipelines via the
> >> +:ref:`media controller API <media_controller>`. For those devices, the
> >> +sub-devices' configuration can be controlled via the
> >> +:ref:`sub-device API <subdev>`, with creates one device node per sub
> >> device.
> >> +
> >> +In summary, for **MC-centric** devices:
> >> +
> >> +- The **V4L2 device** node is responsible for controlling the streami=
ng
> >> +  features;
> >> +- The **media controller device** is responsible to setup the
> >> pipelines;
> >> +- The **V4L2 sub-devices** are responsible for sub-device
> >> +  specific settings.
> >=20
> > How about a summary of vdev-centric devices too ? Or, possibly, no summ=
ary
> > at all ? The need to summarize 5 short paragraphs probably indicates th=
at
> > those paragraphis are not clear enough :-)
>=20
> Done at version 2, already submitted.

I'll review v3 once we agree on definitions for device-related terms :-)

> > I can try to help by proposing enhancements to the documentation once we
> > agree on the glossary above.
> >=20
> >> +.. note::
> >> +
> >> +   A **vdev-centric** may optionally expose V4L2 sub-devices via
> >> +   :ref:`sub-device API <subdev>`. In that case, it has to implement
> >> +   the :ref:`media controller API <media_controller>` as well.
> >=20
> > The separation between vdev-centric and MC-centric devices is quite cle=
ar.
> > If we allow a vdev-centric device to expose subdev nodes we will open t=
he
> > door to all kind of hybrid implementations that have no clear definition
> > today.
>=20
> There are already such devices, as discussed at #media-maint ML. We're
> just documenting the existing status.

The specification doesn't need to document the odd cases that we would have=
=20
rejected if we had known better.

> > It will be very important in that case to document in details what is
> > allowed and what isn't, and how the video device nodes and subdev device
> > nodes interact with each other. I prefer not giving a green light to su=
ch
> > implementations until we have to, and I also prefer discussing this top=
ic
> > separately. It will require a fair amount of work to document (and thus
> > first agree on), and there's no need to block the rest of this patch
> > until we complete that work. For those reasons I would like to explicit=
ly
> > disallow those hybrid devices in this patch, and start discussing the u=
se
> > cases we have for them, and how they would operate.
>=20
> What we can do is to add a notice that this is not recommended or
> that people should not add it without a discussion about what that
> is needed.

How about just saying that's it's forbidden by the specification ? We will=
=20
have a few drivers that don't comply, but we will obviously not blame their=
=20
authors.

I prefer using the strongest possible wording when we want to discourage=20
something. There will always be developers who will still try, but the=20
stronger the wording, the lower the risk.

=2D-=20
Regards,

Laurent Pinchart
