Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A542EC4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 17:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A282070D
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 17:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="t8UvtSF2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfCMRdz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:33:55 -0400
Received: from mail-eopbgr740090.outbound.protection.outlook.com ([40.107.74.90]:40784
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726033AbfCMRdz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 13:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+GWmmDlZPSiiO2pPtydaG046baFOCvezy8fDmjfO5Q=;
 b=t8UvtSF2SoR5VvyL51KQohwEEFsd6fdBvpy3OkHZJQdVtcq7KtAfUnw4Tn1/1Z2Q4BndF0ozPmdOFz0OyxsOc2iPMTf6PB6HnrU8Tjb0gn/+jxHJRT/nkzfhqMQZaoq4uD/Rza0Cs/IyTHx4FtH2IyHez2YyX6i2iK/b/XTLv1g=
Received: from BL0PR07MB4115.namprd07.prod.outlook.com (52.132.10.149) by
 BL0PR07MB3940.namprd07.prod.outlook.com (52.132.9.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.19; Wed, 13 Mar 2019 17:33:39 +0000
Received: from BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::e4fd:8f53:2484:46eb]) by BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::e4fd:8f53:2484:46eb%5]) with mapi id 15.20.1686.021; Wed, 13 Mar 2019
 17:33:38 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     "Eugen.Hristev@microchip.com" <Eugen.Hristev@microchip.com>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>
Subject: RE: [PATCH v2 1/2] media: atmel: atmel-isc: reworked driver and
 formats
Thread-Topic: [PATCH v2 1/2] media: atmel: atmel-isc: reworked driver and
 formats
Thread-Index: AQHU2W3jEjSHs0v2fEmY3j98V2LyQaYJ0K6A
Date:   Wed, 13 Mar 2019 17:33:38 +0000
Message-ID: <BL0PR07MB4115145F4637A1057ED79C84AD4A0@BL0PR07MB4115.namprd07.prod.outlook.com>
References: <1552461639-8708-1-git-send-email-eugen.hristev@microchip.com>
In-Reply-To: <1552461639-8708-1-git-send-email-eugen.hristev@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=KSloat@aampglobal.com; 
x-originating-ip: [100.3.71.115]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26829db3-7812-44fe-14d7-08d6a7da077f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BL0PR07MB3940;
x-ms-traffictypediagnostic: BL0PR07MB3940:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;BL0PR07MB3940;23:WTEVSA8CeUVn9KDZ9h1OT0WmciXHdulmjyfe1j4ya?=
 =?us-ascii?Q?uHnxOFrc4czNsQQIT0+RGi94Mgwi5hfsaz/idA6+XecL1uRzgjDKTqHSrlNV?=
 =?us-ascii?Q?cPMhlPuFtuir4QA7VhQp9qQOS7pHzs6XExc8bCVRdkPZ2azOYT/tGXFSkUVB?=
 =?us-ascii?Q?nTLVV2LwUBNGCLnoOQIvNbYLLjXjfIKWo9eR19W7L56BAWF3di06lWlmLGUn?=
 =?us-ascii?Q?HQiwhtC+/oU7x8kKytznpWknV8n/LhTeQh1Pz8Azek9yQpTAf6ROcUkJUrWi?=
 =?us-ascii?Q?ACgMEitem6y4gf+keSAQbm9LCtFGPXEjLVHXWVSfHRd3Rg9HuEeZhJHoSBrX?=
 =?us-ascii?Q?pW6BDVe/Pd5Nbbu4tIRQ96YmEZxcxTGhbuaKmKZn7x8HTAtAPeBs7O6QbTte?=
 =?us-ascii?Q?Zo36NALFgGBRMWPBhUyQdQru8oD+PHPmm+IJCAsu6M63aMQk0l4FPoQWD37b?=
 =?us-ascii?Q?U6CNhn5JM19AQccsc8EpehO78AoreREFJ6d9MRxwJYsGx0M3EygOOv3DRsk4?=
 =?us-ascii?Q?mxRBqswDKXqJoztTNcIldQ/Nsxbp0AUzzn5nX4URJCBsJ3HklN/s8tkJEp1s?=
 =?us-ascii?Q?D/mfGvbeFw/bnGoPOlwgr/5RNWRT4A8vnR4YRpZGe52Z2htZqGOcVFzhho84?=
 =?us-ascii?Q?qYXbAGz1YtDzyF9CKGkv63syfEcePA56AD/uiYpMg4mfJUOGgkfZ9bZOfRxx?=
 =?us-ascii?Q?auxj7+PJrI2hVcUaoxsMnZzWmeRZqSfU1P0NN6mrOoVCO6z0p0tZwPdzdvQz?=
 =?us-ascii?Q?mEajuOpfkODeXHrtM5trc+1fk+7SLdMKSfVwBL0tMNm43F0yVo3063CodqF3?=
 =?us-ascii?Q?G7dHAlI1dML0vYiUqrP//SlccyTlnvvKXLnFc++8myAwD0pEAVU6ME0FJTbU?=
 =?us-ascii?Q?SdI9wWrReKyOgBjKgbU+lqQ2/UnlUQjqmxDTyhbRFBXABch82gbewfxTRQdb?=
 =?us-ascii?Q?A/ABGIZWpibLfY6cmluuFE9fafZfDNcidyBWIyWUFuzKiOwEnKxoIQMOJ/ig?=
 =?us-ascii?Q?xPnomNgelHfIQPmpFvsy1EiF+xbvSaZg29bFepOdhvqLBhAF+9qK7YCDrwlz?=
 =?us-ascii?Q?8mkFOBGFdTEYXLgTuUduwIqeDK+mhg5CsNgZXAZ7RksTdzFndPXu/2YhRBlq?=
 =?us-ascii?Q?hi61GpLXnX0mQ1T8hqf5MPjJHOEnF3nEv5VOY+YNx2O4Cfc9tJ8nQVT0gNrZ?=
 =?us-ascii?Q?NVMnAX06V303VF9CSwG1WecaWiyb8MhM5N54YG2ATOLbC8OWfyyb1ysqHIe6?=
 =?us-ascii?Q?Y3VhhMU4eb6TkNgOFJSCbABl31dtS4Qaxs/qa0TeM0I6rUQOGtkbUhx6i/H4?=
 =?us-ascii?Q?qZsYZTWNSRSL/qyX+fHoWts94lZ1bxexRaj9t0dC6NtMMf0aAhLms/JVwJkL?=
 =?us-ascii?Q?ERyhck5zx9uANKsOif2v2TO+C392n2MtIZQLH4N3P62F0/r6xbRM9UWsEGTH?=
 =?us-ascii?Q?Ua18K7BsQ=3D=3D?=
