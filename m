Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579Ab2HGCsJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:09 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432709vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:48:08 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 21/24] xc5000: show debug version fields in decimal instead of hex
Date: Mon,  6 Aug 2012 22:47:11 -0400
Message-Id: <1344307634-11673-22-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver prints out a dotted version number but it's in hex.  As a result,
the version doesn't visibly match the filename for the firmware, and
it caused a bunch of confusion while discussing different versions with the
chip manufacturer.

Change the firmware printout to be in decimal.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/common/tuners/xc5000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 3e5f8cd..4bb20fa 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -702,7 +702,7 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	xc_get_version(priv,  &hw_majorversion, &hw_minorversion,
 		&fw_majorversion, &fw_minorversion);
 	xc_get_buildversion(priv,  &fw_buildversion);
-	dprintk(1, "*** HW: V%02x.%02x, FW: V%02x.%02x.%04x\n",
+	dprintk(1, "*** HW: V%d.%d, FW: V %d.%d.%d\n",
 		hw_majorversion, hw_minorversion,
 		fw_majorversion, fw_minorversion, fw_buildversion);
 
-- 
1.7.1

