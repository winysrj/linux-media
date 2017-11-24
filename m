Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.m1stereo.tv ([91.244.124.37]:58849 "EHLO
        kazbek.m1stereo.tv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752935AbdKXKOG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 05:14:06 -0500
Received: from [10.1.5.65] (dev-3.internal.m1stereo.tv [10.1.5.65])
        by kazbek.m1stereo.tv (8.14.4/8.14.4) with ESMTP id vAO8fP1A023987
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 10:41:25 +0200
To: linux-media@vger.kernel.org
From: Maksym Veremeyenko <verem@m1stereo.tv>
Subject: [PATCH] Fix selecting satellite number 0
Message-ID: <c7546899-6333-72f2-68a9-76b52b946aab@m1stereo.tv>
Date: Fri, 24 Nov 2017 10:41:25 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------25FEEDE0A95502E231FFC210"
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------25FEEDE0A95502E231FFC210
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

attached patch fixing zapping to satellite #0

without it specifying -S 0 for *dvbv5-zap* does not work and sat_number 
remains a negative default value. as result, no settings where made
in *dvbsat_diseqc_set_input* ( 
https://git.linuxtv.org/v4l-utils.git/tree/lib/libdvbv5/dvb-sat.c#n526 )

please apply

-- 
Maksym Veremeyenko


--------------25FEEDE0A95502E231FFC210
Content-Type: text/plain; charset=UTF-8;
 name="0001-Fix-selecting-satellite-number-0.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-Fix-selecting-satellite-number-0.patch"

RnJvbSAxZWVjYmY5YjZkM2UxMWE3ZTc5YzYwMDRlM2RmM2IwMWJiNzM2Mzc4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYWtzeW0gVmVyZW1leWVua28gPHZlcmVtQG0xLnR2
PgpEYXRlOiBUaHUsIDIzIE5vdiAyMDE3IDEyOjU4OjQxICswMTAwClN1YmplY3Q6IFtQQVRD
SCAxLzRdIEZpeCBzZWxlY3Rpbmcgc2F0ZWxsaXRlIG51bWJlciAwCgotLS0KIHV0aWxzL2R2
Yi9kdmJ2NS16YXAuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL3V0aWxzL2R2Yi9kdmJ2NS16YXAuYyBiL3V0
aWxzL2R2Yi9kdmJ2NS16YXAuYwppbmRleCBhODg1MDBkMS4uMWI2ZGFiZDAgMTAwNjQ0Ci0t
LSBhL3V0aWxzL2R2Yi9kdmJ2NS16YXAuYworKysgYi91dGlscy9kdmIvZHZidjUtemFwLmMK
QEAgLTkzMCw3ICs5MzAsNyBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiAJ
CWdvdG8gZXJyOwogCWlmIChsbmIgPj0gMCkKIAkJcGFybXMtPmxuYiA9IGR2Yl9zYXRfZ2V0
X2xuYihsbmIpOwotCWlmIChhcmdzLnNhdF9udW1iZXIgPiAwKQorCWlmIChhcmdzLnNhdF9u
dW1iZXIgPj0gMCkKIAkJcGFybXMtPnNhdF9udW1iZXIgPSBhcmdzLnNhdF9udW1iZXI7CiAJ
cGFybXMtPmRpc2VxY193YWl0ID0gYXJncy5kaXNlcWNfd2FpdDsKIAlwYXJtcy0+ZnJlcV9i
cGYgPSBhcmdzLmZyZXFfYnBmOwotLSAKMi4xMy42Cgo=
--------------25FEEDE0A95502E231FFC210--
