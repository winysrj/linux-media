Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35310 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753929AbeDVQG4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 12:06:56 -0400
Received: by mail-wr0-f193.google.com with SMTP id w3-v6so34725685wrg.2
        for <linux-media@vger.kernel.org>; Sun, 22 Apr 2018 09:06:56 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 2/2] [media] ngene: fix ci_tsfix modparam description typo
Date: Sun, 22 Apr 2018 18:06:52 +0200
Message-Id: <20180422160652.20173-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180422160652.20173-1-d.scheller.oss@gmail.com>
References: <20180422160652.20173-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

s/shifs/shifts/

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/ngene-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
index fee89b9ed9c1..5147e83397a1 100644
--- a/drivers/media/pci/ngene/ngene-dvb.c
+++ b/drivers/media/pci/ngene/ngene-dvb.c
@@ -40,7 +40,7 @@
 
 static int ci_tsfix = 1;
 module_param(ci_tsfix, int, 0444);
-MODULE_PARM_DESC(ci_tsfix, "Detect and fix TS buffer offset shifs in conjunction with CI expansions (default: 1/enabled)");
+MODULE_PARM_DESC(ci_tsfix, "Detect and fix TS buffer offset shifts in conjunction with CI expansions (default: 1/enabled)");
 
 /****************************************************************************/
 /* COMMAND API interface ****************************************************/
-- 
2.16.1
