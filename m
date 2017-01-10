Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34874 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932557AbdAJDOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 22:14:07 -0500
Received: by mail-qk0-f194.google.com with SMTP id u25so74294766qki.2
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2017 19:14:06 -0800 (PST)
Date: Mon, 9 Jan 2017 22:14:04 -0500
From: Kevin Cheng <kcheng@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v3 0/2] Support for Hauppauge WinTV-dualHD 01595 ATSC/QAM
Message-ID: <20170110031402.42eexemy57ge3rch@whisper>
References: <693918b2-bfbe-9827-a11a-e1f73f4ac019@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <693918b2-bfbe-9827-a11a-e1f73f4ac019@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds support for the Hauppauge WinTV-dualHD TV tuner USB stick.


Changes in response to review comments:
* Removed extra struct initialization in lgdt3306a.c
* Simplified initialization in em28xx-dvb.c


Kevin Cheng (2):
  [media] lgdt3306a: support i2c mux for use by em28xx
  [media] em28xx: support for Hauppauge WinTV-dualHD 01595 ATSC/QAM

 drivers/media/dvb-frontends/Kconfig     |   2 +-
 drivers/media/dvb-frontends/lgdt3306a.c | 108 ++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/lgdt3306a.h |   4 ++
 drivers/media/usb/em28xx/em28xx-cards.c |  19 ++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   |  78 +++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |   1 +
 6 files changed, 211 insertions(+), 1 deletion(-)

-- 
2.9.3

