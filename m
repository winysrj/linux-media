Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:57494 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729684AbeGQVKW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 17:10:22 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v5 02/11] media: vsp1: Remove packed attributes from aligned structures
Date: Tue, 17 Jul 2018 21:35:44 +0100
Message-Id: <bbb67734d09bc37971ce323570dfb085b7fec0dd.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6efe8ff8efecd736e2aab039b2cf34d43e849939.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6efe8ff8efecd736e2aab039b2cf34d43e849939.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6efe8ff8efecd736e2aab039b2cf34d43e849939.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6efe8ff8efecd736e2aab039b2cf34d43e849939.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The use of the packed attribute can cause a performance penalty for
all accesses to the struct members, as the compiler will assume that the
structure has the potential to have an unaligned base.

These structures are all correctly aligned and contain no holes, thus
the attribute is redundant and negatively impacts performance, so we
remove the attributes entirely.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2
 - Remove attributes entirely

 drivers/media/platform/vsp1/vsp1_dl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index d9b9cdd8fbe2..5da7988dd616 100644
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
