Return-path: <mchehab@localhost>
Received: from comal.ext.ti.com ([198.47.26.152]:36616 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab0IBOqQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Sep 2010 10:46:16 -0400
From: raja_mani@ti.com
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	mchehab@infradead.org
Cc: matti.j.aaltonen@nokia.com, Raja Mani <raja_mani@ti.com>
Subject: [RFC/PATCH 0/8] Add FM TX support for TI WL127x and TI WL128x.
Date: Thu,  2 Sep 2010 11:57:52 -0400
Message-Id: <1283443080-30644-1-git-send-email-raja_mani@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

From: Raja Mani <raja_mani@ti.com>

  This is second set patches for TI FM driver. This adds FM TX support 
  for TI WL128x and TI Wl127x chipsets. Also , extends V4L2 control IDs (CID)
  to support few FM RX features.

  First set of TI FM driver patches are submitted for review in linux-media 
  & LKML and available under this link:

   http://www.spinics.net/lists/linux-media/msg22096.html
   http://lkml.org/lkml/2010/8/13/122

  TI FM driver makes use of TI Shared Transport (solution for BT/FM/GPS combo chip)
  and Shared Transport driver is available in mainline kernel staging 
  directory (/drivers/staging/ti-st).    
   
Raja Mani (8):
  drivers:media:video: Adding new CIDs for FM RX ctls
  include:linux:videodev2: Define new CIDs for FM RX ctls
  drivers:staging:ti-st: Sources for FM TX
  drivers:staging:ti-st: Move get region func to FM RX module.
  drivers:staging:ti-st: Code cleanup in FM Common module
  drivers:staging:ti-st: Extend FM TX global data structure.
  drivers:staging:ti-st: Link FM TX module API with FM V4L2 module
  drivers:staging:ti-st: Include FM TX module in Makefile

 drivers/media/video/v4l2-common.c    |   16 ++
 drivers/staging/ti-st/Makefile       |    2 +-
 drivers/staging/ti-st/fmdrv.h        |    4 +
 drivers/staging/ti-st/fmdrv_common.c |   39 ++--
 drivers/staging/ti-st/fmdrv_common.h |   23 ++-
 drivers/staging/ti-st/fmdrv_rx.c     |    7 +
 drivers/staging/ti-st/fmdrv_rx.h     |    1 +
 drivers/staging/ti-st/fmdrv_tx.c     |  391 ++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/fmdrv_tx.h     |   37 ++++
 drivers/staging/ti-st/fmdrv_v4l2.c   |  243 +++++++++++++++++++--
 include/linux/videodev2.h            |   18 ++
 11 files changed, 733 insertions(+), 48 deletions(-)
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.h

