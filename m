Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52206 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab0KSXmo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:42:44 -0500
Subject: [PATCH 01/10] saa7134: remove unused module parameter
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:42:41 +0100
Message-ID: <20101119234241.3511.28234.stgit@localhost.localdomain>
In-Reply-To: <20101119233959.3511.91287.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

ir_rc5_remote_gap is a leftover from ir-common, remove it.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/saa7134/saa7134-input.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index f3f4aff..4fdc165 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -41,9 +41,6 @@ static int pinnacle_remote;
 module_param(pinnacle_remote, int, 0644);    /* Choose Pinnacle PCTV remote */
 MODULE_PARM_DESC(pinnacle_remote, "Specify Pinnacle PCTV remote: 0=coloured, 1=grey (defaults to 0)");
 
-static int ir_rc5_remote_gap = 885;
-module_param(ir_rc5_remote_gap, int, 0644);
-
 static unsigned int disable_other_ir;
 module_param(disable_other_ir, int, 0644);
 MODULE_PARM_DESC(disable_other_ir, "disable full codes of "

