Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2857 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaC2MhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 08:37:10 -0400
Message-ID: <5336BE52.8030204@xs4all.nl>
Date: Sat, 29 Mar 2014 13:36:34 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH for v3.15] Fix patch merge mistake
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 37571b163c15831cd0a213151c21387363dbf15b ("em28xx-dvb: fix PCTV 461e
tuner I2C binding") was merged incorrectly and one chunk ended up in the
wrong function causing a compile error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 71e1fca..f599b18 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1603,7 +1603,6 @@ static int em28xx_dvb_suspend(struct em28xx *dev)
 	em28xx_info("Suspending DVB extension");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
-		struct i2c_client *client = dvb->i2c_client_tuner;
 
 		if (dvb->fe[0]) {
 			ret = dvb_frontend_suspend(dvb->fe[0]);
@@ -1631,6 +1630,7 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 	em28xx_info("Resuming DVB extension");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
+		struct i2c_client *client = dvb->i2c_client_tuner;
 
 		if (dvb->fe[0]) {
 			ret = dvb_frontend_resume(dvb->fe[0]);
