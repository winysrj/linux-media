Return-path: <mchehab@pedra>
Received: from connie.slackware.com ([64.57.102.36]:40423 "EHLO
	connie.slackware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab1DLObf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 10:31:35 -0400
Date: Tue, 12 Apr 2011 07:31:27 -0700 (PDT)
From: Robby Workman <rworkman@slackware.com>
To: Andreas Oberritter <obi@linuxtv.org>
cc: linux-media@vger.kernel.org,
	Patrick Volkerding <volkerdi@slackware.com>
Subject: Re: [PATCHES] Misc. trivial fixes
In-Reply-To: <4DA441D9.2000601@linuxtv.org>
Message-ID: <alpine.LNX.2.00.1104120729280.7359@connie.slackware.com>
References: <alpine.LNX.2.00.1104111908050.32072@connie.slackware.com> <4DA441D9.2000601@linuxtv.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="960504934-1014675929-1302618687=:7359"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--960504934-1014675929-1302618687=:7359
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Tue, 12 Apr 2011, Andreas Oberritter wrote:

> On 04/12/2011 04:10 AM, Robby Workman wrote:
>> --- a/Make.rules
>> +++ b/Make.rules
>> @@ -11,6 +11,7 @@ PREFIX = /usr/local
>>  LIBDIR = $(PREFIX)/lib
>>  # subdir below LIBDIR in which to install the libv4lx libc wrappers
>>  LIBSUBDIR = libv4l
>> +MANDIR = /usr/share/man
>
> Why did you hardcode /usr instead of keeping $(PREFIX)/share/man?


Eek.  I'd like to say that I sent the wrong patch, but alas, I
simply had a thinko.  See attached (better) patch :-)

-RW
--960504934-1014675929-1302618687=:7359
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0002-Allow-override-of-manpage-installation-directory.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.1104120731270.7359@connie.slackware.com>
Content-Description: 
Content-Disposition: attachment; filename=0002-Allow-override-of-manpage-installation-directory.patch

RnJvbSA2ZWY0YTFmZWNlZTI0MmJlOTY1ODUyOGVmNzY2Mzg0NWQ5YmQ2YmM2
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogUm9iYnkgV29ya21h
biA8cndvcmttYW5Ac2xhY2t3YXJlLmNvbT4NCkRhdGU6IFR1ZSwgMTIgQXBy
IDIwMTEgMDk6MjY6NTcgLTA1MDANClN1YmplY3Q6IFtQQVRDSF0gQWxsb3cg
b3ZlcnJpZGUgb2YgbWFucGFnZSBpbnN0YWxsYXRpb24gZGlyZWN0b3J5DQoN
ClRoaXMgY3JlYXRlcyBNQU5ESVIgaW4gTWFrZS5ydWxlcyBhbmQga2VlcHMg
dGhlIHByZWV4aXN0aW5nDQpkZWZhdWx0IG9mICQoUFJFRklYKS9zaGFyZS9t
YW4sIGJ1dCBhbGxvd3MgcGFja2FnZXJzIHRvIGVhc2lseQ0Kb3ZlcnJpZGUg
dmlhIGUuZy4gIm1ha2UgTUFORElSPS91c3IvbWFuIg0KLS0tDQogTWFrZS5y
dWxlcyAgICAgICAgICAgICAgfCAgICAxICsNCiB1dGlscy9rZXl0YWJsZS9N
YWtlZmlsZSB8ICAgIDQgKystLQ0KIDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvTWFr
ZS5ydWxlcyBiL01ha2UucnVsZXMNCmluZGV4IDBiYjJlYjguLjg3NTgyOGEg
MTAwNjQ0DQotLS0gYS9NYWtlLnJ1bGVzDQorKysgYi9NYWtlLnJ1bGVzDQpA
QCAtMTEsNiArMTEsNyBAQCBQUkVGSVggPSAvdXNyL2xvY2FsDQogTElCRElS
ID0gJChQUkVGSVgpL2xpYg0KICMgc3ViZGlyIGJlbG93IExJQkRJUiBpbiB3
aGljaCB0byBpbnN0YWxsIHRoZSBsaWJ2NGx4IGxpYmMgd3JhcHBlcnMNCiBM
SUJTVUJESVIgPSBsaWJ2NGwNCitNQU5ESVIgPSAkKFBSRUZJWCkvc2hhcmUv
bWFuDQogDQogIyBUaGVzZSBvbmVzIHNob3VsZCBub3QgYmUgb3ZlcnJpZGVu
IGZyb20gdGhlIGNtZGxpbmUNCiANCmRpZmYgLS1naXQgYS91dGlscy9rZXl0
YWJsZS9NYWtlZmlsZSBiL3V0aWxzL2tleXRhYmxlL01ha2VmaWxlDQppbmRl
eCAyOWE2YWM0Li5lMDkzMjgwIDEwMDY0NA0KLS0tIGEvdXRpbHMva2V5dGFi
bGUvTWFrZWZpbGUNCisrKyBiL3V0aWxzL2tleXRhYmxlL01ha2VmaWxlDQpA
QCAtMzksNyArMzksNyBAQCBpbnN0YWxsOiAkKFRBUkdFVFMpDQogCWluc3Rh
bGwgLW0gNjQ0IC1wIHJjX2tleW1hcHMvKiAkKERFU1RESVIpL2V0Yy9yY19r
ZXltYXBzDQogCWluc3RhbGwgLW0gNzU1IC1kICQoREVTVERJUikvbGliL3Vk
ZXYvcnVsZXMuZA0KIAlpbnN0YWxsIC1tIDY0NCAtcCA3MC1pbmZyYXJlZC5y
dWxlcyAkKERFU1RESVIpL2xpYi91ZGV2L3J1bGVzLmQNCi0JaW5zdGFsbCAt
bSA3NTUgLWQgJChERVNURElSKSQoUFJFRklYKS9zaGFyZS9tYW4vbWFuMQ0K
LQlpbnN0YWxsIC1tIDY0NCAtcCBpci1rZXl0YWJsZS4xICQoREVTVERJUikk
KFBSRUZJWCkvc2hhcmUvbWFuL21hbjENCisJaW5zdGFsbCAtbSA3NTUgLWQg
JChERVNURElSKSQoTUFORElSKS9tYW4xDQorCWluc3RhbGwgLW0gNjQ0IC1w
IGlyLWtleXRhYmxlLjEgJChERVNURElSKSQoTUFORElSKS9tYW4xDQogDQog
aW5jbHVkZSAuLi8uLi9NYWtlLnJ1bGVzDQotLSANCjEuNy40LjQNCg0K

--960504934-1014675929-1302618687=:7359--
