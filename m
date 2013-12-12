Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51844 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab3LLQ5o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 11:57:44 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 0/2] V4L2 SDR stream format
Date: Thu, 12 Dec 2013 18:57:25 +0200
Message-Id: <1386867447-1018-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think that needs device capability flag too (struct v4l2_capability)
but bits on that struct are quite short. Add it after V4L2_CAP_MODULATOR ?


OK, now all the API pieces seems to be there, so I am converting my existing
SDR drivers to that API and make some tests.

Antti Palosaari (2):
  v4l2: add stream format for SDR receiver
  v4l2: enable FMT IOCTLs for SDR

 drivers/media/v4l2-core/v4l2-dev.c   | 12 ++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c | 27 +++++++++++++++++++++++++++
 include/trace/events/v4l2.h          |  1 +
 include/uapi/linux/videodev2.h       | 11 +++++++++++
 4 files changed, 51 insertions(+)

-- 
1.8.4.2

