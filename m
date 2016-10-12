Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:59895 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755168AbcJLOlo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:41:44 -0400
Subject: [PATCH 06/34] [media] DaVinci-VPBE: Return an error code only by a
 single variable in vpbe_initialize()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Muralidharan Karicheri <m-karicheri2@ti.com>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <31e1f827-3539-3bcf-e6c1-2b9df5fd3619@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:40:22 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 11 Oct 2016 14:15:57 +0200

An error code was assigned to the local variable "err" in an if branch.
But this variable was not used further then.

Use the local variable "ret" instead like at other places in this function.

Fixes: 66715cdc3224a4e241c1a92856b9a4af3b70e06d ("[media] davinci vpbe:
VPBE display driver")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpbe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 4c4cd81..afa8ff7 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -665,7 +665,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 		if (err) {
 			v4l2_err(&vpbe_dev->v4l2_dev,
 				 "unable to initialize the OSD device");
-			err = -ENOMEM;
+			ret = -ENOMEM;
 			goto fail_dev_unregister;
 		}
 	}
-- 
2.10.1

