Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41726 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdITWUE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 18:20:04 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jasmin Jessich <jasmin@anw.at>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: dvb_ca_en50221: sanity check slot number from userspace
Date: Wed, 20 Sep 2017 23:19:59 +0100
Message-Id: <20170920221959.5979-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Currently a user can pass in an unsanitized slot number which
will lead to and out of range index into ca->slot_info. Fix this
by checking that the slot number is no more than the allowed
maximum number of slots. Seems that this bug has been in the driver
forever.

Detected by CoverityScan, CID#139381 ("Untrusted pointer read")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 95b3723282f4..e3a92b529dba 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1474,6 +1474,9 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 		return -EFAULT;
 	buf += 2;
 	count -= 2;
+
+	if (slot >= ca->slot_count)
+		return -EINVAL;
 	sl = &ca->slot_info[slot];
 
 	/* check if the slot is actually running */
-- 
2.14.1
