Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33892 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3LPWIY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 17:08:24 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v3 0/7] SDR API
Date: Tue, 17 Dec 2013 00:08:01 +0200
Message-Id: <1387231688-8647-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now with some changes done requested by Hans.
I did not agree	very well that VIDIOC_G_FREQUENCY tuner type check
exception, but here it is...

Also two patches, as example, conversion of msi3101 and rtl2832_sdr
drivers to that API.

regards
Antti

Antti Palosaari (7):
  v4l: add new tuner types for SDR
  v4l: 1 Hz resolution flag for tuners
  v4l: add stream format for SDR receiver
  v4l: define own IOCTL ops for SDR FMT
  v4l: enable some IOCTLs for SDR receiver
  rtl2832_sdr: convert to SDR API
  msi3101: convert to SDR API

 drivers/media/v4l2-core/v4l2-dev.c               |  27 ++-
 drivers/media/v4l2-core/v4l2-ioctl.c             |  75 +++++-
 drivers/staging/media/msi3101/sdr-msi3101.c      | 204 +++++++++++-----
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 291 ++++++++++++++++++-----
 include/media/v4l2-ioctl.h                       |   8 +
 include/trace/events/v4l2.h                      |   1 +
 include/uapi/linux/videodev2.h                   |  14 ++
 7 files changed, 486 insertions(+), 134 deletions(-)

-- 
1.8.4.2

