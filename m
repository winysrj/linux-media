Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47529 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3LAVGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Dec 2013 16:06:21 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so8250396eae.33
        for <linux-media@vger.kernel.org>; Sun, 01 Dec 2013 13:06:20 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/7] em28xx: add basic support for the SpeedLink Vicious And Devine Laplace webcams
Date: Sun,  1 Dec 2013 22:06:50 +0100
Message-Id: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SpeedLink Vicious And Devine Laplace webcam is using an EM2765 bridge 
and an OV2640 sensor. It has a built-in microphone (STAC9753 AC97, 
USB standard device class) and provides 3 buttons (snapshot, illumination, mute)
and 2 LEDs (capturing/mute and illumination/flash).
It is also equipped with an eeprom.
The device is available in two colors: white (1ae7:9003) and black (1ae7:9004).
For further details see http://linuxtv.org/wiki/index.php/VAD_Laplace.


The first 6 patches improve and extend the support for device buttons and LEDs by
- abstracting and generalize the button and LED handling
- adding a software debouncing mechanism for buttons connected to ordinary GPI ports
- adding support for analog capturing and illumination LEDs
- adding support for illumination buttons

Support for the audio/video mute button can easily be added later, but that requires to fix several audio issues first.
Fortunately, there is another bug that prevents the em28xx driver from detecting the audio part of these devices. :/

Patch 7 finally adds the USB IDs and the board defintion for these cameras.


The following limitations need to be addressed later:
- resolution currently limited to 640x480 (sensor supports 1600x1200)
- picture quality needs to be improved
- audio/video mute button doesn't work yet


Frank Schäfer (7):
  em28xx: add support for GPO controlled analog capturing LEDs
  em28xx: extend the support for device buttons
  em28xx: add debouncing mechanism for GPI-connected buttons
  em28xx: reduce the polling interval for buttons
  em28xx: prepare for supporting multiple LEDs
  em28xx: add support for illumination button and LED
  em28xx: add support for the SpeedLink Vicious And Devine Laplace
    webcams

 drivers/media/usb/em28xx/em28xx-cards.c |   92 +++++++++++++++-
 drivers/media/usb/em28xx/em28xx-core.c  |  105 +++++++++++++------
 drivers/media/usb/em28xx/em28xx-input.c |  175 ++++++++++++++++++++++++-------
 drivers/media/usb/em28xx/em28xx.h       |   49 ++++++++-
 4 Dateien geändert, 346 Zeilen hinzugefügt(+), 75 Zeilen entfernt(-)

-- 
1.7.10.4

