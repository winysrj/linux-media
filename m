Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:36216 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751902AbdGCKRr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 06:17:47 -0400
Received: by mail-ua0-f173.google.com with SMTP id g40so106650434uaa.3
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 03:17:46 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Bernhard_Rosenkr=C3=A4nzer?=
        <bernhard.rosenkranzer@linaro.org>
Date: Mon, 3 Jul 2017 12:17:25 +0200
Message-ID: <CAJcDVWP27nnixtwCBwP3KMV=jTtA01ZrQ1wxdQwGOM-9gQrdFg@mail.gmail.com>
Subject: [PATCH] [dtv-scan-tables] Add scan file for EWCom Goms DVB-C
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a scan file for EWCom Goms DVB-C

Signed-off-by: Bernhard Rosenkr=C3=A4nzer <bero@lindev.ch>
---
 dvb-c/ch-Oberwallis-ewcom | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 dvb-c/ch-Oberwallis-ewcom

diff --git a/dvb-c/ch-Oberwallis-ewcom b/dvb-c/ch-Oberwallis-ewcom
new file mode 100644
index 0000000..b856e83
--- /dev/null
+++ b/dvb-c/ch-Oberwallis-ewcom
@@ -0,0 +1,9 @@
+# EWCom Goms
+# Network ID 562
+[CHANNEL]
+ DELIVERY_SYSTEM =3D DVBC/ANNEX_A
+ FREQUENCY =3D 594000000
+ SYMBOL_RATE =3D 6900000
+ INNER_FEC =3D NONE
+ MODULATION =3D QAM/256
+ INVERSION =3D AUTO
--=20
2.13.2
