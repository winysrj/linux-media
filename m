Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:57458 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033319AbdD0WnF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 18:43:05 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 1/2] media: entity: Add pad_from_dt_regs entity operation
Date: Fri, 28 Apr 2017 00:33:22 +0200
Message-Id: <20170427223323.13861-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The optional operation can be used by entities to report how it maps its
DT node ports and endpoints to media pad numbers. This is useful for
devices which require more advanced mappings of pads then DT port
number is equivalent with media port number.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/media/media-entity.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index c7c254c5bca1761b..47efaf4d825e671b 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -171,6 +171,9 @@ struct media_pad {
 
 /**
  * struct media_entity_operations - Media entity operations
+ * @pad_from_dt_regs:	Return the pad number based on DT port and reg
+ *			properties. This operation can be used to map a
+ *			DT port and reg to a media pad number. Optional.
  * @link_setup:		Notify the entity of link changes. The operation can
  *			return an error, in which case link setup will be
  *			cancelled. Optional.
@@ -184,6 +187,7 @@ struct media_pad {
  *    mutex held.
  */
 struct media_entity_operations {
+	int (*pad_from_dt_regs)(int port_reg, int reg, unsigned int *pad);
 	int (*link_setup)(struct media_entity *entity,
 			  const struct media_pad *local,
 			  const struct media_pad *remote, u32 flags);
-- 
2.12.2
