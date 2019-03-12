Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F11CC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 11:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04216206DF
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 11:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="nNG6+OW8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfCLLAT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 07:00:19 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:30916 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfCLLAS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 07:00:18 -0400
X-IronPort-AV: E=Sophos;i="5.58,471,1544511600"; 
   d="scan'208";a="29104485"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 12 Mar 2019 04:00:17 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 12 Mar 2019 04:00:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhZYmipEsFL2Uj8tWJI9lfsgwFZagbSGgqecMVYgMLU=;
 b=nNG6+OW8dCMzUgv7a3nadyuSrHAMxs/lJ86aN0vSo3/4zWOPtomNb/thGKILj2Doe9zKkJXRp3jCJM8yI+9aNC6tGArxvYzQlSaijQna1P/41w6NzQYro8zSC0/2YBSKvLMuprBEqwz6S/Zs9mSEKr7kSc2oNsQLDm/pHAvISlg=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1722.namprd11.prod.outlook.com (10.168.106.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.18; Tue, 12 Mar 2019 11:00:15 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e8b6:2ae9:9b9c:2ca8]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e8b6:2ae9:9b9c:2ca8%3]) with mapi id 15.20.1686.021; Tue, 12 Mar 2019
 11:00:15 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <vishal.sagar@xilinx.com>, <hyunk@xilinx.com>,
        <laurent.pinchart@ideasonboard.com>, <mchehab@kernel.org>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>, <michals@xilinx.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <sakari.ailus@linux.intel.com>, <hans.verkuil@cisco.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dineshk@xilinx.com>,
        <sandipk@xilinx.com>
