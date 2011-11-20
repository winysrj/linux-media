Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59792 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1KTPAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 10:00:32 -0500
Received: by eye27 with SMTP id 27so4648267eye.19
        for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 07:00:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EC8F94F.8090800@redhat.com>
References: <CAKdnbx5_qfotsKh0-s+DN7skx-J2=1HRw-qZOw=3mUHCQFHo2g@mail.gmail.com>
 <4EC8F94F.8090800@redhat.com>
From: Eddi De Pieri <eddi@depieri.net>
Date: Sun, 20 Nov 2011 16:00:10 +0100
Message-ID: <CAKdnbx6Leux7+6h5FFRiay709ogwH6v34BCq=U7Qve8YwfA=VQ@mail.gmail.com>
Subject: Re: [PATCH] initial support for HAUPPAUGE HVR-930C again...
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d043c05ccd79fc804b22bd4fa
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f46d043c05ccd79fc804b22bd4fa
Content-Type: text/plain; charset=ISO-8859-1

Attached the patch for for get_firmware

Regards,

Eddi

On Sun, Nov 20, 2011 at 1:57 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 19-11-2011 13:37, Eddi De Pieri escreveu:
>> With this patch I try again to add initial support for HVR930C.
>>
>> Tested only DVB-T, since in Italy Analog service is stopped.
>>
>> Actually "scan -a0 -f1", find only about 50 channel while 400 should
>> be available.
>>
>> Signed-off-by: Eddi De Pieri <eddi@depieri.net>
>
> Tested here with DVB-C, using the Terratec firmware. It worked as expected:
> 213 channels scanned, tested a few non-encrypted ones, and it seems to be
> working as expected.
>
> It didn't work with the firmware used by ddbrigde driver (the one that get_dvb_firmware
> script is capable of retrieving).
>
>>
>> Regards
>>
>> Eddi
>
>

--f46d043c05ccd79fc804b22bd4fa
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
--f46d043c05ccd79fc804b22bd4fa--
