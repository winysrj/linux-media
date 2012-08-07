Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2HGCsM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:12 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:48:12 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: [PATCH 24/24] xc5000: change filename to production/redistributable xc5000c firmware
Date: Mon,  6 Aug 2012 22:47:14 -0400
Message-Id: <1344307634-11673-25-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original xc5000c driver support was based on a beta version of the
firmware, and there were no redistribution rights.  Change over to using the
release version, for which freely redistributable firmware can be found here:

http://kernellabs.com/firmware/xc5000/README.xc5000c
http://kernellabs.com/firmware/xc5000/dvb-fe-xc5000c-4.1.30.7.fw

Thanks to Ramon Cazares from Cresta Technology for making the firmware
available as well as working out the licensing issues.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Michael Krufky <mkrufky@kernellabs.com>
---
 drivers/media/common/tuners/xc5000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 4bb20fa..3f7327c 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -226,7 +226,7 @@ static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
 };
 
 static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
-	.name = "dvb-fe-xc5000c-41.024.5.fw",
+	.name = "dvb-fe-xc5000c-4.1.30.7.fw",
 	.size = 16497,
 	.pll_reg = 0x13,
 	.init_status_supported = 1,
-- 
1.7.1

