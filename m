Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F946C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 10:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D944D218A3
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 10:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sXvPfL2q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbfA3Kc1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:32:27 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:42030 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730703AbfA3Kc0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 05:32:26 -0500
Received: by mail-wr1-f54.google.com with SMTP id q18so25405675wrx.9;
        Wed, 30 Jan 2019 02:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=+rnZqE4S60seD2FdTfpbyFltki4Zf8ZNAwLWaQqbIqo=;
        b=sXvPfL2qysmFO/yB/3ggIuVflSH1fB1v28iRpLWCPEszYLZ3bMWCYP5MGwSCM6EhAQ
         1gWywnnqX2pbrMhwAPEp8Bt6tMR3B0SKB0ih0fkqSjOxA6Gb3gMhU1Rp9/ZS5B5s9NoQ
         1t+NPu/IZ5HmdryY8wP6D/YW4SXWbf0XOIpyIJS9zqeWRk3DTYdfzIIXwSBogYO11FBO
         Bu5uar3uBN5OzToujXRfGWYHIgGyHL8qnTv54AzTfOvbA3uDZ5cjKJnO8xTcgfeOLEHg
         RAo6lZIkUW6vW4g9BJBAcdBuiB0W+c2rQI0bK8iIMJU3SZNd7i/LQ9RudQm4mWg0B+A5
         EGyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+rnZqE4S60seD2FdTfpbyFltki4Zf8ZNAwLWaQqbIqo=;
        b=JqegzLCW2qyB6NjUol9jW3ltMr+xUf/uZMw7l4BOrpXCAzb3DV5S4YMV6rZk1Dg/7h
         oVxgshMUURby88/Njuj92oPEIrAZExm2Kcdsl9OVD348lDD9ZjyulHjaq6s8HwjgK4CG
         dqYjPgFxxMB0vgV3wzWuA94kNdXrq5IVjpEgOkmeEG8WyUvA1nYdPi23NyACqf487xPy
         OyvcXeK7UDNLmPfgtAhPqi8OdH5BXrqXRz6el32hGTpTqdOJ/8Cddij0Sv2dIl0WsI5L
         1xph62x8pN6zcvJ78zVVCGYoQ5tNRUAixR9wpdK6K7qJntDuaY+ykRHZntW4m7TSr5vM
         m8QA==
X-Gm-Message-State: AHQUAub0hq/4WVye2+EpyWwEJ/FbSQdUYmVWJtUUvW3HJ3qadDmNfkxC
        8cb/rbhJyQTUNOmLSK96pI+14Q6eMVHmAcYEq1M=
X-Google-Smtp-Source: AHgI3IZXKf7iknRdsdV7+Z22dFJncrcJQryO2ybsB9eW2KfMW2xc0x6NWordqnDDck7+QWAUzfjLyPm+VsrJm8oqsyk=
X-Received: by 2002:adf:80a9:: with SMTP id 38mr15146737wrl.137.1548844343571;
 Wed, 30 Jan 2019 02:32:23 -0800 (PST)
MIME-Version: 1.0
From:   Gonsolo <gonsolo@gmail.com>
Date:   Wed, 30 Jan 2019 11:32:12 +0100
Message-ID: <CANL0fFSGG_+R2zbf-9MxVLJMTMgc+-fwSoLCqS1qc+jWo-zNLA@mail.gmail.com>
Subject: DVB-T2 Stick
To:     crope@iki.fi, linux-media@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e95c900580aa6c6e"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

--000000000000e95c900580aa6c6e
Content-Type: text/plain; charset="UTF-8"

Hi!

The following patch adds support for the Logilink VG0022A DVB-T2 stick.
After patching and building the kernel it shows up with lsusb and I
used w_scan to scan for channels and vlc for watching.
The original patches were from Andreas Kemnade.
The only thing that doesn't work is wake up after standby.

Do you think you can apply this patch?

Thanks
-- 
g

