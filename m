Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59218 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbZDZPb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 11:31:28 -0400
Received: by ewy24 with SMTP id 24so1751900ewy.37
        for <linux-media@vger.kernel.org>; Sun, 26 Apr 2009 08:31:26 -0700 (PDT)
Message-ID: <49F47E4E.4020804@gmail.com>
Date: Sun, 26 Apr 2009 17:31:26 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: aospan@netup.ru, mchehab@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>
CC: linux-media@vger.kernel.org
Subject: [PATCH] V4L/DVB: &/&& typo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

binary/logical and typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/cx23885/cimax2.c b/drivers/media/video/cx23885/cimax2.c
index 9a65369..08582e5 100644
--- a/drivers/media/video/cx23885/cimax2.c
+++ b/drivers/media/video/cx23885/cimax2.c
@@ -312,7 +312,7 @@ static void netup_read_ci_status(struct work_struct *work)
 		"TS config = %02x\n", __func__, state->ci_i2c_addr, 0, buf[0],
 		buf[32]);
 
-	if (buf[0] && 1)
+	if (buf[0] & 1)
 		state->status = DVB_CA_EN50221_POLL_CAM_PRESENT |
 			DVB_CA_EN50221_POLL_CAM_READY;
 	else

