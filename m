Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:55318 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932632AbdDFHcD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 03:32:03 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Add support for the RainShadow Tech HDMI CEC
 adapter
Message-ID: <261937c8-eac1-fce3-3f1c-b189b03e912e@xs4all.nl>
Date: Thu, 6 Apr 2017 09:31:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Identical to the v3 patch series.

To use add this to /etc/udev/rules.d/70-cec.rules:

SUBSYSTEM=="tty", KERNEL=="ttyACM[0-9]*", ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="ff59", ACTION=="add", TAG+="systemd",
ENV{SYSTEMD_WANTS}+="rainshadow-cec-inputattach@%k.service"

Use this as the systemd service:

$ cat /lib/systemd/system/rainshadow-cec-inputattach@.service
[Unit]
Description=inputattach for rainshadow-cec device on %I

[Service]
Type=simple
ExecStart=/usr/bin/inputattach --rainshadow-cec /dev/%I
KillMode=process


And this is the diff for inputattach:

diff -ur linuxconsoletools-1.6.0/utils/inputattach.c linuxconsoletools-1.6.0.new/utils/inputattach.c
--- linuxconsoletools-1.6.0/utils/inputattach.c	2016-08-09 13:04:05.000000000 +0200
+++ linuxconsoletools-1.6.0.new/utils/inputattach.c	2016-10-31 15:59:38.767639502 +0100
@@ -867,6 +867,9 @@
 { "--pulse8-cec",		"-pulse8-cec",	"Pulse Eight HDMI CEC dongle",
 	B9600, CS8,
 	SERIO_PULSE8_CEC,		0x00,	0x00,	0,	NULL },
+{ "--rainshadow-cec",		"-rainshadow-cec",	"RainShadow Tech HDMI CEC dongle",
+	B9600, CS8,
+	SERIO_RAINSHADOW_CEC,		0x00,	0x00,	0,	NULL },
 { NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL }
 };

diff -ur linuxconsoletools-1.6.0/utils/serio-ids.h linuxconsoletools-1.6.0.new/utils/serio-ids.h
--- linuxconsoletools-1.6.0/utils/serio-ids.h	2016-08-09 13:04:05.000000000 +0200
+++ linuxconsoletools-1.6.0.new/utils/serio-ids.h	2016-10-31 16:00:10.098639502 +0100
@@ -134,5 +134,8 @@
 #ifndef SERIO_PULSE8_CEC
 # define SERIO_PULSE8_CEC	0x40
 #endif
+#ifndef SERIO_RAINSHADOW_CEC
+# define SERIO_RAINSHADOW_CEC	0x41
+#endif

 #endif


Once this driver is merged in the mainline kernel I will mail this patch to the
inputattach maintainer.

Regards,

	Hans

The following changes since commit 2f65ec0567f77b75f459c98426053a3787af356a:

  [media] s5p-g2d: Fix error handling (2017-04-05 16:37:15 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git rain

for you to fetch changes up to 4d7ef7d4915e7dba0d9dee0d45d441b248988827:

  rainshadow-cec: new RainShadow Tech HDMI CEC driver (2017-04-06 08:51:52 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      serio.h: add SERIO_RAINSHADOW_CEC ID
      rainshadow-cec: new RainShadow Tech HDMI CEC driver

 MAINTAINERS                                       |   7 +
 drivers/media/usb/Kconfig                         |   1 +
 drivers/media/usb/Makefile                        |   1 +
 drivers/media/usb/rainshadow-cec/Kconfig          |  10 ++
 drivers/media/usb/rainshadow-cec/Makefile         |   1 +
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 388 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/serio.h                        |   1 +
 7 files changed, 409 insertions(+)
 create mode 100644 drivers/media/usb/rainshadow-cec/Kconfig
 create mode 100644 drivers/media/usb/rainshadow-cec/Makefile
 create mode 100644 drivers/media/usb/rainshadow-cec/rainshadow-cec.c
