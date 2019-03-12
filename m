Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26A8C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 14:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B1D52087C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 14:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="dMtAwjt9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfCLOoj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 10:44:39 -0400
Received: from mail-eopbgr740053.outbound.protection.outlook.com ([40.107.74.53]:50835
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726864AbfCLOoj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 10:44:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rVzi0aZjRvKeV+tOfbo0BEUYryprqlSlcTCCqcEUFw=;
 b=dMtAwjt9Ie8qqvrfbjweR1yGZIdPupd0OzyhPI9D0i0vSW6CnxcWd9h2YcTT1yG4Q5KmturQ4bw5Hluwlf70+jhuNC2kSDLL2tP06mWKGIF+3dB+LMIHCVEUPQ+Be/dIaH2MaA0pll+aUvJlq94vvcY3MvsUOY5Qt1/xHAq7ZGs=
Received: from DM5PR02MB2713.namprd02.prod.outlook.com (10.175.85.19) by
 DM5PR02MB2250.namprd02.prod.outlook.com (10.168.174.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.18; Tue, 12 Mar 2019 14:44:33 +0000
Received: from DM5PR02MB2713.namprd02.prod.outlook.com
 ([fe80::bd91:c73c:5c47:ed13]) by DM5PR02MB2713.namprd02.prod.outlook.com
 ([fe80::bd91:c73c:5c47:ed13%3]) with mapi id 15.20.1686.021; Tue, 12 Mar 2019
 14:44:33 +0000
From:   Vishal Sagar <vsagar@xilinx.com>
To:     "Eugen.Hristev@microchip.com" <Eugen.Hristev@microchip.com>,
        "vishal.sagar@xilinx.com" <vishal.sagar@xilinx.com>,
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
Subject: RE: [PATCH v6 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Thread-Topic: [PATCH v6 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Thread-Index: AQHU2I3r9auFxgNCjUi3EIFrXk02j6YH1G+AgAA7BsA=
Date:   Tue, 12 Mar 2019 14:44:32 +0000
Message-ID: <DM5PR02MB27135A7940D4A40E8BD31FBAA7490@DM5PR02MB2713.namprd02.prod.outlook.com>
References: <1552365330-21155-1-git-send-email-vishal.sagar@xilinx.com>
 <096f280c-6a84-b116-4bee-60013728e59c@microchip.com>
In-Reply-To: <096f280c-6a84-b116-4bee-60013728e59c@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vsagar@xilinx.com; 
x-originating-ip: [122.169.237.165]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca9293f4-f87b-4b3e-f895-08d6a6f93da7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM5PR02MB2250;
x-ms-traffictypediagnostic: DM5PR02MB2250:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtETTVQUjAyTUIyMjUwOzIzOlBJQlEwUnQ3WmxUUjRUTStkYkYyTnF2c1Zr?=
 =?utf-8?B?RFN1cGxCSjE2eG80THJaZEFORGVzVVVySEYrSVcxcEMzL2p4clVYZkhXdURG?=
 =?utf-8?B?V1dXcytFMHp0WFJ0TWNOQndvUzMwNGpQL09CUm5qR3RBcnhTNmZaSTF5cXpo?=
 =?utf-8?B?OFpFQXZITWovQWltck5YWkx4OTZTbVpic09wYjZ0NVZnUTZUa1BZWUZFY2xx?=
 =?utf-8?B?bDhhWEJETG56TnMyQ2xWZTh1aTAwQzBaNndlVUFrNFVDNkthVHFqRWF0d25u?=
 =?utf-8?B?RmZMVXhXcm5iSWg0c1hXeGRwSUtqNHJsclZIdjJmMDdqTXppZ204YjRmWkVy?=
 =?utf-8?B?Y08va1BQK0pMbVBUVTE3U284YXI2TzUxY2ltQ3dJb041dzJqOFJlYkN4RVNq?=
 =?utf-8?B?d0NUVHNsMFNuNGVzQUVzU1IrM3RMVTJNZWVBNm9DRExRUGUyMldmVkVWbmJ1?=
 =?utf-8?B?cmRwamd0QTZBMkFXeS9RVFBnUVgvakRFbUN1bEdJUDBNekdIc3ZJdThCWC9I?=
 =?utf-8?B?SzRuUDJzY05ucDB6YkN6bXk0TmlHYVVtQ3lqOXE5VjY5M2NmVFUvR3F3SVor?=
 =?utf-8?B?eWVjZEpqMnVOenVjUkU0YnlXVTRuZWcwOGZ5aG9kakwrK3NuZGtjQTJuRXZn?=
 =?utf-8?B?dDZGK1ZaWlBkSDNtUzNJbzNnYnZMdjc5QktTK1NyY3ArS1h1NW05L2tmZ1NP?=
 =?utf-8?B?aUhhakdVdTBNTGw3ZzhjT0t0dHlmY0RvdnVNSjhuTllqbDZhMUViSGJvQlNu?=
 =?utf-8?B?aUVJb1Z1alVYU1kvQnNuNEN2aERBU3RoeFJHa2lxNDExWllhMWRZaXZKWlRY?=
 =?utf-8?B?cWZLQkRKZzh1ZW1lWEtvSTJhSERzcFlyMCtYK29CTFM4Q0dIYmFxS3lFakdX?=
 =?utf-8?B?ZEM3bVRNbVRSZzJyb0xSSXk1blM5MnNLYVhNa0RRVmUrc3JtSjJKMWM4S2Jz?=
 =?utf-8?B?L1JKdVYrWFFBTDZUNzFYZGx5WnJGZllkcWVLUGZQS0ZkVllrZjU4dzNWQmdG?=
 =?utf-8?B?cnQrb0NFeU42RVR0OW5GTHM3Zkk0ZU0xWWc2dGZqNDRPMGxrenFWRVp1b3d1?=
 =?utf-8?B?dVY3QVdTdDd5VGFKbmh5Njc1a1hlcURVdVJSZXJYL1hLM2oybUJZL3B2QUZ0?=
 =?utf-8?B?VS9KaTN0amNaejJqY2ZyeTIwVW11cUFzWENZV2pLVTVpU2d0NUliblFnSHlB?=
 =?utf-8?B?NjBZRDJkMThGUlh4TmJHWHJBRVhlU08yZ2xrT2RLWkYyQSs3aFJBVUFDUVAv?=
 =?utf-8?B?ZEgwNmpIVi9lN0pkR0xOa0M2U1ZVeXBUeTNyaGVMZ2UrSURyVTgvTlJCcGJx?=
 =?utf-8?B?a0dRcDNobkFocVVqZ053enQybXBnUjBvNWlzS25YbDBzclJuYiszY0NrTTNI?=
 =?utf-8?B?KzduZmZDYS9OdHdvbUZCTE9XSk1HVldvcENCV0lwQ3R3Yi9HeWdmV3VieVlz?=
 =?utf-8?B?eS9tUmVWNXdRR25YY1dCY3BtQ2oyUDFCeEkzazU4M1AyWUVXQ0F3ak00bUhV?=
 =?utf-8?B?ZzdKSlp1ZkFFcmVUc3pPUGNCSHMzQ0ZxYjVGOFlJcy94Ny9LYlNqQzEwRGhy?=
 =?utf-8?B?aGd5UlI1ZWh6by9JTlhMUmRuSzlwbHdnSm0xWmU2YlZnNXN4Q2VVSjlQMFcz?=
 =?utf-8?B?d3ZiQVM5NWZNUURLdHY3OVB6V0tJamMySTA5TDc0VzFORndtWWVpdUw5RUZu?=
 =?utf-8?B?cUpCeVlMcW91ck1Wb2VkUlN6V2hYeTR1TDAxWjg4Rk91VEVKWEp0Q0FsQzNw?=
 =?utf-8?B?TlFTTHhlMUdvbU54Z0w5Y1dtUHY1WE9MMWVXRDk5Y1M0ekJWbFVCVjBycUpF?=
 =?utf-8?Q?G+oyKQjGBMwGU?=
x-microsoft-antispam-prvs: <DM5PR02MB2250C77F0F4AC2E7593F3119A7490@DM5PR02MB2250.namprd02.prod.outlook.com>
x-forefront-prvs: 09749A275C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(366004)(376002)(346002)(13464003)(199004)(189003)(102836004)(6506007)(86362001)(53546011)(2906002)(186003)(26005)(486006)(52536013)(6436002)(7416002)(316002)(68736007)(110136005)(9686003)(55016002)(5660300002)(33656002)(2501003)(14444005)(256004)(476003)(76176011)(8936002)(99286004)(478600001)(11346002)(7696005)(446003)(71190400001)(25786009)(71200400001)(66066001)(81166006)(81156014)(105586002)(97736004)(8676002)(106356001)(7736002)(14454004)(3846002)(6636002)(6116002)(53936002)(6246003)(74316002)(229853002)(305945005)(2201001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR02MB2250;H:DM5PR02MB2713.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DYJ44M747dSWBdB9T4Ah2nnqwiX39yiH0wLWlIuTWjDBBx/tvmkxNXVTPFcRa2trSwC5DI1VYn6PKK2jBunktx9N6wBiaiLhi3VqCCwQ4OoiLkv+1YYthlZRvCD5lfwiZ9lMPaZbnOq/oNNT5QqFtC7z19No+n1pi/4+7YEMtaT1RMNOqu4JPfcLaTUuLYIdXIBeMnD4MynnXF04NjgmeyndF0ZKqdJ5LuvtwuQeHawpBwjIYtmkHNoqFeDQatob3u51GLveFH7QTXTfaalqY/ze6zSPhD+qJJxOpYsj7IHexvWjlkpXwT/ZK+o3JNxZT2QaCYnM3oXgzEI0erYpBU42C3MpCXFFzc51bo2X0N3jrBGKPSxeDjImR+uGi2FBUCccyzaIAIk3xxTL8saEb4LAZ5jsFgo5n9529EaPqeI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca9293f4-f87b-4b3e-f895-08d6a6f93da7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2019 14:44:32.9238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB2250
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQpIaSBFdWdlbiwNCg0KVGhhbmtzIGZvciByZWFjaGluZyBvdXQuDQoNCj4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXVnZW4uSHJpc3RldkBtaWNyb2NoaXAuY29tIFttYWls
dG86RXVnZW4uSHJpc3RldkBtaWNyb2NoaXAuY29tXQ0KPiBTZW50OiBUdWVzZGF5LCBNYXJjaCAx
MiwgMjAxOSA0OjMwIFBNDQo+IFRvOiB2aXNoYWwuc2FnYXJAeGlsaW54LmNvbTsgSHl1biBLd29u
IDxoeXVua0B4aWxpbnguY29tPjsNCj4gbGF1cmVudC5waW5jaGFydEBpZGVhc29uYm9hcmQuY29t
OyBtY2hlaGFiQGtlcm5lbC5vcmc7DQo+IHJvYmgrZHRAa2VybmVsLm9yZzsgbWFyay5ydXRsYW5k
QGFybS5jb207IE1pY2hhbCBTaW1law0KPiA8bWljaGFsc0B4aWxpbnguY29tPjsgbGludXgtbWVk
aWFAdmdlci5rZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgc2FrYXJp
LmFpbHVzQGxpbnV4LmludGVsLmNvbTsNCj4gaGFucy52ZXJrdWlsQGNpc2NvLmNvbTsgbGludXgt
YXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2Vy
bmVsLm9yZzsgRGluZXNoIEt1bWFyIDxkaW5lc2hrQHhpbGlueC5jb20+OyBTYW5kaXAgS290aGFy
aQ0KPiA8c2FuZGlwa0B4aWxpbnguY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY2IDAvMl0g
QWRkIHN1cHBvcnQgZm9yIFhpbGlueCBDU0kyIFJlY2VpdmVyIFN1YnN5c3RlbQ0KPiANCj4gRVhU
RVJOQUwgRU1BSUwNCj4gDQo+IE9uIDEyLjAzLjIwMTkgMDY6MzUsIFZpc2hhbCBTYWdhciB3cm90
ZToNCj4gPiBYaWxpbnggTUlQSSBDU0ktMiBSZWNlaXZlciBTdWJzeXN0ZW0NCj4gPiAtLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPg0KPiA+IFRoZSBYaWxpbnggTUlQSSBD
U0ktMiBSZWNlaXZlciBTdWJzeXN0ZW0gU29mdCBJUCBjb25zaXN0cyBvZiBhIERQSFkgd2hpY2gN
Cj4gPiBnZXRzIHRoZSBkYXRhLCBhbiBvcHRpb25hbCBJMkMsIGEgQ1NJLTIgUmVjZWl2ZXIgd2hp
Y2ggcGFyc2VzIHRoZSBkYXRhIGFuZA0KPiA+IGNvbnZlcnRzIGl0IGludG8gQVhJUyBkYXRhLg0K
PiA+IFRoaXMgc3RyZWFtIG91dHB1dCBtYXliZSBjb25uZWN0ZWQgdG8gYSBYaWxpbnggVmlkZW8g
Rm9ybWF0IEJyaWRnZS4NCj4gPiBUaGUgbWF4aW11bSBudW1iZXIgb2YgbGFuZXMgc3VwcG9ydGVk
IGlzIGZpeGVkIGluIHRoZSBkZXNpZ24uDQo+ID4gVGhlIG51bWJlciBvZiBhY3RpdmUgbGFuZXMg
Y2FuIGJlIHByb2dyYW1tZWQuDQo+ID4gRm9yIGUuZy4gdGhlIGRlc2lnbiBtYXkgc2V0IG1heGlt
dW0gbGFuZXMgYXMgNCBidXQgaWYgdGhlIGNhbWVyYSBzZW5zb3IgaGFzDQo+ID4gb25seSAxIGxh
bmUgdGhlbiB0aGUgYWN0aXZlIGxhbmVzIHNoYWxsIGJlIHNldCBhcyAxLg0KPiA+DQo+ID4gVGhl
IHBpeGVsIGZvcm1hdCBzZXQgaW4gZGVzaWduIGFjdHMgYXMgYSBmaWx0ZXIgYWxsb3dpbmcgb25s
eSB0aGUgc2VsZWN0ZWQNCj4gPiBkYXRhIHR5cGUgb3IgUkFXOCBkYXRhIHBhY2tldHMuIFRoZSBE
LVBIWSByZWdpc3RlciBhY2Nlc3MgY2FuIGJlIGdhdGVkIGluDQo+ID4gdGhlIGRlc2lnbi4gVGhl
IGJhc2UgYWRkcmVzcyBvZiB0aGUgRFBIWSBkZXBlbmRzIG9uIHdoZXRoZXIgdGhlIGludGVybmFs
DQo+ID4gWGlsaW54IEkyQyBjb250cm9sbGVyIGlzIGVuYWJsZWQgb3Igbm90IGluIGRlc2lnbi4N
Cj4gDQo+IEhpIFZpc2hhbCwNCj4gDQo+IERvIHlvdSBhbHNvIGluY2x1ZGUgYSBkcml2ZXIgZm9y
IHRoZSBEUEhZID8gTmFtZWx5IEkgYW0gaW50ZXJlc3RlZCBpbg0KPiBzb21ldGhpbmcgd2hpY2gg
Y2FuIGNvbXBseSB0byB0aGUgUEhZIHN1YnN5c3RlbSBzcGVjaWZpY2F0aW9ucywgc28gaXQNCj4g
Y2FuIGJlIHJlZmVyZW5jZWQgYnkgcG9zc2libHkgb3RoZXIgbm9kZXMgPw0KPg0KDQpObyB0aGUg
RFBIWSBkcml2ZXIgaXNuJ3QgaW5jbHVkZWQgbm93IGFzIHRoZSBEUEhZIHJlZ2lzdGVyIGludGVy
ZmFjZSBjYW4gYmUgb3B0aW9uYWxseSBlbmFibGVkLg0KQnV0IHRoZSBpZGVhIGlzIHRvIGFkZCB0
aGF0IGtpbmQgb2Ygc3VwcG9ydCBpbiBmdXR1cmUuDQoNCj4gU29tZXRoaW5nIGxpa2UgdGhpczoN
Cj4gDQo+IHhpbGlueF9kcGh5OiBkcGh5QDQwMDAwIHsNCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgIGNvbXBhdGlibGUgPSAieGxueCxkcGh5IjsNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAjcGh5LWNlbGxzID0gPDA+Ow0KPiANCj4gICAgICAgICAgICAgICAgICAgICAgICAgIHJl
ZyA9IDwweDQwMDAwIDB4MTAwPjsNCj4gDQo+ICAgICAgICAgICAgICAgICAgfTsNCj4gDQo+ICBG
cm9tIG15IHVuZGVyc3RhbmRpbmcgeW91ciBSWCBzeXN0ZW0gY2FuIGJlIHJlZmVyZW5jZWQgYXMg
YSB3aG9sZSwNCj4gd2l0aG91dCBiZWluZyBhYmxlIHRvIGhhdmUgdGhlIFBIWSBhcyBzZXBhcmF0
ZSBub2RlLCBhbmQgY3JlYXRpbmcNCj4gcmVmZXJlbmNlcyBtYXliZSBsaWtlIDoNCj4gDQo+IHBo
eXMgPSA8JnhpbGlueF9kcGh5PjsNCj4gDQoNClRydWUuIEN1cnJlbnRseSB0aGlzIGlzIGhvdyBp
dCBpcyBpbXBsZW1lbnRlZCB3aXRob3V0IHRoZSBwaHlzIGR0IGVudHJ5Lg0KDQpSZWdhcmRzDQpW
aXNoYWwgU2FnYXINCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gRXVnZW4NCj4gDQo+IA0KPiANCj4g
Pg0KPiA+IFRoZSBkZXZpY2UgZHJpdmVyIHJlZ2lzdGVycyB0aGUgTUlQSSBDU0kyIFJ4IFN1YnN5
c3RlbSBhcyBhIFY0TDIgc3ViIGRldmljZQ0KPiA+IGhhdmluZyAyIHBhZHMuIFRoZSBzaW5rIHBh
ZCBpcyBjb25uZWN0ZWQgdG8gdGhlIE1JUEkgY2FtZXJhIHNlbnNvciBhbmQNCj4gPiBvdXRwdXQg
cGFkIGlzIGNvbm5lY3RlZCB0byB0aGUgdmlkZW8gbm9kZS4NCj4gPiBSZWZlciB0byB4bG54LGNz
aTJyeHNzLnR4dCBmb3IgZGV2aWNlIHRyZWUgbm9kZSBkZXRhaWxzLg0KPiA+DQo+ID4gVGhpcyBk
cml2ZXIgaGVscHMgY29uZmlndXJlIHRoZSBudW1iZXIgb2YgYWN0aXZlIGxhbmVzIHRvIGJlIHNl
dCwgc2V0dGluZw0KPiA+IGFuZCBoYW5kbGluZyBpbnRlcnJ1cHRzIGFuZCBJUCBjb3JlIGVuYWJs
ZS4gSXQgbG9ncyB0aGUgbnVtYmVyIG9mIGV2ZW50cw0KPiA+IG9jY3VycmluZyBhY2NvcmRpbmcg
dG8gdGhlaXIgdHlwZSBiZXR3ZWVuIHN0cmVhbWluZyBPTiBhbmQgT0ZGLg0KPiA+IEl0IGdlbmVy
YXRlcyBhIHY0bDIgZXZlbnQgZm9yIGVhY2ggc2hvcnQgcGFja2V0IGRhdGEgcmVjZWl2ZWQuDQo+
ID4gVGhlIGFwcGxpY2F0aW9uIGNhbiB0aGVuIGRlcXVldWUgdGhpcyBldmVudCBhbmQgZ2V0IHRo
ZSByZXF1aXNpdGUgZGF0YQ0KPiA+IGZyb20gdGhlIGV2ZW50IHN0cnVjdHVyZS4NCj4gPg0KPiA+
IEl0IGFkZHMgbmV3IFY0TDIgY29udHJvbHMgd2hpY2ggYXJlIHVzZWQgdG8gZ2V0IHRoZSBldmVu
dCBjb3VudGVyIHZhbHVlcw0KPiA+IGFuZCByZXNldCB0aGUgc3Vic3lzdGVtLg0KPiA+DQo+ID4g
VGhlIFhpbGlueCBDU0ktMiBSeCBTdWJzeXN0ZW0gb3V0cHV0cyBhbiBBWEk0IFN0cmVhbSBkYXRh
IHdoaWNoIGNhbiBiZQ0KPiA+IHVzZWQgZm9yIGltYWdlIHByb2Nlc3NpbmcuIFRoaXMgZGF0YSBm
b2xsb3dzIHRoZSB2aWRlbyBmb3JtYXRzIG1lbnRpb25lZA0KPiA+IGluIFhpbGlueCBVRzkzNCB3
aGVuIHRoZSBWaWRlbyBGb3JtYXQgQnJpZGdlIGlzIGVuYWJsZWQuDQo+ID4NCj4gPiB2Ng0KPiA+
IC0gMS8yDQo+ID4gICAgLSBBZGRlZCBtaW5vciBjb21tZW50IGJ5IEx1Y2ENCj4gPiAgICAtIEFk
ZGVkIFJldmlld2VkIGJ5IFJvYiBIZXJyaW5nDQo+ID4gLSAyLzINCj4gPiAgICAtIE5vIGNoYW5n
ZQ0KPiA+DQo+ID4gdjUNCj4gPiAtIDEvMg0KPiA+ICAgIC0gUmVtb3ZlZCB0aGUgRFBIWSBjbG9j
ayBkZXNjcmlwdGlvbiBhbmQgZHQgbm9kZS4NCj4gPiAgICAtIHJlbW92ZWQgYmF5ZXIgcGF0dGVy
biBhcyBDU0kgZG9lc24ndCBkZWFsIHdpdGggaXQuDQo+ID4gLSAyLzINCj4gPiAgICAtIHJlbW92
ZWQgYmF5ZXIgcGF0dGVybiBhcyBDU0kgZG9lc24ndCBkZWFsIHdpdGggaXQuDQo+ID4gICAgLSBh
ZGQgWVVWNDIyIDEwYnBjIG1lZGlhIGJ1cyBmb3JtYXQuDQo+ID4NCj4gPiB2NA0KPiA+IC0gMS8y
DQo+ID4gICAgLSBBZGRlZCByZXZpZXdlZCBieSBIeXVuIEt3b24NCj4gPiAtIDIvMg0KPiA+ICAg
IC0gUmVtb3ZlZCBpcnEgbWVtYmVyIGZyb20gY29yZSBzdHJ1Y3R1cmUNCj4gPiAgICAtIENvbnNv
bGlkYXRlZCBJUCBjb25maWcgcHJpbnRzIGluIHhjc2kycnhzc19sb2dfaXBjb25maWcoKQ0KPiA+
ICAgIC0gUmV0dXJuIC1FSU5WQUwgaW4gY2FzZSBvZiBpbnZhbGlkIGlvY3RsDQo+ID4gICAgLSBD
b2RlIGZvcm1hdHRpbmcNCj4gPiAgICAtIEFkZGVkIHJldmlld2VkIGJ5IEh5dW4gS3dvbg0KPiA+
DQo+ID4gdjMNCj4gPiAtIDEvMg0KPiA+ICAgIC0gcmVtb3ZlZCBpbnRlcnJ1cHQgcGFyZW50IGFz
IHN1Z2dlc3RlZCBieSBSb2INCj4gPiAgICAtIHJlbW92ZWQgZHBoeSBjbG9jaw0KPiA+ICAgIC0g
bW92ZWQgdmZiIHRvIG9wdGlvbmFsIHByb3BlcnRpZXMNCj4gPiAgICAtIEFkZGVkIHJlcXVpcmVk
IGFuZCBvcHRpb25hbCBwb3J0IHByb3BlcnRpZXMgc2VjdGlvbg0KPiA+ICAgIC0gQWRkZWQgZW5k
cG9pbnQgcHJvcGVydHkgc2VjdGlvbg0KPiA+IC0gMi8yDQo+ID4gICAtIEZpeGVkIGNvbW1lbnRz
IGdpdmVuIGJ5IEh5dW4uDQo+ID4gICAtIFJlbW92ZWQgRFBIWSAyMDAgTUh6IGNsb2NrLiBUaGlz
IHdpbGwgYmUgY29udHJvbGxlZCBieSBEUEhZIGRyaXZlcg0KPiA+ICAgLSBNaW5vciBjb2RlIGZv
cm1hdHRpbmcNCj4gPiAgIC0gZW5fY3NpX3YyMCBhbmQgdmZiIG1lbWJlcnMgcmVtb3ZlZCBmcm9t
IHN0cnVjdCBhbmQgbWFkZSBsb2NhbCB0byBkdA0KPiBwYXJzaW5nDQo+ID4gICAtIGxvY2sgZGVz
Y3JpcHRpb24gdXBkYXRlZA0KPiA+ICAgLSBjaGFuZ2VkIHRvIHJhdGVsaW1pdGVkIHR5cGUgZm9y
IGFsbCBkZXYgcHJpbnRzIGluIGlycSBoYW5kbGVyDQo+ID4gICAtIFJlbW92ZWQgWVVWIDQyMiAx
MGJwYyBtZWRpYSBmb3JtYXQNCj4gPg0KPiA+IHYyDQo+ID4gLSAxLzINCj4gPiAgICAtIHVwZGF0
ZWQgdGhlIGNvbXBhdGlibGUgc3RyaW5nIHRvIGxhdGVzdCB2ZXJzaW9uIHN1cHBvcnRlZA0KPiA+
ICAgIC0gcmVtb3ZlZCBEUEhZIHJlbGF0ZWQgcGFyYW1ldGVycw0KPiA+ICAgIC0gYWRkZWQgQ1NJ
IHYyLjAgcmVsYXRlZCBwcm9wZXJ0eSAoaW5jbHVkaW5nIFZDWCBmb3Igc3VwcG9ydGluZyB1cHRv
IDE2DQo+ID4gICAgICB2aXJ0dWFsIGNoYW5uZWxzKS4NCj4gPiAgICAtIG1vZGlmaWVkIGNzaS1w
eGwtZm9ybWF0IGZyb20gc3RyaW5nIHRvIHVuc2lnbmVkIGludCB0eXBlIHdoZXJlIHRoZSB2YWx1
ZQ0KPiA+ICAgICAgaXMgYXMgcGVyIHRoZSBDU0kgc3BlY2lmaWNhdGlvbg0KPiA+ICAgIC0gRGVm
aW5lZCBwb3J0IDAgYW5kIHBvcnQgMSBhcyBzaW5rIGFuZCBzb3VyY2UgcG9ydHMuDQo+ID4gICAg
LSBSZW1vdmVkIG1heC1sYW5lcyBwcm9wZXJ0eSBhcyBzdWdnZXN0ZWQgYnkgUm9iIGFuZCBTYWth
cmkNCj4gPg0KPiA+IC0gMi8yDQo+ID4gICAgLSBGaXhlZCBjb21tZW50cyBnaXZlbiBieSBIeXVu
IGFuZCBTYWthcmkuDQo+ID4gICAgLSBNYWRlIGFsbCBiaXRtYXNrIHVzaW5nIEJJVCgpIGFuZCBH
RU5NQVNLKCkNCj4gPiAgICAtIFJlbW92ZWQgdW51c2VkIGRlZmluaXRpb25zDQo+ID4gICAgLSBS
ZW1vdmVkIERQSFkgYWNjZXNzLiBUaGlzIHdpbGwgYmUgZG9uZSBieSBzZXBhcmF0ZSBEUEhZIFBI
WSBkcml2ZXIuDQo+ID4gICAgLSBBZGRlZCBzdXBwb3J0IGZvciBDU0kgdjIuMCBmb3IgWVVWIDQy
MiAxMGJwYywgUkFXMTYsIFJBVzIwIGFuZCBleHRyYQ0KPiA+ICAgICAgdmlydHVhbCBjaGFubmVs
cw0KPiA+ICAgIC0gRml4ZWQgdGhlIHBvcnRzIGFzIHNpbmsgYW5kIHNvdXJjZQ0KPiA+ICAgIC0g
Tm93IHVzZSB0aGUgdjRsMmZ3bm9kZSBBUEkgdG8gZ2V0IG51bWJlciBvZiBkYXRhLWxhbmVzDQo+
ID4gICAgLSBBZGRlZCBjbG9jayBmcmFtZXdvcmsgc3VwcG9ydA0KPiA+ICAgIC0gUmVtb3ZlZCB0
aGUgY2xvc2UoKSBmdW5jdGlvbg0KPiA+ICAgIC0gdXBkYXRlZCB0aGUgc2V0IGZvcm1hdCBmdW5j
dGlvbg0KPiA+ICAgIC0gU3VwcG9ydCBvbmx5IFZGQiBlbmFibGVkIGNvbmZpZw0KPiA+DQo+ID4g
VmlzaGFsIFNhZ2FyICgyKToNCj4gPiAgICBtZWRpYTogZHQtYmluZGluZ3M6IG1lZGlhOiB4aWxp
bng6IEFkZCBYaWxpbnggTUlQSSBDU0ktMiBSeCBTdWJzeXN0ZW0NCj4gPiAgICBtZWRpYTogdjRs
OiB4aWxpbng6IEFkZCBYaWxpbnggTUlQSSBDU0ktMiBSeCBTdWJzeXN0ZW0gZHJpdmVyDQo+ID4N
Cj4gPiAgIC4uLi9iaW5kaW5ncy9tZWRpYS94aWxpbngveGxueCxjc2kycnhzcy50eHQgICAgICAg
IHwgIDExOCArKw0KPiA+ICAgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS94aWxpbngvS2NvbmZpZyAg
ICAgICAgICAgICAgfCAgIDEwICsNCj4gPiAgIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0veGlsaW54
L01ha2VmaWxlICAgICAgICAgICAgIHwgICAgMSArDQo+ID4gICBkcml2ZXJzL21lZGlhL3BsYXRm
b3JtL3hpbGlueC94aWxpbngtY3NpMnJ4c3MuYyAgICB8IDE0NjUNCj4gKysrKysrKysrKysrKysr
KysrKysNCj4gPiAgIGluY2x1ZGUvdWFwaS9saW51eC94aWxpbngtdjRsMi1jb250cm9scy5oICAg
ICAgICAgIHwgICAxNCArDQo+ID4gICBpbmNsdWRlL3VhcGkvbGludXgveGlsaW54LXY0bDItZXZl
bnRzLmggICAgICAgICAgICB8ICAgMjUgKw0KPiA+ICAgNiBmaWxlcyBjaGFuZ2VkLCAxNjMzIGlu
c2VydGlvbnMoKykNCj4gPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiBEb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbWVkaWEveGlsaW54L3hsbngsY3NpMnJ4c3MudHh0DQo+ID4gICBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS94aWxpbngveGlsaW54LWNz
aTJyeHNzLmMNCj4gPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL3VhcGkvbGludXgveGls
aW54LXY0bDItZXZlbnRzLmgNCj4gPg0K
