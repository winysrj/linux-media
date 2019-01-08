Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B81C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 11:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27891206B7
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 11:42:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="C/tbXVzv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbfAHLmF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 06:42:05 -0500
Received: from mail-eopbgr750084.outbound.protection.outlook.com ([40.107.75.84]:7392
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727107AbfAHLmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 06:42:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxXFisNTWvoE/8Gg5TDDsEH94IdhINaKy+05vZxybtU=;
 b=C/tbXVzv48oBvhPAl5tbAb9jtqFNKBqQseSs8LSG5jCusCvNr89DHHu7BWyX07QW59nCJZtqB4pUGL/+Sj5VvDM57wBoibwRvrZW2W8amWuk5rL7sZoe0vf70RJo6UQf5bE1+SPT8xsuR/V5ysrmGq657PZxZWfy30xkV4gnw/E=
Received: from CY4PR02MB2709.namprd02.prod.outlook.com (10.175.59.19) by
 CY4PR02MB2583.namprd02.prod.outlook.com (10.173.41.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.9; Tue, 8 Jan 2019 11:42:00 +0000
Received: from CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::208e:498e:e558:12]) by CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::208e:498e:e558:12%3]) with mapi id 15.20.1495.011; Tue, 8 Jan 2019
 11:41:58 +0000
From:   Vishal Sagar <vsagar@xilinx.com>
To:     Rob Herring <robh@kernel.org>,
        Vishal Sagar <vishal.sagar@xilinx.com>
