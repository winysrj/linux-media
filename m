Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:61292 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750756AbdH3TQL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 15:16:11 -0400
Subject: [PATCH 1/2] [media] drxd: Delete an error message for a failed memory
 allocation in load_firmware()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <62e6221c-226c-3b25-08bb-4baff9b23cbb@users.sourceforge.net>
Message-ID: <190c120b-6974-e232-a171-e0e103a3e9a6@users.sourceforge.net>
Date: Wed, 30 Aug 2017 21:15:58 +0200
MIME-Version: 1.0
In-Reply-To: <62e6221c-226c-3b25-08bb-4baff9b23cbb@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 30 Aug 2017 20:47:12 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/drxd_hard.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 7d04400b18dd..47b0d37e70ba 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -911,7 +911,6 @@ static int load_firmware(struct drxd_state *state, const char *fw_name)
 	state->microcode = kmemdup(fw->data, fw->size, GFP_KERNEL);
 	if (state->microcode == NULL) {
 		release_firmware(fw);
-		printk(KERN_ERR "drxd: firmware load failure: no memory\n");
 		return -ENOMEM;
 	}
 
-- 
2.14.1
