Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37551 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbdIBLmu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 07:42:50 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/7] a800 dvb rc changes
Date: Sat,  2 Sep 2017 12:42:41 +0100
Message-Id: <cover.1504352252.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various changes to make the a800 dvb adapter work again and to
improve its ir receiver.

Sean Young (7):
  media: dvb: i2c transfers over usb cannot be done from stack
  media: dvb: a800: port to rc-core
  media: rc: avermedia keymap for a800
  media: rc: ensure that protocols are enabled for scancode drivers
  media: rc: dvb: use dvb device name for rc device
  media: rc: if protocols can't be changed, don't be writable
  media: rc: include device name in rc udev event

 drivers/media/cec/cec-core.c                  |  1 -
 drivers/media/dvb-frontends/dib3000mc.c       | 50 ++++++++++++++++-----
 drivers/media/dvb-frontends/dvb-pll.c         | 21 ++++++---
 drivers/media/i2c/ir-kbd-i2c.c                |  1 -
 drivers/media/rc/keymaps/rc-avermedia-m135a.c |  3 +-
 drivers/media/rc/rc-main.c                    | 33 +++++++++++---
 drivers/media/tuners/mt2060.c                 | 59 +++++++++++++++++++-----
 drivers/media/usb/dvb-usb/a800.c              | 65 ++++++---------------------
 drivers/media/usb/dvb-usb/dvb-usb-remote.c    |  2 +-
 9 files changed, 145 insertions(+), 90 deletions(-)

-- 
2.13.5
