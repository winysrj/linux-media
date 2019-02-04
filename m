Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56A5C282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 14:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AF212087C
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 14:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="qhUuS+4a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbfBDOSY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 09:18:24 -0500
Received: from mail-eopbgr810130.outbound.protection.outlook.com ([40.107.81.130]:8258
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731040AbfBDOSV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 09:18:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHMQiLhekAexKhO83qwCVAVLLr6YO/pAayvnDc5nZV8=;
 b=qhUuS+4aSdutj1k8FCLDk3eN/s2R0oMoWMYVyQWfdiXZLw5T7lEJ0e3X80rMqjX8xYIR7BNU6ulIuP1jNIoLYW2dDdEAVPKdSSa0TjvylwRcyVfuUaJczd2/2EqatRKWTZHkZiYEg1W2/F7wmIUjYJHV9Mk5eTMJkUnYJUlYhDU=
Received: from BL0PR07MB4115.namprd07.prod.outlook.com (52.132.10.149) by
 BL0PR07MB4946.namprd07.prod.outlook.com (10.167.180.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Mon, 4 Feb 2019 14:18:13 +0000
Received: from BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::5516:87b1:344e:a27f]) by BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::5516:87b1:344e:a27f%5]) with mapi id 15.20.1580.019; Mon, 4 Feb 2019
 14:18:13 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>
CC:     Ken Sloat <KSloat@aampglobal.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: [PATCH v3 1/2] media: atmel-isc: Add support for BT656 with CRC
 decoding
Thread-Topic: [PATCH v3 1/2] media: atmel-isc: Add support for BT656 with CRC
 decoding
