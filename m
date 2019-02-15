Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC44C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 08:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E499521916
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 08:37:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="aZqPSR+L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404280AbfBOIhr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 03:37:47 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:13324 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfBOIhq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 03:37:46 -0500
X-IronPort-AV: E=Sophos;i="5.58,372,1544511600"; 
   d="scan'208";a="23907100"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 15 Feb 2019 01:37:43 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 15 Feb 2019 01:37:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hufw4V4vuHwJhVfSuNl6jQHvlY/J//dl8PQfsiMeMg4=;
 b=aZqPSR+LMS4onTlVexzsILFxDZktIVyDldUasi4hi5gAlTg59fNrlKrcLl8H38VGFY62ytF71A+AkQJklQ8jQ3IObRLvNQyGmDzznM+mdczALR1hLNdXy12MFkkBgp1LgfiArTPWvgfu4j173jt/kWbQidU3s5dRA/flizkpPVs=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1595.namprd11.prod.outlook.com (10.172.37.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.19; Fri, 15 Feb 2019 08:37:41 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::4c19:f788:c2be:5e8f]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::4c19:f788:c2be:5e8f%5]) with mapi id 15.20.1601.023; Fri, 15 Feb 2019
 08:37:41 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <mchehab@kernel.org>,
        <Nicolas.Ferre@microchip.com>, <ksloat@aampglobal.com>,
        <sakari.ailus@iki.fi>, <hverkuil@xs4all.nl>
CC:     <Eugen.Hristev@microchip.com>
Subject: [PATCH] media: atmel: atmel-isc: reworked driver and formats
Thread-Topic: [PATCH] media: atmel: atmel-isc: reworked driver and formats
Thread-Index: AQHUxQm2DhFZfyQ1n0i/a5kxwOkcZw==
Date:   Fri, 15 Feb 2019 08:37:41 +0000
Message-ID: <1550219467-9532-1-git-send-email-eugen.hristev@microchip.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1692a3c-efb6-401b-1800-08d69320d8cc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1595;
x-ms-traffictypediagnostic: DM5PR11MB1595:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;DM5PR11MB1595;23:2Mz+8ELJ+C287LYrGmkW42tUXVL//FP5pTO6x3r?=
 =?iso-8859-1?Q?Ddlol2q0rtXr7ALj0+UcQWlmeYSjfoAaXZws39xMNT7y9XKUyeqiJd5Z8E?=
 =?iso-8859-1?Q?SMZARY6X/egzGGtxDn4/5xdT2Yk8lwlNBIRxvSmfn7pijv3FaYf0+dVrBU?=
 =?iso-8859-1?Q?ry0GWDo1r8k53pO4vZPWfRnWCx651BXio+lvg0IIfjssRi0J0GHZOcYZnI?=
 =?iso-8859-1?Q?senxvnfUBJyre+nZaHtt690bFHtY0gcly2Lrx2NfrevpGGvMpQ194n6n9S?=
 =?iso-8859-1?Q?9JtvKdoIHCE/OtxcsHpieJJkswZG9Yizg7ghJdb3dFSg07z0QtkyJQJ0Iv?=
 =?iso-8859-1?Q?JqXadJ13zpln3wKQyenXsCEyUypg9n9rvawxHS9aZL7yY2V+mhxa6y1dUZ?=
 =?iso-8859-1?Q?W3qqfgUJd4msOZooL8MFudpNIEyMSeYLP1QXZGFdE5brwqz3XDnaqG+Jv/?=
 =?iso-8859-1?Q?E6+jP/nWVamFtNn59GYpbsgnhqinhfQOD1dhbbh6DaTkBrdjvnSgxacMlO?=
 =?iso-8859-1?Q?FyJTA8nqkbcplLdCfxvqpuuadpvscKCRfb/0H4Hq8u1+d7lmqYsP59mNdP?=
 =?iso-8859-1?Q?19wUaBA2qSy1gGhHukJlRIneEFpqRBvH3QGAobNuJBncSv4xjKq5a6tbLV?=
 =?iso-8859-1?Q?OQ2DcHThxE9nFifzeV9EtYPgmf03Ki8VhNclOLT2creOEyrRdIk1TOIcai?=
 =?iso-8859-1?Q?rpPuG6+AWfDidWtJqWv8b5V+9cAnBMffh+07UdszmH2YxeMFIVFYwoRxdv?=
 =?iso-8859-1?Q?ZrKj7eCp8MmH0JNiIo5TJFwUUn4BT0YVvu/cDobCIgy8MeTC1/SAxos+Qe?=
 =?iso-8859-1?Q?3mN5dRBqzaiZ4Tkvwy6o8K/XpCryT7osw3wHWzgu9QFlBSNnWTa0cIKXPT?=
 =?iso-8859-1?Q?SCef7FK0RXN1QVoIsa9kgm0YC4oD3IgibRcML0Kf9oGcU75Th0039VTNt3?=
 =?iso-8859-1?Q?qtVqcfJtT8pLiMy0O+shog8/yBkLPd1cddaAbIwTmB2DzPYIzAuNyFq/5m?=
 =?iso-8859-1?Q?wdmSjNj+/1dAkyePwAAAxXiIJ/jOe2Kb+5XrZ8FAwts71awNYhG2+oaA8L?=
 =?iso-8859-1?Q?CN7eACDQGUaaL8V42G2ttKEuxFmQi5h9TiS11I+L7BvoVC1h2vhLZdXiw8?=
 =?iso-8859-1?Q?suR4P6GyYTAYN/Hs4NlihOXynbRafYHJgjrKFAReeldCJnJ1cC/3M7WnMh?=
 =?iso-8859-1?Q?HHhDT0nDB3ROQ5xix5bouE9UIsfOBxNTf89q1QAgLXcPsGhRpZNPRcS/vl?=
 =?iso-8859-1?Q?+qVVjQ34zLJlDr8pZHGprIp9Q/ph2GsAiEhMn/XEnTzr4VeYZlLjtUYlwS?=
 =?iso-8859-1?Q?O6e5iDMxhG/WQeTkwU7wGxr3PY117lPneHCqOtdW1nziw=3D=3D?=