x-microsoft-antispam-prvs: <BL0PR07MB39409645D3C813A6966C0D14AD4A0@BL0PR07MB3940.namprd07.prod.outlook.com>
x-forefront-prvs: 09752BC779
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(396003)(346002)(376002)(136003)(199004)(189003)(13464003)(305945005)(26005)(97736004)(6436002)(99286004)(7736002)(229853002)(81166006)(80792005)(2501003)(81156014)(74316002)(8676002)(68736007)(53946003)(53546011)(55016002)(102836004)(256004)(7696005)(76176011)(14444005)(9686003)(71190400001)(71200400001)(66066001)(486006)(446003)(11346002)(8936002)(33656002)(25786009)(186003)(476003)(6116002)(3846002)(106356001)(2906002)(105586002)(6506007)(2201001)(316002)(86362001)(5660300002)(110136005)(30864003)(478600001)(6246003)(72206003)(52536013)(53936002)(14454004)(461764006)(559001)(579004)(569006);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR07MB3940;H:BL0PR07MB4115.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +xs2mjbFgXPcl6YNfMe6ktUsBCvXRPHqyfaq0TtNOmgUgk4VaBj4hEF0wBxqY44r2a5d5O18p6KUGheymcE0r6nsBobJp09xSHgpnaAMxg38WpKuuLySER7YLBmRf9Ud1HPJ0J3LkLyliIPTDhaJe1ovr/4Ce7iYxMAQneQLj4u7/N44SuhaHKo7ib/YYQcZR+ypmFhFmOyI+DHFZ9GLDWyjFiLTOwze1TVk7GkrjnfpRjyXjOqmvi1LL/K+u2A+uO4qGPjCu4T2zNSUn10b/mFlEN/DE8VIjFD+AfZpW6dRjv9Ym/1ojuMuQdu0Ks603c+qiH3QyFGOtXFXD7MiNerI3nYNKiv3LEMOFLT7yCBAfepZySMXYusNbsLxvqCCye/QnILSfpAVIXcL2HpK3+Lk+olBxwnSfob8idcH++0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26829db3-7812-44fe-14d7-08d6a7da077f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2019 17:33:38.6179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e20e3a66-8b9e-46e9-b859-cb654c1ec6ea
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR07MB3940
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: BL0PR07MB4115.namprd07.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-TransportTrafficSubType: 
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 100.3.71.115
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-transporttrafficsubtype: 
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: BL0PR07MB3940.namprd07.prod.outlook.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

> -----Original Message-----
> From: Eugen.Hristev@microchip.com <Eugen.Hristev@microchip.com>
> Sent: Wednesday, March 13, 2019 3:25 AM
> To: hverkuil@xs4all.nl; Nicolas.Ferre@microchip.com; linux-
> media@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; mchehab@kernel.org
> Cc: Ken Sloat <KSloat@aampglobal.com>; Eugen.Hristev@microchip.com
> Subject: [PATCH v2 1/2] media: atmel: atmel-isc: reworked driver and form=
ats
>=20
> From: Eugen Hristev <eugen.hristev@microchip.com>
>=20
> This change is a redesign in the formats and the way the ISC is configure=
d w.r.t.
> sensor format and the output format from the ISC.
> I have changed the splitting between sensor output (which is also ISC inp=
ut) and
> ISC output.
> The sensor format represents the way the sensor is configured, and what I=
SC is
> receiving.
> The format configuration represents the way ISC is interpreting the data =
and
> formatting the output to the subsystem.
> Now it's much easier to figure out what is the ISC configuration for inpu=
t, and
> what is the configuration for output.
> The non-raw format can be obtained directly from sensor or it can be done
> inside the ISC. The controller format list will include a configuration f=
or each
> format.
> The old supported formats are still in place, if we want to dump the sens=
or
> format directly to the output, the try format routine will detect and con=
figure
> the pipeline accordingly.
> This also fixes the previous issues when the raw format was NULL which
> resulted in many crashes for sensors which did not have the expected/test=
ed
> formats.
>=20
> Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
> ---
>=20
> Hello,
>=20
> I have changed the try vs set settings, with having another configuration=
 for try,
> which will be copied to the actual configuration only after set will be c=
alled.
>=20
> This patch keeps the original formats. I added a second patch that fixes =
ARGB
> format w.r.t. byte endianess inside the format.
>=20
> Changes in v2:
>  - now have try_config and also config, all configuration setting will be=
 done
> initially on try_config, and then if everything is OK, in set_fmt, it wil=
l be copied
> to the actual config.
>  - changed macro IS_RAW to apply on mbus code and not isc structure, it's=
 now
