Return-path: <mchehab@pedra>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:51213 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755276Ab0KOJxO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 04:53:14 -0500
From: Jimmy RUBIN <jimmy.rubin@stericsson.com>
To: Joe Perches <joe@perches.com>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Dan JOHANSSON <dan.johansson@stericsson.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>
Date: Mon, 15 Nov 2010 10:52:55 +0100
Subject: RE: [PATCH 01/10] MCDE: Add hardware abstraction layer
Message-ID: <F45880696056844FA6A73F415B568C6953604E7105@EXDCVYMBSTM006.EQ1STM.local>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
	 <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com>
 <1289409276.15905.65.camel@Joe-Laptop>
In-Reply-To: <1289409276.15905.65.camel@Joe-Laptop>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

SGkgSm9lLA0KDQpUaGFua3MgZm9yIHlvdXIgaW5wdXQuDQpTZWUgY29tbWVudHMgYmVsb3cuDQog
DQo+IEp1c3QgdHJpdmlhOg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aWRlby9tY2Rl
L21jZGVfaHcuYw0KPiBiL2RyaXZlcnMvdmlkZW8vbWNkZS9tY2RlX2h3LmMNCj4gDQo+IFtdDQo+
IA0KPiA+ICsjZGVmaW5lIGRzaV9yZmxkKF9faSwgX19yZWcsIF9fZmxkKSBcDQo+ID4gKwkoKGRz
aV9ycmVnKF9faSwgX19yZWcpICYgX19yZWcjI18jI19fZmxkIyNfTUFTSykgPj4gXA0KPiA+ICsJ
CV9fcmVnIyNfIyNfX2ZsZCMjX1NISUZUKQ0KPiA+ICsjZGVmaW5lIGRzaV93ZmxkKF9faSwgX19y
ZWcsIF9fZmxkLCBfX3ZhbCkgXA0KPiA+ICsJZHNpX3dyZWcoX19pLCBfX3JlZywgKGRzaV9ycmVn
KF9faSwgX19yZWcpICYgXA0KPiA+ICsJfl9fcmVnIyNfIyNfX2ZsZCMjX01BU0spIHwgKCgoX192
YWwpIDw8DQo+IF9fcmVnIyNfIyNfX2ZsZCMjX1NISUZUKSAmIFwNCj4gPiArCQkgX19yZWcjI18j
I19fZmxkIyNfTUFTSykpDQo+IA0KPiBUaGVzZSBtYWNyb3MgYXJlIG5vdCBwYXJ0aWN1bGFybHkg
cmVhZGFibGUuDQo+IFBlcmhhcHMgdXNlIHN0YXRlbWVudCBleHByZXNzaW9uIG1hY3JvcyBsaWtl
Og0KPiANCj4gI2RlZmluZSBkc2lfcmZsZChfX2ksIF9fcmVnLCBfX2ZsZCkNCj4gCQlcDQo+ICh7
DQo+IAkJCVwNCj4gCWNvbnN0IHUzMiBtYXNrID0gX19yZWcjI18jX19mbGQjI19NQVNLOw0KPiAJ
CVwNCj4gCWNvbnN0IHUzMiBzaGlmdCA9IF9fcmVnIyNfIyNfX2ZsZCMjX1NISUZUOw0KPiAJXA0K
PiAJKChkc2lfcnJlZyhfX2ksIF9fcmVnKSAmIG1hc2spID4+IHNoaWZ0Ow0KPiAJXA0KPiB9KQ0K
PiANCj4gI2RlZmluZSBkc2lfd2ZsZChfX2ksIF9fcmVnLCBfX2ZsZCwgX192YWwpDQo+IAlcDQo+
ICh7DQo+IAkJCVwNCj4gCWNvbnN0IHUzMiBtYXNrID0gX19yZWcjI18jX19mbGQjI19NQVNLOw0K
PiAJCVwNCj4gCWNvbnN0IHUzMiBzaGlmdCA9IF9fcmVnIyNfIyNfX2ZsZCMjX1NISUZUOw0KPiAJ
XA0KPiAJZHNpX3dyZWcoX19pLCBfX3JlZywNCj4gCQlcDQo+IAkJIChkc2lfcnJlZyhfX2ksIF9f
cmVnKSAmIH5tYXNrKSB8ICgoKF9fdmFsKSA8PA0KPiBzaGlmdCkgJiBtYXNrKSk7XA0KPiB9KQ0K
DQpJIGFncmVlLCBtb3JlIHJlYWRhYmxlLg0KPiANCj4gPiArc3RhdGljIHN0cnVjdCBtY2RlX2No
bmxfc3RhdGUgY2hhbm5lbHNbXSA9IHsNCj4gDQo+IFNob3VsZCBtb3JlIHN0YXRpYyBzdHJ1Y3Rz
IGJlIHN0YXRpYyBjb25zdD8NCg0KSSB0aGluayBzbywgd2UgZ290IHNvbWUgc3RyYW5nZSBiZWhh
dmlvciB3aGVuIHdlIGNoYW5nZWQgdGhlIHN0cnVjdHMgdG8gc3RhdGljIGNvbnN0LiBCdXQgd2Ug
d2lsbCBpbnZlc3RpZ2F0ZSBpdC4NCg0KPiANCj4gW10NCj4gDQo+ID4gKwlkZXZfdmRiZygmbWNk
ZV9kZXYtPmRldiwgIiVzXG4iLCBfX2Z1bmNfXyk7DQo+IA0KPiBJZiB5b3VyIGRldl88bGV2ZWw+
IGxvZ2dpbmcgbWVzc2FnZXMgdXNlICIlcyIsIF9fZnVuY19fDQo+IEkgc3VnZ2VzdCB5b3UgdXNl
IGEgc2V0IG9mIGxvY2FsIG1hY3JvcyB0byBwcmVmYWNlIHRoaXMuDQo+IA0KPiBJIGRvbid0IGdl
bmVyYWxseSBmaW5kIHRoZSBmdW5jdGlvbiBuYW1lIHVzZWZ1bC4NCj4gDQo+IE1heWJlIG9ubHkg
dXNlIHRoZSAlcyBfX2Z1bmNfXyBwYWlyIHdoZW4geW91IGFyZSBhbHNvDQo+IHNldHRpbmcgdmVy
Ym9zZSBkZWJ1Z2dpbmcuDQpBbHJpZ2h0LCB3aWxsIGFkZCBzb21lIGxvY2FsIG1hY3JvcyBmb3Ig
dGhpcy4NCg0KPiANCj4gI2lmZGVmIFZFUkJPU0VfREVCVUcNCj4gI2RlZmluZSBtY2RlX3ByaW50
ayhsZXZlbCwgZGV2LCBmbXQsIGFyZ3MpIFwNCj4gCWRldl9wcmludGsobGV2ZWwsIGRldiwgIiVz
OiAiIGZtdCwgX19mdW5jX18sICMjYXJncykNCj4gI2Vsc2UNCj4gI2RlZmluZSBtY2RlX3ByaW50
ayhsZXZlbCwgZGV2LCBmbXQsIGFyZ3MpIFwNCj4gCWRldl9wcmludGsobGV2ZWwsIGRldiwgZm10
LCBhcmdzKQ0KPiAjZW5kaWYNCj4gDQo+ICNpZmRlZiBWRVJCT1NFX0RFQlVHDQo+ICNkZWZpbmUg
bWNkZV92ZGJnKGRldiwgZm10LCBhcmdzKSBcDQo+IAltY2RlX3ByaW50ayhLRVJOX0RFQlVHLCBk
ZXYsIGZtdCwgIyNhcmdzKQ0KPiAjZWxzZQ0KPiAjZGVmaW5lIG1jZGVfdmRiZyhkZXYsIGZtdCwg
YXJncykgXA0KPiAJZG8geyBpZiAoMCkgbWNkZV9wcmludGsoS0VSTl9ERUJVRywgZGV2LCBmbXQs
ICMjYXJncyk7IH0NCj4gd2hpbGUgKDApDQo+ICNlbmRpZg0KPiANCj4gI2lmZGVmIERFQlVHDQo+
ICNkZWZpbmUgbWNkZV9kYmcoZGV2LCBmbXQsIGFyZ3MpIFwNCj4gCW1jZGVfcHJpbnRrKEtFUk5f
REVCVUcsIGRldiwgZm10LCAjI2FyZ3MpDQo+ICNlbHNlDQo+ICNkZWZpbmUgbWNkZV9kYmcoZGV2
LCBmbXQsIGFyZ3MpIFwNCj4gCWRvIHsgaWYgKDApIG1jZGVfcHJpbnRrKEtFUk5fREVCVUcsIGRl
diwgZm10LCAjI2FyZ3MpOyB9DQo+IHdoaWxlICgwKQ0KPiAjZW5kaWYNCj4gDQo+ICNkZWZpbmUg
bWNkZV9FUlIoZGV2LCBmbXQsIGFyZ3MpIFwNCj4gCW1jZGVfcHJpbnRrKEtFUk5fRVJSLCBkZXYs
IGZtdCwgIyNhcmdzKQ0KPiAjZGVmaW5lIG1jZGVfd2FybihkZXYsIGZtdCwgYXJncykgXA0KPiAJ
bWNkZV9wcmludGsoS0VSTl9XQVJOSU5HLCBkZXYsIGZtdCwgIyNhcmdzKQ0KPiAjZGVmaW5lIG1j
ZGVfaW5mbyhkZXYsIGZtdCwgYXJncykgXA0KPiAJbWNkZV9wcmludGsoS0VSTl9JTkZPLCBkZXYs
IGZtdCwgIyNhcmdzKQ0KPiANCj4gPiArc3RhdGljIHZvaWQgZGlzYWJsZV9jaGFubmVsKHN0cnVj
dCBtY2RlX2Nobmxfc3RhdGUgKmNobmwpDQo+ID4gK3sNCj4gPiArCWludCBpOw0KPiA+ICsJY29u
c3Qgc3RydWN0IG1jZGVfcG9ydCAqcG9ydCA9ICZjaG5sLT5wb3J0Ow0KPiA+ICsNCj4gPiArCWRl
dl92ZGJnKCZtY2RlX2Rldi0+ZGV2LCAiJXNcbiIsIF9fZnVuY19fKTsNCj4gPiArDQo+ID4gKwlp
ZiAoaGFyZHdhcmVfdmVyc2lvbiA9PSBNQ0RFX0NISVBfVkVSU0lPTl8zXzBfOCAmJg0KPiA+ICsJ
CQkJIWlzX2NoYW5uZWxfZW5hYmxlZChjaG5sKSkNCj4gew0KPiA+ICsJCWNobmwtPmNvbnRpbm91
c19ydW5uaW5nID0gZmFsc2U7DQo+IA0KPiBJdCdkIGJlIG5pY2UgdG8gY2hhbmdlIHRvIGNvbnRp
bnVvdXNfcnVubmluZw0KDQpDb250aW5vdXNfcnVubmluZyBpcyBub3JtYWxseSBzZXQgdG8gdHJ1
ZSB3aGVuIGEgY2hubF91cGRhdGUgaXMgcGVyZm9ybWVkLg0KSW4gZGlzYWJsZSBjaGFubmVsIGNv
bnRpbm91c19ydW5uaW5nIG11c3QgYmUgc2V0IHRvIGZhbHNlIGluIG9yZGVyIHRvIGdldCB0aGUg
aHcgcmVnaXN0ZXJzIHVwZGF0ZWQgaW4gdGhlIG5leHQgY2hubF91cGRhdGUuDQoNCj4gDQo+ID4g
K2ludCBtY2RlX2RzaV9kY3Nfd3JpdGUoc3RydWN0IG1jZGVfY2hubF9zdGF0ZSAqY2hubCwgdTgg
Y21kLCB1OCoNCj4gZGF0YSwgaW50IGxlbikNCj4gPiArew0KPiA+ICsJaW50IGk7DQo+ID4gKwl1
MzIgd3JkYXRbNF0gPSB7IDAsIDAsIDAsIDAgfTsNCj4gPiArCXUzMiBzZXR0aW5nczsNCj4gPiAr
CXU4IGxpbmsgPSBjaG5sLT5wb3J0Lmxpbms7DQo+ID4gKwl1OCB2aXJ0X2lkID0gY2hubC0+cG9y
dC5waHkuZHNpLnZpcnRfaWQ7DQo+ID4gKw0KPiA+ICsJLyogUkVWSUVXOiBPbmUgY29tbWFuZCBh
dCBhIHRpbWUgKi8NCj4gPiArCS8qIFJFVklFVzogQWxsb3cgcmVhZC93cml0ZSBvbiB1bnJlc2Vy
dmVkIHBvcnRzICovDQo+ID4gKwlpZiAobGVuID4gTUNERV9NQVhfRENTX1dSSVRFIHx8IGNobmwt
PnBvcnQudHlwZSAhPQ0KPiBNQ0RFX1BPUlRUWVBFX0RTSSkNCj4gPiArCQlyZXR1cm4gLUVJTlZB
TDsNCj4gPiArDQo+ID4gKwl3cmRhdFswXSA9IGNtZDsNCj4gPiArCWZvciAoaSA9IDE7IGkgPD0g
bGVuOyBpKyspDQo+ID4gKwkJd3JkYXRbaT4+Ml0gfD0gKCh1MzIpZGF0YVtpLTFdIDw8ICgoaSAm
IDMpICogOCkpOw0KPiANCj4gRXZlciBvdmVycnVuIHdyZGF0Pw0KPiBNYXliZSBXQVJOX09OKGxl
biA+IDE2LCAib29wcz8iKQ0KPiANCk1DREVfTUFYX0RDU19XUklURSBpcyAxNSBzbyBpdCB3aWxs
IGJlIGFuIGVhcmx5IHJldHVybiBpbiB0aGF0IGNhc2UuDQoNCi9KaW1teQ0K
