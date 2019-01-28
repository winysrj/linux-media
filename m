Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AFDC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 11:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E883B214DA
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 11:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="QNALy56T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfA1LRj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 06:17:39 -0500
Received: from mail-eopbgr790074.outbound.protection.outlook.com ([40.107.79.74]:32922
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726693AbfA1LRj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 06:17:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q558L/feE83xrQAW6A3OVrnOLeE/HhFH2X3FJAunfKs=;
 b=QNALy56TBRXTXDuefY0B7WQjx7z9dedd9k6JIUkNAarYrXW0DtBRmSzjNRQ55cNnHLiiPJp4K0piQLDTYSZ2s5+horG8av3W9HudeexBOkPgF289+PPX+pnD4ecF2B1NVi1hYW7XCFwQkigRgqd9Q9t+MUm73Ux2ott1bZ7BSZA=
Received: from CY4PR02MB2709.namprd02.prod.outlook.com (10.175.59.19) by
 CY4PR02MB2423.namprd02.prod.outlook.com (10.173.38.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Mon, 28 Jan 2019 11:16:55 +0000
Received: from CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::c41a:f0ef:3b4e:6903]) by CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::c41a:f0ef:3b4e:6903%3]) with mapi id 15.20.1558.023; Mon, 28 Jan 2019
 11:16:55 +0000
From:   Vishal Sagar <vsagar@xilinx.com>
To:     Hyun Kwon <hyunk@xilinx.com>,
        Vishal Sagar <vishal.sagar@xilinx.com>
