Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60051 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbD3OIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/22] af9005: fix bad indenting
Date: Thu, 30 Apr 2015 11:08:21 -0300
Message-Id: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb/af9005-fe.c:484 af9005_fe_read_status() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb/af9005-fe.c b/drivers/media/usb/dvb-usb/af9005-fe.c
index 740f3f496f12..6e84a546dfdc 100644
--- a/drivers/media/usb/dvb-usb/af9005-fe.c
+++ b/drivers/media/usb/dvb-usb/af9005-fe.c
@@ -481,7 +481,7 @@ static int af9005_fe_read_status(struct dvb_frontend *fe, fe_status_t * stat)
 		return ret;
 	if (temp != state->strong) {
 		deb_info("adjust for strong signal %d\n", temp);
-			state->strong = temp;
+		state->strong = temp;
 	}
 	return 0;
 }
-- 
2.1.0

