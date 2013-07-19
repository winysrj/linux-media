Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:49407 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3GSRCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 13:02:42 -0400
Received: by mail-la0-f51.google.com with SMTP id ga9so1849341lab.24
        for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 10:02:41 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, Andre Heider <a.heider@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/2] videobuf2-dma-sg: Contiguos memory allocation
Date: Fri, 19 Jul 2013 19:02:32 +0200
Message-Id: <1374253355-3788-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocate memory as contiguos as possible to support dma engines with limitated amount of sg-descriptors.

Replace private structer vb2_dma_sg_desc with generic struct sg_table.

PS: This series of patches is the evolution of my previous patch for vb2-dma-sg to allocate the memory as contiguos as possible.

v2: Contains feedback from Andre Heider and Sylwester Nawrocki

Andre: Fix error handling (--pages)
Sylwester: Squash p3 and p4 into p2

Ricardo Ribalda Delgado (2):
  videobuf2-dma-sg: Allocate pages as contiguous as possible
  videobuf2-dma-sg: Replace vb2_dma_sg_desc with sg_table

 drivers/media/platform/marvell-ccic/mcam-core.c    |   14 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |  149 +++++++++++---------
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |   20 +--
 include/media/videobuf2-dma-sg.h                   |   10 +-
 4 files changed, 105 insertions(+), 88 deletions(-)

-- 
1.7.10.4

