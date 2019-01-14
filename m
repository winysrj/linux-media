Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A934C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 09:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F1F220656
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 09:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="vSOX/8rQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfANJrz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:47:55 -0500
Received: from mail-eopbgr770051.outbound.protection.outlook.com ([40.107.77.51]:26572
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726306AbfANJry (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 04:47:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rP7xA5NMqRjMfp4LF8ScFD4hQyaRzqra5X7dErhA2mw=;
 b=vSOX/8rQdVl8MHJ9n/sYzFMc4zTZCSYNHZdNHPi3EykQ0iPI3FK4NNSuAw1kgOnt3vFC7Gu0mIauHedlOBTm5I16+/tVC9OwYoBseVbf4aut74/OZsTeuGDbt0Jryd+N8USxGbY7r9KB/cPThbTVNYal2gJ1YuCET6dr8tOfsig=
Received: from CY4PR02MB2709.namprd02.prod.outlook.com (10.175.59.19) by
 CY4PR02MB2200.namprd02.prod.outlook.com (10.169.180.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.14; Mon, 14 Jan 2019 09:47:48 +0000
Received: from CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::208e:498e:e558:12]) by CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::208e:498e:e558:12%3]) with mapi id 15.20.1516.019; Mon, 14 Jan 2019
 09:47:41 +0000
