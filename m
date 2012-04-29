Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40712 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2D2RNt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 13:13:49 -0400
Received: from localhost.localdomain (unknown [91.178.160.63])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id F186A359A4
	for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 19:13:47 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] MT9P031 sensor driver fixes
Date: Sun, 29 Apr 2012 19:14:05 +0200
Message-Id: <1335719648-18239-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here are 3 small patches for the MT9P031 sensor driver. I plan to push them
for v3.5.

Laurent Pinchart (3):
  mt9p031: Identify color/mono models using I2C device name
  mt9p031: Replace the reset board callback by a GPIO number
  mt9p031: Implement black level compensation control

 drivers/media/video/mt9p031.c |  161 +++++++++++++++++++++++++++++++++++++----
 include/media/mt9p031.h       |   19 +++---
 2 files changed, 155 insertions(+), 25 deletions(-)

-- 
Regards,

Laurent Pinchart

