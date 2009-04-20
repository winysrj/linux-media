Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail11e.verio-web.com ([204.202.242.84]:34125 "HELO
	mail11e.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757674AbZDTWHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 18:07:51 -0400
Received: from mx01.stngva01.us.mxservers.net (204.202.242.3)
	by mail11e.verio-web.com (RS ver 1.0.95vs) with SMTP id 4-0300435269
	for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 18:07:49 -0400 (EDT)
Date: Mon, 20 Apr 2009 15:07:44 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
Subject: patch: s2255drv: fix race condition on set mode
To: linux-media@vger.kernel.org, mchehab@infradead.org,
	video4linux-list@redhat.com
Message-ID: <tkrat.21210659c895a1d2@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dean Anderson <dean@sensoray.com>

set_modeready flag must be set before command sent to USB in
s2255_write_config.

Signed-off-by: Dean Anderson <dean@sensoray.com>

--- v4l-dvb-74b7f650670a/linux/drivers/media/video/s2255drv.c.orig	2009-04-20 14:33:04.000000000 -0700
+++ v4l-dvb-74b7f650670a/linux/drivers/media/video/s2255drv.c	2009-04-20 14:58:22.000000000 -0700
@@ -1238,6 +1238,7 @@ static int s2255_set_mode(struct s2255_d
 	buffer[1] = (u32) chn_rev;
 	buffer[2] = CMD_SET_MODE;
 	memcpy(&buffer[3], &dev->mode[chn], sizeof(struct s2255_mode));
+	dev->setmode_ready[chn] = 0;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (debug)
 		dump_verify_mode(dev, mode);
@@ -1246,7 +1247,6 @@ static int s2255_set_mode(struct s2255_d
 
 	/* wait at least 3 frames before continuing */
 	if (mode->restart) {
-		dev->setmode_ready[chn] = 0;
 		wait_event_timeout(dev->wait_setmode[chn],
 				   (dev->setmode_ready[chn] != 0),
 				   msecs_to_jiffies(S2255_SETMODE_TIMEOUT));

