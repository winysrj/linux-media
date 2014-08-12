Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaHLVub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/10] Move as102 out of staging
Date: Tue, 12 Aug 2014 18:50:14 -0300
Message-Id: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab (10):
  [media] as102: promote it out of staging
  [media] as102: get rid of FSF mail address
  [media] as102: CodingStyle fixes
  [media] as102: better name the unknown frontend
  [media] as102: Move ancillary routines to the beggining
  [media] as102: get rid of as102_fe_copy_tune_parameters()
  [media] as102: get rid of as10x_fe_copy_tps_parameters()
  [media] as102: prepare as102_fe to be compiled as a module
  [media] as102-fe: make it an independent driver
  Add missing viterbi lock

 drivers/media/dvb-frontends/Kconfig            |   5 +
 drivers/media/dvb-frontends/Makefile           |   2 +-
 drivers/media/dvb-frontends/as102_fe.c         | 471 ++++++++++++++++++++
 drivers/media/dvb-frontends/as102_fe.h         |  29 ++
 drivers/media/dvb-frontends/as102_fe_types.h   | 188 ++++++++
 drivers/media/usb/Kconfig                      |   1 +
 drivers/media/usb/Makefile                     |   1 +
 drivers/media/usb/as102/Kconfig                |   8 +
 drivers/media/usb/as102/Makefile               |   7 +
 drivers/media/usb/as102/as102_drv.c            | 401 ++++++++++++++++++
 drivers/media/usb/as102/as102_drv.h            |  83 ++++
 drivers/media/usb/as102/as102_fw.c             | 228 ++++++++++
 drivers/media/usb/as102/as102_fw.h             |  34 ++
 drivers/media/usb/as102/as102_usb_drv.c        | 475 +++++++++++++++++++++
 drivers/media/usb/as102/as102_usb_drv.h        |  57 +++
 drivers/media/usb/as102/as10x_cmd.c            | 413 ++++++++++++++++++
 drivers/media/usb/as102/as10x_cmd.h            | 523 +++++++++++++++++++++++
 drivers/media/usb/as102/as10x_cmd_cfg.c        | 201 +++++++++
 drivers/media/usb/as102/as10x_cmd_stream.c     | 207 +++++++++
 drivers/media/usb/as102/as10x_handle.h         |  51 +++
 drivers/staging/media/Kconfig                  |   2 -
 drivers/staging/media/Makefile                 |   1 -
 drivers/staging/media/as102/Kconfig            |   8 -
 drivers/staging/media/as102/Makefile           |   6 -
 drivers/staging/media/as102/as102_drv.c        | 276 ------------
 drivers/staging/media/as102/as102_drv.h        |  92 ----
 drivers/staging/media/as102/as102_fe.c         | 566 -------------------------
 drivers/staging/media/as102/as102_fw.c         | 232 ----------
 drivers/staging/media/as102/as102_fw.h         |  38 --
 drivers/staging/media/as102/as102_usb_drv.c    | 479 ---------------------
 drivers/staging/media/as102/as102_usb_drv.h    |  61 ---
 drivers/staging/media/as102/as10x_cmd.c        | 418 ------------------
 drivers/staging/media/as102/as10x_cmd.h        | 529 -----------------------
 drivers/staging/media/as102/as10x_cmd_cfg.c    | 206 ---------
 drivers/staging/media/as102/as10x_cmd_stream.c | 211 ---------
 drivers/staging/media/as102/as10x_handle.h     |  54 ---
 drivers/staging/media/as102/as10x_types.h      | 194 ---------
 37 files changed, 3384 insertions(+), 3374 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/as102_fe.c
 create mode 100644 drivers/media/dvb-frontends/as102_fe.h
 create mode 100644 drivers/media/dvb-frontends/as102_fe_types.h
 create mode 100644 drivers/media/usb/as102/Kconfig
 create mode 100644 drivers/media/usb/as102/Makefile
 create mode 100644 drivers/media/usb/as102/as102_drv.c
 create mode 100644 drivers/media/usb/as102/as102_drv.h
 create mode 100644 drivers/media/usb/as102/as102_fw.c
 create mode 100644 drivers/media/usb/as102/as102_fw.h
 create mode 100644 drivers/media/usb/as102/as102_usb_drv.c
 create mode 100644 drivers/media/usb/as102/as102_usb_drv.h
 create mode 100644 drivers/media/usb/as102/as10x_cmd.c
 create mode 100644 drivers/media/usb/as102/as10x_cmd.h
 create mode 100644 drivers/media/usb/as102/as10x_cmd_cfg.c
 create mode 100644 drivers/media/usb/as102/as10x_cmd_stream.c
 create mode 100644 drivers/media/usb/as102/as10x_handle.h
 delete mode 100644 drivers/staging/media/as102/Kconfig
 delete mode 100644 drivers/staging/media/as102/Makefile
 delete mode 100644 drivers/staging/media/as102/as102_drv.c
 delete mode 100644 drivers/staging/media/as102/as102_drv.h
 delete mode 100644 drivers/staging/media/as102/as102_fe.c
 delete mode 100644 drivers/staging/media/as102/as102_fw.c
 delete mode 100644 drivers/staging/media/as102/as102_fw.h
 delete mode 100644 drivers/staging/media/as102/as102_usb_drv.c
 delete mode 100644 drivers/staging/media/as102/as102_usb_drv.h
 delete mode 100644 drivers/staging/media/as102/as10x_cmd.c
 delete mode 100644 drivers/staging/media/as102/as10x_cmd.h
 delete mode 100644 drivers/staging/media/as102/as10x_cmd_cfg.c
 delete mode 100644 drivers/staging/media/as102/as10x_cmd_stream.c
 delete mode 100644 drivers/staging/media/as102/as10x_handle.h
 delete mode 100644 drivers/staging/media/as102/as10x_types.h

-- 
1.9.3

