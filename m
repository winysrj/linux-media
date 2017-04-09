Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36344 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752353AbdDIBe6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:34:58 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] [media] av7110: use setup_timer
Date: Sun,  9 Apr 2017 09:34:03 +0800
Message-Id: <67d18d0d51942b7b62935105db4978e824ac07c7.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/pci/ttpci/av7110_ir.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
index 10e28f0..ca05198 100644
--- a/drivers/media/pci/ttpci/av7110_ir.c
+++ b/drivers/media/pci/ttpci/av7110_ir.c
@@ -333,9 +333,8 @@ int av7110_ir_init(struct av7110 *av7110)
 	av_list[av_cnt++] = av7110;
 	av7110_check_ir_config(av7110, true);
 
-	init_timer(&av7110->ir.keyup_timer);
-	av7110->ir.keyup_timer.function = av7110_emit_keyup;
-	av7110->ir.keyup_timer.data = (unsigned long) &av7110->ir;
+	setup_timer(&av7110->ir.keyup_timer, av7110_emit_keyup,
+		    (unsigned long)&av7110->ir);
 
 	input_dev = input_allocate_device();
 	if (!input_dev)
-- 
2.9.3
