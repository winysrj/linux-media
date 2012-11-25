Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34934 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2KYKht (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 05:37:49 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3997648eek.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 02:37:47 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/6] em28xx: use common urb data copying function for vbi and non-vbi data streams
Date: Sun, 25 Nov 2012 11:37:31 +0100
Message-Id: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patches 1-5 prepare function em28xx_urb_data_copy_vbi() to also work with non-vbi video data.
Patch 6 finally renames em28xx_urb_data_copy_vbi() and changes to code to use this function for both, vbi and non-vbi video data streams.

The changes have been tested with the following devices:
- "SilverCrest 1.3 MPix webcam" (progressive, non-vbi)
- "Hauppauge HVR-900 (65008/A1C0)" (interlaced, vbi enabled and disabled)

This series applies on top of my previous patch series "em28xx: add support fur USB bulk transfers" V2.



Frank Schäfer (6):
  em28xx: fix video data start position calculation in
    em28xx_urb_data_copy_vbi()
  em28xx: make sure the packet size is >= 4 before checking for headers
    in em28xx_urb_data_copy_vbi()
  em28xx: fix capture type setting in em28xx_urb_data_copy_vbi()
  em28xx: fix/improve frame field handling in
    em28xx_urb_data_copy_vbi()
  em28xx: em28xx_urb_data_copy_vbi(): calculate vbi_size only if needed
  em28xx: use common urb data copying function for vbi and non-vbi data
    streams

 drivers/media/usb/em28xx/em28xx-video.c |  224 ++++++-------------------------
 drivers/media/usb/em28xx/em28xx.h       |    4 +-
 2 Dateien geändert, 46 Zeilen hinzugefügt(+), 182 Zeilen entfernt(-)

-- 
1.7.10.4

