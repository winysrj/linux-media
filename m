Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0661C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 07:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FE6D2173C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 07:25:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="z04PEzQ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfCMHZO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 03:25:14 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:4520 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfCMHZO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 03:25:14 -0400
X-IronPort-AV: E=Sophos;i="5.58,474,1544511600"; 
   d="scan'208";a="27917338"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 13 Mar 2019 00:25:12 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 13 Mar 2019 00:25:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpICsl43dLHtAEuMlGKOMOd63eIBeGLpaLE9GOjhKVs=;
 b=z04PEzQ/2WwIIFtFEtb3fOLOUF8vKpKRTLEgH+kac9TcYyifTensYUaQ0Nzuci3j9QgJn6gIvmSY0QvAC8gyf0VbCTkE98nk3QcYTcW7RdebYDCOcOlTG6TU9jzf2bOZMhVFJ718mSE33KcezR/3Nrs75AvUBDqp/EUv/crjGbQ=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1436.namprd11.prod.outlook.com (10.172.36.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.19; Wed, 13 Mar 2019 07:25:09 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e8b6:2ae9:9b9c:2ca8]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e8b6:2ae9:9b9c:2ca8%3]) with mapi id 15.20.1709.011; Wed, 13 Mar 2019
 07:25:09 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <hverkuil@xs4all.nl>, <Nicolas.Ferre@microchip.com>,
        <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <mchehab@kernel.org>
CC:     <ksloat@aampglobal.com>, <Eugen.Hristev@microchip.com>
Subject: [PATCH v2 1/2] media: atmel: atmel-isc: reworked driver and formats
Thread-Topic: [PATCH v2 1/2] media: atmel: atmel-isc: reworked driver and
 formats
Thread-Index: AQHU2W3jEjSHs0v2fEmY3j98V2LyQQ==
Date:   Wed, 13 Mar 2019 07:25:09 +0000
Message-ID: <1552461639-8708-1-git-send-email-eugen.hristev@microchip.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR07CA0147.eurprd07.prod.outlook.com
 (2603:10a6:802:16::34) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7407e5e-b241-4a59-3acb-08d6a78505a4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1436;
x-ms-traffictypediagnostic: DM5PR11MB1436:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;DM5PR11MB1436;23:34hfr14w/ItHV6ktIqY+j8IA7Fe+1QzAdVAz5NZ?=
 =?iso-8859-1?Q?zBOzzXqkWY/VF+Jve0P3k+q40vo6DK8Fj+lUMN/6zH+lT68oivn9svLo2P?=
 =?iso-8859-1?Q?aZjZtVZM4HyD7yTU2m6g/a6Zue45J1endKYodp2YsWyE77SzSMerwSihqW?=
 =?iso-8859-1?Q?DfCD7EJ9WrIn7pd+DYBGQCBc8wzCPos8z8ZS+5o3E81R225pmXCSGXZveb?=
 =?iso-8859-1?Q?EpDsaaV8kb8KhboZs9OJpVuWeiOKJg25OF3wQMBm5tDVyVkol7ayprDbWq?=
 =?iso-8859-1?Q?n9ViR3yxO5lDwdpBhfK88b1yBBwDvGCKDVoivQ1bJidKQuEeZL1xdnqzRM?=
 =?iso-8859-1?Q?gFU5vabAylfPdBsetGismWIikihFi1vpNPxAWojlXSuWL9fLnY3ZPWzrPI?=
 =?iso-8859-1?Q?N5tAIPxdSfQLYYlM3cdfuJ00Elye+mOJxXLXu3Fj54CDb6NVaojInTeI7x?=
 =?iso-8859-1?Q?Ms+ICgHuyuwSOKbQEJV8Dr6mkj7HSkXWYh2zAMaAPvQ43ENX4IkFSZWLnY?=
 =?iso-8859-1?Q?nwQFspmclIBD/zsLMoMzLDOY4+uDXtd0Las9+3gaep3GgSx8m22L1OIo7F?=
 =?iso-8859-1?Q?hdMbincdB6wHpyVwHRemPUXKB+Z9Go3lAiD/l0FnXjAkeBZH2diPmDgcJD?=
 =?iso-8859-1?Q?srH/WZ+LKYKWIq5X9XpAAtcX5774cFYxjVLsrW04VCuc1+NLeWJ/9lxXGo?=
 =?iso-8859-1?Q?HLezG582YSnpshmsvMO0Ke1s8VIj6Kv0g/dvjlIj6J1xdzEgtyr3GN1adO?=
 =?iso-8859-1?Q?lW5Q9l266u2F8SEQJM2uNI0ZCm3J1JtP0uamM5Sn/QICp7FXY8R16RXIxv?=
 =?iso-8859-1?Q?cwSgScnklOe4TFuXYn39GnNiG270Sgby20OHXbQp1zR3dhTySnagWqhGtB?=
 =?iso-8859-1?Q?DDfq3TVQc8Dc466BqkS3HHqHuwMBT6BkLT2lvwe33G7h2KyrPNXC0u9YY5?=
 =?iso-8859-1?Q?A6W0EHIzmE7+sL0LqvA90DPxeUmH3NQ2dvX7kQEaRqwcl5nLGyh8eweP6C?=
 =?iso-8859-1?Q?HGCdme/6mSaopblRcjxWUubWB3SeD9iiJjwHwBPlq/cVmB7s6sEqaoiPJw?=
 =?iso-8859-1?Q?AWGM4u9U48nAh5MDMAnLxTCXcMSWTagSX7MhP6A5as9HjpP/CjKBzip+OV?=
 =?iso-8859-1?Q?3ztS035MIjsO1bWVr0YJlbIgEejLIWy3s48iS7w+QnOJNmj+31jBm6wpoI?=
 =?iso-8859-1?Q?7m2vsI9oGR+D5k+nejKgxdZKCLlemHTGBXIpPMF5vZCPcm5oh8IQsfthJt?=
 =?iso-8859-1?Q?FuVYxAqa3p6nQ2KU7tMORqjWadHc82Hictcc/DSj6hthrSXsvawzHwrEyL?=
 =?iso-8859-1?Q?Um2qMH4kUIB/7Jlwy7b2GGcooTbG+j8iCE8AEGdC68zGzuk/3By4BW3Gsp?=
 =?iso-8859-1?Q?Zag1kfkdgtVw579s++NmgopJKI5KlH2fNqWY1UukqNRpK0gcV+w=3D=3D?=
