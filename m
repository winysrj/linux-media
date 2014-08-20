Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33612 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaHTSPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 14:15:00 -0400
Received: by mail-la0-f52.google.com with SMTP id b17so7526884lan.39
        for <linux-media@vger.kernel.org>; Wed, 20 Aug 2014 11:14:58 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: g.liakhovetski@gmx.de, mchehab@redhat.com,
	linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH] rcar_vin: fix error message in rcar_vin_get_formats()
Date: Wed, 20 Aug 2014 22:14:56 +0400
Message-ID: <9395741.sQ4VThHCsR@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dev_err() call is supposed to output <width>x<height> in decimal but one of
the format specifiers is "%x" instead of "%u" (most probably due  to a typo).

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against the 'media_tree.git' repo's 'fixes' branch.

 drivers/media/platform/soc_camera/rcar_vin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
===================================================================
--- media_tree.orig/drivers/media/platform/soc_camera/rcar_vin.c
+++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
@@ -981,7 +981,7 @@ static int rcar_vin_get_formats(struct s
 
 		if (shift == 3) {
 			dev_err(dev,
-				"Failed to configure the client below %ux%x\n",
+				"Failed to configure the client below %ux%u\n",
 				mf.width, mf.height);
 			return -EIO;
 		}