> called ISC_IS_FORMAT_RAW and it's called everywhere it's needed.
>  - renamed all functions for configure modules (dma, rlp, pipeline, forma=
ts)
> with 'try' prefix
>=20
> tested with sensors ov7670, ov7740, ov5640
>=20
> v4l2-compliance:
>=20
> v4l2-compliance SHA: 32cf495ff5da24df54936fae3bf0eb91fba77f3a, 32 bits
>=20
> Compliance test for atmel_isc device /atmel_deo0:isc f0008000.isc:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  START STATUS  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D atmel_isc
> f0008000.isc: Brightness: 0 atmel_isc f0008000.isc: Contrast: 256 atmel_i=
sc
> f0008000.isc: Gamma: 2
>=20
> atmeiver Info:
>         Driver name      : atmel_isc
>         Card type        : Atmel Image Sensor Controller
>         Bus info         : platform:atmel_isc f0008000.isc
>         Driver version   : 5.0.0
>         Capabilities     : 0x84200001
>                 Video Capture
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps      : 0x04200001
>                 Video Capture
>                 Streaming
>                 Extended Pix Format
>=20
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
>=20
> Allow for multiple opens:
>         test second /dev/video0 open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
>         test for unlimited opens: OK
>=20
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported) l_isc f0008000.i=
sc:
> White Balance, Automatic: true atmel_isc f0008000.isc: =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> END STATUS  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>         test VIDIOC_LOG_STATUS: OK
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
> Control ioctls (Input 0):
>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>         test VIDIOC_QUERYCTRL: OK
>         test VIDIOC_G/S_CTRL: OK
>         test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>         Standard Controls: 5 Private Controls: 0
>=20
> Format ioctls (Input 0):
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>         test VIDIOC_G/S_PARM: OK
>         test VIDIOC_G_FBUF: OK (Not Supported)
>         test VIDIOC_G_FMT: OK
>         test VIDIOC_TRY_FMT: OK
>         test VIDIOC_S_FMT: OK
>         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>         test Cropping: OK (Not Supported)
>         test Composing: OK (Not Supported)
>         test Scaling: OK (Not Supported)
>=20
> Codec ioctls (Input 0):
>         test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>=20
> Buffer ioctls (Input 0):
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>         test VIDIOC_EXPBUF: OK
>         test Requests: OK (Not Supported)
>=20
> Total for atmel_isc device /dev/video0: 44, Succeeded: 44, Failed: 0, War=
nings:
> 0
>=20
>=20
>  drivers/media/platform/atmel/atmel-isc.c | 888 ++++++++++++++++---------=
----
> --
>  1 file changed, 471 insertions(+), 417 deletions(-)
>=20
> diff --git a/drivers/media/platform/atmel/atmel-isc.c
> b/drivers/media/platform/atmel/atmel-isc.c
> index 5017896..f4ecb24 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -89,35 +89,25 @@ struct isc_subdev_entity {
>  	struct list_head list;
>  };
>=20
> -/* Indicate the format is generated by the sensor */
> -#define FMT_FLAG_FROM_SENSOR		BIT(0)
> -/* Indicate the format is produced by ISC itself */
> -#define FMT_FLAG_FROM_CONTROLLER	BIT(1)
> -/* Indicate a Raw Bayer format */
> -#define FMT_FLAG_RAW_FORMAT		BIT(2)
> -
> -#define FMT_FLAG_RAW_FROM_SENSOR	(FMT_FLAG_FROM_SENSOR |
> \
> -					 FMT_FLAG_RAW_FORMAT)
> -
>  /*
>   * struct isc_format - ISC media bus format information
> +			This structure represents the interface between the ISC
> +			and the sensor. It's the input format received by
> +			the ISC.
>   * @fourcc:		Fourcc code for this format
>   * @mbus_code:		V4L2 media bus format code.
> - * flags:		Indicate format from sensor or converted by controller
> - * @bpp:		Bits per pixel (when stored in memory)
> - *			(when transferred over a bus)
> - * @sd_support:		Subdev supports this format
> - * @isc_support:	ISC can convert raw format to this format
> + * @cfa_baycfg:		If this format is RAW BAYER, indicate the type
> of bayer.
> +			this is either BGBG, RGRG, etc.
> + * @pfe_cfg0_bps:	Number of hardware data lines connected to the ISC
>   */
>=20
>  struct isc_format {
>  	u32	fourcc;
>  	u32	mbus_code;
> -	u32	flags;
> -	u8	bpp;
> +	u32	cfa_baycfg;
>=20
>  	bool	sd_support;
> -	bool	isc_support;
> +	u32	pfe_cfg0_bps;
>  };
>=20
>  /* Pipeline bitmap */
> @@ -135,16 +125,31 @@ struct isc_format {
>=20
>  #define GAM_ENABLES	(GAM_RENABLE | GAM_GENABLE | GAM_BENABLE |
> GAM_ENABLE)
>=20
> +/*
> + * struct fmt_config - ISC format configuration and internal pipeline
> +			This structure represents the internal configuration
> +			of the ISC.
> +			It also holds the format that ISC will present to v4l2.
> + * @sd_format:		Pointer to an isc_format struct that holds the
> sensor
> +			configuration.
> + * @fourcc:		Fourcc code for this format.
> + * @bpp:		Bytes per pixel in the current format.
> + * @rlp_cfg_mode:	Configuration of the RLP (rounding, limiting packaging=
)
> + * @dcfg_imode:		Configuration of the input of the DMA module
> + * @dctrl_dview:	Configuration of the output of the DMA module
> + * @bits_pipeline:	Configuration of the pipeline, which modules are
> enabled
> + */
>  struct fmt_config {
> -	u32	fourcc;
> +	struct isc_format	*sd_format;
>=20
> -	u32	pfe_cfg0_bps;
> -	u32	cfa_baycfg;
> -	u32	rlp_cfg_mode;
> -	u32	dcfg_imode;
> -	u32	dctrl_dview;
> +	u32			fourcc;
> +	u8			bpp;
>=20
> -	u32	bits_pipeline;
> +	u32			rlp_cfg_mode;
> +	u32			dcfg_imode;
> +	u32			dctrl_dview;
> +
> +	u32			bits_pipeline;
>  };
>=20
>  #define HIST_ENTRIES		512
> @@ -196,8 +201,9 @@ struct isc_device {
>  	struct v4l2_format	fmt;
>  	struct isc_format	**user_formats;
>  	unsigned int		num_user_formats;
> -	const struct isc_format	*current_fmt;
> -	const struct isc_format	*raw_fmt;
> +
> +	struct fmt_config	config;
> +	struct fmt_config	try_config;
>=20
>  	struct isc_ctrls	ctrls;
>  	struct work_struct	awb_work;
> @@ -210,319 +216,122 @@ struct isc_device {
>  	struct list_head		subdev_entities;
>  };
>=20
> -static struct isc_format formats_list[] =3D {
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_SBGGR8,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR8_1X8,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 8,
> -	},
> +/* This is a list of the formats that the ISC can *output* */ static
> +struct isc_format controller_formats[] =3D {
>  	{
> -		.fourcc		=3D V4L2_PIX_FMT_SGBRG8,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG8_1X8,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 8,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_SGRBG8,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG8_1X8,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 8,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_SRGGB8,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB8_1X8,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 8,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_SBGGR10,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR10_1X10,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 16,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_SGBRG10,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG10_1X10,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 16,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_SGRBG10,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG10_1X10,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 16,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_SRGGB10,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB10_1X10,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 16,
> +		.fourcc		=3D V4L2_PIX_FMT_ARGB444,
>  	},
>  	{
> -		.fourcc		=3D V4L2_PIX_FMT_SBGGR12,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR12_1X12,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 16,
> +		.fourcc		=3D V4L2_PIX_FMT_ARGB555,
>  	},
>  	{
> -		.fourcc		=3D V4L2_PIX_FMT_SGBRG12,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG12_1X12,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 16,
> +		.fourcc		=3D V4L2_PIX_FMT_RGB565,
>  	},
>  	{
> -		.fourcc		=3D V4L2_PIX_FMT_SGRBG12,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG12_1X12,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 16,
> +		.fourcc		=3D V4L2_PIX_FMT_ARGB32,
>  	},
>  	{
> -		.fourcc		=3D V4L2_PIX_FMT_SRGGB12,
> -		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB12_1X12,
> -		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		=3D 16,
> +		.fourcc		=3D V4L2_PIX_FMT_YUV420,
>  	},
>  	{
> -		.fourcc		=3D V4L2_PIX_FMT_YUV420,
> -		.mbus_code	=3D 0x0,
> -		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		=3D 12,
> +		.fourcc		=3D V4L2_PIX_FMT_YUYV,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_YUV422P,
> -		.mbus_code	=3D 0x0,
> -		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		=3D 16,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_GREY,
> -		.mbus_code	=3D MEDIA_BUS_FMT_Y8_1X8,
> -		.flags		=3D FMT_FLAG_FROM_CONTROLLER |
> -				  FMT_FLAG_FROM_SENSOR,
> -		.bpp		=3D 8,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_ARGB444,
> -		.mbus_code	=3D MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
> -		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		=3D 16,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_ARGB555,
> -		.mbus_code	=3D MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
> -		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		=3D 16,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_RGB565,
> -		.mbus_code	=3D MEDIA_BUS_FMT_RGB565_2X8_LE,
> -		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		=3D 16,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_ARGB32,
> -		.mbus_code	=3D MEDIA_BUS_FMT_ARGB8888_1X32,
> -		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		=3D 32,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_YUYV,
> -		.mbus_code	=3D MEDIA_BUS_FMT_YUYV8_2X8,
> -		.flags		=3D FMT_FLAG_FROM_CONTROLLER |
> -				  FMT_FLAG_FROM_SENSOR,
> -		.bpp		=3D 16,
>  	},
>  };
>=20
> -static struct fmt_config fmt_configs_list[] =3D {
> +/* This is a list of formats that the ISC can receive as *input* */
> +static struct isc_format formats_list[] =3D {
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SBGGR8,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR8_1X8,
>  		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT8,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SGBRG8,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG8_1X8,
>  		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_GBGB,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT8,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SGRBG8,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG8_1X8,
>  		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_GRGR,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT8,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SRGGB8,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB8_1X8,
>  		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_RGRG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT8,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SBGGR10,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR10_1X10,
>  		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TEN,
> -		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT10,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
> +		.cfa_baycfg	=3D ISC_BAY_CFG_RGRG,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SGBRG10,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG10_1X10,
>  		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TEN,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_GBGB,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT10,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SGRBG10,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG10_1X10,
>  		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TEN,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_GRGR,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT10,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SRGGB10,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB10_1X10,
>  		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TEN,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_RGRG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT10,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SBGGR12,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR12_1X12,
>  		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TWELVE,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT12,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SGBRG12,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG12_1X12,
>  		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TWELVE,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_GBGB,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT12,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SGRBG12,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG12_1X12,
>  		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TWELVE,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_GRGR,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT12,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_SRGGB12,
> +		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB12_1X12,
>  		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TWELVE,
>  		.cfa_baycfg	=3D ISC_BAY_CFG_RGRG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT12,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0,
> -	},
> -	{
> -		.fourcc =3D V4L2_PIX_FMT_YUV420,
> -		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_YYCC,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_YC420P,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PLANAR,
> -		.bits_pipeline	=3D SUB420_ENABLE | SUB422_ENABLE |
> -				  CBC_ENABLE | CSC_ENABLE |
> -				  GAM_ENABLES |
> -				  CFA_ENABLE | WB_ENABLE,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_YUV422P,
> -		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_YYCC,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_YC422P,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PLANAR,
> -		.bits_pipeline	=3D SUB422_ENABLE |
> -				  CBC_ENABLE | CSC_ENABLE |
> -				  GAM_ENABLES |
> -				  CFA_ENABLE | WB_ENABLE,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_GREY,
> +		.mbus_code	=3D MEDIA_BUS_FMT_Y8_1X8,
>  		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DATY8,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D CBC_ENABLE | CSC_ENABLE |
> -				  GAM_ENABLES |
> -				  CFA_ENABLE | WB_ENABLE,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_ARGB444,
> -		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_ARGB444,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D GAM_ENABLES | CFA_ENABLE |
> WB_ENABLE,
>  	},
>  	{
> -		.fourcc		=3D V4L2_PIX_FMT_ARGB555,
> +		.fourcc		=3D V4L2_PIX_FMT_YUYV,
> +		.mbus_code	=3D MEDIA_BUS_FMT_YUYV8_2X8,
>  		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_ARGB555,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D GAM_ENABLES | CFA_ENABLE |
> WB_ENABLE,
>  	},
>  	{
>  		.fourcc		=3D V4L2_PIX_FMT_RGB565,
> +		.mbus_code	=3D MEDIA_BUS_FMT_RGB565_2X8_LE,
>  		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_RGB565,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D GAM_ENABLES | CFA_ENABLE |
> WB_ENABLE,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_ARGB32,
> -		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_ARGB32,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED32,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D GAM_ENABLES | CFA_ENABLE |
> WB_ENABLE,
> -	},
> -	{
> -		.fourcc		=3D V4L2_PIX_FMT_YUYV,
> -		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT8,
> -		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	=3D 0x0
>  	},
>  };
>=20
> @@ -571,6 +380,13 @@ static const u32 isc_gamma_table[GAMMA_MAX +
> 1][GAMMA_ENTRIES] =3D {
>  	  0x3E20007, 0x3E90007, 0x3F00008, 0x3F80007 },  };
>=20
> +#define ISC_IS_FORMAT_RAW(mbus_code) \
> +	(((mbus_code) & 0xf000) =3D=3D 0x3000)
> +
> +static unsigned int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "debug level (0-2)");
> +
>  static unsigned int sensor_preferred =3D 1;  module_param(sensor_preferr=
ed,
> uint, 0644);  MODULE_PARM_DESC(sensor_preferred,
> @@ -896,40 +712,17 @@ static int isc_buffer_prepare(struct vb2_buffer *vb=
)
>  	return 0;
>  }
>=20
> -static inline bool sensor_is_preferred(const struct isc_format *isc_fmt)=
 -{
> -	return (sensor_preferred && isc_fmt->sd_support) ||
> -		!isc_fmt->isc_support;
> -}
> -
> -static struct fmt_config *get_fmt_config(u32 fourcc) -{
> -	struct fmt_config *config;
> -	int i;
> -
> -	config =3D &fmt_configs_list[0];
> -	for (i =3D 0; i < ARRAY_SIZE(fmt_configs_list); i++) {
> -		if (config->fourcc =3D=3D fourcc)
> -			return config;
> -
> -		config++;
> -	}
> -	return NULL;
> -}
> -
>  static void isc_start_dma(struct isc_device *isc)  {
>  	struct regmap *regmap =3D isc->regmap;
> -	struct v4l2_pix_format *pixfmt =3D &isc->fmt.fmt.pix;
> -	u32 sizeimage =3D pixfmt->sizeimage;
> -	struct fmt_config *config =3D get_fmt_config(isc->current_fmt->fourcc);
> +	u32 sizeimage =3D isc->fmt.fmt.pix.sizeimage;
>  	u32 dctrl_dview;
>  	dma_addr_t addr0;
>=20
>  	addr0 =3D vb2_dma_contig_plane_dma_addr(&isc->cur_frm-
> >vb.vb2_buf, 0);
>  	regmap_write(regmap, ISC_DAD0, addr0);
>=20
> -	switch (pixfmt->pixelformat) {
> +	switch (isc->config.fourcc) {
>  	case V4L2_PIX_FMT_YUV420:
>  		regmap_write(regmap, ISC_DAD1, addr0 + (sizeimage * 2) /
> 3);
>  		regmap_write(regmap, ISC_DAD2, addr0 + (sizeimage * 5) /
> 6); @@ -942,10 +735,7 @@ static void isc_start_dma(struct isc_device *isc=
)
>  		break;
>  	}
>=20
> -	if (sensor_is_preferred(isc->current_fmt))
> -		dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> -	else
> -		dctrl_dview =3D config->dctrl_dview;
> +	dctrl_dview =3D isc->config.dctrl_dview;
>=20
>  	regmap_write(regmap, ISC_DCTRL, dctrl_dview | ISC_DCTRL_IE_IS);
>  	regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_CAPTURE); @@ -955,7
> +745,6 @@ static void isc_set_pipeline(struct isc_device *isc, u32 pipeli=
ne)  {
>  	struct regmap *regmap =3D isc->regmap;
>  	struct isc_ctrls *ctrls =3D &isc->ctrls;
> -	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
>  	u32 val, bay_cfg;
>  	const u32 *gamma;
>  	unsigned int i;
> @@ -969,7 +758,7 @@ static void isc_set_pipeline(struct isc_device *isc, =
u32
> pipeline)
>  	if (!pipeline)
>  		return;
>=20
> -	bay_cfg =3D config->cfa_baycfg;
> +	bay_cfg =3D isc->config.sd_format->cfa_baycfg;
>=20
>  	regmap_write(regmap, ISC_WB_CFG, bay_cfg);
>  	regmap_write(regmap, ISC_WB_O_RGR, 0x0); @@ -1011,24 +800,24
> @@ static int isc_update_profile(struct isc_device *isc)
>  	}
>=20
>  	if (counter < 0) {
> -		v4l2_warn(&isc->v4l2_dev, "Time out to update profie\n");
> +		v4l2_warn(&isc->v4l2_dev, "Time out to update profile\n");
>  		return -ETIMEDOUT;
>  	}
>=20
>  	return 0;
>  }
>=20
> -static void isc_set_histogram(struct isc_device *isc)
> +static void isc_set_histogram(struct isc_device *isc, bool enable)
>  {
>  	struct regmap *regmap =3D isc->regmap;
>  	struct isc_ctrls *ctrls =3D &isc->ctrls;
> -	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
>=20
> -	if (ctrls->awb && (ctrls->hist_stat !=3D HIST_ENABLED)) {
> +	if (enable) {
>  		regmap_write(regmap, ISC_HIS_CFG,
>  			     ISC_HIS_CFG_MODE_R |
> -			     (config->cfa_baycfg <<
> ISC_HIS_CFG_BAYSEL_SHIFT) |
> -			     ISC_HIS_CFG_RAR);
> +			     (isc->config.sd_format->cfa_baycfg
> +					<< ISC_HIS_CFG_BAYSEL_SHIFT) |
> +					ISC_HIS_CFG_RAR);
>  		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_EN);
>  		regmap_write(regmap, ISC_INTEN, ISC_INT_HISDONE);
>  		ctrls->hist_id =3D ISC_HIS_CFG_MODE_R;
> @@ -1036,7 +825,7 @@ static void isc_set_histogram(struct isc_device *isc=
)
>  		regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
>=20
>  		ctrls->hist_stat =3D HIST_ENABLED;
> -	} else if (!ctrls->awb && (ctrls->hist_stat !=3D HIST_DISABLED)) {
> +	} else {
>  		regmap_write(regmap, ISC_INTDIS, ISC_INT_HISDONE);
>  		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_DIS);
>=20
> @@ -1044,53 +833,18 @@ static void isc_set_histogram(struct isc_device *i=
sc)
>  	}
>  }
>=20
> -static inline void isc_get_param(const struct isc_format *fmt,
> -				 u32 *rlp_mode, u32 *dcfg)
> -{
> -	struct fmt_config *config =3D get_fmt_config(fmt->fourcc);
> -
> -	*dcfg =3D ISC_DCFG_YMBSIZE_BEATS8;
> -
> -	switch (fmt->fourcc) {
> -	case V4L2_PIX_FMT_SBGGR10:
> -	case V4L2_PIX_FMT_SGBRG10:
> -	case V4L2_PIX_FMT_SGRBG10:
> -	case V4L2_PIX_FMT_SRGGB10:
> -	case V4L2_PIX_FMT_SBGGR12:
> -	case V4L2_PIX_FMT_SGBRG12:
> -	case V4L2_PIX_FMT_SGRBG12:
> -	case V4L2_PIX_FMT_SRGGB12:
> -		*rlp_mode =3D config->rlp_cfg_mode;
> -		*dcfg |=3D config->dcfg_imode;
> -		break;
> -	default:
> -		*rlp_mode =3D ISC_RLP_CFG_MODE_DAT8;
> -		*dcfg |=3D ISC_DCFG_IMODE_PACKED8;
> -		break;
> -	}
> -}
> -
>  static int isc_configure(struct isc_device *isc)  {
>  	struct regmap *regmap =3D isc->regmap;
> -	const struct isc_format *current_fmt =3D isc->current_fmt;
> -	struct fmt_config *curfmt_config =3D get_fmt_config(current_fmt-
> >fourcc);
> -	struct fmt_config *rawfmt_config =3D get_fmt_config(isc->raw_fmt-
> >fourcc);
> -	struct isc_subdev_entity *subdev =3D isc->current_subdev;
>  	u32 pfe_cfg0, rlp_mode, dcfg, mask, pipeline;
> +	struct isc_subdev_entity *subdev =3D isc->current_subdev;
>=20
> -	if (sensor_is_preferred(current_fmt)) {
> -		pfe_cfg0 =3D curfmt_config->pfe_cfg0_bps;
> -		pipeline =3D 0x0;
> -		isc_get_param(current_fmt, &rlp_mode, &dcfg);
> -		isc->ctrls.hist_stat =3D HIST_INIT;
> -	} else {
> -		pfe_cfg0 =3D rawfmt_config->pfe_cfg0_bps;
> -		pipeline =3D curfmt_config->bits_pipeline;
> -		rlp_mode =3D curfmt_config->rlp_cfg_mode;
> -		dcfg =3D curfmt_config->dcfg_imode |
> +	pfe_cfg0 =3D isc->config.sd_format->pfe_cfg0_bps;
> +	rlp_mode =3D isc->config.rlp_cfg_mode;
> +	pipeline =3D isc->config.bits_pipeline;
> +
> +	dcfg =3D isc->config.dcfg_imode |
>  		       ISC_DCFG_YMBSIZE_BEATS8 |
> ISC_DCFG_CMBSIZE_BEATS8;
> -	}
>=20
>  	pfe_cfg0  |=3D subdev->pfe_cfg0 | ISC_PFE_CFG0_MODE_PROGRESSIVE;
>  	mask =3D ISC_PFE_CFG0_BPS_MASK | ISC_PFE_CFG0_HPOL_LOW | @@ -
> 1107,8 +861,15 @@ static int isc_configure(struct isc_device *isc)
>  	/* Set the pipeline */
>  	isc_set_pipeline(isc, pipeline);
>=20
> -	if (pipeline)
> -		isc_set_histogram(isc);
> +	/*
> +	 * The current implemented histogram is available for RAW R, B, GB
> +	 * channels. We need to check if sensor is outputting RAW BAYER
> +	 */
> +	if (isc->ctrls.awb &&
> +	    ISC_IS_FORMAT_RAW(isc->config.sd_format->mbus_code))
> +		isc_set_histogram(isc, true);
> +	else
> +		isc_set_histogram(isc, false);
>=20
>  	/* Update profile */
>  	return isc_update_profile(isc);
> @@ -1125,7 +886,8 @@ static int isc_start_streaming(struct vb2_queue *vq,
> unsigned int count)
>  	/* Enable stream on the sub device */
>  	ret =3D v4l2_subdev_call(isc->current_subdev->sd, video, s_stream, 1);
>  	if (ret && ret !=3D -ENOIOCTLCMD) {
> -		v4l2_err(&isc->v4l2_dev, "stream on failed in subdev\n");
> +		v4l2_err(&isc->v4l2_dev, "stream on failed in subdev %d\n",
> +			 ret);
>  		goto err_start_stream;
>  	}
>=20
> @@ -1223,6 +985,22 @@ static void isc_buffer_queue(struct vb2_buffer *vb)
>  	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);  }
>=20
> +static struct isc_format *find_format_by_fourcc(struct isc_device *isc,
> +						 unsigned int fourcc)
> +{
> +	unsigned int num_formats =3D isc->num_user_formats;
> +	struct isc_format *fmt;
> +	unsigned int i;
> +
> +	for (i =3D 0; i < num_formats; i++) {
> +		fmt =3D isc->user_formats[i];
> +		if (fmt->fourcc =3D=3D fourcc)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
>  static const struct vb2_ops isc_vb2_ops =3D {
>  	.queue_setup		=3D isc_queue_setup,
>  	.wait_prepare		=3D vb2_ops_wait_prepare,
> @@ -1249,15 +1027,31 @@ static int isc_querycap(struct file *file, void *=
priv,
> static int isc_enum_fmt_vid_cap(struct file *file, void *priv,
>  				 struct v4l2_fmtdesc *f)
>  {
> -	struct isc_device *isc =3D video_drvdata(file);
>  	u32 index =3D f->index;
> +	u32 i, supported_index;
>=20
> -	if (index >=3D isc->num_user_formats)
> -		return -EINVAL;
> +	if (index < ARRAY_SIZE(controller_formats)) {
> +		f->pixelformat =3D controller_formats[index].fourcc;
> +		return 0;
> +	}
>=20
> -	f->pixelformat =3D isc->user_formats[index]->fourcc;
> +	index -=3D ARRAY_SIZE(controller_formats);
>=20
> -	return 0;
> +	i =3D 0;
> +	supported_index =3D 0;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(formats_list); i++) {
> +		if (!ISC_IS_FORMAT_RAW(formats_list[i].mbus_code) ||
> +		    !formats_list[i].sd_support)
> +			continue;
> +		if (supported_index =3D=3D index) {
> +			f->pixelformat =3D formats_list[i].fourcc;
> +			return 0;
> +		}
> +		supported_index++;
> +	}
> +
> +	return -EINVAL;
>  }
>=20
>  static int isc_g_fmt_vid_cap(struct file *file, void *priv, @@ -1270,26
> +1064,231 @@ static int isc_g_fmt_vid_cap(struct file *file, void *priv,
>  	return 0;
>  }
>=20
> -static struct isc_format *find_format_by_fourcc(struct isc_device *isc,
> -						 unsigned int fourcc)
> +/*
> + * Checks the current configured format, if ISC can output it,
> + * considering which type of format the ISC receives from the sensor
> +*/ static int isc_try_validate_formats(struct isc_device *isc)
>  {
> -	unsigned int num_formats =3D isc->num_user_formats;
> -	struct isc_format *fmt;
> -	unsigned int i;
> +	int ret;
> +	bool bayer =3D false, yuv =3D false, rgb =3D false, grey =3D false;
> +
> +	/* all formats supported by the RLP module are OK */
> +	switch (isc->try_config.fourcc) {
> +	case V4L2_PIX_FMT_SBGGR8:
> +	case V4L2_PIX_FMT_SGBRG8:
> +	case V4L2_PIX_FMT_SGRBG8:
> +	case V4L2_PIX_FMT_SRGGB8:
> +	case V4L2_PIX_FMT_SBGGR10:
> +	case V4L2_PIX_FMT_SGBRG10:
> +	case V4L2_PIX_FMT_SGRBG10:
> +	case V4L2_PIX_FMT_SRGGB10:
> +	case V4L2_PIX_FMT_SBGGR12:
> +	case V4L2_PIX_FMT_SGBRG12:
> +	case V4L2_PIX_FMT_SGRBG12:
> +	case V4L2_PIX_FMT_SRGGB12:
> +		ret =3D 0;
> +		bayer =3D true;
> +		break;
>=20
> -	for (i =3D 0; i < num_formats; i++) {
> -		fmt =3D isc->user_formats[i];
> -		if (fmt->fourcc =3D=3D fourcc)
> -			return fmt;
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YUV422P:
> +	case V4L2_PIX_FMT_YUYV:
> +		ret =3D 0;
> +		yuv =3D true;
> +		break;
> +
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_ARGB32:
> +	case V4L2_PIX_FMT_ARGB444:
> +	case V4L2_PIX_FMT_ARGB555:
> +		ret =3D 0;
> +		rgb =3D true;
> +		break;
> +	case V4L2_PIX_FMT_GREY:
> +		ret =3D 0;
> +		grey =3D true;
> +		break;
> +	default:
> +	/* any other different formats are not supported */
> +		ret =3D -EINVAL;
>  	}
>=20
> -	return NULL;
> +	/* we cannot output RAW/Grey if we do not receive RAW */
> +	if ((bayer || grey) &&
> +	    !ISC_IS_FORMAT_RAW(isc->try_config.sd_format->mbus_code))
> +		return -EINVAL;
> +
> +	return ret;
> +}
> +
> +/*
> + * Configures the RLP and DMA modules, depending on the output format
> + * configured for the ISC.
> + * If direct_dump =3D=3D true, just dump raw data 8 bits.
> + */
> +static int isc_try_configure_rlp_dma(struct isc_device *isc, bool
> +direct_dump) {
> +	if (direct_dump) {
> +		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT8;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED8;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> +		isc->try_config.bpp =3D 16;
> +		return 0;
> +	}
> +
> +	switch (isc->try_config.fourcc) {
> +	case V4L2_PIX_FMT_SBGGR8:
> +	case V4L2_PIX_FMT_SGBRG8:
> +	case V4L2_PIX_FMT_SGRBG8:
> +	case V4L2_PIX_FMT_SRGGB8:
> +		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT8;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED8;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> +		isc->try_config.bpp =3D 8;
> +		break;
> +	case V4L2_PIX_FMT_SBGGR10:
> +	case V4L2_PIX_FMT_SGBRG10:
> +	case V4L2_PIX_FMT_SGRBG10:
> +	case V4L2_PIX_FMT_SRGGB10:
> +		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT10;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> +		isc->try_config.bpp =3D 16;
> +		break;
> +	case V4L2_PIX_FMT_SBGGR12:
> +	case V4L2_PIX_FMT_SGBRG12:
> +	case V4L2_PIX_FMT_SGRBG12:
> +	case V4L2_PIX_FMT_SRGGB12:
> +		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT12;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> +		isc->try_config.bpp =3D 16;
> +		break;
> +	case V4L2_PIX_FMT_RGB565:
> +		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_RGB565;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> +		isc->try_config.bpp =3D 16;
> +		break;
> +	case V4L2_PIX_FMT_ARGB444:
> +		isc->try_config.rlp_cfg_mode =3D
> ISC_RLP_CFG_MODE_ARGB444;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> +		isc->try_config.bpp =3D 16;
> +		break;
> +	case V4L2_PIX_FMT_ARGB555:
> +		isc->try_config.rlp_cfg_mode =3D
> ISC_RLP_CFG_MODE_ARGB555;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> +		isc->try_config.bpp =3D 16;
> +		break;
> +	case V4L2_PIX_FMT_ARGB32:
> +		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_ARGB32;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED32;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> +		isc->try_config.bpp =3D 32;
> +		break;
> +	case V4L2_PIX_FMT_YUV420:
> +		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_YYCC;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_YC420P;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PLANAR;
> +		isc->try_config.bpp =3D 12;
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_YYCC;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_YC422P;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PLANAR;
> +		isc->try_config.bpp =3D 16;
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_YYCC;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED32;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> +		isc->try_config.bpp =3D 16;
> +		break;
> +	case V4L2_PIX_FMT_GREY:
> +		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DATY8;
> +		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED8;
> +		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
> +		isc->try_config.bpp =3D 8;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Configuring pipeline modules, depending on which format the ISC
> +outputs
> + * and considering which format it has as input from the sensor.
> + */
> +static int isc_try_configure_pipeline(struct isc_device *isc) {
> +	switch (isc->try_config.fourcc) {
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_ARGB555:
> +	case V4L2_PIX_FMT_ARGB444:
> +	case V4L2_PIX_FMT_ARGB32:
> +		/* if sensor format is RAW, we convert inside ISC */
> +		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format-
> >mbus_code)) {
> +			isc->try_config.bits_pipeline =3D CFA_ENABLE |
> +				WB_ENABLE | GAM_ENABLES;
> +		} else {
> +			isc->try_config.bits_pipeline =3D 0x0;
> +		}
> +		break;
> +	case V4L2_PIX_FMT_YUV420:
> +		/* if sensor format is RAW, we convert inside ISC */
> +		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format-
> >mbus_code)) {
> +			isc->try_config.bits_pipeline =3D CFA_ENABLE |
> +				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
> +				SUB420_ENABLE | SUB422_ENABLE |
> CBC_ENABLE;
> +		} else {
> +			isc->try_config.bits_pipeline =3D 0x0;
> +		}
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +		/* if sensor format is RAW, we convert inside ISC */
> +		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format-
> >mbus_code)) {
> +			isc->try_config.bits_pipeline =3D CFA_ENABLE |
> +				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
> +				SUB422_ENABLE | CBC_ENABLE;
> +		} else {
> +			isc->try_config.bits_pipeline =3D 0x0;
> +		}
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +		/* if sensor format is RAW, we convert inside ISC */
> +		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format-
> >mbus_code)) {
> +			isc->try_config.bits_pipeline =3D CFA_ENABLE |
> +				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
> +				SUB422_ENABLE | CBC_ENABLE;
> +		} else {
> +			isc->try_config.bits_pipeline =3D 0x0;
> +		}
> +		break;
> +	case V4L2_PIX_FMT_GREY:
> +		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format-
> >mbus_code)) {
> +		/* if sensor format is RAW, we convert inside ISC */
> +			isc->try_config.bits_pipeline =3D CFA_ENABLE |
> +				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
> +				CBC_ENABLE;
> +		} else {
> +			isc->try_config.bits_pipeline =3D 0x0;
> +		}
> +		break;
> +	default:
> +		isc->try_config.bits_pipeline =3D 0x0;
> +	}
> +	return 0;
>  }
>=20
>  static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
> -			struct isc_format **current_fmt, u32 *code)
> +			u32 *code)
>  {
> -	struct isc_format *isc_fmt;
> +	int i;
> +	struct isc_format *sd_fmt =3D NULL, *direct_fmt =3D NULL;
>  	struct v4l2_pix_format *pixfmt =3D &f->fmt.pix;
>  	struct v4l2_subdev_pad_config pad_cfg;
>  	struct v4l2_subdev_format format =3D {
> @@ -1297,48 +1296,114 @@ static int isc_try_fmt(struct isc_device *isc, s=
truct
> v4l2_format *f,
>  	};
>  	u32 mbus_code;
>  	int ret;
> +	bool rlp_dma_direct_dump =3D false;
>=20
>  	if (f->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>=20
> -	isc_fmt =3D find_format_by_fourcc(isc, pixfmt->pixelformat);
> -	if (!isc_fmt) {
> -		v4l2_warn(&isc->v4l2_dev, "Format 0x%x not found\n",
> -			  pixfmt->pixelformat);
> -		isc_fmt =3D isc->user_formats[isc->num_user_formats - 1];
> -		pixfmt->pixelformat =3D isc_fmt->fourcc;
> +	/* Step 1: find a RAW format that is supported */
> +	for (i =3D 0; i < isc->num_user_formats; i++) {
> +		if (ISC_IS_FORMAT_RAW(isc->user_formats[i]->mbus_code)) {
> +			sd_fmt =3D isc->user_formats[i];
> +			break;
> +		}
> +	}
> +	/* Step 2: We can continue with this RAW format, or we can look
> +	 * for better: maybe sensor supports directly what we need.
> +	 */
> +	direct_fmt =3D find_format_by_fourcc(isc, pixfmt->pixelformat);
> +
> +	/* Step 3: We have both. We decide given the module parameter which
> +	 * one to use.
> +	 */
> +	if (direct_fmt && sd_fmt && sensor_preferred)
> +		sd_fmt =3D direct_fmt;
> +
> +	/* Step 4: we do not have RAW but we have a direct format. Use it. */
> +	if (direct_fmt && !sd_fmt)
> +		sd_fmt =3D direct_fmt;
> +
> +	/* Step 5: if we are using a direct format, we need to package
> +	 * everything as 8 bit data and just dump it
> +	 */
> +	if (sd_fmt =3D=3D direct_fmt)
> +		rlp_dma_direct_dump =3D true;
> +
> +	/* Step 6: We have no format. This can happen if the userspace
> +	 * requests some weird/invalid format.
> +	 * In this case, default to whatever we have
> +	 */
> +	if (!sd_fmt && !direct_fmt) {
> +		sd_fmt =3D isc->user_formats[isc->num_user_formats - 1];
> +		v4l2_dbg(1, debug, &isc->v4l2_dev,
> +			 "Sensor not supporting %.4s, using %.4s\n",
> +			 (char *)&pixfmt->pixelformat, (char *)&sd_fmt-
> >fourcc);
>  	}
>=20
> +	/* Step 7: Print out what we decided for debugging */
> +	v4l2_dbg(1, debug, &isc->v4l2_dev,
> +		 "Preferring to have sensor using format %.4s\n",
> +		 (char *)&sd_fmt->fourcc);
> +
> +	/* Step 8: at this moment we decided which format the subdev will use
> */
> +	isc->try_config.sd_format =3D sd_fmt;
> +
>  	/* Limit to Atmel ISC hardware capabilities */
>  	if (pixfmt->width > ISC_MAX_SUPPORT_WIDTH)
>  		pixfmt->width =3D ISC_MAX_SUPPORT_WIDTH;
>  	if (pixfmt->height > ISC_MAX_SUPPORT_HEIGHT)
>  		pixfmt->height =3D ISC_MAX_SUPPORT_HEIGHT;
>=20
> -	if (sensor_is_preferred(isc_fmt))
> -		mbus_code =3D isc_fmt->mbus_code;
> -	else
> -		mbus_code =3D isc->raw_fmt->mbus_code;
> +	/*
> +	 * The mbus format is the one the subdev outputs.
> +	 * The pixels will be transferred in this format Sensor -> ISC
> +	 */
> +	mbus_code =3D sd_fmt->mbus_code;
> +
> +	/*
> +	 * Validate formats. If the required format is not OK, default to raw.
> +	 */
> +
> +	isc->try_config.fourcc =3D pixfmt->pixelformat;
> +
> +	if (isc_try_validate_formats(isc)) {
> +		pixfmt->pixelformat =3D isc->try_config.fourcc =3D sd_fmt->fourcc;
> +		/* This should be redundant, format should be supported */
> +		ret =3D isc_try_validate_formats(isc);
> +		if (ret)
> +			goto isc_try_fmt_err;
> +	}
> +
> +	ret =3D isc_try_configure_rlp_dma(isc, rlp_dma_direct_dump);
> +	if (ret)
> +		goto isc_try_fmt_err;
> +
> +	ret =3D isc_try_configure_pipeline(isc);
> +	if (ret)
> +		goto isc_try_fmt_err;
>=20
>  	v4l2_fill_mbus_format(&format.format, pixfmt, mbus_code);
>  	ret =3D v4l2_subdev_call(isc->current_subdev->sd, pad, set_fmt,
>  			       &pad_cfg, &format);
>  	if (ret < 0)
> -		return ret;
> +		goto isc_try_fmt_err;
>=20
>  	v4l2_fill_pix_format(pixfmt, &format.format);
>=20
>  	pixfmt->field =3D V4L2_FIELD_NONE;
> -	pixfmt->bytesperline =3D (pixfmt->width * isc_fmt->bpp) >> 3;
> +	pixfmt->bytesperline =3D (pixfmt->width * isc->try_config.bpp) >> 3;
>  	pixfmt->sizeimage =3D pixfmt->bytesperline * pixfmt->height;
>=20
> -	if (current_fmt)
> -		*current_fmt =3D isc_fmt;
> -
>  	if (code)
>  		*code =3D mbus_code;
>=20
>  	return 0;
> +
> +isc_try_fmt_err:
> +	v4l2_err(&isc->v4l2_dev, "Could not find any possible format for a
> working pipeline\n");
> +	memset(&isc->try_config, 0, sizeof(isc->try_config));
> +
> +	return ret;
>  }
>=20
>  static int isc_set_fmt(struct isc_device *isc, struct v4l2_format *f) @@=
 -
> 1346,11 +1411,10 @@ static int isc_set_fmt(struct isc_device *isc, struct
> v4l2_format *f)
>  	struct v4l2_subdev_format format =3D {
>  		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
> -	struct isc_format *current_fmt;
> -	u32 mbus_code;
> +	u32 mbus_code =3D 0;
>  	int ret;
>=20
> -	ret =3D isc_try_fmt(isc, f, &current_fmt, &mbus_code);
> +	ret =3D isc_try_fmt(isc, f, &mbus_code);
>  	if (ret)
>  		return ret;
>=20
> @@ -1361,7 +1425,10 @@ static int isc_set_fmt(struct isc_device *isc, str=
uct
> v4l2_format *f)
>  		return ret;
>=20
>  	isc->fmt =3D *f;
> -	isc->current_fmt =3D current_fmt;
> +	/* make the try configuration active */
> +	memcpy(&isc->config, &isc->try_config, sizeof(isc->config));
> +
> +	v4l2_dbg(1, debug, &isc->v4l2_dev, "New ISC configuration in
> +place\n");
>=20
>  	return 0;
>  }
> @@ -1382,7 +1449,7 @@ static int isc_try_fmt_vid_cap(struct file *file, v=
oid
> *priv,  {
>  	struct isc_device *isc =3D video_drvdata(file);
>=20
> -	return isc_try_fmt(isc, f, NULL, NULL);
> +	return isc_try_fmt(isc, f, NULL);
>  }
>=20
>  static int isc_enum_input(struct file *file, void *priv, @@ -1431,27 +14=
98,31
> @@ static int isc_enum_framesizes(struct file *file, void *fh,
>  			       struct v4l2_frmsizeenum *fsize)  {
>  	struct isc_device *isc =3D video_drvdata(file);
> -	const struct isc_format *isc_fmt;
>  	struct v4l2_subdev_frame_size_enum fse =3D {
>  		.index =3D fsize->index,
>  		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
> -	int ret;
> +	int ret =3D -EINVAL;
> +	int i;
>=20
> -	isc_fmt =3D find_format_by_fourcc(isc, fsize->pixel_format);
> -	if (!isc_fmt)
> -		return -EINVAL;
> +	for (i =3D 0; i < isc->num_user_formats; i++)
> +		if (isc->user_formats[i]->fourcc =3D=3D fsize->pixel_format)
> +			ret =3D 0;
>=20
> -	if (sensor_is_preferred(isc_fmt))
> -		fse.code =3D isc_fmt->mbus_code;
> -	else
> -		fse.code =3D isc->raw_fmt->mbus_code;
> +	for (i =3D 0; i < ARRAY_SIZE(controller_formats); i++)
> +		if (controller_formats[i].fourcc =3D=3D fsize->pixel_format)
> +			ret =3D 0;
> +
> +	if (ret)
> +		return ret;
>=20
>  	ret =3D v4l2_subdev_call(isc->current_subdev->sd, pad,
> enum_frame_size,
>  			       NULL, &fse);
>  	if (ret)
>  		return ret;
>=20
> +	fse.code =3D isc->config.sd_format->mbus_code;
> +
>  	fsize->type =3D V4L2_FRMSIZE_TYPE_DISCRETE;
>  	fsize->discrete.width =3D fse.max_width;
>  	fsize->discrete.height =3D fse.max_height; @@ -1463,29 +1534,32 @@
> static int isc_enum_frameintervals(struct file *file, void *fh,
>  				    struct v4l2_frmivalenum *fival)  {
>  	struct isc_device *isc =3D video_drvdata(file);
> -	const struct isc_format *isc_fmt;
>  	struct v4l2_subdev_frame_interval_enum fie =3D {
>  		.index =3D fival->index,
>  		.width =3D fival->width,
>  		.height =3D fival->height,
>  		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
> -	int ret;
> +	int ret =3D -EINVAL;
> +	int i;
>=20
> -	isc_fmt =3D find_format_by_fourcc(isc, fival->pixel_format);
> -	if (!isc_fmt)
> -		return -EINVAL;
> +	for (i =3D 0; i < isc->num_user_formats; i++)
> +		if (isc->user_formats[i]->fourcc =3D=3D fival->pixel_format)
> +			ret =3D 0;
>=20
> -	if (sensor_is_preferred(isc_fmt))
> -		fie.code =3D isc_fmt->mbus_code;
> -	else
> -		fie.code =3D isc->raw_fmt->mbus_code;
> +	for (i =3D 0; i < ARRAY_SIZE(controller_formats); i++)
> +		if (controller_formats[i].fourcc =3D=3D fival->pixel_format)
> +			ret =3D 0;
> +
> +	if (ret)
> +		return ret;
>=20
>  	ret =3D v4l2_subdev_call(isc->current_subdev->sd, pad,
>  			       enum_frame_interval, NULL, &fie);
>  	if (ret)
>  		return ret;
>=20
> +	fie.code =3D isc->config.sd_format->mbus_code;
>  	fival->type =3D V4L2_FRMIVAL_TYPE_DISCRETE;
>  	fival->discrete =3D fie.interval;
>=20
> @@ -1668,7 +1742,6 @@ static void isc_awb_work(struct work_struct *w)
>  	struct isc_device *isc =3D
>  		container_of(w, struct isc_device, awb_work);
>  	struct regmap *regmap =3D isc->regmap;
> -	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
>  	struct isc_ctrls *ctrls =3D &isc->ctrls;
>  	u32 hist_id =3D ctrls->hist_id;
>  	u32 baysel;
> @@ -1686,7 +1759,7 @@ static void isc_awb_work(struct work_struct *w)
>  	}
>=20
>  	ctrls->hist_id =3D hist_id;
> -	baysel =3D config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
> +	baysel =3D isc->config.sd_format->cfa_baycfg <<
> +ISC_HIS_CFG_BAYSEL_SHIFT;
>=20
>  	pm_runtime_get_sync(isc->dev);
>=20
> @@ -1754,7 +1827,6 @@ static int isc_ctrl_init(struct isc_device *isc)
>  	return 0;
>  }
>=20
> -
>  static int isc_async_bound(struct v4l2_async_notifier *notifier,
>  			    struct v4l2_subdev *subdev,
>  			    struct v4l2_async_subdev *asd)
> @@ -1812,35 +1884,20 @@ static int isc_formats_init(struct isc_device *is=
c)
>  		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
>=20
> +	num_fmts =3D 0;
>  	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
>  	       NULL, &mbus_code)) {
>  		mbus_code.index++;
>=20
>  		fmt =3D find_format_by_code(mbus_code.code, &i);
> -		if ((!fmt) || (!(fmt->flags & FMT_FLAG_FROM_SENSOR)))
> +		if (!fmt) {
> +			v4l2_warn(&isc->v4l2_dev, "Mbus code %x not
> supported\n",
> +				  mbus_code.code);
>  			continue;
> +		}
>=20
>  		fmt->sd_support =3D true;
> -
> -		if (fmt->flags & FMT_FLAG_RAW_FORMAT)
> -			isc->raw_fmt =3D fmt;
> -	}
> -
> -	fmt =3D &formats_list[0];
> -	for (i =3D 0; i < list_size; i++) {
> -		if (fmt->flags & FMT_FLAG_FROM_CONTROLLER)
> -			fmt->isc_support =3D true;
> -
> -		fmt++;
> -	}
> -
> -	fmt =3D &formats_list[0];
> -	num_fmts =3D 0;
> -	for (i =3D 0; i < list_size; i++) {
> -		if (fmt->isc_support || fmt->sd_support)
> -			num_fmts++;
> -
> -		fmt++;
> +		num_fmts++;
>  	}
>=20
>  	if (!num_fmts)
> @@ -1855,9 +1912,8 @@ static int isc_formats_init(struct isc_device *isc)
>=20
>  	fmt =3D &formats_list[0];
>  	for (i =3D 0, j =3D 0; i < list_size; i++) {
> -		if (fmt->isc_support || fmt->sd_support)
> +		if (fmt->sd_support)
>  			isc->user_formats[j++] =3D fmt;
> -
>  		fmt++;
>  	}
>=20
> @@ -1877,13 +1933,11 @@ static int isc_set_default_fmt(struct isc_device
> *isc)
>  	};
>  	int ret;
>=20
> -	ret =3D isc_try_fmt(isc, &f, NULL, NULL);
> +	ret =3D isc_try_fmt(isc, &f, NULL);
>  	if (ret)
>  		return ret;
>=20
> -	isc->current_fmt =3D isc->user_formats[0];
>  	isc->fmt =3D f;
> -
>  	return 0;
>  }
>=20
> --
> 2.7.4

Hi Eugen/Hans,

Sorry for the late reply on this, I had some changes I needed to do to my s=
etup to get it working with the latest changes in the media tree. I just te=
sted your v2 iteration here Eugen, and confirmed, yes it does indeed work w=
ith my setup and obviously no longer gets a kernel oops as was happening fo=
r me in the previous version of the driver.

One thing I would like to comment about my setup, is that while it is a YUV=
 type format, rather than the format in the driver (V4L2_PIX_FMT_YUYV), my =
setup actually uses V4L2_PIX_FMT_UYVY. In the previous version of the drive=
r, I actually made modifications in my tree to support this format.

For quick testing purposes on your patch since the format specification met=
hod has changed, I simply replaced V4L2_PIX_FMT_YUYV statements with V4L2_P=
IX_FMT_UYVY and MEDIA_BUS_FMT_YUYV8_2X8 with MEDIA_BUS_FMT_UYVY8_2X8.

Perhaps this alternative YUV format could be added to the current list as w=
ell? Per my test, all of the other settings you have applied in the ISC for=
 YUV work just fine for my setup, I am simply using a different variant of =
the YUV format. If you don't want to add support for this now, I can certai=
nly submit a future patch as well. Let me know if there is anything else yo=
u would like me to test for you also.

Thanks,
Ken Sloat

