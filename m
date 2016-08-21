Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34662 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752174AbcHUSn0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Aug 2016 14:43:26 -0400
From: Jannik Becher <becher.jannik@gmail.com>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jannik Becher <Becher.Jannik@gmail.com>
Subject: [PATCH] drivers: hackrf: fixed a coding style issue
Date: Sun, 21 Aug 2016 20:44:20 +0200
Message-Id: <20160821184420.30115-1-Becher.Jannik@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changed 'unsigned' to 'unsigned int' to obtain the coding style.

Signed-off-by: Jannik Becher <Becher.Jannik@gmail.com>
---
 drivers/media/usb/hackrf/hackrf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index b1e229a..fc67648 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -129,7 +129,7 @@ struct hackrf_dev {
 	struct list_head rx_buffer_list;
 	struct list_head tx_buffer_list;
 	spinlock_t buffer_list_lock; /* Protects buffer_list */
-	unsigned sequence;	     /* Buffer sequence counter */
+	unsigned int sequence;	     /* Buffer sequence counter */
 	unsigned int vb_full;        /* vb is full and packets dropped */
 	unsigned int vb_empty;       /* vb is empty and packets dropped */
 
-- 
2.9.3