x-microsoft-antispam-prvs: <DM5PR11MB15954937C1CED2F1DFDA6956E8600@DM5PR11MB1595.namprd11.prod.outlook.com>
x-forefront-prvs: 09497C15EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(396003)(346002)(199004)(189003)(6116002)(107886003)(186003)(26005)(3846002)(316002)(66066001)(2201001)(486006)(97736004)(25786009)(30864003)(102836004)(99286004)(52116002)(106356001)(2616005)(53936002)(4326008)(386003)(6506007)(6346003)(50226002)(71190400001)(105586002)(8936002)(36756003)(6512007)(305945005)(476003)(6486002)(7736002)(72206003)(86362001)(2906002)(53946003)(2501003)(68736007)(256004)(71200400001)(110136005)(478600001)(14454004)(81166006)(81156014)(6436002)(8676002)(14444005)(461764006)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1595;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RzqDh4IRZ78A0+zmrTn6We/hxscjEE2+0g9ZZeJViqH26mblPznxxHfgBLnrKS/sfjV7odRK/gm3BP+3YAQh9mBOTn10XA4Ckwq3lN4OCwZ0RLmIlqaA2VF9kVxoZaSSOse9kVk9sCBDK3It1Zntv+7Fy335nvOXJdzxBT2CViQHK9Vbt5m4UPu8/KdrjBr/ko/RvAJMgZi1ovoIbTVueBU5Tm3VzjjCqnwfCeZQ/2yu3Pch9OZ4U5PGCgRiDg2nzCRhOyMLZ7XPXSzNb24nV6KGrzWjG9CKCjL7i3/qjRJvqr0sSg8jUjl6xJxvpf1EMNcw1DAn6q3pGrr0ljMMHBEaRGbql7juScc3zQ6I67XYRAP/Gmi8IrHHytCa5TMAGGVHyKTPj59yCFcqf7KpD4PChcD4ehey1Gqtz+Q5m/s=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f1692a3c-efb6-401b-1800-08d69320d8cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2019 08:37:38.7400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1595
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
Hello Ken and possibly others using ISC driver,

