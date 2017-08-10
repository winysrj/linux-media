Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34955 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752297AbdHJM1m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 08:27:42 -0400
Date: Thu, 10 Aug 2017 17:57:35 +0530
From: Harold Gomez <haroldgmz11@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Subject:staging:media:atomisp:ap1302: fix comments style
Message-ID: <20170810122735.GA2481@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fix comment style Warning in ap1302.c
fix WARNING on Block comments use * on subsequent lines

Signed-off-by: Harold Gomez <haroldgmz11@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index ac1aa96..995f243 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -157,9 +157,11 @@ static struct ap1302_context_info context_info[] = {
 	{CNTX_HINF_CTRL, AP1302_REG16, "hinf_ctrl"},
 };
 
-/* This array stores the description list for metadata.
+/*
+ * This array stores the description list for metadata.
  * The metadata contains exposure settings and face
  * detection results.
+ *
  */
 static u16 ap1302_ss_list[] = {
 	0xb01c, /* From 0x0186 with size 0x1C are exposure settings. */
-- 
2.1.4
