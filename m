Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34888 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751380AbeECNg3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 09:36:29 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 02/11] media: vsp1: Remove packed attributes from aligned structures
Date: Thu,  3 May 2018 14:36:13 +0100
Message-Id: <d8f8e86a4e89a48150fae5cc4ee4bb977a13c196.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The use of the packed attribute can cause a performance penalty for
all accesses to the struct members, as the compiler will assume that the
structure has the potential to have an unaligned base.

These structures are all correctly aligned and contain no holes, thus
the attribute is redundant and negatively impacts performance, so we
remove the attributes entirely.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
v2
 - Remove attributes entirely
---
 drivers/media/platform/vsp1/vsp1_dl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index c7fa1cb088cd..f4cede9b9b43 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -25,19 +25,19 @@
 struct vsp1_dl_header_list {
 	u32 num_bytes;
 	u32 addr;
-} __attribute__((__packed__));
+};
 
 struct vsp1_dl_header {
 	u32 num_lists;
 	struct vsp1_dl_header_list lists[8];
 	u32 next_header;
 	u32 flags;
-} __attribute__((__packed__));
+};
 
 struct vsp1_dl_entry {
 	u32 addr;
 	u32 data;
-} __attribute__((__packed__));
+};
 
 /**
  * struct vsp1_dl_body - Display list body
-- 
git-series 0.9.1
