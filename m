Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mognix.dark-green.com ([88.116.226.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gimli@dark-green.com>) id 1LC0qx-0004DE-TS
	for linux-dvb@linuxtv.org; Mon, 15 Dec 2008 00:58:29 +0100
Message-ID: <36739.62.178.208.71.1229299109.squirrel@webmail.dark-green.com>
In-Reply-To: <20081214232918.158520@gmx.net>
References: <4943A606.5060502@cadsoft.de>
	<200812141302.47851@orion.escape-edv.de>
	<52355.62.178.208.71.1229260499.squirrel@webmail.dark-green.com>
	<20081214232918.158520@gmx.net>
Date: Mon, 15 Dec 2008 00:58:29 +0100 (CET)
From: "gimli" <gimli@dark-green.com>
To: "Hans Werner" <HWerner4@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20081215005829_52115"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy S2 PCI HD S2API ( Liplianin's tree
 )	fixes
Reply-To: gimli@dark-green.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_20081215005829_52115
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

sorry to break it. Attached is a corrected patch which adds support
for the Terratec card and corrects MANTIS_VP_1041_DVB_S2.

cu

Edgar (gimli) Hucek

>> Hi,
>>
>> attached there are 2 patches. One which corrects MANTIS_VP_1041_DVB_S2
>
> No, MANTIS_VP_1041_DVB_S2 =3D 0x0031 was correct already for the Azurew=
ave
> AD-SP400
> so your first patch breaks the driver for that card. You need to create
> another define for the
> Terratec Cinergy S2 because it has a different subsystem id.
>
>> and
>> the second one solves the following bug :
>>
> .....
>>
>> Both patches are taken from Manu Abraham's multiproto mantis tree and
>> just
>> aplied to Igor Liplianin's S2API tree.
>
> The second one only I think.
>
>>
>> mfg
>>
>> Edgar (gimli) Hucek
>
> Hans
> --
> Release early, release often.
>
> Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en:
> http://www.gmx.net/de/go/multimessenger
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
>

------=_20081215005829_52115
Content-Type: application/octet-stream;
      name="s2-liplianin_cinergy_s2_pci_hd.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
      filename="s2-liplianin_cinergy_s2_pci_hd.patch"

