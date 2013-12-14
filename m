Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56554 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821Ab3LNQQY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 11:16:24 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v2 0/7] V4L2 SDR API
Date: Sat, 14 Dec 2013 18:15:22 +0200
Message-Id: <1387037729-1977-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some changes done suggested by Hans.

regards
Antti

Antti Palosaari (7):
  v4l: don't clear VIDIOC_G_FREQUENCY tuner type
  v4l: add device type for Software Defined Radio
  v4l: add new tuner types for SDR
  v4l: 1 Hz resolution flag for tuners
  v4l: add stream format for SDR receiver
  v4l: enable some IOCTLs for SDR receiver
  v4l: define own IOCTL ops for SDR FMT

 drivers/media/v4l2-core/v4l2-dev.c   | 32 +++++++++++++--
 drivers/media/v4l2-core/v4l2-ioctl.c | 80 ++++++++++++++++++++++++++++++------
 include/media/v4l2-dev.h             |  3 +-
 include/media/v4l2-ioctl.h           |  8 ++++
 include/trace/events/v4l2.h          |  1 +
 include/uapi/linux/videodev2.h       | 14 +++++++
 6 files changed, 122 insertions(+), 16 deletions(-)

-- 
1.8.4.2

