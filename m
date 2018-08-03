Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:27191 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbeHCFxJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 01:53:09 -0400
From: "Chen, Ping-chung" <ping-chung.chen@intel.com>
To: Tomasz Figa <tfiga@chromium.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Grant Grundler <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: RE: [RESEND PATCH v4] media: imx208: Add imx208 camera sensor driver
Date: Fri, 3 Aug 2018 03:58:47 +0000
Message-ID: <5E40A82D0551C84FA2888225EDABBE093FAA48C5@PGSMSX105.gar.corp.intel.com>
References: <1533265497-16718-1-git-send-email-ping-chung.chen@intel.com>
 <CAAFQd5BA+RuXWeOYuteG=GggGCg-ZJg04-mfy2AEGNPHrB=pQQ@mail.gmail.com>
In-Reply-To: <CAAFQd5BA+RuXWeOYuteG=GggGCg-ZJg04-mfy2AEGNPHrB=pQQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgVG9tYXN6LA0KDQoNCj5PbiBGcmksIEF1ZyAzLCAyMDE4IGF0IDExOjU3IEFNIFBpbmctY2h1
bmcgQ2hlbiA8cGluZy1jaHVuZy5jaGVuQGludGVsLmNvbT4gd3JvdGU6DQo+DQo+IEZyb206ICJD
aGVuLCBQaW5nLWNodW5nIiA8cGluZy1jaHVuZy5jaGVuQGludGVsLmNvbT4NCj4NCj4gQWRkIGEg
VjRMMiBzdWItZGV2aWNlIGRyaXZlciBmb3IgdGhlIFNvbnkgSU1YMjA4IGltYWdlIHNlbnNvci4N
Cj4gVGhpcyBpcyBhIGNhbWVyYSBzZW5zb3IgdXNpbmcgdGhlIEkyQyBidXMgZm9yIGNvbnRyb2wg
YW5kIHRoZQ0KPiBDU0ktMiBidXMgZm9yIGRhdGEuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IFBpbmct
Q2h1bmcgQ2hlbiA8cGluZy1jaHVuZy5jaGVuQGludGVsLmNvbT4NCj4gLS0tDQo+IHNpbmNlIHYx
Og0KPiAtLSBVcGRhdGUgdGhlIGZ1bmN0aW9uIG1lZGlhX2VudGl0eV9wYWRzX2luaXQgZm9yIHVw
c3RyZWFtaW5nLg0KPiAtLSBDaGFuZ2UgdGhlIHN0cnVjdHVyZSBuYW1lIG11dGV4IGFzIGlteDIw
OF9teC4NCj4gLS0gUmVmaW5lIHRoZSBjb250cm9sIGZsb3cgb2YgdGVzdCBwYXR0ZXJuIGZ1bmN0
aW9uLg0KPiAtLSB2ZmxpcC9oZmxpcCBjb250cm9sIHN1cHBvcnQgKHdpbGwgaW1wYWN0IHRoZSBv
dXRwdXQgYmF5ZXIgb3JkZXIpDQo+IC0tIHN1cHBvcnQgNCBiYXllciBvcmRlcnMgb3V0cHV0ICh2
aWEgY2hhbmdlIHYvaGZsaXApDQo+ICAgICAtIFNSR0dCMTAoZGVmYXVsdCksIFNHUkJHMTAsIFNH
QlJHMTAsIFNCR0dSMTANCj4gLS0gU2ltcGxpZnkgZXJyb3IgaGFuZGxpbmcgaW4gdGhlIHNldF9z
dHJlYW0gZnVuY3Rpb24uDQo+IHNpbmNlIHYyOg0KPiAtLSBSZWZpbmUgY29kaW5nIHN0eWxlLg0K
PiAtLSBGaXggdGhlIGlmIHN0YXRlbWVudCB0byB1c2UgcG1fcnVudGltZV9nZXRfaWZfaW5fdXNl
KCkuDQo+IC0tIFByaW50IG1vcmUgZXJyb3IgbG9nIGR1cmluZyBlcnJvciBoYW5kbGluZy4NCj4g
LS0gUmVtb3ZlIG11dGV4X2Rlc3Ryb3koKSBmcm9tIGlteDIwOF9mcmVlX2NvbnRyb2xzKCkuDQo+
IC0tIEFkZCBtb3JlIGNvbW1lbnRzLg0KPiBzaW5jZSB2MzoNCj4gLS0gU2V0IGV4cGxpY2l0IGlu
ZGljZXMgdG8gbGluayBmcmVxdWVuY2llcy4NCj4NCltzbmlwXQ0KPiArLyogTWVudSBpdGVtcyBm
b3IgTElOS19GUkVRIFY0TDIgY29udHJvbCAqLyBzdGF0aWMgY29uc3QgczY0IA0KPiArbGlua19m
cmVxX21lbnVfaXRlbXNbXSA9IHsNCj4gKyAgICAgICBbSU1YMjA4X0xJTktfRlJFUV8zODRNSFpf
SU5ERVhdID0gSU1YMjA4X0xJTktfRlJFUV8zODRNSFosDQo+ICsgICAgICAgW0lNWDIwOF9MSU5L
X0ZSRVFfMzg0TUhaX0lOREVYXSA9IElNWDIwOF9MSU5LX0ZSRVFfOTZNSFosDQoNCj5JTVgyMDhf
TElOS19GUkVRXzk2TUhaX0lOREVYPw0KDQpPaC4uLiBJdCdzIG15IG1pc3Rha2UuIEZpeGVkLg0K
DQo+V2l0aCB0aGlzIGZpeGVkIChhbmQgaWYgdGhlcmUgYXJlIG5vIG90aGVyIGNoYW5nZXMpLCBm
ZWVsIGZyZWUgdG8gYWRkDQoNCj5SZXZpZXdlZC1ieTogVG9tYXN6IEZpZ2EgPHRmaWdhQGNocm9t
aXVtLm9yZz4NCg0KU3VyZS4NCg0KPkJlc3QgcmVnYXJkcywNCj5Ub21hc3oNCg==
