Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:33729 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbcCMAhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2016 19:37:08 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: add dump_stack() if called in atomic context
Date: Sat, 12 Mar 2016 17:37:05 -0700
Message-Id: <1457829425-4411-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change media_add_link() and media_devnode_create() to dump_stack when
called in atomic context.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e95070b..66a5392 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -570,6 +570,9 @@ static struct media_link *media_add_link(struct list_head *head)
 {
 	struct media_link *link;
 
+	if (in_atomic())
+		dump_stack();
+
 	link = kzalloc(sizeof(*link), GFP_KERNEL);
 	if (link == NULL)
 		return NULL;
@@ -891,6 +894,9 @@ struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
 {
 	struct media_intf_devnode *devnode;
 
+	if (in_atomic())
+		dump_stack();
+
 	devnode = kzalloc(sizeof(*devnode), GFP_KERNEL);
 	if (!devnode)
 		return NULL;
-- 
2.5.0

