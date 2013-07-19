Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:46584 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965421Ab3GSH7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 03:59:41 -0400
Received: by mail-lb0-f178.google.com with SMTP id y6so3205239lbh.9
        for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 00:59:39 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?q?=C2=A0Mauro=20Carvalho=20Chehab?= <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	=?UTF-8?q?=C2=A0Ismael=20Luceno?=
	<ismael.luceno@corp.bluecherry.net>,
	=?UTF-8?q?=C2=A0Greg=20Kroah-Hartman?= <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/4] videobuf2-dma-sg: Contiguos memory allocation
Date: Fri, 19 Jul 2013 09:58:45 +0200
Message-Id: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocate memory as contiguos as possible to support dma engines with limitated amount of sg-descriptors.

Replace private structer vb2_dma_sg_desc with generic struct sg_table.

This series of patches is the evolution of my previous patch for vb2-dma-sg to allocate the memory as contiguos as possible.

Ricardo Ribalda Delgado (4):
  videobuf2-dma-sg: Allocate pages as contiguous as possible
  videobuf2-dma-sg: Replace vb2_dma_sg_desc with sg_table
  media/marvell-ccic: Changes on the vb2-dma-sg API
  media/solo6x10: Changes on the vb2-dma-sg API

 drivers/media/platform/marvell-ccic/mcam-core.c    |   12 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |  149 +++++++++++---------
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |   20 +--
 include/media/videobuf2-dma-sg.h                   |   10 +-
 4 files changed, 103 insertions(+), 88 deletions(-)

-- 
1.7.10.4

