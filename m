Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36469 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbdGQDnn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 23:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <2354312.gltkBKX446@avalon>
References: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com>
 <1500137353.2353.1.camel@ndufresne.ca> <CAFLEztQZKqDwOyRCYLapa=730mWs80SOi6RuXwq5VR6m+RjO5w@mail.gmail.com>
 <2354312.gltkBKX446@avalon>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Mon, 17 Jul 2017 11:43:42 +0800
Message-ID: <CAFLEztQNQMJ+wWMcNEqCsC3uPsG4TrOVGXpKcFE5-pnPp+f=AQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] [media] rockchip/rga: v4l2 m2m support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Personnel <nicolas@ndufresne.ca>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        robh+dt@kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        laurent.pinchart+renesas@ideasonboard.com,
        Hans Verkuil <hans.verkuil@cisco.com>, s.nawrocki@samsung.com,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2017-07-17 10:43 GMT+08:00 Laurent Pinchart <laurent.pinchart@ideasonboard.=
com>:
> Hi Jacob,
>
> On Sunday 16 Jul 2017 12:19:41 Jacob Chen wrote:
>> 2017-07-16 0:49 GMT+08:00 Personnel:
>> > Le samedi 15 juillet 2017 =C3=A0 12:42 +0300, Laurent Pinchart a =C3=
=A9crit :
>> >> On Saturday 15 Jul 2017 14:58:36 Jacob Chen wrote:
>> >> > Rockchip RGA is a separate 2D raster graphic acceleration unit. It
>> >> > accelerates 2D graphics operations, such as point/line drawing, ima=
ge
>> >> > scaling, rotation, BitBLT, alpha blending and image blur/sharpness.
>> >> >
>> >> > The drvier is mostly based on s5p-g2d v4l2 m2m driver.
>> >> > And supports various operations from the rendering pipeline.
>> >> >
>> >> >  - copy
>> >> >  - fast solid color fill
>> >> >  - rotation
>> >> >  - flip
>> >> >  - alpha blending
>> >>
>> >> I notice that you don't support the drawing operations. How do you pl=
an
>> >> to support them later through the V4L2 M2M API ? I hate stating the
>> >> obvious, but wouldn't the DRM API be better fit for a graphic acceler=
ator
>> >> ?
>> >
>> > It could fit, maybe, but it really lacks some framework. Also, DRM is
>> > not really meant for M2M operation, and it's also not great for multi-
>> > process. Until recently, there was competing drivers for Exynos, both
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
>> We have write a drm RGA driver.
>> https://patchwork.kernel.org/patch/8630841/
>>
>> Here are the reasons that why i rewrite it to V4l2 M2M.
>> 1. V4l2 have a better buffer framework. If it use DRM-GEM to handle buff=
ers,
>> there will be much redundant cache flush, and we have to add much hack c=
ode
>> to workaround.
>
> I'm glad to hear that you find buffer handling easy in V4L2 :-)
>
>> 2. This driver will be used in rockchip linux project. We mostly use it =
to
>> scale/colorconvert/rotate/mix video/camera stream.
>> A V4L2 M2M drvier can be directly used in gstreamer.
>>
>> The disadvantages of V4l2 M2M API is that it's not stateless.
>> It's inconvenient if user change size frequently, but it's OK,
>> we have not yet need this and I think it's possible to extend. ;)
>
> CC'ing Alexandre Courbot. Alex, how's the request API going ? :-)
>
>> >> Additionally, V4L2 M2M has one source and one destination. How do you
>> >> implement alpha blending in that case, which by definition requires a=
t
>> >> least two sources ?
>> >
>> > This type of HW only do in-place blits. When using such a node, the
>> > buffer queued on the V4L2_CAPTURE contains the destination image, and
>> > the buffer queued on the V4L2_OUTPUT is the source image.
>>
>> Yep.
>
> So the device performs bi-directional DMA on the capture queue buffers ?
> Interesting, does videobuf2 support that properly ?
>

>From the code, I think V4L2_CAPTURE and V4L2_OUTPUT are handled
in the same way. In my test, it work properly.


>> >>> The code in rga-hw.c is used to configure regs accroding to operatio=
ns.
>> >>>
>> >>> The code in rga-buf.c is used to create private mmu table for RGA.
>> >>> The tables is stored in a list, and be removed when buffer is cleanu=
p.
>> >>
>> >> Looking at the implementation it seems to be a scatter-gather list, n=
ot
>> >> an MMU. Is that right ? Does the hardware documentation refer to it a=
s an
>> >> MMU ?
>>
>> It's a 1-level MMU... We use it like a scatter-gather list,
>> It's also the reason why we don't use RGA with DRM API.
>
> You might want to explain this in the code, otherwise someone will ask yo=
u why
> you don't implement support for the MMU through the IOMMU API. Calling it
> scatter-gather would solve that problem, but if the hardware manual calls=
 it
> an MMU, there's no reason not to use that name in the code.
>

ok, i will add comments

>> >>> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
>> >>> ---
>> >>>
>> >>>  drivers/media/platform/Kconfig                |  11 +
>> >>>  drivers/media/platform/Makefile               |   2 +
>> >>>  drivers/media/platform/rockchip-rga/Makefile  |   3 +
>> >>>  drivers/media/platform/rockchip-rga/rga-buf.c | 122 ++++
>> >>>  drivers/media/platform/rockchip-rga/rga-hw.c  | 652 +++++++++++++++=
+++
>> >>>  drivers/media/platform/rockchip-rga/rga-hw.h  | 437 ++++++++++++
>> >>>  drivers/media/platform/rockchip-rga/rga.c     | 958 +++++++++++++++=
+++
>> >>>  drivers/media/platform/rockchip-rga/rga.h     | 111 +++
>> >>>  8 files changed, 2296 insertions(+)
>> >>>  create mode 100644 drivers/media/platform/rockchip-rga/Makefile
>> >>>  create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
>> >>>  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
>> >>>  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
>> >>>  create mode 100644 drivers/media/platform/rockchip-rga/rga.c
>> >>>  create mode 100644 drivers/media/platform/rockchip-rga/rga.h
>
> --
> Regards,
>
> Laurent Pinchart
>
