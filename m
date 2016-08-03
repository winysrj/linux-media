Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58701 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757758AbcHCLBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Aug 2016 07:01:25 -0400
To: linux-input <linux-input@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] serio: add hangup support
Message-ID: <0d959a01-e698-0178-af89-5925469f95ab@xs4all.nl>
Date: Wed, 3 Aug 2016 13:00:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Pulse-Eight USB CEC adapter is a usb device that shows up as a ttyACM0 device.
It requires that you run inputattach in order to communicate with it via serio.

This all works well, but it would be nice to have a udev rule to automatically
start inputattach. That too works OK, but the problem comes when the USB device
is unplugged: the tty hangup is never handled by the serio framework so the
inputattach utility never exits and you have to kill it manually.

By adding this hangup callback the inputattach utility now properly exits as
soon as the USB device is unplugged.

The udev rule I used on my Debian sid system is:

SUBSYSTEM=="tty", KERNEL=="ttyACM[0-9]*", ATTRS{idVendor}=="2548", ATTRS{idProduct}=="1002", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}+="pulse8-cec-inputattach@%k.service"

And pulse8-cec-inputattach@%k.service is as follows:

===============================================================
[Unit]
Description=inputattach for pulse8-cec device on %I

[Service]
Type=simple
ExecStart=/usr/local/bin/inputattach --pulse8-cec /dev/%I
KillMode=process
===============================================================

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Change since the original RFC patch: don't call close() from the hangup() function,
instead only set the DEAD flag in hangup() instead of in close().
---
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 9c927d3..4045e95 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -71,7 +71,6 @@ static void serport_serio_close(struct serio *serio)

 	spin_lock_irqsave(&serport->lock, flags);
 	clear_bit(SERPORT_ACTIVE, &serport->flags);
-	set_bit(SERPORT_DEAD, &serport->flags);
 	spin_unlock_irqrestore(&serport->lock, flags);

 	wake_up_interruptible(&serport->wait);
@@ -248,6 +247,19 @@ static long serport_ldisc_compat_ioctl(struct tty_struct *tty,
 }
 #endif

+static int serport_ldisc_hangup(struct tty_struct * tty)
+{
+	struct serport *serport = (struct serport *) tty->disc_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&serport->lock, flags);
+	set_bit(SERPORT_DEAD, &serport->flags);
+	spin_unlock_irqrestore(&serport->lock, flags);
+
+	wake_up_interruptible(&serport->wait);
+	return 0;
+}
+
 static void serport_ldisc_write_wakeup(struct tty_struct * tty)
 {
 	struct serport *serport = (struct serport *) tty->disc_data;
@@ -274,6 +286,7 @@ static struct tty_ldisc_ops serport_ldisc = {
 	.compat_ioctl =	serport_ldisc_compat_ioctl,
 #endif
 	.receive_buf =	serport_ldisc_receive,
+	.hangup =	serport_ldisc_hangup,
 	.write_wakeup =	serport_ldisc_write_wakeup
 };

