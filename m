Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:27442 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbbCUXVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2015 19:21:34 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Mack <zonque@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 0/4] media: pxa_camera conversion to dmaengine
Date: Sun, 22 Mar 2015 00:21:20 +0100
Message-Id: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I've been cooking this since 2012. At that time, I thought the dmaengine API was
not rich enough to support the pxa_camera subtleties (or complexity).

I was wrong. I submitted a driver to Vinod for a dma pxa driver which would
support everything needed to make pxa_camera work normally.

As a consequence, I wrote this serie. Should the pxa-dma driver be accepted,
then this serie will be my next move towards pxa conversion to dmaengine. And to
parallelize the review work, I'll submit it right away to receive a review and
fix pxa_camera so that it is ready by the time pxa-dma is also reviewed.

Happy review.

--
Robert

Robert Jarzmik (4):
  media: pxa_camera: fix the buffer free path
  media: pxa_camera: move interrupt to tasklet
  media: pxa_camera: trivial move of dma irq functions
  media: pxa_camera: conversion to dmaengine

 drivers/media/platform/soc_camera/pxa_camera.c | 518 +++++++++++++------------
 1 file changed, 266 insertions(+), 252 deletions(-)

-- 
2.1.4

