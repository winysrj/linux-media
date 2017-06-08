Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:55113 "EHLO
        relmlie4.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751092AbdFHLEF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 07:04:05 -0400
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
Date: Thu, 8 Jun 2017 11:04:00 +0000
Message-ID: <KL1PR0601MB2038DA15F6AAB1CB46DBFB5FC3C90@KL1PR0601MB2038.apcprd06.prod.outlook.com>
References: <20170531084457.4800-1-ramesh.shanmugasundaram@bp.renesas.com>
        <20170531084457.4800-4-ramesh.shanmugasundaram@bp.renesas.com>
        <20170607101721.064aafe4@vento.lan>
        <KL1PR0601MB20385C566733E32AC4DCA987C3C90@KL1PR0601MB2038.apcprd06.prod.outlook.com>
 <20170608072317.2e018a90@vento.lan>
In-Reply-To: <20170608072317.2e018a90@vento.lan>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Em Thu, 8 Jun 2017 09:42:43 +0000
> Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com> escreveu=
:
>=20
> > > Subject: Re: [PATCH v6 3/7] media: i2c: max2175: Add MAX2175 support
> > >
> > > Em Wed, 31 May 2017 09:44:53 +0100
> > > Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> escreveu:
> > >
> > > > +++ b/Documentation/media/v4l-drivers/max2175.rst
> > > > @@ -0,0 +1,60 @@
> > > > +Maxim Integrated MAX2175 RF to bits tuner driver
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > > > +
> > > > +The MAX2175 driver implements the following driver-specific
> controls:
> > > > +
> > > > +``V4L2_CID_MAX2175_I2S_ENABLE``
> > > > +-------------------------------
> > > > +    Enable/Disable I2S output of the tuner.
> > > > +
> > > > +.. flat-table::
> > > > +    :header-rows:  0
> > > > +    :stub-columns: 0
> > > > +    :widths:       1 4
> > > > +
> > > > +    * - ``(0)``
> > > > +      - I2S output is disabled.
> > > > +    * - ``(1)``
> > > > +      - I2S output is enabled.
> > >
> > > Hmm... There are other drivers at the subsystem that use I2S (for
> > > audio - not for SDR - but I guess the issue is similar).
> > >
> > > On such drivers, the bridge driver controls it directly, being sure
> > > that I2S is enabled when it is expecting some data coming from the I2=
S
> bus.
> > >
> > > On some drivers, there are both I2S and A/D inputs at the bridge
> chipset.
> > > On such drivers, enabling/disabling I2S is done via VIDIOC_S_INPUT
> > > (and optionally via ALSA mixer), being transparent to the user if
> > > the stream comes from a tuner via I2S or from a directly connected A/=
D
> input.
> > >
> > > I don't think it is a good idea to enable it via a control, as, if
> > > the bridge driver is expecting data via I2S, disabling it will cause
> > > timeouts at the videobuf handling.
> >
> > The MAX2175 device is exposed as a v4l2 subdev with tuner ops and can
> interface with an SDR device. When the tuner is configured, the I2S outpu=
t
> is enabled by default. From an independent tuner device perspective, this
> default behaviour is enough and this control may not be needed/used.
> >
> > However, for the use case here, the R-Car DRIF device acts as the main
> SDR device and the Maxim MAX2175 provides a sub-dev interface with tuner
> ops.
> >
> > +---------------------+                +---------------------+
> > |                     |-----SCK------->|CLK                  |
> > |       Master        |-----SS-------->|SYNC  DRIFn (slave)  |
> > |      (MAX2175)      |-----SD0------->|D0                   |
> > |                     |-----SD1------->|D1                   |
> > +---------------------+                +---------------------+
> >
> > The DRIF device design is such that it involves separate register write=
s
> to enable Rx on each of the data line. To keep both the data lines in syn=
c
> it expects the master device to enable output after both the data line Rx
> are enabled.
> >
> > This level of control is exposed as a feature in the MAX2175 using this
> control. When interfaced with DRIF this control is used to achieve the
> desired functionality. When not interfaced with DRIF, the MAX2175 default
> behaviour does not have to change because of DRIF and hence this I2S
> control may be unused. Like MAX2175, DRIF is also an independent device
> and can interface with a different third party tuner.
> >
> > Hence, this I2S enable/disable is exposed as a user control. The end
> user application (knowing both these devices) is expected to use these
> controls appropriately. Please let me know if I need to explain anything
> in further detail.
>=20
>=20
> The usecase is clear. That's exactly what other drivers with I2S do,
> except that, on those other drivers, they pass I2S control info via
> platform_data (they're not platform drivers).
>=20
> With those drivers, generic applications work as-is via the standard
> video, radio or sdr devnodes, without knowing about I2S.
>=20
> The main difference here is that you're requiring an specialized
> application for this device to work,=20

Specialized application may be needed for this specific combination of devi=
ces (DRIF + MAX2175) only. For MAX2175 alone, a generic application itself =
would be enough. The MAX2175 will have I2S output enabled by default and th=
e SDR device have to just enable/disable its own RX during .start_streaming=
/.stop_streaming.

as a generic one won't be aware of
> this device-specific control, and may end by exposing this "internal"
> control to the end user. That is OK for embedded usage, but, as soon as
> this is used on some non-embedded usecase (with is likely, as there are
> several PC consumer products using other chips from Maxim), we'll have
> problems.
>=20
> I guess the solution here is to make such control visible only via the
> subdev interface.
>=20

Did you mean using v4l2_subdev_tuner_ops? It does not have a method as of t=
oday to support this. The video, audio subdev ops supports s_stream method.=
 We may need to create one for tuner ops.

Thanks,
Ramesh
