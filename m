Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.m1stereo.tv ([91.244.124.37]:57558 "EHLO
        kazbek.m1stereo.tv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbdKXIwI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 03:52:08 -0500
Received: from [10.1.5.65] (dev-3.internal.m1stereo.tv [10.1.5.65])
        by kazbek.m1stereo.tv (8.14.4/8.14.4) with ESMTP id vAO8q5qQ025248
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 10:52:05 +0200
From: Maksym Veremeyenko <verem@m1stereo.tv>
Subject: [PATCH/RFC] not use a DiSEqC switch
To: linux-media@vger.kernel.org
Message-ID: <b5573a09-f841-d126-df19-0ecc76d15511@m1stereo.tv>
Date: Fri, 24 Nov 2017 10:52:04 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------C66209FDFC4922966214FF93"
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------C66209FDFC4922966214FF93
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

there is a code in function *dvbsat_diseqc_set_input*:

[...]
	/* Negative numbers means to not use a DiSEqC switch */
	if (parms->p.sat_number < 0)
		return 0;
[...]

if it mean /there is no DiSEqC switch/ then LNB's *polarity* and *band* 
settings still should be applied - attached patch fixes that behavior.

if it mean /current DVB is a slave/ i.e. it is connected to LOOP OUT of 
another DVB, so no need to configure anything, then statement above is 
correct and no patches from this email should be applied.

-- 
Maksym Veremeyenko



--------------C66209FDFC4922966214FF93
Content-Type: text/plain; charset=UTF-8;
 name="0003-Fix-setting-band-and-polarity-if-sat_number-is-negat.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0003-Fix-setting-band-and-polarity-if-sat_number-is-negat.pa";
 filename*1="tch"

RnJvbSA1N2FjMzQ2NDMzNzIwYzBjOWI4Y2UzMGEzMmJkZmExZGYwNzVmZWRlIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYWtzeW0gVmVyZW1leWVua28gPHZlcmVtQG0xLnR2
PgpEYXRlOiBGcmksIDI0IE5vdiAyMDE3IDA4OjU5OjQxICswMTAwClN1YmplY3Q6IFtQQVRD
SCAzLzRdIEZpeCBzZXR0aW5nIGJhbmQgYW5kIHBvbGFyaXR5IGlmIHNhdF9udW1iZXIgaXMg
bmVnYXRpdmUKCi0tLQogbGliL2xpYmR2YnY1L2R2Yi1zYXQuYyB8IDggKysrKy0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvbGliL2xpYmR2YnY1L2R2Yi1zYXQuYyBiL2xpYi9saWJkdmJ2NS9kdmItc2F0LmMK
aW5kZXggYTAxZGI3MmUuLjhiMmZjZjdkIDEwMDY0NAotLS0gYS9saWIvbGliZHZidjUvZHZi
LXNhdC5jCisrKyBiL2xpYi9saWJkdmJ2NS9kdmItc2F0LmMKQEAgLTUyMywxMCArNTIzLDYg
QEAgc3RhdGljIGludCBkdmJzYXRfZGlzZXFjX3NldF9pbnB1dChzdHJ1Y3QgZHZiX3Y1X2Zl
X3Bhcm1zX3ByaXYgKnBhcm1zLAogCXN0cnVjdCBkaXNlcWNfY21kIGNtZDsKIAljb25zdCBz
dHJ1Y3QgZHZiX3NhdF9sbmJfcHJpdiAqbG5iID0gKHZvaWQgKilwYXJtcy0+cC5sbmI7CiAK
LQkvKiBOZWdhdGl2ZSBudW1iZXJzIG1lYW5zIHRvIG5vdCB1c2UgYSBEaVNFcUMgc3dpdGNo
ICovCi0JaWYgKHBhcm1zLT5wLnNhdF9udW1iZXIgPCAwKQotCQlyZXR1cm4gMDsKLQogCWR2
Yl9mZV9yZXRyaWV2ZV9wYXJtKCZwYXJtcy0+cCwgRFRWX1BPTEFSSVpBVElPTiwgJnBvbCk7
CiAJcG9sX3YgPSAocG9sID09IFBPTEFSSVpBVElPTl9WKSB8fCAocG9sID09IFBPTEFSSVpB
VElPTl9SKTsKIApAQCAtNTU4LDYgKzU1NCw5IEBAIHN0YXRpYyBpbnQgZHZic2F0X2Rpc2Vx
Y19zZXRfaW5wdXQoc3RydWN0IGR2Yl92NV9mZV9wYXJtc19wcml2ICpwYXJtcywKIAogCXVz
bGVlcCgxNSAqIDEwMDApOwogCisJLyogTmVnYXRpdmUgbnVtYmVycyBtZWFucyB0byBub3Qg
dXNlIGEgRGlTRXFDIHN3aXRjaCAqLworCWlmIChwYXJtcy0+cC5zYXRfbnVtYmVyID49IDAp
CisJewogCWlmICghdCkKIAkJcmMgPSBkdmJzYXRfZGlzZXFjX3dyaXRlX3RvX3BvcnRfZ3Jv
dXAocGFybXMsICZjbWQsIGhpZ2hfYmFuZCwKIAkJCQkJCQlwb2xfdiwgc2F0X251bWJlcik7
CkBAIC01NzgsNiArNTc3LDcgQEAgc3RhdGljIGludCBkdmJzYXRfZGlzZXFjX3NldF9pbnB1
dChzdHJ1Y3QgZHZiX3Y1X2ZlX3Bhcm1zX3ByaXYgKnBhcm1zLAogCQkJcmV0dXJuIHJjOwog
CX0KIAl1c2xlZXAoMTUgKiAxMDAwKTsKKwl9CiAKIAlyYyA9IGR2Yl9mZV9zZWNfdG9uZSgm
cGFybXMtPnAsIHRvbmVfb24gPyBTRUNfVE9ORV9PTiA6IFNFQ19UT05FX09GRik7CiAKLS0g
CjIuMTMuNgoK
--------------C66209FDFC4922966214FF93
Content-Type: text/plain; charset=UTF-8;
 name="0004-Fix-indention-from-last-commit.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0004-Fix-indention-from-last-commit.patch"

RnJvbSBjNzAwZTNkYjBjODU1YTI2NzViMzQwZTFlZTE2NDY2NzhiMTliY2M2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYWtzeW0gVmVyZW1leWVua28gPHZlcmVtQG0xLnR2
PgpEYXRlOiBGcmksIDI0IE5vdiAyMDE3IDA5OjAyOjI2ICswMTAwClN1YmplY3Q6IFtQQVRD
SCA0LzRdIEZpeCBpbmRlbnRpb24gZnJvbSBsYXN0IGNvbW1pdAoKLS0tCiBsaWIvbGliZHZi
djUvZHZiLXNhdC5jIHwgMzggKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0t
LS0KIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAxOSBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9saWIvbGliZHZidjUvZHZiLXNhdC5jIGIvbGliL2xpYmR2YnY1L2R2
Yi1zYXQuYwppbmRleCA4YjJmY2Y3ZC4uODM4M2NkZjcgMTAwNjQ0Ci0tLSBhL2xpYi9saWJk
dmJ2NS9kdmItc2F0LmMKKysrIGIvbGliL2xpYmR2YnY1L2R2Yi1zYXQuYwpAQCAtNTU3LDI2
ICs1NTcsMjYgQEAgc3RhdGljIGludCBkdmJzYXRfZGlzZXFjX3NldF9pbnB1dChzdHJ1Y3Qg
ZHZiX3Y1X2ZlX3Bhcm1zX3ByaXYgKnBhcm1zLAogCS8qIE5lZ2F0aXZlIG51bWJlcnMgbWVh
bnMgdG8gbm90IHVzZSBhIERpU0VxQyBzd2l0Y2ggKi8KIAlpZiAocGFybXMtPnAuc2F0X251
bWJlciA+PSAwKQogCXsKLQlpZiAoIXQpCi0JCXJjID0gZHZic2F0X2Rpc2VxY193cml0ZV90
b19wb3J0X2dyb3VwKHBhcm1zLCAmY21kLCBoaWdoX2JhbmQsCi0JCQkJCQkJcG9sX3YsIHNh
dF9udW1iZXIpOwotCWVsc2UKLQkJcmMgPSBkdmJzYXRfc2NyX29kdV9jaGFubmVsX2NoYW5n
ZShwYXJtcywgJmNtZCwgaGlnaF9iYW5kLAotCQkJCQkJCXBvbF92LCBzYXRfbnVtYmVyLCB0
KTsKLQotCWlmIChyYykgewotCQlkdmJfbG9nZXJyKF8oInNlbmRpbmcgZGlzZXEgZmFpbGVk
IikpOwotCQlyZXR1cm4gcmM7Ci0JfQotCXVzbGVlcCgoMTUgKyBwYXJtcy0+cC5kaXNlcWNf
d2FpdCkgKiAxMDAwKTsKLQotCS8qIG1pbmlEaVNFcUMvVG9uZWJ1cnN0IGNvbW1hbmRzIGFy
ZSBkZWZpbmVkIG9ubHkgZm9yIHVwIHRvIDIgc2F0dGVsaXRlcyAqLwotCWlmIChwYXJtcy0+
cC5zYXRfbnVtYmVyIDwgMikgewotCQlyYyA9IGR2Yl9mZV9kaXNlcWNfYnVyc3QoJnBhcm1z
LT5wLCBwYXJtcy0+cC5zYXRfbnVtYmVyKTsKLQkJaWYgKHJjKQorCQlpZiAoIXQpCisJCQly
YyA9IGR2YnNhdF9kaXNlcWNfd3JpdGVfdG9fcG9ydF9ncm91cChwYXJtcywgJmNtZCwgaGln
aF9iYW5kLAorCQkJCQkJCQlwb2xfdiwgc2F0X251bWJlcik7CisJCWVsc2UKKwkJCXJjID0g
ZHZic2F0X3Njcl9vZHVfY2hhbm5lbF9jaGFuZ2UocGFybXMsICZjbWQsIGhpZ2hfYmFuZCwK
KwkJCQkJCQkJcG9sX3YsIHNhdF9udW1iZXIsIHQpOworCisJCWlmIChyYykgeworCQkJZHZi
X2xvZ2VycihfKCJzZW5kaW5nIGRpc2VxIGZhaWxlZCIpKTsKIAkJCXJldHVybiByYzsKLQl9
Ci0JdXNsZWVwKDE1ICogMTAwMCk7CisJCX0KKwkJdXNsZWVwKCgxNSArIHBhcm1zLT5wLmRp
c2VxY193YWl0KSAqIDEwMDApOworCisJCS8qIG1pbmlEaVNFcUMvVG9uZWJ1cnN0IGNvbW1h
bmRzIGFyZSBkZWZpbmVkIG9ubHkgZm9yIHVwIHRvIDIgc2F0dGVsaXRlcyAqLworCQlpZiAo
cGFybXMtPnAuc2F0X251bWJlciA8IDIpIHsKKwkJCXJjID0gZHZiX2ZlX2Rpc2VxY19idXJz
dCgmcGFybXMtPnAsIHBhcm1zLT5wLnNhdF9udW1iZXIpOworCQkJaWYgKHJjKQorCQkJCXJl
dHVybiByYzsKKwkJfQorCQl1c2xlZXAoMTUgKiAxMDAwKTsKIAl9CiAKIAlyYyA9IGR2Yl9m
ZV9zZWNfdG9uZSgmcGFybXMtPnAsIHRvbmVfb24gPyBTRUNfVE9ORV9PTiA6IFNFQ19UT05F
X09GRik7Ci0tIAoyLjEzLjYKCg==
--------------C66209FDFC4922966214FF93--
