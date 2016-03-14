Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:33503 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbcCNB6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 21:58:55 -0400
Received: by mail-lb0-f175.google.com with SMTP id k15so221811771lbg.0
        for <linux-media@vger.kernel.org>; Sun, 13 Mar 2016 18:58:54 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH] Add tw5864 driver - cover letter
Date: Mon, 14 Mar 2016 03:58:33 +0200
Message-Id: <1457920713-21009-1-git-send-email-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a driver for multimedia devices based on Techwell/Intersil TW5864 chip.

It is basically written from scratch. There was an awful reference driver for
2.6 kernel, which is nearly million lines of code and requires half a dozen
special userspace libraries, and still doesn't quite work. So currently
submitted driver is a product of reverse-engineering and heuristics. tw68
driver was used as code skeleton.

The device advertises many capabilities, but this version of driver only
supports H.264 encoding of captured video channels.

There is one known issue, which reproduces on two of five setups of which I
know: P-frames are distorted, but I-frames are fine. Changing quality and
framerate settings does not affect this. Currently such workaround is used:

v4l2-ctl -d /dev/video$n -c video_gop_size=1

GOP size is set to 1, so that every output frame is I-frame. 
We are regularly contacting manufacturer regarding such issues, but
unfortunately they can do little to help us.


Andrey Utkin (1):
  Add tw5864 driver

 MAINTAINERS                                  |    7 +
 drivers/staging/media/Kconfig                |    2 +
 drivers/staging/media/Makefile               |    1 +
 drivers/staging/media/tw5864/Kconfig         |   11 +
 drivers/staging/media/tw5864/Makefile        |    3 +
 drivers/staging/media/tw5864/tw5864-bs.h     |  154 ++
 drivers/staging/media/tw5864/tw5864-config.c |  359 +++++
 drivers/staging/media/tw5864/tw5864-core.c   |  453 ++++++
 drivers/staging/media/tw5864/tw5864-h264.c   |  183 +++
 drivers/staging/media/tw5864/tw5864-reg.h    | 2200 ++++++++++++++++++++++++++
 drivers/staging/media/tw5864/tw5864-tables.h |  237 +++
 drivers/staging/media/tw5864/tw5864-video.c  | 1364 ++++++++++++++++
 drivers/staging/media/tw5864/tw5864.h        |  280 ++++
 include/linux/pci_ids.h                      |    1 +
 14 files changed, 5255 insertions(+)
 create mode 100644 drivers/staging/media/tw5864/Kconfig
 create mode 100644 drivers/staging/media/tw5864/Makefile
 create mode 100644 drivers/staging/media/tw5864/tw5864-bs.h
 create mode 100644 drivers/staging/media/tw5864/tw5864-config.c
 create mode 100644 drivers/staging/media/tw5864/tw5864-core.c
 create mode 100644 drivers/staging/media/tw5864/tw5864-h264.c
 create mode 100644 drivers/staging/media/tw5864/tw5864-reg.h
 create mode 100644 drivers/staging/media/tw5864/tw5864-tables.h
 create mode 100644 drivers/staging/media/tw5864/tw5864-video.c
 create mode 100644 drivers/staging/media/tw5864/tw5864.h

-- 
2.7.1.380.g0fea050.dirty

