Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:57373 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbeCUP6s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 11:58:48 -0400
From: "Yeh, Andy" <andy.yeh@intel.com>
To: jacopo mondi <jacopo@jmondi.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>
Subject: RE: RESEND[PATCH v6 2/2] media: dw9807: Add dw9807 vcm driver
Date: Wed, 21 Mar 2018 15:58:42 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D552FBD@PGSMSX111.gar.corp.intel.com>
References: <1521219926-15329-1-git-send-email-andy.yeh@intel.com>
 <1521219926-15329-3-git-send-email-andy.yeh@intel.com>
 <20180320102817.GB5372@w540>
In-Reply-To: <20180320102817.GB5372@w540>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VGhhbmtzIGZvciB0aGUgY29tbWVudHMuIEEgcXVpY2sgcXVlc3Rpb24gZmlyc3QuIEZvciB0aGUg
cmVzZXQgd2UgbmVlZCBzb21lIHRpbWUgdG8gYWRkcmVzcy4NCg0KLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCkZyb206IGphY29wbyBtb25kaSBbbWFpbHRvOmphY29wb0BqbW9uZGkub3JnXQ0K
U2VudDogVHVlc2RheSwgTWFyY2ggMjAsIDIwMTggNjoyOCBQTQ0KVG86IFllaCwgQW5keSA8YW5k
eS55ZWhAaW50ZWwuY29tPg0KQ2M6IGxpbnV4LW1lZGlhQHZnZXIua2VybmVsLm9yZzsgc2FrYXJp
LmFpbHVzQGxpbnV4LmludGVsLmNvbTsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IENoaWFu
ZywgQWxhblggPGFsYW54LmNoaWFuZ0BpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTogUkVTRU5EW1BB
VENIIHY2IDIvMl0gbWVkaWE6IGR3OTgwNzogQWRkIGR3OTgwNyB2Y20gZHJpdmVyDQoNCkhpIEFu
ZHksDQogICBhIGZldyBjb21tZW50cyBvbiB5b3UgcGF0Y2ggYmVsb3cuLi4NCg0KT24gU2F0LCBN
YXIgMTcsIDIwMTggYXQgMDE6MDU6MjZBTSArMDgwMCwgQW5keSBZZWggd3JvdGU6DQo+IEZyb206
IEFsYW4gQ2hpYW5nIDxhbGFueC5jaGlhbmdAaW50ZWwuY29tPiANCj4gYS9kcml2ZXJzL21lZGlh
L2kyYy9kdzk4MDcuYyBiL2RyaXZlcnMvbWVkaWEvaTJjL2R3OTgwNy5jIG5ldyBmaWxlIA0KPiBt
b2RlIDEwMDY0NCBpbmRleCAwMDAwMDAwLi45NTYyNmU5DQo+IC0tLSAvZGV2L251bGwNCj4gKysr
IGIvZHJpdmVycy9tZWRpYS9pMmMvZHc5ODA3LmMNCj4gQEAgLTAsMCArMSwzMjAgQEANCj4gKy8v
IENvcHlyaWdodCAoQykgMjAxOCBJbnRlbCBDb3Jwb3JhdGlvbiAvLyBTUERYLUxpY2Vuc2UtSWRl
bnRpZmllcjogDQo+ICtHUEwtMi4wDQo+ICsNCg0KTml0OiBteSB1bmRlcnN0YW5kaW5nIGlzIHRo
YXQgdGhlIFNQRFggaWRlbnRpZmllciBnb2VzIGZpcnN0DQoNCmh0dHBzOi8vbHduLm5ldC9BcnRp
Y2xlcy83MzkxODMvDQoNCkkgY2hlY2tlZCB0aGlzIHNpdGUuIEFuZCBpdCBzYXlzIENvcHlyaWdo
dCBzaG91bGQgYmUgYmVmb3JlIFNQRFggaWRlbnRpZmllci4NCj09PT09PT09PT0gZmlsZTAxLmMg
PT09PT09PT09PQ0KLy8gQ29weXJpZ2h0IChjKSAyMDEyLTIwMTYgSm9lIFJhbmRvbSBIYWNrZXIg
Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEJTRC0yLUNsYXVzZSAuLi4NCj09PT09PT09PT0g
ZmlsZTAyLmMgPT09PT09PT09PQ0KLy8gQ29weXJpZ2h0IChjKSAyMDE3IEpvbiBTZXZlcmluc3Nv
bg0KLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEJTRC0yLUNsYXVzZSAuLi4NCj09PT09PT09
PT0gZmlsZTAzLmMgPT09PT09PT09PQ0KLy8gQ29weXJpZ2h0IChjKSAyMDA4IFRoZSBOZXRCU0Qg
Rm91bmRhdGlvbiwgSW5jLg0KLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEJTRC0yLUNsYXVz
ZS1OZXRCU0QNCg0KPiArI2luY2x1ZGUgPGxpbnV4L2FjcGkuaD4NCj4gKyNpbmNsdWRlIDxsaW51
eC9kZWxheS5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L2kyYy5oPg0KPiArI2luY2x1ZGUgPGxpbnV4
L21vZHVsZS5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L3BtX3J1bnRpbWUuaD4NCj4gKyNpbmNsdWRl
IDxtZWRpYS92NGwyLWN0cmxzLmg+DQo+ICsjaW5jbHVkZSA8bWVkaWEvdjRsMi1kZXZpY2UuaD4N
Cj4gKw0KPiArI2RlZmluZSBEVzk4MDdfTkFNRQkJImR3OTgwNyINCj4gKyNkZWZpbmUgRFc5ODA3
X01BWF9GT0NVU19QT1MJMTAyMw0KPg0K
