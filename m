Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47428 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965028AbbLOKJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 05:09:28 -0500
Date: Tue, 15 Dec 2015 13:09:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] media_entity: logical vs bitwise AND typo
Message-ID: <20151215100908.GD20848@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was obviously supposed to be a bitwise AND.

Fixes: 403da6ca3465 ('[media] media: move MEDIA_LNK_FL_INTERFACE_LINK logic to link creation')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 7895e17..6926e06 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -526,7 +526,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 
 	link->source = &source->pads[source_pad];
 	link->sink = &sink->pads[sink_pad];
-	link->flags = flags && ~MEDIA_LNK_FL_INTERFACE_LINK;
+	link->flags = flags & ~MEDIA_LNK_FL_INTERFACE_LINK;
 
 	/* Initialize graph object embedded at the new link */
 	media_gobj_create(source->graph_obj.mdev, MEDIA_GRAPH_LINK,