Thread-Index: AQHUvJR2YZvAK9puQUqBc2Mewd26iA==
Date:   Mon, 4 Feb 2019 14:18:13 +0000
Message-ID: <20190204141756.234563-1-ksloat@aampglobal.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [96.59.174.230]
x-clientproxiedby: BN8PR16CA0007.namprd16.prod.outlook.com
 (2603:10b6:408:4c::20) To BL0PR07MB4115.namprd07.prod.outlook.com
 (2603:10b6:207:4c::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=KSloat@aampglobal.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR07MB4946;6:+wpkSkn4JNtFXrut6SmvgAO4v6RPfh9G8tr7nne753nkHRlmY+gS1ckzikln2IyecNV+7ZHcEfwkt4QfdxFJE4XqPOqoTIHBlruN7jWw7INO6IvVFQ+7bKR0679N08mBARuv0F7yAToOde2WyP5leTqy25l+I4cx+fnUOi4LlIE1ZsJzPNcGIzTThpTFji/RuuHJrQWj4EB0J1C0GDB9cKLkfFsqiZ0xlOkrqMcqgonJcITv1JTgtbwI0etoV+g9dL1tVSoW/byK7EWtNXaxQftLpaXlMR4hUUrc+8z5XvhsraSfV30dEH6thcUal4l5yPWbwZ68b8WQ7/WtorUmPlsFSDDIH2QqU6XpWI8AmvlbbNuHe5OnyHYL9iqC8283x53QP1xWfxg0h/v+NahrK7+D1MWoWH2BuoqnRZguCUJ8aq7LAf4Hw0juiJlekbk35CMuBcFlvZvCi/wwgezhTQ==;5:htnRqgh3swFpX4GOGWbgooyfd4buFjPOueT19Wl8o2f8OthvfzmBOnp8dFmqU34Y+GBBZbOtnYkfljLPinHKhORQO/oBn4DrXhvBv/AuWhH4CcPh7t3yjjhBBccByXWXROFCdC0f7kpe/WCcDT2vZuFsYulAwI+w12kvpXHUISZwHkIppApgazuiGA42AdZD3xAgxLO9hDYs7PV0HIrCTA==;7:nfXxBvZ5FP430IUvr5NcqViFJJU70qtt2t9s9VEfYQekRRLAsXFE2zgiMl34R5/nyPFXN9zZ0x6aWqIRLmwGQIHPEyjwVR/tZ4cvWPQxlgZUv8oZxaO+4i6uX1iZIso3J+SgqYVJwwaZzThxw3K1Aw==
x-ms-office365-filtering-correlation-id: ce54d822-bae7-4db0-8b42-08d68aab98f3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BL0PR07MB4946;
x-ms-traffictypediagnostic: BL0PR07MB4946:
x-microsoft-antispam-prvs: <BL0PR07MB4946C7D0AF4A9704723EECA2AD6D0@BL0PR07MB4946.namprd07.prod.outlook.com>
x-forefront-prvs: 0938781D02
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(39850400004)(366004)(396003)(376002)(199004)(189003)(25786009)(106356001)(68736007)(3846002)(53936002)(26005)(5640700003)(4326008)(186003)(86362001)(305945005)(2351001)(8936002)(2906002)(6486002)(105586002)(2616005)(14444005)(256004)(81166006)(8676002)(36756003)(81156014)(6116002)(6436002)(486006)(7736002)(476003)(66066001)(6916009)(386003)(6512007)(72206003)(71190400001)(71200400001)(52116002)(316002)(97736004)(80792005)(54906003)(99286004)(50226002)(6506007)(478600001)(102836004)(1076003)(14454004)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR07MB4946;H:BL0PR07MB4115.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RMUK59LFFvX9tib6OaaLRpDdbx9epy2bQ2J8YFF7pEdaJ3YiAufW2t4R4w1vCuztO7Ye1imLFwHIR7t1T8HNa3++UXpIRX36k7RUfFe7XkZCF4TVCOuAr5ox0l4/JdDH9qxiRDbCtxh0zWHvnBfFiT4D+Oo4lxHXfdgy4oVARekDQq+2CwywShSXMr+Zh5bzFqEcj5Lah05cac1wJyXtSg+3MI7NwheFMR2E7lFoheQVdWcYfLSz9fjVfNh7sBCiGv2GURcoj76vEXsuQFLKaDrpCFh5/o0Ko86b/VEOFtZWoEwtsslkco0meCGbXHCc6huZNEeJvKzOoACegJ8y91OEAFBkehDI7YiDH6n5xoRvPG+5xF2HUsekxCecWP/zcnOL8vA9vyijbCte2g7/8T6gVaiJhz68Obxwju2SoXk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce54d822-bae7-4db0-8b42-08d68aab98f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2019 14:18:12.3718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: e20e3a66-8b9e-46e9-b859-cb654c1ec6ea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR07MB4946
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-AuthSource: BL0PR07MB4115.namprd07.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-TransportTrafficSubType: 
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-mapi-admin-submission: 
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 96.59.174.230
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-transporttrafficsubtype: 
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: BL0PR07MB4946.namprd07.prod.outlook.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ken Sloat <ksloat@aampglobal.com>

The ISC driver currently supports ITU-R 601 encoding which
utilizes the external hysync and vsync signals. ITU-R 656
format removes the need for these pins by embedding the
sync pulses within the data packet.

To support this feature, enable necessary register bits
when this feature is enabled via device tree.

Signed-off-by: Ken Sloat <ksloat@aampglobal.com>
---
 drivers/media/platform/atmel/atmel-isc-regs.h | 2 ++
 drivers/media/platform/atmel/atmel-isc.c      | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-regs.h b/drivers/media/=
platform/atmel/atmel-isc-regs.h
index 2aadc19235ea..d730693f299c 100644
--- a/drivers/media/platform/atmel/atmel-isc-regs.h
+++ b/drivers/media/platform/atmel/atmel-isc-regs.h
@@ -24,6 +24,8 @@
 #define ISC_PFE_CFG0_HPOL_LOW   BIT(0)
 #define ISC_PFE_CFG0_VPOL_LOW   BIT(1)
 #define ISC_PFE_CFG0_PPOL_LOW   BIT(2)
+#define ISC_PFE_CFG0_CCIR656    BIT(9)
+#define ISC_PFE_CFG0_CCIR_CRC   BIT(10)
=20
 #define ISC_PFE_CFG0_MODE_PROGRESSIVE   (0x0 << 4)
 #define ISC_PFE_CFG0_MODE_MASK          GENMASK(6, 4)
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platf=
orm/atmel/atmel-isc.c
index 50178968b8a6..9a399aa7ca92 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1095,7 +1095,8 @@ static int isc_configure(struct isc_device *isc)
 	pfe_cfg0  |=3D subdev->pfe_cfg0 | ISC_PFE_CFG0_MODE_PROGRESSIVE;
 	mask =3D ISC_PFE_CFG0_BPS_MASK | ISC_PFE_CFG0_HPOL_LOW |
 	       ISC_PFE_CFG0_VPOL_LOW | ISC_PFE_CFG0_PPOL_LOW |
-	       ISC_PFE_CFG0_MODE_MASK;
+	       ISC_PFE_CFG0_MODE_MASK | ISC_PFE_CFG0_CCIR_CRC |
+		   ISC_PFE_CFG0_CCIR656;
=20
 	regmap_update_bits(regmap, ISC_PFE_CFG0, mask, pfe_cfg0);
=20
@@ -2084,6 +2085,10 @@ static int isc_parse_dt(struct device *dev, struct i=
sc_device *isc)
 		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 			subdev_entity->pfe_cfg0 |=3D ISC_PFE_CFG0_PPOL_LOW;
=20
+		if (v4l2_epn.bus_type =3D=3D V4L2_MBUS_BT656)
+			subdev_entity->pfe_cfg0 |=3D ISC_PFE_CFG0_CCIR_CRC |
+					ISC_PFE_CFG0_CCIR656;
+
 		subdev_entity->asd->match_type =3D V4L2_ASYNC_MATCH_FWNODE;
 		subdev_entity->asd->match.fwnode =3D
 			of_fwnode_handle(rem);
--=20
2.17.1

