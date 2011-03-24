Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49075 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1CXRFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 13:05:36 -0400
Received: by ewy4 with SMTP id 4so135192ewy.19
        for <linux-media@vger.kernel.org>; Thu, 24 Mar 2011 10:05:35 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 24 Mar 2011 13:05:35 -0400
Message-ID: <AANLkTi=hppcpARY1DOOJwK7kyKPe+2Q415jt8dNh8Z=-@mail.gmail.com>
Subject: [GIT PULL] HVR-900 R2 and PCTV 330e DVB support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series finally merges in Ralph Metzler's drx-d driver and
brings up the PCTV 330e and
HVR-900R2.  The patches have been tested for quite some time by users
on the Kernel Labs blog,
and they have been quite happy with them.

The firmware required can be found here:

http://kernellabs.com/firmware/drxd/

The following changes since commit 41f3becb7bef489f9e8c35284dd88a1ff59b190c:

  [media] V4L DocBook: update V4L2 version (2011-03-11 18:09:02 -0300)

are available in the git repository at:
  git://sol.kernellabs.com/dheitmueller/drx.git drxd

Devin Heitmueller (12):
      drx: add initial drx-d driver
      drxd: add driver to Makefile and Kconfig
      drxd: provide ability to control rs byte
      em28xx: enable support for the drx-d on the HVR-900 R2
      drxd: provide ability to disable the i2c gate control function
      em28xx: fix GPIO problem with HVR-900R2 getting out of sync with drx-d
      em28xx: include model number for PCTV 330e
      em28xx: add digital support for PCTV 330e
      drxd: move firmware to binary blob
      em28xx: remove "not validated" flag for PCTV 330e
      em28xx: add remote control support for PCTV 330e
      drxd: Run lindent across sources

 Documentation/video4linux/CARDLIST.em28xx   |    2 +-
 drivers/media/dvb/frontends/Kconfig         |   11 +
 drivers/media/dvb/frontends/Makefile        |    2 +
 drivers/media/dvb/frontends/drxd.h          |   61 +
 drivers/media/dvb/frontends/drxd_firm.c     |  929 ++
 drivers/media/dvb/frontends/drxd_firm.h     |  118 +
 drivers/media/dvb/frontends/drxd_hard.c     | 2806 ++++++
 drivers/media/dvb/frontends/drxd_map_firm.h |12694 +++++++++++++++++++++++++++
 drivers/media/video/em28xx/em28xx-cards.c   |   21 +-
 drivers/media/video/em28xx/em28xx-dvb.c     |   22 +-
 drivers/media/video/em28xx/em28xx.h         |    2 +-
 11 files changed, 16649 insertions(+), 19 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/drxd.h
 create mode 100644 drivers/media/dvb/frontends/drxd_firm.c
 create mode 100644 drivers/media/dvb/frontends/drxd_firm.h
 create mode 100644 drivers/media/dvb/frontends/drxd_hard.c
 create mode 100644 drivers/media/dvb/frontends/drxd_map_firm.h


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
