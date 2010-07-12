Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62375 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab0GLXCM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 19:02:12 -0400
Received: by gyh4 with SMTP id 4so33690gyh.19
        for <linux-media@vger.kernel.org>; Mon, 12 Jul 2010 16:02:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100712132100.1b4072b9@tele>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele> <AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele> <AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
	<20100708121454.75db358c@tele> <AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
	<20100709200312.755e8069@tele> <AANLkTikxIJxuQiV_7PqPA5C6ZU5XhhmmQ3hAbIwWsrPT@mail.gmail.com>
	<20100710113616.1ed63ebc@tele> <AANLkTikrKBpRSI6wVdMO3tSYPhm1CECFGeNiyJdzTa03@mail.gmail.com>
	<20100711155008.1f8f583f@tele> <AANLkTinnNhJ-DoFWfU8U5NuTj_p48SefYzWWAxZqiUb-@mail.gmail.com>
	<20100712101802.08527e82@tele> <AANLkTinUHyTHt78ihMHy8dzz0kfPvUMBXKreRmuM-cYW@mail.gmail.com>
	<20100712132100.1b4072b9@tele>
From: Kyle Baker <kyleabaker@gmail.com>
Date: Mon, 12 Jul 2010 19:01:51 -0400
Message-ID: <AANLkTimku962Cm_7glThtq3X3jZiwmHSWOYzc2d3WLBl@mail.gmail.com>
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174c0e52228b7c048b38bed8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015174c0e52228b7c048b38bed8
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jul 12, 2010 at 7:21 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> Fine job! The register 02 is the GPIO register. It seems the audio does
> not work when the bit 0x04 is not set. I am working on the driver for
> the other webcams, but you may patch it yourself removing the register
> 02 settings at lines 1752, 2320 and 2321 of sonixj.c.

Thank you for your help. I've gotten this working for me by using the
following conditional to determine if the driver should run the code
that changes register 02 or not.

if (sd->sensor != SENSOR_OV7660)
	reg_w1(gspca_dev, 0x02, 0x62);

and

if (sd->sensor != SENSOR_OV7660) {
	reg_w1(gspca_dev, 0x02, reg2);
	reg_w1(gspca_dev, 0x02, reg2);
}

These do fix the audio problem,  but they may not be good for other
Sensor OV7660 devices. I am not sure how to identify only my model
here, but that may be ideal for a better patch. I wonder if this patch
would also be needed for the VX-3000 model?

I've attached the patch that I'm using. I attached the "diff -c" and
"diff -uNr" style patches. the uNr style looks more like the
changesets I've found at LinuxTV.org so it may be the easiest to
apply. I hope the patch helps!

Hopefully this will make it into the Kernel source before too long so
it works on other computers without modification. :D

Cheers.

-- 
Kyle Baker

--0015174c0e52228b7c048b38bed8
Content-Type: application/octet-stream; name="sonixj-vx1000.patch"
Content-Disposition: attachment; filename="sonixj-vx1000.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbjwt7290

