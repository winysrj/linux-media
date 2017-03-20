Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:54335 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753453AbdCTJc4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 05:32:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/9] stating/atomisp: fix -Wold-style-definition warning
Date: Mon, 20 Mar 2017 10:32:19 +0100
Message-Id: <20170320093225.1180723-3-arnd@arndb.de>
In-Reply-To: <20170320093225.1180723-1-arnd@arndb.de>
References: <20170320093225.1180723-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ia_css_dequeue_param_buffers does not have an arguement type, causing a warning:

drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c: In function 'ia_css_dequeue_param_buffers':
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:3728:6: error: old-style function definition [-Werror=old-style-definition]

This adds a 'void' keywork to silence the warning.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index 9d51f1c653a2..1f346394c6b1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -3725,7 +3725,7 @@ static void sh_css_update_isp_mem_params_to_ddr(
 	IA_CSS_LEAVE_PRIVATE("void");
 }
 
-void ia_css_dequeue_param_buffers(/*unsigned int pipe_num*/)
+void ia_css_dequeue_param_buffers(/*unsigned int pipe_num*/ void)
 {
 	unsigned int i;
 	hrt_vaddress cpy;
-- 
2.9.0
