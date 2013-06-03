Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58205 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3FCSKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 14:10:31 -0400
Received: by mail-ea0-f174.google.com with SMTP id z7so3804425eaf.5
        for <linux-media@vger.kernel.org>; Mon, 03 Jun 2013 11:10:30 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/4] em28xx: GPIO registers: extend definitions and remove the caching
Date: Mon,  3 Jun 2013 20:12:01 +0200
Message-Id: <1370283125-2231-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first two patches add some missing GPIO register definitions,
while the third patch is a minor code movement to clean up things.
The fourth patch finally removes the GPIO register caching.

Frank Schäfer (4):
  em28xx: extend GPIO register definitions for the em25xx,
    em276x/7x/8x, em2874/174/84
  em28xx: improve em2820-em2873/83 GPIO port register definitions and
    descriptions
  em28xx: move snapshot button bit definition for reg 0x0C from
    em28xx-input.c to em28xx.h
  em28xx: remove GPIO register caching

 drivers/media/usb/em28xx/em28xx-cards.c |  220 +++++++++++++++----------------
 drivers/media/usb/em28xx/em28xx-core.c  |   27 +---
 drivers/media/usb/em28xx/em28xx-dvb.c   |   68 +++++-----
 drivers/media/usb/em28xx/em28xx-input.c |    1 -
 drivers/media/usb/em28xx/em28xx-reg.h   |   23 +++-
 drivers/media/usb/em28xx/em28xx.h       |    6 -
 6 Dateien geändert, 159 Zeilen hinzugefügt(+), 186 Zeilen entfernt(-)

-- 
1.7.10.4

