Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:58098 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbbH3TMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 15:12:44 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v4 0/4] media: pxa_camera: conversion to dmaengine
Date: Sun, 30 Aug 2015 21:07:57 +0200
Message-Id: <1440961681-17279-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

This is the forth round.

This time sg_split() was a consequence of (a) and (b), ie. sg_split() move into
kernel's lib/ directory, and following dmaengine "reuse" flag introduction,
change pxa_camera accordingly.

Happy review.

Cheers.

Robert Jarzmik (4):
  media: pxa_camera: fix the buffer free path
  media: pxa_camera: move interrupt to tasklet
  media: pxa_camera: trivial move of dma irq functions
  media: pxa_camera: conversion to dmaengine

 drivers/media/platform/soc_camera/Kconfig      |   1 +
 drivers/media/platform/soc_camera/pxa_camera.c | 478 +++++++++++--------------
 2 files changed, 220 insertions(+), 259 deletions(-)

-- 
2.1.4

