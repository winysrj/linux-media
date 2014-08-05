Return-path: <linux-media-owner@vger.kernel.org>
Received: from HC210-202-87-179.vdslpro.static.apol.com.tw ([210.202.87.179]:47169
	"EHLO ironport.ite.com.tw" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755141AbaHEFrG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Aug 2014 01:47:06 -0400
Received: from ms2.internal.ite.com.tw (ms2.internal.ite.com.tw [192.168.15.236])
	by mse.ite.com.tw with ESMTP id s755l2b5003782
	for <linux-media@vger.kernel.org>; Tue, 5 Aug 2014 13:47:02 +0800 (CST)
	(envelope-from Bimow.Chen@ite.com.tw)
Received: from [192.168.190.2] (unknown [192.168.190.2])
	by ms2.internal.ite.com.tw (Postfix) with ESMTP id 4007C45307
	for <linux-media@vger.kernel.org>; Tue,  5 Aug 2014 13:46:59 +0800 (CST)
Subject: [PATCH 4/4] V4L/DVB: Add sleep for firmware ready
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-g7HmastJ+b36B/9XJXcb"
Date: Tue, 05 Aug 2014 13:48:03 +0800
Message-ID: <1407217683.2988.9.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-g7HmastJ+b36B/9XJXcb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



--=-g7HmastJ+b36B/9XJXcb
Content-Disposition: attachment; filename="0004-Add-sleep-for-firmware-ready.patch"
Content-Type: text/x-patch; name="0004-Add-sleep-for-firmware-ready.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

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


--=-g7HmastJ+b36B/9XJXcb--

