Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34557 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbbFEMid (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 08:38:33 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: sameo@linux.intel.com, aloisio.almeida@openbossa.org,
	lauro.venancio@openbossa.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Doc:nfc: Fix typo in nfc-hci.txt
Date: Fri,  5 Jun 2015 21:38:19 +0900
Message-Id: <1433507899-13387-1-git-send-email-standby24x7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix a spelling typo in nfc-hci.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/nfc/nfc-hci.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/nfc/nfc-hci.txt b/Documentation/nfc/nfc-hci.txt
index 0686c9e..0dc078c 100644
--- a/Documentation/nfc/nfc-hci.txt
+++ b/Documentation/nfc/nfc-hci.txt
@@ -122,7 +122,7 @@ This must be done from a context that can sleep.
 PHY Management
 --------------
 
-The physical link (i2c, ...) management is defined by the following struture:
+The physical link (i2c, ...) management is defined by the following structure:
 
 struct nfc_phy_ops {
 	int (*write)(void *dev_id, struct sk_buff *skb);
-- 
2.4.2.387.gf86f31a

