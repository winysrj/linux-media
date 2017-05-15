Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35589 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965542AbdEOTm6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 15:42:58 -0400
Received: by mail-wm0-f68.google.com with SMTP id v4so31119462wmb.2
        for <linux-media@vger.kernel.org>; Mon, 15 May 2017 12:42:58 -0700 (PDT)
From: Ricardo Silva <rjpdasilva@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Ricardo Silva <rjpdasilva@gmail.com>
Subject: [PATCH 5/5] staging: media: lirc: Fix unbalanced braces around if/else
Date: Mon, 15 May 2017 20:40:16 +0100
Message-Id: <20170515194016.10246-6-rjpdasilva@gmail.com>
In-Reply-To: <20170515194016.10246-1-rjpdasilva@gmail.com>
References: <20170515194016.10246-1-rjpdasilva@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix all checkpatch reported issues for:

 * CHECK: "braces {} should be used on all arms of this statement".
 * CHECK: "Unbalanced braces around else statement".

Make sure all if/else statements are balanced in terms of braces. Most
cases in code are, but a few were left unbalanced, so put them all
consistent with the recommended style.

Signed-off-by: Ricardo Silva <rjpdasilva@gmail.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 7e36693b66a8..121126beccd0 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -554,9 +554,9 @@ static int get_key_data(unsigned char *buf,
 		if (!read_uint32(&data, tx_data->endp, &i))
 			goto corrupt;
 
-		if (i == codeset)
+		if (i == codeset) {
 			break;
-		else if (codeset > i) {
+		} else if (codeset > i) {
 			base = pos + 1;
 			--lim;
 		}
@@ -990,8 +990,9 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 			"failed to get data for code %u, key %u -- check lircd.conf entries\n",
 			code, key);
 		return ret;
-	} else if (ret != 0)
+	} else if (ret != 0) {
 		return ret;
+	}
 
 	/* Send the data block */
 	ret = send_data_block(tx, data_block);
@@ -1188,8 +1189,9 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 			schedule_timeout((100 * HZ + 999) / 1000);
 			tx->need_boot = 1;
 			++failures;
-		} else
+		} else {
 			i += sizeof(int);
+		}
 	}
 
 	/* Release i2c bus */
-- 
2.12.2
