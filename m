Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39883 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab3KQURu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 15:17:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 0/6] SDR API libV4L stream conversion
Date: Sun, 17 Nov 2013 22:17:26 +0200
Message-Id: <1384719452-21744-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That patch set contains libv4lconvert conversion for all SDR formats
I have currently available.

Also simple test app to stream data from device to standard output.

Seems to works very well. CPU usage is something like 13% when 2MSps
sampling rate is used, which goes very much from the runtime float
conversion. Using pre-calculated LUTs will reduce CPU usage very much,
but lets that kind of optimizations be another issue.

Antti Palosaari (6):
  libv4lconvert: SDR conversion from U8 to FLOAT
  v4l2: add sdr-fetch test app
  libv4lconvert: SDR conversion from S8 to FLOAT
  libv4lconvert: SDR conversion from MSi2500 format 384 to FLOAT
  libv4lconvert: SDR conversion from packed S12 to FLOAT
  libv4lconvert: SDR conversion from S14 to FLOAT

 contrib/freebsd/include/linux/videodev2.h |   8 ++
 contrib/test/Makefile.am                  |   6 +-
 contrib/test/sdr_fetch.c                  | 221 ++++++++++++++++++++++++++++++
 include/linux/videodev2.h                 |   8 ++
 lib/libv4lconvert/libv4lconvert.c         | 184 +++++++++++++++++++++++++
 5 files changed, 426 insertions(+), 1 deletion(-)
 create mode 100644 contrib/test/sdr_fetch.c

-- 
1.8.4.2

