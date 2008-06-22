Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.acc.umu.se ([130.239.18.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nikke@acc.umu.se>) id 1KAPqW-0006gO-GR
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 15:43:09 +0200
Received: from localhost (localhost [127.0.0.1])
	by amavisd-new (Postfix) with ESMTP id 335D52B7
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 15:43:05 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.acc.umu.se (Postfix) with ESMTP id DD5A22B4
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 15:43:01 +0200 (MEST)
Date: Sun, 22 Jun 2008 15:43:01 +0200 (MEST)
From: Niklas Edmundsson <nikke@acc.umu.se>
To: linux-dvb@linuxtv.org
Message-ID: <Pine.GSO.4.64.0806221541250.29266@hatchepsut.acc.umu.se>
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed;
	BOUNDARY="-559023410-851401618-1214140776=:17079"
Content-ID: <Pine.GSO.4.64.0806221541251.29266@hatchepsut.acc.umu.se>
Subject: [linux-dvb] [PATCH] mantis: Azurewave AD-CP300 on 2.6.18
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-851401618-1214140776=:17079
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <Pine.GSO.4.64.0806221541252.29266@hatchepsut.acc.umu.se>


Hi all!

After much frustration I managed to get my Azurewave AD-CP300 (aka Twinhan 
VP-2033) DVB-C card working using the mantis driver from 
http://www.jusst.de/hg/mantis/ on the Debian Etch 2.6.18 kernel. I only use it 
for Free-To-Air channels (no CA/CI/whatchamacallit).

To spare others some frustration I send the result of my hacking, this patch 
fixes:

- Compilation errors on 2.6.18 kernels (INIT_WORK takes different
   number of arguments, fix version for .release change in
   video_class).

- Prohibit TDA10021 claiming TDA10023 devices, since this makes
   tuning fail with no hint on what's wrong whatsoever. Fixes init to
   first try TDA10021 and then try TDA10023. This should work better
   than making assumptions based on the mantis subsystem ID.

- Make TDA10023 init print id in the same manner as TDA10021 init.

The TDA10023 detection on tda10021.c might need some polishing, I simply hard 
coded 0x7d as the id but someone with a relevant data sheet could improve it 
with some nice explanatory defines making tda10021.c claim devices it 
explicitly supports instead of just blacklisting new devices.

As said, it seems to work for me (dmesg):
found a VP-2033 PCI DVB-C device on (02:09.0),
     Mantis Rev 1 [1822:0008], irq: 169, latency: 64
     memory: 0xf6fff000, mmio: 0xe0a36000
     MAC Address=[00:08:ca:XX:YY:ZZ]
mantis_alloc_buffers (0): DMA=0x162c0000 cpu=0xd62c0000 size=65536
mantis_alloc_buffers (0): RISC=0x1514e000 cpu=0xd514e000 size=1000
DVB: registering new adapter (Mantis dvb adapter)
mantis_frontend_init (0): Probing for CU1216 (DVB-C)
TDA10023: i2c-addr = 0x0c, id = 0x7d
mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface

And tuning works:
% czap -n 6
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
   6 SVT1:410000000:INVERSION_AUTO:6875000:FEC_2_3:QAM_64:1001:1002:1010
   6 SVT1: f 410000000, s 6875000, i 2, fec 2, qam 3, v 0x3e9, a 0x3ea
status 00 | signal cccc | snr 0000 | ber 000fffff | unc 000000cf |
status 1f | signal cfcf | snr efef | ber 00000001 | unc 00000000 | FE_HAS_LOCK

So, I'm happy. Now I just hope that some derivative of this work finds it back 
into the relevant repositories. And to be honest, I hope that the mantis driver 
gets merged into the main v4l tree Really Soon Now.


/Nikke
-- 
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Niklas Edmundsson, Admin @ {acc,hpc2n}.umu.se      |     nikke@acc.umu.se
---------------------------------------------------------------------------
  You will never be younger then you are today..
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
---559023410-851401618-1214140776=:17079
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=mantis-2.6.18+adcp300.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.64.0806221519360.17079@hatchepsut.acc.umu.se>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=mantis-2.6.18+adcp300.patch

ZGlmZiAtciAwYjA0YmUwYzA4OGEgbGludXgvZHJpdmVycy9tZWRpYS9kdmIv
ZnJvbnRlbmRzL3RkYTEwMDIxLmMNCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVk
aWEvZHZiL2Zyb250ZW5kcy90ZGExMDAyMS5jCVdlZCBNYXkgMjggMTM6MjU6
MjMgMjAwOCArMDQwMA0KKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9kdmIv
ZnJvbnRlbmRzL3RkYTEwMDIxLmMJU3VuIEp1biAyMiAxMzo1NzoxOCAyMDA4
ICswMjAwDQpAQCAtNDI1LDYgKzQyNSwxMSBAQCBzdHJ1Y3QgZHZiX2Zyb250
ZW5kKiB0ZGExMDAyMV9hdHRhY2goc3RyDQogCS8qIGNoZWNrIGlmIHRoZSBk
ZW1vZCBpcyB0aGVyZSAqLw0KIAlpZCA9IHRkYTEwMDIxX3JlYWRyZWcoc3Rh
dGUsIDB4MWEpOw0KIAlpZiAoKGlkICYgMHhmMCkgIT0gMHg3MCkgZ290byBl
cnJvcjsNCisNCisJLyogRG9uJ3QgY2xhaW0gVERBMTAwMjMgKi8NCisJaWYo
aWQgPT0gMHg3ZCkgew0KKwkJZ290byBlcnJvcjsNCisJfQ0KIA0KIAlwcmlu
dGsoIlREQTEwMDIxOiBpMmMtYWRkciA9IDB4JTAyeCwgaWQgPSAweCUwMnhc
biIsDQogCSAgICAgICBzdGF0ZS0+Y29uZmlnLT5kZW1vZF9hZGRyZXNzLCBp
ZCk7DQpkaWZmIC1yIDBiMDRiZTBjMDg4YSBsaW51eC9kcml2ZXJzL21lZGlh
L2R2Yi9mcm9udGVuZHMvdGRhMTAwMjMuYw0KLS0tIGEvbGludXgvZHJpdmVy
cy9tZWRpYS9kdmIvZnJvbnRlbmRzL3RkYTEwMDIzLmMJV2VkIE1heSAyOCAx
MzoyNToyMyAyMDA4ICswNDAwDQorKysgYi9saW51eC9kcml2ZXJzL21lZGlh
L2R2Yi9mcm9udGVuZHMvdGRhMTAwMjMuYwlTdW4gSnVuIDIyIDE0OjIyOjEy
IDIwMDggKzAyMDANCkBAIC00NjYsNiArNDY2LDcgQEAgc3RydWN0IGR2Yl9m
cm9udGVuZCogdGRhMTAwMjNfYXR0YWNoKGNvbg0KIHsNCiAJc3RydWN0IHRk
YTEwMDIzX3N0YXRlKiBzdGF0ZSA9IE5VTEw7DQogCWludCBpOw0KKwl1OCBp
ZDsNCiANCiAJLyogYWxsb2NhdGUgbWVtb3J5IGZvciB0aGUgaW50ZXJuYWwg
c3RhdGUgKi8NCiAJc3RhdGUgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgdGRh
MTAwMjNfc3RhdGUpLCBHRlBfS0VSTkVMKTsNCkBAIC00ODUsOCArNDg2LDEz
IEBAIHN0cnVjdCBkdmJfZnJvbnRlbmQqIHRkYTEwMDIzX2F0dGFjaChjb24N
CiANCiAJLy8gV2FrZXVwIGlmIGluIHN0YW5kYnkNCiAJdGRhMTAwMjNfd3Jp
dGVyZWcgKHN0YXRlLCAweDAwLCAweDMzKTsNCisNCiAJLyogY2hlY2sgaWYg
dGhlIGRlbW9kIGlzIHRoZXJlICovDQotCWlmICgodGRhMTAwMjNfcmVhZHJl
ZyhzdGF0ZSwgMHgxYSkgJiAweGYwKSAhPSAweDcwKSBnb3RvIGVycm9yOw0K
KwlpZCA9IHRkYTEwMDIzX3JlYWRyZWcoc3RhdGUsIDB4MWEpOw0KKwlpZiAo
KGlkICYgMHhmMCkgIT0gMHg3MCkgZ290byBlcnJvcjsNCisNCisJcHJpbnRr
KCJUREExMDAyMzogaTJjLWFkZHIgPSAweCUwMngsIGlkID0gMHglMDJ4XG4i
LA0KKwkJc3RhdGUtPmNvbmZpZy0+ZGVtb2RfYWRkcmVzcywgaWQpOw0KIA0K
IAkvKiBjcmVhdGUgZHZiX2Zyb250ZW5kICovDQogCW1lbWNweSgmc3RhdGUt
PmZyb250ZW5kLm9wcywgJnRkYTEwMDIzX29wcywgc2l6ZW9mKHN0cnVjdCBk
dmJfZnJvbnRlbmRfb3BzKSk7DQpkaWZmIC1yIDBiMDRiZTBjMDg4YSBsaW51
eC9kcml2ZXJzL21lZGlhL2R2Yi9tYW50aXMvbWFudGlzX2R2Yi5jDQotLS0g
YS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9tYW50aXMvbWFudGlzX2R2Yi5j
CVdlZCBNYXkgMjggMTM6MjU6MjMgMjAwOCArMDQwMA0KKysrIGIvbGludXgv
ZHJpdmVycy9tZWRpYS9kdmIvbWFudGlzL21hbnRpc19kdmIuYwlTdW4gSnVu
IDIyIDE0OjExOjU2IDIwMDggKzAyMDANCkBAIC0yNjAsMjkgKzI2MCwyNiBA
QCBpbnQgX19kZXZpbml0IG1hbnRpc19mcm9udGVuZF9pbml0KHN0cnVjDQog
CQl9DQogCQlicmVhazsNCiAJY2FzZSBNQU5USVNfVlBfMjAzM19EVkJfQzoJ
Ly8gVlAtMjAzMw0KLQkJZHByaW50ayh2ZXJib3NlLCBNQU5USVNfRVJST1Is
IDEsICJQcm9iaW5nIGZvciBDVTEyMTYgKERWQi1DKSIpOw0KLQkJbWFudGlz
LT5mZSA9IHRkYTEwMDIxX2F0dGFjaCgmcGhpbGlwc19jdTEyMTZfY29uZmln
LCAmbWFudGlzLT5hZGFwdGVyLCByZWFkX3B3bShtYW50aXMpKTsNCi0JCWlm
IChtYW50aXMtPmZlKSB7DQotCQkJbWFudGlzLT5mZS0+b3BzLnR1bmVyX29w
cy5zZXRfcGFyYW1zID0gcGhpbGlwc19jdTEyMTZfdHVuZXJfc2V0Ow0KLQkJ
CWRwcmludGsodmVyYm9zZSwgTUFOVElTX0VSUk9SLCAxLA0KLQkJCQkiZm91
bmQgUGhpbGlwcyBDVTEyMTYgRFZCLUMgZnJvbnRlbmQgKFREQTEwMDIxKSBA
IDB4JTAyeCIsDQotCQkJCXBoaWxpcHNfY3UxMjE2X2NvbmZpZy5kZW1vZF9h
ZGRyZXNzKTsNCi0NCi0JCQlkcHJpbnRrKHZlcmJvc2UsIE1BTlRJU19FUlJP
UiwgMSwNCi0JCQkJIk1hbnRpcyBEVkItQyBQaGlsaXBzIENVMTIxNiBmcm9u
dGVuZCBhdHRhY2ggc3VjY2VzcyIpOw0KLQ0KLQkJfQ0KLQkJYnJlYWs7DQog
CWNhc2UgTUFOVElTX1ZQXzIwNDBfRFZCX0M6CS8vIFZQLTIwNDANCiAJY2Fz
ZSBURVJSQVRFQ19DSU5FUkdZX0NfUENJOg0KIAljYXNlIFRFQ0hOSVNBVF9D
QUJMRVNUQVJfSEQyOg0KIAkJZHByaW50ayh2ZXJib3NlLCBNQU5USVNfRVJS
T1IsIDEsICJQcm9iaW5nIGZvciBDVTEyMTYgKERWQi1DKSIpOw0KLQkJbWFu
dGlzLT5mZSA9IHRkYTEwMDIzX2F0dGFjaCgmdGRhMTAwMjNfY3UxMjE2X2Nv
bmZpZywgJm1hbnRpcy0+YWRhcHRlciwgcmVhZF9wd20obWFudGlzKSk7DQor
CQltYW50aXMtPmZlID0gdGRhMTAwMjFfYXR0YWNoKCZwaGlsaXBzX2N1MTIx
Nl9jb25maWcsICZtYW50aXMtPmFkYXB0ZXIsIHJlYWRfcHdtKG1hbnRpcykp
Ow0KKwkJaWYobWFudGlzLT5mZSkgew0KKwkJCWRwcmludGsodmVyYm9zZSwg
TUFOVElTX0VSUk9SLCAxLA0KKwkJCQkiZm91bmQgUGhpbGlwcyBDVTEyMTYg
RFZCLUMgZnJvbnRlbmQgKFREQTEwMDIxKSBAIDB4JTAyeCIsDQorCQkJCXBo
aWxpcHNfY3UxMjE2X2NvbmZpZy5kZW1vZF9hZGRyZXNzKTsNCisJCX0NCisJ
CWVsc2Ugew0KKwkJCW1hbnRpcy0+ZmUgPSB0ZGExMDAyM19hdHRhY2goJnRk
YTEwMDIzX2N1MTIxNl9jb25maWcsICZtYW50aXMtPmFkYXB0ZXIsIHJlYWRf
cHdtKG1hbnRpcykpOw0KKwkJCWlmKG1hbnRpcy0+ZmUpIHsNCisJCQkJZHBy
aW50ayh2ZXJib3NlLCBNQU5USVNfRVJST1IsIDEsDQorCQkJCQkiZm91bmQg
UGhpbGlwcyBDVTEyMTYgRFZCLUMgZnJvbnRlbmQgKFREQTEwMDIzKSBAIDB4
JTAyeCIsDQorCQkJCQlwaGlsaXBzX2N1MTIxNl9jb25maWcuZGVtb2RfYWRk
cmVzcyk7DQorCQkJfQ0KKwkJfQ0KIAkJaWYgKG1hbnRpcy0+ZmUpIHsNCiAJ
CQltYW50aXMtPmZlLT5vcHMudHVuZXJfb3BzLnNldF9wYXJhbXMgPSBwaGls
aXBzX2N1MTIxNl90dW5lcl9zZXQ7DQotCQkJZHByaW50ayh2ZXJib3NlLCBN
QU5USVNfRVJST1IsIDEsDQotCQkJCSJmb3VuZCBQaGlsaXBzIENVMTIxNiBE
VkItQyBmcm9udGVuZCAoVERBMTAwMjMpIEAgMHglMDJ4IiwNCi0JCQkJcGhp
bGlwc19jdTEyMTZfY29uZmlnLmRlbW9kX2FkZHJlc3MpOw0KIA0KIAkJCWRw
cmludGsodmVyYm9zZSwgTUFOVElTX0VSUk9SLCAxLA0KIAkJCQkiTWFudGlz
IERWQi1DIFBoaWxpcHMgQ1UxMjE2IGZyb250ZW5kIGF0dGFjaCBzdWNjZXNz
Iik7DQpkaWZmIC1yIDBiMDRiZTBjMDg4YSBsaW51eC9kcml2ZXJzL21lZGlh
L2R2Yi9tYW50aXMvbWFudGlzX2V2bS5jDQotLS0gYS9saW51eC9kcml2ZXJz
L21lZGlhL2R2Yi9tYW50aXMvbWFudGlzX2V2bS5jCVdlZCBNYXkgMjggMTM6
MjU6MjMgMjAwOCArMDQwMA0KKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9k
dmIvbWFudGlzL21hbnRpc19ldm0uYwlTdW4gSnVuIDIyIDExOjUzOjQ3IDIw
MDggKzAyMDANCkBAIC04Niw3ICs4NiwxMSBAQCBpbnQgbWFudGlzX2V2bWdy
X2luaXQoc3RydWN0IG1hbnRpc19jYSAqDQogCXN0cnVjdCBtYW50aXNfcGNp
ICptYW50aXMgPSBjYS0+Y2FfcHJpdjsNCiANCiAJZHByaW50ayh2ZXJib3Nl
LCBNQU5USVNfREVCVUcsIDEsICJJbml0aWFsaXppbmcgTWFudGlzIEhvc3Qg
SS9GIEV2ZW50IG1hbmFnZXIiKTsNCisjaWYgTElOVVhfVkVSU0lPTl9DT0RF
ID49IEtFUk5FTF9WRVJTSU9OKDIsIDYsIDIwKQ0KIAlJTklUX1dPUksoJmNh
LT5oaWZfZXZtX3dvcmssIG1hbnRpc19oaWZldm1fd29yayk7DQorI2Vsc2UN
CisJSU5JVF9XT1JLKCZjYS0+aGlmX2V2bV93b3JrLCBtYW50aXNfaGlmZXZt
X3dvcmssIGNhKTsNCisjZW5kaWYNCiAJbWFudGlzX3BjbWNpYV9pbml0KGNh
KTsJDQogCXNjaGVkdWxlX3dvcmsoJmNhLT5oaWZfZXZtX3dvcmspOw0KIAlt
YW50aXNfaGlmX2luaXQoY2EpOw0KZGlmZiAtciAwYjA0YmUwYzA4OGEgbGlu
dXgvZHJpdmVycy9tZWRpYS92aWRlby92aWRlb2Rldi5jDQotLS0gYS9saW51
eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3ZpZGVvZGV2LmMJV2VkIE1heSAyOCAx
MzoyNToyMyAyMDA4ICswNDAwDQorKysgYi9saW51eC9kcml2ZXJzL21lZGlh
L3ZpZGVvL3ZpZGVvZGV2LmMJU2F0IEFwciAwNSAxNTo0OTowNSAyMDA4ICsw
MjAwDQpAQCAtNDg1LDcgKzQ4NSw3IEBAIHN0YXRpYyBzdHJ1Y3QgZGV2aWNl
X2F0dHJpYnV0ZSB2aWRlb19kZXYNCiANCiBzdGF0aWMgc3RydWN0IGNsYXNz
IHZpZGVvX2NsYXNzID0gew0KIAkubmFtZSAgICA9IFZJREVPX05BTUUsDQot
I2lmIExJTlVYX1ZFUlNJT05fQ09ERSA8IEtFUk5FTF9WRVJTSU9OKDIsNiwx
MykNCisjaWYgTElOVVhfVkVSU0lPTl9DT0RFIDwgS0VSTkVMX1ZFUlNJT04o
Miw2LDE5KQ0KIAkucmVsZWFzZSA9IHZpZGVvX3JlbGVhc2UsDQogI2Vsc2UN
CiAJLmRldl9hdHRycyA9IHZpZGVvX2RldmljZV9hdHRycywNCg==

---559023410-851401618-1214140776=:17079
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
---559023410-851401618-1214140776=:17079--
