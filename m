Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9423 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753629AbdCTOmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:04 -0400
Subject: [PATCH 16/24] stating/atomisp: fix -Wold-style-definition warning
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:41:29 +0000
Message-ID: <149002088805.17109.15017761805145004727.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

ia_css_dequeue_param_buffers does not have an arguement type, causing a warning:

drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c: In function 'ia_css_dequeue_param_buffers':
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:3728:6: error: old-style function definition [-Werror=old-style-definition]

This adds a 'void' keywork to silence the warning.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index e4599f7..36a0c6b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -3723,7 +3723,7 @@ static void sh_css_update_isp_mem_params_to_ddr(
 	IA_CSS_LEAVE_PRIVATE("void");
 }
 
-void ia_css_dequeue_param_buffers(/*unsigned int pipe_num*/)
+void ia_css_dequeue_param_buffers(/*unsigned int pipe_num*/ void)
 {
 	unsigned int i;
 	hrt_vaddress cpy;
