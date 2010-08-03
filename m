Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51788 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641Ab0HCK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 06:57:54 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH v2 00/11] MT9M111/MT9M131
Date: Tue,  3 Aug 2010 12:57:38 +0200
Message-Id: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey everyone,

here is v2 of the previous (a little messy) patchseries. After i
figured out that the biggest part of the patches were cutted into
unrelated and unneeded pieces here hopefully comes a cleaner patchstack.

The rest of the patches i send last time is living in my git repo for
review, until i figured out that the code is mostly needed for the
softcropping feature of the camera.

But first things first, here are my changes:

Michael Grzeschik (9):
  mt9m111: init chip after read CHIP_VERSION
  mt9m111: register cleanup hex to dec bitoffset
  mt9m111: added new bit offset defines
  mt9m111: changed MIN_DARK_COLS to MT9M131 spec count
  mt9m111: cropcap and s_crop check if type is VIDEO_CAPTURE
  mt9m111: added current colorspace at g_fmt
  mt9m111: added reg_mask function
  mt9m111: rewrite set_pixfmt
  mt9m111: make use of testpattern

Philipp Wiesner (1):
  mt9m111: Added indication that MT9M131 is supported by this driver

Sascha Hauer (1):
  v4l2-mediabus: Add pixelcodes for BGR565 formats

 drivers/media/video/Kconfig   |    5 +-
 drivers/media/video/mt9m111.c |  283 ++++++++++++++++++++++++-----------------
 include/media/v4l2-mediabus.h |    2 +
 3 files changed, 174 insertions(+), 116 deletions(-)

--
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
