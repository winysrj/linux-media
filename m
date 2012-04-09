Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39904 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2DIWBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2012 18:01:42 -0400
Received: by vbbff1 with SMTP id ff1so2600234vbb.19
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2012 15:01:42 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 9 Apr 2012 18:01:41 -0400
Message-ID: <CAOcJUbyysfOU9nNgwr8mV0Aw_fENGNUxGZ5zfLdEAqyukmoR5A@mail.gmail.com>
Subject: [PULL] git://git.linuxtv.org/mkrufky/hauppauge.git voyager
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please merge this into your staging/for_v3.5 tree.

The following changes since commit 296da3cd14db9eb5606924962b2956c9c656dbb0:

  [media] pwc: poll(): Check that the device has not beem claimed for
streaming already (2012-03-27 11:42:04 -0300)

are available in the git repository at:
  git://git.linuxtv.org/mkrufky/hauppauge.git voyager

Michael Krufky (4):
      au0828-dvb: attach tuner based on dev->board.tuner_type on hvr950q
      au8522: build ATV/DTV demodulators as separate modules
      au8522_common: add missing MODULE_LICENSE
      au8522_common: dont EXPORT_SYMBOL(au8522_led_gpio_enable)

 drivers/media/dvb/frontends/Kconfig         |   22 ++-
 drivers/media/dvb/frontends/Makefile        |    5 +-
 drivers/media/dvb/frontends/au8522_common.c |  259 +++++++++++++++++++++++++++
 drivers/media/dvb/frontends/au8522_dig.c    |  215 ----------------------
 drivers/media/dvb/frontends/au8522_priv.h   |    2 +
 drivers/media/video/au0828/Kconfig          |    3 +-
 drivers/media/video/au0828/au0828-dvb.c     |   27 +++-
 7 files changed, 307 insertions(+), 226 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/au8522_common.c

Cheers,

Mike Krufky
