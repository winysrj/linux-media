Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51690 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab0GWKIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 06:08:45 -0400
Date: Fri, 23 Jul 2010 12:08:26 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] V4L: media/IR: testing the wrong variable
Message-ID: <20100723100826.GB26313@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a typo here.  We meant to test "rbuf" instead of "drv".  We
already tested "drv" earlier.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index 178bc5b..870000e 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -192,7 +192,7 @@ static int ir_lirc_register(struct input_dev *input_dev)
 		return rc;
 
 	rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-	if (!drv)
+	if (!rbuf)
 		goto rbuf_alloc_failed;
 
 	rc = lirc_buffer_init(rbuf, sizeof(int), LIRCBUF_SIZE);
