Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.89.28.115]:55034 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaCMK3x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 06:29:53 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: <linux-media@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/3] rc: img-ir: hw: Remove unnecessary semi-colon
Date: Thu, 13 Mar 2014 10:29:21 +0000
Message-ID: <1394706563-31081-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1394706563-31081-1-git-send-email-james.hogan@imgtec.com>
References: <1394706563-31081-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a coccicheck warning in img-ir driver:
drivers/media/rc/img-ir/img-ir-hw.c:500:2-3: Unneeded semicolon

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
I don't object to this patch being squashed into the patch "rc: img-ir:
add hardware decoder driver".
---
 drivers/media/rc/img-ir/img-ir-hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index cbbfd7df649f..2abf78a89fc5 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -497,7 +497,7 @@ set_unlock:
 		break;
 	default:
 		ret = -EINVAL;
-	};
+	}
 
 unlock:
 	spin_unlock_irq(&priv->lock);
-- 
1.8.1.2

