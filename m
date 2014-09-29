Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbaI2CXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 22:23:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan McCrohan <jmccrohan@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Johannes Stezenbach <js@linuxtv.org>
Subject: [PATCH 2/6] [media] drxk: Fix debug printks
Date: Sun, 28 Sep 2014 23:23:19 -0300
Message-Id: <b131dfca6f5a330dfd62f797b4dc1ee1a9261654.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch partially reverts 0fb220f2a5cb. What happened is
that the conversion of debug messages to use pr_debug() was a
bad idea, because one needing to debug would need to both
enable debug level via a modprobe parameter, and then to
enable the dynamic printk's.

So, for now, let's use printk() directly at dprintk().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 672195147d01..f140b835c414 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -166,9 +166,9 @@ static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
 
-#define dprintk(level, fmt, arg...) do {			\
-if (debug >= level)						\
-	pr_debug(fmt, ##arg);					\
+#define dprintk(level, fmt, arg...) do {				\
+if (debug >= level)							\
+	printk(KERN_DEBUG KBUILD_MODNAME ": %s " fmt, __func__, ##arg);	\
 } while (0)
 
 
-- 
1.9.3

