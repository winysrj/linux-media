Return-Path: <SRS0=znln=PF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FACC43387
	for <linux-media@archiver.kernel.org>; Fri, 28 Dec 2018 16:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DFFB20866
	for <linux-media@archiver.kernel.org>; Fri, 28 Dec 2018 16:59:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="TGJkIQWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbeL1Q75 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 28 Dec 2018 11:59:57 -0500
Received: from mail-eopbgr770132.outbound.protection.outlook.com ([40.107.77.132]:12467
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729270AbeL1Q75 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Dec 2018 11:59:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvIvQUt9cOy1DhuF+isS00N+Rdt0dyAJ4xeAYl/o6S8=;
 b=TGJkIQWqxcNm53XUMJsKoS+dHi3S8QsK/ZljLDB80q6Q6Q6b9s7Izl4SwjlleW4gqozkfA/idI3xzupxlDLyOm8YqqdHoAgkKkXyYiXi6/2FCdhqGwx7bA9hJ7DpIzGLmovJ83qYj5uovnEfAcRnV71PYcRDjRqPDVfI/Diz5uc=
Received: from BL0PR07MB4115.namprd07.prod.outlook.com (52.132.10.149) by
 BL0PR07MB5025.namprd07.prod.outlook.com (10.167.180.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1446.26; Fri, 28 Dec 2018 16:59:52 +0000
Received: from BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::6051:85a:c31b:7606]) by BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::6051:85a:c31b:7606%2]) with mapi id 15.20.1446.026; Fri, 28 Dec 2018
 16:59:52 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>
CC:     "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH v1 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Topic: [PATCH v1 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Index: AQHUns6/77kEGvPCikSLFo8p0P0NrA==
Date:   Fri, 28 Dec 2018 16:59:52 +0000
Message-ID: <20181228165934.36393-2-ksloat@aampglobal.com>
References: <20181228165934.36393-1-ksloat@aampglobal.com>
In-Reply-To: <20181228165934.36393-1-ksloat@aampglobal.com>
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
x-microsoft-exchange-diagnostics: 1;BL0PR07MB5025;6:Zu+r7CFNANm5dEdXcCskjZqEfyLAf73bTwUO41nzG6UUZO8HIsk/jeMbRLMLPUZ4/vQW6yrLwVHYB5o5RKsk0WDmfRWzQVzsMXDGxJNAdfIVeClDYlRutSjHSKnCO1Bc2Ys6y+EVX9RFMrrxSyxppOorY4JwXwvN6zsmzo5FgmdONCjKhGKGw5whA5RVDeBEkDTGbKkLxcedz35U2rjBI0qlsiE2HEYUZtzkWs8+3S7n5/jJ7A1Bpu/0YEHrXxQHjiru0VFE7Jde1Vg4/ponhkDjeJFzSvA94XUTbSax4dnLTnY44ZjFf55Hl1DPGAjd0IrtK4QXQRxFVgcpV2SjnrdTNgmXGcnbDB9tld3tHseHyGBw/Qc76ZyF83iWgumrG/iraVTC0oT+xhV0OtzlELO81CUg46U5Nositoxg/UV99obR2PVqArq96LPECSveLYKHfpkQCINbnK3o7OksrA==;5:TLdEWsmCMPKiFv+JBT92NY9sb2GG4sg6Jc/LcGiSbLpMK0VwBy/dnBVuzz3O1VHNhATtzv+qkhWqbllEnhyYAeHrLSpbU8pp00Kua9HuHPtT4YbHIeSehmyyzDPtkzW/bxhwYFnDohT4qbxp822qtjS5Ocvo2fEVb4LVk12sDTQ=;7:JGixPJVWKzTkyLGAaYdEw4ZwTzDF5sfCvNEFescbulvfKT1cUCxyswGxU4f0aSs7OIyRfn+9ocFJteu2Xg19SNyJviZ9IrSh4LLvzUveT1fgdJx/yHeMBuYoJvYNyFkGWyuCSCjy7s4NulZS+vheFA==
x-ms-office365-filtering-correlation-id: 89cf216c-f6af-4825-ca67-08d66ce5e222
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR07MB5025;
x-ms-traffictypediagnostic: BL0PR07MB5025:
x-microsoft-antispam-prvs: <BL0PR07MB5025DEC496E7F7AC49076FD3ADB70@BL0PR07MB5025.namprd07.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(908002)(999002)(5005026)(6040522)(8220051)(2401047)(8121501046)(3231475)(944501520)(52105112)(93006095)(93001095)(10201501046)(3002001)(6041310)(20161123558120)(20161123562045)(20161123560045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BL0PR07MB5025;BCL:0;PCL:0;RULEID:;SRVR:BL0PR07MB5025;
x-forefront-prvs: 09007040D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(39850400004)(376002)(366004)(199004)(189003)(5640700003)(7736002)(54906003)(3846002)(72206003)(6116002)(316002)(478600001)(81156014)(305945005)(8676002)(25786009)(80792005)(8936002)(186003)(26005)(81166006)(2501003)(76176011)(6506007)(99286004)(102836004)(6916009)(2906002)(386003)(446003)(2351001)(52116002)(36756003)(15650500001)(5660300001)(86362001)(11346002)(71200400001)(66066001)(71190400001)(97736004)(2616005)(53936002)(14454004)(486006)(6486002)(6436002)(4326008)(105586002)(106356001)(68736007)(1076003)(476003)(6512007)(256004)(14444005)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR07MB5025;H:BL0PR07MB4115.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jWCxq1fLBBRAaULDCvcmooE1RrZTqrWYS2N7U4RP9vqjMr62TIB6htNSC/QaKjrjuKAWwVRp0uO+lzz3p2FPuzoOrgVfxj+PskY3b7BfDmMBgpf8M4Qj7mE4rQZRSz5u46b21QLUh4p0U4KjHdemVBr0CYPaj53hOPEF7RQsbFHQ8hfn4AAZYlp9kbJN6lQIzl79E6hvakZbPyosx0Rt5wR2U/Z/wes25584LqywZlVqmmHrp0lhUoJ66ejGyliBy9JgAla6vNauVMug+obr/9dHBQ23qxG5zXMG6kV6tzN7+pmltRu2Loymve6mUIo6
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89cf216c-f6af-4825-ca67-08d66ce5e222
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2018 16:59:52.1578
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

Update device tree binding documentation specifying how to
enable BT656 with CRC decoding.

Signed-off-by: Ken Sloat <ksloat@aampglobal.com>
---
 Documentation/devicetree/bindings/media/atmel-isc.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/atmel-isc.txt b/Docume=
ntation/devicetree/bindings/media/atmel-isc.txt
index bbe0e87c6188..e787edeea7da 100644
--- a/Documentation/devicetree/bindings/media/atmel-isc.txt
+++ b/Documentation/devicetree/bindings/media/atmel-isc.txt
@@ -25,6 +25,9 @@ ISC supports a single port node with parallel bus. It sho=
uld contain one
 'port' child node with child 'endpoint' node. Please refer to the bindings
 defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
=20
+If all endpoint bus flags (i.e. hsync-active) are omitted, then CCIR656
+decoding (embedded sync) with CRC decoding is enabled.
+
 Example:
 isc: isc@f0008000 {
 	compatible =3D "atmel,sama5d2-isc";
--=20
2.17.1

