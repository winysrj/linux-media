Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1Kll9y-0001bg-0d
	for linux-dvb@linuxtv.org; Fri, 03 Oct 2008 15:57:35 +0200
Received: by nf-out-0910.google.com with SMTP id g13so682098nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 03 Oct 2008 06:57:30 -0700 (PDT)
Message-ID: <412bdbff0810030657p69ad9207kd68bd9bd1f989cc9@mail.gmail.com>
Date: Fri, 3 Oct 2008 09:57:30 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_19563_8821697.1223042250188"
Subject: [linux-dvb] Pinnacle 801e users: Don't update!
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

------=_Part_19563_8821697.1223042250188
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

If you are a user of the Pinnacle 801e, the changes supporting this
device went in to the mainline on Sunday morning.  However, due to a
subsequent commit, the code will cause a kernel panic if you actually
try to use it.

I would have brought this to users' attention sooner, but I wasn't
expecting the two line patch I submitted Sunday night to sit in
Mauro's queue for four days (and counting).

If you're a Pinnacle 801e user, you can either hold off on updating or
use the attached patch.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

------=_Part_19563_8821697.1223042250188
Content-Type: text/x-diff; name=801e_xc5000_panic.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fluvnp1g0
Content-Disposition: attachment; filename=801e_xc5000_panic.patch

UHV0IGNhbGxiYWNrIGRlZmluaXRpb24gYmVmb3JlIGZ1bmN0aW9uIHJldHVybiBhbmQgY2xlYW51
cCBjYWxsYmFjay4KCkZyb206IERldmluIEhlaXRtdWVsbGVyIDxkZXZpbi5oZWl0bXVlbGxlckBn
bWFpbC5jb20+CgpGaXggYSBidWcgd2hlcmUgdGhlIHhjNTAwMCBjYWxsYmFjayB3YXMgYmVpbmcg
c2V0ICphZnRlciogdGhlIHJldHVybiBjYWxsIChlc3NlbnRpYWxseSByZXN1bHRpbmcgaW4gZGVh
ZCBjb2RlKS4gIAoKQWxzbyBjbGVhbnVwIHRoZSBjYWxsYmFjayBmdW5jdGlvbiB0byBkZXRlY3Qg
dW5rbm93biBjb21tYW5kcy4KCkJ1ZyB3YXMgaW50cm9kdWNlZCBkdXJpbmcgY2FsbGJhY2sgcmVm
YWN0b3JpbmcgaW4gaGcgOTA1MS4KClNpZ25lZC1vZmYtYnk6IERldmluIEhlaXRtdWVsbGVyIDxk
ZXZpbi5oZWl0bXVlbGxlckBnbWFpbC5jb20+CgpkaWZmIC1yIDhlNmNkYTAyMWUwZSBsaW51eC9k
cml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCi0tLSBhL2xpbnV4L2Ry
aXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGliMDcwMF9kZXZpY2VzLmMJRnJpIFNlcCAyNiAxMToy
OTowMyAyMDA4ICswMjAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGli
MDcwMF9kZXZpY2VzLmMJU3VuIFNlcCAyOCAyMzowNzoyOCAyMDA4IC0wNDAwCkBAIC0xMTgxLDEx
ICsxMTgxLDE2IEBAIHN0YXRpYyBpbnQgZGliMDcwMF94YzUwMDBfdHVuZXJfY2FsbGJhY2sKIHsK
IAlzdHJ1Y3QgZHZiX3VzYl9hZGFwdGVyICphZGFwID0gcHJpdjsKIAotCS8qIFJlc2V0IHRoZSB0
dW5lciAqLwotCWRpYjA3MDBfc2V0X2dwaW8oYWRhcC0+ZGV2LCBHUElPMSwgR1BJT19PVVQsIDAp
OwotCW1zbGVlcCgzMzApOyAvKiBmcm9tIFdpbmRvd3MgVVNCIHRyYWNlICovCi0JZGliMDcwMF9z
ZXRfZ3BpbyhhZGFwLT5kZXYsIEdQSU8xLCBHUElPX09VVCwgMSk7Ci0JbXNsZWVwKDMzMCk7IC8q
IGZyb20gV2luZG93cyBVU0IgdHJhY2UgKi8KKwlpZiAoY29tbWFuZCA9PSBYQzUwMDBfVFVORVJf
UkVTRVQpIHsKKwkJLyogUmVzZXQgdGhlIHR1bmVyICovCisJCWRpYjA3MDBfc2V0X2dwaW8oYWRh
cC0+ZGV2LCBHUElPMSwgR1BJT19PVVQsIDApOworCQltc2xlZXAoMzMwKTsgLyogZnJvbSBXaW5k
b3dzIFVTQiB0cmFjZSAqLworCQlkaWIwNzAwX3NldF9ncGlvKGFkYXAtPmRldiwgR1BJTzEsIEdQ
SU9fT1VULCAxKTsKKwkJbXNsZWVwKDMzMCk7IC8qIGZyb20gV2luZG93cyBVU0IgdHJhY2UgKi8K
Kwl9IGVsc2UgeworCQllcnIoInhjNTAwMDogdW5rbm93biB0dW5lciBjYWxsYmFjayBjb21tYW5k
OiAlZFxuIiwgY29tbWFuZCk7CisJCXJldHVybiAtRUlOVkFMOworCX0KIAogCXJldHVybiAwOwog
fQpAQCAtMTE5NywxMiArMTIwMiwxMiBAQCBzdGF0aWMgc3RydWN0IHhjNTAwMF9jb25maWcgczVo
MTQxMV94YzUwCiAKIHN0YXRpYyBpbnQgeGM1MDAwX3R1bmVyX2F0dGFjaChzdHJ1Y3QgZHZiX3Vz
Yl9hZGFwdGVyICphZGFwKQogeworCS8qIEZJWE1FOiBnZW5lcmFsaXplICYgbW92ZSB0byBjb21t
b24gYXJlYSAqLworCWFkYXAtPmZlLT5jYWxsYmFjayA9IGRpYjA3MDBfeGM1MDAwX3R1bmVyX2Nh
bGxiYWNrOworCiAJcmV0dXJuIGR2Yl9hdHRhY2goeGM1MDAwX2F0dGFjaCwgYWRhcC0+ZmUsICZh
ZGFwLT5kZXYtPmkyY19hZGFwLAogCQkJICAmczVoMTQxMV94YzUwMDBfdHVuZXJjb25maWcpCiAJ
CT09IE5VTEwgPyAtRU5PREVWIDogMDsKLQotCS8qIEZJWE1FOiBnZW5lcmFsaXplICYgbW92ZSB0
byBjb21tb24gYXJlYSAqLwotCWFkYXAtPmZlLT5jYWxsYmFjayA9IGRpYjA3MDBfeGM1MDAwX3R1
bmVyX2NhbGxiYWNrOwogfQogCiAvKiBEVkItVVNCIGFuZCBVU0Igc3R1ZmYgZm9sbG93cyAqLwo=

------=_Part_19563_8821697.1223042250188
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_19563_8821697.1223042250188--
