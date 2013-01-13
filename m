Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:42533 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3AMOVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 09:21:43 -0500
Received: by mail-ea0-f172.google.com with SMTP id f13so1382061eaa.3
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 06:21:42 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/7] em28xx-input: remove the dependency on module ir-kbd-i2c
Date: Sun, 13 Jan 2013 15:21:59 +0100
Message-Id: <1358086919-7066-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As it has been decided that i2-kbd-i2c isn't the way to go for i2c IR RC 
devices, remove the dependency on this module from the em28xx driver.
We already use our own key polling functions with ir-kbd-i2c and the polling
infrastructure is already on board, too (currently used for internal devices only).
To avoid the risk of breaking things, just use the same key reporting mechanism 
as ir-i2c-kbd.
The last two patches are optional, as they reduce the code size by ~20 lines 
at the cost of a minor performance drawback.
Tested with device "Terratec Cinergy 200 USB"

Patches 1+2: preparation
Patch 3: actual dependency removal
Patches 4+5: clean-up, comment/coding style fixes
Patches 6+7: code size optimizations (optional)


Frank Schäfer (7):
  em28xx-input: remove dead code line from em28xx_get_key_em_haup()
  em28xx: remove i2cdprintk() messages
  em28xx: get rid of the dependency on module ir-kbd-i2c
  em28xx: remove unused parameter ir_raw from i2c RC key polling
    functions
  em28xx: fix a comment and a small coding style issue
  em28xx: i2c RC devices: minor code size and memory usage optimization
  em28xx: input: use common work_struct callback function for IR RC key
    polling

 drivers/media/usb/em28xx/em28xx-input.c |  230 ++++++++++++++++---------------
 drivers/media/usb/em28xx/em28xx.h       |    3 -
 2 Dateien geändert, 116 Zeilen hinzugefügt(+), 117 Zeilen entfernt(-)

-- 
1.7.10.4

