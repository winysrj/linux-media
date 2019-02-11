Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67583C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 12:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21C1E218A6
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 12:43:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="tWqeMaYd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfBKMnQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 07:43:16 -0500
Received: from mail-eopbgr750042.outbound.protection.outlook.com ([40.107.75.42]:33561
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727191AbfBKMnP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 07:43:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRQug7SNBHkzR+3IOWQr3TkGbMFynznZ47ufNM7EJ00=;
 b=tWqeMaYdEjIhB82lHlZy/XUWufu20yg09k1I8YbQC0ndYXMf8MgH9bRgALdHIydmJ5qBXyFPx/XQ6KL/8MIT3m35QDCICbvn+Bn32QKQzo4qPEHKMz2oYbAExyof0CiMyAUgTxEJR3jrs2fX4gp5qnw66EFskpKhR7VAt+TzbyQ=
Received: from CY4PR02MB2709.namprd02.prod.outlook.com (10.175.80.9) by
 CY4PR02MB2472.namprd02.prod.outlook.com (10.173.40.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Mon, 11 Feb 2019 12:43:08 +0000
Received: from CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::bc8d:c1a1:e7d9:2983]) by CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::bc8d:c1a1:e7d9:2983%10]) with mapi id 15.20.1601.023; Mon, 11 Feb
 2019 12:43:08 +0000
From:   Vishal Sagar <vsagar@xilinx.com>
To:     Luca Ceresoli <luca@lucaceresoli.net>,
        Vishal Sagar <vishal.sagar@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
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
Subject: RE: [PATCH v3 2/2] media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx
 Subsystem
Thread-Topic: [PATCH v3 2/2] media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx
 Subsystem
Thread-Index: AQHUui2l5ecr9Ru5u0itGn9PqazmdqXaeJcAgAADeXA=
Date:   Mon, 11 Feb 2019 12:43:08 +0000
Message-ID: <CY4PR02MB2709000898D5E290B5EE99F4A7640@CY4PR02MB2709.namprd02.prod.outlook.com>
References: <1549025766-135037-1-git-send-email-vishal.sagar@xilinx.com>
 <1549025766-135037-3-git-send-email-vishal.sagar@xilinx.com>
 <3923069f-7c69-c601-0ded-f7629696ef9b@lucaceresoli.net>
