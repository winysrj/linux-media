Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C7DC43444
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 382B520896
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="pq1JrpvA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfARO3C (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 09:29:02 -0500
Received: from mail-eopbgr680126.outbound.protection.outlook.com ([40.107.68.126]:39031
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727020AbfARO3A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 09:29:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHMQiLhekAexKhO83qwCVAVLLr6YO/pAayvnDc5nZV8=;
 b=pq1JrpvAopa62xf5hzY8pB1wHerWgqO/cMfTzheOp62QUm9s1jT9qCTWr0ZIs0mvBUG5+Bha1L1br0wfNh2XIQXIgeA7venaeOeb/mGC+9yRP1RcbyaXO1NOLwbmkFSqOYvad9nsTYrBtuAwm94kKAbXmm1B88NLP6AUBNuDGN8=
Received: from DM5PR07MB4119.namprd07.prod.outlook.com (52.132.140.158) by
 DM5PR07MB3419.namprd07.prod.outlook.com (10.164.146.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.27; Fri, 18 Jan 2019 14:28:16 +0000
Received: from DM5PR07MB4119.namprd07.prod.outlook.com
 ([fe80::c0af:bc6f:3dd4:be07]) by DM5PR07MB4119.namprd07.prod.outlook.com
 ([fe80::c0af:bc6f:3dd4:be07%2]) with mapi id 15.20.1537.018; Fri, 18 Jan 2019
 14:28:16 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>
CC:     "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: [PATCH v2 1/2] media: atmel-isc: Add support for BT656 with CRC
 decoding
Thread-Topic: [PATCH v2 1/2] media: atmel-isc: Add support for BT656 with CRC
 decoding
Thread-Index: AQHUrzoMPVUFS28+2k27YJaUH5w8FA==
Date:   Fri, 18 Jan 2019 14:28:16 +0000
Message-ID: <20190118142803.70160-1-ksloat@aampglobal.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [96.59.174.230]
x-clientproxiedby: BN7PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:406:bc::24) To DM5PR07MB4119.namprd07.prod.outlook.com
 (2603:10b6:4:b3::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=KSloat@aampglobal.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR07MB3419;6:9B18eer5euQsZKQkPbYJQFyWs/YfVsI7oETl49VbV7zbVvjasr4D5M5kfAmhpUsDRb9pp3ICyWlorn3obBpXQtWrt+qGA83ku6XCvgt7YgxujgAg/nINiw6vQ7yF07NWE4bcBFimwz44G/P2WN5MNQeRfxeLtOnfYapVLJBFyH373rWzknSK/Tddffxg43v0U7D55MAD6ezWr5eluBcvNEjVhNf7pHBIKcTfeGV/7hItFR7xeQUmwhjJChRRa+uILfKChK0ABYT8YWaZX7woy1p65pgUPu4PavRw++SfolaqRsm43/b8ggLXgyi80NMQAjxtC0V/FjexfyHeK1Hpme23ointMjF1KtcPH0mGS406doSyCpWLnPsTUJYaMiWCj1I5eoMKUV7VBIQwJcF2bt/tEjDuzVzijz6UXOpHQr+LzEhDkTkcAGFpZ54yJzNtoiLWACfVY09cASR07bvwkw==;5:vYd+lEzeMeqH6yCwYPwgGWTv9tp6IE+6y13zQxSi9oR2CPtBtxX1PI2s0AyGSZjrZ3/FEEiVeayzfgctYFi+6ErFj2viMSH5RCv/VaSKj3IOTrdPAAkW0QXwbhkvQCPQibN2+wAw6XGSQHS7LMZ8+NyuuY1N4jxSkVST2PCga6TWX3U4zwi7bFset6KGtNTFQm6nsuoEAtBFXkgtOO2kGw==;7:LIet2XRzXqH6eAdbkAeSOwLQJsI/+D1hKbpTKgeSnmQAif2HaZuK6A53Lko2IrmyZrOTqbDjNu1eQ4zNozBCyugRVmyDbrB41cunJRk06CU+7g2GIwAlo5rtMqkQhAmGIKs5zRDztC/TSPucQx4pRQ==
x-ms-office365-filtering-correlation-id: 407ff929-ebd4-4f4f-1e68-08d67d512f5d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR07MB3419;
x-ms-traffictypediagnostic: DM5PR07MB3419:
x-microsoft-antispam-prvs: <DM5PR07MB3419B1E7D0D2EAD7A963BAF8AD9C0@DM5PR07MB3419.namprd07.prod.outlook.com>
x-forefront-prvs: 0921D55E4F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(396003)(39850400004)(346002)(189003)(199004)(14454004)(72206003)(54906003)(478600001)(316002)(99286004)(1076003)(66066001)(486006)(476003)(2616005)(25786009)(6512007)(53936002)(102836004)(6506007)(386003)(80792005)(2906002)(97736004)(26005)(186003)(52116002)(5640700003)(256004)(14444005)(36756003)(71200400001)(71190400001)(86362001)(6916009)(5660300001)(8936002)(6436002)(68736007)(8676002)(6486002)(81156014)(81166006)(50226002)(2501003)(2351001)(305945005)(7736002)(3846002)(6116002)(105586002)(106356001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR07MB3419;H:DM5PR07MB4119.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TTAQmVZO2uN1XKXR086+U6pvBanJwP29Z2f2Gqf+cnh3hfoaFzyIKYGvCtHMbC6vf/K9wK6Gi7EEAX9htUf4ImRBVbVgGaQea8oY56AqwcfKHZMNJ1aCVVX50lTGcoFnv4GRqwCoNDXOShTHQ7EvIXTUejwXXUBRmjAKlxZ1yPRTxCbkuV/dsVRM8unROptqnc3iddvNnlxxCoKSN0GzcESyUgVMNH0xmKelYn2wEYO56AwMtGDBz/Lqr5JRWgSpJaKdWtUbLqaRZE6BO2hUmBABsHDbIa+SGERMGyyTKhbY2VrMydCITeRITqiSU1KpYFj8XD1JlTta4ya628x7lm7N2XGhkbzvvj/xwDxhfnl/nlw+wJu2cWgf4uarJNdDFDas+RyCH33+K8sQm1IKoVb+hJ/N8DyWhtO8ZuSAWYU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407ff929-ebd4-4f4f-1e68-08d67d512f5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2019 14:28:15.1842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e20e3a66-8b9e-46e9-b859-cb654c1ec6ea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB3419
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-AuthSource: DM5PR07MB4119.namprd07.prod.outlook.com
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
X-OrganizationHeadersPreserved: DM5PR07MB3419.namprd07.prod.outlook.com
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

