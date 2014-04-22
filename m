Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55789 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaDVTwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 15:52:08 -0400
Date: Tue, 22 Apr 2014 21:52:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pavel@ucw.cz, hans.verkuil@cisco.com, m.chehab@samsung.com,
	ext-eero.nurkkala@nokia.com, nils.faerber@kernelconcepts.de,
	joni.lapilainen@gmail.com, freemangordon@abv.bg, sre@ring0.de,
	dan.carpenter@oracle.com, pali.rohar@gmail.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCHv2] radio-bcm2048.c: fix wrong overflow check
Message-ID: <20140422195206.GA32663@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pali Rohár <pali.rohar@gmail.com>

Fix wrong overflow check in radio-bcm2048.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---

Nothing in patch changed, just added CCs, and From/Reported-by headers.

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index b2cd3a8..bbf236e 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -737,7 +737,7 @@ static int bcm2048_set_region(struct bcm2048_device *bdev, u8 region)
 	int err;
 	u32 new_frequency = 0;
 
-	if (region > ARRAY_SIZE(region_configs))
+	if (region >= ARRAY_SIZE(region_configs))
 		return -EINVAL;
 
 	mutex_lock(&bdev->mutex);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

