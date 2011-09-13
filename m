Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33849 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395Ab1IMT5N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 15:57:13 -0400
Message-ID: <4E6FB595.5030204@iki.fi>
Date: Tue, 13 Sep 2011 22:57:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, Chris Rankin <rankincj@yahoo.com>
Subject: [GIT PULL FOR 3.2] PCTV DVB-S2 Stick 460e
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Morjens Mauro

This patch series adds support for PCTV DVB-S2 Stick 460e, that is 
DVB-S2 USB stick.

Is is based of;
* Empia EM28174
* NXP TDA10071 & Conexant CX24118A combo
* Allegro A8293

It introduces two new chipset drivers namely tda10071 and a8293 - former 
is DVB-S/S2 demod + tuner combo and later is LNB controller.

Also Chris Rankin em28xx bug fix is included since it wasn't committed 
to 3.2 tree as today.

regards
Antti


The following changes since commit 2d04c13a507f5a01daa7422cd52250809573cfdb:

   [media] dvb-usb: improve sanity check of adap->active_fe in 
dvb_usb_ctrl_feed (2011-09-09 15:28:04 -0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git pctv_460e

Antti Palosaari (8):
       a8293: Allegro A8293 SEC driver
       tda10071: NXP TDA10071 DVB-S/S2 driver
       em28xx: add support for PCTV DVB-S2 Stick 460e [2013:024f]
       get_dvb_firmware: add dvb-fe-tda10071.fw
       get_dvb_firmware: update tda10071 file url
       tda10071: do not download last byte of fw
       tda10071: change sleeps to more suitable ones
       get_dvb_firmware: whitespace fix

Chris Rankin (1):
       em28xx: ERROR: "em28xx_add_into_devlist" 
[drivers/media/video/em28xx/em28xx.ko] undefined!

  Documentation/dvb/get_dvb_firmware          |   19 +-
  drivers/media/dvb/frontends/Kconfig         |   12 +
  drivers/media/dvb/frontends/Makefile        |    2 +
  drivers/media/dvb/frontends/a8293.c         |  184 ++++
  drivers/media/dvb/frontends/a8293.h         |   41 +
  drivers/media/dvb/frontends/tda10071.c      | 1269 
+++++++++++++++++++++++++++
  drivers/media/dvb/frontends/tda10071.h      |   81 ++
  drivers/media/dvb/frontends/tda10071_priv.h |  122 +++
  drivers/media/video/em28xx/Kconfig          |    2 +
  drivers/media/video/em28xx/em28xx-cards.c   |   33 +-
  drivers/media/video/em28xx/em28xx-dvb.c     |   25 +
  drivers/media/video/em28xx/em28xx.h         |    1 +
  12 files changed, 1788 insertions(+), 3 deletions(-)
  create mode 100644 drivers/media/dvb/frontends/a8293.c
  create mode 100644 drivers/media/dvb/frontends/a8293.h
  create mode 100644 drivers/media/dvb/frontends/tda10071.c
  create mode 100644 drivers/media/dvb/frontends/tda10071.h
  create mode 100644 drivers/media/dvb/frontends/tda10071_priv.h

-- 
http://palosaari.fi/
