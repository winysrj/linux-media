Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:56044 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752447AbdFPHiw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 03:38:52 -0400
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: tc358743: remove useless variable assignment in
 tc358743_isr
Date: Fri, 16 Jun 2017 07:28:20 +0000
Message-ID: <F23C0B09-8A98-4ADD-A584-28E156EE1E55@cisco.com>
References: <20170615164914.GA23292@embeddedgus>
In-Reply-To: <20170615164914.GA23292@embeddedgus>
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-ID: <78A9EAD7276D144283B73B54F24F94E2@emea.cisco.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VGhhbmtzIQ0KWW91IGNvdWxkIHJlbW92ZQ0KDQppbnRzdGF0dXMgJj0gfk1BU0tfSERNSV9JTlQ7
DQoNCmluIGxpbmUgMTI4OSBhcyB3ZWxsLg0KDQpSZWdhcmRzLA0KTWF0cyBSYW5kZ2FhcmQNCg0K
T24gMTUvMDYvMjAxNywgMTg6NDksICJHdXN0YXZvIEEuIFIuIFNpbHZhIiA8Z2Fyc2lsdmFAZW1i
ZWRkZWRvci5jb20+IHdyb3RlOg0KDQogICAgUmVtb3ZlIHVzZWxlc3MgdmFyaWFibGUgYXNzaWdu
bWVudCBpbiBmdW5jdGlvbiB0YzM1ODc0M19pc3IoKS4NCiAgICANCiAgICBUaGUgdmFsdWUgc3Rv
cmVkIGluIHZhcmlhYmxlIF9pbnRzdGF0dXNfIGF0IGxpbmUgMTI5OSBpcw0KICAgIG92ZXJ3cml0
dGVuIGF0IGxpbmUgMTMwMiwganVzdCBiZWZvcmUgaXQgY2FuIGJlIHVzZWQuDQogICAgDQogICAg
QWRkcmVzc2VzLUNvdmVyaXR5LUlEOiAxMzk3Njc4DQogICAgU2lnbmVkLW9mZi1ieTogR3VzdGF2
byBBLiBSLiBTaWx2YSA8Z2Fyc2lsdmFAZW1iZWRkZWRvci5jb20+DQogICAgLS0tDQogICAgIGRy
aXZlcnMvbWVkaWEvaTJjL3RjMzU4NzQzLmMgfCAxIC0NCiAgICAgMSBmaWxlIGNoYW5nZWQsIDEg
ZGVsZXRpb24oLSkNCiAgICANCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9pMmMvdGMz
NTg3NDMuYyBiL2RyaXZlcnMvbWVkaWEvaTJjL3RjMzU4NzQzLmMNCiAgICBpbmRleCAzMjUxY2Jh
Li5lOGIyM2YzIDEwMDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvbWVkaWEvaTJjL3RjMzU4NzQzLmMN
CiAgICArKysgYi9kcml2ZXJzL21lZGlhL2kyYy90YzM1ODc0My5jDQogICAgQEAgLTEyOTYsNyAr
MTI5Niw2IEBAIHN0YXRpYyBpbnQgdGMzNTg3NDNfaXNyKHN0cnVjdCB2NGwyX3N1YmRldiAqc2Qs
IHUzMiBzdGF0dXMsIGJvb2wgKmhhbmRsZWQpDQogICAgIAkJCXRjMzU4NzQzX2NzaV9lcnJfaW50
X2hhbmRsZXIoc2QsIGhhbmRsZWQpOw0KICAgICANCiAgICAgCQlpMmNfd3IxNihzZCwgSU5UU1RB
VFVTLCBNQVNLX0NTSV9JTlQpOw0KICAgIC0JCWludHN0YXR1cyAmPSB+TUFTS19DU0lfSU5UOw0K
ICAgICAJfQ0KICAgICANCiAgICAgCWludHN0YXR1cyA9IGkyY19yZDE2KHNkLCBJTlRTVEFUVVMp
Ow0KICAgIC0tIA0KICAgIDIuNS4wDQogICAgDQogICAgDQoNCg==
