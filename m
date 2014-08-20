Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1629 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaHTW7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/29] pctv452e: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:08 +0200
Message-Id: <1408575568-20562-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/dvb-usb/pctv452e.c:886:64: warning: Using plain integer as NULL pointer
drivers/media/usb/dvb-usb/pctv452e.c:903:63: warning: Using plain integer as NULL pointer
drivers/media/usb/dvb-usb/pctv452e.c:968:19: warning: Using plain integer as NULL pointer
drivers/media/usb/dvb-usb/pctv452e.c:1026:19: warning: Using plain integer as NULL pointer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/dvb-usb/pctv452e.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index bdfe896..d17618f 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -883,7 +883,7 @@ static int pctv452e_frontend_attach(struct dvb_usb_adapter *a)
 	if (!a->fe_adap[0].fe)
 		return -ENODEV;
 	if ((dvb_attach(lnbp22_attach, a->fe_adap[0].fe,
-					&a->dev->i2c_adap)) == 0)
+					&a->dev->i2c_adap)) == NULL)
 		err("Cannot attach lnbp22\n");
 
 	id = a->dev->desc->warm_ids[0];
@@ -900,7 +900,7 @@ static int pctv452e_tuner_attach(struct dvb_usb_adapter *a)
 	if (!a->fe_adap[0].fe)
 		return -ENODEV;
 	if (dvb_attach(stb6100_attach, a->fe_adap[0].fe, &stb6100_config,
-					&a->dev->i2c_adap) == 0) {
+					&a->dev->i2c_adap) == NULL) {
 		err("%s failed\n", __func__);
 		return -ENODEV;
 	}
@@ -965,7 +965,7 @@ static struct dvb_usb_device_properties pctv452e_properties = {
 		  .cold_ids = { NULL, NULL }, /* this is a warm only device */
 		  .warm_ids = { &pctv452e_usb_table[0], NULL }
 		},
-		{ 0 },
+		{ NULL },
 	}
 };
 
@@ -1023,7 +1023,7 @@ static struct dvb_usb_device_properties tt_connect_s2_3600_properties = {
 		  .cold_ids = { NULL, NULL },
 		  .warm_ids = { &pctv452e_usb_table[2], NULL }
 		},
-		{ 0 },
+		{ NULL },
 	}
 };
 
-- 
2.1.0.rc1

