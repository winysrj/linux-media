Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1GKB73 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:29 -0400
Date: Sun, 10 Jul 2011 22:59:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 00/21] drx-k patches and Terratec H5 support (em28xx)
Message-ID: <20110710225907.29f002e1@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This patch series applies after the DRX-K/ngene/ddbridge patches that
Oliver Endriss submitted.

It does a cleanup on several small issues at drx-k, including driver
removal. It also adds support for Terratec H5 (only DVB-C were tested).
In order to use Terratec H5, a different firmware is needed. I'm trying
to get a formal permission to release the firmware, or to find some time
to write an extraction logic for get_firmware script.

The entire series with DRX-K, ngene support, ddbridge and em28xx are
hosted at my experimental tree, at branch ngene of:
	git://linuxtv.org/mchehab/experimental.git ngene

In order to make DRX-K driver to work with Terratec H5, I used a refence
driver found at Terratec site:
	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz

The driver there is more complete, and has also analog support, but
it didn't work as-is for Terratec H7. On both drivers, there were
some board-specific setup in the middle of the driver. I've parametrized
the ones found at the ngene/drxk in order to allow re-using the same
driver for em28xx/drxk. I suspect that I'll need to add more parameters
for Terratec H7. For example, the driver at Terratec site uses 3 GPIO's 
for H7, while the other drivers don't seem to need any.

In order to allow me to check what was going wrong with Terratec H5, I
wrote a DRX-K parser for em28xx logs, found at:
	http://git.linuxtv.org/v4l-utils.git?a=blob;f=contrib/em28xx/parse_em28xx_drxk.pl;h=8659ccac29c0cac1acfa39907cf0239a3201fe26;hb=86a37d95c8c33e6b877a486104da122a0a05931c

The parser helped a lot to discover what commands were generating errors,
allowing me to compare with the reference drivers and discovering what
were broken. I hope it may be useful also for the others. It shouldn't
be hard to change it to parse logs from other usb devices.

It is possible to check what's happening in real time with:

	sudo ./parse_tcpdump_log.pl |./em28xx/parse_em28xx_drxk.pl

I'll post a message as soon as I find a way to allow people to obtain
the DRX-K firmware needed for Terratec H5.

I intend to merge the Oliver series, plus mine on this week. So, tests with
ngene/ddbridge are welcome, to be sure that none of my patches broke
support for them.

Thanks!
Mauro

Mauro Carvalho Chehab (21):
  [media] drxk: add drxk prefix to the errors
  [media] tda18271c2dd: add tda18271c2dd prefix to the errors
  [media] drxk: Add debug printk's
  [media] drxk: remove _0 from read/write routines
  [media] drxk: Move I2C address into a config structure
  [media] drxk: Convert an #ifdef logic as a new config parameter
  [media] drxk: Avoid OOPSes if firmware is corrupted
  [media] drxk: Print an error if firmware is not loaded
  [media] Add initial support for Terratec H5
  [media] drxk: Add a parameter for the microcode name
  [media] em28xx-i2c: Add a read after I2C write
  [media] drxk: Allow to disable I2C Bridge control switch
  [media] drxk: Proper handle/propagate the error codes
  [media] drxk: change mode before calling the set mode routines
  [media] drxk: Fix the antenna switch logic
  [media] drxk: Print detected configuration
  [media] drxk: Improves the UIO handling
  [media] drxk: Fix driver removal
  [media] drxk: Simplify the DVB-C set mode logic
  [media] drxk: Improve the scu_command error message
  [media] drxk: Add a fallback method for QAM parameter setting

 drivers/media/dvb/ddbridge/ddbridge-core.c |    8 +-
 drivers/media/dvb/frontends/drxk.h         |   29 +-
 drivers/media/dvb/frontends/drxk_hard.c    | 7788 ++++++++++++++--------------
 drivers/media/dvb/frontends/drxk_hard.h    |   20 +-
 drivers/media/dvb/frontends/tda18271c2dd.c |   10 +-
 drivers/media/dvb/ngene/ngene-cards.c      |    9 +-
 drivers/media/video/em28xx/Kconfig         |    2 +
 drivers/media/video/em28xx/em28xx-cards.c  |   37 +
 drivers/media/video/em28xx/em28xx-core.c   |    8 +-
 drivers/media/video/em28xx/em28xx-dvb.c    |  111 +-
 drivers/media/video/em28xx/em28xx-i2c.c    |   15 +-
 drivers/media/video/em28xx/em28xx-reg.h    |    1 +
 drivers/media/video/em28xx/em28xx.h        |    4 +-
 13 files changed, 4266 insertions(+), 3776 deletions(-)

