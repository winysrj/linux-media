Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38353 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbdHJI66 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 04:58:58 -0400
Date: Thu, 10 Aug 2017 14:28:51 +0530
From: Harold Gomez <haroldgmz11@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Subject:drivers:staging:media:atomisp:i2c:api1302.c
Message-ID: <20170810085851.GA2724@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix Warning Block comments use * on subsequent lines

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
