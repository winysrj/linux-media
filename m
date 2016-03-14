Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:40696 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbcCNWYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 18:24:30 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: Update documentation for media_entity_notify
Date: Mon, 14 Mar 2016 16:24:25 -0600
Message-Id: <1457994265-5349-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update documentation for media_entity_notify to clearly state the usage
restrictions. This handler is intended for creating links between exiting
entities and should not used to create and register entities.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 include/media/media-device.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index d9867ed..2ca9616 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -271,8 +271,10 @@ struct device;
  * @notify_data: Input data to invoke the callback
  * @notify: Callback function pointer
  *
- * Drivers may register a callback to take action when
- * new entities get registered with the media device.
+ * Drivers may register a callback to take action when new entities get
+ * registered with the media device. This handler is intended for creating
+ * links between existing entities and should not create entities and register
+ * them.
  */
 struct media_entity_notify {
 	struct list_head list;
-- 
2.5.0

