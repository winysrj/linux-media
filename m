Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42760 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1KUKoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 05:44:14 -0500
Received: by wwe3 with SMTP id 3so5288042wwe.1
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 02:44:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKdnbx6Leux7+6h5FFRiay709ogwH6v34BCq=U7Qve8YwfA=VQ@mail.gmail.com>
References: <CAKdnbx5_qfotsKh0-s+DN7skx-J2=1HRw-qZOw=3mUHCQFHo2g@mail.gmail.com>
 <4EC8F94F.8090800@redhat.com> <CAKdnbx6Leux7+6h5FFRiay709ogwH6v34BCq=U7Qve8YwfA=VQ@mail.gmail.com>
From: Eddi De Pieri <eddi@depieri.net>
Date: Mon, 21 Nov 2011 11:43:52 +0100
Message-ID: <CAKdnbx5XkDcCkbjYuEWP5wXG0yQFgqLhAuaJGW-v7C7oGCSG4Q@mail.gmail.com>
Subject: Re: [PATCH] initial support for HAUPPAUGE HVR-930C again...
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174c3d8c18cc1b04b23c5e56
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015174c3d8c18cc1b04b23c5e56
Content-Type: text/plain; charset=ISO-8859-1

Attached the patch for for get_firmware

Signed-off-by: Eddi De Pieri <eddi@depieri.net>

Regards,

Eddi

--0015174c3d8c18cc1b04b23c5e56
Content-Type: text/x-patch; charset=US-ASCII; name="hauppauge-hvr930c_getfw.patch"
Content-Disposition: attachment; filename="hauppauge-hvr930c_getfw.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gv86b1sx0

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZHZiL2dldF9kdmJfZmlybXdhcmUgYi9Eb2N1bWVu
dGF0aW9uL2R2Yi9nZXRfZHZiX2Zpcm13YXJlCmluZGV4IGM0NjZmNTguLjUwM2Q3MGYgMTAwNzU1
Ci0tLSBhL0RvY3VtZW50YXRpb24vZHZiL2dldF9kdmJfZmlybXdhcmUKKysrIGIvRG9jdW1lbnRh
dGlvbi9kdmIvZ2V0X2R2Yl9maXJtd2FyZQpAQCAtMjcsNyArMjcsNyBAQCB1c2UgSU86OkhhbmRs
ZTsKIAkJIm9yNTEyMTEiLCAib3I1MTEzMl9xYW0iLCAib3I1MTEzMl92c2IiLCAiYmx1ZWJpcmQi
LAogCQkib3BlcmExIiwgImN4MjMxeHgiLCAiY3gxOCIsICJjeDIzODg1IiwgInB2cnVzYjIiLCAi
bXBjNzE4IiwKIAkJImFmOTAxNSIsICJuZ2VuZSIsICJhejYwMjciLCAibG1lMjUxMF9sZyIsICJs
bWUyNTEwY19zNzM5NSIsCi0JCSJsbWUyNTEwY19zNzM5NV9vbGQiLCAiZHJ4ayIsICJkcnhrX3Rl
cnJhdGVjX2g1Iik7CisJCSJsbWUyNTEwY19zNzM5NV9vbGQiLCAiZHJ4ayIsICJkcnhrX2hhdXBw
YXVnZV9odnI5MzBjIiwgImRyeGtfdGVycmF0ZWNfaDUiKTsKIAogIyBDaGVjayBhcmdzCiBzeW50
YXgoKSBpZiAoc2NhbGFyKEBBUkdWKSAhPSAxKTsKQEAgLTY1Miw2ICs2NTIsMjQgQEAgc3ViIGRy
eGsgewogICAgICIkZndmaWxlIgogfQogCitzdWIgZHJ4a19oYXVwcGF1Z2VfaHZyOTMwYyB7Cisg
ICAgbXkgJHVybCA9ICJodHRwOi8vd3d3LndpbnR2Y2QuY28udWsvZHJpdmVycy8iOworICAgIG15
ICR6aXBmaWxlID0gIkhWUi05eDBfNV8xMF8zMjVfMjgxNTNfU0lHTkVELnppcCI7CisgICAgbXkg
JGhhc2ggPSAiODNhYjgyZTdlOTQ4MGVjOGJmMWFlMDE1NWNhNjNjODgiOworICAgIG15ICR0bXBk
aXIgPSB0ZW1wZGlyKERJUiA9PiAiL3RtcCIsIENMRUFOVVAgPT4gMSk7CisgICAgbXkgJGRydmZp
bGUgPSAiSFZSLTkwMC9lbU9FTS5zeXMiOworICAgIG15ICRmd2ZpbGUgPSAiZHZiLXVzYi1oYXVw
cGF1Z2UtaHZyOTMwYy1kcnhrLmZ3IjsKKworICAgIGNoZWNrc3RhbmRhcmQoKTsKKworICAgIHdn
ZXRmaWxlKCR6aXBmaWxlLCAkdXJsIC4gJHppcGZpbGUpOworICAgIHZlcmlmeSgkemlwZmlsZSwg
JGhhc2gpOworICAgIHVuemlwKCR6aXBmaWxlLCAkdG1wZGlyKTsKKyAgICBleHRyYWN0KCIkdG1w
ZGlyLyRkcnZmaWxlIiwgMHgxMTdiMCwgNDI2OTIsICIkZndmaWxlIik7CisKKyAgICAiJGZ3Zmls
ZSIKK30KKwogc3ViIGRyeGtfdGVycmF0ZWNfaDUgewogICAgIG15ICR1cmwgPSAiaHR0cDovL3d3
dy5saW51eHR2Lm9yZy9kb3dubG9hZHMvZmlybXdhcmUvIjsKICAgICBteSAkaGFzaCA9ICIxOTAw
MGRhZGE4ZTI3NDExNjJjY2M1MGNjOTFmYTdmMSI7Cg==
--0015174c3d8c18cc1b04b23c5e56--
