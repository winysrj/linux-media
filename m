Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35408 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab3LSEAX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 23:00:23 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v4 0/7] SDR API
Date: Thu, 19 Dec 2013 05:59:59 +0200
Message-Id: <1387425606-7458-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is the full set of implementation.

But..... API Documentation is the really hard part as it is in XML format.
I have wasted already quite too much time for it :/ The reason is that
I don't have any XML editor, just plain text editor. Is there any WYSIWYG
XML editor for Linux? If there is no even editor I wonder if it is wise at
all to keep documentation in XML format...

We used Altova XMLSpy on our structured data formats course and I would like
to see something similar.

regards
Antti

Antti Palosaari (7):
  v4l: add device type for Software Defined Radio
  v4l: add new tuner types for SDR
  v4l: 1 Hz resolution flag for tuners
  v4l: add stream format for SDR receiver
  v4l: define own IOCTL ops for SDR FMT
  v4l: enable some IOCTLs for SDR receiver
  v4l: add device capability flag for SDR receiver

 drivers/media/v4l2-core/v4l2-dev.c   | 26 +++++++++++--
 drivers/media/v4l2-core/v4l2-ioctl.c | 75 ++++++++++++++++++++++++++++++------
 include/media/v4l2-dev.h             |  3 +-
 include/media/v4l2-ioctl.h           |  8 ++++
 include/trace/events/v4l2.h          |  1 +
 include/uapi/linux/videodev2.h       | 16 ++++++++
 6 files changed, 114 insertions(+), 15 deletions(-)

-- 
1.8.4.2

