Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030364AbbD1PoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:24 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Tomas Melin <tomas.melin@iki.fi>,
	Markus Elfring <elfring@users.sourceforge.net>,
	James Hogan <james.hogan@imgtec.com>,
	"Marcel J.E. Mol" <marcel@mesa.nl>
Subject: [PATCH 01/14] rc: fix bad indenting
Date: Tue, 28 Apr 2015 12:43:40 -0300
Message-Id: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/rc/rc-main.c:749 rc_close() warn: inconsistent indenting

There's an extra space there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f8c5e47a30aa..0ff388a16168 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -746,7 +746,7 @@ void rc_close(struct rc_dev *rdev)
 	if (rdev) {
 		mutex_lock(&rdev->lock);
 
-		 if (!--rdev->users && rdev->close != NULL)
+		if (!--rdev->users && rdev->close != NULL)
 			rdev->close(rdev);
 
 		mutex_unlock(&rdev->lock);
-- 
2.1.0