Subject: Re: [PATCH v6 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Thread-Topic: [PATCH v6 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Thread-Index: AQHU2I3sAl74p+z1m0WU4c/erdLiWKYH0zSA
Date:   Tue, 12 Mar 2019 11:00:15 +0000
Message-ID: <096f280c-6a84-b116-4bee-60013728e59c@microchip.com>
References: <1552365330-21155-1-git-send-email-vishal.sagar@xilinx.com>
In-Reply-To: <1552365330-21155-1-git-send-email-vishal.sagar@xilinx.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0102CA0042.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::19) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190312125551798
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a7ce2e6-a9ad-4cb5-7689-08d6a6d9e7ba
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1722;
x-ms-traffictypediagnostic: DM5PR11MB1722:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtETTVQUjExTUIxNzIyOzIzOmFGVGgxT3RvZngzblloRjg5Z0ZVUjhYanIz?=
 =?utf-8?B?T0lRT3dLd3hlWm5hb3hQTG1ua21OTytOM3J1NndRUXhXeHE3U3VGRjBUSG9Z?=
 =?utf-8?B?WnNzaS9zOEtrU0FlMjZOVmxYUXVUdWltVkZ5S1B6aDJRbGVqcDVPMkJYVzly?=
 =?utf-8?B?YytWZjlhRzFNa0pFei9ndGJPYTdRVG5VWm01OEpJc0tNa3ZnNGtHaWJmWkU2?=
 =?utf-8?B?d056ZDJCTGZrTU5pRm5UaW5vYVlGZGxkTFp0dWpJR1pMRWwwdGxXZUNVOGtX?=
 =?utf-8?B?TXdYOTUrMEF1T0kyM1R3TGNvb1pmQ2tIR21NamhKWmNXOXRtajNxVHJITXBS?=
 =?utf-8?B?T0tuZUkyN205d2tacGRORDRmeEV6K3ovUUFZWkFTaWRnekZVMFQzTUkvYTB3?=
 =?utf-8?B?NWpOcHdYU1NmSUhWdm9yK0hGTDRScHBpM3dwa2lRUW10ZjRpWnZrUUZLeGZL?=
 =?utf-8?B?VFJ3czdlVkxYbmtvZjFRdkFOWkRqTXRKVU9uTXFXWkFKZTlQNGlsdk4yc2Zk?=
 =?utf-8?B?YzlycFJMY0JocFZ5RisxZS9SL052cWRjQXcwMzZOY3VOemxOY0UvY2pnQ0VV?=
 =?utf-8?B?MGVEbVNhRExhcjFldWUwTE0vR0g1M083Yk9mMSs0ajh1VENHNS9sRFZFUnFw?=
 =?utf-8?B?RmhEdDJMc0ZWRjRnN1JMdk5BQ1FEdUc4a3U2Mm9FZEhOdW5HZHZ3ckJzZjYv?=
 =?utf-8?B?R0t3YzlNa3B5VzdRUzVkOWtzVldzSFA1SHBGVWwwd2RIeURwcmV4ejF4V0du?=
 =?utf-8?B?REZLS21xeHNKbDJ1enJmczZOcXk0bnFaN3hNa2x3ZGZqd1RXRVlSQmg0MFlq?=
 =?utf-8?B?cm82RHZKdWxucHhvcUEzaXl3UnpYSXJRRjg2NDRlejB4NFFwWTlCZnh0eU9G?=
 =?utf-8?B?b2h5NkFZN1RKVlBmMUl3K0ZhVDJGVW1aTHpWR1l0c1RTbE9sd3U0MVdQQUx5?=
 =?utf-8?B?WWhhdVdwYll3TS8ycWVSemduTmVqZUZNTlVzbjRNNEpVSmFsdkhZSzM4SCt6?=
 =?utf-8?B?eEtnWlpsZi9BYTBCQjdTSXRlMkluUUtrZllGYUI3bkc3KzJweDZLaDhDWW0z?=
 =?utf-8?B?dGNBdytxeTBZV2drcHRjRSt5RHVCWjZ1V0V5WEYzZFppVzdDOFc1M2pOcXpw?=
 =?utf-8?B?V3NIRzMwOFFPeGpSYzF5enNGVmhEQ1M0TzBRTTZKVkJ2a2tyMTRKR0FDZDZt?=
 =?utf-8?B?cSt2UUVDY0U5Y2FvYkFFVXBYYy9qZUo0ckFJanVxbHRBVUhsZWc3VjduZ1Ar?=
 =?utf-8?B?M1lrUGZjR2wza1VvNkRrR2kzM3dpOE44SHMyTW1hRW10UVBtMEZIWjA5cEk2?=
 =?utf-8?B?cjlBSXUvYSt0K0Y2S1ZSVEdqSEpVK2xKdVpEUTdPaG1LMUkrOUhCWERacEd1?=
 =?utf-8?B?RTNWMWtHMGo3VGg4QTZaOG1OcXF3b1A5d1dMRHhkSTljNWN1NXIzVVlneVRG?=
 =?utf-8?B?UndGQU11UTNtZXVxcEZBcWJxOGkyZDhWMzlRVU5JYlVSbVFMaUFtTllRNlNH?=
 =?utf-8?B?NjhaRk8rbG5CMnhZVmhKYkR2cmwveFBDSFl4SmNINUM0NTMwMEw1czJKUmRx?=
 =?utf-8?B?UnVOSFZHR1FUWFlkRUsvZEY5a3MrbUNmZ0Q2TDZhUDdVZWhOd0NjZDJhTUZQ?=
 =?utf-8?B?Mmh0SzhqdVNhdkdLRkdwNjRVNkhBckM1U284WFoyWG5iRGdIdDlVdDgvVGth?=
 =?utf-8?B?a0EraWNMKzJMYXhGZE9ZbkxsWjdUZ0tzcitCZ0RVRmNuN3dxdkRXWVA5TzNm?=
 =?utf-8?B?N2hCQzJ6VVZGRW8xb1laemNVREg2MjVwbkNyOUwxUHd5aFpka1R1RzFpcVI3?=
 =?utf-8?B?b3VyT285ZEFDenliYUJWdHliaXUrMDg0WU5ocDA3ODNlM0E9PQ==?=
x-microsoft-antispam-prvs: <DM5PR11MB17222EC6B411DD8703712041E8490@DM5PR11MB1722.namprd11.prod.outlook.com>
x-forefront-prvs: 09749A275C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(39860400002)(136003)(396003)(189003)(199004)(110136005)(5660300002)(8936002)(53936002)(36756003)(102836004)(486006)(31686004)(6486002)(8676002)(26005)(316002)(14454004)(7416002)(7736002)(11346002)(478600001)(305945005)(6246003)(14444005)(81156014)(81166006)(105586002)(2616005)(476003)(256004)(97736004)(66066001)(386003)(72206003)(25786009)(2906002)(186003)(229853002)(6436002)(53546011)(6506007)(86362001)(31696002)(2501003)(99286004)(6512007)(6116002)(3846002)(76176011)(446003)(52116002)(71190400001)(71200400001)(2201001)(68736007)(106356001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1722;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dvk5Kzsy5BjzKOo7y7CPYkGouMZdHYXTNX6cvsP2WXr0zcnYyi7fj4cKTV5gGPEGdMu+4x3VqXn6UM6WfN7zO1yEld8KSJRxJPoWhYhTKZr8dtDnfbJyYvUWQlPqYv0S1ggykQNjrV+/y/GTjbljMBJjcouRvQKdd92LOeV9oVXL5jonI0BYtzCzJtOzVj0Epm9N0Y03rMQbObd/HGnTeWWyAIvlUysj0GrhAIDMwFt9JuMDFm+eRD4Egl2PIsyMaHAAOmLnMJEKcyGUiixZXiEAUrnIn2HNUWg5t25fLIQo1BfKYeCzvS41SJY7fI2d48AOWOxKTeb7V067bRDI32/9jOqeEAExUE+Lw51Nep0laAA+wNt1LWkekgCa2dsoco/UOfzkmi2W2omd5JLRVf5UOmeR/8J2UMQazo0JwYM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A0669642D530B499FFAACAC53E035CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a7ce2e6-a9ad-4cb5-7689-08d6a6d9e7ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2019 11:00:15.0629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1722
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDEyLjAzLjIwMTkgMDY6MzUsIFZpc2hhbCBTYWdhciB3cm90ZToNCj4gWGlsaW54IE1J
UEkgQ1NJLTIgUmVjZWl2ZXIgU3Vic3lzdGVtDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KPiANCj4gVGhlIFhpbGlueCBNSVBJIENTSS0yIFJlY2VpdmVyIFN1YnN5c3Rl
bSBTb2Z0IElQIGNvbnNpc3RzIG9mIGEgRFBIWSB3aGljaA0KPiBnZXRzIHRoZSBkYXRhLCBhbiBv
cHRpb25hbCBJMkMsIGEgQ1NJLTIgUmVjZWl2ZXIgd2hpY2ggcGFyc2VzIHRoZSBkYXRhIGFuZA0K
PiBjb252ZXJ0cyBpdCBpbnRvIEFYSVMgZGF0YS4NCj4gVGhpcyBzdHJlYW0gb3V0cHV0IG1heWJl
IGNvbm5lY3RlZCB0byBhIFhpbGlueCBWaWRlbyBGb3JtYXQgQnJpZGdlLg0KPiBUaGUgbWF4aW11
bSBudW1iZXIgb2YgbGFuZXMgc3VwcG9ydGVkIGlzIGZpeGVkIGluIHRoZSBkZXNpZ24uDQo+IFRo
ZSBudW1iZXIgb2YgYWN0aXZlIGxhbmVzIGNhbiBiZSBwcm9ncmFtbWVkLg0KPiBGb3IgZS5nLiB0
aGUgZGVzaWduIG1heSBzZXQgbWF4aW11bSBsYW5lcyBhcyA0IGJ1dCBpZiB0aGUgY2FtZXJhIHNl
bnNvciBoYXMNCj4gb25seSAxIGxhbmUgdGhlbiB0aGUgYWN0aXZlIGxhbmVzIHNoYWxsIGJlIHNl
dCBhcyAxLg0KPiANCj4gVGhlIHBpeGVsIGZvcm1hdCBzZXQgaW4gZGVzaWduIGFjdHMgYXMgYSBm
aWx0ZXIgYWxsb3dpbmcgb25seSB0aGUgc2VsZWN0ZWQNCj4gZGF0YSB0eXBlIG9yIFJBVzggZGF0
YSBwYWNrZXRzLiBUaGUgRC1QSFkgcmVnaXN0ZXIgYWNjZXNzIGNhbiBiZSBnYXRlZCBpbg0KPiB0
aGUgZGVzaWduLiBUaGUgYmFzZSBhZGRyZXNzIG9mIHRoZSBEUEhZIGRlcGVuZHMgb24gd2hldGhl
ciB0aGUgaW50ZXJuYWwNCj4gWGlsaW54IEkyQyBjb250cm9sbGVyIGlzIGVuYWJsZWQgb3Igbm90
IGluIGRlc2lnbi4NCg0KSGkgVmlzaGFsLA0KDQpEbyB5b3UgYWxzbyBpbmNsdWRlIGEgZHJpdmVy
IGZvciB0aGUgRFBIWSA/IE5hbWVseSBJIGFtIGludGVyZXN0ZWQgaW4gDQpzb21ldGhpbmcgd2hp
Y2ggY2FuIGNvbXBseSB0byB0aGUgUEhZIHN1YnN5c3RlbSBzcGVjaWZpY2F0aW9ucywgc28gaXQg
DQpjYW4gYmUgcmVmZXJlbmNlZCBieSBwb3NzaWJseSBvdGhlciBub2RlcyA/DQoNClNvbWV0aGlu
ZyBsaWtlIHRoaXM6DQoNCnhpbGlueF9kcGh5OiBkcGh5QDQwMDAwIHsNCiAgICAgICAgICAgICAg
ICAgICAgICAgICBjb21wYXRpYmxlID0gInhsbngsZHBoeSI7IA0KDQogICAgICAgICAgICAgICAg
ICAgICAgICAgI3BoeS1jZWxscyA9IDwwPjsgDQoNCiAgICAgICAgICAgICAgICAgICAgICAgICBy
ZWcgPSA8MHg0MDAwMCAweDEwMD47IA0KDQogICAgICAgICAgICAgICAgIH07DQoNCiBGcm9tIG15
IHVuZGVyc3RhbmRpbmcgeW91ciBSWCBzeXN0ZW0gY2FuIGJlIHJlZmVyZW5jZWQgYXMgYSB3aG9s
ZSwgDQp3aXRob3V0IGJlaW5nIGFibGUgdG8gaGF2ZSB0aGUgUEhZIGFzIHNlcGFyYXRlIG5vZGUs
IGFuZCBjcmVhdGluZyANCnJlZmVyZW5jZXMgbWF5YmUgbGlrZSA6DQoNCnBoeXMgPSA8JnhpbGlu
eF9kcGh5PjsNCg0KDQpUaGFua3MsDQoNCkV1Z2VuDQoNCg0KDQo+IA0KPiBUaGUgZGV2aWNlIGRy
aXZlciByZWdpc3RlcnMgdGhlIE1JUEkgQ1NJMiBSeCBTdWJzeXN0ZW0gYXMgYSBWNEwyIHN1YiBk
ZXZpY2UNCj4gaGF2aW5nIDIgcGFkcy4gVGhlIHNpbmsgcGFkIGlzIGNvbm5lY3RlZCB0byB0aGUg
TUlQSSBjYW1lcmEgc2Vuc29yIGFuZA0KPiBvdXRwdXQgcGFkIGlzIGNvbm5lY3RlZCB0byB0aGUg
dmlkZW8gbm9kZS4NCj4gUmVmZXIgdG8geGxueCxjc2kycnhzcy50eHQgZm9yIGRldmljZSB0cmVl
IG5vZGUgZGV0YWlscy4NCj4gDQo+IFRoaXMgZHJpdmVyIGhlbHBzIGNvbmZpZ3VyZSB0aGUgbnVt
YmVyIG9mIGFjdGl2ZSBsYW5lcyB0byBiZSBzZXQsIHNldHRpbmcNCj4gYW5kIGhhbmRsaW5nIGlu
dGVycnVwdHMgYW5kIElQIGNvcmUgZW5hYmxlLiBJdCBsb2dzIHRoZSBudW1iZXIgb2YgZXZlbnRz
DQo+IG9jY3VycmluZyBhY2NvcmRpbmcgdG8gdGhlaXIgdHlwZSBiZXR3ZWVuIHN0cmVhbWluZyBP
TiBhbmQgT0ZGLg0KPiBJdCBnZW5lcmF0ZXMgYSB2NGwyIGV2ZW50IGZvciBlYWNoIHNob3J0IHBh
Y2tldCBkYXRhIHJlY2VpdmVkLg0KPiBUaGUgYXBwbGljYXRpb24gY2FuIHRoZW4gZGVxdWV1ZSB0
aGlzIGV2ZW50IGFuZCBnZXQgdGhlIHJlcXVpc2l0ZSBkYXRhDQo+IGZyb20gdGhlIGV2ZW50IHN0
cnVjdHVyZS4NCj4gDQo+IEl0IGFkZHMgbmV3IFY0TDIgY29udHJvbHMgd2hpY2ggYXJlIHVzZWQg
dG8gZ2V0IHRoZSBldmVudCBjb3VudGVyIHZhbHVlcw0KPiBhbmQgcmVzZXQgdGhlIHN1YnN5c3Rl
bS4NCj4gDQo+IFRoZSBYaWxpbnggQ1NJLTIgUnggU3Vic3lzdGVtIG91dHB1dHMgYW4gQVhJNCBT
dHJlYW0gZGF0YSB3aGljaCBjYW4gYmUNCj4gdXNlZCBmb3IgaW1hZ2UgcHJvY2Vzc2luZy4gVGhp
cyBkYXRhIGZvbGxvd3MgdGhlIHZpZGVvIGZvcm1hdHMgbWVudGlvbmVkDQo+IGluIFhpbGlueCBV
RzkzNCB3aGVuIHRoZSBWaWRlbyBGb3JtYXQgQnJpZGdlIGlzIGVuYWJsZWQuDQo+IA0KPiB2Ng0K
PiAtIDEvMg0KPiAgICAtIEFkZGVkIG1pbm9yIGNvbW1lbnQgYnkgTHVjYQ0KPiAgICAtIEFkZGVk
IFJldmlld2VkIGJ5IFJvYiBIZXJyaW5nDQo+IC0gMi8yDQo+ICAgIC0gTm8gY2hhbmdlDQo+IA0K
PiB2NQ0KPiAtIDEvMg0KPiAgICAtIFJlbW92ZWQgdGhlIERQSFkgY2xvY2sgZGVzY3JpcHRpb24g
YW5kIGR0IG5vZGUuDQo+ICAgIC0gcmVtb3ZlZCBiYXllciBwYXR0ZXJuIGFzIENTSSBkb2Vzbid0
IGRlYWwgd2l0aCBpdC4NCj4gLSAyLzINCj4gICAgLSByZW1vdmVkIGJheWVyIHBhdHRlcm4gYXMg
Q1NJIGRvZXNuJ3QgZGVhbCB3aXRoIGl0Lg0KPiAgICAtIGFkZCBZVVY0MjIgMTBicGMgbWVkaWEg
YnVzIGZvcm1hdC4NCj4gDQo+IHY0DQo+IC0gMS8yDQo+ICAgIC0gQWRkZWQgcmV2aWV3ZWQgYnkg
SHl1biBLd29uDQo+IC0gMi8yDQo+ICAgIC0gUmVtb3ZlZCBpcnEgbWVtYmVyIGZyb20gY29yZSBz
dHJ1Y3R1cmUNCj4gICAgLSBDb25zb2xpZGF0ZWQgSVAgY29uZmlnIHByaW50cyBpbiB4Y3NpMnJ4
c3NfbG9nX2lwY29uZmlnKCkNCj4gICAgLSBSZXR1cm4gLUVJTlZBTCBpbiBjYXNlIG9mIGludmFs
aWQgaW9jdGwNCj4gICAgLSBDb2RlIGZvcm1hdHRpbmcNCj4gICAgLSBBZGRlZCByZXZpZXdlZCBi
eSBIeXVuIEt3b24NCj4gDQo+IHYzDQo+IC0gMS8yDQo+ICAgIC0gcmVtb3ZlZCBpbnRlcnJ1cHQg
cGFyZW50IGFzIHN1Z2dlc3RlZCBieSBSb2INCj4gICAgLSByZW1vdmVkIGRwaHkgY2xvY2sNCj4g
ICAgLSBtb3ZlZCB2ZmIgdG8gb3B0aW9uYWwgcHJvcGVydGllcw0KPiAgICAtIEFkZGVkIHJlcXVp
cmVkIGFuZCBvcHRpb25hbCBwb3J0IHByb3BlcnRpZXMgc2VjdGlvbg0KPiAgICAtIEFkZGVkIGVu
ZHBvaW50IHByb3BlcnR5IHNlY3Rpb24NCj4gLSAyLzINCj4gICAtIEZpeGVkIGNvbW1lbnRzIGdp
dmVuIGJ5IEh5dW4uDQo+ICAgLSBSZW1vdmVkIERQSFkgMjAwIE1IeiBjbG9jay4gVGhpcyB3aWxs
IGJlIGNvbnRyb2xsZWQgYnkgRFBIWSBkcml2ZXINCj4gICAtIE1pbm9yIGNvZGUgZm9ybWF0dGlu
Zw0KPiAgIC0gZW5fY3NpX3YyMCBhbmQgdmZiIG1lbWJlcnMgcmVtb3ZlZCBmcm9tIHN0cnVjdCBh
bmQgbWFkZSBsb2NhbCB0byBkdCBwYXJzaW5nDQo+ICAgLSBsb2NrIGRlc2NyaXB0aW9uIHVwZGF0
ZWQNCj4gICAtIGNoYW5nZWQgdG8gcmF0ZWxpbWl0ZWQgdHlwZSBmb3IgYWxsIGRldiBwcmludHMg
aW4gaXJxIGhhbmRsZXINCj4gICAtIFJlbW92ZWQgWVVWIDQyMiAxMGJwYyBtZWRpYSBmb3JtYXQN
Cj4gDQo+IHYyDQo+IC0gMS8yDQo+ICAgIC0gdXBkYXRlZCB0aGUgY29tcGF0aWJsZSBzdHJpbmcg
dG8gbGF0ZXN0IHZlcnNpb24gc3VwcG9ydGVkDQo+ICAgIC0gcmVtb3ZlZCBEUEhZIHJlbGF0ZWQg
cGFyYW1ldGVycw0KPiAgICAtIGFkZGVkIENTSSB2Mi4wIHJlbGF0ZWQgcHJvcGVydHkgKGluY2x1
ZGluZyBWQ1ggZm9yIHN1cHBvcnRpbmcgdXB0byAxNg0KPiAgICAgIHZpcnR1YWwgY2hhbm5lbHMp
Lg0KPiAgICAtIG1vZGlmaWVkIGNzaS1weGwtZm9ybWF0IGZyb20gc3RyaW5nIHRvIHVuc2lnbmVk
IGludCB0eXBlIHdoZXJlIHRoZSB2YWx1ZQ0KPiAgICAgIGlzIGFzIHBlciB0aGUgQ1NJIHNwZWNp
ZmljYXRpb24NCj4gICAgLSBEZWZpbmVkIHBvcnQgMCBhbmQgcG9ydCAxIGFzIHNpbmsgYW5kIHNv
dXJjZSBwb3J0cy4NCj4gICAgLSBSZW1vdmVkIG1heC1sYW5lcyBwcm9wZXJ0eSBhcyBzdWdnZXN0
ZWQgYnkgUm9iIGFuZCBTYWthcmkNCj4gDQo+IC0gMi8yDQo+ICAgIC0gRml4ZWQgY29tbWVudHMg
Z2l2ZW4gYnkgSHl1biBhbmQgU2FrYXJpLg0KPiAgICAtIE1hZGUgYWxsIGJpdG1hc2sgdXNpbmcg
QklUKCkgYW5kIEdFTk1BU0soKQ0KPiAgICAtIFJlbW92ZWQgdW51c2VkIGRlZmluaXRpb25zDQo+
ICAgIC0gUmVtb3ZlZCBEUEhZIGFjY2Vzcy4gVGhpcyB3aWxsIGJlIGRvbmUgYnkgc2VwYXJhdGUg
RFBIWSBQSFkgZHJpdmVyLg0KPiAgICAtIEFkZGVkIHN1cHBvcnQgZm9yIENTSSB2Mi4wIGZvciBZ
VVYgNDIyIDEwYnBjLCBSQVcxNiwgUkFXMjAgYW5kIGV4dHJhDQo+ICAgICAgdmlydHVhbCBjaGFu
bmVscw0KPiAgICAtIEZpeGVkIHRoZSBwb3J0cyBhcyBzaW5rIGFuZCBzb3VyY2UNCj4gICAgLSBO
b3cgdXNlIHRoZSB2NGwyZndub2RlIEFQSSB0byBnZXQgbnVtYmVyIG9mIGRhdGEtbGFuZXMNCj4g
ICAgLSBBZGRlZCBjbG9jayBmcmFtZXdvcmsgc3VwcG9ydA0KPiAgICAtIFJlbW92ZWQgdGhlIGNs
b3NlKCkgZnVuY3Rpb24NCj4gICAgLSB1cGRhdGVkIHRoZSBzZXQgZm9ybWF0IGZ1bmN0aW9uDQo+
ICAgIC0gU3VwcG9ydCBvbmx5IFZGQiBlbmFibGVkIGNvbmZpZw0KPiANCj4gVmlzaGFsIFNhZ2Fy
ICgyKToNCj4gICAgbWVkaWE6IGR0LWJpbmRpbmdzOiBtZWRpYTogeGlsaW54OiBBZGQgWGlsaW54
IE1JUEkgQ1NJLTIgUnggU3Vic3lzdGVtDQo+ICAgIG1lZGlhOiB2NGw6IHhpbGlueDogQWRkIFhp
bGlueCBNSVBJIENTSS0yIFJ4IFN1YnN5c3RlbSBkcml2ZXINCj4gDQo+ICAgLi4uL2JpbmRpbmdz
L21lZGlhL3hpbGlueC94bG54LGNzaTJyeHNzLnR4dCAgICAgICAgfCAgMTE4ICsrDQo+ICAgZHJp
dmVycy9tZWRpYS9wbGF0Zm9ybS94aWxpbngvS2NvbmZpZyAgICAgICAgICAgICAgfCAgIDEwICsN
Cj4gICBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL3hpbGlueC9NYWtlZmlsZSAgICAgICAgICAgICB8
ICAgIDEgKw0KPiAgIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0veGlsaW54L3hpbGlueC1jc2kycnhz
cy5jICAgIHwgMTQ2NSArKysrKysrKysrKysrKysrKysrKw0KPiAgIGluY2x1ZGUvdWFwaS9saW51
eC94aWxpbngtdjRsMi1jb250cm9scy5oICAgICAgICAgIHwgICAxNCArDQo+ICAgaW5jbHVkZS91
YXBpL2xpbnV4L3hpbGlueC12NGwyLWV2ZW50cy5oICAgICAgICAgICAgfCAgIDI1ICsNCj4gICA2
IGZpbGVzIGNoYW5nZWQsIDE2MzMgaW5zZXJ0aW9ucygrKQ0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0
NCBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEveGlsaW54L3hsbngsY3Np
MnJ4c3MudHh0DQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0v
eGlsaW54L3hpbGlueC1jc2kycnhzcy5jDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUv
dWFwaS9saW51eC94aWxpbngtdjRsMi1ldmVudHMuaA0KPiANCg==
