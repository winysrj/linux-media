Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61984 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752137AbdHHLYE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 07:24:04 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] [media] uvcvideo: constify video_subdev structures
Date: Tue,  8 Aug 2017 12:58:32 +0200
Message-Id: <1502189912-28794-7-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

uvc_subdev_ops is only passed as the second argument of
v4l2_subdev_init, which is const, so uvc_subdev_ops can be
const as well.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/usb/uvc/uvc_entity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index ac386bb..554063c 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -61,7 +61,7 @@ static int uvc_mc_create_links(struct uvc_video_chain *chain,
 	return 0;
 }
 
-static struct v4l2_subdev_ops uvc_subdev_ops = {
+static const struct v4l2_subdev_ops uvc_subdev_ops = {
 };
 
 void uvc_mc_cleanup_entity(struct uvc_entity *entity)
