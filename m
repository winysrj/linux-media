Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:18842 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750722AbdJKEOj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 00:14:39 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: RE: [PATCH v2 08/12] intel-ipu3: params: compute and program ccs
Date: Wed, 11 Oct 2017 04:14:37 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE287D3@ORSMSX106.amr.corp.intel.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-9-git-send-email-yong.zhi@intel.com>
 <CAHp75Vff3tQE4NdsLJDO=7b7_5O3XW360qxOw4nbeE3i+usvhQ@mail.gmail.com>
In-Reply-To: <CAHp75Vff3tQE4NdsLJDO=7b7_5O3XW360qxOw4nbeE3i+usvhQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGksIEFuZHksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgt
bWVkaWEtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtbWVkaWEtDQo+IG93bmVy
QHZnZXIua2VybmVsLm9yZ10gT24gQmVoYWxmIE9mIEFuZHkgU2hldmNoZW5rbw0KPiBTZW50OiBG
cmlkYXksIEp1bmUgMTYsIDIwMTcgMzo1MyBQTQ0KPiBUbzogWmhpLCBZb25nIDx5b25nLnpoaUBp
bnRlbC5jb20+DQo+IENjOiBMaW51eCBNZWRpYSBNYWlsaW5nIExpc3QgPGxpbnV4LW1lZGlhQHZn
ZXIua2VybmVsLm9yZz47DQo+IHNha2FyaS5haWx1c0BsaW51eC5pbnRlbC5jb207IFpoZW5nLCBK
aWFuIFh1IDxqaWFuLnh1LnpoZW5nQGludGVsLmNvbT47DQo+IHRmaWdhQGNocm9taXVtLm9yZzsg
TWFuaSwgUmFqbW9oYW4gPHJham1vaGFuLm1hbmlAaW50ZWwuY29tPjsNCj4gVG9pdm9uZW4sIFR1
dWtrYSA8dHV1a2thLnRvaXZvbmVuQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2
MiAwOC8xMl0gaW50ZWwtaXB1MzogcGFyYW1zOiBjb21wdXRlIGFuZCBwcm9ncmFtIGNjcw0KPiAN
Cj4gT24gVGh1LCBKdW4gMTUsIDIwMTcgYXQgMToxOSBBTSwgWW9uZyBaaGkgPHlvbmcuemhpQGlu
dGVsLmNvbT4gd3JvdGU6DQo+ID4gQSBjb2xsZWN0aW9uIG9mIHJvdXRpbmVzIHRoYXQgYXJlIG1h
aW5seSByZXNwb25zaWJsZSB0byBjYWxjdWxhdGUgdGhlDQo+ID4gYWNjIHBhcmFtZXRlcnMuDQo+
IA0KPiA+ICtzdGF0aWMgdW5zaWduZWQgaW50IGlwdTNfY3NzX3NjYWxlcl9nZXRfZXhwKHVuc2ln
bmVkIGludCBjb3VudGVyLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgdW5zaWduZWQgaW50IGRpdmlkZXIpIHsNCj4gPiArICAgICAgIHVuc2lnbmVkIGlu
dCBpID0gMDsNCj4gPiArDQo+ID4gKyAgICAgICB3aGlsZSAoY291bnRlciA8PSBkaXZpZGVyIC8g
Mikgew0KPiA+ICsgICAgICAgICAgICAgICBkaXZpZGVyIC89IDI7DQo+ID4gKyAgICAgICAgICAg
ICAgIGkrKzsNCj4gPiArICAgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgICByZXR1cm4gaTsNCj4g
DQo+IFdlIGhhdmUgYSBsb3Qgb2YgZGlmZmVyZW50IGhlbHBlcnMgaW5jbHVkaW5nIG9uZSB5b3Ug
bWF5IHVzZSBpbnN0ZWFkIG9mIHRoaXMNCj4gZnVuY3Rpb24uDQo+IA0KPiBJdCdzICpoaWdobHkq
IHJlY29tbWVuZGVkIHlvdSBsZWFybiB3aGF0IHdlIGhhdmUgdW5kZXIgbGliLyAoYW5kIG5vdCBv
bmx5DQo+IHRoZXJlKSBpbiBrZXJuZWwgYmV3Zm9yZSBzdWJtaXR0aW5nIGEgbmV3IHZlcnNpb24u
DQo+IA0KDQpUcmllZCB0byBpZGVudGlmeSBtb3JlIHBsYWNlcyB0aGF0IGNvdWxkIGJlIHJlLWlt
cGxlbWVudGVkIHdpdGggbGliIGhlbHBlcnMgb3IgbW9yZSBnZW5lcmljIG1ldGhvZCwgYnV0IHdl
IGZhaWxlZCB0byBzcG90IGFueSBvYnZpb3VzIGNhbmRpZGF0ZSB0aHVzIGZhci4NCg0KPiAtLQ0K
PiBXaXRoIEJlc3QgUmVnYXJkcywNCj4gQW5keSBTaGV2Y2hlbmtvDQo=
