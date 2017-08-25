Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40670 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752874AbdHYNKn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 09:10:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 1/3] media: open.rst: document devnode-centric and mc-centric types
Date: Fri, 25 Aug 2017 16:11:15 +0300
Message-ID: <14323646.WPb2L3qxUc@avalon>
In-Reply-To: <bef8524bf9eb1fbf51fff93d59c42602009858c1.1503653839.git.mchehab@s-opensource.com>
References: <cover.1503653839.git.mchehab@s-opensource.com> <bef8524bf9eb1fbf51fff93d59c42602009858c1.1503653839.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Friday, 25 August 2017 12:40:05 EEST Mauro Carvalho Chehab wrote:
> From: "mchehab@s-opensource.com" <mchehab@s-opensource.com>
>=20
> When we added support for omap3, back in 2010, we added a new
> type of V4L2 devices that aren't fully controlled via the V4L2
> device node. Yet, we never made it clear, at the V4L2 spec,
> about the differences between both types.

Nitpicking (and there will be lots of nitpicking in this review as I think=
=20
it's very important to get this piece of the documentation right down to=20
details):

s/at the V4L2 spec/in the V4L2 spec/

"make it clear about" doesn't sound good to me. How about the following ?

"Yet, we have never clearly documented in the V4L2 specification the=20
differences between the two types."

> Let's document them with the current implementation.

s/with the/based on the/

>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/uapi/v4l/open.rst | 50 +++++++++++++++++++++++++++++=
+++
>  1 file changed, 50 insertions(+)
>=20
> diff --git a/Documentation/media/uapi/v4l/open.rst
> b/Documentation/media/uapi/v4l/open.rst index afd116edb40d..a72d142897c0
> 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -6,6 +6,56 @@
>  Opening and Closing Devices
>  ***************************
>=20
> +Types of V4L2 hardware control
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> +
> +V4L2 devices are usually complex: they are implemented via a main driver
> and
> +often several additional drivers. The main driver always exposes one or
> +more **V4L2 device** devnodes (see :ref:`v4l2_device_naming`).

=46irst of all, as stated in a previous e-mail, I think we should start by=
=20
defining the terms we are going to use. The word "device" is ambiguous, it =
can=20
mean

=2D device node

The /dev device node through which a character- or block-based API is expos=
ed=20
through userspace.

The term "device node" is commonly used in the kernel, I think we can use i=
t=20
as-is without ambiguity.

=2D kernel struct device

An instance of the kernel struct device. Kernel devices are used to represe=
nt=20
hardware devices (and are then embedded in bus-specific device structure su=
ch=20
as platform_device, pci_device or i2c_client) and logical devices (and are=
=20
then embedded in class-spcific device structures such as struct video_devic=
e=20
or struct net_device).

=46or now I believe this isn't relevant to the V4L2 userspace API discussio=
n, so=20
we can leave it out.

=2D hardware device

The hardware counterpart of the first category of the kernel struct device,=
 a=20
hardware (and thus physical) device such as an SoC IP core or an I2C chip.

We could call this "hardware device" or "hardware component". Other proposa=
ls=20
are welcome.

=2D hardware peripheral

A group of hardware devices that together make a larger user-facing functio=
nal=20
peripheral. For instance the SoC ISP IP cores and external camera sensors=20
together make a camera peripheral.

If we call the previous device a "hardware component" this could be called=
=20
"hardware device". Otherwise "hardware peripheral" is a possible name, but =
we=20
can probably come up with a better name.

=2D software peripheral

The software counterpart of the hardware peripheral. In V4L2 this is modele=
d=20
by a struct v4l2_device, often associated with a struct media_device.

I don't like the name "software peripheral", other proposals are welcome.

Once we agree on names and definitions I'll comment on the reworked version=
 of=20
this patch, as it's pointless to bikeshed the wording without first agreein=
g=20
on clear definitions of the concepts we're discussing. Please still see bel=
ow=20
for a few comments not related to particular wording.

> +The other drivers are called **V4L2 sub-devices** and provide control to
> +other parts of the hardware usually connected via a serial bus (like
> +I=B2C, SMBus or SPI). They can be implicitly controlled directly by the
> +main driver or explicitly through via the **V4L2 sub-device API**
> interface.
> +
> +When V4L2 was originally designed, there was only one type of device
> control.
> +The entire device was controlled via the **V4L2 device nodes**. We refer=
 to
> +this kind of control as **V4L2 device node centric** (or,
> simply, +**vdev-centric**).
> +
> +Since the end of 2010, a new type of V4L2 device control was added in or=
der
> +to support complex devices that are common for embedded systems. Those
> +devices are controlled mainly via the media controller and sub-devices.
> +So, they're called: **Media controller centric** (or, simply,
> +"**MC-centric**").

Do we really need to explain the development history with dates ? I don't=20
think it helps understanding the separation between vdev-centric and MC-
centric devices. For instance the previous paragraph that explains that V4L=
2=20
originally had a single type of device control that we now call vdev-centri=
c=20
doesn't really help understanding what a vdev-centric device is.

It would be clearer in my opinion to explain the two kind of devices with a=
n=20
associated use case, without referring to the history.

> +For **vdev-centric** control, the device and their corresponding hardware
> +pipelines are controlled via the **V4L2 device** node. They may optional=
ly
> +expose via the :ref:`media controller API <media_controller>`.
> +
> +For **MC-centric** control, before using the V4L2 device, it is required=
 to
> +set the hardware pipelines via the
> +:ref:`media controller API <media_controller>`. For those devices, the
> +sub-devices' configuration can be controlled via the
> +:ref:`sub-device API <subdev>`, with creates one device node per sub
> device.
> +
> +In summary, for **MC-centric** devices:
> +
> +- The **V4L2 device** node is responsible for controlling the streaming
> +  features;
> +- The **media controller device** is responsible to setup the pipelines;
> +- The **V4L2 sub-devices** are responsible for sub-device
> +  specific settings.

How about a summary of vdev-centric devices too ? Or, possibly, no summary =
at=20
all ? The need to summarize 5 short paragraphs probably indicates that thos=
e=20
paragraphis are not clear enough :-)

I can try to help by proposing enhancements to the documentation once we ag=
ree=20
on the glossary above.

> +.. note::
> +
> +   A **vdev-centric** may optionally expose V4L2 sub-devices via
> +   :ref:`sub-device API <subdev>`. In that case, it has to implement
> +   the :ref:`media controller API <media_controller>` as well.

The separation between vdev-centric and MC-centric devices is quite clear. =
If=20
we allow a vdev-centric device to expose subdev nodes we will open the door=
 to=20
all kind of hybrid implementations that have no clear definition today. It=
=20
will be very important in that case to document in details what is allowed =
and=20
what isn't, and how the video device nodes and subdev device nodes interact=
=20
with each other. I prefer not giving a green light to such implementations=
=20
until we have to, and I also prefer discussing this topic separately. It wi=
ll=20
require a fair amount of work to document (and thus first agree on), and=20
there's no need to block the rest of this patch until we complete that work=
=2E=20
=46or those reasons I would like to explicitly disallow those hybrid device=
s in=20
this patch, and start discussing the use cases we have for them, and how th=
ey=20
would operate.

> +.. _v4l2_device_naming:
>=20
>  Device Naming
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


=2D-=20
Regards,

Laurent Pinchart
