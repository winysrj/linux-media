Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36120 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754625AbdGSKkY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 06:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <1500302710.21957.1.camel@ndufresne.ca>
References: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com>
 <2363665.x6z9MR1vqI@avalon> <1500137353.2353.1.camel@ndufresne.ca>
 <11368407.z8bSoa2YAE@avalon> <1500302710.21957.1.camel@ndufresne.ca>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Wed, 19 Jul 2017 18:40:23 +0800
Message-ID: <CAFLEztR24XBFFtSitvKQ5iRA802nm1LHE2pJvUmZUbFd5F6-Tw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] [media] rockchip/rga: v4l2 m2m support
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        robh+dt@kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, s.nawrocki@samsung.com,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2017-07-17 22:45 GMT+08:00 Nicolas Dufresne <nicolas@ndufresne.ca>:
> Le lundi 17 juillet 2017 =C3=A0 05:37 +0300, Laurent Pinchart a =C3=A9cri=
t :
>> Hi Nicolas,
>>
>> On Saturday 15 Jul 2017 12:49:13 Personnel wrote:
>>
>> You might want to fix your mailer to use your name :-)
>>
>> > Le samedi 15 juillet 2017 =C3=A0 12:42 +0300, Laurent Pinchart a =C3=
=A9crit :
>> > > On Saturday 15 Jul 2017 14:58:36 Jacob Chen wrote:
>> > > > Rockchip RGA is a separate 2D raster graphic acceleration unit. It
>> > > > accelerates 2D graphics operations, such as point/line drawing, im=
age
>> > > > scaling, rotation, BitBLT, alpha blending and image blur/sharpness=
.
>> > > >
>> > > > The drvier is mostly based on s5p-g2d v4l2 m2m driver.
>> > > > And supports various operations from the rendering pipeline.
>> > > >
>> > > >  - copy
>> > > >  - fast solid color fill
>> > > >  - rotation
>> > > >  - flip
>> > > >  - alpha blending
>> > >
>> > > I notice that you don't support the drawing operations. How do you p=
lan to
>> > > support them later through the V4L2 M2M API ? I hate stating the obv=
ious,
>> > > but wouldn't the DRM API be better fit for a graphic accelerator ?
>> >
>> > It could fit, maybe, but it really lacks some framework. Also, DRM is
>> > not really meant for M2M operation, and it's also not great for multi-
>> > process.
>>
>> GPUs on embedded devices are mem-to-mem, and they're definitely shared b=
etween
>> multiple processes :-)
>>
>> > Until recently, there was competing drivers for Exynos, both
>> > implemented in V4L2 and DRM, for similar rational, all DRM ones are
>> > being deprecated/removed.
>> >
>> > I think 2D blitters in V4L2 are fine, but they terribly lack something
>> > to differentiate them from converters/scalers when looking up the HW
>> > list. Could be as simple as a capability flag, if I can suggest. For
>> > the reference, the 2D blitter on IMX6 has been used to implement a liv=
e
>> > video mixer in GStreamer.
>> >
>> > https://bugzilla.gnome.org/show_bug.cgi?id=3D772766
>>
>> If we decide that 2D blitters should be supported by V4L2 (and I'm open =
to get
>> convinced about that), we really need to define a proper API before merg=
ing a
>> bunch of drivers that will implement things in slightly different ways,
>> otherwise the future will be very painful.
>
> Arguably, Jacob is not proposing anything new, as at least one other
> driver has been merged.
>
>>
>> Among the issues that need to be solved are
>>
>> - stateful vs. stateless operation (as mentioned by Jacob in this mail
>> thread), a.k.a. the request API
>
> Would it be possible to extend your thought. To me, Request API could
> enable more use cases but is not strictly required.
>
>>
>> - exposing capabilities to userspace (a single capability flag would be =
enough
>> only if all blitters expose the same API, which I'm not sure we can assu=
me)
>
> I am just rethinking this. With this patch series, Jacob is trying to
> generalize the Blit Operation controls (still need a name, blend mode
> does not work). We can easily make a recommendation to set the default
> operation to a copy operation (drivers always support that). This way,
> the node will behave like a converter (scaler, colorspace converter,
> rotator and/or etc.) Checking the presence of that control, we can
> clearly and quickly figure-out what this node is about. The capability
> remains a nice idea, but probably optional.
>
> I totally agree we should document the behaviours and rationals for
> picking a certain default. The control should maybe become a "menu"
> too, so each driver can cherry-pick the blit operations they support
> (using int with min/max requires userspace trial and error, we already
> did that mistake for encoders profiles and level).
>
>>
>> - single input (a.k.a. in-place blitters as you mentioned below) vs. mul=
tiple
>> inputs
>
> I do think the second is something you can build on top of the first by
> cascading (what we do in the refereed GStreamer element). So far this
> is applicable to Exynos, IMX6 and now Rockchip (probably more). The
> "optimal" form for the second case seems like something that will be
> implemented using much lower level kernel interface, like a GPU
> programming interface (aka proprietary Adreno C2D API), or through
> multiple nodes (multiple inputs and outputs). It's seems like the cut
> between high-end and low-end.
>
>>
>> - API for 2D-accelerated operations other than blitting (filling, point =
and
>> line drawing, ...)
>
> I doubt such hardware exist in a form that is not bound to the GPU. I'm
> not ignoring your point, there is a clear overlap between how we
> integrated GPUs and having this into V4L2.
>