ZGlmZiAtdU5yIHMyLWxpcGxpYW5pbi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9tYW50aXMvbWFu
dGlzX2NvcmUuYyBzMi1saXBsaWFuaW4uY2luZXJneS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9t
YW50aXMvbWFudGlzX2NvcmUuYwotLS0gczItbGlwbGlhbmluL2xpbnV4L2RyaXZlcnMvbWVkaWEv
ZHZiL21hbnRpcy9tYW50aXNfY29yZS5jCTIwMDgtMTItMTQgMTg6MjA6MDEuMDAwMDAwMDAwICsw
MTAwCisrKyBzMi1saXBsaWFuaW4uY2luZXJneS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9tYW50
aXMvbWFudGlzX2NvcmUuYwkyMDA4LTEyLTE1IDAwOjQ5OjQ2LjAwMDAwMDAwMCArMDEwMApAQCAt
OTEsNiArOTEsNyBAQAogCQltYW50aXMtPmh3Y29uZmlnID0gJnZwMTAzNF9tYW50aXNfY29uZmln
OwogCQlicmVhazsKIAljYXNlIE1BTlRJU19WUF8xMDQxX0RWQl9TMjoJLy8gVlAtMTA0MQorCWNh
c2UgVEVSUkFURUNfQ0lORVJHWV9QQ0lfSEQ6CiAJY2FzZSBURUNITklTQVRfU0tZU1RBUl9IRDJf
MToKIAljYXNlIFRFQ0hOSVNBVF9TS1lTVEFSX0hEMl8yOgogCQltYW50aXMtPmh3Y29uZmlnID0g
JnZwMTA0MV9tYW50aXNfY29uZmlnOwpkaWZmIC11TnIgczItbGlwbGlhbmluL2xpbnV4L2RyaXZl
cnMvbWVkaWEvZHZiL21hbnRpcy9tYW50aXNfZHZiLmMgczItbGlwbGlhbmluLmNpbmVyZ3kvbGlu
dXgvZHJpdmVycy9tZWRpYS9kdmIvbWFudGlzL21hbnRpc19kdmIuYwotLS0gczItbGlwbGlhbmlu
L2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL21hbnRpcy9tYW50aXNfZHZiLmMJMjAwOC0xMi0xNCAx
ODoyMDowMS4wMDAwMDAwMDAgKzAxMDAKKysrIHMyLWxpcGxpYW5pbi5jaW5lcmd5L2xpbnV4L2Ry
aXZlcnMvbWVkaWEvZHZiL21hbnRpcy9tYW50aXNfZHZiLmMJMjAwOC0xMi0xNSAwMDo0ODoxMi4w
MDAwMDAwMDAgKzAxMDAKQEAgLTIyOSw2ICsyMjksNyBAQAogCQl9CiAJCWJyZWFrOwogCWNhc2Ug
TUFOVElTX1ZQXzEwNDFfRFZCX1MyOgorCWNhc2UgVEVSUkFURUNfQ0lORVJHWV9QQ0lfSEQ6CiAJ
Y2FzZSBURUNITklTQVRfU0tZU1RBUl9IRDJfMToKIAljYXNlIFRFQ0hOSVNBVF9TS1lTVEFSX0hE
Ml8yOgogCQltYW50aXMtPmZlID0gc3RiMDg5OV9hdHRhY2goJnZwMTA0MV9jb25maWcsICZtYW50
aXMtPmFkYXB0ZXIpOwpkaWZmIC11TnIgczItbGlwbGlhbmluL2xpbnV4L2RyaXZlcnMvbWVkaWEv
ZHZiL21hbnRpcy9tYW50aXNfdnAxMDQxLmggczItbGlwbGlhbmluLmNpbmVyZ3kvbGludXgvZHJp
dmVycy9tZWRpYS9kdmIvbWFudGlzL21hbnRpc192cDEwNDEuaAotLS0gczItbGlwbGlhbmluL2xp
bnV4L2RyaXZlcnMvbWVkaWEvZHZiL21hbnRpcy9tYW50aXNfdnAxMDQxLmgJMjAwOC0xMi0xNCAx
ODoyMDowMS4wMDAwMDAwMDAgKzAxMDAKKysrIHMyLWxpcGxpYW5pbi5jaW5lcmd5L2xpbnV4L2Ry
aXZlcnMvbWVkaWEvZHZiL21hbnRpcy9tYW50aXNfdnAxMDQxLmgJMjAwOC0xMi0xNSAwMDo0Nzow
MS4wMDAwMDAwMDAgKzAxMDAKQEAgLTI3LDcgKzI3LDggQEAKICNpbmNsdWRlICJzdGI2MTAwLmgi
CiAjaW5jbHVkZSAibG5icDIxLmgiCiAKLSNkZWZpbmUgTUFOVElTX1ZQXzEwNDFfRFZCX1MyCTB4
MTE3OQorI2RlZmluZSBNQU5USVNfVlBfMTA0MV9EVkJfUzIJMHgwMDMxCisjZGVmaW5lIFRFUlJB
VEVDX0NJTkVSR1lfUENJX0hECTB4MTE3OQogI2RlZmluZSBURUNITklTQVRfU0tZU1RBUl9IRDJf
MQkweDAwMDEKIC8vIFN1YnN5c3RlbTogRGV2aWNlIDFhZTQ6MDAwMwogI2RlZmluZSBURUNITklT
QVRfU0tZU1RBUl9IRDJfMiAweDAwMDMK
------=_20081215005829_52115
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_20081215005829_52115--
