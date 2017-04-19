Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:36361 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940326AbdDSXOl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:41 -0400
Received: by mail-qt0-f180.google.com with SMTP id g60so32567923qtd.3
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:36 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 11/12] Fix breakage in "make menuconfig" for media_build
Date: Wed, 19 Apr 2017 19:13:54 -0400
Message-Id: <1492643635-30823-12-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Kconfig format is strict enough where if the indentation isn't
correct then the "make menuconfig" will break.

Fix the indentation to match all the other entries.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/rc/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index e422f3d..5e83b76 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -169,11 +169,11 @@ config IR_HIX5HD2
 	tristate "Hisilicon hix5hd2 IR remote control"
 	depends on RC_CORE
 	help
-	 Say Y here if you want to use hisilicon hix5hd2 remote control.
-	 To compile this driver as a module, choose M here: the module will be
-	 called ir-hix5hd2.
+	   Say Y here if you want to use hisilicon hix5hd2 remote control.
+	   To compile this driver as a module, choose M here: the module will be
+	   called ir-hix5hd2.
 
-	 If you're not sure, select N here
+	   If you're not sure, select N here
 
 config IR_IMON
 	tristate "SoundGraph iMON Receiver and Display"
-- 
1.9.1
