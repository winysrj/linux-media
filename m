Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46241 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751257AbdGPAnj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:39 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 13/16] [media] dvb-core/dvb_ca_en50221.c: Fix again wrong EXPORT_SYMBOL order
Date: Sun, 16 Jul 2017 02:43:14 +0200
Message-Id: <1500165797-16987-14-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Some EXPORT_SYMBOL() on this file don't match the name of functions
that precedes them.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index aba80d8..2619822 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1849,7 +1849,6 @@ static unsigned int dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
 
 	return mask;
 }
-EXPORT_SYMBOL(dvb_ca_en50221_init);
 
 
 static const struct file_operations dvb_ca_fops = {
@@ -1968,8 +1967,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	pubca->private = NULL;
 	return ret;
 }
-EXPORT_SYMBOL(dvb_ca_en50221_release);
-
+EXPORT_SYMBOL(dvb_ca_en50221_init);
 
 
 /**
@@ -1995,3 +1993,4 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 	dvb_ca_private_put(ca);
 	pubca->private = NULL;
 }
+EXPORT_SYMBOL(dvb_ca_en50221_release);
-- 
2.7.4
