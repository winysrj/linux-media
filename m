Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:59779 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbdGCMIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 08:08:21 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@iki.fi
Cc: linux-media@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH] [media] media: Make parameter of media_entity_remote_pad() const
Date: Mon,  3 Jul 2017 15:08:11 +0300
Message-Id: <1499083691-30112-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The local pad parameter in media_entity_remote_pad() is not modified.
Make that explicit by adding a const modifier.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/media-entity.c | 2 +-
 include/media/media-entity.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c68239e..60f9de0 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -854,7 +854,7 @@ struct media_link *
 }
 EXPORT_SYMBOL_GPL(media_entity_find_link);
 
-struct media_pad *media_entity_remote_pad(struct media_pad *pad)
+struct media_pad *media_entity_remote_pad(const struct media_pad *pad)
 {
 	struct media_link *link;
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index b2203ee..bb3a57c 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -804,7 +804,7 @@ struct media_link *media_entity_find_link(struct media_pad *source,
  * Return: returns a pointer to the pad at the remote end of the first found
  * enabled link, or %NULL if no enabled link has been found.
  */
-struct media_pad *media_entity_remote_pad(struct media_pad *pad);
+struct media_pad *media_entity_remote_pad(const struct media_pad *pad);
 
 /**
  * media_entity_get - Get a reference to the parent module
-- 
1.9.1
