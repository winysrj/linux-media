Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52229 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaJIQqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 12:46:31 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Zhangfei Gao <zhangfei.gao@linaro.org>,
	Guoxiong Yan <yanguoxiong@huawei.com>
Subject: [PATCH] [media] ir-hix5hd2: fix build on c6x arch
Date: Thu,  9 Oct 2014 13:46:03 -0300
Message-Id: <5563caaf8b8cd22e35997d5d74cb3609df86b223.1412873150.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While not all archs have readl_relaxed, we need to add a hack at the
driver to allow it to COMPILE_TEST on all archs:

	drivers/media/rc/ir-hix5hd2.c: In function ‘hix5hd2_ir_config’:
	drivers/media/rc/ir-hix5hd2.c:100:2: error: implicit declaration of function ‘readl_relaxed’ [-Werror=implicit-function-declaration]

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index c555ca2aed0e..08bbd4f508cd 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -20,6 +20,9 @@
 #ifndef writel_relaxed
 # define writel_relaxed writel
 #endif
+#ifndef readl_relaxed
+# define readl_relaxed readl
+#endif
 
 #define IR_ENABLE		0x00
 #define IR_CONFIG		0x04
-- 
1.9.3