x-microsoft-antispam-prvs: <DM5PR11MB1436AB8B04FDD613B3BBCA70E84A0@DM5PR11MB1436.namprd11.prod.outlook.com>
x-forefront-prvs: 09752BC779
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(396003)(366004)(136003)(189003)(199004)(3846002)(5660300002)(6116002)(53936002)(36756003)(50226002)(2201001)(8936002)(86362001)(110136005)(8676002)(4326008)(6436002)(68736007)(107886003)(6512007)(53946003)(6486002)(6506007)(81166006)(81156014)(386003)(316002)(30864003)(54906003)(14444005)(66066001)(256004)(186003)(102836004)(26005)(25786009)(305945005)(52116002)(7736002)(99286004)(478600001)(97736004)(72206003)(2616005)(476003)(486006)(2906002)(71200400001)(14454004)(105586002)(71190400001)(106356001)(2501003)(461764006)(579004)(559001)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1436;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FT/oaN6fTIOvROu8T6nx7Z4FZJbPbpKrQCU+TjswzgmbxxcMPOBxDs/BmWy4SVt35vDoQzE+O1yxfoxY68gW5pDFB8SHv7KxQOzOoB+C4JsA8zqnyxJ90Y9fseVjDxXVYYypfwa31zjIfsL81v1JhOGM0YbbnlMSTaAfdC1mxl31luUWXIGYr59Pt5OuWw1TWPKt6XEse1d7alBXfIzilGtFqmF4SJ6SeG38eqJlnlch7Esc3DIyEcUgtaL7Lo7ZWi6cJHbWgrqcpUnXv1NzXoaOKj9eLp2+qF0HDb6RZ8cFpW7PLoBUTG4EY28ySKOOvnGxOwshifGSgs0emyycn/Q6dcKFlm87Qwj3ffxffc+lurhwA5hDVCSb9jDXyfsJfwlL61xYtu27ADrSXS/0e3iIlpH4Gjlu+Y0oID+KLVM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f7407e5e-b241-4a59-3acb-08d6a78505a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2019 07:25:09.2876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1436
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

This change is a redesign in the formats and the way the ISC is
configured w.r.t. sensor format and the output format from the ISC.
I have changed the splitting between sensor output (which is also ISC input=
)
and ISC output.
The sensor format represents the way the sensor is configured, and what ISC
is receiving.
The format configuration represents the way ISC is interpreting the data an=
d
formatting the output to the subsystem.
Now it's much easier to figure out what is the ISC configuration for input,=
 and
what is the configuration for output.
The non-raw format can be obtained directly from sensor or it can be done
inside the ISC. The controller format list will include a configuration for
each format.
The old supported formats are still in place, if we want to dump the sensor
format directly to the output, the try format routine will detect and
configure the pipeline accordingly.
This also fixes the previous issues when the raw format was NULL which
resulted in many crashes for sensors which did not have the expected/tested
formats.

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
---

Hello,

I have changed the try vs set settings, with having another configuration f=
or
try, which will be copied to the actual configuration only after set will
be called.

This patch keeps the original formats. I added a second patch that fixes AR=
GB
format w.r.t. byte endianess inside the format.

Changes in v2:
 - now have try_config and also config, all configuration setting will be d=
one
initially on try_config, and then if everything is OK, in set_fmt, it will =
be
copied to the actual config.
 - changed macro IS_RAW to apply on mbus code and not isc structure, it's n=
ow
called ISC_IS_FORMAT_RAW and it's called everywhere it's needed.
 - renamed all functions for configure modules (dma, rlp, pipeline, formats=
)
with 'try' prefix

tested with sensors ov7670, ov7740, ov5640

v4l2-compliance:

v4l2-compliance SHA: 32cf495ff5da24df54936fae3bf0eb91fba77f3a, 32 bits

Compliance test for atmel_isc device /atmel_deo0:isc f0008000.isc: =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  START STATUS  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
atmel_isc f0008000.isc: Brightness: 0
atmel_isc f0008000.isc: Contrast: 256
atmel_isc f0008000.isc: Gamma: 2

atmeiver Info:
        Driver name      : atmel_isc
        Card type        : Atmel Image Sensor Controller
        Bus info         : platform:atmel_isc f0008000.isc
        Driver version   : 5.0.0
        Capabilities     : 0x84200001
                Video Capture
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps      : 0x04200001
                Video Capture
                Streaming
                Extended Pix Format

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second /dev/video0 open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
l_isc f0008000.isc: White Balance, Automatic: true
atmel_isc f0008000.isc: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  END STATUS  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
        test VIDIOC_LOG_STATUS: OK

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

Control ioctls (Input 0):
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
        test VIDIOC_QUERYCTRL: OK
        test VIDIOC_G/S_CTRL: OK
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 5 Private Controls: 0

Format ioctls (Input 0):
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
        test VIDIOC_G/S_PARM: OK
        test VIDIOC_G_FBUF: OK (Not Supported)
        test VIDIOC_G_FMT: OK
        test VIDIOC_TRY_FMT: OK
        test VIDIOC_S_FMT: OK
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
        test Cropping: OK (Not Supported)
        test Composing: OK (Not Supported)
        test Scaling: OK (Not Supported)

Codec ioctls (Input 0):
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
        test VIDIOC_EXPBUF: OK
        test Requests: OK (Not Supported)

Total for atmel_isc device /dev/video0: 44, Succeeded: 44, Failed: 0, Warni=
ngs: 0


 drivers/media/platform/atmel/atmel-isc.c | 888 ++++++++++++++++-----------=
----
 1 file changed, 471 insertions(+), 417 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platf=
orm/atmel/atmel-isc.c
index 5017896..f4ecb24 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -89,35 +89,25 @@ struct isc_subdev_entity {
 	struct list_head list;
 };
=20
-/* Indicate the format is generated by the sensor */
-#define FMT_FLAG_FROM_SENSOR		BIT(0)
-/* Indicate the format is produced by ISC itself */
-#define FMT_FLAG_FROM_CONTROLLER	BIT(1)
-/* Indicate a Raw Bayer format */
-#define FMT_FLAG_RAW_FORMAT		BIT(2)
-
-#define FMT_FLAG_RAW_FROM_SENSOR	(FMT_FLAG_FROM_SENSOR | \
-					 FMT_FLAG_RAW_FORMAT)
-
 /*
  * struct isc_format - ISC media bus format information
+			This structure represents the interface between the ISC
+			and the sensor. It's the input format received by
+			the ISC.
  * @fourcc:		Fourcc code for this format
  * @mbus_code:		V4L2 media bus format code.
- * flags:		Indicate format from sensor or converted by controller
- * @bpp:		Bits per pixel (when stored in memory)
- *			(when transferred over a bus)
- * @sd_support:		Subdev supports this format
- * @isc_support:	ISC can convert raw format to this format
+ * @cfa_baycfg:		If this format is RAW BAYER, indicate the type of bayer.
+			this is either BGBG, RGRG, etc.
+ * @pfe_cfg0_bps:	Number of hardware data lines connected to the ISC
  */
=20
 struct isc_format {
 	u32	fourcc;
 	u32	mbus_code;
-	u32	flags;
-	u8	bpp;
+	u32	cfa_baycfg;
=20
 	bool	sd_support;
-	bool	isc_support;
+	u32	pfe_cfg0_bps;
 };
=20
 /* Pipeline bitmap */