In-Reply-To: <3923069f-7c69-c601-0ded-f7629696ef9b@lucaceresoli.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vsagar@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR02MB2472;6:YbjDiExMJRZOu7d6+OcVPirfWNudjt9zg5dtHrQohLL1BIcwLJVrTeMsKRalgQimw+y+mlKRaX1XW07ajXf797r5mi9tR+DYVOEallXANQtT3oCrrVq8qBZBofuW34B4Nbxi2920qnQYYsdnsZBzpXYPtk612VpygrBYpxbny7KBADvpYfWRiVwcSpk47mdgvc+MhccNSsTvbGKB2oZbEAnVTvm8DnaC3sDfvtWES3+/tifAGaz8eoRsa+gyiGF8a7ePeZeqX1a9htdhFhALCTFM5wiEvd8SZItWs4zBtBEtoXxF1OBe0k2FGOLz0gbekPpLmChQBGAxA3exr3T3nlX7HAESBNl3QRrjl1KDo5Upb/gLfDqeKBT6rvM2n45eQvtgrRiUqYv1oeTIM/SAAZMO5SLGnK/JDB4GfIc6IpfCv4gt7zkZ8P6+7XsKNP3AwOiuUU9bPtINKks6/yWCiw==;5:t3pEbVa6dDC4aiOSptFL0wrJbYwo4IkGLTm4fmoZffCC0OvG5ZLdIvCWnFxDneZ+QMIiKAXYojh87gp3envXKGrdeqoz9rvFcl32N9mCbs+S8fFARbFBkkjCowQJiAaQD3cgteGv7f/3gvuivHjKbEdRVhz07Rz28/yMtWDGh9ZZrCuGcnbzEUDnmgT/E4AMq5HihHWr/PP2/bSxHKI2qw==;7:6/Yldqf+C30Xf40+rjQhdD3Z5+moK2PEha7penII7rdOBosTCIopTOQmLxZHP7GPjH0piWjwIUL7I5QX651cv+gerigT2ku2UgnXacMuiE9ys5C2p3v1VLTj7w0Dr81I9rYC82jbU/1bIprYpXYSkg==
x-ms-office365-filtering-correlation-id: 02193727-3ba2-40c8-70df-08d6901e79c5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:CY4PR02MB2472;
x-ms-traffictypediagnostic: CY4PR02MB2472:
x-microsoft-antispam-prvs: <CY4PR02MB2472B678AF11656D1C6DCA81A7640@CY4PR02MB2472.namprd02.prod.outlook.com>
x-forefront-prvs: 0945B0CC72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(39860400002)(366004)(396003)(199004)(189003)(13464003)(76176011)(97736004)(6436002)(99286004)(2501003)(55016002)(66066001)(7416002)(9686003)(6246003)(316002)(86362001)(229853002)(7696005)(2201001)(81166006)(53546011)(81156014)(6506007)(33656002)(8936002)(6116002)(26005)(6636002)(305945005)(106356001)(7736002)(8676002)(11346002)(476003)(486006)(71200400001)(71190400001)(74316002)(14454004)(102836004)(25786009)(256004)(110136005)(53936002)(2906002)(105586002)(446003)(478600001)(68736007)(3846002)(186003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR02MB2472;H:CY4PR02MB2709.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: guKH8VzbTD9gnT81mZpdhe+HpxUCjnYHnE9Xmg7A+5YzB7AvZNx7q/1fzvfr9sJVr1BVJunVz9zZosQDZEwNDRBOEZWJrtv0wmSTg+RiSxziokpHeT4KLaTDA4JAynUcga3VgFRaZxlG/A6mwfjC4DJtOwY2pDqxtEHN1KCxwl629kvDQU1zXu3e2phAjLhg7BnHKrJ1mmpn6H2DksMzEriwOpsDJ6CkeJtb9TKxS3Vux99NwXSa291pOVqpBrQg/pkH1oQ24Yi+yCnxnFXW6aAeR/Q3S57w1ogQqxJ21SIjvmBgW5REoOL6vDRei432ngvT8k/amxgxsWPZOdigKG4tkJkTjwajU8dQCczdhAQipk+VfQhz6lxcrhJp/CUYV0Ra2o+VlS6Hnig/z4LP8BZgVIvM4Cy9WrYYGDdnN8A=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02193727-3ba2-40c8-70df-08d6901e79c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2019 12:43:08.4974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB2472
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgTHVjYSwNCg0KVGhhbmtzIGZvciByZXZpZXdpbmcgdGhpcy4gDQoNCj4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTHVjYSBDZXJlc29saSBbbWFpbHRvOmx1Y2FAbHVjYWNl
cmVzb2xpLm5ldF0NCj4gU2VudDogTW9uZGF5LCBGZWJydWFyeSAxMSwgMjAxOSA0OjEyIFBNDQo+
IFRvOiBWaXNoYWwgU2FnYXIgPHZpc2hhbC5zYWdhckB4aWxpbnguY29tPjsgSHl1biBLd29uIDxo
eXVua0B4aWxpbnguY29tPjsNCj4gbGF1cmVudC5waW5jaGFydEBpZGVhc29uYm9hcmQuY29tOyBt
Y2hlaGFiQGtlcm5lbC5vcmc7DQo+IHJvYmgrZHRAa2VybmVsLm9yZzsgbWFyay5ydXRsYW5kQGFy
bS5jb207IE1pY2hhbCBTaW1law0KPiA8bWljaGFsc0B4aWxpbnguY29tPjsgbGludXgtbWVkaWFA
dmdlci5rZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgc2FrYXJpLmFp
bHVzQGxpbnV4LmludGVsLmNvbTsNCj4gaGFucy52ZXJrdWlsQGNpc2NvLmNvbTsgbGludXgtYXJt
LWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVs
Lm9yZzsgRGluZXNoIEt1bWFyIDxkaW5lc2hrQHhpbGlueC5jb20+OyBTYW5kaXAgS290aGFyaQ0K
PiA8c2FuZGlwa0B4aWxpbnguY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYzIDIvMl0gbWVk
aWE6IHY0bDogeGlsaW54OiBBZGQgWGlsaW54IE1JUEkgQ1NJLTIgUngNCj4gU3Vic3lzdGVtDQo+
IA0KPiBFWFRFUk5BTCBFTUFJTA0KPiANCj4gSGkgVmlzaGFsLA0KPiANCj4gT24gMDEvMDIvMTkg
MTM6NTYsIFZpc2hhbCBTYWdhciB3cm90ZToNCj4gPiBUaGUgWGlsaW54IE1JUEkgQ1NJLTIgUngg
U3Vic3lzdGVtIHNvZnQgSVAgaXMgdXNlZCB0byBjYXB0dXJlIGltYWdlcw0KPiA+IGZyb20gTUlQ
SSBDU0ktMiBjYW1lcmEgc2Vuc29ycyBhbmQgb3V0cHV0IEFYSTQtU3RyZWFtIHZpZGVvIGRhdGEg
cmVhZHkNCj4gPiBmb3IgaW1hZ2UgcHJvY2Vzc2luZy4gUGxlYXNlIHJlZmVyIHRvIFBHMjMyIGZv
ciBkZXRhaWxzLg0KPiANCj4gRm9yIHRob3NlIHVudXNlZCB0byBYaWxpbnggZG9jdW1lbnRhdGlv
biBJJ2QgdXNlIHRoZSBmdWxsIGRvY3VtZW50IG5hbWUNCj4gKCJNSVBJIENTSS0yIFJlY2VpdmVy
IFN1YnN5c3RlbSB2NC4wIikgb3IsIGV2ZW4gYmV0dGVyLCBhIHN0YWJsZSBVUkwgaWYNCj4gYXZh
aWxhYmxlLg0KPiANCg0KT2suIEkgd2lsbCBhZGQgdGhlIGZ1bGwgZG9jdW1lbnRhdGlvbiBuYW1l
IGhlcmUgYW5kIFVSTC4NCg0KPiA+IFRoZSBkcml2ZXIgaXMgdXNlZCB0byBzZXQgdGhlIG51bWJl
ciBvZiBhY3RpdmUgbGFuZXMsIGlmIGVuYWJsZWQNCj4gPiBpbiBoYXJkd2FyZS4gVGhlIENTSTIg
UnggY29udHJvbGxlciBmaWx0ZXJzIG91dCBhbGwgcGFja2V0cyBleGNlcHQgZm9yDQo+ID4gdGhl
IHBhY2tldHMgd2l0aCBkYXRhIHR5cGUgZml4ZWQgaW4gaGFyZHdhcmUuIFJBVzggcGFja2V0cyBh
cmUgYWx3YXlzDQo+ID4gYWxsb3dlZCB0byBwYXNzIHRocm91Z2guDQo+ID4NCj4gPiBJdCBpcyBh
bHNvIHVzZWQgdG8gc2V0dXAgYW5kIGhhbmRsZSBpbnRlcnJ1cHRzIGFuZCBlbmFibGUgdGhlIGNv
cmUuIEl0DQo+ID4gbG9ncyBhbGwgdGhlIGV2ZW50cyBpbiByZXNwZWN0aXZlIGNvdW50ZXJzIGJl
dHdlZW4gc3RyZWFtaW5nIG9uIGFuZCBvZmYuDQo+ID4gVGhlIGdlbmVyaWMgc2hvcnQgcGFja2V0
cyByZWNlaXZlZCBhcmUgbm90aWZpZWQgdG8gYXBwbGljYXRpb24gdmlhDQo+ID4gdjRsMl9ldmVu
dHMuDQo+ID4NCj4gPiBUaGUgZHJpdmVyIHN1cHBvcnRzIG9ubHkgdGhlIHZpZGVvIGZvcm1hdCBi
cmlkZ2UgZW5hYmxlZCBjb25maWd1cmF0aW9uLg0KPiA+IFNvbWUgZGF0YSB0eXBlcyBsaWtlIFlV
ViA0MjIgMTBicGMsIFJBVzE2LCBSQVcyMCBhcmUgc3VwcG9ydGVkIHdoZW4NCj4gdGhlDQo+ID4g
Q1NJIHYyLjAgZmVhdHVyZSBpcyBlbmFibGVkIGluIGRlc2lnbi4gV2hlbiB0aGUgVkNYIGZlYXR1
cmUgaXMgZW5hYmxlZCwNCj4gPiB0aGUgbWF4aW11bSBudW1iZXIgb2YgdmlydHVhbCBjaGFubmVs
cyBiZWNvbWVzIDE2IGZyb20gNC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBTYWdh
ciA8dmlzaGFsLnNhZ2FyQHhpbGlueC5jb20+DQo+IA0KPiAuLi4NCj4gDQo+ID4gKy8qKg0KPiA+
ICsgKiB4Y3NpMnJ4c3NfcmVzZXQgLSBEb2VzIGEgc29mdCByZXNldCBvZiB0aGUgTUlQSSBDU0ky
IFJ4IFN1YnN5c3RlbQ0KPiA+ICsgKiBAY29yZTogQ29yZSBYaWxpbnggQ1NJMiBSeCBTdWJzeXN0
ZW0gc3RydWN0dXJlIHBvaW50ZXINCj4gPiArICoNCj4gPiArICogQ29yZSB0YWtlcyBsZXNzIHRo
YW4gMTAwIHZpZGVvIGNsb2NrIGN5Y2xlcyB0byByZXNldC4NCj4gPiArICogU28gYSBsYXJnZXIg
dGltZW91dCB2YWx1ZSBpcyBjaG9zZW4gZm9yIG1hcmdpbi4NCj4gPiArICoNCj4gPiArICogUmV0
dXJuOiAwIC0gb24gc3VjY2VzcyBPUiAtRVRJTUUgaWYgcmVzZXQgdGltZXMgb3V0DQo+ID4gKyAq
Lw0KPiA+ICtzdGF0aWMgaW50IHhjc2kycnhzc19yZXNldChzdHJ1Y3QgeGNzaTJyeHNzX2NvcmUg
KmNvcmUpDQo+ID4gK3sNCj4gPiArICAgICB1MzIgdGltZW91dCA9IFhDU0lfVElNRU9VVF9WQUw7
DQo+IA0KPiBUaGUgY29tbWVudCBhYm91dCB0aGUgdGltZW91dCBpcyBkdXBsaWNhdGVkIGhlcmUg
YW5kIGF0IHRoZSAjZGVmaW5lDQo+IGxpbmUuIFdoeSBub3QgcmVtb3ZpbmcgdGhlIGRlZmluZSBh
Ym92ZSBhbmQganVzdCBwdXR0aW5nDQo+IA0KPiAgIHUzMiB0aW1lb3V0ID0gMTAwMDsgLyogdXMg
Ki8NCj4gDQo+IGhlcmU/IEl0IHdvdWxkIG1ha2UgdGhlIGVudGlyZSB0aW1lb3V0IGxvZ2ljIGFw
cGVhciBpbiBhIHVuaXF1ZSBwbGFjZS4NCj4gDQoNCkFncmVlLiBJdCB3YXMga2VwdCBsaWtlIHRo
YXQgYXMgdGhlIHRpbWVvdXQgdmFsdWUgd2FzIGJlaW5nIHVzZWQgaW4gc29tZSBvdGhlciBwbGFj
ZSBpbiBlYXJsaWVyIHBhdGNoIHZlcnNpb25zLg0KSSB3aWxsIGRvIGFzIHN1Z2dlc3RlZCBpbiBu
ZXh0IHZlcnNpb24uDQoNCj4gPiArc3RhdGljIGludCB4Y3NpMnJ4c3Nfc3RhcnRfc3RyZWFtKHN0
cnVjdCB4Y3NpMnJ4c3Nfc3RhdGUgKnN0YXRlKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IHhj
c2kycnhzc19jb3JlICpjb3JlID0gJnN0YXRlLT5jb3JlOw0KPiA+ICsgICAgIGludCByZXQgPSAw
Ow0KPiA+ICsNCj4gPiArICAgICB4Y3NpMnJ4c3NfZW5hYmxlKGNvcmUpOw0KPiA+ICsNCj4gPiAr
ICAgICByZXQgPSB4Y3NpMnJ4c3NfcmVzZXQoY29yZSk7DQo+ID4gKyAgICAgaWYgKHJldCA8IDAp
IHsNCj4gPiArICAgICAgICAgICAgIHN0YXRlLT5zdHJlYW1pbmcgPSBmYWxzZTsNCj4gPiArICAg
ICAgICAgICAgIHJldHVybiByZXQ7DQo+ID4gKyAgICAgfQ0KPiA+ICsNCj4gPiArICAgICB4Y3Np
MnJ4c3NfaW50cl9lbmFibGUoY29yZSk7DQo+ID4gKyAgICAgc3RhdGUtPnN0cmVhbWluZyA9IHRy
dWU7DQo+IA0KPiBTaG91bGRuJ3QgeW91IHByb3BhZ2F0ZSBzX3N0cmVhbSB0byB0aGUgdXBzdHJl
YW0gc3ViZGV2IGhlcmUgY2FsbGluZw0KPiB2NGwyX3N1YmRldl9jYWxsKC4uLiwgLi4uLCBzX3N0
cmVhbSwgMSk/DQo+IA0KDQpUaGlzIGlzIGRvbmUgYnkgdGhlIHh2aXBfcGlwZWxpbmVfc3RhcnRf
c3RvcCgpIGluIHhpbGlueC1kbWEuYyBmb3IgWGlsaW54IFZpZGVvIHBpcGVsaW5lLg0KDQo+ID4g
KyAgICAgcmV0dXJuIHJldDsNCj4gPiArfQ0KPiANCj4gDQo+IC0tDQo+IEx1Y2ENCg0KUmVnYXJk
cw0KVmlzaGFsIFNhZ2FyDQo=
