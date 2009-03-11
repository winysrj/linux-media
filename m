Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41375 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZCKKIx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 06:08:53 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 0/4] soc-camera: setting the buswidth of camera sensors
Date: Wed, 11 Mar 2009 11:06:12 +0100
Message-Id: <1236765976-20581-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The following patches change the handling of the bus width
for camera sensors so that a board can overwrite a sensors
native bus width

Sascha

Sascha Hauer (4):
  soc-camera: add board hook to specify the buswidth for camera sensors
  pcm990 baseboard: add camera bus width switch setting
  mt9m001: allow setting of bus width from board code
  mt9v022: allow setting of bus width from board code

 arch/arm/mach-pxa/pcm990-baseboard.c |   50 +++++++++++---
 drivers/media/video/Kconfig          |   14 ----
 drivers/media/video/mt9m001.c        |  130 ++++++++--------------------------
 drivers/media/video/mt9v022.c        |   97 +++----------------------
 include/media/soc_camera.h           |    6 ++
 5 files changed, 88 insertions(+), 209 deletions(-)

