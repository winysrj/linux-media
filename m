Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:54393 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757066AbcJMQbF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:31:05 -0400
Subject: [PATCH 03/18] [media] RedRat3: Return directly after a failed
 kcalloc() in redrat3_transmit_ir()
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
Message-ID: <43840a4c-9f13-4e02-4f57-306c1fca2ee8@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:23:33 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 10:34:29 +0200

* Return directly after a call of the function "kcalloc" failed
  at the beginning.

* Reorder two calls for the function "kfree" at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index f5a6850..7ae2ced 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -741,10 +741,8 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 	sample_lens = kcalloc(RR3_DRIVER_MAXLENS,
 			      sizeof(*sample_lens),
 			      GFP_KERNEL);
-	if (!sample_lens) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!sample_lens)
+		return -ENOMEM;
 
 	irdata = kzalloc(sizeof(*irdata), GFP_KERNEL);
 	if (!irdata) {
@@ -815,8 +813,8 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 		ret = count;
 
 out:
-	kfree(sample_lens);
 	kfree(irdata);
+	kfree(sample_lens);
 
 	rr3->transmitting = false;
 	/* rr3 re-enables rc detector because it was enabled before */
-- 
2.10.1

