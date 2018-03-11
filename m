Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:19666 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932162AbeCKP66 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 11:58:58 -0400
From: "Yeh, Andy" <andy.yeh@intel.com>
To: Tomasz Figa <tfiga@chromium.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        "Chiang, AlanX" <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Subject: RE: [PATCH v6] media: imx258: Add imx258 camera sensor driver
Date: Sun, 11 Mar 2018 15:58:54 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D532128@PGSMSX111.gar.corp.intel.com>
References: <1520002549-6564-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5D1a1Wd0ns85rkg8cJwK+y9uYzaS=c46efOniuGhvFk+w@mail.gmail.com>
In-Reply-To: <CAAFQd5D1a1Wd0ns85rkg8cJwK+y9uYzaS=c46efOniuGhvFk+w@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

T2theS4gQWxsIGNvbW1lbnRzIGFyZSBhZGRyZXNzZWQgaW4gdjcuICAoaHR0cHM6Ly9wYXRjaHdv
cmsubGludXh0di5vcmcvcGF0Y2gvNDc4NjkvKQ0KDQpUaGFua3MgZm9yIGFsbCB0aGUgY29tbWVu
dHMgYW5kIHN1Z2dlc3Rpb25zLg0KDQpSZWdhcmRzLCBBbmR5DQoNCi0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQpGcm9tOiBUb21hc3ogRmlnYSBbbWFpbHRvOnRmaWdhQGNocm9taXVtLm9yZ10g
DQpTZW50OiBGcmlkYXksIE1hcmNoIDIsIDIwMTggMTE6NDQgUE0NClRvOiBZZWgsIEFuZHkgPGFu
ZHkueWVoQGludGVsLmNvbT4NCkNjOiBMaW51eCBNZWRpYSBNYWlsaW5nIExpc3QgPGxpbnV4LW1l
ZGlhQHZnZXIua2VybmVsLm9yZz47IFNha2FyaSBBaWx1cyA8c2FrYXJpLmFpbHVzQGxpbnV4Lmlu
dGVsLmNvbT47IENoZW4sIEphc29uWCBaIDxqYXNvbnguei5jaGVuQGludGVsLmNvbT47IENoaWFu
ZywgQWxhblggPGFsYW54LmNoaWFuZ0BpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENIIHY2
XSBtZWRpYTogaW14MjU4OiBBZGQgaW14MjU4IGNhbWVyYSBzZW5zb3IgZHJpdmVyDQoNCkhpIEFu
ZHksDQoNClRoYW5rcyBmb3IgdGhlIHBhdGNoLiBMZXQgbWUgcG9zdCBzb21lIGNvbW1lbnRzIGlu
bGluZS4NCg0KT24gRnJpLCBNYXIgMiwgMjAxOCBhdCAxMTo1NSBQTSwgQW5keSBZZWggPGFuZHku
eWVoQGludGVsLmNvbT4gd3JvdGU6DQo+IEFkZCBhIFY0TDIgc3ViLWRldmljZSBkcml2ZXIgZm9y
IHRoZSBTb255IElNWDI1OCBpbWFnZSBzZW5zb3IuDQo+IFRoaXMgaXMgYSBjYW1lcmEgc2Vuc29y
IHVzaW5nIHRoZSBJMkMgYnVzIGZvciBjb250cm9sIGFuZCB0aGUNCj4gQ1NJLTIgYnVzIGZvciBk
YXRhLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBDaGVuIDxqYXNvbnguei5jaGVuQGludGVs
LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQWxhbiBDaGlhbmcgPGFsYW54LmNoaWFuZ0BpbnRlbC5j
b20+DQo+IC0tLQ0KPiBzaW5jZSB2MjoNCj4gLS0gVXBkYXRlIHRoZSBzdHJlYW1pbmcgZnVuY3Rp
b24gdG8gcmVtb3ZlIFNXX1NUQU5EQlkgaW4gdGhlIGJlZ2lubmluZy4NCj4gLS0gQWRqdXN0IHRo
ZSBkZWxheSB0aW1lIGZyb20gMW1zIHRvIDEybXMgYmVmb3JlIHNldCBzdHJlYW0tb24gcmVnaXN0
ZXIuDQo+IHNpbmNlIHYzOg0KPiAtLSBmaXggdGhlIHNkLmVudGl0eSB0byBtYWtlIGNvZGUgYmUg
Y29tcGlsZWQgb24gdGhlIG1haW5saW5lIGtlcm5lbC4NCj4gc2luY2UgdjQ6DQo+IC0tIEVuYWJs
ZWQgQUcsIERHLCBhbmQgRXhwb3N1cmUgdGltZSBjb250cm9sIGNvcnJlY3RseS4NCj4gc2luY2Ug
djU6DQo+IC0tIFNlbnNvciB2ZW5kb3IgcHJvdmlkZWQgYSBuZXcgc2V0dGluZyB0byBmaXggZGlm
ZmVyZW50IENMSyBpc3N1ZQ0KPiAtLSBBZGQgb25lIG1vcmUgcmVzb2x1dGlvbiBmb3IgMTA0OHg3
ODAsIHVzZWQgZm9yIFZHQSBzdHJlYW1pbmcNCg0K