KioqIHNvbml4ai1vcmlnaW5hbC5jCTIwMTAtMDctMTAgMDU6MDM6MDIuMDAwMDAwMDAwIC0wNDAw
Ci0tLSBzb25peGotcGF0Y2guYwkyMDEwLTA3LTEyIDE3OjUyOjIwLjAwMDAwMDAwMCAtMDQwMAoq
KioqKioqKioqKioqKioKKioqIDE3NDksMTc1NSAqKioqCiAgCQlyZWdfdzEoZ3NwY2FfZGV2LCAw
eDAxLCAweDYyKTsKICAJCXJlZ193MShnc3BjYV9kZXYsIDB4MDEsIDB4NDIpOwogIAkJbXNsZWVw
KDEwMCk7CiEgCQlyZWdfdzEoZ3NwY2FfZGV2LCAweDAyLCAweDYyKTsKICAJCWJyZWFrOwogIAlk
ZWZhdWx0OgogIC8qCWNhc2UgU0VOU09SX0hWNzEzMVI6ICovCi0tLSAxNzQ5LDE3NTYgLS0tLQog
IAkJcmVnX3cxKGdzcGNhX2RldiwgMHgwMSwgMHg2Mik7CiAgCQlyZWdfdzEoZ3NwY2FfZGV2LCAw
eDAxLCAweDQyKTsKICAJCW1zbGVlcCgxMDApOwohIAkJaWYgKHNkLT5zZW5zb3IgIT0gU0VOU09S
X09WNzY2MCkKISAJCQlyZWdfdzEoZ3NwY2FfZGV2LCAweDAyLCAweDYyKTsKICAJCWJyZWFrOwog
IAlkZWZhdWx0OgogIC8qCWNhc2UgU0VOU09SX0hWNzEzMVI6ICovCioqKioqKioqKioqKioqKgoq
KiogMjMxNywyMzI0ICoqKioKICAJCXJlZzIgPSAweDQwOwogIAkJYnJlYWs7CiAgCX0KISAJcmVn
X3cxKGdzcGNhX2RldiwgMHgwMiwgcmVnMik7CiEgCXJlZ193MShnc3BjYV9kZXYsIDB4MDIsIHJl
ZzIpOwogIAogIAlyZWdfdzEoZ3NwY2FfZGV2LCAweDE1LCBzbjljMXh4WzB4MTVdKTsKICAJcmVn
X3cxKGdzcGNhX2RldiwgMHgxNiwgc245YzF4eFsweDE2XSk7Ci0tLSAyMzE4LDIzMjcgLS0tLQog
IAkJcmVnMiA9IDB4NDA7CiAgCQlicmVhazsKICAJfQohIAlpZiAoc2QtPnNlbnNvciAhPSBTRU5T
T1JfT1Y3NjYwKSB7CiEgCQlyZWdfdzEoZ3NwY2FfZGV2LCAweDAyLCByZWcyKTsKISAJCXJlZ193
MShnc3BjYV9kZXYsIDB4MDIsIHJlZzIpOwohIAl9CiAgCiAgCXJlZ193MShnc3BjYV9kZXYsIDB4
MTUsIHNuOWMxeHhbMHgxNV0pOwogIAlyZWdfdzEoZ3NwY2FfZGV2LCAweDE2LCBzbjljMXh4WzB4
MTZdKTsK
--0015174c0e52228b7c048b38bed8
Content-Type: application/octet-stream; name="sonixj-vx1000-diff-uNr.patch"
Content-Disposition: attachment; filename="sonixj-vx1000-diff-uNr.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbjwxyso1

LS0tIHNvbml4ai1vcmlnaW5hbC5jCTIwMTAtMDctMTAgMDU6MDM6MDIuMDAwMDAwMDAwIC0wNDAw
CisrKyBzb25peGotcGF0Y2guYwkyMDEwLTA3LTEyIDE3OjUyOjIwLjAwMDAwMDAwMCAtMDQwMApA
QCAtMTc0OSw3ICsxNzQ5LDggQEAKIAkJcmVnX3cxKGdzcGNhX2RldiwgMHgwMSwgMHg2Mik7CiAJ
CXJlZ193MShnc3BjYV9kZXYsIDB4MDEsIDB4NDIpOwogCQltc2xlZXAoMTAwKTsKLQkJcmVnX3cx
KGdzcGNhX2RldiwgMHgwMiwgMHg2Mik7CisJCWlmIChzZC0+c2Vuc29yICE9IFNFTlNPUl9PVjc2
NjApCisJCQlyZWdfdzEoZ3NwY2FfZGV2LCAweDAyLCAweDYyKTsKIAkJYnJlYWs7CiAJZGVmYXVs
dDoKIC8qCWNhc2UgU0VOU09SX0hWNzEzMVI6ICovCkBAIC0yMzE3LDggKzIzMTgsMTAgQEAKIAkJ
cmVnMiA9IDB4NDA7CiAJCWJyZWFrOwogCX0KLQlyZWdfdzEoZ3NwY2FfZGV2LCAweDAyLCByZWcy
KTsKLQlyZWdfdzEoZ3NwY2FfZGV2LCAweDAyLCByZWcyKTsKKwlpZiAoc2QtPnNlbnNvciAhPSBT
RU5TT1JfT1Y3NjYwKSB7CisJCXJlZ193MShnc3BjYV9kZXYsIDB4MDIsIHJlZzIpOworCQlyZWdf
dzEoZ3NwY2FfZGV2LCAweDAyLCByZWcyKTsKKwl9CiAKIAlyZWdfdzEoZ3NwY2FfZGV2LCAweDE1
LCBzbjljMXh4WzB4MTVdKTsKIAlyZWdfdzEoZ3NwY2FfZGV2LCAweDE2LCBzbjljMXh4WzB4MTZd
KTsK
--0015174c0e52228b7c048b38bed8--
