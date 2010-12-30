Return-path: <mchehab@gaivota>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64019 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0L3XI2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 18:08:28 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	spi-devel-general@lists.sourceforge.net,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 07/15]drivers:net:wireless:iwlwifi Typo change diable to disable.
Date: Thu, 30 Dec 2010 15:07:56 -0800
Message-Id: <1293750484-1161-7-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1293750484-1161-6-git-send-email-justinmattock@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-4-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-5-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-6-git-send-email-justinmattock@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The below patch fixes a typo "diable" to "disable". Please let me know if this 
is correct or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
index a5dbfea..b5cb3be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -197,7 +197,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 
  none:
 	/* re-enable interrupts here since we don't have anything to service. */
-	/* only Re-enable if diabled by irq  and no schedules tasklet. */
+	/* only Re-enable if disabled by irq  and no schedules tasklet. */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->_agn.inta)
 		iwl_enable_interrupts(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c2636a7..9b912c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1316,7 +1316,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	}
 
 	/* Re-enable all interrupts */
-	/* only Re-enable if diabled by irq */
+	/* only Re-enable if disabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
 
@@ -1530,7 +1530,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	}
 
 	/* Re-enable all interrupts */
-	/* only Re-enable if diabled by irq */
+	/* only Re-enable if disabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 25fb391..8700ab3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1304,7 +1304,7 @@ irqreturn_t iwl_isr_legacy(int irq, void *data)
 
  none:
 	/* re-enable interrupts here since we don't have anything to service. */
-	/* only Re-enable if diabled by irq */
+	/* only Re-enable if disabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.6.5.2.180.gc5b3e

