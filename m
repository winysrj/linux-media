Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34152 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756557AbcLPSAF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 13:00:05 -0500
Received: by mail-lf0-f67.google.com with SMTP id 30so424317lfy.1
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2016 10:00:04 -0800 (PST)
From: henrik@austad.us
To: linux-kernel@vger.kernel.org
Cc: Richard Cochran <richardcochran@gmail.com>, henrik@austad.us,
        linux-media@vger.kernel.org, alsa-devel@vger.kernel.org,
        netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, Henrik Austad <haustad@cisco.com>
Subject: [TSN RFC v2 1/9] igb: add missing fields to TXDCTL-register
Date: Fri, 16 Dec 2016 18:59:05 +0100
Message-Id: <1481911153-549-2-git-send-email-henrik@austad.us>
In-Reply-To: <1481911153-549-1-git-send-email-henrik@austad.us>
References: <1481911153-549-1-git-send-email-henrik@austad.us>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Henrik Austad <henrik@austad.us>

The current list of E1000_TXDCTL-registers is incomplete. This adds the
missing parts for the Transmit Descriptor Control (TXDCTL) register.

The rest of these values (threshold for descriptor read/write) for
TXDCTL seems to be defined in igb/igb.h, not sure why this is split
though.

It seems that this was left out in the commit that added support for
82575 Gigabit Ethernet driver 9d5c8243 (igb: PCI-Express 82575 Gigabit
Ethernet driver).

Cc: linux-kernel@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 drivers/net/ethernet/intel/igb/e1000_82575.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.h b/drivers/net/ethernet/intel/igb/e1000_82575.h
index acf0605..7faa482 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.h
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.h
@@ -158,7 +158,11 @@ struct e1000_adv_tx_context_desc {
 
 /* Additional Transmit Descriptor Control definitions */
 #define E1000_TXDCTL_QUEUE_ENABLE  0x02000000 /* Enable specific Tx Queue */
+
+/* Transmit Software Flush, sw-triggered desc writeback */
+#define E1000_TXDCTL_SWFLSH        0x04000000
 /* Tx Queue Arbitration Priority 0=low, 1=high */
+#define E1000_TXDCTL_PRIORITY      0x08000000
 
 /* Additional Receive Descriptor Control definitions */
 #define E1000_RXDCTL_QUEUE_ENABLE  0x02000000 /* Enable specific Rx Queue */
-- 
2.7.4

