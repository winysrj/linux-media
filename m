Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:59776 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549AbcHIVls (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:48 -0400
Subject: [PATCH 03/12] [media] dvb-core/en50221: use dvb_remove_device()
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:16 +0200
Message-ID: <147077833619.21835.14426939382293452517.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit da677fe14364 ("[media] dvb-core/en50221: use kref to manage
struct dvb_ca_private") moved the dvb_unregister_device() call to the
kref callback, but that left lots of stale device state visible to
userspace (e.g. in sysfs).  By using dvb_remove_device() and
dvb_free_device() instead of dvb_unregister_device(), we can avoid
that.

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/dvb-core/dvb_ca_en50221.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index b5b5b19..09e759c 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -166,7 +166,7 @@ static void dvb_ca_private_free(struct dvb_ca_private *ca)
 {
 	unsigned int i;
 
-	dvb_unregister_device(ca->dvbdev);
+	dvb_free_device(ca->dvbdev);
 	for (i = 0; i < ca->slot_count; i++)
 		vfree(ca->slot_info[i].rx_buffer.data);
 
@@ -1794,6 +1794,7 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 	for (i = 0; i < ca->slot_count; i++) {
 		dvb_ca_en50221_slot_shutdown(ca, i);
 	}
+	dvb_remove_device(ca->dvbdev);
 	dvb_ca_private_put(ca);
 	pubca->private = NULL;
 }

