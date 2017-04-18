Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:26675 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753293AbdDRRNU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 13:13:20 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 5/7] doc_rst: media: New SDR formats PC16, PC18 & PC20
Date: Tue, 18 Apr 2017 17:13:13 +0000
Message-ID: <HK2PR06MB054587E6329C32C2DD9A38B1C3190@HK2PR06MB0545.apcprd06.prod.outlook.com>
References: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1486479757-32128-6-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <213133284.36Jzg1zrIM@avalon>
In-Reply-To: <213133284.36Jzg1zrIM@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review comments.

> On Tuesday 07 Feb 2017 15:02:35 Ramesh Shanmugasundaram wrote:
> > This patch adds documentation for the three new SDR formats
> >
> > V4L2_SDR_FMT_PCU16BE
> > V4L2_SDR_FMT_PCU18BE
> > V4L2_SDR_FMT_PCU20BE
> >
> > Signed-off-by: Ramesh Shanmugasundaram
> > <ramesh.shanmugasundaram@bp.renesas.com> ---
> >  .../media/uapi/v4l/pixfmt-sdr-pcu16be.rst          | 55
> +++++++++++++++++++
> >  .../media/uapi/v4l/pixfmt-sdr-pcu18be.rst          | 55
> +++++++++++++++++++
> >  .../media/uapi/v4l/pixfmt-sdr-pcu20be.rst          | 54
> +++++++++++++++++++
> >  Documentation/media/uapi/v4l/sdr-formats.rst       |  3 ++
> >  4 files changed, 167 insertions(+)
> >  create mode 100644
> > Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
> >  create mode 100644
> > Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
> >  create mode 100644
> > Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
> >
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
> > b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst new file mode
> > 100644 index 0000000..2de1b1a
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
> > @@ -0,0 +1,55 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _V4L2-SDR-FMT-PCU16BE:
> > +
> > +******************************
> > +V4L2_SDR_FMT_PCU16BE ('PC16')
> > +******************************
> > +
> > +Planar complex unsigned 16-bit big endian IQ sample
> > +
> > +Description
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +This format contains a sequence of complex number samples. Each
> > +complex number consist of two parts called In-phase and Quadrature
> > +(IQ). Both I and Q are represented as a 16 bit unsigned big endian
> > +number stored in
> > +32 bit space. The remaining unused bits within the 32 bit space will
> > +be padded with 0. I value starts first and Q value starts at an
> > +offset equalling half of the buffer size (i.e.) offset =3D
> > +buffersize/2. Out of the 16 bits, bit 15:2 (14 bit) is data and bit
> > +1:0 (2 bit) can be any value.
>=20
> This sounds very strange to me. Are the two lower bits always random ?
> What is that used for ?

It could be zeros or it could be status bits in case of MAX2175 (if enabled=
). I mentioned any value because the user app does not have any assumptions=
 on these bits value.
