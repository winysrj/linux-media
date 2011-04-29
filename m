Return-path: <mchehab@pedra>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:45462 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760994Ab1D2WFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 18:05:44 -0400
From: Daniel Drake <dsd@laptop.org>
To: corbet@lwn.net
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] via-camera: add MODULE_ALIAS
Message-Id: <20110429214501.7AAD39D401D@zog.reactivated.net>
Date: Fri, 29 Apr 2011 22:45:01 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This fixes autoloading of the module.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/via-camera.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index 8c780c2..85d3048 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -29,6 +29,7 @@
 
 #include "via-camera.h"
 
+MODULE_ALIAS("platform:viafb-camera");
 MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
 MODULE_DESCRIPTION("VIA framebuffer-based camera controller driver");
 MODULE_LICENSE("GPL");
-- 
1.7.4.4

