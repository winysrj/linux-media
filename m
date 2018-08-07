Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33570 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbeHGMcP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 08:32:15 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH] media: vsp1_dl: add a description for cmdpool field
Date: Tue,  7 Aug 2018 06:18:33 -0400
Message-Id: <5cc2f8f81f4c7d1ae693d87980353c725f9a11d3.1533637111.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gets rid of this build warning:
	drivers/media/platform/vsp1/vsp1_dl.c:229: warning: Function parameter or member 'cmdpool' not described in 'vsp1_dl_manager'

Fixes: f3b98e3c4d2e ("media: vsp1: Provide support for extended command pools")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 9255b5ee2cb8..af60d95ec4f8 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -211,6 +211,7 @@ struct vsp1_dl_list {
  * @queued: list queued to the hardware (written to the DL registers)
  * @pending: list waiting to be queued to the hardware
  * @pool: body pool for the display list bodies
+ * @cmdpool: Display List commands pool
  * @autofld_cmds: command pool to support auto-fld interlaced mode
  */
 struct vsp1_dl_manager {
-- 
2.17.1
