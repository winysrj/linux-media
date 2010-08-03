Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58898 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab0HCJik (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 05:38:40 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: baruch@tkos.co.il, g.liakhovetski@gmx.de, s.hauer@pengutronix.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 0/5] mx2_camera changes and corrections
Date: Tue,  3 Aug 2010 11:37:51 +0200
Message-Id: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

this patchseries include little changes, which are necessary for the mx2_camera
driver to work properly on i.MX27 baseboards, especially an issue with the
emma.

Thanks,
Michael

Michael Grzeschik (5):
  mx2_camera: change to register and probe
  mx2_camera: remove emma limitation for RGB565
  mx2_camera: fix for list bufnum in frame_done_emma
  mx2_camera: add rising edge for pixclock
  mx2_camera: add informative camera clock frequency printout

 drivers/media/video/mx2_camera.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
