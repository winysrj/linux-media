Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp02.atmel.com ([204.2.163.16]:13956 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750980AbbJ1Jm2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2015 05:42:28 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] soc-camera: fix the bug which will fail to search the registered v4l2-clk
Date: Wed, 28 Oct 2015 17:48:51 +0800
Message-ID: <1446025735-26849-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set will fix a bug in soc-camera, which will fail to search
the v4l2-clk if the i2c sensor is probed later than soc-camera host.

It also add some clean up for v4l2-clk code and usage.


Josh Wu (4):
  soc_camera: get the clock name by using macro: v4l2_clk_name_i2c()
  v4l2-clk: add new macro for v4l2_clk_name_of()
  v4l2-clk: add new definition: V4L2_CLK_NAME_SIZE
  v4l2-clk: v4l2_clk_get() also need to find the of_fullname clock

 drivers/media/platform/soc_camera/soc_camera.c | 23 ++++++++++++-----------
 drivers/media/usb/em28xx/em28xx-camera.c       |  2 +-
 drivers/media/v4l2-core/v4l2-clk.c             |  9 +++++++++
 include/media/v4l2-clk.h                       |  5 +++++
 4 files changed, 27 insertions(+), 12 deletions(-)

-- 
1.9.1