From:   Vishal Sagar <vsagar@xilinx.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vishal Sagar <vishal.sagar@xilinx.com>
CC:     Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Dinesh Kumar <dineshk@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
Thread-Topic: [PATCH 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
Thread-Index: AQHUp1LB9yVBRVhU3kSv/sTypyy0J6WqXxWg
Date:   Mon, 14 Jan 2019 09:47:41 +0000
Message-ID: <CY4PR02MB2709C346C4BEF853C48C32DCA7800@CY4PR02MB2709.namprd02.prod.outlook.com>
References: <1527620084-94864-1-git-send-email-vishal.sagar@xilinx.com>
 <1527620084-94864-2-git-send-email-vishal.sagar@xilinx.com>
 <20190108130457.syjuq7u7vep3km3h@paasikivi.fi.intel.com>
In-Reply-To: <20190108130457.syjuq7u7vep3km3h@paasikivi.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vsagar@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR02MB2200;6:/uHEqzJr6Su7Ml5R1FLlQ3PlMXVJGvomO0wsW9PqRz3+8zQHmUvwII8LZp6t+7sxsdw3ABBhPPot930/hs6hZEkybBanlDeVHqByW6d8J0FUu3evxGTrf/qYNWWPvfYNB2cW/zvuEp/db2tzQ3QlEg2wh7OUA56jv7Ko2AJ61aH+3d3jkLeEKTA18LLEAiZA9We7Z+WIzGEgBFfefqVIjDmEle79GL41yROOCqt5SvJzn15Vzxu+uH1sTtdgZKx9hOJWWsEy02Do8kG0Cra5+8IkNb/lnEeXF0s5zRcGh2PmsSGDF59Gq0ueZVRxflJZWDi3V77a6kabEQ/6ZeK/KqW+itm96zp9OKfBNMtfNZtgP8bT9lyfOUgwHYzYx60GdV6/eOf55Bx6Lq0ke1pDqOKJhqSRYQw04reP4ubNMxaA1MIzOE1u/LRp27ZlqgrbR70pVM3OP1T0vJLFDN0ecA==;5:8VULKAmBnjuHb1+bSxlGISYzB4e1IgNzsW1YqMZi6ciPZ3xzOZr0bBP8NRpc/5MXTb1SxAi+TeQhUnIxsPL6tryzX6PSDeu90ymT5Np1/iXGCpy3LKDesZI4l62yJTIFTA7qcSajtithRYPS/ulhqwC05sEnYDRH6U4Pjns516c0t7fyq6h1hHd/Doczd6NutE7HBgeLNESVNEbnw13FVA==;7:VTWXnguPCVlD261ykmEw+QnuT/56ZPbSPk3BQgkdzpbEk8LrLouKnIHx5DiQ4n7DSeFVEzGX0tVrr+6gA0b99qhkf68g8gOg4izMyReVWIvItdlyXW4xwUCr9p4NL81WFSjdMGReHKMwfgWrarZ2yg==
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-forefront-antispam-report: SFV:SKI;SCL:-1;SFV:NSPM;SFS:(10009020)(39860400002)(366004)(136003)(346002)(376002)(396003)(189003)(199004)(13464003)(76176011)(256004)(478600001)(7696005)(2906002)(102836004)(8936002)(6636002)(229853002)(71190400001)(71200400001)(81156014)(5024004)(55016002)(105586002)(5660300001)(8676002)(14444005)(97736004)(53546011)(106356001)(6506007)(305945005)(446003)(74316002)(11346002)(81166006)(33656002)(6116002)(3846002)(7736002)(6436002)(476003)(14454004)(54906003)(86362001)(4326008)(110136005)(316002)(7416002)(6306002)(6246003)(66066001)(68736007)(26005)(486006)(9686003)(186003)(53936002)(99286004)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR02MB2200;H:CY4PR02MB2709.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-office365-filtering-correlation-id: 83915dfa-8c37-4776-6ef6-08d67a0553bb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:CY4PR02MB2200;
x-ms-traffictypediagnostic: CY4PR02MB2200:
x-microsoft-antispam-prvs: <CY4PR02MB22009DAA72918D1D4DC29DEAA7800@CY4PR02MB2200.namprd02.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GttNiF+pSl91IBY2eY600hNHno63EPCSuzr/X4wSkmJVWtzI7qYm0MrJ1cXqmfu8NlLtzKnYMtF82bq0NIrzPdIqmIerr2vBJjEc9vnO3lHasqLastd4o88EczEbHluh9DL4tuI41/OcM1z39MaqgMf39WtSUb95qgl8botVZjMWNBli+XoI5nwKIKNxlDJIAW6sx6XZLgR31szXgxYKxJyeaAX6FoPEFZosiUHtWwKkaBMmWIE18T7b+QucK7O0Tz2WBN4rar7if1XfD1Tav/xjvOUPy76pakoJN9OsMjkDe9fjNNmTGByy7/mfH/fXE4JaD997pKZBSlwjyqoIjlRu0YlRbMqu/jZz10Ow+U4/TN9lrzNfjHJoqovaqxcKOeHvzYfjIDt07sm3SZrBj097ywb0A/cjSfziLYqkB8g=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83915dfa-8c37-4776-6ef6-08d67a0553bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:47:41.5529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB2200
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thanks for reviewing this.=20

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Tuesday, January 08, 2019 6:35 PM
> To: Vishal Sagar <vishal.sagar@xilinx.com>
> Cc: Hyun Kwon <hyunk@xilinx.com>; laurent.pinchart@ideasonboard.com;
> Michal Simek <michals@xilinx.com>; linux-media@vger.kernel.org;
> devicetree@vger.kernel.org; hans.verkuil@cisco.com; mchehab@kernel.org;
> robh+dt@kernel.org; mark.rutland@arm.com; Dinesh Kumar
> <dineshk@xilinx.com>; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] media: dt-bindings: media: xilinx: Add Xilinx MI=
PI CSI-2
> Rx Subsystem
>=20
> EXTERNAL EMAIL
>=20
> Hi Vishal,
>=20
> The patchset hard escaped me somehow earlier and your reply to Rob made m=
e
> notice it again. Thanks. :-)
>=20
> On Wed, May 30, 2018 at 12:24:43AM +0530, Vishal Sagar wrote:
> > Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.
> >
> > The Xilinx MIPI CSI-2 Rx Subsystem consists of a DPHY, CSI-2 Rx, an
> > optional I2C controller and an optional Video Format Bridge (VFB). The
> > active lanes can be configured at run time if enabled in the IP. The
> > DPHY register interface may also be enabled.
> >
> > Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> > ---
> >  .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 117
> +++++++++++++++++++++
> >  1 file changed, 117 insertions(+)
> >  create mode 100644
> Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rx=
ss.txt
> b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> > new file mode 100644
> > index 0000000..31ed721
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> > @@ -0,0 +1,117 @@
> > +
>=20
> Extra newline.
>=20

