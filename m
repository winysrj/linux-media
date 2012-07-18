Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36904 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab2GROl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 10:41:59 -0400
Message-ID: <5006CB2B.3060905@gmail.com>
Date: Wed, 18 Jul 2012 22:41:47 +0800
From: Duan Jiong <djduanjiong@gmail.com>
MIME-Version: 1.0
To: mchehab@infradead.org, hans.verkuil@cisco.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pms.c: remove duplicated include
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Duan Jiong <djduanjiong@gmail.com>
---
 drivers/media/video/pms.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index b4c679b..77f9c92 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -30,7 +30,6 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
-#include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/isa.h>
 #include <asm/io.h>
-- 
1.7.9.5

