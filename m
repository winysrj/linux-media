Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38254 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751902AbdJCLov (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 07:44:51 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: gregkh@linuxfoundation.org, jacobvonchorus@cwphoto.ca,
        mchehab@kernel.org, eric@anholt.net, stefan.wahren@i2se.com,
        f.fainelli@gmail.com, rjui@broadcom.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 2/4] staging: media: davinci_vpfe: pr_err() strings should end with newlines
Date: Tue,  3 Oct 2017 17:13:24 +0530
Message-Id: <1507031006-16543-3-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1507031006-16543-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1507031006-16543-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pr_err() messages should end with a new-line to avoid other messages
being concatenated.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
index a893072..8cfe873 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
@@ -268,7 +268,7 @@ int config_ipipe_hw(struct vpfe_ipipe_device *ipipe)
 
 	ipipe_mode = get_ipipe_mode(ipipe);
 	if (ipipe_mode < 0) {
-		pr_err("Failed to get ipipe mode");
+		pr_err("Failed to get ipipe mode\n");
 		return -EINVAL;
 	}
 	regw_ip(ipipe_base, ipipe_mode, IPIPE_SRC_MODE);
-- 
1.9.1
