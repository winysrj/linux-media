Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14785 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab1KDOUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 10:20:10 -0400
Date: Fri, 04 Nov 2011 15:19:54 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/8] s5p-fimc bug fixes for 3.2-rc
To: linux-media@vger.kernel.org
Cc: samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following is a bunch of bug fixes/improvements for s5p-fimc driver. 

Sylwester Nawrocki (8):
  s5p-fimc: Fix wrong pointer dereference when unregistering sensors
  s5p-fimc: Fix error in the capture subdev deinitialization
  s5p-fimc: Fix initialization for proper system suspend support
  s5p-fimc: Fix buffer dequeue order issue
  s5p-fimc: Allow probe() to succeed with null platform data
  s5p-fimc: Adjust pixel height alignments according to the IP revision
  s5p-fimc: Fail driver probing when sensor configuration is wrong
  s5p-fimc: Use correct fourcc for RGB565 colour format

 drivers/media/video/s5p-fimc/fimc-capture.c |   13 +++++---
 drivers/media/video/s5p-fimc/fimc-core.c    |   24 +++++++-------
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   43 +++++++++++++++++----------
 drivers/media/video/s5p-fimc/fimc-reg.c     |   15 +++++++--
 5 files changed, 61 insertions(+), 36 deletions(-)

--
Regards,
Sylwester Nawrocki
