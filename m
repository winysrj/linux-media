Return-path: <mchehab@pedra>
Received: from web29505.mail.ird.yahoo.com ([77.238.189.132]:45840 "HELO
	web29505.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750827Ab0IHOWg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 10:22:36 -0400
Message-ID: <670866.16644.qm@web29505.mail.ird.yahoo.com>
Date: Wed, 8 Sep 2010 14:15:54 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
Subject: [Patch] Correct Signal Strength values for STB0899
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-490203341-1283955354=:16644"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

--0-490203341-1283955354=:16644
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,=0A=0Afirst of all I have to say that this patch is not from me.=0AIt's =
from rotor-0.1.4mh-v1.2.tar.gz=0AThx to the author of that patch and the mo=
dified rotor Plugin. I think he's a friend of Mike Booth=0A=0AI think it sh=
ould be included into s2-liplianin.=0AWith this patch all dvb-s and dvb-s2 =
signal strength values are scaled correctly.=0A=0Akind regards=0A=0A=0ANews=
y=0A=0A
--0-490203341-1283955354=:16644
Content-Type: application/octet-stream; name=STB0899_signal_strength_v3patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=STB0899_signal_strength_v3patch

LS0tIC9jb21tb24vUHJvZ3JhbW1zL3ZlcjIvc3JjL3MyLWxpcGxpYW5pbi9s
aW51eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvc3RiMDg5OV9kcnYu
YwkyMDA5LTEyLTMxIDE3OjE1OjM4LjExNTIwMzM0NyArMDMwMAorKysgLi9s
aW51eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvc3RiMDg5OV9kcnYu
YwkyMDEwLTAxLTE0IDIyOjE3OjIyLjY3MTYzNDU1MSArMDMwMApAQCAtOTgw
LDYgKzk4MCwxNiBAQAogCiAJCQkJKnN0cmVuZ3RoID0gc3RiMDg5OV90YWJs
ZV9sb29rdXAoc3RiMDg5OV9kdmJzcmZfdGFiLCBBUlJBWV9TSVpFKHN0YjA4
OTlfZHZic3JmX3RhYikgLSAxLCB2YWwpOwogCQkJCSpzdHJlbmd0aCArPSA3
NTA7CisgICAgICAgICAgICAgICAgCisgICAgICAgICAgICAgICAgY29uc3Qg
aW50IE1JTl9TVFJFTkdUSF9EVkJTID0gMDsKKyAgICAgICAgICAgICAgICBj
b25zdCBpbnQgTUFYX1NUUkVOR1RIX0RWQlMgPSA2ODA7CisgICAgICAgICAg
ICAgICAgaWYgKCpzdHJlbmd0aCA8IE1JTl9TVFJFTkdUSF9EVkJTKSAgICAg
CisgICAgICAgICAgICAgICAgICAgICpzdHJlbmd0aCA9IDA7CisgICAgICAg
ICAgICAgICAgZWxzZSBpZigqc3RyZW5ndGggPiBNQVhfU1RSRU5HVEhfRFZC
UykgCisgICAgICAgICAgICAgICAgICAgICpzdHJlbmd0aCA9IDB4RkZGRjsK
KyAgICAgICAgICAgICAgICBlbHNlCisJCQkgICAgICAgICpzdHJlbmd0aCA9
ICgqc3RyZW5ndGggLSBNSU5fU1RSRU5HVEhfRFZCUykgKiAweEZGRkYgLyAo
TUFYX1NUUkVOR1RIX0RWQlMgLSBNSU5fU1RSRU5HVEhfRFZCUyk7IAorCiAJ
CQkJZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEsICJBR0NJ
UVZBTFVFID0gMHglMDJ4LCBDID0gJWQgKiAwLjEgZEJtIiwKIAkJCQkJdmFs
ICYgMHhmZiwgKnN0cmVuZ3RoKTsKIAkJCX0KQEAgLTk5Miw2ICsxMDAyLDcg
QEAKIAogCQkJKnN0cmVuZ3RoID0gc3RiMDg5OV90YWJsZV9sb29rdXAoc3Ri
MDg5OV9kdmJzMnJmX3RhYiwgQVJSQVlfU0laRShzdGIwODk5X2R2YnMycmZf
dGFiKSAtIDEsIHZhbCk7CiAJCQkqc3RyZW5ndGggKz0gNzUwOworCQkJKnN0
cmVuZ3RoID0gKnN0cmVuZ3RoIDw8IDQ7CiAJCQlkcHJpbnRrKHN0YXRlLT52
ZXJib3NlLCBGRV9ERUJVRywgMSwgIklGX0FHQ19HQUlOID0gMHglMDR4LCBD
ID0gJWQgKiAwLjEgZEJtIiwKIAkJCQl2YWwgJiAweDNmZmYsICpzdHJlbmd0
aCk7CiAJCX0KQEAgLTEwMjQsNiArMTAzNSwxNiBAQAogCQkJCXZhbCA9IE1B
S0VXT1JEMTYoYnVmWzBdLCBidWZbMV0pOwogCiAJCQkJKnNuciA9IHN0YjA4
OTlfdGFibGVfbG9va3VwKHN0YjA4OTlfY25fdGFiLCBBUlJBWV9TSVpFKHN0
YjA4OTlfY25fdGFiKSAtIDEsIHZhbCk7CisKKyAgICAgICAgICAgICAgICBj
b25zdCBpbnQgTUlOX1NOUl9EVkJTID0gMDsKKyAgICAgICAgICAgICAgICBj
b25zdCBpbnQgTUFYX1NOUl9EVkJTID0gMjAwOworICAgICAgICAgICAgICAg
IGlmICgqc25yIDwgTUlOX1NOUl9EVkJTKSAgICAgCisgICAgICAgICAgICAg
ICAgICAgICpzbnIgPSAwOworICAgICAgICAgICAgICAgIGVsc2UgaWYoKnNu
ciA+IE1BWF9TTlJfRFZCUykgCisgICAgICAgICAgICAgICAgICAgICpzbnIg
PSAweEZGRkY7CisgICAgICAgICAgICAgICAgZWxzZQorCQkJICAgICAgICAq
c25yID0gKCpzbnIgLSBNSU5fU05SX0RWQlMpICogMHhGRkZGIC8gKE1BWF9T
TlJfRFZCUyAtIE1JTl9TTlJfRFZCUyk7IAorCiAJCQkJZHByaW50ayhzdGF0
ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEsICJOSVIgPSAweCUwMnglMDJ4ID0g
JXUsIEMvTiA9ICVkICogMC4xIGRCbVxuIiwKIAkJCQkJYnVmWzBdLCBidWZb
MV0sIHZhbCwgKnNucik7CiAJCQl9CkBAIC0xMDQ4LDYgKzEwNjksMTYgQEAK
IAkJCQl2YWwgPSAocXVhbnRuIC0gZXN0bikgLyAxMDsKIAkJCX0KIAkJCSpz
bnIgPSB2YWw7CisKKyAgICAgICAgICAgIGNvbnN0IGludCBNSU5fU05SX0RW
QlMyID0gMTA7CisgICAgICAgICAgICBjb25zdCBpbnQgTUFYX1NOUl9EVkJT
MiA9IDcwOworICAgICAgICAgICAgaWYgKCpzbnIgPCBNSU5fU05SX0RWQlMy
KSAgICAgCisgICAgICAgICAgICAgICAgKnNuciA9IDA7CisgICAgICAgICAg
ICBlbHNlIGlmKCpzbnIgPiBNQVhfU05SX0RWQlMyKSAKKyAgICAgICAgICAg
ICAgICAqc25yID0gMHhGRkZGOworICAgICAgICAgICAgZWxzZQorCQkJICAg
ICpzbnIgPSAoKnNuciAtIE1JTl9TTlJfRFZCUzIpICogMHhGRkZGIC8gKE1B
WF9TTlJfRFZCUzIgLSBNSU5fU05SX0RWQlMyKTsgCisKIAkJCWRwcmludGso
c3RhdGUtPnZlcmJvc2UsIEZFX0RFQlVHLCAxLCAiRXMvTjAgcXVhbnQgPSAl
ZCAoJWQpIGVzdGltYXRlID0gJXUgKCVkKSwgQy9OID0gJWQgKiAwLjEgZEJt
IiwKIAkJCQlxdWFudCwgcXVhbnRuLCBlc3QsIGVzdG4sIHZhbCk7CiAJCX0K


--0-490203341-1283955354=:16644--
