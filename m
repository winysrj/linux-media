Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44079 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3LKQHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 11:07:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 0/7] Atmel ISI fixes and improvements
Date: Wed, 11 Dec 2013 17:07:38 +0100
Message-Id: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's the second version of a set of miscellaneous fixes and improvement
patches for the atmel-isi driver. Please see individual commit messages for
more information.

Patch 5/7 makes the MCK clock optional. The goal is to remove it completely,
but we first need to port boards to the new clock handling mechanism. The
patch in itself will not have any effect until then, but getting it in v3.14
will help with dependency management for arch/ changes in the next kernel
versions.

Josh told me he isn't planning to send a pull request for the atmel-isi driver
for v3.14 so I'll send one with this series in a couple of days.

Changes compared to v1:

- Added patches 6/7 and 7/7
- Rebased on the latest linuxtv master branch

Josh Wu (2):
  v4l: atmel-isi: remove SOF wait in start_streaming()
  v4l: atmel-isi: Should clear bits before set the hardware register

Laurent Pinchart (5):
  v4l: atmel-isi: Use devm_* managed allocators
  v4l: atmel-isi: Defer clock (un)preparation to enable/disable time
  v4l: atmel-isi: Reset the ISI when starting the stream
  v4l: atmel-isi: Make the MCK clock optional
  v4l: atmel-isi: Fix color component ordering

 drivers/media/platform/soc_camera/atmel-isi.c | 179 ++++++++------------------
 include/media/atmel-isi.h                     |   2 +
 2 files changed, 55 insertions(+), 126 deletions(-)

-- 
Regards,

Laurent Pinchart

