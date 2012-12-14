Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41617 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2LNQ26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 11:28:58 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2052143eek.19
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 08:28:57 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, dheitmueller@kernellabs.com,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/5] em28xx: i2c bug fixes and cleanups
Date: Fri, 14 Dec 2012 17:28:48 +0100
Message-Id: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com>
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


Frank Schäfer (5):
  em28xx: clean up the data type mess of the i2c transfer function
    parameters
  em28xx: respect the message size constraints for i2c transfers
  em28xx: fix two severe bugs in function em2800_i2c_recv_bytes()
  em28xx: fix the i2c adapter functionality flags
  em28xx: fix+improve+unify i2c error handling, debug messages and code
    comments

 drivers/media/usb/em28xx/em28xx-core.c |    5 +-
 drivers/media/usb/em28xx/em28xx-i2c.c  |  280 +++++++++++++++++++-------------
 drivers/media/usb/em28xx/em28xx.h      |    2 +-
 3 Dateien geändert, 172 Zeilen hinzugefügt(+), 115 Zeilen entfernt(-)

-- 
1.7.10.4

