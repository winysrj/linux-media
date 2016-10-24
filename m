Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:12903 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757100AbcJXKTI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 06:19:08 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [RFC 5/5] doc_rst: media: New SDR formats SC16, SC18 & SC20
Date: Mon, 24 Oct 2016 10:19:00 +0000
Message-ID: <SG2PR06MB10388FD8A8EBE46518ADCFBEC3A90@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1476281429-27603-6-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <2893157.XL3Txm4q5I@avalon>
In-Reply-To: <2893157.XL3Txm4q5I@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the review comments.

> On Wednesday 12 Oct 2016 15:10:29 Ramesh Shanmugasundaram wrote:
> > This patch adds documentation for the three new SDR formats
> >
> > V4L2_SDR_FMT_SCU16BE
> > V4L2_SDR_FMT_SCU18BE
> > V4L2_SDR_FMT_SCU20BE
> >
> > Signed-off-by: Ramesh Shanmugasundaram
> > <ramesh.shanmugasundaram@bp.renesas.com> ---
> >  .../media/uapi/v4l/pixfmt-sdr-scu16be.rst          | 44
> ++++++++++++++++++
> >  .../media/uapi/v4l/pixfmt-sdr-scu18be.rst          | 48
> +++++++++++++++++++
> >  .../media/uapi/v4l/pixfmt-sdr-scu20be.rst          | 48
> +++++++++++++++++++
> >  Documentation/media/uapi/v4l/sdr-formats.rst       |  3 ++
> >  4 files changed, 143 insertions(+)
> >  create mode 100644
> > Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst
> >  create mode 100644
> > Documentation/media/uapi/v4l/pixfmt-sdr-scu18be.rst
> >  create mode 100644
> > Documentation/media/uapi/v4l/pixfmt-sdr-scu20be.rst
> >
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst
> > b/Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst new file mode
> > 100644 index 0000000..d6c2123
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst
> > @@ -0,0 +1,44 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _V4L2-SDR-FMT-SCU16BE:
> > +
> > +******************************
> > +V4L2_SDR_FMT_SCU16BE ('SCU16')
>=20
> The value between parentheses is the ASCII representation of the 4CC, it
> should be SC16. Same comment for the other formats.

Agreed. I corrected it after I sent the patch :-(.

>=20
> > +******************************
> > +
> > +Sliced complex unsigned 16-bit big endian IQ sample
> > +
> > +
> > +Description
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +This format contains a sequence of complex number samples. Each
> > +complex number consist of two parts called In-phase and Quadrature
> > +(IQ). Both I and Q are represented as a 16 bit unsigned big endian
> > +number. I value starts first and Q value starts at an offset
> > +equalling half of the buffer size. 14 bit data is stored in 16 bit
> > +space with unused stuffed bits padded with 0.
>=20
> Please specify here how the 14-bit numbers are aligned (i.e. padding in
> bits
> 15:14 or bits 1:0 or any other strange option). Same comment for the othe=
r
> formats.

You are right. Actually the representation would be something like below. I=
 will correct this for all the 3 formats. Thanks.

<------------------------32bits---------------------->
<--14 bit data + 2bit status---- 16bit padded zeros-->
<--14 bit data + 2bit status---- 16bit padded zeros-->

>=20
> > +
> > +**Byte Order.**
> > +Each cell is one byte.
> > +
> > +
> > +.. flat-table::
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +
> > +    -  .. row 1
>=20
> Please use the more compact table stable

Agreed.

>=20
> 	* - start + 0:
> 	  - I'\ :sub:`0[D13:D6]`
> 	  ...
>=20
> Same comment for the other formats.

Agreed.

>=20
> > +
> > +       -  start + 0:
> > +
> > +       -  I'\ :sub:`0[D13:D6]`
> > +
> > +       -  I'\ :sub:`0[D5:D0]`
> > +
> > +    -  .. row 2
> > +
> > +       -  start + buffer_size/2:
> > +
> > +       -  Q'\ :sub:`0[D13:D6]`
> > +
> > +       -  Q'\ :sub:`0[D5:D0]`
>=20
> The format looks planar, does it use one V4L2 plane (as does NV12) or two
> V4L2 planes (as does NV12M) ? Same question for the other formats.

Thank you for bringing up this topic. This is one of the key design dilemma=
.

The I & Q data for these three SDR formats comes from two different DMA cha=
nnels and hence two separate pointers -> we could say it is v4l2 multi-plan=
ar. Right now, I am making it look like a single plane by presenting the da=
ta in one single buffer ptr.=20

For e.g. multi-planar SC16 format would look something like this

<------------------------32bits---------------------->
<--I(14 bit data) + 2bit status--16bit padded zeros--> : start0 + 0=20
<--I(14 bit data) + 2bit status--16bit padded zeros--> : start0 + 4=20
...
<--Q(14 bit data) + 2bit status--16bit padded zeros--> : start1 + 0=20
<--Q(14 bit data) + 2bit status--16bit padded zeros--> : start1 + 4=20

My concerns are

1) These formats are not a standard as the video "Image Formats". These for=
mats are possible when we use DRIF + MAX2175 combination. If we interface w=
ith a different tuner vendor, the above format(s) MAY/MAY NOT be re-usable.=
 We do not know at this point. This is the main open item for discussion in=
 the cover letter.

2) MPLANE support within V4L2 seems specific to video. Please correct me if=
 this is wrong interpretation.
	- struct v4l2_format contains v4l2_sdr_format and v4l2_pix_format_mplane a=
s members of union. Should I create a new v4l2_sdr_format_mplane? If I have=
 to use v4l2_pix_format_mplane most of the video specific members would be =
unused (it would be similar to using v4l2_pix_format itself instead of v4l2=
_sdr_format)?
=09
	- The above decision (accomodate SDR & MPLANE) needs to be propagated acro=
ss the framework. Is this the preferred approach?
=09
It goes back to point (1). As of today, the change set for this combo (DRIF=
+MAX2175) introduces new SDR formats only. Should it add further SDR+MPLANE=
 support to the framework as well?

I would appreciate your suggestions on this regard.

>=20
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-scu18be.rst
> > b/Documentation/media/uapi/v4l/pixfmt-sdr-scu18be.rst new file mode
> > 100644 index 0000000..e6e0aff
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-sdr-scu18be.rst
> > @@ -0,0 +1,48 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _V4L2-SDR-FMT-SCU18BE:
> > +
> > +******************************
> > +V4L2_SDR_FMT_SCU18BE ('SCU18')
> > +******************************
> > +
> > +Sliced complex unsigned 18-bit big endian IQ sample
> > +
> > +
> > +Description
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +This format contains a sequence of complex number samples. Each
> > +complex number consist of two parts called In-phase and Quadrature
> > +(IQ). Both I and Q are represented as a 18 bit unsigned big endian
> > +number. I value starts first and Q value starts at an offset
> > +equalling half of the buffer size. 16 bit data is stored in 18 bit
> > +space with unused stuffed bits padded with 0.
>=20
> Your example below suggests that 18 bit data is stored in 24 bits. Simila=
r
> comment for SCU20.

Agreed. The corrected representation is as I mentioned in the earlier comme=
nt.

Thanks,
Ramesh
