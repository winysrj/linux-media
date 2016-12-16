Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36586 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933039AbcLPVb4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 16:31:56 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] [media] bt8xx: fix memory leak
Date: Fri, 16 Dec 2016 21:31:49 +0000
Message-Id: <1481923909-5418-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If dvb_attach() fails then we were just printing an error message and
exiting but the memory allocated to state was not released.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/media/pci/bt8xx/dvb-bt8xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
index 6100fa7..e247638 100644
--- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
@@ -683,6 +683,7 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 		/*	DST is not a frontend, attaching the ASIC	*/
 		if (dvb_attach(dst_attach, state, &card->dvb_adapter) == NULL) {
 			pr_err("%s: Could not find a Twinhan DST\n", __func__);
+			kfree(state);
 			break;
 		}
 		/*	Attach other DST peripherals if any		*/
-- 
1.9.1

