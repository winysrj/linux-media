Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:36940 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1LOMZF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 07:25:05 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id pBFCP3bR013039
	for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 06:25:04 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH 0/2] add dm365 specific media formats
Date: Thu, 15 Dec 2011 17:54:56 +0530
Message-ID: <1323951898-16330-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add mediabus formats and pixel formats suported as part of
dm365 vpfe device.
The device supports media formats(transfer and storage)
which include -
1. ALAW compressed bayer.
2. UV interleaved without Y( for resizer)
3. NV12

Manjunath Hadli (2):
  media: add new mediabus format enums for dm365
  v4l2: add new pixel formats supported on dm365

 include/linux/v4l2-mediabus.h |   10 ++++++++--
 include/linux/videodev2.h     |    6 ++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

