Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:61901 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933264AbcJLOnn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:43:43 -0400
Subject: [PATCH 08/34] [media] DaVinci-VPBE: Return the success indication
 only as a constant in vpbe_set_mode()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <bcd9c829-4a3b-22d8-e5fa-c530615a8921@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:43:27 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 09:51:29 +0200

* Return a success code without storing it in an intermediate variable.

* Delete the local variable "ret" which became unnecessary with
  this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpbe.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 9fdd8c0..d6a0221 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -509,7 +509,6 @@ static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
 	struct v4l2_dv_timings dv_timings;
 	struct osd_state *osd_device;
 	int out_index = vpbe_dev->current_out_index;
-	int ret = 0;
 	int i;
 
 	if (!mode_info || !mode_info->name)
@@ -549,8 +548,7 @@ static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
 		vpbe_dev->current_timings.upper_margin);
 
 	mutex_unlock(&vpbe_dev->lock);
-
-	return ret;
+	return 0;
 }
 
 static int vpbe_set_default_mode(struct vpbe_device *vpbe_dev)
-- 
2.10.1

