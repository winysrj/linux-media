Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36450 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdBTXbO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 18:31:14 -0500
Received: by mail-it0-f67.google.com with SMTP id w185so7099191ita.3
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 15:31:13 -0800 (PST)
From: David Cako <dc@cako.io>
To: linux-media@vger.kernel.org
Cc: David Cako <dc@cako.io>
Subject: [PATCH] rtl8188eu: style: spaces to tabs
Date: Mon, 20 Feb 2017 16:31:04 -0700
Message-Id: <1487633464-160680-1-git-send-email-dc@cako.io>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/staging/rtl8188eu/core/rtw_recv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index f2021fe..8c715af 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -32,11 +32,11 @@ static u8 SNAP_ETH_TYPE_APPLETALK_AARP[2] = {0x80, 0xf3};
 
 /* Bridge-Tunnel header (for EtherTypes ETH_P_AARP and ETH_P_IPX) */
 static u8 rtw_bridge_tunnel_header[] = {
-       0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8
+	0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8
 };
 
 static u8 rtw_rfc1042_header[] = {
-       0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00
+	0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00
 };
 
 static void rtw_signal_stat_timer_hdl(unsigned long data);
-- 
2.7.4
