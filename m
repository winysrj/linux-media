Return-path: <linux-media-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:39055 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965780AbcCPMFC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 08:05:02 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 2/5] [media] media-device: Fix a comment
Date: Wed, 16 Mar 2016 09:04:03 -0300
Message-Id: <5b7aab28416452575f9b36ea08e7906784a6b8a6.1458129823.git.mchehab@osg.samsung.com>
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comment is for the wrong function. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/media/media-device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index 0c2de97181f3..ca3871b853ba 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -490,7 +490,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 #define media_device_register(mdev) __media_device_register(mdev, THIS_MODULE)
 
 /**
- * __media_device_unregister() - Unegisters a media device element
+ *_media_device_unregister() - Unegisters a media device element
  *
  * @mdev:	pointer to struct &media_device
  *
-- 
2.5.0

