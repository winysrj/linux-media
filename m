Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC98DC282C7
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 08:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B48FE2087F
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 08:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="FUD7iUP8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbfAaIHV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 03:07:21 -0500
Received: from mail-eopbgr680085.outbound.protection.outlook.com ([40.107.68.85]:19824
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725829AbfAaIHU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 03:07:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vX2ECGMgJ6VcVqE8z/P6pnQ1gJLgiu1/xGnH8iU1ZGg=;
 b=FUD7iUP8mAjbNnNU/3du7gdjiiLpq0aK3fDdzVHrAfggd0rnR0d2bR4Srv2I1jddqGR/R3XkURslciveYkGkqK3/9CRjUeax6ECTiCpMLK8lB6zkcFW011NIMvpYNPA2NlKL9uFi3XTLxu7SYbXcACA9NuNuMJ4OChDWLAVxDmc=
Received: from CY4PR02MB2709.namprd02.prod.outlook.com (10.175.59.19) by
 CY4PR02MB3286.namprd02.prod.outlook.com (10.165.88.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Thu, 31 Jan 2019 08:07:13 +0000
Received: from CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::c41a:f0ef:3b4e:6903]) by CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::c41a:f0ef:3b4e:6903%3]) with mapi id 15.20.1558.023; Thu, 31 Jan 2019
 08:07:13 +0000
From:   Vishal Sagar <vsagar@xilinx.com>
To:     Rob Herring <robh@kernel.org>,
        Vishal Sagar <vishal.sagar@xilinx.com>
