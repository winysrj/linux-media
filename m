Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58373 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2LPSXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 13:23:30 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2061535eaa.19
        for <linux-media@vger.kernel.org>; Sun, 16 Dec 2012 10:23:29 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 0/5] em28xx: i2c bug fixes and cleanups
Date: Sun, 16 Dec 2012 19:23:26 +0100
Message-Id: <1355682211-13604-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains some I2C bug fixes / cleanups / unifications and 
improvements for the em28xx driver, which I've made while working on adding 
support for the em25xx/em276x i2c bus B support and playing with the 
Terratec Cinergy 200 USB which I've got recently.

Patches 1 and 5 are cleanup/unification patches, patches 2, 3, 4 fix some bugs.
Patch 3 actually fixes 2 bugs, but separate commits didn't make sense, because 
more or less the whole function had to be rewritten.

Changelog v2:
- removed i2c address type/range check from patch 5 as requested by Antti Palosaari


Frank Schäfer (5):
  em28xx: clean up the data type mess of the i2c transfer function
    parameters
  em28xx: respect the message size constraints for i2c transfers
  em28xx: fix two severe bugs in function em2800_i2c_recv_bytes()
  em28xx: fix the i2c adapter functionality flags
  em28xx: fix+improve+unify i2c error handling, debug messages and code
    comments

 drivers/media/usb/em28xx/em28xx-core.c |    5 +-
 drivers/media/usb/em28xx/em28xx-i2c.c  |  276 +++++++++++++++++++-------------
 drivers/media/usb/em28xx/em28xx.h      |    2 +-
 3 Dateien geändert, 168 Zeilen hinzugefügt(+), 115 Zeilen entfernt(-)

-- 
1.7.10.4

