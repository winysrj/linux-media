Return-path: <linux-media-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48648 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbLMAcF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 19:32:05 -0500
Date: Sun, 13 Dec 2015 00:32:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH][davinci] ccdc_update_raw_params() frees the wrong thing
Message-ID: <20151213003201.GQ20997@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Passing a physical address to free_pages() is a bad idea.
config_params->fault_pxl.fpc_table_addr is set to virt_to_phys()
of __get_free_pages() return value; what we should pass to free_pages()
is its phys_to_virt().  ccdc_close() does that properly, but
ccdc_update_raw_params() doesn't.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index ffbefdf..6fba32b 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -261,7 +261,7 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 	 */
 	if (raw_params->fault_pxl.fp_num != config_params->fault_pxl.fp_num) {
 		if (fpc_physaddr != NULL) {
-			free_pages((unsigned long)fpc_physaddr,
+			free_pages((unsigned long)fpc_virtaddr,
 				   get_order
 				   (config_params->fault_pxl.fp_num *
 				   FP_NUM_BYTES));
