Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:40240 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbcKZToB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 14:44:01 -0500
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] [media] tw686x: silent -Wformat-security warning
Date: Sat, 26 Nov 2016 20:43:50 +0100
Message-Id: <20161126194350.23177-1-nicolas.iooss_linux@m4x.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using sprintf() with a non-literal string makes some compiler complain
when building with -Wformat-security (eg. clang reports "format string
is not a string literal (potentially insecure)").

Here sprintf() format parameter is indirectly a literal string so there
is no security issue.  Nevertheless adding a "%s" format string to
silent the warning helps to detect real bugs in the kernel.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/media/pci/tw686x/tw686x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
index 71a0453b1af1..336e2f9bc1b6 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -74,7 +74,7 @@ static const char *dma_mode_name(unsigned int mode)
 
 static int tw686x_dma_mode_get(char *buffer, struct kernel_param *kp)
 {
-	return sprintf(buffer, dma_mode_name(dma_mode));
+	return sprintf(buffer, "%s", dma_mode_name(dma_mode));
 }
 
 static int tw686x_dma_mode_set(const char *val, struct kernel_param *kp)
-- 
2.10.2

