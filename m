Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36704 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab3CQNjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 09:39:24 -0400
Received: by mail-pd0-f169.google.com with SMTP id 3so599837pdj.0
        for <linux-media@vger.kernel.org>; Sun, 17 Mar 2013 06:39:22 -0700 (PDT)
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: staging: davinci_vpfe: fix build error
Date: Sun, 17 Mar 2013 19:02:30 +0530
Message-Id: <1363527150-6371-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

add missing header file delay.h required for msleep().
This patch fixes following build error:

drivers/staging/media/davinci_vpfe/dm365_isif.c: In function 'isif_enable':
drivers/staging/media/davinci_vpfe/dm365_isif.c:129: error: implicit declaration of function 'msleep'
make[4]: *** [drivers/staging/media/davinci_vpfe/dm365_isif.o] Error 1

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/media/davinci_vpfe/dm365_isif.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index ebeea72..e4e6fcc 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -19,6 +19,8 @@
  *      Prabhakar Lad <prabhakar.lad@ti.com>
  */
 
+#include <linux/delay.h>
+
 #include "dm365_isif.h"
 #include "vpfe_mc_capture.h"
 
-- 
1.7.0.4

