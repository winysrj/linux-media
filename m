Return-path: <linux-media-owner@vger.kernel.org>
Received: from twinsen.zall.org ([109.74.194.249]:57558 "EHLO twinsen.zall.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751661AbdDARgF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Apr 2017 13:36:05 -0400
Date: Sat, 1 Apr 2017 17:30:45 +0000
From: Alyssa Milburn <amilburn@zall.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] media: fix some potential buffer overruns
Message-ID: <cover.1491066251.git.amilburn@zall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I don't own any of this hardware, so I can't test these patches; I'd
appreciate it if someone with the hardware could do so, but in theory
they shouldn't break anything.

Most of the patches below fix overruns which can be induced by local
users, but only if they can read or write to i2c devices. The zr364xx
patch is probably only needed against malicious hardware.

This is against mainline, not linux-media. Sorry. The dw2102 patch will
not apply cleanly due to 606142af57dad981b78707234cfbd15f9f7b7125, which
changed the relevant code (moving from stack to heap buffers), but
backporting it seems silly.

I tried to make these patches as non-invasive as possible, and to stick
with any existing error reporting style where present. I have more fixes
planned, so any feedback on this approach would be appreciated.

Alyssa Milburn (4):
  digitv: limit messages to buffer size
  zr364xx: enforce minimum size when reading header
  ttusb2: limit messages to buffer size
  dw2102: limit messages to buffer size

 drivers/media/usb/dvb-usb/digitv.c  |  3 +++
 drivers/media/usb/dvb-usb/dw2102.c  | 54 +++++++++++++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb/ttusb2.c  | 19 +++++++++++++
 drivers/media/usb/zr364xx/zr364xx.c |  8 ++++++
 4 files changed, 84 insertions(+)

-- 
2.11.0
