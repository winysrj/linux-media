Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaIXW2A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:28:00 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Michael Opdenacker <michael.opdenacker@free-electrons.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [PATCH 04/18] [media] saa7164-core: declare symbols as static
Date: Wed, 24 Sep 2014 19:27:04 -0300
Message-Id: <c2514892ac4ce7d8d645abd90916480d884a49eb.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those symbols are used only at saa7164-core.

drivers/media/pci/saa7164/saa7164-core.c:55:14: warning: symbol 'fw_debug' was not declared. Should it be static?
drivers/media/pci/saa7164/saa7164-core.c:75:14: warning: symbol 'print_histogram' was not declared. Should it be static?
drivers/media/pci/saa7164/saa7164-core.c:83:14: warning: symbol 'guard_checking' was not declared. Should it be static?

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 1bf06970ca3e..cc1be8a7a451 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -52,7 +52,7 @@ unsigned int saa_debug;
 module_param_named(debug, saa_debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
 
-unsigned int fw_debug;
+static unsigned int fw_debug;
 module_param(fw_debug, int, 0644);
 MODULE_PARM_DESC(fw_debug, "Firmware debug level def:2");
 
@@ -72,7 +72,7 @@ static unsigned int card[]  = {[0 ... (SAA7164_MAXBOARDS - 1)] = UNSET };
 module_param_array(card,  int, NULL, 0444);
 MODULE_PARM_DESC(card, "card type");
 
-unsigned int print_histogram = 64;
+static unsigned int print_histogram = 64;
 module_param(print_histogram, int, 0644);
 MODULE_PARM_DESC(print_histogram, "print histogram values once");
 
@@ -80,7 +80,7 @@ unsigned int crc_checking = 1;
 module_param(crc_checking, int, 0644);
 MODULE_PARM_DESC(crc_checking, "enable crc sanity checking on buffers");
 
-unsigned int guard_checking = 1;
+static unsigned int guard_checking = 1;
 module_param(guard_checking, int, 0644);
 MODULE_PARM_DESC(guard_checking,
 	"enable dma sanity checking for buffer overruns");
-- 
1.9.3

