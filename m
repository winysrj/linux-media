Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60725 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3KBQdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 20/29] tuner-xc2028: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:28 -0200
Message-Id: <1383399097-11615-21-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/tuners/tuner-xc2028.c:651:1: warning: 'load_firmware' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer.

In the specific case of this driver, the maximum limit is 80, used only
on tm6000 driver. This limit is due to the size of the USB control URBs.

Ok, it would be theoretically possible to use a bigger size on PCI
devices, but the firmware load time is already good enough. Anyway,
if some usage requires more, it is just a matter of also increasing
the buffer size at load_firmware().

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/tuner-xc2028.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index e287a7417319..387934b22a2b 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -547,7 +547,10 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 {
 	struct xc2028_data *priv = fe->tuner_priv;
 	int                pos, rc;
-	unsigned char      *p, *endp, buf[priv->ctrl.max_len];
+	unsigned char      *p, *endp, buf[80];
+
+	if (priv->ctrl.max_len > sizeof(buf))
+		priv->ctrl.max_len = sizeof(buf);
 
 	tuner_dbg("%s called\n", __func__);
 
-- 
1.8.3.1

