Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:43789 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754659AbdDLSU6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:20:58 -0400
Subject: [PATCH 03/14] staging: atomisp: remove enable_isp_irq function and
 add disable_isp_irq
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:20:22 +0100
Message-ID: <149202121717.16615.8267343060617686506.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daeseok Youn <daeseok.youn@gmail.com>

Enable/Disable ISP irq is switched with "enable" parameter of
enable_isp_irq(). It would be better splited to two such as
enable_isp_irq()/disable_isp_irq().

But the enable_isp_irq() is no use in atomisp_cmd.c file.
So remove the enable_isp_irq() function and add
disable_isp_irq function only.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |   36 +++++---------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 9ad5146..08606cb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -376,34 +376,16 @@ int atomisp_reset(struct atomisp_device *isp)
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
@@ -1416,7 +1398,7 @@ static void __atomisp_css_recover(struct atomisp_device *isp, bool isp_timeout)
 	}
 
 	/* clear irq */
-	enable_isp_irq(hrt_isp_css_irq_sp, false);
+	disable_isp_irq(hrt_isp_css_irq_sp);
 	clear_isp_irq(hrt_isp_css_irq_sp);
 
 	/* Set the SRSE to 3 before resetting */
