Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47588 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2HLXQc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 19:16:32 -0400
Received: by yhmm54 with SMTP id m54so2714195yhm.19
        for <linux-media@vger.kernel.org>; Sun, 12 Aug 2012 16:16:31 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 12 Aug 2012 19:16:30 -0400
Message-ID: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com>
Subject: [GIT PULL] ViewCast O820E capture support added
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>
Cc: Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

A new PCIe bridge driver below. It was released a couple of months ago
to the public, probably about time
we got this into the request queue. I'll review the linux-firmware
additions shortly, I have a firmware blob
and flexible license for the distros.

The following changes since commit da2cd767f537082be0a02d83f87e0da4270e25b2:

  [media] ttpci: add support for Omicom S2 PCI (2012-08-12 14:41:26 -0300)

are available in the git repository at:
  git://git.kernellabs.com/stoth/media_tree.git o820e

Steven Toth (1):
      [media] vc8x0: Add support for the ViewCast O820E card.

 drivers/media/video/Kconfig                 |    2 +
 drivers/media/video/Makefile                |    1 +
 drivers/media/video/vc8x0/Kconfig           |   14 +
 drivers/media/video/vc8x0/Makefile          |   10 +
 drivers/media/video/vc8x0/vc8x0-ad7441.c    | 3057 +++++++++++++++++++++++++++
 drivers/media/video/vc8x0/vc8x0-audio.c     |  736 +++++++
 drivers/media/video/vc8x0/vc8x0-buffer.c    |  338 +++
 drivers/media/video/vc8x0/vc8x0-cards.c     |  138 ++
 drivers/media/video/vc8x0/vc8x0-channel.c   |  934 ++++++++
 drivers/media/video/vc8x0/vc8x0-core.c      |  887 ++++++++
 drivers/media/video/vc8x0/vc8x0-display.c   | 1359 ++++++++++++
 drivers/media/video/vc8x0/vc8x0-dma.c       | 2677 +++++++++++++++++++++++
 drivers/media/video/vc8x0/vc8x0-eeprom.c    |   71 +
 drivers/media/video/vc8x0/vc8x0-fw.c        |  429 ++++
 drivers/media/video/vc8x0/vc8x0-i2c.c       |  290 +++
 drivers/media/video/vc8x0/vc8x0-pcm3052.c   |  192 ++
 drivers/media/video/vc8x0/vc8x0-reg.h       |  214 ++
 drivers/media/video/vc8x0/vc8x0-timestamp.c |  156 ++
 drivers/media/video/vc8x0/vc8x0-vga.c       |  430 ++++
 drivers/media/video/vc8x0/vc8x0-video.c     | 2650 +++++++++++++++++++++++
 drivers/media/video/vc8x0/vc8x0.h           |  995 +++++++++
 21 files changed, 15580 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/vc8x0/Kconfig
 create mode 100644 drivers/media/video/vc8x0/Makefile
 create mode 100644 drivers/media/video/vc8x0/vc8x0-ad7441.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-audio.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-buffer.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-cards.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-channel.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-core.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-display.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-dma.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-eeprom.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-fw.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-i2c.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-pcm3052.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-reg.h
 create mode 100644 drivers/media/video/vc8x0/vc8x0-timestamp.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-vga.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0-video.c
 create mode 100644 drivers/media/video/vc8x0/vc8x0.h

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