--000000000000e95c900580aa6c6e
Content-Type: text/x-patch; charset="US-ASCII"; name="dvb.patch"
Content-Disposition: attachment; filename="dvb.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jrj1wni70>
X-Attachment-Id: f_jrj1wni70

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdHVuZXJzL3NpMjE1Ny5jIGIvZHJpdmVycy9tZWRp
YS90dW5lcnMvc2kyMTU3LmMKaW5kZXggZDM4OWYxZmMyMzdhLi4xZjkyMzQxOGZmMTAgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdHVuZXJzL3NpMjE1Ny5jCisrKyBiL2RyaXZlcnMvbWVkaWEv
dHVuZXJzL3NpMjE1Ny5jCkBAIC04NCw3ICs4NCw3IEBAIHN0YXRpYyBpbnQgc2kyMTU3X2luaXQo
c3RydWN0IGR2Yl9mcm9udGVuZCAqZmUpCiAJc3RydWN0IHNpMjE1N19jbWQgY21kOwogCWNvbnN0
IHN0cnVjdCBmaXJtd2FyZSAqZnc7CiAJY29uc3QgY2hhciAqZndfbmFtZTsKLQl1bnNpZ25lZCBp
bnQgdWl0bXAsIGNoaXBfaWQ7CisgICAgICAgIHVuc2lnbmVkIGludCB1aXRtcDsKIAogCWRldl9k
YmcoJmNsaWVudC0+ZGV2LCAiXG4iKTsKIApAQCAtMTI2LDcgKzEyNiw3IEBAIHN0YXRpYyBpbnQg
c2kyMTU3X2luaXQoc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUpCiAJCWlmIChyZXQpCiAJCQlnb3Rv
IGVycjsKIAl9Ci0KKyNpZiAwCiAJLyogcXVlcnkgY2hpcCByZXZpc2lvbiAqLwogCW1lbWNweShj
bWQuYXJncywgIlx4MDIiLCAxKTsKIAljbWQud2xlbiA9IDE7CkBAIC0xNDYsNiArMTQ2LDggQEAg
c3RhdGljIGludCBzaTIxNTdfaW5pdChzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSkKIAkjZGVmaW5l
IFNJMjE0MV9BMTAgKCdBJyA8PCAyNCB8IDQxIDw8IDE2IHwgJzEnIDw8IDggfCAnMCcgPDwgMCkK
IAogCXN3aXRjaCAoY2hpcF9pZCkgeworI2VuZGlmCisgICAgICAgIHN3aXRjaCAoZGV2LT5jaGlw
X2lkKSB7CiAJY2FzZSBTSTIxNThfQTIwOgogCWNhc2UgU0kyMTQ4X0EyMDoKIAkJZndfbmFtZSA9
IFNJMjE1OF9BMjBfRklSTVdBUkU7CkBAIC0xNjYsOSArMTY4LDkgQEAgc3RhdGljIGludCBzaTIx
NTdfaW5pdChzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSkKIAkJZ290byBlcnI7CiAJfQogCi0JZGV2
X2luZm8oJmNsaWVudC0+ZGV2LCAiZm91bmQgYSAnU2lsaWNvbiBMYWJzIFNpMjElZC0lYyVjJWMn
XG4iLAotCQkJY21kLmFyZ3NbMl0sIGNtZC5hcmdzWzFdLCBjbWQuYXJnc1szXSwgY21kLmFyZ3Nb
NF0pOwotCisvLwlkZXZfaW5mbygmY2xpZW50LT5kZXYsICJmb3VuZCBhICdTaWxpY29uIExhYnMg
U2kyMSVkLSVjJWMlYydcbiIsCisvLwkJCWNtZC5hcmdzWzJdLCBjbWQuYXJnc1sxXSwgY21kLmFy
Z3NbM10sIGNtZC5hcmdzWzRdKTsKKy8vCiAJaWYgKGZ3X25hbWUgPT0gTlVMTCkKIAkJZ290byBz
a2lwX2Z3X2Rvd25sb2FkOwogCkBAIC00NjEsNiArNDYzLDM4IEBAIHN0YXRpYyBpbnQgc2kyMTU3
X3Byb2JlKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsCiAJbWVtY3B5KCZmZS0+b3BzLnR1bmVy
X29wcywgJnNpMjE1N19vcHMsIHNpemVvZihzdHJ1Y3QgZHZiX3R1bmVyX29wcykpOwogCWZlLT50
dW5lcl9wcml2ID0gY2xpZW50OwogCisgICAgICAgLyogcG93ZXIgdXAgKi8KKyAgICAgICBpZiAo
ZGV2LT5jaGlwdHlwZSA9PSBTSTIxNTdfQ0hJUFRZUEVfU0kyMTQ2KSB7CisgICAgICAgICAgICAg
ICBtZW1jcHkoY21kLmFyZ3MsICJceGMwXHgwNVx4MDFceDAwXHgwMFx4MGJceDAwXHgwMFx4MDEi
LCA5KTsKKyAgICAgICAgICAgICAgIGNtZC53bGVuID0gOTsKKyAgICAgICB9IGVsc2UgeworICAg
ICAgICAgICAgICAgbWVtY3B5KGNtZC5hcmdzLAorICAgICAgICAgICAgICAgIlx4YzBceDAwXHgw
Y1x4MDBceDAwXHgwMVx4MDFceDAxXHgwMVx4MDFceDAxXHgwMlx4MDBceDAwXHgwMSIsCisgICAg
ICAgICAgICAgICAxNSk7CisgICAgICAgICAgICAgICBjbWQud2xlbiA9IDE1OworICAgICAgIH0K
KyAgICAgICBjbWQucmxlbiA9IDE7CisgICAgICAgcmV0ID0gc2kyMTU3X2NtZF9leGVjdXRlKGNs
aWVudCwgJmNtZCk7CisgICAgICAgaWYgKHJldCkKKyAgICAgICAgICAgICAgIGdvdG8gZXJyOwor
ICAgICAgIC8qIHF1ZXJ5IGNoaXAgcmV2aXNpb24gKi8KKyAgICAgICAvKiBoYWNrOiBkbyBpdCBo
ZXJlIGJlY2F1c2UgYWZ0ZXIgdGhlIHNpMjE2OCBnZXRzIDAxMDEsIGNvbW1hbmRzIHdpbGwKKyAg
ICAgICAgKiBzdGlsbCBiZSBleGVjdXRlZCBoZXJlIGJ1dCBubyByZXN1bHQKKyAgICAgICAgKi8K
KyAgICAgICBtZW1jcHkoY21kLmFyZ3MsICJceDAyIiwgMSk7CisgICAgICAgY21kLndsZW4gPSAx
OworICAgICAgIGNtZC5ybGVuID0gMTM7CisgICAgICAgcmV0ID0gc2kyMTU3X2NtZF9leGVjdXRl
KGNsaWVudCwgJmNtZCk7CisgICAgICAgaWYgKHJldCkKKyAgICAgICAgICAgICAgIGdvdG8gZXJy
X2tmcmVlOworICAgICAgIGRldi0+Y2hpcF9pZCA9IGNtZC5hcmdzWzFdIDw8IDI0IHwKKyAgICAg
ICAgICAgICAgICAgICAgICAgY21kLmFyZ3NbMl0gPDwgMTYgfAorICAgICAgICAgICAgICAgICAg
ICAgICBjbWQuYXJnc1szXSA8PCA4IHwKKyAgICAgICAgICAgICAgICAgICAgICAgY21kLmFyZ3Nb
NF0gPDwgMDsKKyAgICAgICBkZXZfaW5mbygmY2xpZW50LT5kZXYsICJmb3VuZCBhICdTaWxpY29u
IExhYnMgU2kyMSVkLSVjJWMlYydcbiIsCisgICAgICAgICAgICAgICAgICAgICAgIGNtZC5hcmdz
WzJdLCBjbWQuYXJnc1sxXSwgY21kLmFyZ3NbM10sIGNtZC5hcmdzWzRdKTsKKyAKKwogI2lmZGVm
IENPTkZJR19NRURJQV9DT05UUk9MTEVSCiAJaWYgKGNmZy0+bWRldikgewogCQlkZXYtPm1kZXYg
PSBjZmctPm1kZXY7CmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3R1bmVycy9zaTIxNTdfcHJp
di5oIGIvZHJpdmVycy9tZWRpYS90dW5lcnMvc2kyMTU3X3ByaXYuaAppbmRleCA1MGY4NjMwMGQ5
NjUuLjM1OTIxNDZjZjQ5YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS90dW5lcnMvc2kyMTU3
X3ByaXYuaAorKysgYi9kcml2ZXJzL21lZGlhL3R1bmVycy9zaTIxNTdfcHJpdi5oCkBAIC0zNyw2
ICszNyw3IEBAIHN0cnVjdCBzaTIxNTdfZGV2IHsKIAl1OCBjaGlwdHlwZTsKIAl1OCBpZl9wb3J0
OwogCXUzMiBpZl9mcmVxdWVuY3k7CisgICAgICAgIHUzMiBjaGlwX2lkOwogCXN0cnVjdCBkZWxh
eWVkX3dvcmsgc3RhdF93b3JrOwogCiAjaWYgZGVmaW5lZChDT05GSUdfTUVESUFfQ09OVFJPTExF
UikKQEAgLTUxLDYgKzUyLDEzIEBAIHN0cnVjdCBzaTIxNTdfZGV2IHsKICNkZWZpbmUgU0kyMTU3
X0NISVBUWVBFX1NJMjE0NiAxCiAjZGVmaW5lIFNJMjE1N19DSElQVFlQRV9TSTIxNDEgMgogCisj
ZGVmaW5lIFNJMjE1OF9BMjAgKCdBJyA8PCAyNCB8IDU4IDw8IDE2IHwgJzInIDw8IDggfCAnMCcg
PDwgMCkKKyNkZWZpbmUgU0kyMTQ4X0EyMCAoJ0EnIDw8IDI0IHwgNDggPDwgMTYgfCAnMicgPDwg
OCB8ICcwJyA8PCAwKQorI2RlZmluZSBTSTIxNTdfQTMwICgnQScgPDwgMjQgfCA1NyA8PCAxNiB8
ICczJyA8PCA4IHwgJzAnIDw8IDApCisjZGVmaW5lIFNJMjE0N19BMzAgKCdBJyA8PCAyNCB8IDQ3
IDw8IDE2IHwgJzMnIDw8IDggfCAnMCcgPDwgMCkKKyNkZWZpbmUgU0kyMTQ2X0ExMCAoJ0EnIDw8
IDI0IHwgNDYgPDwgMTYgfCAnMScgPDwgOCB8ICcwJyA8PCAwKQorI2RlZmluZSBTSTIxNDFfQTEw
ICgnQScgPDwgMjQgfCA0MSA8PCAxNiB8ICcxJyA8PCA4IHwgJzAnIDw8IDApCisKIC8qIGZpcm13
YXJlIGNvbW1hbmQgc3RydWN0ICovCiAjZGVmaW5lIFNJMjE1N19BUkdMRU4gICAgICAzMAogc3Ry
dWN0IHNpMjE1N19jbWQgewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS91c2IvZHZiLXVzYi12
Mi9hZjkwMzUuYyBiL2RyaXZlcnMvbWVkaWEvdXNiL2R2Yi11c2ItdjIvYWY5MDM1LmMKaW5kZXgg
ODBkM2JkM2EwZjI0Li4yOGIwNzNiZmUwZDQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdXNi
L2R2Yi11c2ItdjIvYWY5MDM1LmMKKysrIGIvZHJpdmVycy9tZWRpYS91c2IvZHZiLXVzYi12Mi9h
ZjkwMzUuYwpAQCAtMTIxNiw4ICsxMjE2LDUxIEBAIHN0YXRpYyBpbnQgaXQ5MzB4X2Zyb250ZW5k
X2F0dGFjaChzdHJ1Y3QgZHZiX3VzYl9hZGFwdGVyICphZGFwKQogCXN0cnVjdCBzaTIxNjhfY29u
ZmlnIHNpMjE2OF9jb25maWc7CiAJc3RydWN0IGkyY19hZGFwdGVyICphZGFwdGVyOwogCi0JZGV2
X2RiZygmaW50Zi0+ZGV2LCAiYWRhcC0+aWQ9JWRcbiIsIGFkYXAtPmlkKTsKLQorCS8vZGV2X2Ri
ZygmaW50Zi0+ZGV2LCAiYWRhcC0+aWQ9JWRcbiIsIGFkYXAtPmlkKTsKKyAgICAgICBkZXZfZGJn
KCZpbnRmLT5kZXYsICIlcyAgYWRhcC0+aWQ9JWRcbiIsIF9fZnVuY19fLCBhZGFwLT5pZCk7CisK
KyAgICAgICAvKiBJMkMgbWFzdGVyIGJ1cyAyIGNsb2NrIHNwZWVkIDMwMGsgKi8KKyAgICAgICBy
ZXQgPSBhZjkwMzVfd3JfcmVnKGQsIDB4MDBmNmE3LCAweDA3KTsKKyAgICAgICBpZiAocmV0IDwg
MCkKKyAgICAgICAgICAgICAgIGdvdG8gZXJyOworCisgICAgICAgLyogSTJDIG1hc3RlciBidXMg
MSwzIGNsb2NrIHNwZWVkIDMwMGsgKi8KKyAgICAgICByZXQgPSBhZjkwMzVfd3JfcmVnKGQsIDB4
MDBmMTAzLCAweDA3KTsKKyAgICAgICBpZiAocmV0IDwgMCkKKyAgICAgICAgICAgICAgIGdvdG8g
ZXJyOworCisgICAgICAgLyogc2V0IGdwaW8xMSBsb3cgKi8KKyAgICAgICByZXQgPSBhZjkwMzVf
d3JfcmVnX21hc2soZCwgMHhkOGQ0LCAweDAxLCAweDAxKTsKKyAgICAgICBpZiAocmV0IDwgMCkK
KyAgICAgICAgICAgICAgIGdvdG8gZXJyOworCisgICAgICAgcmV0ID0gYWY5MDM1X3dyX3JlZ19t
YXNrKGQsIDB4ZDhkNSwgMHgwMSwgMHgwMSk7CisgICAgICAgaWYgKHJldCA8IDApCisgICAgICAg
ICAgICAgICBnb3RvIGVycjsKKworICAgICAgIHJldCA9IGFmOTAzNV93cl9yZWdfbWFzayhkLCAw
eGQ4ZDMsIDB4MDEsIDB4MDEpOworICAgICAgIGlmIChyZXQgPCAwKQorICAgICAgICAgICAgICAg
Z290byBlcnI7CisgCisgICAgICAgLyogVHVuZXIgZW5hYmxlIHVzaW5nIGdwaW90Ml9lbiwgZ3Bp
b3QyX29uIGFuZCBncGlvdDJfbyAocmVzZXQpICovCisgICAgICAgcmV0ID0gYWY5MDM1X3dyX3Jl
Z19tYXNrKGQsIDB4ZDhiOCwgMHgwMSwgMHgwMSk7CisgICAgICAgaWYgKHJldCA8IDApCisgICAg
ICAgICAgICAgICBnb3RvIGVycjsKKworICAgICAgIHJldCA9IGFmOTAzNV93cl9yZWdfbWFzayhk
LCAweGQ4YjksIDB4MDEsIDB4MDEpOworICAgICAgIGlmIChyZXQgPCAwKQorICAgICAgICAgICAg
ICAgZ290byBlcnI7CisKKyAgICAgICByZXQgPSBhZjkwMzVfd3JfcmVnX21hc2soZCwgMHhkOGI3
LCAweDAwLCAweDAxKTsKKyAgICAgICBpZiAocmV0IDwgMCkKKyAgICAgICAgICAgICAgIGdvdG8g
ZXJyOworCisgICAgICAgbXNsZWVwKDIwMCk7CisKKyAgICAgICByZXQgPSBhZjkwMzVfd3JfcmVn
X21hc2soZCwgMHhkOGI3LCAweDAxLCAweDAxKTsKKyAgICAgICBpZiAocmV0IDwgMCkKKyAgICAg
ICAgICAgICAgIGdvdG8gZXJyOworIAogCW1lbXNldCgmc2kyMTY4X2NvbmZpZywgMCwgc2l6ZW9m
KHNpMjE2OF9jb25maWcpKTsKIAlzaTIxNjhfY29uZmlnLmkyY19hZGFwdGVyID0gJmFkYXB0ZXI7
CiAJc2kyMTY4X2NvbmZpZy5mZSA9ICZhZGFwLT5mZVswXTsKQEAgLTIxMjgsNiArMjE3MSw4IEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBhZjkwMzVfaWRfdGFibGVbXSA9IHsK
IAkvKiBJVDkzMHggZGV2aWNlcyAqLwogCXsgRFZCX1VTQl9ERVZJQ0UoVVNCX1ZJRF9JVEVURUNI
LCBVU0JfUElEX0lURVRFQ0hfSVQ5MzAzLAogCQkmaXQ5MzB4X3Byb3BzLCAiSVRFIDkzMDMgR2Vu
ZXJpYyIsIE5VTEwpIH0sCisgICAgICAgIHsgRFZCX1VTQl9ERVZJQ0UoVVNCX1ZJRF9ERVhBVEVL
LCAweDAxMDAsCisgICAgICAgICAgICAgICAgJml0OTMweF9wcm9wcywgIkxvZ2lsaW5rIFZHMDAy
MkEiLCBOVUxMKSB9LAogCXsgfQogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUodXNiLCBhZjkwMzVf
aWRfdGFibGUpOwo=
--000000000000e95c900580aa6c6e--
