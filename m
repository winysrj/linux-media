Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:49559 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3ACS0w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 13:26:52 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so7036582wgb.13
        for <linux-media@vger.kernel.org>; Thu, 03 Jan 2013 10:26:51 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, saschasommer@freenet.de,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v3 0/5] em28xx: i2c bug fixes and cleanups
Date: Thu,  3 Jan 2013 19:27:01 +0100
Message-Id: <1357237626-3358-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains some I2C bug fixes / cleanups / unifications and 
improvements for the em28xx driver, which I've made while working on adding 
support for the em25xx/em276x i2c bus B support and playing with the 
Terratec Cinergy 200 USB which I've got recently.

Patches 1, 2, 3, 5 fix some bugs, patch 4 is a cleanup/unification patch.
Patch 2 actually fixes 2 bugs, but separate commits didn't make sense, because 
more or less the whole function had to be rewritten.

Changelog:
v2: - removed i2c address type/range check from patch 5 as requested by Antti Palosaari
v3: - removed patch 1 (already applied)
    - added comment that explains the reasons for the i2c message size restrictions
      on em28xx devices
    - added another patch that fixes eeprom reading with the em2800

Frank Schäfer (5):
  em28xx: respect the message size constraints for i2c transfers
  em28xx: fix two severe bugs in function em2800_i2c_recv_bytes()
  em28xx: fix the i2c adapter functionality flags
  em28xx: fix+improve+unify i2c error handling, debug messages and code
    comments
  em28xx: consider the message length limitation of the i2c adapter
    when reading the eeprom

 drivers/media/usb/em28xx/em28xx-core.c |    5 +-
 drivers/media/usb/em28xx/em28xx-i2c.c  |  276 ++++++++++++++++++++------------
 drivers/media/usb/em28xx/em28xx.h      |    2 +-
 3 Dateien geändert, 176 Zeilen hinzugefügt(+), 107 Zeilen entfernt(-)

-- 
1.7.10.4

