Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:31450 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750786AbdFHJms (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 05:42:48 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v6 3/7] media: i2c: max2175: Add MAX2175 support
Date: Thu, 8 Jun 2017 09:42:43 +0000
Message-ID: <KL1PR0601MB20385C566733E32AC4DCA987C3C90@KL1PR0601MB2038.apcprd06.prod.outlook.com>
References: <20170531084457.4800-1-ramesh.shanmugasundaram@bp.renesas.com>
        <20170531084457.4800-4-ramesh.shanmugasundaram@bp.renesas.com>
 <20170607101721.064aafe4@vento.lan>
In-Reply-To: <20170607101721.064aafe4@vento.lan>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Subject: Re: [PATCH v6 3/7] media: i2c: max2175: Add MAX2175 support
>=20
> Em Wed, 31 May 2017 09:44:53 +0100
> Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com> escreveu=
:
>=20
> > +++ b/Documentation/media/v4l-drivers/max2175.rst
> > @@ -0,0 +1,60 @@
> > +Maxim Integrated MAX2175 RF to bits tuner driver
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +The MAX2175 driver implements the following driver-specific controls:
> > +
> > +``V4L2_CID_MAX2175_I2S_ENABLE``
> > +-------------------------------
> > +    Enable/Disable I2S output of the tuner.
> > +
> > +.. flat-table::
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 4
> > +
> > +    * - ``(0)``
> > +      - I2S output is disabled.
> > +    * - ``(1)``
> > +      - I2S output is enabled.
>=20
> Hmm... There are other drivers at the subsystem that use I2S (for audio -
> not for SDR - but I guess the issue is similar).
>=20
> On such drivers, the bridge driver controls it directly, being sure that
> I2S is enabled when it is expecting some data coming from the I2S bus.
>=20
> On some drivers, there are both I2S and A/D inputs at the bridge chipset.
> On such drivers, enabling/disabling I2S is done via VIDIOC_S_INPUT (and
> optionally via ALSA mixer), being transparent to the user if the stream
> comes from a tuner via I2S or from a directly connected A/D input.
>=20
> I don't think it is a good idea to enable it via a control, as, if the
> bridge driver is expecting data via I2S, disabling it will cause timeouts
> at the videobuf handling.

The MAX2175 device is exposed as a v4l2 subdev with tuner ops and can inter=
face with an SDR device. When the tuner is configured, the I2S output is en=
abled by default. From an independent tuner device perspective, this defaul=
t behaviour is enough and this control may not be needed/used.

However, for the use case here, the R-Car DRIF device acts as the main SDR =
device and the Maxim MAX2175 provides a sub-dev interface with tuner ops.

+---------------------+                +---------------------+
|                     |-----SCK------->|CLK                  |  =20
|       Master        |-----SS-------->|SYNC  DRIFn (slave)  |
|      (MAX2175)      |-----SD0------->|D0                   |  =20
|                     |-----SD1------->|D1                   |  =20
+---------------------+                +---------------------+

The DRIF device design is such that it involves separate register writes to=
 enable Rx on each of the data line. To keep both the data lines in sync it=
 expects the master device to enable output after both the data line Rx are=
 enabled.

This level of control is exposed as a feature in the MAX2175 using this con=
trol. When interfaced with DRIF this control is used to achieve the desired=
 functionality. When not interfaced with DRIF, the MAX2175 default behaviou=
r does not have to change because of DRIF and hence this I2S control may be=
 unused. Like MAX2175, DRIF is also an independent device and can interface=
 with a different third party tuner.=20

Hence, this I2S enable/disable is exposed as a user control. The end user a=
pplication (knowing both these devices) is expected to use these controls a=
ppropriately. Please let me know if I need to explain anything in further d=
etail.

Thanks,
Ramesh
