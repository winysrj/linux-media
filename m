Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33136 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbdJCLo7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 07:44:59 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: gregkh@linuxfoundation.org, jacobvonchorus@cwphoto.ca,
        mchehab@kernel.org, eric@anholt.net, stefan.wahren@i2se.com,
        f.fainelli@gmail.com, rjui@broadcom.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 4/4] staging: rtlwifi: pr_err() strings should end with newlines
Date: Tue,  3 Oct 2017 17:13:26 +0530
Message-Id: <1507031006-16543-5-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1507031006-16543-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1507031006-16543-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pr_err() messages should end with a new-line to avoid other messages
being concatenated.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c | 6 +++---
 drivers/staging/rtlwifi/rtl8822be/phy.c                       | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c b/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c
index f33024e..eeef8b6 100644
--- a/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c
+++ b/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c
@@ -1036,7 +1036,7 @@ enum halmac_ret_status
 		if (halmac_send_fwpkt_88xx(
 			    halmac_adapter, code_ptr + mem_offset,
 			    send_pkt_size) != HALMAC_RET_SUCCESS) {
-			pr_err("halmac_send_fwpkt_88xx fail!!");
+			pr_err("halmac_send_fwpkt_88xx fail!!\n");
 			return HALMAC_RET_DLFW_FAIL;
 		}
 
@@ -1046,7 +1046,7 @@ enum halmac_ret_status
 				    halmac_adapter->hw_config_info.txdesc_size,
 			    dest + mem_offset, send_pkt_size,
 			    first_part) != HALMAC_RET_SUCCESS) {
-			pr_err("halmac_iddma_dlfw_88xx fail!!");
+			pr_err("halmac_iddma_dlfw_88xx fail!!\n");
 			return HALMAC_RET_DLFW_FAIL;
 		}
 
@@ -1057,7 +1057,7 @@ enum halmac_ret_status
 
 	if (halmac_check_fw_chksum_88xx(halmac_adapter, dest) !=
 	    HALMAC_RET_SUCCESS) {
-		pr_err("halmac_check_fw_chksum_88xx fail!!");
+		pr_err("halmac_check_fw_chksum_88xx fail!!\n");
 		return HALMAC_RET_DLFW_FAIL;
 	}
 
diff --git a/drivers/staging/rtlwifi/rtl8822be/phy.c b/drivers/staging/rtlwifi/rtl8822be/phy.c
index 4cba2ad..921226b 100644
--- a/drivers/staging/rtlwifi/rtl8822be/phy.c
+++ b/drivers/staging/rtlwifi/rtl8822be/phy.c
@@ -890,7 +890,7 @@ bool rtl8822be_load_txpower_by_rate(struct ieee80211_hw *hw)
 	rtstatus = rtlpriv->phydm.ops->phydm_load_txpower_by_rate(rtlpriv);
 
 	if (!rtstatus) {
-		pr_err("BB_PG Reg Fail!!");
+		pr_err("BB_PG Reg Fail!!\n");
 		return false;
 	}
 
@@ -915,7 +915,7 @@ bool rtl8822be_load_txpower_limit(struct ieee80211_hw *hw)
 	rtstatus = rtlpriv->phydm.ops->phydm_load_txpower_limit(rtlpriv);
 
 	if (!rtstatus) {
-		pr_err("RF TxPwr Limit Fail!!");
+		pr_err("RF TxPwr Limit Fail!!\n");
 		return false;
 	}
 
-- 
1.9.1
