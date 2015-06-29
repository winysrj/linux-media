Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33015 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbbF2Uuz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 16:50:55 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>, <stable@vger.kernel.org>
Subject: [Patch v2 1/1] media: am437x-vpfe: Requested frame size and fmt overwritten by current sensor setting
Date: Mon, 29 Jun 2015 15:50:49 -0500
Message-ID: <1435611049-3196-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Upon a S_FMT the input/requested frame size and pixel format is
overwritten by the current sub-device settings.
Fix this so application can actually set the frame size and format.

Fixes: 417d2e507ed [media] media: platform: add VPFE capture driver support for AM437X
Cc: <stable@vger.kernel.org> # v4.0+
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
Changes from v1:
- Added stable reference

 drivers/media/platform/am437x/am437x-vpfe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index eb25c43..0fa62c5 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1584,7 +1584,7 @@ static int vpfe_s_fmt(struct file *file, void *priv,
 		return -EBUSY;
 	}
 
-	ret = vpfe_try_fmt(file, priv, fmt);
+	ret = vpfe_try_fmt(file, priv, &format);
 	if (ret)
 		return ret;
 
-- 
1.8.5.1

