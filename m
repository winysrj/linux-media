Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33780 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab1KWHJg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 02:09:36 -0500
Date: Wed, 23 Nov 2011 10:09:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Peter Huewe <peterhuewe@gmx.de>,
	Steven Toth <stoth@kernellabs.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] saa7164: fix endian conversion in saa7164_bus_set()
Message-ID: <20111123070911.GA8561@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The msg->command field is 32 bits, and we should fill it with a call
to cpu_to_le32().  The current code is broken on big endian systems,
and on little endian systems it just truncates the 32 bit value to
16 bits.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is a static checker bug.  I haven't tested it.

diff --git a/drivers/media/video/saa7164/saa7164-bus.c b/drivers/media/video/saa7164/saa7164-bus.c
index 466e1b0..8f853d1 100644
--- a/drivers/media/video/saa7164/saa7164-bus.c
+++ b/drivers/media/video/saa7164/saa7164-bus.c
@@ -149,7 +149,7 @@ int saa7164_bus_set(struct saa7164_dev *dev, struct tmComResInfo* msg,
 	saa7164_bus_verify(dev);
 
 	msg->size = cpu_to_le16(msg->size);
-	msg->command = cpu_to_le16(msg->command);
+	msg->command = cpu_to_le32(msg->command);
 	msg->controlselector = cpu_to_le16(msg->controlselector);
 
 	if (msg->size > dev->bus.m_wMaxReqSize) {
