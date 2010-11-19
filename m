Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33751 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab0KSXoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:44:44 -0500
Subject: [PATCH 06/10] saa7134: make module parameters boolean
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:43:07 +0100
Message-ID: <20101119234307.3511.53565.stgit@localhost.localdomain>
In-Reply-To: <20101119233959.3511.91287.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

int to bool conversion for module parameters which are truely boolean.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/saa7134/saa7134-input.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 8b80efb..aea74e2 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -29,12 +29,12 @@
 
 #define MODULE_NAME "saa7134"
 
-static unsigned int disable_ir;
-module_param(disable_ir, int, 0444);
+static bool disable_ir;
+module_param(disable_ir, bool, 0444);
 MODULE_PARM_DESC(disable_ir,"disable infrared remote support");
 
-static unsigned int ir_debug;
-module_param(ir_debug, int, 0644);
+static bool ir_debug;
+module_param(ir_debug, bool, 0644);
 MODULE_PARM_DESC(ir_debug,"enable debug messages [IR]");
 
 static int pinnacle_remote;

