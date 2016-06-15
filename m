Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:44929 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbcFOUY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 16:24:27 -0400
Subject: [PATCH 2/3] drivers/media/media-entity: clear media_gobj.mdev in
 _destroy()
From: Max Kellermann <max@duempel.org>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Jun 2016 22:15:07 +0200
Message-ID: <146602170722.9818.9277146367995018321.stgit@woodpecker.blarg.de>
In-Reply-To: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_gobj_destroy() may be called twice on one instance - once by
media_device_unregister() and again by dvb_media_device_free().  The
function media_remove_intf_links() establishes and documents the
convention that mdev==NULL means that the object is not registered,
but nobody ever NULLs this variable.  So this patch really implements
this behavior, and adds another mdev==NULL check to
media_gobj_destroy() to protect against double removal.

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/media-entity.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index d8a2299..9526338 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -203,10 +203,16 @@ void media_gobj_destroy(struct media_gobj *gobj)
 {
 	dev_dbg_obj(__func__, gobj);
 
+	/* Do nothing if the object is not linked. */
+	if (gobj->mdev == NULL)
+		return;
+
 	gobj->mdev->topology_version++;
 
 	/* Remove the object from mdev list */
 	list_del(&gobj->list);
+
+	gobj->mdev = NULL;
 }
 
 int media_entity_pads_init(struct media_entity *entity, u16 num_pads,