Will remove it in next version.=20

> > +Xilinx MIPI CSI2 Receiver Subsystem Device Tree Bindings
> > +--------------------------------------------------------
> > +
> > +The Xilinx MIPI CSI2 Receiver Subsystem is used to capture MIPI CSI2 t=
raffic
> > +from compliant camera sensors and send the output as AXI4 Stream video
> data
> > +for image processing.
> > +
> > +The subsystem consists of a MIPI DPHY in slave mode which captures the
> > +data packets. This is passed along the MIPI CSI2 Rx IP which extracts =
the
> > +packet data. This data is taken in by the Video Format Bridge (VFB),
> > +if selected, and converted into AXI4 Stream video data at selected
> > +pixels per clock as per AXI4-Stream Video IP and System Design UG934.
> > +
> > +For more details, please refer to PG232 MIPI CSI-2 Receiver Subsystem.
> >
> +https://www.xilinx.com/support/documentation/ip_documentation/mipi_csi
> 2_rx_subsystem/v3_0/pg232-mipi-csi2-rx.pdf
> > +
> > +Required properties:
> > +
> > +- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-2.0" or
> > +  "xlnx,mipi-csi2-rx-subsystem-3.0"
> > +
> > +- reg: Physical base address and length of the registers set for the d=
evice.
> > +
> > +- interrupt-parent: specifies the phandle to the parent interrupt cont=
roller
> > +
> > +- interrupts: Property with a value describing the interrupt number.
> > +
> > +- xlnx,max-lanes: Maximum active lanes in the design.
> > +
> > +- xlnx,vc: Virtual Channel, specifies virtual channel number to be fil=
tered.
> > +  If this is 4 then all virtual channels are allowed.
>=20
> This seems like something a driver should configure, based on the
> configuration of the connected device.
>=20

The filtering of the Virtual channels is property of the hardware IP and is=
 fixed in design.=20
This is not software controlled.

> > +
> > +- xlnx,csi-pxl-format: This denotes the CSI Data type selected in hw d=
esign.
> > +  Packets other than this data type (except for RAW8 and User defined =
data
> > +  types) will be filtered out. Possible values are RAW6, RAW7, RAW8, R=
AW10,
> > +  RAW12, RAW14, RGB444, RGB555, RGB565, RGB666, RGB888 and
> YUV4228bit.
>=20
> This should be configured at runtime instead through V4L2 sub-device
> interface; it's not a property of the hardware.
>

This too is a property of the hardware IP and is fixed to one data type dur=
ing design to reduce gate count.
So for e.g. if RGB888 is selected during design, then the hardware will onl=
y pass across RGB888 packet data to output.
(RAW8 packets are also allowed to pass through for all data types selected)
This is used in the driver to determine the media bus format of the connect=
ed pads.

> > +
> > +- xlnx,axis-tdata-width: AXI Stream width, This denotes the AXI Stream=
 width.
> > +  It depends on Data type chosen, Video Format Bridge enabled/disabled=
 and
> > +  pixels per clock. If VFB is disabled then its value is either 0x20 (=
32 bit)
> > +  or 0x40(64 bit) width.
> > +
> > +- xlnx,video-format, xlnx,video-width: Video format and width, as defi=
ned in
> > +  video.txt.
>=20
> Ditto.
>=20
Again these are fixed values and can't be changed at run time.=20
These are used to determine the media bus format.

> > +
> > +- port: Video port, using the DT bindings defined in ../video-interfac=
es.txt.
> > +  The CSI 2 Rx Subsystem has a two ports, one input port for connectin=
g to
> > +  camera sensor and other is output port.
> > +
> > +- data-lanes: The number of data lanes through which CSI2 Rx Subsystem=
 is
