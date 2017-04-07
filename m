Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35122 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752245AbdDGGAU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 02:00:20 -0400
Date: Fri, 7 Apr 2017 14:56:04 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] staging: atomisp: remove enable_isp_irq function and add
 disable_isp_irq
Message-ID: <20170407055604.GA32049@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable/Disable ISP irq is switched with "enable" parameter of
enable_isp_irq(). It would be better splited to two such as
enable_isp_irq()/disable_isp_irq().

But the enable_isp_irq() is no use in atomisp_cmd.c file.
So remove the enable_isp_irq() function and add
disable_isp_irq function only.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
This series of patches are related to previous patches:
[1] https://lkml.org/lkml/2017/3/27/159
[2] https://lkml.org/lkml/2017/3/30/1068
[3] https://lkml.org/lkml/2017/3/30/1069

 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 36 ++++++----------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 0ba5d8b..c3d0596 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -375,34 +375,16 @@ int atomisp_reset(struct atomisp_device *isp)
 }
 
 /*
- * interrupt enable/disable functions
+ * interrupt disable functions
  */
-static void enable_isp_irq(enum hrt_isp_css_irq irq, bool enable)
-{
-	if (enable) {
-		irq_enable_channel(IRQ0_ID, irq);
-		/*sh_css_hrt_irq_enable(irq, true, false);*/
-		switch (irq) { /*We only have sp interrupt right now*/
-		case hrt_isp_css_irq_sp:
-			/*sh_css_hrt_irq_enable_sp(true);*/
-			cnd_sp_irq_enable(SP0_ID, true);
-			break;
-		default:
-			break;
-		}
+static void disable_isp_irq(enum hrt_isp_css_irq irq)
+{
+	irq_disable_channel(IRQ0_ID, irq);
 
-	} else {
-		/*sh_css_hrt_irq_disable(irq);*/
-		irq_disable_channel(IRQ0_ID, irq);
-		switch (irq) {
-		case hrt_isp_css_irq_sp:
-			/*sh_css_hrt_irq_enable_sp(false);*/
-			cnd_sp_irq_enable(SP0_ID, false);
-			break;
-		default:
-			break;
-		}
-	}
+	if (irq != hrt_isp_css_irq_sp)
+		return;
+
+	cnd_sp_irq_enable(SP0_ID, false);
 }
 
 /*
@@ -1415,7 +1397,7 @@ static void __atomisp_css_recover(struct atomisp_device *isp, bool isp_timeout)
 	}
 
 	/* clear irq */
-	enable_isp_irq(hrt_isp_css_irq_sp, false);
+	disable_isp_irq(hrt_isp_css_irq_sp);
 	clear_isp_irq(hrt_isp_css_irq_sp);
 
 	/* Set the SRSE to 3 before resetting */
-- 
1.9.1