@@ -135,16 +125,31 @@ struct isc_format {
=20
 #define GAM_ENABLES	(GAM_RENABLE | GAM_GENABLE | GAM_BENABLE | GAM_ENABLE)
=20
+/*
+ * struct fmt_config - ISC format configuration and internal pipeline
+			This structure represents the internal configuration
+			of the ISC.
+			It also holds the format that ISC will present to v4l2.
+ * @sd_format:		Pointer to an isc_format struct that holds the sensor
+			configuration.
+ * @fourcc:		Fourcc code for this format.
+ * @bpp:		Bytes per pixel in the current format.
+ * @rlp_cfg_mode:	Configuration of the RLP (rounding, limiting packaging)
+ * @dcfg_imode:		Configuration of the input of the DMA module
+ * @dctrl_dview:	Configuration of the output of the DMA module
+ * @bits_pipeline:	Configuration of the pipeline, which modules are enable=
d
+ */
 struct fmt_config {
-	u32	fourcc;
+	struct isc_format	*sd_format;
=20
-	u32	pfe_cfg0_bps;
-	u32	cfa_baycfg;
-	u32	rlp_cfg_mode;
-	u32	dcfg_imode;
-	u32	dctrl_dview;
+	u32			fourcc;
+	u8			bpp;
=20
-	u32	bits_pipeline;
+	u32			rlp_cfg_mode;
+	u32			dcfg_imode;
+	u32			dctrl_dview;
+
+	u32			bits_pipeline;
 };
=20
 #define HIST_ENTRIES		512
@@ -196,8 +201,9 @@ struct isc_device {
 	struct v4l2_format	fmt;
 	struct isc_format	**user_formats;
 	unsigned int		num_user_formats;
-	const struct isc_format	*current_fmt;
-	const struct isc_format	*raw_fmt;
+
+	struct fmt_config	config;
+	struct fmt_config	try_config;
=20
 	struct isc_ctrls	ctrls;
 	struct work_struct	awb_work;
@@ -210,319 +216,122 @@ struct isc_device {
 	struct list_head		subdev_entities;
 };
=20
-static struct isc_format formats_list[] =3D {
-	{
-		.fourcc		=3D V4L2_PIX_FMT_SBGGR8,
-		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR8_1X8,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 8,
-	},
+/* This is a list of the formats that the ISC can *output* */
+static struct isc_format controller_formats[] =3D {
 	{
-		.fourcc		=3D V4L2_PIX_FMT_SGBRG8,
-		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG8_1X8,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 8,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_SGRBG8,
-		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG8_1X8,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 8,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_SRGGB8,
-		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB8_1X8,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 8,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_SBGGR10,
-		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR10_1X10,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 16,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_SGBRG10,
-		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG10_1X10,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 16,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_SGRBG10,
-		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG10_1X10,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 16,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_SRGGB10,
-		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB10_1X10,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 16,
+		.fourcc		=3D V4L2_PIX_FMT_ARGB444,
 	},
 	{
-		.fourcc		=3D V4L2_PIX_FMT_SBGGR12,
-		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR12_1X12,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 16,
+		.fourcc		=3D V4L2_PIX_FMT_ARGB555,
 	},
 	{
-		.fourcc		=3D V4L2_PIX_FMT_SGBRG12,
-		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG12_1X12,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 16,
+		.fourcc		=3D V4L2_PIX_FMT_RGB565,
 	},
 	{
-		.fourcc		=3D V4L2_PIX_FMT_SGRBG12,
-		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG12_1X12,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 16,
+		.fourcc		=3D V4L2_PIX_FMT_ARGB32,
 	},
 	{
-		.fourcc		=3D V4L2_PIX_FMT_SRGGB12,
-		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB12_1X12,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 16,
+		.fourcc		=3D V4L2_PIX_FMT_YUV420,
 	},
 	{
-		.fourcc		=3D V4L2_PIX_FMT_YUV420,
-		.mbus_code	=3D 0x0,
-		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
-		.bpp		=3D 12,
+		.fourcc		=3D V4L2_PIX_FMT_YUYV,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_YUV422P,
-		.mbus_code	=3D 0x0,
-		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
-		.bpp		=3D 16,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_GREY,
-		.mbus_code	=3D MEDIA_BUS_FMT_Y8_1X8,
-		.flags		=3D FMT_FLAG_FROM_CONTROLLER |
-				  FMT_FLAG_FROM_SENSOR,
-		.bpp		=3D 8,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_ARGB444,
-		.mbus_code	=3D MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
-		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
-		.bpp		=3D 16,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_ARGB555,
-		.mbus_code	=3D MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
-		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
-		.bpp		=3D 16,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_RGB565,
-		.mbus_code	=3D MEDIA_BUS_FMT_RGB565_2X8_LE,
-		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
-		.bpp		=3D 16,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_ARGB32,
-		.mbus_code	=3D MEDIA_BUS_FMT_ARGB8888_1X32,
-		.flags		=3D FMT_FLAG_FROM_CONTROLLER,
-		.bpp		=3D 32,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_YUYV,
-		.mbus_code	=3D MEDIA_BUS_FMT_YUYV8_2X8,
-		.flags		=3D FMT_FLAG_FROM_CONTROLLER |
-				  FMT_FLAG_FROM_SENSOR,
-		.bpp		=3D 16,
 	},
 };
=20
-static struct fmt_config fmt_configs_list[] =3D {
+/* This is a list of formats that the ISC can receive as *input* */
+static struct isc_format formats_list[] =3D {
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SBGGR8,
+		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR8_1X8,
 		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
 		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT8,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SGBRG8,
+		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG8_1X8,
 		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
 		.cfa_baycfg	=3D ISC_BAY_CFG_GBGB,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT8,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SGRBG8,
+		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG8_1X8,
 		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
 		.cfa_baycfg	=3D ISC_BAY_CFG_GRGR,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT8,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SRGGB8,
+		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB8_1X8,
 		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
 		.cfa_baycfg	=3D ISC_BAY_CFG_RGRG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT8,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SBGGR10,
+		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR10_1X10,
 		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TEN,
-		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT10,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
+		.cfa_baycfg	=3D ISC_BAY_CFG_RGRG,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SGBRG10,
+		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG10_1X10,
 		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TEN,
 		.cfa_baycfg	=3D ISC_BAY_CFG_GBGB,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT10,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SGRBG10,
+		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG10_1X10,
 		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TEN,
 		.cfa_baycfg	=3D ISC_BAY_CFG_GRGR,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT10,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SRGGB10,
+		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB10_1X10,
 		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TEN,
 		.cfa_baycfg	=3D ISC_BAY_CFG_RGRG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT10,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SBGGR12,
+		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR12_1X12,
 		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TWELVE,
 		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT12,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SGBRG12,
+		.mbus_code	=3D MEDIA_BUS_FMT_SGBRG12_1X12,
 		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TWELVE,
 		.cfa_baycfg	=3D ISC_BAY_CFG_GBGB,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT12,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SGRBG12,
+		.mbus_code	=3D MEDIA_BUS_FMT_SGRBG12_1X12,
 		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TWELVE,
 		.cfa_baycfg	=3D ISC_BAY_CFG_GRGR,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT12,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_SRGGB12,
+		.mbus_code	=3D MEDIA_BUS_FMT_SRGGB12_1X12,
 		.pfe_cfg0_bps	=3D ISC_PFG_CFG0_BPS_TWELVE,
 		.cfa_baycfg	=3D ISC_BAY_CFG_RGRG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT12,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0,
-	},
-	{
-		.fourcc =3D V4L2_PIX_FMT_YUV420,
-		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
-		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_YYCC,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_YC420P,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PLANAR,
-		.bits_pipeline	=3D SUB420_ENABLE | SUB422_ENABLE |
-				  CBC_ENABLE | CSC_ENABLE |
-				  GAM_ENABLES |
-				  CFA_ENABLE | WB_ENABLE,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_YUV422P,
-		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
-		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_YYCC,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_YC422P,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PLANAR,
-		.bits_pipeline	=3D SUB422_ENABLE |
-				  CBC_ENABLE | CSC_ENABLE |
-				  GAM_ENABLES |
-				  CFA_ENABLE | WB_ENABLE,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_GREY,
+		.mbus_code	=3D MEDIA_BUS_FMT_Y8_1X8,
 		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
-		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DATY8,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D CBC_ENABLE | CSC_ENABLE |
-				  GAM_ENABLES |
-				  CFA_ENABLE | WB_ENABLE,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_ARGB444,
-		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
-		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_ARGB444,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
 	},
 	{
-		.fourcc		=3D V4L2_PIX_FMT_ARGB555,
+		.fourcc		=3D V4L2_PIX_FMT_YUYV,
+		.mbus_code	=3D MEDIA_BUS_FMT_YUYV8_2X8,
 		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
-		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_ARGB555,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_RGB565,
+		.mbus_code	=3D MEDIA_BUS_FMT_RGB565_2X8_LE,
 		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
-		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_RGB565,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED16,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_ARGB32,
-		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
-		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_ARGB32,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED32,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
-	},
-	{
-		.fourcc		=3D V4L2_PIX_FMT_YUYV,
-		.pfe_cfg0_bps	=3D ISC_PFE_CFG0_BPS_EIGHT,
-		.cfa_baycfg	=3D ISC_BAY_CFG_BGBG,
-		.rlp_cfg_mode	=3D ISC_RLP_CFG_MODE_DAT8,
-		.dcfg_imode	=3D ISC_DCFG_IMODE_PACKED8,
-		.dctrl_dview	=3D ISC_DCTRL_DVIEW_PACKED,
-		.bits_pipeline	=3D 0x0
 	},
 };
=20
@@ -571,6 +380,13 @@ static const u32 isc_gamma_table[GAMMA_MAX + 1][GAMMA_=
ENTRIES] =3D {
 	  0x3E20007, 0x3E90007, 0x3F00008, 0x3F80007 },
 };
=20
+#define ISC_IS_FORMAT_RAW(mbus_code) \
+	(((mbus_code) & 0xf000) =3D=3D 0x3000)
+
+static unsigned int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level (0-2)");
+
 static unsigned int sensor_preferred =3D 1;
 module_param(sensor_preferred, uint, 0644);
 MODULE_PARM_DESC(sensor_preferred,
@@ -896,40 +712,17 @@ static int isc_buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
=20
-static inline bool sensor_is_preferred(const struct isc_format *isc_fmt)
-{
-	return (sensor_preferred && isc_fmt->sd_support) ||
-		!isc_fmt->isc_support;
-}
-
-static struct fmt_config *get_fmt_config(u32 fourcc)
-{
-	struct fmt_config *config;
-	int i;
-
-	config =3D &fmt_configs_list[0];
-	for (i =3D 0; i < ARRAY_SIZE(fmt_configs_list); i++) {
-		if (config->fourcc =3D=3D fourcc)
-			return config;
-
-		config++;
-	}
-	return NULL;
-}
-
 static void isc_start_dma(struct isc_device *isc)
 {
 	struct regmap *regmap =3D isc->regmap;
-	struct v4l2_pix_format *pixfmt =3D &isc->fmt.fmt.pix;
-	u32 sizeimage =3D pixfmt->sizeimage;
-	struct fmt_config *config =3D get_fmt_config(isc->current_fmt->fourcc);
+	u32 sizeimage =3D isc->fmt.fmt.pix.sizeimage;
 	u32 dctrl_dview;
 	dma_addr_t addr0;
=20
 	addr0 =3D vb2_dma_contig_plane_dma_addr(&isc->cur_frm->vb.vb2_buf, 0);
 	regmap_write(regmap, ISC_DAD0, addr0);
=20
-	switch (pixfmt->pixelformat) {
+	switch (isc->config.fourcc) {
 	case V4L2_PIX_FMT_YUV420:
 		regmap_write(regmap, ISC_DAD1, addr0 + (sizeimage * 2) / 3);
 		regmap_write(regmap, ISC_DAD2, addr0 + (sizeimage * 5) / 6);
@@ -942,10 +735,7 @@ static void isc_start_dma(struct isc_device *isc)
 		break;
 	}
=20
-	if (sensor_is_preferred(isc->current_fmt))
-		dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
-	else
-		dctrl_dview =3D config->dctrl_dview;
+	dctrl_dview =3D isc->config.dctrl_dview;
=20
 	regmap_write(regmap, ISC_DCTRL, dctrl_dview | ISC_DCTRL_IE_IS);
 	regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_CAPTURE);
@@ -955,7 +745,6 @@ static void isc_set_pipeline(struct isc_device *isc, u3=
2 pipeline)
 {
 	struct regmap *regmap =3D isc->regmap;
 	struct isc_ctrls *ctrls =3D &isc->ctrls;
-	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
 	u32 val, bay_cfg;
 	const u32 *gamma;
 	unsigned int i;
@@ -969,7 +758,7 @@ static void isc_set_pipeline(struct isc_device *isc, u3=
2 pipeline)
 	if (!pipeline)
 		return;
=20
-	bay_cfg =3D config->cfa_baycfg;
+	bay_cfg =3D isc->config.sd_format->cfa_baycfg;
=20
 	regmap_write(regmap, ISC_WB_CFG, bay_cfg);
 	regmap_write(regmap, ISC_WB_O_RGR, 0x0);
@@ -1011,24 +800,24 @@ static int isc_update_profile(struct isc_device *isc=
)
 	}
=20
 	if (counter < 0) {
-		v4l2_warn(&isc->v4l2_dev, "Time out to update profie\n");
+		v4l2_warn(&isc->v4l2_dev, "Time out to update profile\n");
 		return -ETIMEDOUT;
 	}
=20
 	return 0;
 }
=20
-static void isc_set_histogram(struct isc_device *isc)
+static void isc_set_histogram(struct isc_device *isc, bool enable)
 {
 	struct regmap *regmap =3D isc->regmap;
 	struct isc_ctrls *ctrls =3D &isc->ctrls;
-	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
=20
-	if (ctrls->awb && (ctrls->hist_stat !=3D HIST_ENABLED)) {
+	if (enable) {
 		regmap_write(regmap, ISC_HIS_CFG,
 			     ISC_HIS_CFG_MODE_R |
-			     (config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT) |
-			     ISC_HIS_CFG_RAR);
+			     (isc->config.sd_format->cfa_baycfg
+					<< ISC_HIS_CFG_BAYSEL_SHIFT) |
+					ISC_HIS_CFG_RAR);
 		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_EN);
 		regmap_write(regmap, ISC_INTEN, ISC_INT_HISDONE);
 		ctrls->hist_id =3D ISC_HIS_CFG_MODE_R;
@@ -1036,7 +825,7 @@ static void isc_set_histogram(struct isc_device *isc)
 		regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
=20
 		ctrls->hist_stat =3D HIST_ENABLED;
-	} else if (!ctrls->awb && (ctrls->hist_stat !=3D HIST_DISABLED)) {
+	} else {
 		regmap_write(regmap, ISC_INTDIS, ISC_INT_HISDONE);
 		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_DIS);
=20
@@ -1044,53 +833,18 @@ static void isc_set_histogram(struct isc_device *isc=
)
 	}
 }
=20
-static inline void isc_get_param(const struct isc_format *fmt,
-				 u32 *rlp_mode, u32 *dcfg)
-{
-	struct fmt_config *config =3D get_fmt_config(fmt->fourcc);
-
-	*dcfg =3D ISC_DCFG_YMBSIZE_BEATS8;
-
-	switch (fmt->fourcc) {
-	case V4L2_PIX_FMT_SBGGR10:
-	case V4L2_PIX_FMT_SGBRG10:
-	case V4L2_PIX_FMT_SGRBG10:
-	case V4L2_PIX_FMT_SRGGB10:
-	case V4L2_PIX_FMT_SBGGR12:
-	case V4L2_PIX_FMT_SGBRG12:
-	case V4L2_PIX_FMT_SGRBG12:
-	case V4L2_PIX_FMT_SRGGB12:
-		*rlp_mode =3D config->rlp_cfg_mode;
-		*dcfg |=3D config->dcfg_imode;
-		break;
-	default:
-		*rlp_mode =3D ISC_RLP_CFG_MODE_DAT8;
-		*dcfg |=3D ISC_DCFG_IMODE_PACKED8;
-		break;
-	}
-}
-
 static int isc_configure(struct isc_device *isc)
 {
 	struct regmap *regmap =3D isc->regmap;
-	const struct isc_format *current_fmt =3D isc->current_fmt;
-	struct fmt_config *curfmt_config =3D get_fmt_config(current_fmt->fourcc);
-	struct fmt_config *rawfmt_config =3D get_fmt_config(isc->raw_fmt->fourcc)=
;
-	struct isc_subdev_entity *subdev =3D isc->current_subdev;
 	u32 pfe_cfg0, rlp_mode, dcfg, mask, pipeline;
+	struct isc_subdev_entity *subdev =3D isc->current_subdev;
=20
-	if (sensor_is_preferred(current_fmt)) {
-		pfe_cfg0 =3D curfmt_config->pfe_cfg0_bps;
-		pipeline =3D 0x0;
-		isc_get_param(current_fmt, &rlp_mode, &dcfg);
-		isc->ctrls.hist_stat =3D HIST_INIT;
-	} else {
-		pfe_cfg0 =3D rawfmt_config->pfe_cfg0_bps;
-		pipeline =3D curfmt_config->bits_pipeline;
-		rlp_mode =3D curfmt_config->rlp_cfg_mode;
-		dcfg =3D curfmt_config->dcfg_imode |
+	pfe_cfg0 =3D isc->config.sd_format->pfe_cfg0_bps;
+	rlp_mode =3D isc->config.rlp_cfg_mode;
+	pipeline =3D isc->config.bits_pipeline;
+
+	dcfg =3D isc->config.dcfg_imode |
 		       ISC_DCFG_YMBSIZE_BEATS8 | ISC_DCFG_CMBSIZE_BEATS8;
-	}
=20
 	pfe_cfg0  |=3D subdev->pfe_cfg0 | ISC_PFE_CFG0_MODE_PROGRESSIVE;
 	mask =3D ISC_PFE_CFG0_BPS_MASK | ISC_PFE_CFG0_HPOL_LOW |
@@ -1107,8 +861,15 @@ static int isc_configure(struct isc_device *isc)
 	/* Set the pipeline */
 	isc_set_pipeline(isc, pipeline);
=20
-	if (pipeline)
-		isc_set_histogram(isc);
+	/*
+	 * The current implemented histogram is available for RAW R, B, GB
+	 * channels. We need to check if sensor is outputting RAW BAYER
+	 */
+	if (isc->ctrls.awb &&
+	    ISC_IS_FORMAT_RAW(isc->config.sd_format->mbus_code))
+		isc_set_histogram(isc, true);
+	else
+		isc_set_histogram(isc, false);
=20
 	/* Update profile */
 	return isc_update_profile(isc);
@@ -1125,7 +886,8 @@ static int isc_start_streaming(struct vb2_queue *vq, u=
nsigned int count)
 	/* Enable stream on the sub device */
 	ret =3D v4l2_subdev_call(isc->current_subdev->sd, video, s_stream, 1);
 	if (ret && ret !=3D -ENOIOCTLCMD) {
-		v4l2_err(&isc->v4l2_dev, "stream on failed in subdev\n");
+		v4l2_err(&isc->v4l2_dev, "stream on failed in subdev %d\n",
+			 ret);
 		goto err_start_stream;
 	}
=20
@@ -1223,6 +985,22 @@ static void isc_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
 }
=20
+static struct isc_format *find_format_by_fourcc(struct isc_device *isc,
+						 unsigned int fourcc)
+{
+	unsigned int num_formats =3D isc->num_user_formats;
+	struct isc_format *fmt;
+	unsigned int i;
+
+	for (i =3D 0; i < num_formats; i++) {
+		fmt =3D isc->user_formats[i];
+		if (fmt->fourcc =3D=3D fourcc)
+			return fmt;
+	}
+
+	return NULL;
+}
+
 static const struct vb2_ops isc_vb2_ops =3D {
 	.queue_setup		=3D isc_queue_setup,
 	.wait_prepare		=3D vb2_ops_wait_prepare,
@@ -1249,15 +1027,31 @@ static int isc_querycap(struct file *file, void *pr=
iv,
 static int isc_enum_fmt_vid_cap(struct file *file, void *priv,
 				 struct v4l2_fmtdesc *f)
 {
-	struct isc_device *isc =3D video_drvdata(file);
 	u32 index =3D f->index;
+	u32 i, supported_index;
=20
-	if (index >=3D isc->num_user_formats)
-		return -EINVAL;
+	if (index < ARRAY_SIZE(controller_formats)) {
+		f->pixelformat =3D controller_formats[index].fourcc;
+		return 0;
+	}
=20
-	f->pixelformat =3D isc->user_formats[index]->fourcc;
+	index -=3D ARRAY_SIZE(controller_formats);
=20
-	return 0;
+	i =3D 0;
+	supported_index =3D 0;
+
+	for (i =3D 0; i < ARRAY_SIZE(formats_list); i++) {
+		if (!ISC_IS_FORMAT_RAW(formats_list[i].mbus_code) ||
+		    !formats_list[i].sd_support)
+			continue;
+		if (supported_index =3D=3D index) {
+			f->pixelformat =3D formats_list[i].fourcc;
+			return 0;
+		}
+		supported_index++;
+	}
+
+	return -EINVAL;
 }
=20
 static int isc_g_fmt_vid_cap(struct file *file, void *priv,
@@ -1270,26 +1064,231 @@ static int isc_g_fmt_vid_cap(struct file *file, vo=
id *priv,
 	return 0;
 }
=20
-static struct isc_format *find_format_by_fourcc(struct isc_device *isc,
-						 unsigned int fourcc)
+/*
+ * Checks the current configured format, if ISC can output it,
+ * considering which type of format the ISC receives from the sensor
+ */
+static int isc_try_validate_formats(struct isc_device *isc)
 {
-	unsigned int num_formats =3D isc->num_user_formats;
-	struct isc_format *fmt;
-	unsigned int i;
+	int ret;
+	bool bayer =3D false, yuv =3D false, rgb =3D false, grey =3D false;
+
+	/* all formats supported by the RLP module are OK */
+	switch (isc->try_config.fourcc) {
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SRGGB10:
+	case V4L2_PIX_FMT_SBGGR12:
+	case V4L2_PIX_FMT_SGBRG12:
+	case V4L2_PIX_FMT_SGRBG12:
+	case V4L2_PIX_FMT_SRGGB12:
+		ret =3D 0;
+		bayer =3D true;
+		break;
=20
-	for (i =3D 0; i < num_formats; i++) {
-		fmt =3D isc->user_formats[i];
-		if (fmt->fourcc =3D=3D fourcc)
-			return fmt;
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_YUYV:
+		ret =3D 0;
+		yuv =3D true;
+		break;
+
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_ARGB32:
+	case V4L2_PIX_FMT_ARGB444:
+	case V4L2_PIX_FMT_ARGB555:
+		ret =3D 0;
+		rgb =3D true;
+		break;
+	case V4L2_PIX_FMT_GREY:
+		ret =3D 0;
+		grey =3D true;
+		break;
+	default:
+	/* any other different formats are not supported */
+		ret =3D -EINVAL;
 	}
=20
-	return NULL;
+	/* we cannot output RAW/Grey if we do not receive RAW */
+	if ((bayer || grey) &&
+	    !ISC_IS_FORMAT_RAW(isc->try_config.sd_format->mbus_code))
+		return -EINVAL;
+
+	return ret;
+}
+
+/*
+ * Configures the RLP and DMA modules, depending on the output format
+ * configured for the ISC.
+ * If direct_dump =3D=3D true, just dump raw data 8 bits.
+ */
+static int isc_try_configure_rlp_dma(struct isc_device *isc, bool direct_d=
ump)
+{
+	if (direct_dump) {
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT8;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED8;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->try_config.bpp =3D 16;
+		return 0;
+	}
+
+	switch (isc->try_config.fourcc) {
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT8;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED8;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->try_config.bpp =3D 8;
+		break;
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SRGGB10:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT10;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->try_config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_SBGGR12:
+	case V4L2_PIX_FMT_SGBRG12:
+	case V4L2_PIX_FMT_SGRBG12:
+	case V4L2_PIX_FMT_SRGGB12:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT12;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->try_config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_RGB565;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->try_config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_ARGB444:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_ARGB444;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->try_config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_ARGB555:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_ARGB555;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->try_config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_ARGB32:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_ARGB32;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED32;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->try_config.bpp =3D 32;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_YYCC;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_YC420P;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PLANAR;
+		isc->try_config.bpp =3D 12;
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_YYCC;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_YC422P;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PLANAR;
+		isc->try_config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_YYCC;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED32;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->try_config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_GREY:
+		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DATY8;
+		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED8;
+		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->try_config.bpp =3D 8;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * Configuring pipeline modules, depending on which format the ISC outputs
+ * and considering which format it has as input from the sensor.
+ */
+static int isc_try_configure_pipeline(struct isc_device *isc)
+{
+	switch (isc->try_config.fourcc) {
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_ARGB555:
+	case V4L2_PIX_FMT_ARGB444:
+	case V4L2_PIX_FMT_ARGB32:
+		/* if sensor format is RAW, we convert inside ISC */
+		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format->mbus_code)) {
+			isc->try_config.bits_pipeline =3D CFA_ENABLE |
+				WB_ENABLE | GAM_ENABLES;
+		} else {
+			isc->try_config.bits_pipeline =3D 0x0;
+		}
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		/* if sensor format is RAW, we convert inside ISC */
+		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format->mbus_code)) {
+			isc->try_config.bits_pipeline =3D CFA_ENABLE |
+				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
+				SUB420_ENABLE | SUB422_ENABLE | CBC_ENABLE;
+		} else {
+			isc->try_config.bits_pipeline =3D 0x0;
+		}
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		/* if sensor format is RAW, we convert inside ISC */
+		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format->mbus_code)) {
+			isc->try_config.bits_pipeline =3D CFA_ENABLE |
+				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
+				SUB422_ENABLE | CBC_ENABLE;
+		} else {
+			isc->try_config.bits_pipeline =3D 0x0;
+		}
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		/* if sensor format is RAW, we convert inside ISC */
+		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format->mbus_code)) {
+			isc->try_config.bits_pipeline =3D CFA_ENABLE |
+				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
+				SUB422_ENABLE | CBC_ENABLE;
+		} else {
+			isc->try_config.bits_pipeline =3D 0x0;
+		}
+		break;
+	case V4L2_PIX_FMT_GREY:
+		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format->mbus_code)) {
+		/* if sensor format is RAW, we convert inside ISC */
+			isc->try_config.bits_pipeline =3D CFA_ENABLE |
+				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
+				CBC_ENABLE;
+		} else {
+			isc->try_config.bits_pipeline =3D 0x0;
+		}
+		break;
+	default:
+		isc->try_config.bits_pipeline =3D 0x0;
+	}
+	return 0;
 }
