Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward9l.mail.yandex.net ([84.201.143.142]:36216 "EHLO
	forward9l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3KAThs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 15:37:48 -0400
Received: from smtp1h.mail.yandex.net (smtp1h.mail.yandex.net [84.201.187.144])
	by forward9l.mail.yandex.net (Yandex) with ESMTP id 5BA8EE60C37
	for <linux-media@vger.kernel.org>; Fri,  1 Nov 2013 23:31:16 +0400 (MSK)
Received: from smtp1h.mail.yandex.net (localhost [127.0.0.1])
	by smtp1h.mail.yandex.net (Yandex) with ESMTP id 1B6491340266
	for <linux-media@vger.kernel.org>; Fri,  1 Nov 2013 23:31:15 +0400 (MSK)
Message-ID: <5274017D.9050204@narod.ru>
Date: Fri, 01 Nov 2013 21:31:09 +0200
From: CrazyCat <crazycat69@narod.ru>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] tda18271-fe: Fix dvb-c standard selection
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix dvb-c standard selection - qam8 for ANNEX_AC

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
diff --git a/drivers/media/tuners/tda18271-fe.c 
b/drivers/media/tuners/tda18271-fe.c
index 4995b89..6a385c8 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -960,16 +960,12 @@ static int tda18271_set_params(struct dvb_frontend 
*fe)
          break;
      case SYS_DVBC_ANNEX_B:
          bw = 6000000;
-        /* falltrough */
+        map = &std_map->qam_6;
+        break;
      case SYS_DVBC_ANNEX_A:
      case SYS_DVBC_ANNEX_C:
-        if (bw <= 6000000) {
-            map = &std_map->qam_6;
-        } else if (bw <= 7000000) {
-            map = &std_map->qam_7;
-        } else {
-            map = &std_map->qam_8;
-        }
+        bw = 8000000;
+        map = &std_map->qam_8;
          break;
      default:
          tda_warn("modulation type not supported!\n");

