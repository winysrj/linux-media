Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:42269 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZD3IkU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 04:40:20 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1LzSu6-0004zc-GW
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Thu, 30 Apr 2009 11:50:06 +0200
Date: Thu, 30 Apr 2009 10:40:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] Drop stray references to i2c_probe
Message-ID: <20090430104007.6e7e6fc6@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new i2c binding model doesn't use i2c_probe.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/tea6415c.c |    1 -
 linux/drivers/media/video/tea6420.c  |    1 -
 2 files changed, 2 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/tea6415c.c	2009-04-06 10:10:25.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/tea6415c.c	2009-04-29 18:46:09.000000000 +0200
@@ -147,7 +147,6 @@ static const struct v4l2_subdev_ops tea6
 	.video = &tea6415c_video_ops,
 };
 
-/* this function is called by i2c_probe */
 static int tea6415c_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
--- v4l-dvb.orig/linux/drivers/media/video/tea6420.c	2009-04-06 10:10:25.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/tea6420.c	2009-04-29 18:46:05.000000000 +0200
@@ -118,7 +118,6 @@ static const struct v4l2_subdev_ops tea6
 	.audio = &tea6420_audio_ops,
 };
 
-/* this function is called by i2c_probe */
 static int tea6420_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {


-- 
Jean Delvare
