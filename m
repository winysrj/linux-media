Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:11673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0AQS1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 13:27:07 -0500
Received: by fg-out-1718.google.com with SMTP id 22so409909fge.1
        for <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 10:27:03 -0800 (PST)
Content-Type: multipart/mixed; boundary=----------LxuQk1UBlEnfcv9HWxFZFn
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Date: Sun, 17 Jan 2010 19:26:56 +0100
Subject: [RESEND PATCH] ir-kbd-i2c: Allow to disable Hauppauge filter through
 module parameter
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
From: "Samuel Rakitnican" <samuel.rakitnican@gmail.com>
Message-ID: <op.u6ov64og6dn9rq@denis-laptop.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------------LxuQk1UBlEnfcv9HWxFZFn
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 8bit

Some Hauppauge devices have id=0 so such devices won't work.
For such devices add a module parameter that allow to turn
off filtering.

Signed-off-by: Samuel Rakitničan <semiRocket@gmail.com>
-- 
Lorem ipsum
------------LxuQk1UBlEnfcv9HWxFZFn
Content-Disposition: attachment; filename=wintv-radio-ir.diff
Content-Type: application/octet-stream; name=wintv-radio-ir.diff
Content-Transfer-Encoding: Base64

ZGlmZiAtciA4MmJiYjNiZDBmMGEgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9p
ci1rYmQtaTJjLmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9pci1r
YmQtaTJjLmMJTW9uIEphbiAxMSAxMTo0NzozMyAyMDEwIC0wMjAwCisrKyBiL2xp
bnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vaXIta2JkLWkyYy5jCVNhdCBKYW4gMTYg
MTY6Mzk6MTQgMjAxMCArMDEwMApAQCAtNjEsNiArNjEsMTAgQEAKIG1vZHVsZV9w
YXJhbShoYXVwcGF1Z2UsIGludCwgMDY0NCk7ICAgIC8qIENob29zZSBIYXVwcGF1
Z2UgcmVtb3RlICovCiBNT0RVTEVfUEFSTV9ERVNDKGhhdXBwYXVnZSwgIlNwZWNp
ZnkgSGF1cHBhdWdlIHJlbW90ZTogMD1ibGFjaywgMT1ncmV5IChkZWZhdWx0cyB0
byAwKSIpOwogCitzdGF0aWMgaW50IGhhdXBfZmlsdGVyID0gMTsKK21vZHVsZV9w
YXJhbShoYXVwX2ZpbHRlciwgaW50LCAwNjQ0KTsKK01PRFVMRV9QQVJNX0RFU0Mo
aGF1cF9maWx0ZXIsICJIYXVwcGF1Z2UgZmlsdGVyIGZvciBvdGhlciByZW1vdGVz
LCBkZWZhdWx0IGlzIDEgKE9uKSIpOworCiAKICNkZWZpbmUgREVWTkFNRSAiaXIt
a2JkLWkyYyIKICNkZWZpbmUgZHByaW50ayhsZXZlbCwgZm10LCBhcmcuLi4pCWlm
IChkZWJ1ZyA+PSBsZXZlbCkgXApAQCAtOTYsMjQgKzEwMCwyNyBAQAogCWlmICgh
c3RhcnQpCiAJCS8qIG5vIGtleSBwcmVzc2VkICovCiAJCXJldHVybiAwOwotCS8q
Ci0JICogSGF1cHBhdWdlIHJlbW90ZXMgKGJsYWNrL3NpbHZlcikgYWx3YXlzIHVz
ZQotCSAqIHNwZWNpZmljIGRldmljZSBpZHMuIElmIHdlIGRvIG5vdCBmaWx0ZXIg
dGhlCi0JICogZGV2aWNlIGlkcyB0aGVuIG1lc3NhZ2VzIGRlc3RpbmVkIGZvciBk
ZXZpY2VzCi0JICogc3VjaCBhcyBUVnMgKGlkPTApIHdpbGwgZ2V0IHRocm91Z2gg
Y2F1c2luZwotCSAqIG1pcy1maXJlZCBldmVudHMuCi0JICoKLQkgKiBXZSBhbHNv
IGZpbHRlciBvdXQgaW52YWxpZCBrZXkgcHJlc3NlcyB3aGljaAotCSAqIHByb2R1
Y2UgYW5ub3lpbmcgZGVidWcgbG9nIGVudHJpZXMuCi0JICovCi0JaXJjb2RlPSAo
c3RhcnQgPDwgMTIpIHwgKHRvZ2dsZSA8PCAxMSkgfCAoZGV2IDw8IDYpIHwgY29k
ZTsKLQlpZiAoKGlyY29kZSAmIDB4MWZmZik9PTB4MWZmZikKLQkJLyogaW52YWxp
ZCBrZXkgcHJlc3MgKi8KLQkJcmV0dXJuIDA7CiAKLQlpZiAoZGV2IT0weDFlICYm
IGRldiE9MHgxZikKLQkJLyogbm90IGEgaGF1cHBhdWdlIHJlbW90ZSAqLwotCQly
ZXR1cm4gMDsKKwlpZiAoaGF1cF9maWx0ZXIgIT0gMCkgeworCQkvKgorCQkgKiBI
YXVwcGF1Z2UgcmVtb3RlcyAoYmxhY2svc2lsdmVyKSBhbHdheXMgdXNlCisJCSAq
IHNwZWNpZmljIGRldmljZSBpZHMuIElmIHdlIGRvIG5vdCBmaWx0ZXIgdGhlCisJ
CSAqIGRldmljZSBpZHMgdGhlbiBtZXNzYWdlcyBkZXN0aW5lZCBmb3IgZGV2aWNl
cworCQkgKiBzdWNoIGFzIFRWcyAoaWQ9MCkgd2lsbCBnZXQgdGhyb3VnaCBjYXVz
aW5nCisJCSAqIG1pcy1maXJlZCBldmVudHMuCisJCSAqCisJCSAqIFdlIGFsc28g
ZmlsdGVyIG91dCBpbnZhbGlkIGtleSBwcmVzc2VzIHdoaWNoCisJCSAqIHByb2R1
Y2UgYW5ub3lpbmcgZGVidWcgbG9nIGVudHJpZXMuCisJCSAqLworCQlpcmNvZGUg
PSAoc3RhcnQgPDwgMTIpIHwgKHRvZ2dsZSA8PCAxMSkgfCAoZGV2IDw8IDYpIHwg
Y29kZTsKKwkJaWYgKChpcmNvZGUgJiAweDFmZmYpID09IDB4MWZmZikKKwkJCS8q
IGludmFsaWQga2V5IHByZXNzICovCisJCQlyZXR1cm4gMDsKKworCQlpZiAoZGV2
ICE9IDB4MWUgJiYgZGV2ICE9IDB4MWYpCisJCQkvKiBub3QgYSBoYXVwcGF1Z2Ug
cmVtb3RlICovCisJCQlyZXR1cm4gMDsKKwl9CiAKIAlpZiAoIXJhbmdlKQogCQlj
b2RlICs9IDY0Owo=

------------LxuQk1UBlEnfcv9HWxFZFn--

