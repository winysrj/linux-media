Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:45003 "EHLO
        homiemail-a68.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934004AbeALQUC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 11:20:02 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/7] cx231xx: Add multiple frontend USB device
Date: Fri, 12 Jan 2018 10:19:35 -0600
Message-Id: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set requires:

https://patchwork.linuxtv.org/patch/46396/
https://patchwork.linuxtv.org/patch/46397/

The Hauppauge HVR-975 is a dual frontend, single tuner USB device.
The 975 has lgdt3306a (currently enabled) and si2168 demodulators,
and one si2157 tuner. It provides analog capture via breakout cable.

This patch set adds pieces to the cx231xx USB bridge to allow a
second frontend, whether it is old dvb_attach style, or new i2c
device style. A new field is added to board config to accomodate
second demod address.

To accomodate addubg the second demodulator to the si2157 tuner,
hybrid tuner instance functionality was added. The contents of
probe, moved to attach, and .release is provided for shared
instances to clean their state. All changes are backwards
compatible and transparent to current usages.

The si2168 frontend driver required addition of ts bus control,
without this both frontends remain active, after switching between,
and the demux provides no data thereafter.

Finally the second demod is added to the HVR975 and attached
to the si2157.


Brad Love (7):
  cx231xx: Add second frontend option
  cx231xx: Add second i2c demod client
  si2157: Add hybrid tuner support
  si2168: Add ts bus coontrol, turn off bus on sleep
  si2168: Announce frontend creation failure
  lgdt3306a: Announce successful creation
  cx231xx: Add second i2c demod to Hauppauge 975

 drivers/media/dvb-frontends/lgdt3306a.c     |   4 +-
 drivers/media/dvb-frontends/si2168.c        |  40 ++++-
 drivers/media/dvb-frontends/si2168.h        |   1 +
 drivers/media/pci/saa7164/saa7164-dvb.c     |  11 +-
 drivers/media/tuners/si2157.c               | 232 +++++++++++++++++-------
 drivers/media/tuners/si2157.h               |  14 ++
 drivers/media/tuners/si2157_priv.h          |   5 +
 drivers/media/usb/cx231xx/cx231xx-cards.c   |   1 +
 drivers/media/usb/cx231xx/cx231xx-dvb.c     | 269 ++++++++++++++++++----------
 drivers/media/usb/cx231xx/cx231xx-dvb.c.rej |  11 ++
 drivers/media/usb/cx231xx/cx231xx.h         |   1 +
 11 files changed, 411 insertions(+), 178 deletions(-)
 create mode 100644 drivers/media/usb/cx231xx/cx231xx-dvb.c.rej

-- 
2.7.4
