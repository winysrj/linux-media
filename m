Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13916C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAAE32146F
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:28:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="iJIOP8Mf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfARO2Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 09:28:24 -0500
Received: from mail-eopbgr730097.outbound.protection.outlook.com ([40.107.73.97]:58688
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727481AbfARO2Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 09:28:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7RmTXA60Z7oxmionXu79ZXiIyrTePvdk3t7YUb6P6E=;
 b=iJIOP8Mf6Ct5hesha6Uu4qmPx9TfB05SFHUHl05mknXivWfHk65FD/He4tzCeg74lNupczbUqjFTT7WEJRBeOVHzpJdazT72xfeJNd/rMzOBd74STzqVA1RUPyh+XRPg/pZvMz3pd8VkQnjUySLjhiDnYEKitzn36k0L2lEZ2mU=
Received: from DM5PR07MB4119.namprd07.prod.outlook.com (52.132.140.158) by
 DM5PR07MB3878.namprd07.prod.outlook.com (52.132.139.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.24; Fri, 18 Jan 2019 14:28:17 +0000
Received: from DM5PR07MB4119.namprd07.prod.outlook.com
 ([fe80::c0af:bc6f:3dd4:be07]) by DM5PR07MB4119.namprd07.prod.outlook.com
 ([fe80::c0af:bc6f:3dd4:be07%2]) with mapi id 15.20.1537.018; Fri, 18 Jan 2019
 14:28:17 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>
CC:     "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Topic: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Index: AQHUrzoN7XJuswIKkE+w1zxwJJXABA==
Date:   Fri, 18 Jan 2019 14:28:17 +0000
Message-ID: <20190118142803.70160-2-ksloat@aampglobal.com>
References: <20190118142803.70160-1-ksloat@aampglobal.com>
In-Reply-To: <20190118142803.70160-1-ksloat@aampglobal.com>
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
x-microsoft-exchange-diagnostics: 1;DM5PR07MB3878;6:NcrQ8tX2vkFWXoZ7c14/Gh9sxI4v5/xBpzlE3l9ElVXuKPpAjo/p62hRjDmaDrytmTuNWVkGL9TWVaG+KQxQRiZQLcX+hLQ86cJYS1BIPU3z6Qehn3VPKzJ8M8mTsrQeQjIIpLzDnUPOA6kPWBysQbp2nDcrET0zBpyfXnlX3MDv5WKHg0naxmUV3OehbXZi0K/R66M4YjgFaKLwAtEY9sJEvKoBsEqA5VJeocbaG9D40kxn4vgnvHB8+tyzAkrjIDVfZHZHJmi/69e5EimyTfK8TnSV81lXBtEob2UY4u6kiLMwaY+yZxS2m6weXloa/8tZN6En6zgWI3Nxt/Yn6wUlLK5kA2yLfb0PhQuDcZ+JBc0EVbvcxE0MtM9+TXgtm1aD0AHpegvDcQ5JfTy/g5EQeuVlpBKI6irtCL6wPXQEAifv7EjtO1YSwmOqZ6f1pdAcXKHbMX/YhH8QSHIMEQ==;5:Ple04L/11UveC99R+i9S/GrZH14rnIbApM/BIHBQEEfTra6SxAQFAm4/QFjVUDG5klL2T8E31leuDWIrFSAGJfIGSmA3V/DDvl1Hj4k6XXGJqHuaK3vwJ2LHmGwBO72hx6ndQGMT9EP8PBHJUQ0fKSo7zym24osyKDpJQMSw+l/iMlInqntix5iqa1LzVauBAkfVHMP4rgCDFXqfkrq0xQ==;7:U76hTQQi/kCkD6tp+Dnq53peBpgFKkg3IGYZd0QjruFQ8eHTKlauaXSUHeag7hdNsdmZyEZgCv9PzbFX3S/WtL2wUvwuQCuUHXcMMFapiCUAaDfCE4lzfvWHZcxi6byo0uFazDPVd0geazqgTSKk8Q==
x-ms-office365-filtering-correlation-id: 94ad89cd-e3df-4024-3460-08d67d513028
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR07MB3878;
x-ms-traffictypediagnostic: DM5PR07MB3878:
x-microsoft-antispam-prvs: <DM5PR07MB3878532341E38DFC8E46655BAD9C0@DM5PR07MB3878.namprd07.prod.outlook.com>
x-forefront-prvs: 0921D55E4F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(366004)(39850400004)(376002)(189003)(199004)(53936002)(478600001)(6116002)(71200400001)(105586002)(71190400001)(3846002)(80792005)(86362001)(446003)(6916009)(99286004)(186003)(68736007)(102836004)(14454004)(81156014)(81166006)(8676002)(8936002)(256004)(2351001)(15650500001)(97736004)(14444005)(1076003)(4326008)(106356001)(72206003)(5640700003)(52116002)(316002)(6506007)(386003)(66066001)(6512007)(6486002)(6436002)(50226002)(2501003)(36756003)(2906002)(2616005)(486006)(476003)(54906003)(26005)(11346002)(7736002)(305945005)(25786009)(5660300001)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR07MB3878;H:DM5PR07MB4119.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o+2YKdCNlWnDrhDTWXQHwa9IjjXVgxWfJE1aELZiffWWhV1KlRF+J1KCj7gxBMeAKYJ0dPfu16iIXSAjONmwW+pg2p6N9rwDGQMXShNUrPFaQibrfJu+emKbaxiX0FgMGTDmyR8xzkL5HvdxEmUSTKvSIEbfl7s5s95bqfXKcgmOB4NKomdbKY9pq9Dj8YOQzDXtNS3sFiej+k6ANtX0a62tSIQ5w9/cihilAZHJ3wTV/rV8b23+dCJuCR7j1Vrqqo0QDbvbw29rPdp6L5D0Lp3DKHTBS/jXFxroVAyxtGZ6ALnB29elwUTP6pL/YDOhZL/gzriCOZZ9Ez1znqpaX3twpklqYFvjxJikm7p+RPDW6n8HwmC7mwC6+RlbOlfrJYYF2hh5aWKwz+hs+S+LmFRFWnCLm+RH9E6QbLG2P8k=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ad89cd-e3df-4024-3460-08d67d513028
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2019 14:28:16.4111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e20e3a66-8b9e-46e9-b859-cb654c1ec6ea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB3878
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
X-OrganizationHeadersPreserved: DM5PR07MB3878.namprd07.prod.outlook.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ken Sloat <ksloat@aampglobal.com>

Update device tree binding documentation specifying how to
enable BT656 with CRC decoding.

Signed-off-by: Ken Sloat <ksloat@aampglobal.com>
---
 Changes in v2:
 -Use correct media "bus-type" dt property.
=20
 Documentation/devicetree/bindings/media/atmel-isc.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/atmel-isc.txt b/Docume=
ntation/devicetree/bindings/media/atmel-isc.txt
index bbe0e87c6188..2d4378dfd6c8 100644
--- a/Documentation/devicetree/bindings/media/atmel-isc.txt
+++ b/Documentation/devicetree/bindings/media/atmel-isc.txt
@@ -21,6 +21,11 @@ Required properties for ISC:
 - pinctrl-names, pinctrl-0
 	Please refer to pinctrl-bindings.txt.
=20
+Optional properties for ISC:
+- bus-type
+	When set to 6, Bt.656 decoding (embedded sync) with CRC decoding
+	is enabled.
+
 ISC supports a single port node with parallel bus. It should contain one
 'port' child node with child 'endpoint' node. Please refer to the bindings
 defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
--=20
2.17.1

