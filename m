Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:33187 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbbHZTGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 15:06:44 -0400
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH v2] media/pci/cobalt: Use %*ph to print small buffers
Date: Thu, 27 Aug 2015 01:06:11 +0600
Message-Id: <1440615971-13255-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

printk() supports %*ph format specifier for printing a small buffers,
let's use it intead of %02x %02x...

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 drivers/media/pci/cobalt/cobalt-cpld.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-cpld.c b/drivers/media/pci/cobalt/cobalt-cpld.c
index e83f5c9..23c875f 100644
--- a/drivers/media/pci/cobalt/cobalt-cpld.c
+++ b/drivers/media/pci/cobalt/cobalt-cpld.c
@@ -290,8 +290,8 @@ bool cobalt_cpld_set_freq(struct cobalt *cobalt, unsigned f_out)
 	   0x01, 0xc7, 0xfc, 0x7f, 0x53, 0x62).
 	 */
 
-	cobalt_dbg(1, "%u: %02x %02x %02x %02x %02x %02x\n", f_out,
-			regs[0], regs[1], regs[2], regs[3], regs[4], regs[5]);
+	cobalt_dbg(1, "%u: %6ph\n", f_out, regs);
+
 	while (retries--) {
 		u8 read_regs[6];
 
@@ -330,9 +330,7 @@ bool cobalt_cpld_set_freq(struct cobalt *cobalt, unsigned f_out)
 
 		if (!memcmp(read_regs, regs, sizeof(read_regs)))
 			break;
-		cobalt_dbg(1, "retry: %02x %02x %02x %02x %02x %02x\n",
-			read_regs[0], read_regs[1], read_regs[2],
-			read_regs[3], read_regs[4], read_regs[5]);
+		cobalt_dbg(1, "retry: %6ph\n", read_regs);
 	}
 	if (2 - retries)
 		cobalt_info("Needed %d retries\n", 2 - retries);
-- 
2.5.0