CC:     Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>
Subject: RE: [PATCH v2 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
Thread-Topic: [PATCH v2 1/2] media: dt-bindings: media: xilinx: Add Xilinx
 MIPI CSI-2 Rx Subsystem
Thread-Index: AQHUtNbLyB/3OqWzKESYx7XdyxEw86XIPb0AgAComZA=
Date:   Thu, 31 Jan 2019 08:07:13 +0000
Message-ID: <CY4PR02MB27091A04C6BA664C1C48D0D8A7910@CY4PR02MB2709.namprd02.prod.outlook.com>
References: <1548438777-11203-1-git-send-email-vishal.sagar@xilinx.com>
 <1548438777-11203-2-git-send-email-vishal.sagar@xilinx.com>
 <20190130194052.GA9543@bogus>
In-Reply-To: <20190130194052.GA9543@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vsagar@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR02MB3286;6:ixACk5kg16mrGYTMdfsO6VYpCKm6RkKEJ4BMbvfxEpATl5PqYfM5S6f4S4hygyDjqL4zkpuiiDuDjwGWKXvY3t2PklwI9q9MJ9Jwc7r2jcuTORUEswK5buRNO3xMfFXsC8JHhbYQgDtPT5Ez5e6HyFL7BWcFbOq7SENAq86XLnfxOYqWU0T/OHE3uzQjBn11ZayCuNsy4xIwnY9dydJshoNrsq6AE613wzf/9NImuheoJ+mNbRa2JvClItKsm1fFvgeBy5ix71ERLr9NLVEe4RpfTSJyNNfgJWeNu07lBxB3reGHIqwtjmYxruxPJYOws6llXOP5Dc/49lcUfVXBxyBatzPDT2ZUJgYk8Ifz72QFI+KZzGBpIBEBJ6gkjxKxTBJP7qH9AhsjlBXYtsNxYeOyfj4VrBj4RxTbf59pFOi9AoSsvuIIYNZmusvpy10lv3uow6ZFVJfQOGLQ3jPS8w==;5:4cxjxTaq6fYhXNbpCv/+KFMy6NJvGpcAsh75tooa5S5J5AqHPzopMoOXW6C8Ca0E821Q2b/UMtCcf0Hm6xvKDMjj5TuZWSiZSac/pqBP8YqFbusQzMhQ7L3Bzgmxmezo3WI9H4ZmKainbKiNIeUZLmopph0WMGAV3InKHTMRJsbr0evr6A48OkKNy/1qkILVxLkBOqN3qJ+vCiZ2Kkc1OQ==;7:bz/ahc7CzQp5qzCuH9JCcIEljjpewQXxWSp1812GH1lgw7b4nVcCw7fNthgdQfzNif6mJfw5QAvxXBHodG2RDU/cx9ZvbfWzI5wDEWV3dHaa/5I3nL91hMhUeLrDfHx2TChgLBATIemf5gEppCyklQ==
x-ms-office365-filtering-correlation-id: 66c4b094-c6d6-4932-1601-08d687531bcd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:CY4PR02MB3286;
x-ms-traffictypediagnostic: CY4PR02MB3286:
x-microsoft-antispam-prvs: <CY4PR02MB3286EF587DC44415988CE16CA7910@CY4PR02MB3286.namprd02.prod.outlook.com>
x-forefront-prvs: 09347618C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(376002)(346002)(39860400002)(199004)(13464003)(189003)(26005)(486006)(25786009)(186003)(478600001)(99286004)(256004)(102836004)(105586002)(68736007)(55016002)(6506007)(14454004)(3846002)(71200400001)(71190400001)(6246003)(6116002)(53546011)(33656002)(53936002)(4326008)(107886003)(106356001)(9686003)(2906002)(14444005)(6436002)(110136005)(7736002)(8676002)(76176011)(81166006)(305945005)(81156014)(74316002)(229853002)(7696005)(476003)(446003)(86362001)(316002)(7416002)(97736004)(11346002)(66066001)(54906003)(6636002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR02MB3286;H:CY4PR02MB2709.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ESZrLkVcORyzE9+S5ZnJ1i7LWfrXLPQpxfrrsZlsNyKxzudcHz1Fxffc3qscC3yUbvLbvRq5X+jITGnUcubobph2qoYYMkhdboXBLUCVHSYXB2MY9tmQaRBypfeCAgqAOQcN4tqWbttNg7yjfpocIR5gVKxMr9+dyVO8X53geZYbXXHMMqe6noMSRMkjaDH5xe+LGnzkH+K9zHQphwwSBLlkskwVuSwkVbyxjfwgjRb8b53r6pedmCLiX27H4SgyQl2u/pMXy0KEYVS9zyUQ6a2R+26fGYKZfGsaFta2hUKq+hUCodk2XyLMpfeKlyzdON0B5bab8tLwCoEyI8cLki6us+emEphYxQeoHL3CJjEVCL2KA/u9rWnsd1CcKSBWPBhwF3ZMKwRwXpxd+bMOzbpmmGW8IxyxqHFjopMdZqY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c4b094-c6d6-4932-1601-08d687531bcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2019 08:07:13.6703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB3286
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rob,

Thanks for reviewing.

> -----Original Message-----
> From: Rob Herring [mailto:robh@kernel.org]
> Sent: Thursday, January 31, 2019 1:11 AM
> To: Vishal Sagar <vishal.sagar@xilinx.com>
> Cc: Hyun Kwon <hyunk@xilinx.com>; laurent.pinchart@ideasonboard.com;
> mchehab@kernel.org; mark.rutland@arm.com; Michal Simek
> <michals@xilinx.com>; linux-media@vger.kernel.org;
> devicetree@vger.kernel.org; sakari.ailus@linux.intel.com;
> hans.verkuil@cisco.com; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; Dinesh Kumar <dineshk@xilinx.com>; Sandip Kothari
> <sandipk@xilinx.com>
> Subject: Re: [PATCH v2 1/2] media: dt-bindings: media: xilinx: Add Xilinx=
 MIPI
> CSI-2 Rx Subsystem
>=20
> EXTERNAL EMAIL
>=20
> On Fri, Jan 25, 2019 at 11:22:56PM +0530, Vishal Sagar wrote:
> > Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.
> >
> > The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
> > DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.
> >
> > Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> > ---
> > v2
> > - updated the compatible string to latest version supported
> > - removed DPHY related parameters
> > - added CSI v2.0 related property (including VCX for supporting upto 16
> >   virtual channels).
> > - modified csi-pxl-format from string to unsigned int type where the va=
lue
> >   is as per the CSI specification
> > - Defined port 0 and port 1 as sink and source ports.
> > - Removed max-lanes property as suggested by Rob and Sakari
> >
> >  .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 105
> +++++++++++++++++++++
> >  1 file changed, 105 insertions(+)
> >  create mode 100644
> Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rx=
ss.txt
> b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> > new file mode 100644
> > index 0000000..98781cf
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> > @@ -0,0 +1,105 @@
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
> > +packet data. The Video Format Bridge (VFB) converts this data to AXI4
> Stream
> > +video data.
> > +
> > +For more details, please refer to PG232 Xilinx MIPI CSI-2 Receiver Sub=
system.
> > +
> > +Required properties:
> > +--------------------
> > +- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-4.0".
> > +- reg: Physical base address and length of the registers set for the d=
evice.
> > +- interrupt-parent: specifies the phandle to the parent interrupt cont=
roller
>=20
> Don't document this. It is implied.

Ok. I will remove this in next revision.

>=20
> > +- interrupts: Property with a value describing the interrupt number.
> > +- clocks: List of phandles to AXI Lite, Video and 200 MHz DPHY clocks.
> > +- clock-names: Must contain "lite_aclk", "video_aclk" and "dphy_clk_20=
0M"
> in
> > +  the same order as clocks listed in clocks property.
> > +- xlnx,csi-pxl-format: This denotes the CSI Data type selected in hw d=
esign.
> > +  Packets other than this data type (except for RAW8 and User defined =
data
> > +  types) will be filtered out. Possible values are as below -
> > +  0x1E - YUV4228B
> > +  0x1F - YUV42210B
> > +  0x20 - RGB444
> > +  0x21 - RGB555
> > +  0x22 - RGB565
> > +  0x23 - RGB666
> > +  0x24 - RGB888
> > +  0x28 - RAW6
> > +  0x29 - RAW7
> > +  0x2A - RAW8
> > +  0x2B - RAW10
> > +  0x2C - RAW12
> > +  0x2D - RAW14
> > +  0x2E - RAW16
> > +  0x2F - RAW20
> > +- xlnx,vfb: This is present when Video Format Bridge is enabled.
>=20
> boolean?
>=20

Yes this is a Boolean.=20

> > +
> > +Optional properties:
> > +--------------------
> > +- xlnx,en-csi-v2-0: Present if CSI v2 is enabled in IP configuration.
> > +- xlnx,en-vcx: When present, there are maximum 16 virtual channels, el=
se
> > +  only 4. This is present only if xlnx,en-csi-v2-0 is present.
> > +- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
> > +  Configuration Register.
> > +- xlnx,cfa-pattern: This goes in the sink port to indicate bayer patte=
rn.
> > +  Valid values are "bggr", "rggb", "gbrg" and "grbg".
>=20
> This should go in the endpoint with the other properties. I'd also move
> it down below 'Ports' to be clear it goes in a different node.
>=20

Agree. I will do this in next revision.

> > +
> > +Ports
> > +-----
> > +The device node shall contain two 'port' child nodes as defined in
> > +Documentation/devicetree/bindings/media/video-interfaces.txt.
> > +
> > +The port@0 is sink port and shall connect to CSI2 source like camera.
> > +It must have the data-lanes property. It may have the xlnx,cfa-pattern
> > +property to indicate bayer pattern of source.
> > +
> > +The port@1 is source port could be connected to any video processing I=
P
> > +which can work with AXI4 Stream data.
> > +
> > +Both ports must have remote-endpoints.
>=20
> No need to state that. That's implicit for the graph to work...

Ok=20

Regards
Vishal Sagar

> > +
> > +Example:
> > +
> > +     csiss_1: csiss@a0020000 {
> > +             compatible =3D "xlnx,mipi-csi2-rx-subsystem-4.0";
> > +             reg =3D <0x0 0xa0020000 0x0 0x10000>;
> > +             interrupt-parent =3D <&gic>;
> > +             interrupts =3D <0 95 4>;
> > +             xlnx,csi-pxl-format =3D <0x2a>;
> > +             xlnx,vfb;
> > +             xlnx,en-active-lanes;
> > +             xlnx,en-csi-v2-0;
> > +             xlnx,en-vcx;
> > +             clock-names =3D "lite_aclk", "dphy_clk_200M", "video_aclk=
";
> > +             clocks =3D <&misc_clk_0>, <&misc_clk_1>, <&misc_clk_2>;
> > +
> > +             ports {
> > +                     #address-cells =3D <1>;
> > +                     #size-cells =3D <0>;
> > +
> > +                     port@0 {
> > +                             /* Sink port */
> > +                             reg =3D <0>;
> > +                             xlnx,cfa-pattern =3D "bggr"
> > +                             csiss_in: endpoint {
> > +                                     data-lanes =3D <1 2 3 4>;
> > +                                     /* MIPI CSI2 Camera handle */
> > +                                     remote-endpoint =3D <&camera_out>=
;
> > +                             };
> > +                     };
> > +                     port@1 {
> > +                             /* Source port */
> > +                             reg =3D <1>;
> > +                             csiss_out: endpoint {
> > +                                     remote-endpoint =3D <&vproc_in>;
> > +                             };
> > +                     };
> > +             };
> > +     };
> > --
> > 2.7.4
> >
