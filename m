Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35993 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbDBU1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2015 16:27:00 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] [media] fc0013: remove unneeded test
Date: Thu,  2 Apr 2015 22:33:28 +0200
Message-Id: <1428006808-16981-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The same code is executed if ret is true or false, so this test can
be removed.
Fix Coverity CID 1268782.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/media/tuners/fc0013.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/tuners/fc0013.c b/drivers/media/tuners/fc0013.c
index b416231..522690d 100644
--- a/drivers/media/tuners/fc0013.c
+++ b/drivers/media/tuners/fc0013.c
@@ -217,8 +217,6 @@ static int fc0013_set_vhf_track(struct fc0013_priv *priv, u32 freq)
 	} else {			/* UHF and GPS */
 		ret = fc0013_writereg(priv, 0x1d, tmp | 0x1c);
 	}
-	if (ret)
-		goto error_out;
 error_out:
 	return ret;
 }
-- 
2.1.4

