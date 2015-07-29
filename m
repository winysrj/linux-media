Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:27724 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbG2Tmo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2015 15:42:44 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 0/4] media: pxa_camera conversion to dmaengine
Date: Wed, 29 Jul 2015 21:39:00 +0200
Message-Id: <1438198744-6150-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

This is the third round.

Most of this round deals with the sg_cut() polishing.
We still have a bit of ground to cover :
 (a) Robert: try to submit sg_split() to lib/sglist.c
 (b) Robert: following dmaengine "reuse" flag introduction, change pxa_camera
             accordingly
 (c) Guennadi: I think you had comments about free_buffer() I never received by
               mail, so there might be something to rework in this area.
 (d) Guennadi+Robert: continue review of the serie

Happy review.

Cheers.

--
Robert

Robert Jarzmik (4):
  media: pxa_camera: fix the buffer free path
  media: pxa_camera: move interrupt to tasklet
  media: pxa_camera: trivial move of dma irq functions
  media: pxa_camera: conversion to dmaengine

 drivers/media/platform/soc_camera/pxa_camera.c | 578 ++++++++++++++-----------
 1 file changed, 321 insertions(+), 257 deletions(-)

-- 
2.1.4


