Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab3CCP67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Mar 2013 10:58:59 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: [PATCH 11/11] [media] em28xx-dvb: Don't put device in suspend mode at feed stop
Date: Sun,  3 Mar 2013 12:58:51 -0300
Message-Id: <1362326331-17541-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
References: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Putting em28xx in suspend mode when a feed stops is just plain
wrong. Every time a new PES filter is changed, the DVB demux
code will stop the current feed, and then start a new one.
If are there any code that switches off the frontend, via
some GPIO setting, this would make the DVB fail.
This condition was actually trigged with one device, during
DVB scan, as, during scan, it is common that userspace apps
to change the filter several times, in order to get all
tables.
Also, this is not needed at all, since the em28xx code already
hooks into ops.ts_bus_ctrl(). This warrants that em28xx can
check there if DVB frontend is in usage or not. The code there
already puts the device on suspend mode, if the DVB frontend
is not used (closed).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a81ec2e..7200dfe 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -220,8 +220,6 @@ static int em28xx_stop_streaming(struct em28xx_dvb *dvb)
 
 	em28xx_stop_urbs(dev);
 
-	em28xx_set_mode(dev, EM28XX_SUSPEND);
-
 	return 0;
 }
 
-- 
1.8.1.4

