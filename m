Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:25336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab1DSVZR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 17:25:17 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p3JLPGdQ029281
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 19 Apr 2011 17:25:16 -0400
Date: Tue, 19 Apr 2011 17:25:15 -0400
From: Jarod Wilson <jarod@redhat.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL REQ] IR additions and misc media fixes for 2.6.40
Message-ID: <20110419212515.GA25900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

IR additions and misc minor media_tree fixes for 2.6.40. There's an input.h
patch included in here, which was merged in 2.6.39-rc4, that the patch
just after it depends upon, wasn't quite sure how to handle that, since it
wasn't already in the staging/for_v2.6.40 branch that this is on top of...

The main IR additions are the improved support for more variants of the
Nuvoton Super I/O LPC integrated CIR function in nuvoton-cir and the
addition of a TiVo keymap which is now used by default with the mceusb
driven TiVo branded transceiver that ships in the Nero LiquidTV bundle.

The following changes since commit f2dae48f7f0888fdfb978677ab0d03af468c2218:

  [media] gspca - kinect: New subdriver for Microsoft Kinect (2011-04-19 17:24:56 -0300)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-ir.git linuxtv-dev

Jarod Wilson (10):
      rc: add tivo/nero liquidtv keymap
      mceusb: tivo transceiver should default to tivo keymap
      Input: add KEY_IMAGES specifically for AL Image Browser
      [media] rc: further key name standardization
      [media] rc/nuvoton-cir: only warn about unknown chips
      [media] rc/nuvoton-cir: enable CIR on w83667hg chip variant
      [media] mceusb: Formosa e017 device has no tx
      ttusb-budget: driver has a debug param, use it
      lirc_sasem: key debug spew off debug modparam
      tm6000: fix vbuf may be used uninitialized

 drivers/media/dvb/dvb-usb/dibusb-common.c          |    2 +-
 drivers/media/dvb/dvb-usb/m920x.c                  |   16 ++--
 drivers/media/dvb/dvb-usb/nova-t-usb2.c            |    2 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |   60 ++++++-------
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |    2 +-
 drivers/media/rc/keymaps/rc-imon-mce.c             |    2 +-
 drivers/media/rc/keymaps/rc-imon-pad.c             |    6 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |    2 +-
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    4 +-
 drivers/media/rc/keymaps/rc-tivo.c                 |   98 ++++++++++++++++++++
 drivers/media/rc/mceusb.c                          |   16 +++-
 drivers/media/rc/nuvoton-cir.c                     |   62 ++++++++++---
 drivers/media/rc/nuvoton-cir.h                     |   17 +++-
 drivers/staging/lirc/lirc_sasem.c                  |   13 ++-
 drivers/staging/tm6000/tm6000-video.c              |    4 +-
 include/linux/input.h                              |    9 +-
 include/media/rc-map.h                             |    1 +
 18 files changed, 235 insertions(+), 82 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-tivo.c

-- 
Jarod Wilson
jarod@redhat.com

