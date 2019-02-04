Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB2CC282CB
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 14:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 639BE2082E
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 14:18:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="raF9tQPm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731570AbfBDOSY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 09:18:24 -0500
Received: from mail-eopbgr810130.outbound.protection.outlook.com ([40.107.81.130]:8258
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731568AbfBDOSW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 09:18:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZ+MN1XAE5bsBGJc+Buz5pxW74jmJ3RbJiZ87BLBCYg=;
 b=raF9tQPmTJfwlGarvD1ABgeeh+yWk/f4P7ZJ+7kycujXXz8NWvQM+lN7CRiWZIhHgDRDUfa67jQaS3JLRoSVy43nSQLisNqEswb5uPIS2hNSaTIHPpN3W4Ad+SVaObEWdMXgA6acIi2Vv0oc0NE3bcJrkc5N9+hu9Kgs1njQp0w=
Received: from BL0PR07MB4115.namprd07.prod.outlook.com (52.132.10.149) by
 BL0PR07MB4946.namprd07.prod.outlook.com (10.167.180.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Mon, 4 Feb 2019 14:18:14 +0000
Received: from BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::5516:87b1:344e:a27f]) by BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::5516:87b1:344e:a27f%5]) with mapi id 15.20.1580.019; Mon, 4 Feb 2019
 14:18:14 +0000
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
Subject: [PATCH v3 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Topic: [PATCH v3 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Index: AQHUvJR3CYKO7qlX9EmmEJdCMaYwPA==
Date:   Mon, 4 Feb 2019 14:18:14 +0000
Message-ID: <20190204141756.234563-2-ksloat@aampglobal.com>
References: <20190204141756.234563-1-ksloat@aampglobal.com>
In-Reply-To: <20190204141756.234563-1-ksloat@aampglobal.com>
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
x-microsoft-exchange-diagnostics: 1;BL0PR07MB4946;6:mzkm28H9ENERiULty/izyddoYsPW7/3Z5F7RgpDRVziKezbsfDcvD90dtPycqRnCyY84WsNoKHQ6WlCwvEoHcJd3dKFGnyM35V3W/K67QugHDBs+4OBCAAl6uxLljCymWmSkd2BT2CRUQezzl6LtwegoldQ/VC2LCuh7wByQ3iAOM8VoFYnDe+Wxoe/b1M03YfzmkoMEIAxkQOhA+TP+LhggHcVWTk1htuZe7G7ryOtPJKmMoh9p2ECLG59nS+1gCCIZOPB3XCppSoeWRe+XGkLTCCW0a5y07Dt28+oAtzJwA8uXeomvVaCDZKlEr6JDutL5SHnq74lFWBf9BhN4PxCbIKYZNhRtz6OC1Qt22MRo1byEY1Cs6otpr4Q/TEEIMJaXD8bU33XGrlhjhWQvjW7ml/8hsTgawOjYNyq3LIXBP/R8RQFOCsvsBqS2N6NAwai0V9b1R/rmMotlSeKG+Q==;5:LA1kgDBqCLb1oOZ6x+o1sMLfdLDZBRi6bCs6Yi7+V6El0nbhLU6HVmXledpxEkM0dVonKEnjaE9QYo9j2LdKb58JjJgqQzUw9AQSegLQoLLyHCVt9twuM3aJzfNl0L77xO9tYo73RHhiNWenJA6bGB6LNMbM9ssDQV/r4064OOMY2xuCEXZHtvhLN1uAhG7yCyslTqh6KlN8he8960pZgg==;7:D+tshkwDU2jjfhw0pfLzrhWdtY2iFo03lTLniVWU9R05nx8U93aa99sWsJZJO7P2uvDVux82NZqJYNlsF7+YAIcrUGxVRNULxYSqeYTDPNPsvVpLwT/M7GVNi/nlZStbj/bg+FuujJPvzUmoGKQDqw==
x-ms-office365-filtering-correlation-id: aeccdf6c-6d27-44c2-ec1c-08d68aab99a1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BL0PR07MB4946;
x-ms-traffictypediagnostic: BL0PR07MB4946:
x-microsoft-antispam-prvs: <BL0PR07MB494655228B81FB1157D1172AAD6D0@BL0PR07MB4946.namprd07.prod.outlook.com>
x-forefront-prvs: 0938781D02
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(39850400004)(366004)(396003)(376002)(199004)(189003)(25786009)(106356001)(68736007)(446003)(3846002)(53936002)(26005)(5640700003)(4326008)(186003)(86362001)(305945005)(2351001)(8936002)(2906002)(6486002)(105586002)(2616005)(14444005)(256004)(81166006)(8676002)(36756003)(81156014)(6116002)(6436002)(11346002)(486006)(7736002)(476003)(66066001)(15650500001)(6916009)(386003)(6512007)(72206003)(71190400001)(71200400001)(52116002)(76176011)(316002)(97736004)(80792005)(54906003)(99286004)(50226002)(6506007)(478600001)(102836004)(1076003)(14454004)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR07MB4946;H:BL0PR07MB4115.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MjrYBYn+MKFkA4LENz+iGbAJNDcphOl94cvMtqgUZuCSEBjOwNjUoSoQxtjqrPVTcKxv+u1yUoGhsQyXeRXGoIf+FAqf0cTYXTTtdfeEVYeF4HOSAmfhh2K7wDHXH7ABaDOjxDYnrJ4JypSoLmHaf2NSSgNgdHIfd4+ste9b1exEbmbSd2WGmUawQvHEyBx8CAIOVOulEZfKR3K1f1cq9mH49votziWoivSNq7FPfk4RDw8l9MpYG2t8T4herms9aTczsQZJda7wpwbGyUvuTZYNeR5ZGiyfBRolGhSjH7Qtp3JcQSYkt4PkMk71tiAnnftHi/Smm88bOoqy+3eAYg6BpVRu1aHlYFy4Np5wvqRcEGE1RwEUE3Sr7iwSMLC3XjRDLWmFOdAcOmCt8zc5NpyNFHOoEGEPV8FuHXLkG7Y=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeccdf6c-6d27-44c2-ec1c-08d68aab99a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2019 14:18:13.5266
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

Update device tree binding documentation specifying how to
enable BT656 with CRC decoding and specify properties for
default parallel bus type.

Signed-off-by: Ken Sloat <ksloat@aampglobal.com>
---
 Changes in v2:
 -Use correct media "bus-type" dt property.

 Changes in v3:
 -Specify default bus type.
 -Document optional parallel bus flags.

 .../devicetree/bindings/media/atmel-isc.txt       | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/atmel-isc.txt b/Docume=
ntation/devicetree/bindings/media/atmel-isc.txt
index bbe0e87c6188..db3749a3964f 100644
--- a/Documentation/devicetree/bindings/media/atmel-isc.txt
+++ b/Documentation/devicetree/bindings/media/atmel-isc.txt
@@ -21,6 +21,21 @@ Required properties for ISC:
 - pinctrl-names, pinctrl-0
 	Please refer to pinctrl-bindings.txt.
=20
+Optional properties for ISC:
+- bus-type
+	When set to 6, Bt.656 decoding (embedded sync) with CRC decoding
+	is enabled. If omitted, then the default bus-type is parallel and
+	the additional properties to follow can be specified:
+- hsync-active
+	Active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
+	If unspecified, this signal is set as active HIGH.
+- vsync-active
+	Active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
+	If unspecified, this signal is set as active HIGH.
+- pclk-sample
+	Sample data on rising (1) or falling (0) edge of the pixel clock
+	signal. If unspecified, data is sampled on the rising edge.
+
 ISC supports a single port node with parallel bus. It should contain one
 'port' child node with child 'endpoint' node. Please refer to the bindings
 defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
--=20
2.17.1

