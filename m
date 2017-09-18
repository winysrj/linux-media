Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([63.128.21.107]:56617 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751340AbdIRObq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 10:31:46 -0400
Subject: [PATCH] media: rc: Delete duplicate debug message
To: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
References: <d03f24dd-2e71-5f72-0c71-54ddc468f00a@free.fr>
 <20170912153049.gistk5gyrzbnygzz@gofer.mess.org>
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Message-ID: <050e4ded-b68b-a660-b7d6-d4124788107a@sigmadesigns.com>
Date: Mon, 18 Sep 2017 16:31:41 +0200
MIME-Version: 1.0
In-Reply-To: <20170912153049.gistk5gyrzbnygzz@gofer.mess.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir_setkeytable() and ir_create_table() print the same debug message.
Delete the one in ir_setkeytable()

Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
---
  drivers/media/rc/rc-main.c | 3 ---
  1 file changed, 3 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 981cccd6b988..a881d7c161e1 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -439,9 +439,6 @@ static int ir_setkeytable(struct rc_dev *dev,
  	if (rc)
  		return rc;
  
-	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
-		   rc_map->size, rc_map->alloc);
-
  	for (i = 0; i < from->size; i++) {
  		index = ir_establish_scancode(dev, rc_map,
  					      from->scan[i].scancode, false);
-- 
2.11.0
