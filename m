Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47250 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbbF2Tm1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 15:42:27 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>
Subject: [Patch 1/1] media: am437x-vpfe: Requested frame size and fmt overwritten by current sensor setting
Date: Mon, 29 Jun 2015 14:42:20 -0500
Message-ID: <1435606940-2321-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Upon a S_FMT the input/requeated frame size and pixel format is
overwritten by the current subdevice settings.
Fix this so application can actually set the frame size and format.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
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

