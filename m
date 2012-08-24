Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:30282 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab2HXEZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 00:25:40 -0400
Received: from epcpsbge2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9800HTTS885WH0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 24 Aug 2012 13:25:39 +0900 (KST)
Date: Fri, 24 Aug 2012 04:25:39 +0000 (GMT)
From: Arun Kumar K <arun.kk@samsung.com>
Subject: RE: [PATCH v4 1/4] [media] s5p-mfc: Update MFCv5 driver for callback
 based architecture
To: Kamil Debski <k.debski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Jeongtae Park <jtp.park@samsung.com>,
	Jang-Hyuck Kim <janghyuck.kim@samsung.com>,
	peter Oh <jaeryul.oh@samsung.com>,
	NAVEEN KRISHNA CHATRADHI <ch.naveen@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"kmpark@infradead.org" <kmpark@infradead.org>,
	SUNIL JOSHI <joshi@samsung.com>
Reply-to: arun.kk@samsung.com
MIME-version: 1.0
Content-transfer-encoding: base64
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <32557341.15871345782339106.JavaMail.weblogic@epml04>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgS2FtaWwsDQpUaGFuayB5b3UgZm9yIHRoZSByZXZpZXcgY29tbWVudHMuDQpXaWxsIHBvc3Qg
djUgcGF0Y2hlcyBpbmNvcnBvcmF0aW5nIHlvdXIgY29tbWVudHMuDQoNClJlZ2FyZHMNCkFydW4N
Cg0KLS0tLS0tLSBPcmlnaW5hbCBNZXNzYWdlIC0tLS0tLS0NClNlbmRlciA6IEthbWlsIERlYnNr
aTxrLmRlYnNraUBzYW1zdW5nLmNvbT4gIFNvZnR3YXJlIEVuZ2luZWVyL1NQUkMtTGludXggUGxh
dGZvcm0gKFNTRCkvU2Ftc3VuZyBFbGVjdHJvbmljcw0KRGF0ZSAgIDogQXVnIDIyLCAyMDEyIDIx
OjQ4IChHTVQrMDU6MzApDQpUaXRsZSAgOiBSRTogW1BBVENIIHY0IDEvNF0gW21lZGlhXSBzNXAt
bWZjOiBVcGRhdGUgTUZDdjUgZHJpdmVyIGZvciBjYWxsYmFjaw0KIGJhc2VkIGFyY2hpdGVjdHVy
ZQ0KDQpIaSBBcnVuLA0KDQpGaXJzdCBvZiBhbGwgLSB0aGFuayB5b3UgZm9yIGFsbCB0aGUgcGF0
Y2hlcywgdGhleSBhcmUgZ2V0dGluZyBiZXR0ZXIgYW5kDQpiZXR0ZXINCndpdGggZXZlcnkgdmVy
c2lvbi4NCg0KVHdvIHRoaW5nczogDQoxKSBBIG1pbm9yIG9uZSAtIEkgc3VnZ2VzdCB0aGF0IHRo
ZSBjaG9pY2Ugb2YgdGhlIGRlZmF1bHQgcGl4ZWwgZm9ybWF0IHNob3VsZA0KYmUNCmRvbmUgaW4g
YSBkaWZmZXJlbnQgbWFubmVyLiBJIHN1Z2dlc3QgdXNpbmcgYSBWNEwyX1BJWF9GTVRfKiBpbiB0
aGUNCkRFRl9TUkNfRk1UX0RFQw0KZGVmaW5lIGFuZCB0aGVuIHVzaW5nIGZpbmRfZm9ybWF0IGlu
IHM1cF9tZmNfZGVjX2luaXQuIFNhbWUgZ29lcyBmb3IgZW5jb2RpbmcuDQoNCjIpIEEgbWFqb3Ig
b25lIC0gdGhlIG9wcyBtZWNoYW5pc20gY291bGQgYmUgaW1wcm92ZWQuIEkgc2VlIHRoYXQgdGhl
cmUgYXJlDQptYW55IGZ1bmN0aW9ucyB0aGF0IG9ubHkgY2FsbCBhbiBvcHMuIFN1Y2ggYXM6DQoN
Cj4gaW50IHM1cF9tZmNfYWxsb2NfZGVjX3RlbXBfYnVmZmVycyhzdHJ1Y3QgczVwX21mY19jdHgg
KmN0eCkNCj4gew0KPiAgICAgICAgcmV0dXJuIHM1cF9tZmNfb3BzLT5zNXBfbWZjX2FsbG9jX2Rl
Y190ZW1wX2J1ZmZlcnMoY3R4KTsNCj4gfQ0KDQpJIHN1Z2dlc3QgZHJvcHBpbmcgdGhlIHM1cF9t
ZmNfIHByZWZpeCBpbiBhbGwgdGhlIGZpZWxkcyBvZiBzNXBfbWZjX2h3X29wcyBhbmQNCnVzaW5n
IGEgbWFjcm8gdG8gY2FsbCB0aGUgb3BzLiBMaWtlIHRoaXM6DQoNCisjZGVmaW5lIGZpbWNfcGlw
ZWxpbmVfY2FsbChmLCBvcCwgcCwgYXJncy4uLikgICAgICAgICAgICAgICAgICAgICAgICAgIFxy
DQorICAgICAgICghKGYpID8gLUVOT0RFViA6ICgoKGYpLT5waXBlbGluZV9vcHMgJiYgKGYpLT5w
aXBlbGluZV9vcHMtPm9wKSA/IFxyDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgKGYpLT5w
aXBlbGluZV9vcHMtPm9wKChwKSwgIyNhcmdzKSA6DQotRU5PSU9DVExDTUQpKQ0KKGZyb20gY29t
bWl0IGJ5IFN5bHdlc3RlciBOYXdyb2NraSBodHRwOi8vZ29vLmdsL1E2NTdqKQ0KDQpJbiBhZGRp
dGlvbiwgeW91ciBjb2RlIGRvZXMgbm90IGNoZWNrIHdoZXRoZXIgdGhlIG9wcyBwb2ludGVyIGlz
IG51bGwgYW5kIEkNCnRoaW5rIHRoYXQgaXQgc2hvdWxkIGJlIGRvbmUuDQoNCkJlc3Qgd2lzaGVz
LA0KLS0NCkthbWlsIERlYnNraQ0KTGludXggUGxhdGZvcm0gR3JvdXANClNhbXN1bmcgUG9sYW5k
IFImRCBDZW50ZXINCg0KW3NuaXAgdGhlIGNvZGVdDQoNCjxwPiZuYnNwOzwvcD48cD4mbmJzcDs8
L3A+


