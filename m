Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:52292 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbZJBJGp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2009 05:06:45 -0400
Received: from localhost (localhost [127.0.0.1])
	by bamako.nerim.net (Postfix) with ESMTP id DC48F39DC83
	for <linux-media@vger.kernel.org>; Fri,  2 Oct 2009 11:06:47 +0200 (CEST)
Received: from bamako.nerim.net ([127.0.0.1])
	by localhost (bamako.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w8zGG9zmi7BY for <linux-media@vger.kernel.org>;
	Fri,  2 Oct 2009 11:06:47 +0200 (CEST)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by bamako.nerim.net (Postfix) with ESMTP id D9C2F39DC7E
	for <linux-media@vger.kernel.org>; Fri,  2 Oct 2009 11:06:46 +0200 (CEST)
Date: Fri, 2 Oct 2009 11:06:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] Fix wrong sizeof
Message-ID: <20091002110648.5d8d5b17@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Which is why I have always preferred sizeof(struct foo) over
sizeof(var).

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/dvb/dvb-usb/ce6230.c        |    2 +-
 linux/drivers/media/video/saa7164/saa7164-cmd.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/ce6230.c	2009-09-26 13:10:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/ce6230.c	2009-10-02 11:03:17.000000000 +0200
@@ -105,7 +105,7 @@ static int ce6230_i2c_xfer(struct i2c_ad
 	int i = 0;
 	struct req_t req;
 	int ret = 0;
-	memset(&req, 0, sizeof(&req));
+	memset(&req, 0, sizeof(req));
 
 	if (num > 2)
 		return -EINVAL;
--- v4l-dvb.orig/linux/drivers/media/video/saa7164/saa7164-cmd.c	2009-09-26 13:10:09.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7164/saa7164-cmd.c	2009-10-02 11:03:21.000000000 +0200
@@ -347,7 +347,7 @@ int saa7164_cmd_send(struct saa7164_dev
 
 	/* Prepare some basic command/response structures */
 	memset(&command_t, 0, sizeof(command_t));
-	memset(&response_t, 0, sizeof(&response_t));
+	memset(&response_t, 0, sizeof(response_t));
 	pcommand_t = &command_t;
 	presponse_t = &response_t;
 	command_t.id = id;

-- 
Jean Delvare