CC:     Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Dinesh Kumar <dineshk@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sandip Kothari <sandipk@xilinx.com>
Subject: RE: [PATCH 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
Thread-Topic: [PATCH 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
Thread-Index: AQHT937v9yVBRVhU3kSv/sTypyy0J6RdIekAgUfxthA=
Date:   Tue, 8 Jan 2019 11:41:58 +0000
Message-ID: <CY4PR02MB27094F7483A1628CB269AB3CA78A0@CY4PR02MB2709.namprd02.prod.outlook.com>
References: <1527620084-94864-1-git-send-email-vishal.sagar@xilinx.com>
 <1527620084-94864-2-git-send-email-vishal.sagar@xilinx.com>
 <20180612200338.GA31620@rob-hp-laptop>
In-Reply-To: <20180612200338.GA31620@rob-hp-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vsagar@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR02MB2583;6:AgPXVUAlOxhh65pBLQCs8qcj3nzIEkEuSwdSAM5s0SNCBxg5LTJrrh7Tk48tj2HMtkgDAPUPWQDkj9QuycEo5xQdLpCZufo+n7xi+uXx7fazH3OyeN/Nq0RKmKX+mblNH9S9U8nk4O/u4nnYDKbdMWzo/IPEOQ4MP4kKhy1p0gPgyrnxJIE76dEu3lcGwyt3tVCkYL3UskdgQ7GiHaICP9mchVBIhHXVeUL0ZWjWJlfOjd67uacWpVMy48DiU6/PBt102Nf0OML6kwHTzRb7BVAoT50WOL8QxnBcI/yt2DfA2OV7diBEwNgTX5hN5NJxQFX8X57Ujzzm6CsVXZMCGnQPiRGCiTAhu1QVaTkMvo99eg7bxTXXAUrLO7n4MocQekhYYsOM/Y7sqnuL+rGoZCM0bIu016P23q5uGJqj9YqIprDE03B+t8Rwvv0fQ61xKaMZvlJwd4t40eI3mUNx/w==;5:nrXy7eoAEWdyv5CRj2j/PvddjIHq/0+HINvgfU7bU1ABI44FMeUyRJ6bCRPDmoZmP2XIfmKiaXKeCFEfb4mndDukh34TM+MFLq13CF2GPoQ8GLT2s11Q180ECcMV6JnMUDFrf8pWf+lIuwpPlKbYGmUG5dAoCT8k5ZA+5BspXvcFlKUGdE0M6Ha1krPYnKT6yN1oICtImcF9FXW7+z9SyA==;7:XjoqsyvXgLNZwenpMiUb8yp7h9bQrLBps949FdYxygaorQLta3Pv/9LebMlminT2sAewbwBMXa+lcDSRWP3/56zu2nv61NX22Ee8FIerujS4JTOPi3N4A5h+DJ0kVcinVClCureUNeSLXqlNo7xw4g==
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-forefront-antispam-report: SFV:SKI;SCL:-1;SFV:NSPM;SFS:(10009020)(136003)(376002)(366004)(346002)(39860400002)(396003)(189003)(199004)(13464003)(51914003)(107886003)(966005)(25786009)(229853002)(478600001)(74316002)(14444005)(5024004)(14454004)(316002)(256004)(6306002)(9686003)(33656002)(81166006)(26005)(476003)(4326008)(7736002)(55016002)(53936002)(6436002)(305945005)(486006)(8936002)(110136005)(54906003)(6246003)(99286004)(106356001)(6636002)(8676002)(3846002)(6116002)(7416002)(105586002)(71200400001)(76176011)(53546011)(6506007)(66066001)(71190400001)(81156014)(97736004)(11346002)(86362001)(2906002)(446003)(5660300001)(7696005)(68736007)(186003)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR02MB2583;H:CY4PR02MB2709.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-office365-filtering-correlation-id: 06736ca7-6227-44f8-107c-08d6755e4c0b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:CY4PR02MB2583;
x-ms-traffictypediagnostic: CY4PR02MB2583:
x-microsoft-antispam-prvs: <CY4PR02MB2583AC9F3999534F3F377904A78A0@CY4PR02MB2583.namprd02.prod.outlook.com>
x-forefront-prvs: 0911D5CE78
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r00ZeARHr8ZXn5s8Jf1IdfFEynwCIvH3KSKBO3/MUV3GE0zETad9NojuynTXQAYqf+9da9yhGvddk2sy5SWuDOXB+1x2y5oY9whFTdH558NvDPDZNcI+4DOwkIFS4QP/hFhL1VmV3qxe9jixvlDDl/g9xWO+3NH1qROA8KnMAxQ/yHNS6cyaep2j3WJL3mr45Ruv2jnlBEmyGlsOjQxVAiXf00YB+Y8/Eaqxas9IbFHTuvbl+im3HnPU8xxGSaMG/hXggD55os5Jx+wSiU01hdtgwL36t5gnjVSNnwbgauzrKbQ5PpGuJBp/N3Pn5Ev/
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06736ca7-6227-44f8-107c-08d6755e4c0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2019 11:41:58.0611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB2583
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rob,

Thanks for the review.

> -----Original Message-----
> From: Rob Herring [mailto:robh@kernel.org]
> Sent: Wednesday, June 13, 2018 1:34 AM
> To: Vishal Sagar <vishal.sagar@xilinx.com>
> Cc: Hyun Kwon <hyunk@xilinx.com>; laurent.pinchart@ideasonboard.com;
> michal.simek@xilinx.com; linux-media@vger.kernel.org;
> devicetree@vger.kernel.org; mark.rutland@arm.com; mchehab@kernel.org;
> linux-kernel@vger.kernel.org; hans.verkuil@cisco.com;
> sakari.ailus@linux.intel.com; Dinesh Kumar <dineshk@xilinx.com>; linux-ar=
m-
> kernel@lists.infradead.org
> Subject: Re: [PATCH 1/2] media: dt-bindings: media: xilinx: Add Xilinx MI=
PI CSI-2
> Rx Subsystem
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
>=20
> There's already a property defined in video-interfaces.txt to limit
> lanes.
>=20

Ok I will use the standard data-lanes and remove this.

> > +
> > +- xlnx,vc: Virtual Channel, specifies virtual channel number to be fil=
tered.
> > +  If this is 4 then all virtual channels are allowed.
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
> This should be standard property.

I don't see a standard property for the CSI pixel formats.
Do you mean media bus formats?

>=20
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
> This doc needs to define what are valid values.
>=20

Ok. The valid values list will be added in next revision.

> Why do you need this on both ports? Can there be a conversion in this
> block? At least for the MIPI CSI interface part, this should be a common
> property. Not sure offhand if we have defined one. We have for parallel
> interfaces.
>=20
> And 'width' doesn't seem like the right term for what this is defined to
> be.
>=20

This is put on both ports to keep it consistent with other drivers.
The video-format values are specific to Xilinx.=20
The width here means bit per component.

> > +
> > +- port: Video port, using the DT bindings defined in ../video-interfac=
es.txt.
>=20
> port is not a property. It goes in its own section. And port properties
> should be under it.

I will update this in next version.

>=20
> > +  The CSI 2 Rx Subsystem has a two ports, one input port for connectin=
g to
> > +  camera sensor and other is output port.
>=20
> Need be specific port #0 is ?? and port #1 is ??.
>=20

Right. I will describe them in the next version correctly.
0 will be sink pad and 1 will source pad.

> > +
> > +- data-lanes: The number of data lanes through which CSI2 Rx Subsystem=
 is
> > +  connected to the camera sensor as per video-interfaces.txt
>=20
> Why do you need both this and max-lanes?

I didn't know more and added both. I will keep this.

>=20
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
>=20
> Perhaps you should break up reg into ranges for each submodule (or make
> the DPHY a separate node and use the phy binding.
>=20

Ok I will break the range into 2 parts and access DPHY accordingly.

Regards
Vishal Sagar

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
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
