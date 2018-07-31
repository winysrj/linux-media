Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:63025 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727161AbeGaFcg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 01:32:36 -0400
From: "Chen, Ping-chung" <ping-chung.chen@intel.com>
To: Tomasz Figa <tfiga@chromium.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Grant Grundler <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: RE: [PATCH v2] media: imx208: Add imx208 camera sensor driver
Date: Tue, 31 Jul 2018 03:54:23 +0000
Message-ID: <5E40A82D0551C84FA2888225EDABBE093FAA3EE3@PGSMSX105.gar.corp.intel.com>
References: <1532942799-25289-1-git-send-email-ping-chung.chen@intel.com>
 <CAAFQd5D33wzALT+0KkfXKzKs68cYKy05GbHe_SnLakpfJyry3w@mail.gmail.com>
In-Reply-To: <CAAFQd5D33wzALT+0KkfXKzKs68cYKy05GbHe_SnLakpfJyry3w@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgVG9tYXN6LA0KDQo+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gKy8qIEdldCBiYXll
ciBvcmRlciBiYXNlZCBvbiBmbGlwIHNldHRpbmcuICovIHN0YXRpYyBfX3UzMiANCj4gK2lteDIw
OF9nZXRfZm9ybWF0X2NvZGUoc3RydWN0IGlteDIwOCAqaW14MjA4KQ0KDQo+V2h5IG5vdCBqdXN0
ICJ1MzIiPw0KDQpJdHMgcmV0dXJuIHZhbHVlIHdpbGwgYmUgYXNzaWduZWQgdG8gdGhlIHZhcmlh
YmxlIGNvZGUgd2hpY2ggYmVsb25ncyB0byB0aGUgc3RydWN0dXJlIA0KdjRsMl9zdWJkZXZfbWJ1
c19jb2RlX2VudW0sIGFuZCB0aGUgdHlwZSBvZiB0aGlzIHZhcmlhYmxlIGlzIF9fdTMyLg0Kc3Ry
dWN0IHY0bDJfc3ViZGV2X21idXNfY29kZV9lbnVtIHsNCglfX3UzMiBwYWQ7DQoJX191MzIgaW5k
ZXg7DQoJX191MzIgY29kZTsNCglfX3UzMiB3aGljaDsNCglfX3UzMiByZXNlcnZlZFs4XTsNCn07
DQoNCj4gK3sNCj4gKyAgICAgICAvKg0KPiArICAgICAgICAqIE9ubHkgb25lIGJheWVyIG9yZGVy
IGlzIHN1cHBvcnRlZC4NCj4gKyAgICAgICAgKiBJdCBkZXBlbmRzIG9uIHRoZSBmbGlwIHNldHRp
bmdzLg0KPiArICAgICAgICAqLw0KPiArICAgICAgIHN0YXRpYyBjb25zdCBfX3UzMiBjb2Rlc1sy
XVsyXSA9IHsNCg0KPkRpdHRvLg0KDQo+ICsgICAgICAgICAgICAgICB7IE1FRElBX0JVU19GTVRf
U1JHR0IxMF8xWDEwLCBNRURJQV9CVVNfRk1UX1NHUkJHMTBfMVgxMCwgfSwNCj4gKyAgICAgICAg
ICAgICAgIHsgTUVESUFfQlVTX0ZNVF9TR0JSRzEwXzFYMTAsIE1FRElBX0JVU19GTVRfU0JHR1Ix
MF8xWDEwLCB9LA0KPiArICAgICAgIH07DQo+ICsNCj4gKyAgICAgICByZXR1cm4gY29kZXNbaW14
MjA4LT52ZmxpcC0+dmFsXVtpbXgyMDgtPmhmbGlwLT52YWxdOw0KPiArfQ0KPiArDQo=