=20
>=20
> > +**Byte Order.**
> > +Each cell is one byte.
> > +
> > +.. flat-table::
> > +    :header-rows:  1
> > +    :stub-columns: 0
> > +
> > +    * -  Offset:
> > +      -  Byte B0
> > +      -  Byte B1
> > +      -  Byte B2
> > +      -  Byte B3
> > +    * -  start + 0:
> > +      -  I'\ :sub:`0[13:6]`
> > +      -  I'\ :sub:`0[5:0]; B1[1:0]=3Dpad`
> > +      -  pad
> > +      -  pad
> > +    * -  start + 4:
> > +      -  I'\ :sub:`1[13:6]`
> > +      -  I'\ :sub:`1[5:0]; B1[1:0]=3Dpad`
> > +      -  pad
> > +      -  pad
> > +    * -  ...
> > +    * - start + offset:
> > +      -  Q'\ :sub:`0[13:6]`
> > +      -  Q'\ :sub:`0[5:0]; B1[1:0]=3Dpad`
> > +      -  pad
> > +      -  pad
> > +    * - start + offset + 4:
> > +      -  Q'\ :sub:`1[13:6]`
> > +      -  Q'\ :sub:`1[5:0]; B1[1:0]=3Dpad`
> > +      -  pad
> > +      -  pad
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
> > b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst new file mode
> > 100644 index 0000000..da8b26b
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
> > @@ -0,0 +1,55 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _V4L2-SDR-FMT-PCU18BE:
> > +
> > +******************************
> > +V4L2_SDR_FMT_PCU18BE ('PC18')
> > +******************************
> > +
> > +Planar complex unsigned 18-bit big endian IQ sample
> > +
> > +Description
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +This format contains a sequence of complex number samples. Each
> > +complex number consist of two parts called In-phase and Quadrature
> > +(IQ). Both I and Q are represented as a 18 bit unsigned big endian
> > +number stored in
> > +32 bit space. The remaining unused bits within the 32 bit space will
> > +be padded with 0. I value starts first and Q value starts at an
> > +offset equalling half of the buffer size (i.e.) offset =3D
> > +buffersize/2. Out of the 18 bits, bit 17:2 (16 bit) is data and bit
> > +1:0 (2 bit) can be any value.
> > +
> > +**Byte Order.**
> > +Each cell is one byte.
> > +
> > +.. flat-table::
> > +    :header-rows:  1
> > +    :stub-columns: 0
> > +
> > +    * -  Offset:
> > +      -  Byte B0
> > +      -  Byte B1
> > +      -  Byte B2
> > +      -  Byte B3
> > +    * -  start + 0:
> > +      -  I'\ :sub:`0[17:10]`
> > +      -  I'\ :sub:`0[9:2]`
> > +      -  I'\ :sub:`0[1:0]; B2[5:0]=3Dpad`
> > +      -  pad
> > +    * -  start + 4:
> > +      -  I'\ :sub:`1[17:10]`
> > +      -  I'\ :sub:`1[9:2]`
> > +      -  I'\ :sub:`1[1:0]; B2[5:0]=3Dpad`
> > +      -  pad
> > +    * -  ...
> > +    * - start + offset:
> > +      -  Q'\ :sub:`0[17:10]`
> > +      -  Q'\ :sub:`0[9:2]`
> > +      -  Q'\ :sub:`0[1:0]; B2[5:0]=3Dpad`
> > +      -  pad
> > +    * - start + offset + 4:
> > +      -  Q'\ :sub:`1[17:10]`
> > +      -  Q'\ :sub:`1[9:2]`
> > +      -  Q'\ :sub:`1[1:0]; B2[5:0]=3Dpad`
> > +      -  pad
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
> > b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst new file mode
> > 100644 index 0000000..5499eed
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
> > @@ -0,0 +1,54 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +.. _V4L2-SDR-FMT-PCU20BE:
> > +
> > +******************************
> > +V4L2_SDR_FMT_PCU20BE ('PC20')
> > +******************************
> > +
> > +Planar complex unsigned 20-bit big endian IQ sample
> > +
> > +Description
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +This format contains a sequence of complex number samples. Each
> > +complex number consist of two parts called In-phase and Quadrature
> > +(IQ). Both I and Q are represented as a 20 bit unsigned big endian
> > +number stored in
> > +32 bit space. The remaining unused bits within the 32 bit space will
> > +be padded with 0. I value starts first and Q value starts at an
> > +offset equalling half of the buffer size (i.e.) offset =3D
> > +buffersize/2. Out of the 20 bits, bit 19:2 (18 bit) is data and bit
> > +1:0 (2 bit) can be any value.
> > +
> > +**Byte Order.**
> > +Each cell is one byte.
> > +
> > +.. flat-table::
> > +    :header-rows:  1
> > +    :stub-columns: 0
> > +
> > +    * -  Offset:
> > +      -  Byte B0
> > +      -  Byte B1
> > +      -  Byte B2
> > +      -  Byte B3
> > +    * -  start + 0:
> > +      -  I'\ :sub:`0[19:12]`
> > +      -  I'\ :sub:`0[11:4]`
> > +      -  I'\ :sub:`0[3:0]; B2[3:0]=3Dpad`
> > +      -  pad
> > +    * -  start + 4:
> > +      -  I'\ :sub:`1[19:12]`
> > +      -  I'\ :sub:`1[11:4]`
> > +      -  I'\ :sub:`1[3:0]; B2[3:0]=3Dpad`
> > +      -  pad
> > +    * -  ...
> > +    * - start + offset:
> > +      -  Q'\ :sub:`0[19:12]`
> > +      -  Q'\ :sub:`0[11:4]`
> > +      -  Q'\ :sub:`0[3:0]; B2[3:0]=3Dpad`
> > +      -  pad
> > +    * - start + offset + 4:
> > +      -  Q'\ :sub:`1[19:12]`
> > +      -  Q'\ :sub:`1[11:4]`
> > +      -  Q'\ :sub:`1[3:0]; B2[3:0]=3Dpad`
> > +      -  pad
> > diff --git a/Documentation/media/uapi/v4l/sdr-formats.rst
> > b/Documentation/media/uapi/v4l/sdr-formats.rst index f863c08..2037f5b
> > 100644
> > --- a/Documentation/media/uapi/v4l/sdr-formats.rst
> > +++ b/Documentation/media/uapi/v4l/sdr-formats.rst
> > @@ -17,3 +17,6 @@ These formats are used for :ref:`SDR <sdr>`
> > interface only. pixfmt-sdr-cs08
> >      pixfmt-sdr-cs14le
> >      pixfmt-sdr-ru12le
> > +    pixfmt-sdr-pcu16be
> > +    pixfmt-sdr-pcu18be
> > +    pixfmt-sdr-pcu20be


Thanks,
Ramesh