=20
 static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
-			struct isc_format **current_fmt, u32 *code)
+			u32 *code)
 {
-	struct isc_format *isc_fmt;
+	int i;
+	struct isc_format *sd_fmt =3D NULL, *direct_fmt =3D NULL;
 	struct v4l2_pix_format *pixfmt =3D &f->fmt.pix;
 	struct v4l2_subdev_pad_config pad_cfg;
 	struct v4l2_subdev_format format =3D {
@@ -1297,48 +1296,114 @@ static int isc_try_fmt(struct isc_device *isc, str=
uct v4l2_format *f,
 	};
 	u32 mbus_code;
 	int ret;
+	bool rlp_dma_direct_dump =3D false;
=20
 	if (f->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
=20
-	isc_fmt =3D find_format_by_fourcc(isc, pixfmt->pixelformat);
-	if (!isc_fmt) {
-		v4l2_warn(&isc->v4l2_dev, "Format 0x%x not found\n",
-			  pixfmt->pixelformat);
-		isc_fmt =3D isc->user_formats[isc->num_user_formats - 1];
-		pixfmt->pixelformat =3D isc_fmt->fourcc;
+	/* Step 1: find a RAW format that is supported */
+	for (i =3D 0; i < isc->num_user_formats; i++) {
+		if (ISC_IS_FORMAT_RAW(isc->user_formats[i]->mbus_code)) {
+			sd_fmt =3D isc->user_formats[i];
+			break;
+		}
+	}
+	/* Step 2: We can continue with this RAW format, or we can look
+	 * for better: maybe sensor supports directly what we need.
+	 */
+	direct_fmt =3D find_format_by_fourcc(isc, pixfmt->pixelformat);
+
+	/* Step 3: We have both. We decide given the module parameter which
+	 * one to use.
+	 */
+	if (direct_fmt && sd_fmt && sensor_preferred)
+		sd_fmt =3D direct_fmt;
+
+	/* Step 4: we do not have RAW but we have a direct format. Use it. */
+	if (direct_fmt && !sd_fmt)
+		sd_fmt =3D direct_fmt;
+
+	/* Step 5: if we are using a direct format, we need to package
+	 * everything as 8 bit data and just dump it
+	 */
+	if (sd_fmt =3D=3D direct_fmt)
+		rlp_dma_direct_dump =3D true;
+
+	/* Step 6: We have no format. This can happen if the userspace
+	 * requests some weird/invalid format.
+	 * In this case, default to whatever we have
+	 */
+	if (!sd_fmt && !direct_fmt) {
+		sd_fmt =3D isc->user_formats[isc->num_user_formats - 1];
+		v4l2_dbg(1, debug, &isc->v4l2_dev,
+			 "Sensor not supporting %.4s, using %.4s\n",
+			 (char *)&pixfmt->pixelformat, (char *)&sd_fmt->fourcc);
 	}
=20
+	/* Step 7: Print out what we decided for debugging */
+	v4l2_dbg(1, debug, &isc->v4l2_dev,
+		 "Preferring to have sensor using format %.4s\n",
+		 (char *)&sd_fmt->fourcc);
+
+	/* Step 8: at this moment we decided which format the subdev will use */
+	isc->try_config.sd_format =3D sd_fmt;
+
 	/* Limit to Atmel ISC hardware capabilities */
 	if (pixfmt->width > ISC_MAX_SUPPORT_WIDTH)
 		pixfmt->width =3D ISC_MAX_SUPPORT_WIDTH;
 	if (pixfmt->height > ISC_MAX_SUPPORT_HEIGHT)
 		pixfmt->height =3D ISC_MAX_SUPPORT_HEIGHT;
=20
-	if (sensor_is_preferred(isc_fmt))
-		mbus_code =3D isc_fmt->mbus_code;
-	else
-		mbus_code =3D isc->raw_fmt->mbus_code;
+	/*
+	 * The mbus format is the one the subdev outputs.
+	 * The pixels will be transferred in this format Sensor -> ISC
+	 */
+	mbus_code =3D sd_fmt->mbus_code;
+
+	/*
+	 * Validate formats. If the required format is not OK, default to raw.
+	 */
+
+	isc->try_config.fourcc =3D pixfmt->pixelformat;
+
+	if (isc_try_validate_formats(isc)) {
+		pixfmt->pixelformat =3D isc->try_config.fourcc =3D sd_fmt->fourcc;
+		/* This should be redundant, format should be supported */
+		ret =3D isc_try_validate_formats(isc);
+		if (ret)
+			goto isc_try_fmt_err;
+	}
+
+	ret =3D isc_try_configure_rlp_dma(isc, rlp_dma_direct_dump);
+	if (ret)
+		goto isc_try_fmt_err;
+
+	ret =3D isc_try_configure_pipeline(isc);
+	if (ret)
+		goto isc_try_fmt_err;
=20
 	v4l2_fill_mbus_format(&format.format, pixfmt, mbus_code);
 	ret =3D v4l2_subdev_call(isc->current_subdev->sd, pad, set_fmt,
 			       &pad_cfg, &format);
 	if (ret < 0)
-		return ret;
+		goto isc_try_fmt_err;
=20
 	v4l2_fill_pix_format(pixfmt, &format.format);
=20
 	pixfmt->field =3D V4L2_FIELD_NONE;
-	pixfmt->bytesperline =3D (pixfmt->width * isc_fmt->bpp) >> 3;
+	pixfmt->bytesperline =3D (pixfmt->width * isc->try_config.bpp) >> 3;
 	pixfmt->sizeimage =3D pixfmt->bytesperline * pixfmt->height;
=20
-	if (current_fmt)
-		*current_fmt =3D isc_fmt;
-
 	if (code)
 		*code =3D mbus_code;
=20
 	return 0;
+
+isc_try_fmt_err:
+	v4l2_err(&isc->v4l2_dev, "Could not find any possible format for a workin=
g pipeline\n");
+	memset(&isc->try_config, 0, sizeof(isc->try_config));
+
+	return ret;
 }
=20
 static int isc_set_fmt(struct isc_device *isc, struct v4l2_format *f)
@@ -1346,11 +1411,10 @@ static int isc_set_fmt(struct isc_device *isc, stru=
ct v4l2_format *f)
 	struct v4l2_subdev_format format =3D {
 		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
-	struct isc_format *current_fmt;
-	u32 mbus_code;
+	u32 mbus_code =3D 0;
 	int ret;
=20
-	ret =3D isc_try_fmt(isc, f, &current_fmt, &mbus_code);
+	ret =3D isc_try_fmt(isc, f, &mbus_code);
 	if (ret)
 		return ret;
=20
@@ -1361,7 +1425,10 @@ static int isc_set_fmt(struct isc_device *isc, struc=
t v4l2_format *f)
 		return ret;
=20
 	isc->fmt =3D *f;
-	isc->current_fmt =3D current_fmt;
+	/* make the try configuration active */
+	memcpy(&isc->config, &isc->try_config, sizeof(isc->config));
+
+	v4l2_dbg(1, debug, &isc->v4l2_dev, "New ISC configuration in place\n");
=20
 	return 0;
 }
@@ -1382,7 +1449,7 @@ static int isc_try_fmt_vid_cap(struct file *file, voi=
d *priv,
 {
 	struct isc_device *isc =3D video_drvdata(file);
=20
-	return isc_try_fmt(isc, f, NULL, NULL);
+	return isc_try_fmt(isc, f, NULL);
 }
=20
 static int isc_enum_input(struct file *file, void *priv,
@@ -1431,27 +1498,31 @@ static int isc_enum_framesizes(struct file *file, v=
oid *fh,
 			       struct v4l2_frmsizeenum *fsize)
 {
 	struct isc_device *isc =3D video_drvdata(file);
-	const struct isc_format *isc_fmt;
 	struct v4l2_subdev_frame_size_enum fse =3D {
 		.index =3D fsize->index,
 		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
-	int ret;
+	int ret =3D -EINVAL;
+	int i;
=20
-	isc_fmt =3D find_format_by_fourcc(isc, fsize->pixel_format);
-	if (!isc_fmt)
-		return -EINVAL;
+	for (i =3D 0; i < isc->num_user_formats; i++)
+		if (isc->user_formats[i]->fourcc =3D=3D fsize->pixel_format)
+			ret =3D 0;
=20
-	if (sensor_is_preferred(isc_fmt))
-		fse.code =3D isc_fmt->mbus_code;
-	else
-		fse.code =3D isc->raw_fmt->mbus_code;
+	for (i =3D 0; i < ARRAY_SIZE(controller_formats); i++)
+		if (controller_formats[i].fourcc =3D=3D fsize->pixel_format)
+			ret =3D 0;
+
+	if (ret)
+		return ret;
=20
 	ret =3D v4l2_subdev_call(isc->current_subdev->sd, pad, enum_frame_size,
 			       NULL, &fse);
 	if (ret)
 		return ret;
=20
+	fse.code =3D isc->config.sd_format->mbus_code;
+
 	fsize->type =3D V4L2_FRMSIZE_TYPE_DISCRETE;
 	fsize->discrete.width =3D fse.max_width;
 	fsize->discrete.height =3D fse.max_height;
@@ -1463,29 +1534,32 @@ static int isc_enum_frameintervals(struct file *fil=
e, void *fh,
 				    struct v4l2_frmivalenum *fival)
 {
 	struct isc_device *isc =3D video_drvdata(file);
-	const struct isc_format *isc_fmt;
 	struct v4l2_subdev_frame_interval_enum fie =3D {
 		.index =3D fival->index,
 		.width =3D fival->width,
 		.height =3D fival->height,
 		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
-	int ret;
+	int ret =3D -EINVAL;
+	int i;
=20
-	isc_fmt =3D find_format_by_fourcc(isc, fival->pixel_format);
-	if (!isc_fmt)
-		return -EINVAL;
+	for (i =3D 0; i < isc->num_user_formats; i++)
+		if (isc->user_formats[i]->fourcc =3D=3D fival->pixel_format)
+			ret =3D 0;
=20
-	if (sensor_is_preferred(isc_fmt))
-		fie.code =3D isc_fmt->mbus_code;
-	else
-		fie.code =3D isc->raw_fmt->mbus_code;
+	for (i =3D 0; i < ARRAY_SIZE(controller_formats); i++)
+		if (controller_formats[i].fourcc =3D=3D fival->pixel_format)
+			ret =3D 0;
+
+	if (ret)
+		return ret;
=20
 	ret =3D v4l2_subdev_call(isc->current_subdev->sd, pad,
 			       enum_frame_interval, NULL, &fie);
 	if (ret)
 		return ret;
=20
+	fie.code =3D isc->config.sd_format->mbus_code;
 	fival->type =3D V4L2_FRMIVAL_TYPE_DISCRETE;
 	fival->discrete =3D fie.interval;
=20
@@ -1668,7 +1742,6 @@ static void isc_awb_work(struct work_struct *w)
 	struct isc_device *isc =3D
 		container_of(w, struct isc_device, awb_work);
 	struct regmap *regmap =3D isc->regmap;
-	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
 	struct isc_ctrls *ctrls =3D &isc->ctrls;
 	u32 hist_id =3D ctrls->hist_id;
 	u32 baysel;
@@ -1686,7 +1759,7 @@ static void isc_awb_work(struct work_struct *w)
 	}
=20
 	ctrls->hist_id =3D hist_id;
-	baysel =3D config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
+	baysel =3D isc->config.sd_format->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
=20
 	pm_runtime_get_sync(isc->dev);
=20
@@ -1754,7 +1827,6 @@ static int isc_ctrl_init(struct isc_device *isc)
 	return 0;
 }
=20
-
 static int isc_async_bound(struct v4l2_async_notifier *notifier,
 			    struct v4l2_subdev *subdev,
 			    struct v4l2_async_subdev *asd)
@@ -1812,35 +1884,20 @@ static int isc_formats_init(struct isc_device *isc)
 		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
=20
+	num_fmts =3D 0;
 	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
 	       NULL, &mbus_code)) {
 		mbus_code.index++;
=20
 		fmt =3D find_format_by_code(mbus_code.code, &i);
-		if ((!fmt) || (!(fmt->flags & FMT_FLAG_FROM_SENSOR)))
+		if (!fmt) {
+			v4l2_warn(&isc->v4l2_dev, "Mbus code %x not supported\n",
+				  mbus_code.code);
 			continue;
+		}
=20
 		fmt->sd_support =3D true;
-
-		if (fmt->flags & FMT_FLAG_RAW_FORMAT)
-			isc->raw_fmt =3D fmt;
-	}
-
-	fmt =3D &formats_list[0];
-	for (i =3D 0; i < list_size; i++) {
-		if (fmt->flags & FMT_FLAG_FROM_CONTROLLER)
-			fmt->isc_support =3D true;
-
-		fmt++;
-	}
-
-	fmt =3D &formats_list[0];
-	num_fmts =3D 0;
-	for (i =3D 0; i < list_size; i++) {
-		if (fmt->isc_support || fmt->sd_support)
-			num_fmts++;
-
-		fmt++;
+		num_fmts++;
 	}
=20
 	if (!num_fmts)
@@ -1855,9 +1912,8 @@ static int isc_formats_init(struct isc_device *isc)
=20
 	fmt =3D &formats_list[0];
 	for (i =3D 0, j =3D 0; i < list_size; i++) {
-		if (fmt->isc_support || fmt->sd_support)
+		if (fmt->sd_support)
 			isc->user_formats[j++] =3D fmt;
-
 		fmt++;
 	}
=20
@@ -1877,13 +1933,11 @@ static int isc_set_default_fmt(struct isc_device *i=
sc)
 	};
 	int ret;
=20
-	ret =3D isc_try_fmt(isc, &f, NULL, NULL);
+	ret =3D isc_try_fmt(isc, &f, NULL);
 	if (ret)
 		return ret;
=20
-	isc->current_fmt =3D isc->user_formats[0];
 	isc->fmt =3D f;
-
 	return 0;
 }
=20
--=20
2.7.4

