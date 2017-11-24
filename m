Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.m1stereo.tv ([91.244.124.37]:58849 "EHLO
        kazbek.m1stereo.tv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752935AbdKXKNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 05:13:52 -0500
Received: from [10.1.5.65] (dev-3.internal.m1stereo.tv [10.1.5.65])
        by kazbek.m1stereo.tv (8.14.4/8.14.4) with ESMTP id vAO8hNmq024098
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 10:43:24 +0200
From: Maksym Veremeyenko <verem@m1stereo.tv>
Subject: [PATCH] Override sat_number by value from channel file if it not
 specified
To: linux-media@vger.kernel.org
Message-ID: <0dcf838d-2b23-842a-6f40-c96ca6f3c8ad@m1stereo.tv>
Date: Fri, 24 Nov 2017 10:43:23 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------DEC45303847DB99CE23EBA87"
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------DEC45303847DB99CE23EBA87
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

attached patch fix using SAT_NUMBER value from channel file.

please apply

-- 
Maksym Veremeyenko



--------------DEC45303847DB99CE23EBA87
Content-Type: text/plain; charset=UTF-8;
 name="0002-Override-sat_number-by-value-from-channel-file-if-it.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0002-Override-sat_number-by-value-from-channel-file-if-it.pa";
 filename*1="tch"

RnJvbSBmZTAxOTNmODExNWFkMjU2YWNmZDJiZTQyZjVmZWQwZDQ2NWRmZjU1IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYWtzeW0gVmVyZW1leWVua28gPHZlcmVtQG0xLnR2
PgpEYXRlOiBUaHUsIDIzIE5vdiAyMDE3IDE0OjE1OjI4ICswMTAwClN1YmplY3Q6IFtQQVRD
SCAyLzRdIE92ZXJyaWRlIHNhdF9udW1iZXIgYnkgdmFsdWUgZnJvbSBjaGFubmVsIGZpbGUg
aWYgaXQgbm90CiBzcGVjaWZpZWQKCi0tLQogdXRpbHMvZHZiL2R2YnY1LXphcC5jIHwgMyAr
KysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS91dGls
cy9kdmIvZHZidjUtemFwLmMgYi91dGlscy9kdmIvZHZidjUtemFwLmMKaW5kZXggMWI2ZGFi
ZDAuLjU1Njc3MzZkIDEwMDY0NAotLS0gYS91dGlscy9kdmIvZHZidjUtemFwLmMKKysrIGIv
dXRpbHMvZHZiL2R2YnY1LXphcC5jCkBAIC0yMjcsNiArMjI3LDkgQEAgc3RhdGljIGludCBw
YXJzZShzdHJ1Y3QgYXJndW1lbnRzICphcmdzLAogCQlwYXJtcy0+bG5iID0gZHZiX3NhdF9n
ZXRfbG5iKGxuYik7CiAJfQogCisJaWYgKHBhcm1zLT5zYXRfbnVtYmVyIDwgMCAmJiBlbnRy
eS0+c2F0X251bWJlciA+PSAwKQorCQlwYXJtcy0+c2F0X251bWJlciA9IGVudHJ5LT5zYXRf
bnVtYmVyOworCiAJaWYgKGVudHJ5LT52aWRlb19waWQpIHsKIAkJaWYgKGFyZ3MtPm5fdnBp
ZCA8IGVudHJ5LT52aWRlb19waWRfbGVuKQogCQkJKnZwaWQgPSBlbnRyeS0+dmlkZW9fcGlk
W2FyZ3MtPm5fdnBpZF07Ci0tIAoyLjEzLjYKCg==
--------------DEC45303847DB99CE23EBA87--
