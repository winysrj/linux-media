Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38608 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbeBXSzi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 13:55:38 -0500
Received: by mail-wm0-f67.google.com with SMTP id z9so10253180wmb.3
        for <linux-media@vger.kernel.org>; Sat, 24 Feb 2018 10:55:38 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 01/12] [media] ngene: add two additional PCI IDs
Date: Sat, 24 Feb 2018 19:55:23 +0100
Message-Id: <20180224185534.13792-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180224185534.13792-1-d.scheller.oss@gmail.com>
References: <20180224185534.13792-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add two more device IDs for cards supported by the ngene driver.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/ngene-cards.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index bb49620540c5..49f78bb31537 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -749,6 +749,8 @@ static const struct ngene_info ngene_info_terratec = {
 /****************************************************************************/
 
 static const struct pci_device_id ngene_id_tbl[] = {
+	NGENE_ID(0x18c3, 0xab04, ngene_info_cineS2),
+	NGENE_ID(0x18c3, 0xab05, ngene_info_cineS2v5),
 	NGENE_ID(0x18c3, 0xabc3, ngene_info_cineS2),
 	NGENE_ID(0x18c3, 0xabc4, ngene_info_cineS2),
 	NGENE_ID(0x18c3, 0xdb01, ngene_info_satixS2),
-- 
2.16.1
