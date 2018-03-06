Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44907 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbeCFPf0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 10:35:26 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: ov772x: constify ov772x_frame_intervals
Date: Tue,  6 Mar 2018 10:35:22 -0500
Message-Id: <7b69f2cb91319abdacf37be501db2eae45112a09.1520350517.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The values on this array never changes. Make it const.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ov772x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 16665af0c712..321105bb3161 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -531,7 +531,7 @@ static const struct ov772x_win_size ov772x_win_sizes[] = {
 /*
  * frame rate settings lists
  */
-static unsigned int ov772x_frame_intervals[] = { 5, 10, 15, 20, 30, 60 };
+static const unsigned int ov772x_frame_intervals[] = { 5, 10, 15, 20, 30, 60 };
 
 /*
  * general function
-- 
2.14.3