> > +  connected to the camera sensor as per video-interfaces.txt
>=20
> This is somewhat different from the documentation in video-interfaces.txt=
.
> Could you align the two? I don't think there's a need to document standar=
d
> properties in device binding files elaborately; rather just the hardware
> specific bits.
>=20

Agree. In this current IP there is no way to re-order the lanes which are s=
et at design time.
So physical and logical lanes are at same index. This could only be used to=
 determine how many lanes are allowed to be programmed.
For e.g. if design has set the number of lanes as 4 and xlnx,en-active-lane=
s is present, then the number of lanes=20
can be set from 1 to 4.

> > +
> > +Optional properties:
> > +
> > +- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
> > +  Configuration Register.
> > +
> > +- xlnx,dphy-present: This is equivalent to whether DPHY register inter=
face is
> > +  enabled or not.
> > +
> > +- xlnx,iic-present: This shows whether subsystem's IIC is present or n=
ot. This
> > +  affects the base address of the DPHY.
> > +
> > +- xlnx,vfb: Video Format Bridge, Denotes if Video Format Bridge is sel=
ected
> > +  so that output is as per AXI stream documented in UG934.
> > +
> > +- xlnx,ppc: Pixels per clock, Number of pixels to be transferred per p=
ixel
> > +  clock. This is valid only if xlnx,vfb property is present.
> > +
> > +Example:
> > +
> > +       csiss_1: csiss@a0020000 {
> > +               compatible =3D "xlnx,mipi-csi2-rx-subsystem-3.0";
> > +               reg =3D <0x0 0xa0020000 0x0 0x20000>;
> > +               interrupt-parent =3D <&gic>;
> > +               interrupts =3D <0 95 4>;
> > +
> > +               xlnx,max-lanes =3D <0x4>;
> > +               xlnx,en-active-lanes;
> > +               xlnx,dphy-present;
> > +               xlnx,iic-present;
> > +               xlnx,vc =3D <0x4>;
> > +               xlnx,csi-pxl-format =3D "RAW8";
> > +               xlnx,vfb;
> > +               xlnx,ppc =3D <0x4>;
> > +               xlnx,axis-tdata-width =3D <0x20>;
> > +
> > +               ports {
> > +                       #address-cells =3D <1>;
> > +                       #size-cells =3D <0>;
> > +
> > +                       port@0 {
> > +                               reg =3D <0>;
> > +
> > +                               xlnx,video-format =3D <XVIP_VF_YUV_422>=
;
> > +                               xlnx,video-width =3D <8>;
> > +                               csiss_out: endpoint {
> > +                                       remote-endpoint =3D <&vcap_csis=
s_in>;
> > +                               };
> > +                       };
> > +                       port@1 {
> > +                               reg =3D <1>;
> > +
> > +                               xlnx,video-format =3D <XVIP_VF_YUV_422>=
;
> > +                               xlnx,video-width =3D <8>;
> > +
> > +                               csiss_in: endpoint {
> > +                                       data-lanes =3D <1 2 3 4>;
> > +                                       /* MIPI CSI2 Camera handle */
> > +                                       remote-endpoint =3D <&vs2016_ou=
t>;
> > +                               };
> > +
> > +                       };
> > +
> > +               };
> > +       };
> > --
> > 2.7.4
> >
> > This email and any attachments are intended for the sole use of the nam=
ed
> recipient(s) and contain(s) confidential information that may be propriet=
ary,
> privileged or copyrighted under applicable law. If you are not the intend=
ed
> recipient, do not read, copy, or forward this email message or any attach=
ments.
> Delete this email message and any attachments immediately.
>=20
> Could you drop this from v2?
>=20

Ok.=20

Regards
Vishal Sagar

> --
> Regards,
>=20
> Sakari Ailus
> sakari.ailus@linux.intel.com
