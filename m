Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:43829 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051AbbAPJ3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 04:29:42 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B410B2A002F
	for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 10:29:23 +0100 (CET)
Message-ID: <54B8D9F3.9080706@xs4all.nl>
Date: Fri, 16 Jan 2015 10:29:23 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.20] Remove deprecated drivers
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As promised, remove the deprecated tlg2300, vino, saa7191, bw-qcam, c-qcam and
pms drivers.

Regards,

	Hans

The following changes since commit 99f3cd52aee21091ce62442285a68873e3be833f:

  [media] vb2-vmalloc: Protect DMA-specific code by #ifdef CONFIG_HAS_DMA (2014-12-23 16:28:09 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git removedrvs

for you to fetch changes up to c93947c835df35500b952b2bdfea603ef54529fe:

  Documentation/video4linux: remove obsolete text files (2015-01-16 10:26:54 +0100)

----------------------------------------------------------------
Hans Verkuil (4):
      tlg2300: remove deprecated staging driver
      vino/saa7191: remove deprecated drivers
      bw/c-qcam, w9966, pms: remove deprecated staging drivers
      Documentation/video4linux: remove obsolete text files

 Documentation/video4linux/CQcam.txt        |  205 ----
 Documentation/video4linux/README.tlg2300   |   47 -
 Documentation/video4linux/w9966.txt        |   33 -
 MAINTAINERS                                |   22 -
 drivers/staging/media/Kconfig              |    6 -
 drivers/staging/media/Makefile             |    4 -
 drivers/staging/media/parport/Kconfig      |   69 --
 drivers/staging/media/parport/Makefile     |    4 -
 drivers/staging/media/parport/bw-qcam.c    | 1177 ----------------------
 drivers/staging/media/parport/c-qcam.c     |  882 -----------------
 drivers/staging/media/parport/pms.c        | 1156 ----------------------
 drivers/staging/media/parport/w9966.c      |  980 ------------------
 drivers/staging/media/tlg2300/Kconfig      |   20 -
 drivers/staging/media/tlg2300/Makefile     |    9 -
 drivers/staging/media/tlg2300/pd-alsa.c    |  337 -------
 drivers/staging/media/tlg2300/pd-common.h  |  270 -----
 drivers/staging/media/tlg2300/pd-dvb.c     |  597 -----------
 drivers/staging/media/tlg2300/pd-main.c    |  553 -----------
 drivers/staging/media/tlg2300/pd-radio.c   |  336 -------
 drivers/staging/media/tlg2300/pd-video.c   | 1560 -----------------------------
 drivers/staging/media/tlg2300/vendorcmds.h |  243 -----
 drivers/staging/media/vino/Kconfig         |   24 -
 drivers/staging/media/vino/Makefile        |    3 -
 drivers/staging/media/vino/indycam.c       |  378 -------
 drivers/staging/media/vino/indycam.h       |   93 --
 drivers/staging/media/vino/saa7191.c       |  649 ------------
 drivers/staging/media/vino/saa7191.h       |  245 -----
 drivers/staging/media/vino/vino.c          | 4345 --------------------------------------------------------------------------------
 drivers/staging/media/vino/vino.h          |  138 ---
 29 files changed, 14385 deletions(-)
 delete mode 100644 Documentation/video4linux/CQcam.txt
 delete mode 100644 Documentation/video4linux/README.tlg2300
 delete mode 100644 Documentation/video4linux/w9966.txt
 delete mode 100644 drivers/staging/media/parport/Kconfig
 delete mode 100644 drivers/staging/media/parport/Makefile
 delete mode 100644 drivers/staging/media/parport/bw-qcam.c
 delete mode 100644 drivers/staging/media/parport/c-qcam.c
 delete mode 100644 drivers/staging/media/parport/pms.c
 delete mode 100644 drivers/staging/media/parport/w9966.c
 delete mode 100644 drivers/staging/media/tlg2300/Kconfig
 delete mode 100644 drivers/staging/media/tlg2300/Makefile
 delete mode 100644 drivers/staging/media/tlg2300/pd-alsa.c
 delete mode 100644 drivers/staging/media/tlg2300/pd-common.h
 delete mode 100644 drivers/staging/media/tlg2300/pd-dvb.c
 delete mode 100644 drivers/staging/media/tlg2300/pd-main.c
 delete mode 100644 drivers/staging/media/tlg2300/pd-radio.c
 delete mode 100644 drivers/staging/media/tlg2300/pd-video.c
 delete mode 100644 drivers/staging/media/tlg2300/vendorcmds.h
 delete mode 100644 drivers/staging/media/vino/Kconfig
 delete mode 100644 drivers/staging/media/vino/Makefile
 delete mode 100644 drivers/staging/media/vino/indycam.c
 delete mode 100644 drivers/staging/media/vino/indycam.h
 delete mode 100644 drivers/staging/media/vino/saa7191.c
 delete mode 100644 drivers/staging/media/vino/saa7191.h
 delete mode 100644 drivers/staging/media/vino/vino.c
 delete mode 100644 drivers/staging/media/vino/vino.h
