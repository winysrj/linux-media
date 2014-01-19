Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:64436 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaASVrk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 16:47:40 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so3071791eek.23
        for <linux-media@vger.kernel.org>; Sun, 19 Jan 2014 13:47:39 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/4] em28xx: resolve the remaining issues with the i2c code
Date: Sun, 19 Jan 2014 22:48:33 +0100
Message-Id: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This small patch series resolves the remaing issues with the em82xx i2c code
which have been introduced with the recent changes.


Frank Schäfer (4):
  em28xx-i2c: fix the i2c error description strings for -ENXIO
  em28xx-i2c: fix the error code for unknown errors
  em28xx-i2c: do not map -ENXIO errors to -ENODEV for empty i2c
    transfers
  em28xx-i2c: remove duplicate error printing code from
    em28xx_i2c_xfer()

 drivers/media/usb/em28xx/em28xx-i2c.c |   53 ++++++++++++++++++++-------------
 1 Datei geändert, 32 Zeilen hinzugefügt(+), 21 Zeilen entfernt(-)

-- 
1.7.10.4

