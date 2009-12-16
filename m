Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:44555 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZLPQEl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 11:04:41 -0500
Message-ID: <4B290589.2030607@gmail.com>
Date: Wed, 16 Dec 2009 17:06:33 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] vivi: Fix test of unsigned in vivi_create_instance()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

video_nr is unsigned so the test did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 7705fc6..328af3a 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1375,7 +1375,7 @@ static int __init vivi_create_instance(int inst)
 	snprintf(vfd->name, sizeof(vfd->name), "%s (%i)",
 			vivi_template.name, vfd->num);
 
-	if (video_nr >= 0)
+	if (video_nr != -1)
 		video_nr++;
 
 	dev->vfd = vfd;
