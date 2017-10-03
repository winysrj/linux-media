Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38831 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbdJCLos (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 07:44:48 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: gregkh@linuxfoundation.org, jacobvonchorus@cwphoto.ca,
        mchehab@kernel.org, eric@anholt.net, stefan.wahren@i2se.com,
        f.fainelli@gmail.com, rjui@broadcom.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 1/4] staging: gs_fpgaboot: pr_err() strings should end with newlines
Date: Tue,  3 Oct 2017 17:13:23 +0530
Message-Id: <1507031006-16543-2-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1507031006-16543-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1507031006-16543-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pr_err() messages should end with a new-line to avoid other messages
being concatenated.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index bcbdc73..fa8b27e 100644
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
+++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
@@ -106,7 +106,7 @@ static int readmagic_bitstream(u8 *bitdata, int *offset)
 	read_bitstream(bitdata, buf, offset, 13);
 	r = memcmp(buf, bits_magic, 13);
 	if (r) {
-		pr_err("error: corrupted header");
+		pr_err("error: corrupted header\n");
 		return -EINVAL;
 	}
 	pr_info("bitstream file magic number Ok\n");
-- 
1.9.1