I would appreciate if you could test this patch with your sensor,
because I do not wish to break anything in your setups.
Feedback is appreciated if any errors appear, so I can fix them.
I tested with ov5640, ov7670, ov7740(only in 4.19 because on latest it's br=
oken
for me...)
Rebased this patch on top of mediatree.git/master
Thanks!

Eugen

 drivers/media/platform/atmel/atmel-isc.c | 882 ++++++++++++++++-----------=
----
 1 file changed, 465 insertions(+), 417 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platf=
orm/atmel/atmel-isc.c
index 5017896..7f0a6cc 100644
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
@@ -196,8 +201,7 @@ struct isc_device {
 	struct v4l2_format	fmt;
 	struct isc_format	**user_formats;
 	unsigned int		num_user_formats;
-	const struct isc_format	*current_fmt;
-	const struct isc_format	*raw_fmt;
+	struct fmt_config	config;
=20
 	struct isc_ctrls	ctrls;
 	struct work_struct	awb_work;
@@ -210,319 +214,122 @@ struct isc_device {
 	struct list_head		subdev_entities;
 };
=20
-static struct isc_format formats_list[] =3D {
+/* This is a list of the formats that the ISC can *output* */
+static struct isc_format controller_formats[] =3D {
 	{
-		.fourcc		=3D V4L2_PIX_FMT_SBGGR8,
-		.mbus_code	=3D MEDIA_BUS_FMT_SBGGR8_1X8,
-		.flags		=3D FMT_FLAG_RAW_FROM_SENSOR,
-		.bpp		=3D 8,
-	},
-	{
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
@@ -571,6 +378,13 @@ static const u32 isc_gamma_table[GAMMA_MAX + 1][GAMMA_=
ENTRIES] =3D {
 	  0x3E20007, 0x3E90007, 0x3F00008, 0x3F80007 },
 };
=20
+#define ISC_IS_SENSOR_RAW_MODE(isc) \
+	(((isc)->config.sd_format->mbus_code & 0xf000) =3D=3D 0x3000)
+
+static unsigned int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level (0-2)");
+
 static unsigned int sensor_preferred =3D 1;
 module_param(sensor_preferred, uint, 0644);
 MODULE_PARM_DESC(sensor_preferred,
@@ -896,40 +710,17 @@ static int isc_buffer_prepare(struct vb2_buffer *vb)
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
@@ -942,10 +733,7 @@ static void isc_start_dma(struct isc_device *isc)
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
@@ -955,7 +743,6 @@ static void isc_set_pipeline(struct isc_device *isc, u3=
2 pipeline)
 {
 	struct regmap *regmap =3D isc->regmap;
 	struct isc_ctrls *ctrls =3D &isc->ctrls;
-	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
 	u32 val, bay_cfg;
 	const u32 *gamma;
 	unsigned int i;
@@ -969,7 +756,7 @@ static void isc_set_pipeline(struct isc_device *isc, u3=
2 pipeline)
 	if (!pipeline)
 		return;
=20
-	bay_cfg =3D config->cfa_baycfg;
+	bay_cfg =3D isc->config.sd_format->cfa_baycfg;
=20
 	regmap_write(regmap, ISC_WB_CFG, bay_cfg);
 	regmap_write(regmap, ISC_WB_O_RGR, 0x0);
@@ -1011,24 +798,24 @@ static int isc_update_profile(struct isc_device *isc=
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
@@ -1036,7 +823,7 @@ static void isc_set_histogram(struct isc_device *isc)
 		regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
=20
 		ctrls->hist_stat =3D HIST_ENABLED;
-	} else if (!ctrls->awb && (ctrls->hist_stat !=3D HIST_DISABLED)) {
+	} else {
 		regmap_write(regmap, ISC_INTDIS, ISC_INT_HISDONE);
 		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_DIS);
=20
@@ -1044,53 +831,18 @@ static void isc_set_histogram(struct isc_device *isc=
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
@@ -1107,8 +859,16 @@ static int isc_configure(struct isc_device *isc)
 	/* Set the pipeline */
 	isc_set_pipeline(isc, pipeline);
=20
-	if (pipeline)
-		isc_set_histogram(isc);
+	/*
+	 * The current implemented histogram is available for RAW R, B, GB
+	 * channels. Hence we can use it if CFA is disabled and CSC is disabled
+	 * and the sensor outputs RAW mode.
+	 */
+	if (isc->ctrls.awb && ((pipeline & (CFA_ENABLE | CSC_ENABLE)) =3D=3D 0)
+	    && ISC_IS_SENSOR_RAW_MODE(isc))
+		isc_set_histogram(isc, true);
+	else
+		isc_set_histogram(isc, false);
=20
 	/* Update profile */
 	return isc_update_profile(isc);
@@ -1125,7 +885,8 @@ static int isc_start_streaming(struct vb2_queue *vq, u=
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
@@ -1223,6 +984,22 @@ static void isc_buffer_queue(struct vb2_buffer *vb)
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
@@ -1249,15 +1026,31 @@ static int isc_querycap(struct file *file, void *pr=
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
+		if (((formats_list[i].mbus_code & 0xf000) !=3D 0x3000) ||
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
@@ -1270,26 +1063,230 @@ static int isc_g_fmt_vid_cap(struct file *file, vo=
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
+static int isc_validate_formats(struct isc_device *isc)
 {
-	unsigned int num_formats =3D isc->num_user_formats;
-	struct isc_format *fmt;
-	unsigned int i;
+	int ret;
+	bool bayer =3D false, yuv =3D false, rgb =3D false, grey =3D false;
+
+	/* all formats supported by the RLP module are OK */
+	switch (isc->config.fourcc) {
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
+	if ((bayer || grey) && !ISC_IS_SENSOR_RAW_MODE(isc))
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
+static int isc_configure_rlp_dma(struct isc_device *isc, bool direct_dump)
+{
+	if (direct_dump) {
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT8;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED8;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->config.bpp =3D 16;
+		return 0;
+	}
+
+	switch (isc->config.fourcc) {
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT8;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED8;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->config.bpp =3D 8;
+		break;
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SRGGB10:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT10;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_SBGGR12:
+	case V4L2_PIX_FMT_SGBRG12:
+	case V4L2_PIX_FMT_SGRBG12:
+	case V4L2_PIX_FMT_SRGGB12:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DAT12;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_RGB565;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_ARGB444:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_ARGB444;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_ARGB555:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_ARGB555;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED16;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_ARGB32:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_ARGB32;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED32;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->config.bpp =3D 32;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_YYCC;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_YC420P;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PLANAR;
+		isc->config.bpp =3D 12;
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_YYCC;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_YC422P;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PLANAR;
+		isc->config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_YYCC;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED32;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->config.bpp =3D 16;
+		break;
+	case V4L2_PIX_FMT_GREY:
+		isc->config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_DATY8;
+		isc->config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED8;
+		isc->config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
+		isc->config.bpp =3D 8;
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
+static int isc_configure_pipeline(struct isc_device *isc)
+{
+	switch (isc->config.fourcc) {
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_ARGB555:
+	case V4L2_PIX_FMT_ARGB444:
+	case V4L2_PIX_FMT_ARGB32:
+		/* if sensor format is RAW, we convert inside ISC */
+		if (ISC_IS_SENSOR_RAW_MODE(isc)) {
+			isc->config.bits_pipeline =3D CFA_ENABLE |
+				WB_ENABLE | GAM_ENABLES;
+		} else {
+			isc->config.bits_pipeline =3D 0x0;
+		}
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		/* if sensor format is RAW, we convert inside ISC */
+		if (ISC_IS_SENSOR_RAW_MODE(isc)) {
+			isc->config.bits_pipeline =3D CFA_ENABLE |
+				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
+				SUB420_ENABLE | SUB422_ENABLE | CBC_ENABLE;
+		} else {
+			isc->config.bits_pipeline =3D 0x0;
+		}
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		/* if sensor format is RAW, we convert inside ISC */
+		if (ISC_IS_SENSOR_RAW_MODE(isc)) {
+			isc->config.bits_pipeline =3D CFA_ENABLE |
+				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
+				SUB422_ENABLE | CBC_ENABLE;
+		} else {
+			isc->config.bits_pipeline =3D 0x0;
+		}
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		/* if sensor format is RAW, we convert inside ISC */
+		if (ISC_IS_SENSOR_RAW_MODE(isc)) {
+			isc->config.bits_pipeline =3D CFA_ENABLE |
+				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
+				SUB422_ENABLE | CBC_ENABLE;
+		} else {
+			isc->config.bits_pipeline =3D 0x0;
+		}
+		break;
+	case V4L2_PIX_FMT_GREY:
+		/* if sensor format is RAW, we convert inside ISC */
+		if (ISC_IS_SENSOR_RAW_MODE(isc)) {
+			isc->config.bits_pipeline =3D CFA_ENABLE |
+				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
+				CBC_ENABLE;
+		} else {
+			isc->config.bits_pipeline =3D 0x0;
+		}
+		break;
+	default:
+		isc->config.bits_pipeline =3D 0x0;
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
@@ -1297,48 +1294,114 @@ static int isc_try_fmt(struct isc_device *isc, str=
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
+		if ((isc->user_formats[i]->mbus_code & 0xf000) =3D=3D 0x3000) {
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
+	isc->config.sd_format =3D sd_fmt;
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
+	isc->config.fourcc =3D pixfmt->pixelformat;
+
+	if (isc_validate_formats(isc)) {
+		pixfmt->pixelformat =3D isc->config.fourcc =3D sd_fmt->fourcc;
+		/* This should be redundant, format should be supported */
+		ret =3D isc_validate_formats(isc);
+		if (ret)
+			goto isc_try_fmt_err;
+	}
+
+	ret =3D isc_configure_rlp_dma(isc, rlp_dma_direct_dump);
+	if (ret)
+		goto isc_try_fmt_err;
+
+	ret =3D isc_configure_pipeline(isc);
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
+	pixfmt->bytesperline =3D (pixfmt->width * isc->config.bpp) >> 3;
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
+	memset(&isc->config, 0, sizeof(isc->config));
+
+	return ret;
 }
=20
 static int isc_set_fmt(struct isc_device *isc, struct v4l2_format *f)
@@ -1346,11 +1409,10 @@ static int isc_set_fmt(struct isc_device *isc, stru=
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
@@ -1361,7 +1423,6 @@ static int isc_set_fmt(struct isc_device *isc, struct=
 v4l2_format *f)
 		return ret;
=20
 	isc->fmt =3D *f;
-	isc->current_fmt =3D current_fmt;
=20
 	return 0;
 }
@@ -1382,7 +1443,7 @@ static int isc_try_fmt_vid_cap(struct file *file, voi=
d *priv,
 {
 	struct isc_device *isc =3D video_drvdata(file);
=20
-	return isc_try_fmt(isc, f, NULL, NULL);
+	return isc_try_fmt(isc, f, NULL);
 }
=20
 static int isc_enum_input(struct file *file, void *priv,
@@ -1431,27 +1492,31 @@ static int isc_enum_framesizes(struct file *file, v=
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
@@ -1463,29 +1528,32 @@ static int isc_enum_frameintervals(struct file *fil=
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
@@ -1668,7 +1736,6 @@ static void isc_awb_work(struct work_struct *w)
 	struct isc_device *isc =3D
 		container_of(w, struct isc_device, awb_work);
 	struct regmap *regmap =3D isc->regmap;
-	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
 	struct isc_ctrls *ctrls =3D &isc->ctrls;
 	u32 hist_id =3D ctrls->hist_id;
 	u32 baysel;
@@ -1686,7 +1753,7 @@ static void isc_awb_work(struct work_struct *w)
 	}
=20
 	ctrls->hist_id =3D hist_id;
-	baysel =3D config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
+	baysel =3D isc->config.sd_format->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
=20
 	pm_runtime_get_sync(isc->dev);
=20
@@ -1754,7 +1821,6 @@ static int isc_ctrl_init(struct isc_device *isc)
 	return 0;
 }
=20
-
 static int isc_async_bound(struct v4l2_async_notifier *notifier,
 			    struct v4l2_subdev *subdev,
 			    struct v4l2_async_subdev *asd)
@@ -1812,35 +1878,20 @@ static int isc_formats_init(struct isc_device *isc)
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
@@ -1855,9 +1906,8 @@ static int isc_formats_init(struct isc_device *isc)
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
@@ -1877,13 +1927,11 @@ static int isc_set_default_fmt(struct isc_device *i=
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

