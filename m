Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:47186 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbbGESai (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2015 14:30:38 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 0/4] media: pxa_camera conversion to dmaengine
Date: Sun,  5 Jul 2015 20:27:48 +0200
Message-Id: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

This is the next round.

Most of your comments are addressed or answered, the one big thing left apart is
the videobuf_sg_cut() implementation and complexity. If you have a better idea,
I'm all ears.

One thing that changed since v1 is that pxa_dma driver was accepted into
dmaengine tree and merged, as well as the dma buffer "reusability" stuff.

This begins round 2 of dmaengine conversion of pxa_camera, happy review.

Cheers.

--
Robert

Robert Jarzmik (4):
  media: pxa_camera: fix the buffer free path
  media: pxa_camera: move interrupt to tasklet
  media: pxa_camera: trivial move of dma irq functions
  media: pxa_camera: conversion to dmaengine

 drivers/media/platform/soc_camera/pxa_camera.c | 522 +++++++++++++------------
 1 file changed, 267 insertions(+), 255 deletions(-)

-- 
2.1.4

