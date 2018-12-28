Return-Path: <SRS0=znln=PF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA40EC43444
	for <linux-media@archiver.kernel.org>; Fri, 28 Dec 2018 16:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4AF32148E
	for <linux-media@archiver.kernel.org>; Fri, 28 Dec 2018 16:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="TwKyiool"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbeL1Q76 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 28 Dec 2018 11:59:58 -0500
Received: from mail-eopbgr770132.outbound.protection.outlook.com ([40.107.77.132]:12467
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729404AbeL1Q76 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Dec 2018 11:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbF4C35ZWDRk5vmNCJZ/tvMk9eTrXOuvSLqpGl4X59k=;
 b=TwKyioolSU5/OmJU0yWmJSSGfRWEnBRuAvLudoCxw1pg3t+F8DWMAyuU/gAf74PRo+TI8hxVb4kEtgUjazfLEH2jYNUMDiCQPhDkVS1eRh0yVPBmEHPEqGhhcP5cQEp9BIp10bg90/bVZfVZc9lYkq91tnWrDnQ/ZgYQDX1azwo=
Received: from BL0PR07MB4115.namprd07.prod.outlook.com (52.132.10.149) by
 BL0PR07MB5025.namprd07.prod.outlook.com (10.167.180.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1446.26; Fri, 28 Dec 2018 16:59:51 +0000
Received: from BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::6051:85a:c31b:7606]) by BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::6051:85a:c31b:7606%2]) with mapi id 15.20.1446.026; Fri, 28 Dec 2018
 16:59:51 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>
CC:     "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH v1 1/2] media: atmel-isc: Add support for BT656 with CRC
 decoding
Thread-Topic: [PATCH v1 1/2] media: atmel-isc: Add support for BT656 with CRC
 decoding
Thread-Index: AQHUns6/Mav1xniG5UimGV2/kOTXnQ==
Date:   Fri, 28 Dec 2018 16:59:51 +0000
Message-ID: <20181228165934.36393-1-ksloat@aampglobal.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [100.3.71.115]
x-clientproxiedby: BN8PR16CA0033.namprd16.prod.outlook.com
 (2603:10b6:408:4c::46) To BL0PR07MB4115.namprd07.prod.outlook.com
 (2603:10b6:207:4c::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=KSloat@aampglobal.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR07MB5025;6:To8ZgFJzaKIDH6gcyEXiAT6qcRmm9jcfO+v40J7ZHmRLYMUpOClysN5/k5znsEfTigevZS9eHgdA6SHwSKea7P4C3ilqJ4Vzus8ESyqzhP2sPu6aWdcjjVgmo02atXfd33sFuLSy6woiMv7oB1ajH6c3En3Vcula8xSe3Vn4BUpLWDKA3HkUJdMul5zk5n7L03ZdPo1q4hE92Bb3E7iMEYluf9NOokTkdyaqxvE3AL2iVV83Qz+mqnTWsr/T78Z5n+RyA47s84DTjEhAgSp2oqgaysyyrgCps0bT4KEHqY051HelCqlMIZmbosghCGs5Fg/ws1cMJAzr3InlgmzHZ3HIdK7y4/z4FOuLvTZsRmYyMxF/IZuwtPGgfDUIBwAg+dYms3A0XofFftbheZ0A57UnT4IPpPFrYf39BXJ7S2+6GUG79+lCPjAyn6zdswD2PdHzicYq7o0upHP49N8XwQ==;5:zy+2KJOjOlQ7YKavk9C0QY2uY/KoRAAmaB6XusVrH3yI8ztz3dqjjmpUWdV+UehfENCVrXrC0mR7J7vvwuF4pLzCEKxCp/5/HodF5Lb7t8SAZ35vAFo8AvUWxX47AYuBDhMd9GFZJQD5dKhaxznYWhbS/zl0YftF1pE0/IcEop8=;7:QUCY6V+7+bJp2n4l4Cv63ziLggqzJ9qmvXVj9AhoU6Auu4BUa7eW9pBIyUzmRiWep6cbdXAJWZWBAfzBEaDPtgsWVKLm7sNs2fDi+ivMkf7QcRT2LTDGaZM2Z/d3l2oIhRQp31nN3rZYMBZQRDcpqQ==
x-ms-office365-filtering-correlation-id: 377300ed-71c3-454d-762f-08d66ce5e196
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR07MB5025;
x-ms-traffictypediagnostic: BL0PR07MB5025:
x-microsoft-antispam-prvs: <BL0PR07MB5025D313E287B2654972F766ADB70@BL0PR07MB5025.namprd07.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(908002)(999002)(5005026)(6040522)(8220051)(2401047)(8121501046)(3231475)(944501520)(52105112)(93006095)(93001095)(10201501046)(3002001)(6041310)(20161123558120)(20161123562045)(20161123560045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BL0PR07MB5025;BCL:0;PCL:0;RULEID:;SRVR:BL0PR07MB5025;
x-forefront-prvs: 09007040D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(39850400004)(376002)(366004)(199004)(189003)(5640700003)(7736002)(54906003)(3846002)(72206003)(6116002)(316002)(478600001)(81156014)(305945005)(8676002)(25786009)(80792005)(8936002)(186003)(26005)(81166006)(2501003)(6506007)(99286004)(102836004)(6916009)(2906002)(386003)(2351001)(52116002)(36756003)(5660300001)(86362001)(71200400001)(66066001)(71190400001)(97736004)(2616005)(53936002)(14454004)(486006)(6486002)(6436002)(4326008)(105586002)(106356001)(68736007)(1076003)(476003)(6512007)(256004)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR07MB5025;H:BL0PR07MB4115.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DsoWj8zbu6UXr414d+v2l6XVwCjSE+6NxQ5GAqe34GAodfX1KuGHjDe9rvt9JGOCngcmBxlJQN12RB6S4G/tRVw6biYLWgS6Jrf4tJ1naO0o+UcdHkF+feJpLH2qMVdj3EqKWpUUtZ7S2x+S5bFNigq8ZNMLtogDvhjgO+37AMLEypmb+YfTf+YRiAjCGjrdlhBz5QFuOKXVqHmq8k/YguxP0TxstUaJzc1axn91fkjzxZ32LWA3X0oUuCNImA/mE2k0iKYhYxJG+shDBd+jeBsFI/lz5sEfjrCogIEI+WuGb4UiK8GKdUxkXlSK5yqe
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 377300ed-71c3-454d-762f-08d66ce5e196
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2018 16:59:51.0460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e20e3a66-8b9e-46e9-b859-cb654c1ec6ea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR07MB5025
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-AuthSource: BL0PR07MB4115.namprd07.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-TransportTrafficSubType: 
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-mapi-admin-submission: 
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 100.3.71.115
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-transporttrafficsubtype: 
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: BL0PR07MB5025.namprd07.prod.outlook.com
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
index 2aadc19235ea..8b6f4db15bdc 100644
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

