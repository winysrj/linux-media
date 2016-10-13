Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:64276 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932307AbcJMQm3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:42:29 -0400
Subject: [PATCH 14/18] [media] RedRat3: Rename a jump label in
 redrat3_init_rc_dev()
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <172b54fe-559b-44a4-9902-96abece75a7f@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:42:16 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 15:00:12 +0200

Adjust a jump label according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 74d93dd..055f214 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -890,12 +890,11 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	ret = rc_register_device(rc);
 	if (ret < 0) {
 		dev_err(rr3->dev, "remote dev registration failed\n");
-		goto out;
+		goto free_device;
 	}
 
 	return rc;
-
-out:
+free_device:
 	rc_free_device(rc);
 	return NULL;
 }
-- 
2.10.1

