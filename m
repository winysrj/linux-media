Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449AbaKANjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 09:39:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/7] [media] cx231xx-i2c: fix i2c_scan modprobe parameter
Date: Sat,  1 Nov 2014 11:38:58 -0200
Message-Id: <14a334de4f4b5786e55ce62872f7b033e9f0af3f.1414849031.git.mchehab@osg.samsung.com>
In-Reply-To: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
References: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <cover.1414849031.git.mchehab@osg.samsung.com>
References: <cover.1414849031.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This device doesn't properly implement read with a zero bytes
len. So, use 1 byte for I2C scan.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 1a0d9efeb209..9b7e5a155e34 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -502,7 +502,7 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 		i2c_port);
 	for (i = 0; i < 128; i++) {
 		client.addr = i;
-		rc = i2c_master_recv(&client, &buf, 0);
+		rc = i2c_master_recv(&client, &buf, 1);
 		if (rc < 0)
 			continue;
 		pr_info("i2c scan: found device @ 0x%x  [%s]\n",
-- 
1.9.3

