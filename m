Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:63487 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3DMJrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 05:47:41 -0400
Received: by mail-ea0-f173.google.com with SMTP id k11so1589151eaj.32
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 02:47:40 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/3] em28xx: clean up end extend the GPIO port handling
Date: Sat, 13 Apr 2013 11:48:38 +0200
Message-Id: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch 1 removes the unneeded and broken gpio register caching code.
Patch 2 adds the gpio register defintions for the em25xx/em276x/7x/8x
and patch 3 finally adds a new helper function for gpio ports with separate
registers for read and write access.


Frank Schäfer (3):
  em28xx: give up GPIO register tracking/caching
  em28xx: add register defines for em25xx/em276x/7x/8x GPIO registers
  em28xx: add helper function for handling the GPIO registers of newer
    devices

 drivers/media/usb/em28xx/em28xx-cards.c |   12 --------
 drivers/media/usb/em28xx/em28xx-core.c  |   50 ++++++++++++-------------------
 drivers/media/usb/em28xx/em28xx-reg.h   |    8 +++++
 drivers/media/usb/em28xx/em28xx.h       |   11 ++-----
 4 Dateien geändert, 30 Zeilen hinzugefügt(+), 51 Zeilen entfernt(-)

-- 
1.7.10.4

