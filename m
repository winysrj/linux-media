Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.acc.umu.se ([130.239.18.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nikke@acc.umu.se>) id 1KrURy-0005Nh-2e
	for linux-dvb@linuxtv.org; Sun, 19 Oct 2008 11:19:53 +0200
Date: Sun, 19 Oct 2008 11:19:40 +0200 (MEST)
From: Niklas Edmundsson <nikke@acc.umu.se>
To: Hans Bergersen <h_bergersen@hotmail.com>
In-Reply-To: <BAY109-W307DF75E4A987746AD9EE585300@phx.gbl>
Message-ID: <Pine.GSO.4.64.0810191117040.16269@hatchepsut.acc.umu.se>
References: <BAY109-W307DF75E4A987746AD9EE585300@phx.gbl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-559023410-851401618-1224407980=:16269"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis 2033 dvb-tuning problems
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

---559023410-851401618-1224407980=:16269
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Wed, 15 Oct 2008, Hans Bergersen wrote:

> Hi,
>

> I have got a Twinhan vp-2033 based card. I run Ubuntu 8.04. I have 
> downloaded the driver from http://jusst.de/hg/mantis and it compiled 
> just fine. But when i try to tune a channel the tuning fails. It is 
> a newer card with the tda10023 tuner but when the driver loads it 
> uses the tda10021. What do I have to do to make it use the right 
> tuner? Can i give some options when compiling or when loading the 
> module?
<snip>
> Any ideas?

Try the attached patch which fixes this for my Azurewave AD-CP300 (at 
least last time I compiled it).

I've sent it to Manu and he was going to apply it, but it hasn't shown 
up on http://jusst.de/hg/mantis/ yet...


/Nikke
-- 
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Niklas Edmundsson, Admin @ {acc,hpc2n}.umu.se      |     nikke@acc.umu.se
---------------------------------------------------------------------------
  "I don't believe it. There are no respected plastic surgeons." - Logan
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
---559023410-851401618-1224407980=:16269
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=mantis-adcp300-20080927.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.64.0810191119400.16269@hatchepsut.acc.umu.se>
Content-Description: 
Content-Disposition: attachment; filename=mantis-adcp300-20080927.patch

DQpGaXggdGRhMTAwMjEgdG8gbm90IGNsYWltIHRkYTEwMDIzLg0KDQpQcmV2
aW91c2x5IG1hbnRpc19mcm9udGVuZF9pbml0KCkgcmVsaWVkIG9uIHRoZSBQ
Q0kgSUQgYWxvbmUsIHRoaXMNCmNhdXNlcyB0cm91YmxlIHdoZW4gYSBjYXJk
IGhhcyBhIGRpZmZlcmVudCBjaGlwIGRlcGVuZGluZyBvbg0KdGhlIG1hbnVm
YWN0dXJpbmcgZGF0ZS4gVGhpcyBtYXRjaCBtYWtlcyBpdCB3b3JrIHdpdGgg
bmV3ZXINCkF6dXJld2F2ZSBBRC1DUDMwMCBjYXJkcyB3aGlsZSAoaG9wZWZ1
bGx5KSBtYWludGFpbmluZyBjb21wYXRpYmlsaXR5DQp3aXRoIG9sZGVyIGNh
cmRzLg0KDQpTaWduZWQtb2ZmLWJ5OiBOaWtsYXMgRWRtdW5kc3NvbiA8bmlr
a2VAYWNjLnVtdS5zZT4NCg0KDQpkaWZmIC1yIDMwM2IxZDI5ZDczNSBsaW51
eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvdGRhMTAwMjEuYw0KLS0t
IGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL3RkYTEwMDIx
LmMJU3VuIFNlcCAyMSAxOTo0MTowMCAyMDA4ICswNDAwDQorKysgYi9saW51
eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvdGRhMTAwMjEuYwlTdW4g
U2VwIDE0IDIxOjQzOjI0IDIwMDggKzAyMDANCkBAIC00MjUsNiArNDI1LDEx
IEBAIHN0cnVjdCBkdmJfZnJvbnRlbmQqIHRkYTEwMDIxX2F0dGFjaChzdHIN
CiAJLyogY2hlY2sgaWYgdGhlIGRlbW9kIGlzIHRoZXJlICovDQogCWlkID0g
dGRhMTAwMjFfcmVhZHJlZyhzdGF0ZSwgMHgxYSk7DQogCWlmICgoaWQgJiAw
eGYwKSAhPSAweDcwKSBnb3RvIGVycm9yOw0KKw0KKwkvKiBEb24ndCBjbGFp
bSBUREExMDAyMyAqLw0KKwlpZihpZCA9PSAweDdkKSB7DQorCQlnb3RvIGVy
cm9yOw0KKwl9DQogDQogCXByaW50aygiVERBMTAwMjE6IGkyYy1hZGRyID0g
MHglMDJ4LCBpZCA9IDB4JTAyeFxuIiwNCiAJICAgICAgIHN0YXRlLT5jb25m
aWctPmRlbW9kX2FkZHJlc3MsIGlkKTsNCmRpZmYgLXIgMzAzYjFkMjlkNzM1
IGxpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy90ZGExMDAyMy5j
DQotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvdGRh
MTAwMjMuYwlTdW4gU2VwIDIxIDE5OjQxOjAwIDIwMDggKzA0MDANCisrKyBi
L2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy90ZGExMDAyMy5j
CVN1biBTZXAgMTQgMjE6NTQ6NTMgMjAwOCArMDIwMA0KQEAgLTQ4Nyw2ICs0
ODcsNyBAQCBzdHJ1Y3QgZHZiX2Zyb250ZW5kICp0ZGExMDAyM19hdHRhY2go
Y29uDQogCQkJCSAgICAgdTggcHdtKQ0KIHsNCiAJc3RydWN0IHRkYTEwMDIz
X3N0YXRlKiBzdGF0ZSA9IE5VTEw7DQorCXU4IGlkOw0KIA0KIAkvKiBhbGxv
Y2F0ZSBtZW1vcnkgZm9yIHRoZSBpbnRlcm5hbCBzdGF0ZSAqLw0KIAlzdGF0
ZSA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCB0ZGExMDAyM19zdGF0ZSksIEdG
UF9LRVJORUwpOw0KQEAgLTQ5OCw4ICs0OTksMTMgQEAgc3RydWN0IGR2Yl9m
cm9udGVuZCAqdGRhMTAwMjNfYXR0YWNoKGNvbg0KIA0KIAkvKiB3YWtldXAg
aWYgaW4gc3RhbmRieSAqLw0KIAl0ZGExMDAyM193cml0ZXJlZyAoc3RhdGUs
IDB4MDAsIDB4MzMpOw0KKw0KIAkvKiBjaGVjayBpZiB0aGUgZGVtb2QgaXMg
dGhlcmUgKi8NCi0JaWYgKCh0ZGExMDAyM19yZWFkcmVnKHN0YXRlLCAweDFh
KSAmIDB4ZjApICE9IDB4NzApIGdvdG8gZXJyb3I7DQorCWlkID0gdGRhMTAw
MjNfcmVhZHJlZyhzdGF0ZSwgMHgxYSk7DQorCWlmICgoaWQgJiAweGYwKSAh
PSAweDcwKSBnb3RvIGVycm9yOw0KKw0KKwlwcmludGsoIlREQTEwMDIzOiBp
MmMtYWRkciA9IDB4JTAyeCwgaWQgPSAweCUwMnhcbiIsDQorCQlzdGF0ZS0+
Y29uZmlnLT5kZW1vZF9hZGRyZXNzLCBpZCk7DQogDQogCS8qIGNyZWF0ZSBk
dmJfZnJvbnRlbmQgKi8NCiAJbWVtY3B5KCZzdGF0ZS0+ZnJvbnRlbmQub3Bz
LCAmdGRhMTAwMjNfb3BzLCBzaXplb2Yoc3RydWN0IGR2Yl9mcm9udGVuZF9v
cHMpKTsNCmRpZmYgLXIgMzAzYjFkMjlkNzM1IGxpbnV4L2RyaXZlcnMvbWVk
aWEvZHZiL21hbnRpcy9tYW50aXNfZHZiLmMNCi0tLSBhL2xpbnV4L2RyaXZl
cnMvbWVkaWEvZHZiL21hbnRpcy9tYW50aXNfZHZiLmMJU3VuIFNlcCAyMSAx
OTo0MTowMCAyMDA4ICswNDAwDQorKysgYi9saW51eC9kcml2ZXJzL21lZGlh
L2R2Yi9tYW50aXMvbWFudGlzX2R2Yi5jCVN1biBTZXAgMTQgMjE6NTQ6NTUg
MjAwOCArMDIwMA0KQEAgLTI2MywyOSArMjYzLDI2IEBAIGludCBfX2Rldmlu
aXQgbWFudGlzX2Zyb250ZW5kX2luaXQoc3RydWMNCiAJCX0NCiAJCWJyZWFr
Ow0KIAljYXNlIE1BTlRJU19WUF8yMDMzX0RWQl9DOgkvLyBWUC0yMDMzDQot
CQlkcHJpbnRrKHZlcmJvc2UsIE1BTlRJU19FUlJPUiwgMSwgIlByb2Jpbmcg
Zm9yIENVMTIxNiAoRFZCLUMpIik7DQotCQltYW50aXMtPmZlID0gdGRhMTAw
MjFfYXR0YWNoKCZwaGlsaXBzX2N1MTIxNl9jb25maWcsICZtYW50aXMtPmFk
YXB0ZXIsIHJlYWRfcHdtKG1hbnRpcykpOw0KLQkJaWYgKG1hbnRpcy0+ZmUp
IHsNCi0JCQltYW50aXMtPmZlLT5vcHMudHVuZXJfb3BzLnNldF9wYXJhbXMg
PSBwaGlsaXBzX2N1MTIxNl90dW5lcl9zZXQ7DQotCQkJZHByaW50ayh2ZXJi
b3NlLCBNQU5USVNfRVJST1IsIDEsDQotCQkJCSJmb3VuZCBQaGlsaXBzIENV
MTIxNiBEVkItQyBmcm9udGVuZCAoVERBMTAwMjEpIEAgMHglMDJ4IiwNCi0J
CQkJcGhpbGlwc19jdTEyMTZfY29uZmlnLmRlbW9kX2FkZHJlc3MpOw0KLQ0K
LQkJCWRwcmludGsodmVyYm9zZSwgTUFOVElTX0VSUk9SLCAxLA0KLQkJCQki
TWFudGlzIERWQi1DIFBoaWxpcHMgQ1UxMjE2IGZyb250ZW5kIGF0dGFjaCBz
dWNjZXNzIik7DQotDQotCQl9DQotCQlicmVhazsNCiAJY2FzZSBNQU5USVNf
VlBfMjA0MF9EVkJfQzoJLy8gVlAtMjA0MA0KIAljYXNlIFRFUlJBVEVDX0NJ
TkVSR1lfQ19QQ0k6DQogCWNhc2UgVEVDSE5JU0FUX0NBQkxFU1RBUl9IRDI6
DQogCQlkcHJpbnRrKHZlcmJvc2UsIE1BTlRJU19FUlJPUiwgMSwgIlByb2Jp
bmcgZm9yIENVMTIxNiAoRFZCLUMpIik7DQotCQltYW50aXMtPmZlID0gdGRh
MTAwMjNfYXR0YWNoKCZ0ZGExMDAyM19jdTEyMTZfY29uZmlnLCAmbWFudGlz
LT5hZGFwdGVyLCByZWFkX3B3bShtYW50aXMpKTsNCisJCW1hbnRpcy0+ZmUg
PSB0ZGExMDAyMV9hdHRhY2goJnBoaWxpcHNfY3UxMjE2X2NvbmZpZywgJm1h
bnRpcy0+YWRhcHRlciwgcmVhZF9wd20obWFudGlzKSk7DQorCQlpZihtYW50
aXMtPmZlKSB7DQorCQkJZHByaW50ayh2ZXJib3NlLCBNQU5USVNfRVJST1Is
IDEsDQorCQkJCSJmb3VuZCBQaGlsaXBzIENVMTIxNiBEVkItQyBmcm9udGVu
ZCAoVERBMTAwMjEpIEAgMHglMDJ4IiwNCisJCQkJcGhpbGlwc19jdTEyMTZf
Y29uZmlnLmRlbW9kX2FkZHJlc3MpOw0KKwkJfQ0KKwkJZWxzZSB7DQorCQkJ
bWFudGlzLT5mZSA9IHRkYTEwMDIzX2F0dGFjaCgmdGRhMTAwMjNfY3UxMjE2
X2NvbmZpZywgJm1hbnRpcy0+YWRhcHRlciwgcmVhZF9wd20obWFudGlzKSk7
DQorCQkJaWYobWFudGlzLT5mZSkgew0KKwkJCQlkcHJpbnRrKHZlcmJvc2Us
IE1BTlRJU19FUlJPUiwgMSwNCisJCQkJCSJmb3VuZCBQaGlsaXBzIENVMTIx
NiBEVkItQyBmcm9udGVuZCAoVERBMTAwMjMpIEAgMHglMDJ4IiwNCisJCQkJ
CXBoaWxpcHNfY3UxMjE2X2NvbmZpZy5kZW1vZF9hZGRyZXNzKTsNCisJCQl9
DQorCQl9DQogCQlpZiAobWFudGlzLT5mZSkgew0KIAkJCW1hbnRpcy0+ZmUt
Pm9wcy50dW5lcl9vcHMuc2V0X3BhcmFtcyA9IHBoaWxpcHNfY3UxMjE2X3R1
bmVyX3NldDsNCi0JCQlkcHJpbnRrKHZlcmJvc2UsIE1BTlRJU19FUlJPUiwg
MSwNCi0JCQkJImZvdW5kIFBoaWxpcHMgQ1UxMjE2IERWQi1DIGZyb250ZW5k
IChUREExMDAyMykgQCAweCUwMngiLA0KLQkJCQlwaGlsaXBzX2N1MTIxNl9j
b25maWcuZGVtb2RfYWRkcmVzcyk7DQogDQogCQkJZHByaW50ayh2ZXJib3Nl
LCBNQU5USVNfRVJST1IsIDEsDQogCQkJCSJNYW50aXMgRFZCLUMgUGhpbGlw
cyBDVTEyMTYgZnJvbnRlbmQgYXR0YWNoIHN1Y2Nlc3MiKTsNCg==

---559023410-851401618-1224407980=:16269
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
---559023410-851401618-1224407980=:16269--
