Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3H1N2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 09:28:38 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 0/3] V4L2: fix em28xx ov2640 support
Date: Wed, 28 Aug 2013 15:28:25 +0200
Message-Id: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds a V4L2 clock support to em28xx with an ov2640 
sensor. Only compile tested, might need fixing, please, test.

Guennadi Liakhovetski (3):
  V4L2: add v4l2-clock helpers to register and unregister a fixed-rate
    clock
  V4L2: add a v4l2-clk helper macro to produce an I2C device ID
  V4L2: em28xx: register a V4L2 clock source

 drivers/media/usb/em28xx/em28xx-camera.c |   41 ++++++++++++++++++++++-------
 drivers/media/usb/em28xx/em28xx-cards.c  |    3 ++
 drivers/media/usb/em28xx/em28xx.h        |    1 +
 drivers/media/v4l2-core/v4l2-clk.c       |   39 ++++++++++++++++++++++++++++
 include/media/v4l2-clk.h                 |   17 ++++++++++++
 5 files changed, 91 insertions(+), 10 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
