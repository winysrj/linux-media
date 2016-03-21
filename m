Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:48047 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154AbcCUNaT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 09:30:19 -0400
Subject: [PATCH 1/6] drivers/media/dvb-core/en50221: move code to
 dvb_ca_private_free()
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Mon, 21 Mar 2016 14:30:17 +0100
Message-ID: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare for postponing the call until all file handles have been
closed.

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/dvb-core/dvb_ca_en50221.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index f82cd1f..e33364c 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -161,6 +161,17 @@ struct dvb_ca_private {
 	struct mutex ioctl_mutex;
 };
 
+static void dvb_ca_private_free(struct dvb_ca_private *ca)
+{
+	dvb_unregister_device(ca->dvbdev);
+	unsigned int i;
+	for (i = 0; i < ca->slot_count; i++) {
+		vfree(ca->slot_info[i].rx_buffer.data);
+	}
+	kfree(ca->slot_info);
+	kfree(ca);
+}
+
 static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca);
 static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * ebuf, int ecount);
 static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * ebuf, int ecount);
@@ -1759,10 +1770,7 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 
 	for (i = 0; i < ca->slot_count; i++) {
 		dvb_ca_en50221_slot_shutdown(ca, i);
-		vfree(ca->slot_info[i].rx_buffer.data);
 	}
-	kfree(ca->slot_info);
-	dvb_unregister_device(ca->dvbdev);
-	kfree(ca);
+	dvb_ca_private_free(ca);
 	pubca->private = NULL;
 }

