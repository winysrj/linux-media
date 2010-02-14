Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:54695 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0BNUga (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 15:36:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	jirislaby@gmail.com, Dmitry Torokhov <dtor@mail.ru>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] V4L: dvb-usb, add extra sync to down-up input events
Date: Sun, 14 Feb 2010 21:36:25 +0100
Message-Id: <1266179785-836-1-git-send-email-jslaby@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Userspace is allowed to coalesce events between SYNCs. And since the code
emits UP right after DOWN for the same key, it may be missed
(up+down=nothing). Add an extra sync in between UP and DOWN events to disable
the coalesce.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/dvb-usb/dib0700_core.c   |    1 +
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 4450214..4f961d2 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -612,6 +612,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 	case REMOTE_KEY_REPEAT:
 		deb_info("key repeated\n");
 		input_event(d->rc_input_dev, EV_KEY, event, 1);
+		input_sync(d->rc_input_dev);
 		input_event(d->rc_input_dev, EV_KEY, d->last_event, 0);
 		input_sync(d->rc_input_dev);
 		break;
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index 6b5ded9..a03ef7e 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -107,6 +107,7 @@ static void dvb_usb_read_remote_control(struct work_struct *work)
 		case REMOTE_KEY_REPEAT:
 			deb_rc("key repeated\n");
 			input_event(d->rc_input_dev, EV_KEY, event, 1);
+			input_sync(d->rc_input_dev);
 			input_event(d->rc_input_dev, EV_KEY, d->last_event, 0);
 			input_sync(d->rc_input_dev);
 			break;
-- 
1.6.6.1

