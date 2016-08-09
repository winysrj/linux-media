Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:60456 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378AbcHIVlp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:45 -0400
Subject: [PATCH 11/12] [media] media-entity: clear media_gobj.mdev in
 _destroy()
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:57 +0200
Message-ID: <147077837761.21835.15641401024739733305.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
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

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
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

