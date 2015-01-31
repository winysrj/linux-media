Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43760 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbbAaJ3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jan 2015 04:29:54 -0500
Received: by mail-pa0-f48.google.com with SMTP id ey11so62051042pad.7
        for <linux-media@vger.kernel.org>; Sat, 31 Jan 2015 01:29:53 -0800 (PST)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] [media] ir-hix5hd2: remove writel/readl_relaxed define
Date: Sat, 31 Jan 2015 17:29:46 +0800
Message-Id: <1422696586-27411-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 9439eb3ab9d1ec ("asm-generic: io: implement relaxed
accessor macros as conditional wrappers") has added
{read,write}{b,w,l,q}_relaxed to include/asm-generic/io.h

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/media/rc/ir-hix5hd2.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index b0df62961c14..58ec5986274e 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -16,14 +16,6 @@
 #include <linux/regmap.h>
 #include <media/rc-core.h>
 
-/* Allow the driver to compile on all architectures */
-#ifndef writel_relaxed
-# define writel_relaxed writel
-#endif
-#ifndef readl_relaxed
-# define readl_relaxed readl
-#endif
-
 #define IR_ENABLE		0x00
 #define IR_CONFIG		0x04
 #define CNT_LEADS		0x08
-- 
1.9.1

