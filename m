Return-path: <linux-media-owner@vger.kernel.org>
Received: from anglina.eu ([195.181.215.36]:45066 "EHLO megous.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751893AbdLVNxH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 08:53:07 -0500
Message-ID: <1513950408.841.81.camel@megous.com>
Subject: Re: [linux-sunxi] [PATCH v4 0/2] Initial Allwinner V3s CSI Support
From: =?UTF-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To: yong.deng@magewell.com,
        "\"Maxime Ripard" <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Date: Fri, 22 Dec 2017 14:46:48 +0100
In-Reply-To: <1513935138-35223-1-git-send-email-yong.deng@magewell.com>
References: <1513935138-35223-1-git-send-email-yong.deng@magewell.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-BrWYAKJ2Oa6HXJYVWwZT"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-BrWYAKJ2Oa6HXJYVWwZT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Yong Deng p=C3=AD=C5=A1e v P=C3=A1 22. 12. 2017 v 17:32 +0800:
> This patchset add initial support for Allwinner V3s CSI.
>=20
> Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> and CSI1 is used for parallel interface. This is not documented in
> datasheet but by testing and guess.
>=20
> This patchset implement a v4l2 framework driver and add a binding=20
> documentation for it.=20
>=20
> Currently, the driver only support the parallel interface. And has been
> tested with a BT1120 signal which generating from FPGA. The following
> fetures are not support with this patchset:
>   - ISP=20
>   - MIPI-CSI2
>   - Master clock for camera sensor
>   - Power regulator for the front end IC
>=20
> Thanks for Ond=C5=99ej Jirman's help.
>=20
> Changes in v4:
>   * Deal with the CSI 'INNER QUEUE'.
>     CSI will lookup the next dma buffer for next frame before the
>     the current frame done IRQ triggered. This is not documented
>     but reported by Ond=C5=99ej Jirman.
>     The BSP code has workaround for this too. It skip to mark the
>     first buffer as frame done for VB2 and pass the second buffer
>     to CSI in the first frame done ISR call. Then in second frame
>     done ISR call, it mark the first buffer as frame done for VB2
>     and pass the third buffer to CSI. And so on. The bad thing is
>     that the first buffer will be written twice and the first frame
>     is dropped even the queued buffer is sufficient.
>     So, I make some improvement here. Pass the next buffer to CSI
>     just follow starting the CSI. In this case, the first frame
>     will be stored in first buffer, second frame in second buffer.
>     This mothed is used to avoid dropping the first frame, it
>     would also drop frame when lacking of queued buffer.
>   * Fix: using a wrong mbus_code when getting the supported formats
>   * Change all fourcc to pixformat
>   * Change some function names
>=20
> Changes in v3:
>   * Get rid of struct sun6i_csi_ops
>   * Move sun6i-csi to new directory drivers/media/platform/sunxi
>   * Merge sun6i_csi.c and sun6i_csi_v3s.c into sun6i_csi.c
>   * Use generic fwnode endpoints parser
>   * Only support a single subdev to make things simple
>   * Many complaintion fix
>=20
> Changes in v2:=20
>   * Change sunxi-csi to sun6i-csi
>   * Rebase to media_tree master branch=20
>=20
> Following is the 'v4l2-compliance -s -f' output, I have test this
> with both interlaced and progressive signal:
>=20
> # ./v4l2-compliance -s -f
> v4l2-compliance SHA   : 6049ea8bd64f9d78ef87ef0c2b3dc9b5de1ca4a1
>=20
> Driver Info:
>         Driver name   : sun6i-video
>         Card type     : sun6i-csi
>         Bus info      : platform:csi
>         Driver version: 4.15.0
>         Capabilities  : 0x84200001
>                 Video Capture
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x04200001
>                 Video Capture
>                 Streaming
>                 Extended Pix Format
>=20
> Compliance test for device /dev/video0 (not using libv4l2):
>=20
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
>=20
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
>         test for unlimited opens: OK
>=20
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
>=20
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 1 Audio Inputs: 0 Tuners: 0
>=20
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
>=20
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
>=20
> Test input 0:
>=20
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
>                 test VIDIOC_QUERYCTRL: OK (Not Supported)
>                 test VIDIOC_G/S_CTRL: OK (Not Supported)
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supporte=
d)
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 0 Private Controls: 0

I'm not sure if your driver passes control queries to the subdev. It
did not originally, and I'm not sure you picked up the change from my
version of the driver. "Not supported" here seems to indicate that it
does not.

I'd be interested what's the recommended practice here. It sure helps
with some apps that expect to be able to modify various input controls
directly on the /dev/video# device. These are then supported out of the
box.

It's a one-line change. See:

