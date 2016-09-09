Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37561 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbcIIOBB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 10:01:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] [media] pxa_camera: make soc_mbus_xlate_by_fourcc() static
Date: Fri,  9 Sep 2016 11:00:39 -0300
Message-Id: <8f05b34a8be23d483661de181aa77c07d8a1bd58.1473429632.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:

drivers/media/platform/pxa_camera.c:283:39: warning: no previous prototype for 'soc_mbus_xlate_by_fourcc' [-Wmissing-prototypes]
 const struct soc_camera_format_xlate *soc_mbus_xlate_by_fourcc(
                                       ^~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/pxa_camera.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index c2d1ceaea49b..733677f06cb4 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -280,8 +280,9 @@ static const char *pxa_cam_driver_description = "PXA_Camera";
 /*
  * Format translation functions
  */
-const struct soc_camera_format_xlate *soc_mbus_xlate_by_fourcc(
-	struct soc_camera_format_xlate *user_formats, unsigned int fourcc)
+static const struct soc_camera_format_xlate
+*soc_mbus_xlate_by_fourcc(struct soc_camera_format_xlate *user_formats,
+			  unsigned int fourcc)
 {
 	unsigned int i;
 
-- 
2.7.4

