Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54618 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab0HQReU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Aug 2010 13:34:20 -0400
Received: by ywh1 with SMTP id 1so2605874ywh.19
        for <linux-media@vger.kernel.org>; Tue, 17 Aug 2010 10:34:20 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 Aug 2010 10:34:19 -0700
Message-ID: <AANLkTinkYSHB5cLav2jw1snWa=1mYWL2+DmUb4ckgZHT@mail.gmail.com>
Subject: [PATCH] gp8psk: fix tuner delay
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>,
	Alan Nisota <alannisota@gmail.com>
Content-Type: multipart/mixed; boundary=000e0cd2c2d4e76c17048e085b47
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

--000e0cd2c2d4e76c17048e085b47
Content-Type: text/plain; charset=ISO-8859-1

This patches adjusts the tuner delay to be longer in response to
several users experiencing tuner timeouts.  This change fixes that
problem and allows those users to be able to tune.

Signed-off-by: Derek Kelly <user.vdr@gmail.com>
----------
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c
2010-08-17 09:53:27.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c 2010-08-17
10:00:28.000000000 -0700
@@ -109,7 +109,7 @@ static int gp8psk_fe_read_signal_strengt

 static int gp8psk_fe_get_tune_settings(struct dvb_frontend* fe,
struct dvb_frontend_tune_settings *tune)
 {
-       tune->min_delay_ms = 200;
+       tune->min_delay_ms = 800;
        return 0;
 }

--000e0cd2c2d4e76c17048e085b47
Content-Type: application/octet-stream; name="gp8psk-fix_tuner_delay.diff"
Content-Disposition: attachment; filename="gp8psk-fix_tuner_delay.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcz184270

ZGlmZiAtcHJ1TiB2NGwtZHZiLm9yaWcvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9n
cDhwc2stZmUuYyB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZ3A4cHNr
LWZlLmMKLS0tIHY0bC1kdmIub3JpZy9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2dw
OHBzay1mZS5jCTIwMTAtMDgtMTcgMDk6NTM6MjcuMDAwMDAwMDAwIC0wNzAwCisrKyB2NGwtZHZi
L2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZ3A4cHNrLWZlLmMJMjAxMC0wOC0xNyAx
MDowMDoyOC4wMDAwMDAwMDAgLTA3MDAKQEAgLTEwOSw3ICsxMDksNyBAQCBzdGF0aWMgaW50IGdw
OHBza19mZV9yZWFkX3NpZ25hbF9zdHJlbmd0CiAKIHN0YXRpYyBpbnQgZ3A4cHNrX2ZlX2dldF90
dW5lX3NldHRpbmdzKHN0cnVjdCBkdmJfZnJvbnRlbmQqIGZlLCBzdHJ1Y3QgZHZiX2Zyb250ZW5k
X3R1bmVfc2V0dGluZ3MgKnR1bmUpCiB7Ci0JdHVuZS0+bWluX2RlbGF5X21zID0gMjAwOworCXR1
bmUtPm1pbl9kZWxheV9tcyA9IDgwMDsKIAlyZXR1cm4gMDsKIH0KIAo=
--000e0cd2c2d4e76c17048e085b47--
