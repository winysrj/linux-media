Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33778 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1APIjd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 03:39:33 -0500
Date: Sun, 16 Jan 2011 09:39:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [PATCH] firedtv: fix remote control with newer Xorg evdev
Message-ID: <20110116093921.6275ac89@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

After a recent update of xf86-input-evdev and xorg-server, I noticed
that X11 applications did not receive keypresses from the FireDTV
infrared remote control anymore.  Instead, the Xorg log featured lots of

    "FireDTV remote control: dropping event due to full queue!"

exclamations.  The Linux console did not have an issue with the
FireDTV's RC though.

The fix is to insert EV_SYN events after the key-down/-up events.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-rc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: b/drivers/media/dvb/firewire/firedtv-rc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-rc.c
+++ b/drivers/media/dvb/firewire/firedtv-rc.c
@@ -172,7 +172,8 @@ void fdtv_unregister_rc(struct firedtv *
 
 void fdtv_handle_rc(struct firedtv *fdtv, unsigned int code)
 {
-	u16 *keycode = fdtv->remote_ctrl_dev->keycode;
+	struct input_dev *idev = fdtv->remote_ctrl_dev;
+	u16 *keycode = idev->keycode;
 
 	if (code >= 0x0300 && code <= 0x031f)
 		code = keycode[code - 0x0300];
@@ -188,6 +189,7 @@ void fdtv_handle_rc(struct firedtv *fdtv
 		return;
 	}
 
-	input_report_key(fdtv->remote_ctrl_dev, code, 1);
-	input_report_key(fdtv->remote_ctrl_dev, code, 0);
+	input_report_key(idev, code, 1);
+	input_report_key(idev, code, 0);
+	input_sync(idev);
 }


-- 
Stefan Richter
-=====-==-== ---= =----
http://arcgraph.de/sr/
