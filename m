Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57893 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZCLL2p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 07:28:45 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 0/5] V2: soc-camera: setting the buswidth of camera sensors
Date: Thu, 12 Mar 2009 12:27:14 +0100
Message-Id: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Take 2: I hope I addressed all comments I receive in the first round.

The following patches change the handling of the bus width
for camera sensors so that a board can overwrite a sensors
native bus width

Sascha Hauer (5):
  soc-camera: add board hook to specify the buswidth for camera sensors
  pcm990 baseboard: add camera bus width switch setting
  mt9m001: allow setting of bus width from board code
  mt9v022: allow setting of bus width from board code
  soc-camera: remove now unused gpio member of struct soc_camera_link

 arch/arm/mach-pxa/pcm990-baseboard.c |   49 ++++++++++--
 drivers/media/video/Kconfig          |   14 ----
 drivers/media/video/mt9m001.c        |  143 ++++++++++------------------------
 drivers/media/video/mt9v022.c        |  141 ++++++++++-----------------------
 include/media/soc_camera.h           |    9 ++-
 5 files changed, 129 insertions(+), 227 deletions(-)

