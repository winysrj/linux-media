Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:34739 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752927AbaLHJvl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 04:51:41 -0500
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 11965-09 for <linux-media@vger.kernel.org>;
 Mon,  8 Dec 2014 09:51:31 +0000 (GMT)
From: David Laight <David.Laight@ACULAB.COM>
To: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	"Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Felipe Balbi <balbi@ti.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: RE: [PATCH] usb: hcd: get/put device and hcd for hcd_buffers()
Date: Mon, 8 Dec 2014 09:44:05 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CA04A1D@AcuExch.aculab.com>
References: <20141205200357.GA1586@linutronix.de>
 <20141205211932.GA24249@kroah.com>
In-Reply-To: <20141205211932.GA24249@kroah.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RnJvbTogR3JlZyBLcm9haC1IYXJ0bWFuDQo+IE9uIEZyaSwgRGVjIDA1LCAyMDE0IGF0IDA5OjAz
OjU3UE0gKzAxMDAsIFNlYmFzdGlhbiBBbmRyemVqIFNpZXdpb3Igd3JvdGU6DQo+ID4gQ29uc2lk
ZXIgdGhlIGZvbGxvd2luZyBzY2VuYXJpbzoNCj4gPiAtIHBsdWdpbiBhIHdlYmNhbQ0KPiA+IC0g
cGxheSB0aGUgc3RyZWFtIHZpYSBnc3QtbGF1bmNoLTAuMTAgdjRsMnNyYyBkZXZpY2U9L2Rldi92
aWRlbzANCj4gPiAtIHJlbW92ZSB0aGUgVVNCLUhDRCBkdXJpbmcgcGxheWJhY2sgdmlhICJybW1v
ZCAkSENEIg0KPiA+DQo+ID4gYW5kIG5vdyB3YWl0IGZvciB0aGUgY3Jhc2gNCj4gDQo+IFdoaWNo
IHlvdSBkZXNlcnZlLCB3aHkgZGlkIHlvdSBldmVyIHJlbW92ZSBhIGtlcm5lbCBtb2R1bGU/ICBU
aGF0J3MgcmFjeQ0KPiBhbmQgX25ldmVyXyByZWNvbW1lbmRlZCwgd2hpY2ggaXMgd2h5IGl0IG5l
dmVyIGhhcHBlbnMgYXV0b21hdGljYWxseSBhbmQNCj4gb25seSByb290IGNhbiBkbyBpdC4NCg0K
UmVhbGx5IGRyaXZlcnMgYW5kIHN1YnN5c3RlbXMgc2hvdWxkIGhhdmUgdGhlIHJlcXVpcmVkIGxv
Y2tpbmcgKGV0YykgdG8NCmVuc3VyZSB0aGF0IGtlcm5lbCBtb2R1bGVzIGNhbiBlaXRoZXIgYmUg
dW5sb2FkZWQsIG9yIHRoYXQgdGhlIHVubG9hZA0KcmVxdWVzdCBpdHNlbGYgZmFpbHMgaWYgdGhl
IGRldmljZSBpcyBidXN5Lg0KDQpJdCBzaG91bGRuJ3QgYmUgY29uc2lkZXJlZCBhICdzaG9vdCBz
ZWxmIGluIGZvb3QnIG9wZXJhdGlvbi4NCk9UT0ggdGhlcmUgYXJlIGxpa2VseSB0byBiZSBidWdz
Lg0KDQoJRGF2aWQNCg0K
