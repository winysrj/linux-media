Return-path: <mchehab@gaivota>
Received: from blu0-omc2-s24.blu0.hotmail.com ([65.55.111.99]:4925 "EHLO
	blu0-omc2-s24.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759175Ab1EMCIi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 22:08:38 -0400
Message-ID: <BLU157-w5E482944CB2AA4A90A5E5D8880@phx.gbl>
Content-Type: multipart/mixed;
	boundary="_817f8ab8-5abf-4c04-a8ac-a5087675b283_"
From: Manoel PN <pinusdtv@hotmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>, <lgspn@hotmail.com>
Subject: [PATCH 2/4] Modifications to the driver mb86a20s
Date: Fri, 13 May 2011 05:08:36 +0300
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--_817f8ab8-5abf-4c04-a8ac-a5087675b283_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


This patch implements mb86a20s_read_snr and adds mb86a20s_read_ber and mb86=
a20s_read_ucblocks both without practical utility but that programs as dvbs=
noop need.


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>



 		 	   		  =

--_817f8ab8-5abf-4c04-a8ac-a5087675b283_
Content-Type: application/octet-stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="read_snr.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9tYjg2YTIwcy5jIGIvZHJp
dmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL21iODZhMjBzLmMKaW5kZXggMGY4NjdhNS4uMGRlNGFi
ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL21iODZhMjBzLmMKKysr
IGIvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL21iODZhMjBzLmMKQEAgLTQxMSw2ICs0MTEs
NTYgQEAgZXJyOgogCXJldHVybiByYzsKIH0KIAorc3RhdGljIGludCBtYjg2YTIwc19yZWFkX3Nu
cihzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSwgdTE2ICpzbnIpCit7CisJc3RydWN0IG1iODZhMjBz
X3N0YXRlICpzdGF0ZSA9IGZlLT5kZW1vZHVsYXRvcl9wcml2OworCWludCBpLCBjbnIsIHZhbCwg
dmFsMjsKKworCWZvciAoaSA9IDA7IGkgPCAzMDsgaSsrKSB7CisJCWlmIChtYjg2YTIwc19yZWFk
cmVnKHN0YXRlLCAweDBhKSA+PSAyKQorCQkJdmFsID0gbWI4NmEyMHNfcmVhZHJlZyhzdGF0ZSwg
MHg0NSk7IC8qIHJlYWQgY25yX2ZsYWcgKi8KKwkJZWxzZQorCQkJdmFsID0gLTE7CisJCWlmICh2
YWwgPiAwICYmICgodmFsID4+IDYpICYgMSkgIT0gMCkgeworCQkJdmFsMiA9IG1iODZhMjBzX3Jl
YWRyZWcoc3RhdGUsIDB4NDYpOworCQkJdmFsID0gbWI4NmEyMHNfcmVhZHJlZyhzdGF0ZSwgMHg0
Nyk7CisJCQlpZiAodmFsMiA+PTAgJiYgdmFsID49IDApIHsKKwkJCQljbnIgPSAodmFsMiA8PCAw
eDA4KSB8IHZhbDsKKwkJCQlpZiAoY25yID4gMHg0Y2MwKSBjbnIgPSAweDRjYzA7CisJCQkJdmFs
ID0gKCgweDRjYzAgLSBjbnIpICogMTAwMDApIC8gMHg0Y2MwOworCQkJCXZhbDIgPSAoNjU1MzUg
KiB2YWwpIC8gMTAwMDA7CisJCQkJKnNuciA9ICh1MTYpdmFsMjsKKwkJCQlkcHJpbnRrKCJzbnI9
JWksIGNucj0laSwgdmFsPSVpXG4iLCB2YWwyLCBjbnIsIHZhbCk7CisJCQkJLyogcmVzZXQgY25y
X2NvdW50ZXIgKi8KKwkJCQl2YWwgPSBtYjg2YTIwc19yZWFkcmVnKHN0YXRlLCAweDQ1KTsKKwkJ
CQlpZiAodmFsID49IDApCisJCQkJeworCQkJCQltYjg2YTIwc193cml0ZXJlZyhzdGF0ZSwgMHg0
NSwgdmFsIHwgMHgxMCk7CisJCQkJCW1zbGVlcCg1KTsKKwkJCQkJbWI4NmEyMHNfd3JpdGVyZWco
c3RhdGUsIDB4NDUsIHZhbCAmIDB4NmYpOyAvKiBGSVhNRTogb3IgMHhlZiA/ICovCisJCQkJfQor
CQkJCXJldHVybiAwOworCQkJfQorCQl9CisJCW1zbGVlcCgzMCk7CisJfQorCSpzbnIgPSAwOwor
CWRwcmludGsoIm5vIHNpZ25hbCFcbiIpOworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IG1i
ODZhMjBzX3JlYWRfYmVyKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLCB1MzIgKmJlcikKK3sKKwkq
YmVyID0gMDsKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBtYjg2YTIwc19yZWFkX3VjYmxv
Y2tzKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLCB1MzIgKnVjYmxvY2tzKQoreworCSp1Y2Jsb2Nr
cyA9IDA7CisJcmV0dXJuIDA7Cit9CisKIHN0YXRpYyBpbnQgbWI4NmEyMHNfcmVhZF9zaWduYWxf
c3RyZW5ndGgoc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsIHUxNiAqc3RyZW5ndGgpCiB7CiAJc3Ry
dWN0IG1iODZhMjBzX3N0YXRlICpzdGF0ZSA9IGZlLT5kZW1vZHVsYXRvcl9wcml2OwpAQCAtNjI3
LDYgKzY3Nyw5IEBAIHN0YXRpYyBzdHJ1Y3QgZHZiX2Zyb250ZW5kX29wcyBtYjg2YTIwc19vcHMg
PSB7CiAJLnJlbGVhc2UgPSBtYjg2YTIwc19yZWxlYXNlLAogCiAJLmluaXQgPSBtYjg2YTIwc19p
bml0ZmUsCisJLnJlYWRfc25yID0gbWI4NmEyMHNfcmVhZF9zbnIsCisJLnJlYWRfYmVyID0gbWI4
NmEyMHNfcmVhZF9iZXIsCisJLnJlYWRfdWNibG9ja3MgPSBtYjg2YTIwc19yZWFkX3VjYmxvY2tz
LAogCS5zZXRfZnJvbnRlbmQgPSBtYjg2YTIwc19zZXRfZnJvbnRlbmQsCiAJLmdldF9mcm9udGVu
ZCA9IG1iODZhMjBzX2dldF9mcm9udGVuZCwKIAkucmVhZF9zdGF0dXMgPSBtYjg2YTIwc19yZWFk
X3N0YXR1cywK

--_817f8ab8-5abf-4c04-a8ac-a5087675b283_--
