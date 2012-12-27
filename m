Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:59169 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2L0XCe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 18:02:34 -0500
Received: by mail-ee0-f43.google.com with SMTP id e49so5041506eek.2
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 15:02:33 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/6] em28xx: make remote controls of devices with external IR IC working again
Date: Fri, 28 Dec 2012 00:02:42 +0100
Message-Id: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for remote controls of em28xx devices with external IR receiver/decoder 
IC are broken since a long time. This patch series makes them working again and 
fixes+improves several parts of the code.


Frank Schäfer (6):
  em28xx: simplify device state tracking
  em28xx: refactor the code in em28xx_usb_disconnect()
  em28xx: make remote controls of devices with external IR IC working
    again
  em28xx: IR RC: get rid of function em28xx_get_key_terratec()
  em28xx: IR RC: move assignment of get_key functions from
    *_change_protocol() functions to em28xx_ir_init()
  ir-kbd-i2c: fix get_key_knc1()

 drivers/media/i2c/ir-kbd-i2c.c          |   15 +--
 drivers/media/usb/em28xx/em28xx-cards.c |   38 ++++---
 drivers/media/usb/em28xx/em28xx-core.c  |    4 +-
 drivers/media/usb/em28xx/em28xx-dvb.c   |    4 +-
 drivers/media/usb/em28xx/em28xx-i2c.c   |    1 +
 drivers/media/usb/em28xx/em28xx-input.c |  176 ++++++++++++++-----------------
 drivers/media/usb/em28xx/em28xx-video.c |   12 +--
 drivers/media/usb/em28xx/em28xx.h       |   12 +--
 8 Dateien geändert, 111 Zeilen hinzugefügt(+), 151 Zeilen entfernt(-)

-- 
1.7.10.4
