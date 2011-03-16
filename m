Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1CPUQq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:16:46 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2GKGkFs027520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 16:16:46 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/2] hdpvr: use same polling interval as other OS
Date: Wed, 16 Mar 2011 16:16:35 -0400
Message-Id: <1300306595-19098-2-git-send-email-jarod@redhat.com>
In-Reply-To: <1300306595-19098-1-git-send-email-jarod@redhat.com>
References: <1300306595-19098-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The hdpvr's IR part, in short, sucks. As observed with a usb traffic
sniffer, the Windows software for it uses a polling interval of 405ms.
Its still not behaving as well as I'd like even with this change, but
this inches us closer and closer to that point...

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/video/hdpvr/hdpvr-i2c.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
index de69bae..2a1ac28 100644
--- a/drivers/media/video/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
@@ -56,6 +56,7 @@ struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
 	init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 	init_data->type = RC_TYPE_RC5;
 	init_data->name = "HD-PVR";
+	init_data->polling_interval = 405; /* ms, duplicated from Windows */
 	hdpvr_ir_rx_i2c_board_info.platform_data = init_data;
 
 	return i2c_new_device(&dev->i2c_adapter, &hdpvr_ir_rx_i2c_board_info);
@@ -191,7 +192,7 @@ static struct i2c_adapter hdpvr_i2c_adapter_template = {
 
 static int hdpvr_activate_ir(struct hdpvr_device *dev)
 {
-	char buffer[8];
+	char buffer[2];
 
 	mutex_lock(&dev->i2c_mutex);
 
-- 
1.7.1

