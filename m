Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48601 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754226AbcJNRrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/25] Do some printk cleanups to avoid troubles with continuation lines
Date: Fri, 14 Oct 2016 14:45:38 -0300
Message-Id: <cover.1476466574.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit:

	commit 563873318d328d9bbab4b00dfd835ac7c7e28697
	Merge: 24532f768121 bfd8d3f23b51
	Author: Linus Torvalds <torvalds@linux-foundation.org>
	Date:   Mon Oct 10 09:29:50 2016 -0700

	Merge branch 'printk-cleanups'

Affects dmesg prints like:
	printk(KERN_INFO "foo");
	printk(" bar\n);

Won't be doing the same output, as the Kernel won't understand the second
printk as a continuation.

That's said, some media drivers use some very old driver-specific way
of outputting messages, that came before pr_foo() and dev_foo() started
being used at the subsystem.

This patch series start fixing those issues. I have another series of ~30-40
patches already, but they require more work, as they use dev_foo(), with
could potentially cause some regression, and touch on a lot of drivers.

They also depend on a big patch that merges big printk lines, that I also
want to split into smaller ones.

So, let me flush a series of cases that handle simpler cases. 

Mauro Carvalho Chehab (25):
  [media] tuner-xc2028: mark printk continuation lines as such
  [media] tuner-xc2028: don't break long lines
  [media] em28xx: don't break long lines
  [media] em28xx: mark printk continuation lines as such
  [media] em28xx: use pr_foo instead of em28xx-specific printk macros
  [media] em28xx: convert the remaining printks to pr_foo
  [media] dvb-core: don't break long lines
  [media] tuner-core: don't break long lines
  [media] tuner-core: use %&ph for small buffer dumps
  [media] radio-bcm2048: don't ignore errors
  [media] dvb-core: use pr_foo() instead of printk()
  [media] dvb_demux: convert an internal ifdef into a Kconfig option
  [media] dvb_demux: uncomment a packet loss check code
  [media] dvb-core: get rid of demux optional circular buffer
  [media] dvb-core: move dvb_filter out of the DVB core
  [media] dvb_filter: get rid of dead code
  [media] dvb_filter: use KERN_CONT where needed
  [media] uvc_driver: use KERN_CONT where needed
  [media] imon: use %*ph to do small hexa dumps
  [media] mt20xx: use %*ph to do small hexa dumps
  [media] tvaudio: mark printk continuation lines as such
  [media] flexcop-i2c: mark printk continuation lines as such
  [media] cx2341x: mark printk continuation lines as such
  [media] dvb-pll: use pr_foo() macros instead of printk()
  [media] nxt6000: use pr_foo() macros instead of printk()

 drivers/media/common/b2c2/flexcop-common.h         |   1 -
 drivers/media/common/b2c2/flexcop-i2c.c            |  10 +-
 drivers/media/common/cx2341x.c                     |  12 +-
 drivers/media/dvb-core/Kconfig                     |  13 +
 drivers/media/dvb-core/Makefile                    |   2 +-
 drivers/media/dvb-core/demux.h                     |   5 +-
 drivers/media/dvb-core/dmxdev.c                    |  28 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |  57 +-
 drivers/media/dvb-core/dvb_demux.c                 | 115 ++--
 drivers/media/dvb-core/dvb_demux.h                 |   2 -
 drivers/media/dvb-core/dvb_filter.c                | 603 ---------------------
 drivers/media/dvb-core/dvb_frontend.c              |  12 +-
 drivers/media/dvb-core/dvb_net.c                   |  85 +--
 drivers/media/dvb-core/dvbdev.c                    |  25 +-
 drivers/media/dvb-frontends/dvb-pll.c              |  19 +-
 drivers/media/dvb-frontends/nxt6000.c              | 136 +++--
 drivers/media/i2c/tvaudio.c                        |   5 +-
 drivers/media/pci/ttpci/Makefile                   |   2 +-
 drivers/media/pci/ttpci/dvb_filter.c               | 114 ++++
 drivers/media/{dvb-core => pci/ttpci}/dvb_filter.h |   0
 drivers/media/rc/imon.c                            |   7 +-
 drivers/media/tuners/mt20xx.c                      |  21 +-
 drivers/media/tuners/tuner-xc2028.c                | 116 ++--
 drivers/media/usb/em28xx/em28xx-audio.c            |  45 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |  53 +-
 drivers/media/usb/em28xx/em28xx-cards.c            | 153 +++---
 drivers/media/usb/em28xx/em28xx-core.c             | 105 ++--
 drivers/media/usb/em28xx/em28xx-dvb.c              |  73 ++-
 drivers/media/usb/em28xx/em28xx-i2c.c              | 183 +++----
 drivers/media/usb/em28xx/em28xx-input.c            |  29 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |   7 +-
 drivers/media/usb/em28xx/em28xx-video.c            | 105 ++--
 drivers/media/usb/em28xx/em28xx.h                  |  18 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |  58 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  30 +-
 drivers/media/v4l2-core/tuner-core.c               |  15 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c      |   2 +
 37 files changed, 896 insertions(+), 1370 deletions(-)
 delete mode 100644 drivers/media/dvb-core/dvb_filter.c
 create mode 100644 drivers/media/pci/ttpci/dvb_filter.c
 rename drivers/media/{dvb-core => pci/ttpci}/dvb_filter.h (100%)

-- 
2.7.4