I think stateless and multiple inputs are optional, we don't have to
support it right now.
(Though we really need a stateless m2m API, too many hardwares need it, not=
 just
2d blitters, but also internal dsp, image process units.... It would
be really great
 if people could convert their custom drivers to V4L2. )


Agree that we should have API for more 2D-accelerated operations and
capabilities,

What about this?

#define V4L2_CID_2D_MODE
enum v4l2_2d_mode {
        V4L2_2D_MODE_COPY
        V4L2_2D_MODE_FILLING
        V4L2_2D_MODE_PORTERDUFF
        /*
        V4L2_2D_MODE_BITBLT
        V4L2_2D_MODE_ALPHA_BLEND
        other operations.....
        */
}


/* for V4L2_2D_MODE_PORTERDUFF */
#define V4L2_CID_2D_PORTERDUFF_MODE
ATOP
SRC
.....


/* for V4L2_2D_MODE_BITBLT */
#define V4L2_2D_BITBLT_ROP
XOR
OR
AND
NOT
....

#define .......


/* for V4L2_2D_MODE_ALPHA_BLEND */
#define .......
........

/* for V4L2_2D_MODE_FILLING */
V4L2_CID_BG_COLOR
#define .......


We use copy as the default mode for hardware that not support bitblt/alpha =
blend
e.g : some image process units, used for image enhancement/noise reduction
(Though BITBLT+copy rop or V4L2_2D_MODE_PORTERDUFF+SRC+MODE =3D copy)


V4L2_2D_MODE_PORTERDUFF are used to wrap bitblt/alpha-blend.
If driver need a more customizable API, they could implent  V4L2_2D_MODE_BI=
TBLT/
V4L2_2D_MODE_ALPHA_BLEND, or they just need implent V4L2_2D_MODE_PORTERDUFF=
.


Driver return false in ioctl to show capabilities.


>>
>> > > Additionally, V4L2 M2M has one source and one destination. How do yo=
u
>> > > implement alpha blending in that case, which by definition requires =
at
>> > > least two sources ?
>> >
>> > This type of HW only do in-place blits. When using such a node, the
>> > buffer queued on the V4L2_CAPTURE contains the destination image, and
>> > the buffer queued on the V4L2_OUTPUT is the source image.
>> >
>> > > > The code in rga-hw.c is used to configure regs accroding to operat=
ions.
>> > > >
>> > > > The code in rga-buf.c is used to create private mmu table for RGA.
>> > > > The tables is stored in a list, and be removed when buffer is clea=
nup.
>> > >
>> > > Looking at the implementation it seems to be a scatter-gather list, =
not an
>> > > MMU. Is that right ? Does the hardware documentation refer to it as =
an MMU
>> > > ?
>> > >
>> > > > Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
>> > > > ---
>> > > >
>> > > >  drivers/media/platform/Kconfig                |  11 +
>> > > >  drivers/media/platform/Makefile               |   2 +
>> > > >  drivers/media/platform/rockchip-rga/Makefile  |   3 +
>> > > >  drivers/media/platform/rockchip-rga/rga-buf.c | 122 ++++
>> > > >  drivers/media/platform/rockchip-rga/rga-hw.c  | 652 +++++++++++++=
+++++
>> > > >  drivers/media/platform/rockchip-rga/rga-hw.h  | 437 ++++++++++++
>> > > >  drivers/media/platform/rockchip-rga/rga.c     | 958 +++++++++++++=
++++++
>> > > >  drivers/media/platform/rockchip-rga/rga.h     | 111 +++
>> > > >  8 files changed, 2296 insertions(+)
>> > > >  create mode 100644 drivers/media/platform/rockchip-rga/Makefile
>> > > >  create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
>> > > >  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
>> > > >  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
>> > > >  create mode 100644 drivers/media/platform/rockchip-rga/rga.c
>> > > >  create mode 100644 drivers/media/platform/rockchip-rga/rga.h
>>
>>
