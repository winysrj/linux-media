Return-path: <mchehab@pedra>
Received: from mga09.intel.com ([134.134.136.24]:47455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab1BIH2I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 02:28:08 -0500
From: "Wang, Wen W" <wen.w.wang@intel.com>
To: "Kanigeri, Hari K" <hari.k.kanigeri@intel.com>,
	"Iyer, Sundar" <sundar.iyer@intel.com>,
	"Yang, Jianwei" <jianwei.yang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"umg-meego-handset-kernel@umglistsvr.jf.intel.com"
	<umg-meego-handset-kernel@umglistsvr.jf.intel.com>
CC: Jozef Kruger <jozef.kruger@siliconhive.com>
Date: Wed, 9 Feb 2011 15:27:27 +0800
Subject: RE: Memory allocation in Video4Linux
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A32F92445@shsmsx501.ccr.corp.intel.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
	<D5AB6E638E5A3E4B8F4406B113A5A19A32F923D8@shsmsx501.ccr.corp.intel.com>
	<D5AB6E638E5A3E4B8F4406B113A5A19A32F923DC@shsmsx501.ccr.corp.intel.com>
 <C039722627B15F489AB215B00C0A3E6608B074BC74@bgsmsx501.gar.corp.intel.com>
 <A787B2DEAF88474996451E847A0AFAB7F264B7A4@rrsmsx508.amr.corp.intel.com>
In-Reply-To: <A787B2DEAF88474996451E847A0AFAB7F264B7A4@rrsmsx508.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

SGkgSGFyaSwNCg0KWW91IGFyZSByaWdodC4gV2hhdCB3ZSBuZWVkIGlzIHZpcnR1YWwgYWRkcmVz
cy4NCg0KQ3VycmVudGx5IHdlIGFsbG9jIHBhZ2VzIChhbGxvY19wYWdlcygpKSBmb3IgYW55IHJl
cXVlc3QuIFN0b3JlIHRob3NlIHBhZ2VzIGZvciBhbiBpbWFnZSBidWZmZXIgaW50byBhIGxpc3Qu
IFdlIGFsc28gbWFuYWdlIHRoZSB2aXJ0dWFsIGFkZHJlc3MgZm9yIElTUCBieSBvdXJzZWxmICh0
aGUgcmFuZ2UgZnJvbSAwIHRvIDRHQikgYW5kIHRoZSBwYWdlIHRhYmxlIGZvciBvdXIgTU1VIHdo
aWNoIGlzIGluZGVwZW5kZW50IHRvIHN5c3RlbSBNTVUgcGFnZSB0YWJsZS4NCg0KVGhhbmtzDQpX
ZW4NCg0KPi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogS2FuaWdlcmksIEhhcmkg
Sw0KPlNlbnQ6IDIwMTHE6jLUwjnI1SAxNToyMg0KPlRvOiBJeWVyLCBTdW5kYXI7IFdhbmcsIFdl
biBXOyBZYW5nLCBKaWFud2VpOyBsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmc7DQo+dW1nLW1l
ZWdvLWhhbmRzZXQta2VybmVsQHVtZ2xpc3RzdnIuamYuaW50ZWwuY29tDQo+Q2M6IEpvemVmIEty
dWdlcg0KPlN1YmplY3Q6IFJFOiBNZW1vcnkgYWxsb2NhdGlvbiBpbiBWaWRlbzRMaW51eA0KPg0K
Pg0KPg0KPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4+IEZyb206IHVtZy1tZWVnby1o
YW5kc2V0LWtlcm5lbC1ib3VuY2VzQHVtZ2xpc3RzdnIuamYuaW50ZWwuY29tDQo+PiBbbWFpbHRv
OnVtZy1tZWVnby1oYW5kc2V0LWtlcm5lbC1ib3VuY2VzQHVtZ2xpc3RzdnIuamYuaW50ZWwuY29t
XSBPbg0KPj4gQmVoYWxmIE9mIEl5ZXIsIFN1bmRhcg0KPj4gU2VudDogV2VkbmVzZGF5LCBGZWJy
dWFyeSAwOSwgMjAxMSAxMjoyMCBQTQ0KPj4gVG86IFdhbmcsIFdlbiBXOyBZYW5nLCBKaWFud2Vp
OyBsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmc7IHVtZy1tZWVnby0NCj4+IGhhbmRzZXQta2Vy
bmVsQHVtZ2xpc3RzdnIuamYuaW50ZWwuY29tDQo+PiBDYzogSm96ZWYgS3J1Z2VyDQo+PiBTdWJq
ZWN0OiBSZTogW1VtZy1tZWVnby1oYW5kc2V0LWtlcm5lbF0gTWVtb3J5IGFsbG9jYXRpb24gaW4N
Cj4+IFZpZGVvNExpbnV4DQo+Pg0KPj4gSSByZW1lbWJlciBzb21lIENvbnRpbm91cyBNZW1vcnkg
QWxsb2NhdG9yIChDTUEpIGJlaW5nIGl0ZXJhdGVkIGRvd24gYQ0KPj4gZmV3IHZlcnNpb25zIG9u
DQo+PiBzb21lIG1haWxpbmcgbGlzdHM/IElJUkMsIGl0IGlzIGFsc28gZm9yIGxhcmdlIGJ1ZmZl
cnMgYW5kIG1hbmFnZW1lbnQNCj4+IGZvciB2aWRlbyBJUHMuDQo+DQo+SSBiZWxpZXZlIENNQSBp
cyBmb3IgYWxsb2NhdGluZyBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMgbWVtb3J5IGFuZCBmcm9tIHdo
YXQgV2VuDQo+bWVudGlvbmVkIGhlIGFsc28gbmVlZHMgdmlydHVhbCBtZW1vcnkgbWFuYWdlbWVu
dCwgd2hpY2ggdGhlIElPTU1VIHdpbGwNCj5wcm92aWRlLiBQbGVhc2UgY2hlY2sgdGhlIG9wZW4g
c291cmNlIGRpc2N1c3Npb24gb24gQ01BLCB0aGUgbGFzdCBJIGhlYXJkIENNQQ0KPnByb3Bvc2Fs
IHdhcyBzaG90IGRvd24uDQo+UmVmZXJlbmNlOiBodHRwOi8vd3d3LnNwaW5pY3MubmV0L2xpc3Rz
L2xpbnV4LW1lZGlhL21zZzI2ODc1Lmh0bWwNCj4NCj5XZW4sIGhvdyBhcmUgeW91IGN1cnJlbnRs
eSBhbGxvY2F0aW5nIHBoeXNpY2FsIG1lbW9yeSA/DQo+DQo+DQo+VGhhbmsgeW91LA0KPkJlc3Qg
cmVnYXJkcywNCj5IYXJpDQo=
