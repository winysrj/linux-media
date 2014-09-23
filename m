Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37187 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaIWLuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 07:50:44 -0400
Date: Tue, 23 Sep 2014 08:50:39 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Bimow Chen <Bimow.Chen@ite.com.tw>
Subject: Fw: [PATCH 4/4] V4L/DVB: Add sleep for firmware ready
Message-ID: <20140923085039.51765665@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti,

After the firmware load changes, is this patch still applicable?

Regards,
Mauro

Forwarded message:

Date: Tue, 05 Aug 2014 13:48:03 +0800
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] V4L/DVB: Add sleep for firmware ready


>From b19fa868ce937a6ef10f1591a49b2a7ad14964a9 Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Tue, 5 Aug 2014 11:20:53 +0800
Subject: [PATCH 4/4] Add sleep for firmware ready.


Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 drivers/media/usb/dvb-usb-v2/af9035.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 7b9b75f..a450cdb 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -602,6 +602,8 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 	if (ret < 0)
 		goto err;
 
+	msleep(30);
+
 	/* firmware loaded, request boot */
 	req.cmd = CMD_FW_BOOT;
 	ret = af9035_ctrl_msg(d, &req);
-- 
1.7.0.4

