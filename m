Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:43202 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbeCIFFa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 00:05:30 -0500
MIME-Version: 1.0
In-Reply-To: <20180309040903.hhkhylvs6q6lvqjy@tarshish>
References: <20180308094807.9443-1-jacob-chen@iotwrt.com> <20180308120200.wpcjnbglf4x32vrp@tarshish>
 <CAFLEztTokSaXJuN8Ls0BpAEuFdTC+Viwn6PGxC=TC6vZAs+w3g@mail.gmail.com> <20180309040903.hhkhylvs6q6lvqjy@tarshish>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Fri, 9 Mar 2018 13:05:28 +0800
Message-ID: <CAFLEztT4XJ9QnvLciv62dFCfj-y7Kynd2R8HpVxXeUXObvp3GQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/17] Rockchip ISP1 Driver
To: Baruch Siach <baruch@tkos.co.il>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?B?6ZKf5Lul5bSH?= <zyc@rock-chips.com>,
        Eddie Cai <eddie.cai.linux@gmail.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Baruch,

2018-03-09 12:09 GMT+08:00 Baruch Siach <baruch@tkos.co.il>:
> Hi Jacob,
>
> On Fri, Mar 09, 2018 at 08:53:57AM +0800, Jacob Chen wrote:
>> 2018-03-08 20:02 GMT+08:00 Baruch Siach <baruch@tkos.co.il>:
>> > On Thu, Mar 08, 2018 at 05:47:50PM +0800, Jacob Chen wrote:
>> >> This patch series add a ISP(Camera) v4l2 driver for rockchip rk3288/r=
k3399
>> >> SoC.
>> >>
>> >> Wiki Pages:
>> >> http://opensource.rock-chips.com/wiki_Rockchip-isp1
>> >>
>> >> The deprecated g_mbus_config op is not dropped in  V6 because i am wa=
iting
>> >> tomasz's patches.
>> >
>> > Which tree is this series based on? On top of v4.16-rc4 I get the buil=
d
>> > failure below. The V4L2_BUF_TYPE_META_OUTPUT macro, for example, is no=
t even
>> > in media_tree.git.
>>
>> This series is based on v4.16-rc4 with below patch.
>> https://patchwork.kernel.org/patch/9792001/
>
> This patch does not apply on v4.16-rc4. I also tried v2 of this patch wit=
h the
> same result:
>
>   https://patchwork.linuxtv.org/patch/44682/

It need resolve merge conflict.

>
> Can you push your series to a public git repo branch?
>

Sure, I have push it to my github.
https://github.com/wzyy2/linux/tree/4.16-rc4

This commit might be a bit of a mess
https://github.com/wzyy2/linux/commit/ff68323c4804adc10f64836ea1be172c54a9d=
6c6

