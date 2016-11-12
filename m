Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49854 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966517AbcKLR07 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 12:26:59 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] zoran: fix spelling mistake in dprintk message
Date: Sat, 12 Nov 2016 17:26:48 +0000
Message-Id: <20161112172648.7756-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake "unnsupported" to "unsupported"
in debug message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/zoran/zoran_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index d6b631a..2170e17 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -1488,7 +1488,7 @@ zoran_set_input (struct zoran *zr,
 	if (input < 0 || input >= zr->card.inputs) {
 		dprintk(1,
 			KERN_ERR
-			"%s: %s - unnsupported input %d\n",
+			"%s: %s - unsupported input %d\n",
 			ZR_DEVNAME(zr), __func__, input);
 		return -EINVAL;
 	}
-- 
2.10.2

