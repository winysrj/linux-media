Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:15335 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbZJCPGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 11:06:34 -0400
Received: from [192.168.1.4] (athloroad.xperim.be [192.168.1.4])
	(authenticated bits=0)
	by via.xperim.be (8.14.2/8.14.2/Debian-2build1) with ESMTP id n93F4Bde014192
	for <linux-media@vger.kernel.org>; Sat, 3 Oct 2009 17:04:13 +0200
Message-ID: <4AC767EB.7070006@computer.org>
Date: Sat, 03 Oct 2009 17:04:11 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] drivers/media/dvb/dvb-usb: memset region size error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From bb568359751d84b485dbbf04f1317a77c6c3f6f0 Mon Sep 17 00:00:00 2001
From: Jan Ceuleers <jan.ceuleers@computer.org>
Date: Sat, 3 Oct 2009 16:58:51 +0200
Subject: [PATCH] drivers/media/dvb/dvb-usb: memset region size error

The size of the region to be memset() should be the size
of the target rather than the size of the pointer to it.

Compile-tested only.

Signed-off-by: Jan Ceuleers <jan.ceuleers@computer.org>
---
 drivers/media/dvb/dvb-usb/ce6230.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/ce6230.c b/drivers/media/dvb/dvb-usb/ce6230.c
index 0737c63..3df2045 100644
--- a/drivers/media/dvb/dvb-usb/ce6230.c
+++ b/drivers/media/dvb/dvb-usb/ce6230.c
@@ -105,7 +105,7 @@ static int ce6230_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	int i = 0;
 	struct req_t req;
 	int ret = 0;
-	memset(&req, 0, sizeof(&req));
+	memset(&req, 0, sizeof(req));
 
 	if (num > 2)
 		return -EINVAL;
-- 
1.5.4.3

