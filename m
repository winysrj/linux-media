Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49510 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbbBMW6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guoxiong Yan <yanguoxiong@huawei.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCHv4 01/25] [media] ir-hix5hd2: remove writel/readl_relaxed define
Date: Fri, 13 Feb 2015 20:57:44 -0200
Message-Id: <211deabc7707be714ed6a5673372566dbff190c9.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Zhangfei Gao <zhangfei.gao@linaro.org>

Commit 9439eb3ab9d1ec ("asm-generic: io: implement relaxed
accessor macros as conditional wrappers") has added
{read,write}{b,w,l,q}_relaxed to include/asm-generic/io.h

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

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
2.1.0

