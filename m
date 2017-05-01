Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41312 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758715AbdEAQEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:45 -0400
Subject: [PATCH 12/16] lirc_dev: return POLLHUP and POLLERR when device is
 gone
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:37 +0200
Message-ID: <149365467703.12922.9688704294126545443.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most drivers return both values when the device is gone.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 57d21201ff93..e44e0b23b883 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -374,7 +374,7 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 	}
 
 	if (!ir->attached)
-		return POLLERR;
+		return POLLHUP | POLLERR;
 
 	if (ir->buf) {
 		poll_wait(file, &ir->buf->wait_poll, wait);
