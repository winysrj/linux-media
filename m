Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37030 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751731AbdHJJic (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 05:38:32 -0400
Date: Thu, 10 Aug 2017 15:08:26 +0530
From: Harold Gomez <haroldgmz11@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Subject:drivers:staging:media:atomisp:
Message-ID: <20170810093826.GA3361@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix Warning from checkpatch.pl 
Block comments use * on subsequent lines

Signed-off-by: Harold Gomez <haroldgmz11@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index 9d6ce36..ac1aa96 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -158,8 +158,9 @@ static struct ap1302_context_info context_info[] = {
 };
 
 /* This array stores the description list for metadata.
-   The metadata contains exposure settings and face
-   detection results. */
+ * The metadata contains exposure settings and face
+ * detection results.
+ */
 static u16 ap1302_ss_list[] = {
 	0xb01c, /* From 0x0186 with size 0x1C are exposure settings. */
 	0x0186,
-- 
2.1.4
