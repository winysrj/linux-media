Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51744 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 00/20] MT9M111/MT9M131
Date: Fri, 30 Jul 2010 16:53:18 +0200
Message-Id: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

the following patchseries was created in a rewrite process of the
mt9m111 camera driver while it was tested for support of the very
similar silicon mt9m121. Some patches add functionality like panning or
test pattern generation or adjust rectengular positioning while others
do some restructuring. It has been tested as functional. Comments on
this are very welcome.

Michael Grzeschik (19):
  mt9m111: init chip after read CHIP_VERSION
  mt9m111: register cleanup hex to dec bitoffset
  mt9m111: added new bit offset defines
  mt9m111: added default row/col/width/height values
  mt9m111: changed MAX_{HEIGHT,WIDTH} values to silicon pixelcount
  mt9m111: changed MIN_DARK_COLS to MT9M131 spec count
  mt9m111: cropcap use defined default rect properties in defrect
  mt9m111: cropcap check if type is CAPTURE
  mt9m111: rewrite make_rect for positioning in debug
  mt9m111: added mt9m111 format structure
  mt9m111: s_crop add calculation of output size
  mt9m111: s_crop check for VIDEO_CAPTURE type
  mt9m111: added reg_mask function
  mt9m111: rewrite setup_rect, added soft_crop for smooth panning
  mt9m111: added more supported BE colour formats
  mt9m111: rewrite set_pixfmt
  mt9m111: make use of testpattern in debug mode
  mt9m111: try_fmt rewrite to use preset values
  mt9m111: s_fmt make use of try_fmt

Philipp Wiesner (1):
  mt9m111: Added indication that MT9M131 is supported by this driver

 drivers/media/video/Kconfig   |    5 +-
 drivers/media/video/mt9m111.c |  596 ++++++++++++++++++++++++++---------------
 2 files changed, 377 insertions(+), 224 deletions(-)

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
