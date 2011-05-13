Return-path: <mchehab@gaivota>
Received: from blu0-omc2-s32.blu0.hotmail.com ([65.55.111.107]:26395 "EHLO
	blu0-omc2-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932353Ab1EMCN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 22:13:59 -0400
Message-ID: <BLU157-w51A0D0CDE5F2B0061ACA23D8880@phx.gbl>
Content-Type: multipart/mixed;
	boundary="_ce9c3536-9dc7-415a-95ea-3e6177f3851f_"
From: Manoel PN <pinusdtv@hotmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>, <lgspn@hotmail.com>
Subject: =?windows-1256?Q?[PATCH_4/4?= =?windows-1256?Q?]_Modifica?=
 =?windows-1256?Q?tions_to_t?= =?windows-1256?Q?he_driver_?=
 =?windows-1256?Q?mb86a20s=FE=FE?=
Date: Fri, 13 May 2011 05:13:58 +0300
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--_ce9c3536-9dc7-415a-95ea-3e6177f3851f_
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit



This patch implement changes to the function mb86a20s_read_signal_strength.

The original function, binary search, does not work with device dtb08.

I would like to know if this function works.


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>


 		 	   		  
--_ce9c3536-9dc7-415a-95ea-3e6177f3851f_
Content-Type: application/octet-stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="signal_strength.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9tYjg2YTIwcy5jIGIvZHJp
dmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL21iODZhMjBzLmMKaW5kZXggMGY4NjdhNS4uOGYzOWRh
NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL21iODZhMjBzLmMKKysr
IGIvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL21iODZhMjBzLmMKQEAgLTQxNCw2ICs0MTQs
MTIgQEAgZXJyOgogc3RhdGljIGludCBtYjg2YTIwc19yZWFkX3NpZ25hbF9zdHJlbmd0aChzdHJ1
Y3QgZHZiX2Zyb250ZW5kICpmZSwgdTE2ICpzdHJlbmd0aCkKIHsKIAlzdHJ1Y3QgbWI4NmEyMHNf
c3RhdGUgKnN0YXRlID0gZmUtPmRlbW9kdWxhdG9yX3ByaXY7CisJaW50IGksIHZhbCwgdmFsMjsK
KworI2lmIDAKKwkvKgorCSAqIEJpbmFyeSBzZWFyY2ggZG9uJ3Qgd29yayB3aXRoIERUQjA4CisJ
ICovCiAJdW5zaWduZWQgcmZfbWF4LCByZl9taW4sIHJmOwogCXU4CSB2YWw7CiAKQEAgLTQ0Nyw2
ICs0NTMsMzAgQEAgc3RhdGljIGludCBtYjg2YTIwc19yZWFkX3NpZ25hbF9zdHJlbmd0aChzdHJ1
Y3QgZHZiX2Zyb250ZW5kICpmZSwgdTE2ICpzdHJlbmd0aCkKIAogCWlmIChmZS0+b3BzLmkyY19n
YXRlX2N0cmwpCiAJCWZlLT5vcHMuaTJjX2dhdGVfY3RybChmZSwgMSk7CisjZW5kaWYKKworCWRw
cmludGsoIlxuIik7CisKKwkqc3RyZW5ndGggPSAwOworCisJZm9yIChpID0gMDsgaSA8IDEwOyBp
KyspCisJeworCQl2YWwgPSBtYjg2YTIwc19yZWFkcmVnKHN0YXRlLCAweDBhKTsKKwkJaWYgKHZh
bCA+PSAyKSB7CisJCQltYjg2YTIwc193cml0ZXJlZyhzdGF0ZSwgMHgwNCwgMHgyNSk7CisJCQl2
YWwyID0gbWI4NmEyMHNfcmVhZHJlZyhzdGF0ZSwgMHgwNSk7CisJCQltYjg2YTIwc193cml0ZXJl
ZyhzdGF0ZSwgMHgwNCwgMHgyNik7CisJCQl2YWwgPSBtYjg2YTIwc19yZWFkcmVnKHN0YXRlLCAw
eDA1KTsKKwkJCWlmICh2YWwgPj0gMCAmJiB2YWwyID49IDApIHsKKwkJCQl2YWwgPSAodmFsMiA8
PCA4KSB8IHZhbDsKKwkJCQl2YWwyID0gKHZhbCAqIDB4MTAwMTAwKSA+PiAxNjsKKwkJCQlkcHJp
bnRrKCJzaWduYWwgc3RyZW5ndGggPSAlaVxuIiwgdmFsMik7CisJCQkJKnN0cmVuZ3RoID0gKHUx
Nil2YWwyOworCQkJCXJldHVybiAwOworCQkJfQorCQl9CisJCW1zbGVlcCgxMCk7CisJfQogCiAJ
cmV0dXJuIDA7CiB9Cg==

--_ce9c3536-9dc7-415a-95ea-3e6177f3851f_--
