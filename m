Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:46440 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab2HJT2L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 15:28:11 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	Stefan Macher <st_maker-lirc@yahoo.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/6] [media] rc: transmit on device which does not support it should fail
Date: Fri, 10 Aug 2012 20:28:04 +0100
Message-Id: <1344626888-10536-2-git-send-email-sean@mess.org>
In-Reply-To: <1344626888-10536-1-git-send-email-sean@mess.org>
References: <1344626888-10536-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently write() will return 0 if an IR device does not support sending.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 5faba2a..d2fd064 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -105,7 +105,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	struct lirc_codec *lirc;
 	struct rc_dev *dev;
 	unsigned int *txbuf; /* buffer with values to transmit */
-	ssize_t ret = 0;
+	ssize_t ret = -EINVAL;
 	size_t count;
 
 	lirc = lirc_get_pdata(file);
-- 
1.7.11.2

