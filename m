Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:36026 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbdGQKe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 06:34:59 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 01/23] [media] media: Make parameter of media_entity_remote_pad() const
Date: Mon, 17 Jul 2017 13:33:27 +0300
Message-Id: <1500287629-23703-2-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The local pad parameter in media_entity_remote_pad() is not modified.
Make that explicit by adding a const modifier.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 2 +-
 include/media/media-entity.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index dd0f0ea..2ace041 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -917,7 +917,7 @@ media_entity_find_link(struct media_pad *source, struct media_pad *sink)
 }
 EXPORT_SYMBOL_GPL(media_entity_find_link);
 
-struct media_pad *media_entity_remote_pad(struct media_pad *pad)
+struct media_pad *media_entity_remote_pad(const struct media_pad *pad)
 {
 	struct media_link *link;
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 754182d..222d379 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -805,7 +805,7 @@ struct media_link *media_entity_find_link(struct media_pad *source,
  * Return: returns a pointer to the pad at the remote end of the first found
  * enabled link, or %NULL if no enabled link has been found.
  */
-struct media_pad *media_entity_remote_pad(struct media_pad *pad);
+struct media_pad *media_entity_remote_pad(const struct media_pad *pad);
 
 /**
  * media_entity_get - Get a reference to the parent module
-- 
2.7.4
