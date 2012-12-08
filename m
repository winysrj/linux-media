Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38287 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965337Ab2LHPbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 10:31:35 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so548069eaa.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 07:31:34 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/9] em28xx: refactor the frame data processing code
Date: Sat,  8 Dec 2012 16:31:23 +0100
Message-Id: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series refactors the frame data processing code in em28xx-video.c to
- reduce code duplication
- fix a bug in vbi data processing
- prepare for adding em25xx/em276x frame data processing support
- clean up the code and make it easier to understand

It applies on top of my previous patch series 
"em28xx: add support fur USB bulk transfers"
"em28xx: use common urb data copying function for vbi and non-vbi data streams"

The changes have been tested with the following devices:
- "SilverCrest 1.3 MPix webcam" (progressive, non-vbi)
- "Hauppauge HVR-900 (65008/A1C0)" (interlaced, vbi enabled and disabled)


Frank Schäfer (9):
  em28xx: refactor get_next_buf() and use it for vbi data, too
  em28xx: use common function for video and vbi buffer completion
  em28xx: remove obsolete field 'frame' from struct em28xx_buffer
  em28xx: move field 'pos' from struct em28xx_dmaqueue to struct
    em28xx_buffer
  em28xx: refactor VBI data processing code in em28xx_urb_data_copy()
  em28xx: move caching of pointer to vmalloc memory in videobuf to
    struct em28xx_buffer
  em28xx: em28xx_urb_data_copy(): move duplicate code for
    capture_type=0 and capture_type=2 to a function
  em28xx: move the em2710/em2750/em28xx specific frame data processing
    code to a separate function
  em28xx: clean up and unify functions em28xx_copy_vbi()
    em28xx_copy_video()

 drivers/media/usb/em28xx/em28xx-video.c |  374 ++++++++++++-------------------
 drivers/media/usb/em28xx/em28xx.h       |   12 +-
 2 Dateien geändert, 154 Zeilen hinzugefügt(+), 232 Zeilen entfernt(-)

-- 
1.7.10.4