CC:     Hyun Kwon <hyunk@xilinx.com>,
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
Subject: RE: [PATCH v2 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
Thread-Topic: [PATCH v2 1/2] media: dt-bindings: media: xilinx: Add Xilinx
 MIPI CSI-2 Rx Subsystem
Thread-Index: AQHUtNbLyB/3OqWzKESYx7XdyxEw86XA0CIAgANy6DA=
Date:   Mon, 28 Jan 2019 11:16:55 +0000
Message-ID: <CY4PR02MB2709C078D872F2C1ABF82DF2A7960@CY4PR02MB2709.namprd02.prod.outlook.com>
References: <1548438777-11203-1-git-send-email-vishal.sagar@xilinx.com>
 <1548438777-11203-2-git-send-email-vishal.sagar@xilinx.com>
 <20190126021446.GA2412@smtp.xilinx.com>
In-Reply-To: <20190126021446.GA2412@smtp.xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vsagar@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR02MB2423;6:VLER3dgndl04X+Op1QrOULPxdP4GR0LlX0BgP6zY6fXFbzCqiBLxhD5dVik251h+juKQTb2ps4SzFh3JcZlE63XeMPRsnw8+1sU1ymUUSZBcoOPRioc7C/QxqvvsKdewJOqrs8ND8GM9XF7ElcMGQoPKoD3VFwI5xMjnDFDUvg0P6O+TavGIzaY3AJ9WlDZeG2raiptKCTZ6v2OmZYatGfnJpTfXSM1C99dUZiXBNyRbE8LY+wQ+ycB2fe3IlJwnbeHCYNOF6oRhuCgv5FtyNWC67Z8GtngWB5/ycAn3FGVCQDoFontzqwLYpk4MX9lUxwqhWf5ZzWOgxOn5QtFF/eJCfbDEtB6oUlwxlXllfFRsOEKLipJsgrwjFlB8dCd0YnSCj+1fVyInGkkIddnIKas6bcEdSMrk7hQluznXr10m6qx/gUHBVIiJHOwFUlAECOkm6onTjcscv2l1/5kdYQ==;5:nmVasrKmQ9rdGQ0Sl1qsTA+EyN/2sLaECcUI4cCflGHEp0vocZCsv3THmu/n4ELP9lNCnGWHfH/KJkq/4e0ZrFIY+1fz2vUlYQyO08r0DhR5BYJXOq4TBNUF2dAmS9tmL8LCOMyLbDEnc08lLoLLGMdhoQtQcJii1J9u/05knaNW8CQc8uayZCmDW2FDINXK0kdgqjiNKJ0jFu098fhFkg==;7:dnNFJMHr6ilVeUxSFOoT7wbc5DdjiXM7srw1NSRNRcvrPYjrPE9MWZm7DEz90SI7I9jp9UKajJBRpfa2KBnSmNYbI4+oHq1f3i+YLCdjb/HWXuv5WNZ4yKZOjMqmz/gZpHUnj+qxM4HjTjnqvrleQg==
x-ms-office365-filtering-correlation-id: be48bb25-23c9-42ad-75e4-08d685121cda
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:CY4PR02MB2423;
x-ms-traffictypediagnostic: CY4PR02MB2423:
x-microsoft-antispam-prvs: <CY4PR02MB242318CC91FAC1875403B985A7960@CY4PR02MB2423.namprd02.prod.outlook.com>
x-forefront-prvs: 0931CB1479
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(346002)(376002)(366004)(51914003)(13464003)(199004)(189003)(256004)(14444005)(14454004)(99286004)(66066001)(229853002)(71190400001)(71200400001)(446003)(6436002)(76176011)(476003)(7696005)(105586002)(11346002)(110136005)(54906003)(486006)(316002)(86362001)(97736004)(478600001)(81156014)(3846002)(6116002)(53936002)(55016002)(25786009)(8936002)(106356001)(4326008)(26005)(8676002)(2906002)(7416002)(6636002)(53546011)(68736007)(102836004)(6246003)(6506007)(74316002)(107886003)(33656002)(9686003)(305945005)(7736002)(81166006)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR02MB2423;H:CY4PR02MB2709.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fAs8qugsfXb0tj38OUhEx+yT+ZrthIf83BfMSj2QwuhBr/+o8S8paTkNje2RldXImd9PKL2dgmp/XzQkWxxYsuxKC2OT7qazX+3pUXJQYotbwxtC+05YbdFjTjalC0FXW5yV2pjWia1n2z2nGgULq8cK2LkevW6JRFc1M/NKmbBKCMMcCnDHUqD2EX7OlN4wbu9YHB78rp90cqTNVoNQ9id6IDcIuOolyBHbiOHIWTNMqcc6t7tjunwYS5DvQ7PvQg5ptvn42zDAMeH9XEVco4RmtQh8iPz2Z78AJ4H9gpzG4dsuAcBO1IIXgdIbVtQ13h28qttK9J5jvXhbo1/DxroIrHC0isOxSxcOL7PlAACjay6MXagTvsIuRbasS9OPIhEVlO+VWIHEaSVFYhYSftLB5i2Z+NcDFHWztbOW5bY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be48bb25-23c9-42ad-75e4-08d685121cda
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2019 11:16:55.8607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB2423
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgSHl1biwNCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3LiANCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBIeXVuIEt3b24gW21haWx0bzpoeXVuLmt3b25AeGlsaW54LmNv
bV0NCj4gU2VudDogU2F0dXJkYXksIEphbnVhcnkgMjYsIDIwMTkgNzo0NSBBTQ0KPiBUbzogVmlz
aGFsIFNhZ2FyIDx2aXNoYWwuc2FnYXJAeGlsaW54LmNvbT4NCj4gQ2M6IEh5dW4gS3dvbiA8aHl1
bmtAeGlsaW54LmNvbT47IGxhdXJlbnQucGluY2hhcnRAaWRlYXNvbmJvYXJkLmNvbTsNCj4gbWNo
ZWhhYkBrZXJuZWwub3JnOyByb2JoK2R0QGtlcm5lbC5vcmc7IG1hcmsucnV0bGFuZEBhcm0uY29t
OyBNaWNoYWwNCj4gU2ltZWsgPG1pY2hhbHNAeGlsaW54LmNvbT47IGxpbnV4LW1lZGlhQHZnZXIu
a2VybmVsLm9yZzsNCj4gZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IHNha2FyaS5haWx1c0Bs
aW51eC5pbnRlbC5jb207DQo+IGhhbnMudmVya3VpbEBjaXNjby5jb207IGxpbnV4LWFybS1rZXJu
ZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7
IERpbmVzaCBLdW1hciA8ZGluZXNoa0B4aWxpbnguY29tPjsgU2FuZGlwIEtvdGhhcmkNCj4gPHNh
bmRpcGtAeGlsaW54LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAxLzJdIG1lZGlhOiBk
dC1iaW5kaW5nczogbWVkaWE6IHhpbGlueDogQWRkIFhpbGlueCBNSVBJDQo+IENTSS0yIFJ4IFN1
YnN5c3RlbQ0KPiANCj4gSGkgVmlzaGFsLA0KPiANCj4gVGhhbmtzIGZvciB0aGUgcGF0Y2guDQo+
IA0KPiBPbiBGcmksIDIwMTktMDEtMjUgYXQgMDk6NTI6NTYgLTA4MDAsIFZpc2hhbCBTYWdhciB3
cm90ZToNCj4gPiBBZGQgYmluZGluZ3MgZG9jdW1lbnRhdGlvbiBmb3IgWGlsaW54IE1JUEkgQ1NJ
LTIgUnggU3Vic3lzdGVtLg0KPiA+DQo+ID4gVGhlIFhpbGlueCBNSVBJIENTSS0yIFJ4IFN1YnN5
c3RlbSBjb25zaXN0cyBvZiBhIENTSS0yIFJ4IGNvbnRyb2xsZXIsIGENCj4gPiBEUEhZIGluIFJ4
IG1vZGUsIGFuIG9wdGlvbmFsIEkyQyBjb250cm9sbGVyIGFuZCBhIFZpZGVvIEZvcm1hdCBCcmlk
Z2UuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWaXNoYWwgU2FnYXIgPHZpc2hhbC5zYWdhckB4
aWxpbnguY29tPg0KPiA+IC0tLQ0KPiA+IHYyDQo+ID4gLSB1cGRhdGVkIHRoZSBjb21wYXRpYmxl
IHN0cmluZyB0byBsYXRlc3QgdmVyc2lvbiBzdXBwb3J0ZWQNCj4gPiAtIHJlbW92ZWQgRFBIWSBy
ZWxhdGVkIHBhcmFtZXRlcnMNCj4gPiAtIGFkZGVkIENTSSB2Mi4wIHJlbGF0ZWQgcHJvcGVydHkg
KGluY2x1ZGluZyBWQ1ggZm9yIHN1cHBvcnRpbmcgdXB0byAxNg0KPiA+ICAgdmlydHVhbCBjaGFu
bmVscykuDQo+ID4gLSBtb2RpZmllZCBjc2ktcHhsLWZvcm1hdCBmcm9tIHN0cmluZyB0byB1bnNp
Z25lZCBpbnQgdHlwZSB3aGVyZSB0aGUgdmFsdWUNCj4gPiAgIGlzIGFzIHBlciB0aGUgQ1NJIHNw
ZWNpZmljYXRpb24NCj4gPiAtIERlZmluZWQgcG9ydCAwIGFuZCBwb3J0IDEgYXMgc2luayBhbmQg
c291cmNlIHBvcnRzLg0KPiA+IC0gUmVtb3ZlZCBtYXgtbGFuZXMgcHJvcGVydHkgYXMgc3VnZ2Vz
dGVkIGJ5IFJvYiBhbmQgU2FrYXJpDQo+ID4NCj4gPiAgLi4uL2JpbmRpbmdzL21lZGlhL3hpbGlu
eC94bG54LGNzaTJyeHNzLnR4dCAgICAgICAgfCAxMDUNCj4gKysrKysrKysrKysrKysrKysrKysr
DQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMDUgaW5zZXJ0aW9ucygrKQ0KPiA+ICBjcmVhdGUgbW9k
ZSAxMDA2NDQNCj4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL3hpbGlu
eC94bG54LGNzaTJyeHNzLnR4dA0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS94aWxpbngveGxueCxjc2kycnhzcy50eHQNCj4gYi9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEveGlsaW54L3hsbngsY3NpMnJ4
c3MudHh0DQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwLi45ODc4
MWNmDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9tZWRpYS94aWxpbngveGxueCxjc2kycnhzcy50eHQNCj4gPiBAQCAtMCwwICsx
LDEwNSBAQA0KPiA+ICtYaWxpbnggTUlQSSBDU0kyIFJlY2VpdmVyIFN1YnN5c3RlbSBEZXZpY2Ug
VHJlZSBCaW5kaW5ncw0KPiA+ICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICsNCj4gPiArVGhlIFhpbGlueCBNSVBJIENTSTIgUmVj
ZWl2ZXIgU3Vic3lzdGVtIGlzIHVzZWQgdG8gY2FwdHVyZSBNSVBJIENTSTIgdHJhZmZpYw0KPiA+
ICtmcm9tIGNvbXBsaWFudCBjYW1lcmEgc2Vuc29ycyBhbmQgc2VuZCB0aGUgb3V0cHV0IGFzIEFY
STQgU3RyZWFtIHZpZGVvDQo+IGRhdGENCj4gPiArZm9yIGltYWdlIHByb2Nlc3NpbmcuDQo+ID4g
Kw0KPiA+ICtUaGUgc3Vic3lzdGVtIGNvbnNpc3RzIG9mIGEgTUlQSSBEUEhZIGluIHNsYXZlIG1v
ZGUgd2hpY2ggY2FwdHVyZXMgdGhlDQo+ID4gK2RhdGEgcGFja2V0cy4gVGhpcyBpcyBwYXNzZWQg
YWxvbmcgdGhlIE1JUEkgQ1NJMiBSeCBJUCB3aGljaCBleHRyYWN0cyB0aGUNCj4gPiArcGFja2V0
IGRhdGEuIFRoZSBWaWRlbyBGb3JtYXQgQnJpZGdlIChWRkIpIGNvbnZlcnRzIHRoaXMgZGF0YSB0
byBBWEk0DQo+IFN0cmVhbQ0KPiA+ICt2aWRlbyBkYXRhLg0KPiA+ICsNCj4gPiArRm9yIG1vcmUg
ZGV0YWlscywgcGxlYXNlIHJlZmVyIHRvIFBHMjMyIFhpbGlueCBNSVBJIENTSS0yIFJlY2VpdmVy
IFN1YnN5c3RlbS4NCj4gPiArDQo+ID4gK1JlcXVpcmVkIHByb3BlcnRpZXM6DQo+ID4gKy0tLS0t
LS0tLS0tLS0tLS0tLS0tDQo+ID4gKy0gY29tcGF0aWJsZTogTXVzdCBjb250YWluICJ4bG54LG1p
cGktY3NpMi1yeC1zdWJzeXN0ZW0tNC4wIi4NCj4gPiArLSByZWc6IFBoeXNpY2FsIGJhc2UgYWRk
cmVzcyBhbmQgbGVuZ3RoIG9mIHRoZSByZWdpc3RlcnMgc2V0IGZvciB0aGUgZGV2aWNlLg0KPiA+
ICstIGludGVycnVwdC1wYXJlbnQ6IHNwZWNpZmllcyB0aGUgcGhhbmRsZSB0byB0aGUgcGFyZW50
IGludGVycnVwdCBjb250cm9sbGVyDQo+ID4gKy0gaW50ZXJydXB0czogUHJvcGVydHkgd2l0aCBh
IHZhbHVlIGRlc2NyaWJpbmcgdGhlIGludGVycnVwdCBudW1iZXIuDQo+ID4gKy0gY2xvY2tzOiBM
aXN0IG9mIHBoYW5kbGVzIHRvIEFYSSBMaXRlLCBWaWRlbyBhbmQgMjAwIE1IeiBEUEhZIGNsb2Nr
cy4NCj4gPiArLSBjbG9jay1uYW1lczogTXVzdCBjb250YWluICJsaXRlX2FjbGsiLCAidmlkZW9f
YWNsayIgYW5kICJkcGh5X2Nsa18yMDBNIg0KPiBpbg0KPiA+ICsgIHRoZSBzYW1lIG9yZGVyIGFz
IGNsb2NrcyBsaXN0ZWQgaW4gY2xvY2tzIHByb3BlcnR5Lg0KPiA+ICstIHhsbngsY3NpLXB4bC1m
b3JtYXQ6IFRoaXMgZGVub3RlcyB0aGUgQ1NJIERhdGEgdHlwZSBzZWxlY3RlZCBpbiBodyBkZXNp
Z24uDQo+ID4gKyAgUGFja2V0cyBvdGhlciB0aGFuIHRoaXMgZGF0YSB0eXBlIChleGNlcHQgZm9y
IFJBVzggYW5kIFVzZXIgZGVmaW5lZCBkYXRhDQo+ID4gKyAgdHlwZXMpIHdpbGwgYmUgZmlsdGVy
ZWQgb3V0LiBQb3NzaWJsZSB2YWx1ZXMgYXJlIGFzIGJlbG93IC0NCj4gPiArICAweDFFIC0gWVVW
NDIyOEINCj4gPiArICAweDFGIC0gWVVWNDIyMTBCDQo+ID4gKyAgMHgyMCAtIFJHQjQ0NA0KPiA+
ICsgIDB4MjEgLSBSR0I1NTUNCj4gPiArICAweDIyIC0gUkdCNTY1DQo+ID4gKyAgMHgyMyAtIFJH
QjY2Ng0KPiA+ICsgIDB4MjQgLSBSR0I4ODgNCj4gPiArICAweDI4IC0gUkFXNg0KPiA+ICsgIDB4
MjkgLSBSQVc3DQo+ID4gKyAgMHgyQSAtIFJBVzgNCj4gPiArICAweDJCIC0gUkFXMTANCj4gPiAr
ICAweDJDIC0gUkFXMTINCj4gPiArICAweDJEIC0gUkFXMTQNCj4gPiArICAweDJFIC0gUkFXMTYN
Cj4gPiArICAweDJGIC0gUkFXMjANCj4gPiArLSB4bG54LHZmYjogVGhpcyBpcyBwcmVzZW50IHdo
ZW4gVmlkZW8gRm9ybWF0IEJyaWRnZSBpcyBlbmFibGVkLg0KPiANCj4gSXNuJ3QgdGhpcyBvcHRp
b25hbCBhcyB3ZWxsPw0KDQpPayB0aGlzIHdpbGwgYmUgdXBkYXRlZCBpbiBuZXh0IHJldmlzaW9u
LiANCldoZW4gdGhpcyBwcm9wZXJ0eSBpcyBub3QgcHJlc2VudCwgdGhlIGRyaXZlciBwcm9iZSB3
aWxsIGZhaWwgYXMgdGhlIG91dHB1dCBvZiB0aGUgSVAgd2lsbCBub3QgbWF0Y2ggdGhlIG1lZGlh
IGJ1cyBmb3JtYXRzLg0KDQo+IA0KPiA+ICsNCj4gPiArT3B0aW9uYWwgcHJvcGVydGllczoNCj4g
PiArLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiArLSB4bG54LGVuLWNzaS12Mi0wOiBQcmVzZW50
IGlmIENTSSB2MiBpcyBlbmFibGVkIGluIElQIGNvbmZpZ3VyYXRpb24uDQo+ID4gKy0geGxueCxl
bi12Y3g6IFdoZW4gcHJlc2VudCwgdGhlcmUgYXJlIG1heGltdW0gMTYgdmlydHVhbCBjaGFubmVs
cywgZWxzZQ0KPiA+ICsgIG9ubHkgNC4gVGhpcyBpcyBwcmVzZW50IG9ubHkgaWYgeGxueCxlbi1j
c2ktdjItMCBpcyBwcmVzZW50Lg0KPiA+ICstIHhsbngsZW4tYWN0aXZlLWxhbmVzOiBFbmFibGUg
QWN0aXZlIGxhbmVzIGNvbmZpZ3VyYXRpb24gaW4gUHJvdG9jb2wNCj4gPiArICBDb25maWd1cmF0
aW9uIFJlZ2lzdGVyLg0KPiA+ICstIHhsbngsY2ZhLXBhdHRlcm46IFRoaXMgZ29lcyBpbiB0aGUg
c2luayBwb3J0IHRvIGluZGljYXRlIGJheWVyIHBhdHRlcm4uDQo+ID4gKyAgVmFsaWQgdmFsdWVz
IGFyZSAiYmdnciIsICJyZ2diIiwgImdicmciIGFuZCAiZ3JiZyIuDQo+ID4gKw0KPiA+ICtQb3J0
cw0KPiA+ICstLS0tLQ0KPiA+ICtUaGUgZGV2aWNlIG5vZGUgc2hhbGwgY29udGFpbiB0d28gJ3Bv
cnQnIGNoaWxkIG5vZGVzIGFzIGRlZmluZWQgaW4NCj4gPiArRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL21lZGlhL3ZpZGVvLWludGVyZmFjZXMudHh0Lg0KPiA+ICsNCj4gPiArVGhl
IHBvcnRAMCBpcyBzaW5rIHBvcnQgYW5kIHNoYWxsIGNvbm5lY3QgdG8gQ1NJMiBzb3VyY2UgbGlr
ZSBjYW1lcmEuDQo+ID4gK0l0IG11c3QgaGF2ZSB0aGUgZGF0YS1sYW5lcyBwcm9wZXJ0eS4gSXQg
bWF5IGhhdmUgdGhlIHhsbngsY2ZhLXBhdHRlcm4NCj4gPiArcHJvcGVydHkgdG8gaW5kaWNhdGUg
YmF5ZXIgcGF0dGVybiBvZiBzb3VyY2UuDQo+IA0KPiBUaGVzZSB0d28gcHJvcGVydGllcyBiZXR0
ZXIgYmUgc3BlbGxlZCBvdXQgcHJvcGVybHkuIE1heWJlIGJldHRlciB0byBtZW50aW9uDQo+IHRo
ZSBkYXRhLWxhbmVzIGlzIGZyb20gdmlkZW8taW50ZXJmYWNlcy50eHQuDQoNCk9rLiBJIHdpbGwg
ZG9jdW1lbnQgZWFjaCBwb3J0IHdpdGggaXRzIHByb3BlcnRpZXMgdW5kZXIgYSBQb3J0cyBzZWN0
aW9uDQpBbmQgc2VuZCBpdCBhY3Jvc3MgaW4gdGhlIG5leHQgcmV2aXNpb24uIA0KDQpSZWdhcmRz
DQpWaXNoYWwgU2FnYXINCg0KDQo+IA0KPiBUaGFua3MsDQo+IC1oeXVuDQo+IA0KPiA+ICsNCj4g
PiArVGhlIHBvcnRAMSBpcyBzb3VyY2UgcG9ydCBjb3VsZCBiZSBjb25uZWN0ZWQgdG8gYW55IHZp
ZGVvIHByb2Nlc3NpbmcgSVANCj4gPiArd2hpY2ggY2FuIHdvcmsgd2l0aCBBWEk0IFN0cmVhbSBk
YXRhLg0KPiA+ICsNCj4gPiArQm90aCBwb3J0cyBtdXN0IGhhdmUgcmVtb3RlLWVuZHBvaW50cy4N
Cj4gPiArDQo+ID4gK0V4YW1wbGU6DQo+ID4gKw0KPiA+ICsJY3Npc3NfMTogY3Npc3NAYTAwMjAw
MDAgew0KPiA+ICsJCWNvbXBhdGlibGUgPSAieGxueCxtaXBpLWNzaTItcngtc3Vic3lzdGVtLTQu
MCI7DQo+ID4gKwkJcmVnID0gPDB4MCAweGEwMDIwMDAwIDB4MCAweDEwMDAwPjsNCj4gPiArCQlp
bnRlcnJ1cHQtcGFyZW50ID0gPCZnaWM+Ow0KPiA+ICsJCWludGVycnVwdHMgPSA8MCA5NSA0PjsN
Cj4gPiArCQl4bG54LGNzaS1weGwtZm9ybWF0ID0gPDB4MmE+Ow0KPiA+ICsJCXhsbngsdmZiOw0K
PiA+ICsJCXhsbngsZW4tYWN0aXZlLWxhbmVzOw0KPiA+ICsJCXhsbngsZW4tY3NpLXYyLTA7DQo+
ID4gKwkJeGxueCxlbi12Y3g7DQo+ID4gKwkJY2xvY2stbmFtZXMgPSAibGl0ZV9hY2xrIiwgImRw
aHlfY2xrXzIwME0iLCAidmlkZW9fYWNsayI7DQo+ID4gKwkJY2xvY2tzID0gPCZtaXNjX2Nsa18w
PiwgPCZtaXNjX2Nsa18xPiwgPCZtaXNjX2Nsa18yPjsNCj4gPiArDQo+ID4gKwkJcG9ydHMgew0K
PiA+ICsJCQkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCj4gPiArCQkJI3NpemUtY2VsbHMgPSA8MD47
DQo+ID4gKw0KPiA+ICsJCQlwb3J0QDAgew0KPiA+ICsJCQkJLyogU2luayBwb3J0ICovDQo+ID4g
KwkJCQlyZWcgPSA8MD47DQo+ID4gKwkJCQl4bG54LGNmYS1wYXR0ZXJuID0gImJnZ3IiDQo+ID4g
KwkJCQljc2lzc19pbjogZW5kcG9pbnQgew0KPiA+ICsJCQkJCWRhdGEtbGFuZXMgPSA8MSAyIDMg
ND47DQo+ID4gKwkJCQkJLyogTUlQSSBDU0kyIENhbWVyYSBoYW5kbGUgKi8NCj4gPiArCQkJCQly
ZW1vdGUtZW5kcG9pbnQgPSA8JmNhbWVyYV9vdXQ+Ow0KPiA+ICsJCQkJfTsNCj4gPiArCQkJfTsN
Cj4gPiArCQkJcG9ydEAxIHsNCj4gPiArCQkJCS8qIFNvdXJjZSBwb3J0ICovDQo+ID4gKwkJCQly
ZWcgPSA8MT47DQo+ID4gKwkJCQljc2lzc19vdXQ6IGVuZHBvaW50IHsNCj4gPiArCQkJCQlyZW1v
dGUtZW5kcG9pbnQgPSA8JnZwcm9jX2luPjsNCj4gPiArCQkJCX07DQo+ID4gKwkJCX07DQo+ID4g
KwkJfTsNCj4gPiArCX07DQo+ID4gLS0NCj4gPiAyLjcuNA0KPiA+DQo=
