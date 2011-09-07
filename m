Return-path: <linux-media-owner@vger.kernel.org>
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:13978 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab1IGQOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Sep 2011 12:14:52 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCH] mmp_camera: add MODULE_ALIAS
Message-Id: <20110907093646.DA5AA9D401C@zog.reactivated.net>
Date: Wed,  7 Sep 2011 10:36:46 +0100 (BST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enables module autoloading.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/marvell-ccic/mmp-driver.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/video/marvell-ccic/mmp-driver.c
index d6b7645..fb0b124 100644
--- a/drivers/media/video/marvell-ccic/mmp-driver.c
+++ b/drivers/media/video/marvell-ccic/mmp-driver.c
@@ -29,6 +29,7 @@
 
 #include "mcam-core.h"
 
+MODULE_ALIAS("platform:mmp-camera");
 MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
 MODULE_LICENSE("GPL");
 
-- 
1.7.6

