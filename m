Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48568 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaALQXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:23:44 -0500
Received: by mail-ee0-f51.google.com with SMTP id b15so2745313eek.10
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 08:23:43 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFT/RFC PATCH 0/8] em28xx: move more v4l/dvb specific code to the extension modules and fix the resources handling
Date: Sun, 12 Jan 2014 17:24:17 +0100
Message-Id: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch 1 is fix for the analog device initialization on the first open() call.
Patches 2-7 move some dvb and v4l specific code from the core module to the 
extension modules and fix the resources releasing logic/order in the core and
the v4l2 module. This will also fix the various sysfs group remove warnings 
which we can see since kernel 3.13.
Patch 8 finally removes some dead code lines and fixes leaking the memory of 
video, vbi and radio video_device structs.

I've tested all patches carefully with the devices I have, but because this is
really critical stuff, they should be reviewed and tested by others, too.


Frank Schäfer (8):
  em28xx-v4l: fix device initialization in em28xx_v4l2_open() for radio
    and VBI mode
  em28xx: move usb buffer pre-allocation and transfer uninit from the
    core to the dvb extension
  em28xx: move usb transfer uninit on device disconnect from the core to
    the v4l-extension
  em28xx: move v4l2_device_disconnect() call from the core to the v4l
    extension
  em28xx-v4l: move v4l2_ctrl_handler freeing and v4l2_device
    unregistration to em28xx_v4l2_fini
  em28xx: move v4l2 dummy clock deregistration from the core to the v4l
    extension
  em28xx: always call em28xx_release_resources() in the usb disconnect
    handler
  em28xx-v4l: fix the freeing of the video devices memory

 drivers/media/usb/em28xx/em28xx-cards.c |   48 ++--------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |   23 ++++++++
 drivers/media/usb/em28xx/em28xx-video.c |   91 +++++++++++++++++++------------
 3 Dateien geändert, 85 Zeilen hinzugefügt(+), 77 Zeilen entfernt(-)

-- 
1.7.10.4

