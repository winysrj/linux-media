Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0065.outbound.protection.outlook.com ([104.47.42.65]:64173
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934498AbeE3GWF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 02:22:05 -0400
From: Vishal Sagar <vsagar@xilinx.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Vishal Sagar <vishal.sagar@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Dinesh Kumar <dineshk@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx
 Subsystem driver
Date: Wed, 30 May 2018 06:22:02 +0000
Message-ID: <CY4PR02MB2709A481A94CB673DC8C87EBA76C0@CY4PR02MB2709.namprd02.prod.outlook.com>
References: <1527620084-94864-1-git-send-email-vishal.sagar@xilinx.com>
 <1527620084-94864-3-git-send-email-vishal.sagar@xilinx.com>
 <5bf470c0-8737-273e-c138-58a05d7d9a30@infradead.org>
In-Reply-To: <5bf470c0-8737-273e-c138-58a05d7d9a30@infradead.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgUmFuZHksDQoNClRoYW5rcyBmb3IgcmV2aWV3aW5nLiANCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBSYW5keSBEdW5sYXAgW21haWx0bzpyZHVubGFwQGluZnJhZGVh
ZC5vcmddDQo+IFNlbnQ6IFdlZG5lc2RheSwgTWF5IDMwLCAyMDE4IDE6MjkgQU0NCj4gVG86IFZp
c2hhbCBTYWdhciA8dmlzaGFsLnNhZ2FyQHhpbGlueC5jb20+OyBIeXVuIEt3b24gPGh5dW5rQHhp
bGlueC5jb20+Ow0KPiBsYXVyZW50LnBpbmNoYXJ0QGlkZWFzb25ib2FyZC5jb207IG1pY2hhbC5z
aW1la0B4aWxpbnguY29tOyBsaW51eC0NCj4gbWVkaWFAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0
cmVlQHZnZXIua2VybmVsLm9yZw0KPiBDYzogc2FrYXJpLmFpbHVzQGxpbnV4LmludGVsLmNvbTsg
aGFucy52ZXJrdWlsQGNpc2NvLmNvbTsNCj4gbWNoZWhhYkBrZXJuZWwub3JnOyByb2JoK2R0QGtl
cm5lbC5vcmc7IG1hcmsucnV0bGFuZEBhcm0uY29tOyBEaW5lc2gNCj4gS3VtYXIgPGRpbmVzaGtA
eGlsaW54LmNvbT47IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgt
DQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCAyLzJdIG1l
ZGlhOiB2NGw6IHhpbGlueDogQWRkIFhpbGlueCBNSVBJIENTSS0yIFJ4IFN1YnN5c3RlbQ0KPiBk
cml2ZXINCj4gDQo+IE9uIDA1LzI5LzIwMTggMTE6NTQgQU0sIFZpc2hhbCBTYWdhciB3cm90ZToN
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBTYWdhciA8dmlzaGFsLnNhZ2FyQHhpbGlu
eC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0veGlsaW54L0tjb25m
aWcgICAgICAgICAgIHwgICAxMiArDQo+ID4gIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0veGlsaW54
L01ha2VmaWxlICAgICAgICAgIHwgICAgMSArDQo+ID4gIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0v
eGlsaW54L3hpbGlueC1jc2kycnhzcy5jIHwgMTc1MQ0KPiArKysrKysrKysrKysrKysrKysrKysr
Kw0KPiA+ICBpbmNsdWRlL3VhcGkvbGludXgveGlsaW54LWNzaTJyeHNzLmggICAgICAgICAgICB8
ICAgMjUgKw0KPiA+ICBpbmNsdWRlL3VhcGkvbGludXgveGlsaW54LXY0bDItY29udHJvbHMuaCAg
ICAgICB8ICAgMTQgKw0KPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDE4MDMgaW5zZXJ0aW9ucygrKQ0K
PiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS94aWxpbngveGls
aW54LWNzaTJyeHNzLmMNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUvdWFwaS9saW51
eC94aWxpbngtY3NpMnJ4c3MuaA0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEv
cGxhdGZvcm0veGlsaW54L0tjb25maWcNCj4gYi9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL3hpbGlu
eC9LY29uZmlnDQo+ID4gaW5kZXggYTVkMjFiNy4uMDZkNTk0NCAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL21lZGlhL3BsYXRmb3JtL3hpbGlueC9LY29uZmlnDQo+ID4gKysrIGIvZHJpdmVycy9t
ZWRpYS9wbGF0Zm9ybS94aWxpbngvS2NvbmZpZw0KPiA+IEBAIC04LDYgKzgsMTggQEAgY29uZmln
IFZJREVPX1hJTElOWA0KPiA+DQo+ID4gIGlmIFZJREVPX1hJTElOWA0KPiA+DQo+ID4gK2NvbmZp
ZyBWSURFT19YSUxJTlhfQ1NJMlJYU1MNCj4gPiArICAgICAgIHRyaXN0YXRlICJYaWxpbnggQ1NJ
MiBSeCBTdWJzeXN0ZW0iDQo+ID4gKyAgICAgICBkZXBlbmRzIG9uIFZJREVPX1hJTElOWA0KPiA+
ICsgICAgICAgaGVscA0KPiA+ICsgICAgICAgICBEcml2ZXIgZm9yIFhpbGlueCBNSVBJIENTSTIg
UnggU3Vic3lzdGVtLiBUaGlzIGlzIGEgVjRMIHN1Yi1kZXZpY2UNCj4gPiArICAgICAgICAgYmFz
ZWQgZHJpdmVyIHRoYXQgdGFrZXMgaW5wdXQgZnJvbSBDU0kyIFR4IHNvdXJjZSBhbmQgY29udmVy
dHMNCj4gPiArICAgICAgICAgaXQgaW50byBhbiBBWEk0LVN0cmVhbS4gSXQgaGFzIGEgRFBIWSAo
d2hvc2UgcmVnaXN0ZXIgaW50ZXJmYWNlDQo+ID4gKyAgICAgICAgIGNhbiBiZSBlbmFibGVkLCBh
biBvcHRpb25hbCBJMkMgY29udHJvbGxlciBhbmQgYW4gb3B0aW9uYWwgVmlkZW8NCj4gDQo+IAkg
ICAgY2FuIGJlIGVuYWJsZWQpLA0KPiANCg0KTm90ZWQuIEkgd2lsbCB1cGRhdGUgaW4gbmV4dCBy
ZXZpc2lvbiBvZiBwYXRjaC4NCg0KPiA+ICsgICAgICAgICBGb3JtYXQgQnJpZGdlIHdoaWNoIGNv
bnZlcnRzIHRoZSBBWEk0LVN0cmVhbSBkYXRhIHRvIFhpbGlueCBWaWRlbw0KPiA+ICsgICAgICAg
ICBCdXMgZm9ybWF0cyBiYXNlZCBvbiBVRzkzNC4gVGhlIGRyaXZlciBpcyB1c2VkIHRvIHNldCB0
aGUgbnVtYmVyDQo+ID4gKyAgICAgICAgIG9mIGFjdGl2ZSBsYW5lcyBhbmQgZ2V0IHNob3J0IHBh
Y2tldCBkYXRhLg0KPiA+ICsNCj4gPiAgY29uZmlnIFZJREVPX1hJTElOWF9UUEcNCj4gPiAgICAg
ICAgIHRyaXN0YXRlICJYaWxpbnggVmlkZW8gVGVzdCBQYXR0ZXJuIEdlbmVyYXRvciINCj4gPiAg
ICAgICAgIGRlcGVuZHMgb24gVklERU9fWElMSU5YDQo+IA0KPiANCj4gDQo+ID4gVGhpcyBlbWFp
bCBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBpbnRlbmRlZCBmb3IgdGhlIHNvbGUgdXNlIG9mIHRo
ZSBuYW1lZA0KPiByZWNpcGllbnQocykgYW5kIGNvbnRhaW4ocykgY29uZmlkZW50aWFsIGluZm9y
bWF0aW9uIHRoYXQgbWF5IGJlIHByb3ByaWV0YXJ5LA0KPiBwcml2aWxlZ2VkIG9yIGNvcHlyaWdo
dGVkIHVuZGVyIGFwcGxpY2FibGUgbGF3LiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQNCj4g
cmVjaXBpZW50LCBkbyBub3QgcmVhZCwgY29weSwgb3IgZm9yd2FyZCB0aGlzIGVtYWlsIG1lc3Nh
Z2Ugb3IgYW55IGF0dGFjaG1lbnRzLg0KPiBEZWxldGUgdGhpcyBlbWFpbCBtZXNzYWdlIGFuZCBh
bnkgYXR0YWNobWVudHMgaW1tZWRpYXRlbHkuDQo+IA0KPiA6KA0KPiANCg0KU29ycnkgYWJvdXQg
dGhhdC4NCkkgd2lsbCB3b3JrIHdpdGggSVQgb24gZ2V0dGluZyB0aGlzIHJlbW92ZWQgYmVmb3Jl
IHNlbmRpbmcgdjIgZm9yIHRoZSBwYXRjaGVzLg0KDQotLSBWaXNoYWwgDQoNCj4gLS0NCj4gflJh
bmR5DQo=
