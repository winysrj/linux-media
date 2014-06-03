Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32936 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaFCJgA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 05:36:00 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 0/5] mt9v032: add support for v4l2-async, mt9v02x, and regmap
Date: Tue,  3 Jun 2014 11:35:50 +0200
Message-Id: <1401788155-3690-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series contains the fixed up mt9v032 patches I recently sent,
plus an additional patch to use regmap for the i2c register access.

regards
Philipp

Philipp Zabel (5):
  [media] mt9v032: reset is self clearing
  [media] mt9v032: register v4l2 asynchronous subdevice
  [media] mt9v032: do not clear reserved bits in read mode register
  [media] mt9v032: add support for mt9v022 and mt9v024
  [media] mt9v032: use regmap

 drivers/media/i2c/Kconfig   |   1 +
 drivers/media/i2c/mt9v032.c | 168 +++++++++++++++++++++++++-------------------
 2 files changed, 95 insertions(+), 74 deletions(-)

-- 
2.0.0.rc2

