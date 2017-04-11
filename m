Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:18614 "EHLO
        relmlie4.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751255AbdDKJ5w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 05:57:52 -0400
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
Subject: RE: [PATCH v3 2/7] dt-bindings: media: Add MAX2175 binding
 description
Date: Tue, 11 Apr 2017 09:57:45 +0000
Message-ID: <HK2PR06MB0545282102FBC0472D9831AEC3000@HK2PR06MB0545.apcprd06.prod.outlook.com>
References: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1486479757-32128-3-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <14921696.qIuO4easis@avalon>
In-Reply-To: <14921696.qIuO4easis@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review comments.

>=20
> On Tuesday 07 Feb 2017 15:02:32 Ramesh Shanmugasundaram wrote:
> > Add device tree binding documentation for MAX2175 Rf to bits tuner
> > device.
> >
> > Signed-off-by: Ramesh Shanmugasundaram
> > <ramesh.shanmugasundaram@bp.renesas.com> ---
> >  .../devicetree/bindings/media/i2c/max2175.txt      | 61
> +++++++++++++++++++
> >  .../devicetree/bindings/property-units.txt         |  1 +
> >  2 files changed, 62 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/media/i2c/max2175.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/i2c/max2175.txt
> > b/Documentation/devicetree/bindings/media/i2c/max2175.txt new file
> > mode
> > 100644
> > index 0000000..f591ab4
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/max2175.txt
> > @@ -0,0 +1,61 @@
> > +Maxim Integrated MAX2175 RF to Bits tuner
> > +-----------------------------------------
> > +
> > +The MAX2175 IC is an advanced analog/digital hybrid-radio receiver
> > +with RF to Bits(r) front-end designed for software-defined radio
> solutions.
> > +
> > +Required properties:
> > +--------------------
> > +- compatible: "maxim,max2175" for MAX2175 RF-to-bits tuner.
> > +- clocks: phandle to the fixed xtal clock.
> > +- clock-names: name of the fixed xtal clock.
>=20
> I would mention that the name has to be "xtal". Maybe something like
>=20
> - clock-names: name of the fixed xtal clock, shall be "xtal".

Agreed.

>=20
> > +- port: child port node of a tuner that defines the local and remote
> > +  endpoints. The remote endpoint is assumed to be an SDR device
> > +  that is capable of receiving the digital samples from the tuner.
>=20
> You should refer to the OF graphs bindings here. How about the following
> to document the port node ?
>=20
> - port: child port node corresponding to the I2S output, in accordance
> with the video interface bindings defined in
> Documentation/devicetree/bindings/media/video-interfaces.txt. The port
> node must contain at least one endpoint.

Agreed.

>=20
> > +Optional properties:
> > +--------------------
> > +- maxim,slave	      : phandle to the master tuner if it is a slave.
> This
> > +			is used to define two tuners in diversity mode
> > +			(1 master, 1 slave). By default each tuner is an
> > +			individual master.
>=20
> It seems weird to me to name a property "slave" when it points to the
> master tuner. Shouldn't it be named "maxim,master" ?

Agreed.

>=20
> > +- maxim,refout-load-pF: load capacitance value (in pF) on reference
> > +			output drive level. The possible load values are
> > +			 0 (default - refout disabled)
> > +			10
> > +			20
> > +			30
> > +			40
> > +			60
> > +			70
> > +- maxim,am-hiz	      : empty property indicates AM Hi-Z filter path
> is
> > +			selected for AM antenna input. By default this
> > +			filter path is not used.
>=20
> Isn't this something that should be selected at runtime through a control
> ? Or does the hardware design dictate whether the filter has to be used o=
r
> must not be used ?

This is dictated by the h/w design and not selectable at run-time.=20
I will update these changes in the next patchset.

Thanks,
Ramesh
