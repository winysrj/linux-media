Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:65514 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756287AbcJMQTa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:19:30 -0400
Subject: [PATCH 01/18] [media] RedRat3: Use kcalloc() in two functions
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
Message-ID: <21c57b39-25ac-2df1-030d-11c243a11ebc@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:18:57 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 08:35:57 +0200

* Multiplications for the size determination of memory allocations
  indicated that array data structures should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of data types by pointer dereferences
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 8d7df6d..d89958b 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -549,7 +549,7 @@ static void redrat3_get_firmware_rev(struct redrat3_dev *rr3)
 	int rc = 0;
 	char *buffer;
 
-	buffer = kzalloc(sizeof(char) * (RR3_FW_VERSION_LEN + 1), GFP_KERNEL);
+	buffer = kcalloc(RR3_FW_VERSION_LEN + 1, sizeof(*buffer), GFP_KERNEL);
 	if (!buffer) {
 		dev_err(rr3->dev, "Memory allocation failure\n");
 		return;
@@ -741,7 +741,9 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 	/* rr3 will disable rc detector on transmit */
 	rr3->transmitting = true;
 
-	sample_lens = kzalloc(sizeof(int) * RR3_DRIVER_MAXLENS, GFP_KERNEL);
+	sample_lens = kcalloc(RR3_DRIVER_MAXLENS,
+			      sizeof(*sample_lens),
+			      GFP_KERNEL);
 	if (!sample_lens) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.10.1