> Thanks,
> baruch
>
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1321:3: error: =E2=
=80=98const struct v4l2_ioctl_ops=E2=80=99 has no member named =E2=80=98vid=
ioc_enum_fmt_meta_out=E2=80=99; did you mean =E2=80=98vidioc_enum_fmt_meta_=
cap=E2=80=99?
>> >   .vidioc_enum_fmt_meta_out =3D rkisp1_params_enum_fmt_meta_out,
>> >    ^~~~~~~~~~~~~~~~~~~~~~~~
>> >    vidioc_enum_fmt_meta_cap
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1321:30: error: init=
ialization from incompatible pointer type [-Werror=3Dincompatible-pointer-t=
ypes]
>> >   .vidioc_enum_fmt_meta_out =3D rkisp1_params_enum_fmt_meta_out,
>> >                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1321:30: note: (near=
 initialization for =E2=80=98rkisp1_params_ioctl.vidioc_g_std=E2=80=99)
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1322:3: error: =E2=
=80=98const struct v4l2_ioctl_ops=E2=80=99 has no member named =E2=80=98vid=
ioc_g_fmt_meta_out=E2=80=99; did you mean =E2=80=98vidioc_g_fmt_meta_cap=E2=
=80=99?
>> >   .vidioc_g_fmt_meta_out =3D rkisp1_params_g_fmt_meta_out,
>> >    ^~~~~~~~~~~~~~~~~~~~~
>> >    vidioc_g_fmt_meta_cap
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1322:27: error: init=
ialization from incompatible pointer type [-Werror=3Dincompatible-pointer-t=
ypes]
>> >   .vidioc_g_fmt_meta_out =3D rkisp1_params_g_fmt_meta_out,
>> >                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1322:27: note: (near=
 initialization for =E2=80=98rkisp1_params_ioctl.vidioc_s_std=E2=80=99)
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1323:3: error: =E2=
=80=98const struct v4l2_ioctl_ops=E2=80=99 has no member named =E2=80=98vid=
ioc_s_fmt_meta_out=E2=80=99; did you mean =E2=80=98vidioc_s_fmt_meta_cap=E2=
=80=99?
>> >   .vidioc_s_fmt_meta_out =3D rkisp1_params_g_fmt_meta_out,
>> >    ^~~~~~~~~~~~~~~~~~~~~
>> >    vidioc_s_fmt_meta_cap
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1323:27: error: init=
ialization from incompatible pointer type [-Werror=3Dincompatible-pointer-t=
ypes]
>> >   .vidioc_s_fmt_meta_out =3D rkisp1_params_g_fmt_meta_out,
>> >                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1323:27: note: (near=
 initialization for =E2=80=98rkisp1_params_ioctl.vidioc_querystd=E2=80=99)
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1324:3: error: =E2=
=80=98const struct v4l2_ioctl_ops=E2=80=99 has no member named =E2=80=98vid=
ioc_try_fmt_meta_out=E2=80=99; did you mean =E2=80=98vidioc_try_fmt_meta_ca=
p=E2=80=99?
>> >   .vidioc_try_fmt_meta_out =3D rkisp1_params_g_fmt_meta_out,
>> >    ^~~~~~~~~~~~~~~~~~~~~~~
>> >    vidioc_try_fmt_meta_cap
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1324:29: error: init=
ialization from incompatible pointer type [-Werror=3Dincompatible-pointer-t=
ypes]
>> >   .vidioc_try_fmt_meta_out =3D rkisp1_params_g_fmt_meta_out,
>> >                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1324:29: note: (near=
 initialization for =E2=80=98rkisp1_params_ioctl.vidioc_enum_input=E2=80=99=
)
>> > drivers/media/platform/rockchip/isp1/isp_params.c: In function =E2=80=
=98rkisp1_params_init_vb2_queue=E2=80=99:
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1462:12: error: =E2=
=80=98V4L2_BUF_TYPE_META_OUTPUT=E2=80=99 undeclared (first use in this func=
tion); did you mean =E2=80=98V4L2_BUF_TYPE_SDR_OUTPUT=E2=80=99?
>> >   q->type =3D V4L2_BUF_TYPE_META_OUTPUT;
>> >             ^~~~~~~~~~~~~~~~~~~~~~~~~
>> >             V4L2_BUF_TYPE_SDR_OUTPUT
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1462:12: note: each =
undeclared identifier is reported only once for each function it appears in
>> >   CC      drivers/media/platform/rockchip/isp1/mipi_dphy_sy.o
>> > drivers/media/platform/rockchip/isp1/isp_params.c: In function =E2=80=
=98rkisp1_register_params_vdev=E2=80=99:
>> > drivers/media/platform/rockchip/isp1/isp_params.c:1507:43: error: =E2=
=80=98V4L2_CAP_META_OUTPUT=E2=80=99 undeclared (first use in this function)=
; did you mean =E2=80=98V4L2_CAP_VBI_OUTPUT=E2=80=99?
>> >   vdev->device_caps =3D V4L2_CAP_STREAMING | V4L2_CAP_META_OUTPUT;
>> >                                            ^~~~~~~~~~~~~~~~~~~~
>> >                                            V4L2_CAP_VBI_OUTPUT
>> >
>> > Thanks,
>> > baruch
>> >
>> >> Jacob Chen (12):
>> >>   media: doc: add document for rkisp1 meta buffer format
>> >>   media: rkisp1: add Rockchip MIPI Synopsys DPHY driver
>> >>   media: rkisp1: add Rockchip ISP1 subdev driver
>> >>   media: rkisp1: add ISP1 statistics driver
>> >>   media: rkisp1: add ISP1 params driver
>> >>   media: rkisp1: add capture device driver
>> >>   media: rkisp1: add rockchip isp1 core driver
>> >>   dt-bindings: Document the Rockchip ISP1 bindings
>> >>   dt-bindings: Document the Rockchip MIPI RX D-PHY bindings
>> >>   ARM: dts: rockchip: add isp node for rk3288
>> >>   ARM: dts: rockchip: add rx0 mipi-phy for rk3288
>> >>   MAINTAINERS: add entry for Rockchip ISP1 driver
>> >>
>> >> Jeffy Chen (1):
>> >>   media: rkisp1: Add user space ABI definitions
>> >>
>> >> Shunqian Zheng (3):
>> >>   media: videodev2.h, v4l2-ioctl: add rkisp1 meta buffer format
>> >>   arm64: dts: rockchip: add isp0 node for rk3399
>> >>   arm64: dts: rockchip: add rx0 mipi-phy for rk3399
>> >>
>> >> Wen Nuan (1):
>> >>   ARM: dts: rockchip: Add dts mipi-dphy TXRX1 node for rk3288
>> >>
>> >>  .../devicetree/bindings/media/rockchip-isp1.txt    |   69 +
>> >>  .../bindings/media/rockchip-mipi-dphy.txt          |   90 +
>> >>  Documentation/media/uapi/v4l/meta-formats.rst      |    2 +
>> >>  .../media/uapi/v4l/pixfmt-meta-rkisp1-params.rst   |   20 +
>> >>  .../media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst     |   18 +
>> >>  MAINTAINERS                                        |   10 +
>> >>  arch/arm/boot/dts/rk3288.dtsi                      |   33 +
>> >>  arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   25 +
>> >>  drivers/media/platform/Kconfig                     |   10 +
>> >>  drivers/media/platform/Makefile                    |    1 +
>> >>  drivers/media/platform/rockchip/isp1/Makefile      |    8 +
>> >>  drivers/media/platform/rockchip/isp1/capture.c     | 1751 ++++++++++=
++++++++++
>> >>  drivers/media/platform/rockchip/isp1/capture.h     |  167 ++
>> >>  drivers/media/platform/rockchip/isp1/common.h      |  110 ++
>> >>  drivers/media/platform/rockchip/isp1/dev.c         |  626 +++++++
>> >>  drivers/media/platform/rockchip/isp1/dev.h         |   93 ++
>> >>  drivers/media/platform/rockchip/isp1/isp_params.c  | 1539 ++++++++++=
+++++++
>> >>  drivers/media/platform/rockchip/isp1/isp_params.h  |   49 +
>> >>  drivers/media/platform/rockchip/isp1/isp_stats.c   |  508 ++++++
>> >>  drivers/media/platform/rockchip/isp1/isp_stats.h   |   58 +
>> >>  .../media/platform/rockchip/isp1/mipi_dphy_sy.c    |  868 ++++++++++
>> >>  .../media/platform/rockchip/isp1/mipi_dphy_sy.h    |   15 +
>> >>  drivers/media/platform/rockchip/isp1/regs.c        |  239 +++
>> >>  drivers/media/platform/rockchip/isp1/regs.h        | 1550 ++++++++++=
+++++++
>> >>  drivers/media/platform/rockchip/isp1/rkisp1.c      | 1177 ++++++++++=
+++
>> >>  drivers/media/platform/rockchip/isp1/rkisp1.h      |  105 ++
>> >>  drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
>> >>  include/uapi/linux/rkisp1-config.h                 |  798 +++++++++
>> >>  include/uapi/linux/videodev2.h                     |    4 +
>> >>  29 files changed, 9945 insertions(+)
>> >>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-=
isp1.txt
>> >>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-=
mipi-dphy.txt
>> >>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-p=
arams.rst
>> >>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-s=
tat.rst
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/Makefile
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/capture.c
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/capture.h
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/common.h
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/dev.c
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/dev.h
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.c
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.h
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_stats.c
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_stats.h
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/mipi_dphy_sy=
.c
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/mipi_dphy_sy=
.h
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/regs.c
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/regs.h
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.c
>> >>  create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.h
>> >>  create mode 100644 include/uapi/linux/rkisp1-config.h
>
> --
>      http://baruch.siach.name/blog/                  ~. .~   Tk Open Syst=
ems
> =3D}------------------------------------------------ooO--U--Ooo----------=
--{=3D
>    - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
