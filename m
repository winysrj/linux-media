Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33617 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3LNCtW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 21:49:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [GIT PULL FOR v3.14] Atmel ISI patches
Date: Sat, 14 Dec 2013 03:49:37 +0100
Message-ID: <1408503.CfMV1Tiy7q@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 675722b0e3917c6c917f1aa5f6d005cd3a0479f5:

  Merge branch 'upstream-fixes' into patchwork (2013-12-13 05:04:00 -0200)

are available in the git repository at:


  git://linuxtv.org/pinchartl/media.git atmel/isi

for you to fetch changes up to 8f94dee5c528d1334fd1cb548966757ba2cf1431:

  v4l: atmel-isi: Should clear bits before set the hardware register 
(2013-12-14 03:46:39 +0100)

----------------------------------------------------------------
Josh Wu (2):
      v4l: atmel-isi: remove SOF wait in start_streaming()
      v4l: atmel-isi: Should clear bits before set the hardware register

Laurent Pinchart (5):
      v4l: atmel-isi: Use devm_* managed allocators
      v4l: atmel-isi: Defer clock (un)preparation to enable/disable time
      v4l: atmel-isi: Reset the ISI when starting the stream
      v4l: atmel-isi: Make the MCK clock optional
      v4l: atmel-isi: Fix color component ordering

 drivers/media/platform/soc_camera/atmel-isi.c | 179 +++++++------------------
 include/media/atmel-isi.h                     |   2 +
 2 files changed, 55 insertions(+), 126 deletions(-)

-- 
Regards,

Laurent Pinchart

