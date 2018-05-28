Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38114 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033596AbeE1KYZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 06:24:25 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH] media: vsp1: Document vsp1_dl_body refcnt
Date: Mon, 28 May 2018 11:24:20 +0100
Message-Id: <20180528102420.19150-1-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In commit 2d9445db0ee9 ("media: vsp1: Use reference counting for
bodies"), a new field was introduced to the vsp1_dl_body structure to
account for usage tracking of the body.

Document the newly added field in the kerneldoc.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index d9b9cdd8fbe2..10a24bde2299 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -43,6 +43,7 @@ struct vsp1_dl_entry {
  * struct vsp1_dl_body - Display list body
  * @list: entry in the display list list of bodies
  * @free: entry in the pool free body list
+ * @refcnt: reference tracking for the body
  * @pool: pool to which this body belongs
  * @vsp1: the VSP1 device
  * @entries: array of entries
-- 
2.17.0
