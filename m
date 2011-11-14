Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56735 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1KNW4l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 17:56:41 -0500
Message-ID: <4EC19CA5.60904@iki.fi>
Date: Tue, 15 Nov 2011 00:56:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH FOR 3.2 FIX] af9015: limit I2C access to keep FW happy
References: <4EC014E5.5090303@iki.fi> <4EC01857.5050000@iki.fi> <4ec1955e.e813b40a.37be.3fce@mx.google.com>
In-Reply-To: <4ec1955e.e813b40a.37be.3fce@mx.google.com>
Content-Type: multipart/mixed;
 boundary="------------070601030007080904080206"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070601030007080904080206
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/2011 12:25 AM, Malcolm Priestley wrote:
>> On 11/13/2011 09:05 PM, Antti Palosaari wrote:
>>> AF9015 firmware does not like if it gets interrupted by I2C adapter
>>> request on some critical phases. During normal operation I2C adapter
>>> is used only 2nd demodulator and tuner on dual tuner devices.
>>>
>>> Override demodulator callbacks and use mutex for limit access to
>>> those "critical" paths to keep AF9015 happy.

> I have tried this patch, while it initially got MythTV working, there is
> too many call backs and some failed to acquire the lock. The device
> became unstable on both single and dual devices.
>
> The callbacks
>
> af9015_af9013_read_status,
> af9015_af9013_init
> af9015_af9013_sleep
>
> had to be removed.

init and sleep are called very rarely, only when open or close device. 
If that mutex locking cause problems it is most likely high I2C I/O + 
some waiting due to mux => we have more I/O than we can handle.

> I take your point, a call back can be an alternative.
>
> The patch didn't stop the firmware fails either.

You mean the loading fw to 2nd FE? I didn't done nothing for that.

> The af9015 usb bridge on the whole is so unstable in its early stages,
> especially on a cold boot and when the USB controller has another device
> on it, such as card reader or wifi device.
>
> I am, at the moment looking to see if the fails are due to interface 1
> being claimed by HID.

I still suspect corruptions to stream are coming from too high I2C 
traffic. I have feeling those who always squawk are just MythTV users, 
so maybe it is MythTV that does some very much polls and channel changes.

I added patch I tested reducing I2C I/O. Feel free to test.

I can try to optimize af9013 next weekend if we found it is one stream 
corruption cause.


Antti


-- 
http://palosaari.fi/

--------------070601030007080904080206
Content-Type: text/plain;
 name="af9013_reduce_i2c.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="af9013_reduce_i2c.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9hZjkwMTMuYyBiL2Ry
aXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9hZjkwMTMuYwppbmRleCBmNDI3NmU0Li40Njk0
ZjRiIDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvYWY5MDEzLmMK
KysrIGIvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL2FmOTAxMy5jCkBAIC01MCw2ICs1
MCw4IEBAIHN0cnVjdCBhZjkwMTNfc3RhdGUgewogCXUxNiBzbnI7CiAJdTMyIGZyZXF1ZW5j
eTsKIAl1bnNpZ25lZCBsb25nIG5leHRfc3RhdGlzdGljc19jaGVjazsKKworCXU4IGZlX3Nl
dDsKIH07CiAKIHN0YXRpYyB1OCByZWdtYXNrWzhdID0geyAweDAxLCAweDAzLCAweDA3LCAw
eDBmLCAweDFmLCAweDNmLCAweDdmLCAweGZmIH07CkBAIC02MDYsMTkgKzYwOCwyOSBAQCBz
dGF0aWMgaW50IGFmOTAxM19zZXRfZnJvbnRlbmQoc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUs
CiAKIAlzdGF0ZS0+ZnJlcXVlbmN5ID0gcGFyYW1zLT5mcmVxdWVuY3k7CiAKKwkvKiBTdG9w
IE9GU00gKi8gLy8gZnJvbSBNYWxjb20KKwlyZXQgPSBhZjkwMTNfd3JpdGVfcmVnKHN0YXRl
LCAweGZmZmYsIDEpOworCWlmIChyZXQpCisJCWdvdG8gZXJyb3I7CisKIAkvKiBwcm9ncmFt
IHR1bmVyICovCiAJaWYgKGZlLT5vcHMudHVuZXJfb3BzLnNldF9wYXJhbXMpCiAJCWZlLT5v
cHMudHVuZXJfb3BzLnNldF9wYXJhbXMoZmUsIHBhcmFtcyk7CiAKLQkvKiBwcm9ncmFtIENG
T0UgY29lZmZpY2llbnRzICovCi0JcmV0ID0gYWY5MDEzX3NldF9jb2VmZihzdGF0ZSwgcGFy
YW1zLT51Lm9mZG0uYmFuZHdpZHRoKTsKLQlpZiAocmV0KQotCQlnb3RvIGVycm9yOworCWlm
ICghc3RhdGUtPmZlX3NldCkgewogCi0JLyogcHJvZ3JhbSBmcmVxdWVuY3kgY29udHJvbCAq
LwotCXJldCA9IGFmOTAxM19zZXRfZnJlcV9jdHJsKHN0YXRlLCBmZSk7Ci0JaWYgKHJldCkK
LQkJZ290byBlcnJvcjsKKwkJLyogcHJvZ3JhbSBDRk9FIGNvZWZmaWNpZW50cyAqLworCQly
ZXQgPSBhZjkwMTNfc2V0X2NvZWZmKHN0YXRlLCBwYXJhbXMtPnUub2ZkbS5iYW5kd2lkdGgp
OworCQlpZiAocmV0KQorCQkJZ290byBlcnJvcjsKKworCQkvKiBwcm9ncmFtIGZyZXF1ZW5j
eSBjb250cm9sICovCisJCXJldCA9IGFmOTAxM19zZXRfZnJlcV9jdHJsKHN0YXRlLCBmZSk7
CisJCWlmIChyZXQpCisJCQlnb3RvIGVycm9yOworCisJCXN0YXRlLT5mZV9zZXQgPSAxOwor
CX0KIAogCS8qIGNsZWFyIFRQUyBsb2NrIGZsYWcgKGludmVydGVkIGZsYWcpICovCiAJcmV0
ID0gYWY5MDEzX3dyaXRlX3JlZ19iaXRzKHN0YXRlLCAweGQzMzAsIDMsIDEsIDEpOwpAQCAt
OTE3LDYgKzkyOSw3IEBAIHN0YXRpYyBpbnQgYWY5MDEzX3VwZGF0ZV9zbnIoc3RydWN0IGR2
Yl9mcm9udGVuZCAqZmUpCiAJCWlmIChyZXQpCiAJCQlnb3RvIGVycm9yOwogCisjaWYgMAog
CQkvKiBjaGVjayBxdWFudGl6ZXIgYXZhaWxhYmlsaXR5ICovCiAJCWZvciAoaSA9IDA7IGkg
PCAxMDsgaSsrKSB7CiAJCQltc2xlZXAoMTApOwpAQCAtOTI3LDcgKzk0MCw3IEBAIHN0YXRp
YyBpbnQgYWY5MDEzX3VwZGF0ZV9zbnIoc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUpCiAJCQlp
ZiAoIWJ1ZlswXSkKIAkJCQlicmVhazsKIAkJfQotCisjZW5kaWYKIAkJLyogcmVzZXQgcXVh
bnRpemVyICovCiAJCXJldCA9IGFmOTAxM193cml0ZV9yZWdfYml0cyhzdGF0ZSwgMHhkMmUx
LCAzLCAxLCAxKTsKIAkJaWYgKHJldCkKQEAgLTk3OCw2ICs5OTEsOCBAQCBzdGF0aWMgaW50
IGFmOTAxM191cGRhdGVfc3RhdGlzdGljcyhzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSkKIAlz
dHJ1Y3QgYWY5MDEzX3N0YXRlICpzdGF0ZSA9IGZlLT5kZW1vZHVsYXRvcl9wcml2OwogCWlu
dCByZXQ7CiAKKwlyZXR1cm4gMDsKKwogCWlmICh0aW1lX2JlZm9yZShqaWZmaWVzLCBzdGF0
ZS0+bmV4dF9zdGF0aXN0aWNzX2NoZWNrKSkKIAkJcmV0dXJuIDA7CiAKQEAgLTEwMTUsNiAr
MTAzMCwxNSBAQCBzdGF0aWMgaW50IGFmOTAxM19yZWFkX3N0YXR1cyhzdHJ1Y3QgZHZiX2Zy
b250ZW5kICpmZSwgZmVfc3RhdHVzX3QgKnN0YXR1cykKIAl1OCB0bXA7CiAJKnN0YXR1cyA9
IDA7CiAKKworCWlmIChzdGF0ZS0+Y29uZmlnLm91dHB1dF9tb2RlID09IEFGOTAxM19PVVRQ
VVRfTU9ERV9VU0IpIHsKKwkJKnN0YXR1cyB8PSBGRV9IQVNfU0lHTkFMIHwgRkVfSEFTX0NB
UlJJRVIgfCBGRV9IQVNfVklURVJCSSB8IEZFX0hBU19TWU5DIHwgRkVfSEFTX0xPQ0s7CisJ
fSBlbHNlIHsKKwkJKnN0YXR1cyB8PSBGRV9IQVNfU0lHTkFMIHwgRkVfSEFTX0NBUlJJRVIg
fCBGRV9IQVNfVklURVJCSSB8IEZFX0hBU19TWU5DIHwgRkVfSEFTX0xPQ0s7CisvLwkJKnN0
YXR1cyA9IDA7CisJfQorCisjaWYgMAogCS8qIE1QRUcyIGxvY2sgKi8KIAlyZXQgPSBhZjkw
MTNfcmVhZF9yZWdfYml0cyhzdGF0ZSwgMHhkNTA3LCA2LCAxLCAmdG1wKTsKIAlpZiAocmV0
KQpAQCAtMTA2MSw2ICsxMDg1LDcgQEAgc3RhdGljIGludCBhZjkwMTNfcmVhZF9zdGF0dXMo
c3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsIGZlX3N0YXR1c190ICpzdGF0dXMpCiAJfQogCiAJ
cmV0ID0gYWY5MDEzX3VwZGF0ZV9zdGF0aXN0aWNzKGZlKTsKKyNlbmRpZgogCiBlcnJvcjoK
IAlyZXR1cm4gcmV0OwpAQCAtMTEwOSwxMSArMTEzNCwxNCBAQCBzdGF0aWMgaW50IGFmOTAx
M19zbGVlcChzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSkKIAlpbnQgcmV0OwogCWRlYl9pbmZv
KCIlc1xuIiwgX19mdW5jX18pOwogCisJc3RhdGUtPmZlX3NldCA9IDA7CisKIAlyZXQgPSBh
ZjkwMTNfbG9ja19sZWQoc3RhdGUsIDApOwogCWlmIChyZXQpCiAJCWdvdG8gZXJyb3I7CiAK
IAlyZXQgPSBhZjkwMTNfcG93ZXJfY3RybChzdGF0ZSwgMCk7CisKIGVycm9yOgogCXJldHVy
biByZXQ7CiB9CkBAIC0xMTI2LDYgKzExNTQsOSBAQCBzdGF0aWMgaW50IGFmOTAxM19pbml0
KHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlKQogCXN0cnVjdCByZWdkZXNjICppbml0OwogCWRl
Yl9pbmZvKCIlc1xuIiwgX19mdW5jX18pOwogCisJc3RhdGUtPmZlX3NldCA9IDA7CisKKwog
CS8qIHJlc2V0IE9GRE0gKi8KIAlyZXQgPSBhZjkwMTNfcmVzZXQoc3RhdGUsIDApOwogCWlm
IChyZXQpCkBAIC0xMjkyLDYgKzEzMjMsOCBAQCBzdGF0aWMgaW50IGFmOTAxM19pbml0KHN0
cnVjdCBkdmJfZnJvbnRlbmQgKmZlKQogCQkJZ290byBlcnJvcjsKIAl9CiAKKwlyZXQgPSBh
ZjkwMTNfd3JpdGVfcmVnKHN0YXRlLCAweGQ1MDMsIDB4MCk7CisKIGVycm9yOgogCXJldHVy
biByZXQ7CiB9CkBAIC0xNTMwLDcgKzE1NjMsNyBAQCBzdGF0aWMgc3RydWN0IGR2Yl9mcm9u
dGVuZF9vcHMgYWY5MDEzX29wcyA9IHsKIAkuaTJjX2dhdGVfY3RybCA9IGFmOTAxM19pMmNf
Z2F0ZV9jdHJsLAogCiAJLnNldF9mcm9udGVuZCA9IGFmOTAxM19zZXRfZnJvbnRlbmQsCi0J
LmdldF9mcm9udGVuZCA9IGFmOTAxM19nZXRfZnJvbnRlbmQsCisvLwkuZ2V0X2Zyb250ZW5k
ID0gYWY5MDEzX2dldF9mcm9udGVuZCwKIAogCS5nZXRfdHVuZV9zZXR0aW5ncyA9IGFmOTAx
M19nZXRfdHVuZV9zZXR0aW5ncywKIAo=
--------------070601030007080904080206--
