Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:35339 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3C0VG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 17:06:26 -0400
Received: by mail-ee0-f47.google.com with SMTP id t10so1533171eei.20
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 14:06:25 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/9] em28xx: improve the sensor device code
Date: Wed, 27 Mar 2013 22:06:27 +0100
Message-Id: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series improves the sensor device support/code.
The changes include
- splitting sensor detection, board hints and sensor initialization/configuration (patches 1 and 2)
- moving the sensor specific code to a separate source code file (patch 4)
- improving/extending sensor probing and identification (patches 5, 7 and 8)
- adding (basic) support for the OmniVision OV2640 sensor (patch 9)

Frank Schäfer (9):
  em28xx: fix and separate the board hints for sensor devices
  em28xx: separate sensor detection and initialization/configuration
  em28xx: rename em28xx_hint_sensor() to em28xx_detect_sensor()
  em28xx: move sensor code to a separate source code file
    em28xx-camera.c
  em28xx: detect further Micron sensors
  em28xx: move the probing of Micron sensors to a separate function
  em28xx: add probing procedure for OmniVision sensors
  em28xx: add comment about Samsung and Kodak sensor probing addresses
  em28xx: add basic support for OmniVision OV2640 sensors

 drivers/media/usb/em28xx/Makefile        |    2 +-
 drivers/media/usb/em28xx/em28xx-camera.c |  424 ++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-cards.c  |  183 ++-----------
 drivers/media/usb/em28xx/em28xx.h        |    5 +
 4 Dateien geändert, 451 Zeilen hinzugefügt(+), 163 Zeilen entfernt(-)
 create mode 100644 drivers/media/usb/em28xx/em28xx-camera.c

-- 
1.7.10.4

