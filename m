Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:54667 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab1FKRrF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:47:05 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Refactor cafe_ccic and add Armada 610 driver [V2]
Date: Sat, 11 Jun 2011 11:46:41 -0600
Message-Id: <1307814409-46282-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Here is the second posting of the cafe_ccic driver rework and the addition
of the Armada 610 camera driver.  Things have been somewhat cleaned up
since the first time around, and I think that this series is ready to be
queued for 3.1.  Mauro, if you agree, the whole series can be pulled from:

       git://git.lwn.net/linux-2.6.git for-mauro

Some notes:

 - The videobuf2 conversion is not yet done.  My plan is to complete that
   in the very near future and have it ready for 3.1 as well.  In any case,
   though, I want this point to exist in the mainline history since it has
   a working version of both drivers without substantially changing how the
   cafe_ccic driver works.  If I later break the XO 1 for somebody, this
   will be an important bisection point.

 - The movement of cafe_ccic code generates a bunch of checkpatch errors,
   but they are all from code which has been in mainline for years.  If the
   coding style nits bug people I'll happily generate a patch to fix them
   all (may do so anyway), but I didn't want to add a bunch of noise when
   everything else was in flux.

 - Guennadi, I've not added the intermediate Kconfig variable you
   suggested; it seemed like it was just more complication for no real
   benefit.  If you feel strongly about it, though, I'll make the change.

The changes in the series are:

Jonathan Corbet (8):
      marvell-cam: Move cafe-ccic into its own directory
      marvell-cam: Separate out the Marvell camera core
      marvell-cam: Pass sensor parameters from the platform
      marvell-cam: Remove the "untested" comment
      marvell-cam: Move Cafe-specific register definitions to cafe-driver.c
      marvell-cam: Right-shift i2c slave ID's in the cafe driver
      marvell-cam: Allocate the i2c adapter in the platform driver
      marvell-cam: Basic working MMP camera driver

 drivers/media/video/Kconfig                     |   11 +-
 drivers/media/video/Makefile                    |    3 +-
 drivers/media/video/cafe_ccic-regs.h            |  166 --
 drivers/media/video/cafe_ccic.c                 | 2267 -----------------------
 drivers/media/video/marvell-ccic/Kconfig        |   20 +
 drivers/media/video/marvell-ccic/Makefile       |    6 +
 drivers/media/video/marvell-ccic/cafe-driver.c  |  648 +++++++
 drivers/media/video/marvell-ccic/mcam-core.c    | 1683 +++++++++++++++++
 drivers/media/video/marvell-ccic/mcam-core.h    |  259 +++
 drivers/media/video/marvell-ccic/mmp-driver.c   |  339 ++++
 drivers/media/video/ov7670.c                    |    3 +-
 include/media/mmp-camera.h                      |    9 +
 {drivers/media/video => include/media}/ov7670.h |    0
 include/media/v4l2-chip-ident.h                 |    3 +-
 14 files changed, 2971 insertions(+), 2446 deletions(-)
 delete mode 100644 drivers/media/video/cafe_ccic-regs.h
 delete mode 100644 drivers/media/video/cafe_ccic.c
 create mode 100644 drivers/media/video/marvell-ccic/Kconfig
 create mode 100644 drivers/media/video/marvell-ccic/Makefile
 create mode 100644 drivers/media/video/marvell-ccic/cafe-driver.c
 create mode 100644 drivers/media/video/marvell-ccic/mcam-core.c
 create mode 100644 drivers/media/video/marvell-ccic/mcam-core.h
 create mode 100644 drivers/media/video/marvell-ccic/mmp-driver.c
 create mode 100644 include/media/mmp-camera.h
 rename {drivers/media/video => include/media}/ov7670.h (100%)

Thanks,

jon


