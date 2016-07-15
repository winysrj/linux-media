Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43843 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932694AbcGOL11 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 07:27:27 -0400
To: linux-input <linux-input@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH] serio: add hangup support
Message-ID: <287a7f88-5d45-bb45-c98e-22a2313ab780@xs4all.nl>
Date: Fri, 15 Jul 2016 13:27:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the upcoming 4.8 kernel I made a driver for the Pulse-Eight USB CEC adapter.
This is a usb device that shows up as a ttyACM0 device. It requires that you run
inputattach in order to communicate with it via serio.

This all works well, but it would be nice to have a udev rule to automatically
start inputattach. That too works OK, but the problem comes when the USB device
is unplugged: the tty hangup is never handled by the serio framework so the
inputattach utility never exits and you have to kill it manually.

By adding this hangup callback the inputattach utility now exists as soon as I
unplug the USB device.

Is this the correct approach?

BTW, the new driver is found here:

https://git.linuxtv.org/media_tree.git/tree/drivers/staging/media/pulse8-cec

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

---
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 9c927d3..a615846 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -248,6 +248,14 @@ static long serport_ldisc_compat_ioctl(struct tty_struct *tty,
 }
 #endif

+static int serport_ldisc_hangup(struct tty_struct * tty)
+{
+	struct serport *serport = (struct serport *) tty->disc_data;
+
+	serport_serio_close(serport->serio);
+	return 0;
+}
+
 static void serport_ldisc_write_wakeup(struct tty_struct * tty)
 {
 	struct serport *serport = (struct serport *) tty->disc_data;
@@ -274,6 +282,7 @@ static struct tty_ldisc_ops serport_ldisc = {
 	.compat_ioctl =	serport_ldisc_compat_ioctl,
 #endif
 	.receive_buf =	serport_ldisc_receive,
+	.hangup =	serport_ldisc_hangup,
 	.write_wakeup =	serport_ldisc_write_wakeup
 };

