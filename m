Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:64190 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab3BKRsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 12:48:00 -0500
Received: by mail-ea0-f179.google.com with SMTP id d12so2794252eaa.10
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 09:47:58 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/4] em28xx: add image quality bridge controls
Date: Mon, 11 Feb 2013 18:48:32 +0100
Message-Id: <1360604916-3048-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first two patches remove unused code.
The third patch makes sure that the same image quality default settings are used
everywhere in the code.
The fourth patch finally adds the following image quality bridge controls:
- contrast
- brightness
- saturation
- blue balance
- red balance
- sharpness

Tested with the following devices:
"Terratec Cinergy 200 USB"
"Hauppauge HVR-900"
"SilverCrest 1.3MPix webcam"
"Hauppauge WinTV USB2"
"Speedlink VAD Laplace webcam"


Frank Schäfer (4):
  em28xx: remove unused image quality control functions
  em28xx: remove unused ac97 v4l2_ctrl_handler
  em28xx: introduce #defines for the image quality default settings
  em28xx: add image quality bridge controls

 drivers/media/usb/em28xx/em28xx-cards.c |    7 +---
 drivers/media/usb/em28xx/em28xx-core.c  |   12 +++---
 drivers/media/usb/em28xx/em28xx-reg.h   |   23 ++++++++---
 drivers/media/usb/em28xx/em28xx-video.c |   58 +++++++++++++++++++++++++-
 drivers/media/usb/em28xx/em28xx.h       |   68 -------------------------------
 5 Dateien geändert, 80 Zeilen hinzugefügt(+), 88 Zeilen entfernt(-)

-- 
1.7.10.4

