Return-path: <linux-media-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:59707 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755221AbcCPNBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 09:01:31 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] [media] media-device: make topology_version u64
Date: Wed, 16 Mar 2016 10:00:38 -0300
Message-Id: <4f08b737b76f0045ca843cd8e283f7adc5c59b6d.1458133227.git.mchehab@osg.samsung.com>
In-Reply-To: <907cfedffb3524aeffcdfde0efe3f23f2eb70dd1.1458133227.git.mchehab@osg.samsung.com>
References: <907cfedffb3524aeffcdfde0efe3f23f2eb70dd1.1458133227.git.mchehab@osg.samsung.com>
In-Reply-To: <907cfedffb3524aeffcdfde0efe3f23f2eb70dd1.1458133227.git.mchehab@osg.samsung.com>
References: <907cfedffb3524aeffcdfde0efe3f23f2eb70dd1.1458133227.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The uAPI defines it with 64 bits. Let's change the Kernel
implementation too.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/media/media-device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index 9166bff8068e..4a475604d992 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -358,7 +358,7 @@ struct media_device {
 	u32 hw_revision;
 	u32 driver_version;
 
-	u32 topology_version;
+	u64 topology_version;
 
 	u32 id;
 	struct ida entity_internal_idx;
-- 
2.5.0

