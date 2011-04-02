Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33533 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1DBNwA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 09:52:00 -0400
Received: by wwk4 with SMTP id 4so355748wwk.1
        for <linux-media@vger.kernel.org>; Sat, 02 Apr 2011 06:51:59 -0700 (PDT)
Subject: [PATCH 2/2] [BUG]STV0288 Register 42 - Incorrect settings
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Apr 2011 14:51:53 +0100
Message-ID: <1301752313.7763.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Register 42 bits 2,3,6 and 7 should be set to 0.
 This gives difficult locking on some channels and may be compensated
 for by other methods.

This affects any driver using the stv0288 frontend on the default
or earda inittab.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/eds1547.h |    2 +-
 drivers/media/dvb/frontends/stv0288.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/eds1547.h b/drivers/media/dvb/frontends/eds1547.h
index fa79b7c..c983f2f 100644
--- a/drivers/media/dvb/frontends/eds1547.h
+++ b/drivers/media/dvb/frontends/eds1547.h
@@ -61,7 +61,7 @@ static u8 stv0288_earda_inittab[] = {
 	0x3d, 0x30,
 	0x40, 0x63,
 	0x41, 0x04,
-	0x42, 0x60,
+	0x42, 0x20,
 	0x43, 0x00,
 	0x44, 0x00,
 	0x45, 0x00,
diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index e3fe17f..8e0cfad 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -253,7 +253,7 @@ static u8 stv0288_inittab[] = {
 	0x3d, 0x30,
 	0x40, 0x63,
 	0x41, 0x04,
-	0x42, 0x60,
+	0x42, 0x20,
 	0x43, 0x00,
 	0x44, 0x00,
 	0x45, 0x00,
-- 
1.7.4.1

