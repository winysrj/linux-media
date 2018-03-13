Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41730 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753052AbeCMSFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:05:42 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 02/11] media: vsp1: Remove packed attributes from aligned structures
Date: Tue, 13 Mar 2018 19:05:18 +0100
Message-Id: <30abb41033b9670c06a54ff484d61d25d3c6e5cd.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
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

 drivers/media/platform/vsp1/vsp1_dl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 37e2c984fbf3..85795b55a357 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -29,19 +29,19 @@
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
