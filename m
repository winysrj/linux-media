Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:40736 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbeBXO4B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 09:56:01 -0500
Received: by mail-wm0-f65.google.com with SMTP id t6so1265762wmt.5
        for <linux-media@vger.kernel.org>; Sat, 24 Feb 2018 06:56:00 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Jasmin Jessich <jasmin@anw.at>
Subject: [PATCH] [media] dvb_ca_en50221: fix severity of successful CAM init log message
Date: Sat, 24 Feb 2018 15:55:57 +0100
Message-Id: <20180224145557.4179-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

A successful CA module initialisation isn't an error. Change the log print
to info severity accordingly.

Cc: Jasmin Jessich <jasmin@anw.at>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 204d0f6c678d..97365a863519 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1254,8 +1254,8 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 		ca->pub->slot_ts_enable(ca->pub, slot);
 		sl->slot_state = DVB_CA_SLOTSTATE_RUNNING;
 		dvb_ca_en50221_thread_update_delay(ca);
-		pr_err("dvb_ca adapter %d: DVB CAM detected and initialised successfully\n",
-		       ca->dvbdev->adapter->num);
+		pr_info("dvb_ca adapter %d: DVB CAM detected and initialised successfully\n",
+			ca->dvbdev->adapter->num);
 		break;
 
 	case DVB_CA_SLOTSTATE_RUNNING:
-- 
2.16.1