https://www.kernel.org/doc/html/latest/media/kapi/v4l2-controls.html#in
heriting-controls

>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK (Not Supported)
>=20
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>=20
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
>=20
> Test input 0:
>=20
> Streaming ioctls:
>         test read/write: OK (Not Supported)
>         test MMAP: OK                                    =20
>         test USERPTR: OK (Not Supported)
>         test DMABUF: Cannot test, specify --expbuf-device
>=20
> Stream using all formats:
>         test MMAP for Format HM12, Frame Size 1280x720:
>                 Stride 1920, Field None: OK                              =
  =20
>         test MMAP for Format NV12, Frame Size 1280x720:
>                 Stride 1920, Field None: OK                              =
  =20
>         test MMAP for Format NV21, Frame Size 1280x720:
>                 Stride 1920, Field None: OK                              =
  =20
>         test MMAP for Format YU12, Frame Size 1280x720:
>                 Stride 1920, Field None: OK                              =
  =20
>         test MMAP for Format YV12, Frame Size 1280x720:
>                 Stride 1920, Field None: OK                              =
  =20
>         test MMAP for Format NV16, Frame Size 1280x720:
>                 Stride 2560, Field None: OK                              =
  =20
>         test MMAP for Format NV61, Frame Size 1280x720:
>                 Stride 2560, Field None: OK                              =
  =20
>         test MMAP for Format 422P, Frame Size 1280x720:
>                 Stride 2560, Field None: OK                              =
  =20
>=20
> Total: 54, Succeeded: 54, Failed: 0, Warnings: 0
>=20
> Yong Deng (2):
>   dt-bindings: media: Add Allwinner V3s Camera Sensor Interface (CSI)
>   media: V3s: Add support for Allwinner CSI.
>=20
>  .../devicetree/bindings/media/sun6i-csi.txt        |  51 ++
>  MAINTAINERS                                        |   8 +
>  drivers/media/platform/Kconfig                     |   1 +
>  drivers/media/platform/Makefile                    |   2 +
>  drivers/media/platform/sunxi/sun6i-csi/Kconfig     |   9 +
>  drivers/media/platform/sunxi/sun6i-csi/Makefile    |   3 +
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 878 +++++++++++++++=
++++++
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h | 147 ++++
>  .../media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h | 203 +++++
>  .../media/platform/sunxi/sun6i-csi/sun6i_video.c   | 752 +++++++++++++++=
+++
>  .../media/platform/sunxi/sun6i-csi/sun6i_video.h   |  60 ++
>  11 files changed, 2114 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Kconfig
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Makefile
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.=
h
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h
>=20
> --=20
> 1.8.3.1
>=20
--=-BrWYAKJ2Oa6HXJYVWwZT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEmrE4sgaRYhzUz5ICbmQmxnfP7/EFAlo9DMgACgkQbmQmxnfP
7/FjEw/9EbY3Cp7W3US0NwbeWi0ohp/nge+YQs4Rk3+EHpKFCCGj9cCypT1WZ/Iu
/2t3WmBmvr37nK9d2UWGzoFGrT5TS4TIg34xgqFjx0RIFsjjbOjuPO+ZUCZlHtgJ
I9yQt4c31S5tRXEExov5KtSfkc4QWIarHaLiOnRlHinLVEEB3iClNRG6uXEf1KXP
oyO1q8WiqnOKQKeRICtldFFpCc05WYGNxHCrtaUsjgb34hKjMxaehlsjy4MlxxO1
O+djzJXg5RN2BomAMMsh86fYAJIScaoPrqZaNpX6Duw6Ik39lJ2LDd+qDnKU0Fbn
X6qg4bz806IhweWZz3+UG+vwD1wRG85byjGRj0GjPERVMNdaLo8d9eMpvumjLgjO
/JyunDl17bMj7UYUgjAxkhs73wMr8O2SeanI2aju/fgoysNHpGffuuI9RI7X3sy0
AXze1/vPYFWrIuOw+PJzyJMHPEYbSOk8JoAnzLXddb1ZLYscx+i+RZ98mGWxWuEL
g7HtJ/p9Zt5urs5Ckl4ghP6wr9Kfe0YAh6YYLqYqoFQuu5sjIW6R7AThl+4AJFEU
sWUZeuqNiYFUxX1SJBwWGJ0InqRfFaFQIHwLdEbE/+8HrXOzklqZ1ToWXpFU7U3r
0G4FQtdmefIm4l06PfnwTnTFcQocefQlO81N6WW36u6r6Z1bC8k=
=wELM
-----END PGP SIGNATURE-----

--=-BrWYAKJ2Oa6HXJYVWwZT--
