Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0094.outbound.protection.outlook.com ([104.47.2.94]:16944
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751168AbcLECq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Dec 2016 21:46:58 -0500
From: Iago Abal <iari@itu.dk>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, Iago Abal <mail@iagoabal.eu>
Subject: [PATCH] [media] pctv452e: fix double lock bug
Date: Sun,  4 Dec 2016 17:32:42 +0100
Message-Id: <1480869162-2370-1-git-send-email-iari@itu.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Iago Abal <mail@iagoabal.eu>

Commit 73d5c5c864f4 protected the body of `tt3650_ci_msg' with state->ca_mutex.
This is not needed: 1) this function is always called from a context where that
lock is held; and 2) there exists a `tt3650_ci_msg_locked' wrapper that does
exactly the same.

This leads to double lock as reported by the EBA (http://www.iagoabal.eu/eba)
static bug finder:

    a) Function `tt3650_ci_msg_locked' takes state->ca_mutex in line 156 and
       then calls `tt3650_ci_msg' in line 157.

    b) Function `tt3650_ci_slot_reset' takes state->ca_mutex in line 297 and
       then calls `tt3650_ci_msg' in line 299.

Fixes: 73d5c5c864f4 ("[media] pctv452e: don't do DMA on stack")
Signed-off-by: Iago Abal <mail@iagoabal.eu>
---
 drivers/media/usb/dvb-usb/pctv452e.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index 07fa08b..c718fd9 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -114,7 +114,6 @@ static int tt3650_ci_msg(struct dvb_usb_device *d, u8 cmd, u8 *data,
 		return -EIO;
 	}
 
-	mutex_lock(&state->ca_mutex);
 	id = state->c++;
 
 	state->data[0] = SYNC_BYTE_OUT;
@@ -136,7 +135,6 @@ static int tt3650_ci_msg(struct dvb_usb_device *d, u8 cmd, u8 *data,
 
 	memcpy(data, state->data + 4, read_len);
 
-	mutex_unlock(&state->ca_mutex);
 	return 0;
 
 failed:
-- 
1.9.1

