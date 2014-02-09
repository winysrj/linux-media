Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48076 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbaBIGGX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 01:06:23 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/5] v4l2-ctl: add SDR device support
Date: Sun,  9 Feb 2014 08:05:49 +0200
Message-Id: <1391925954-25975-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That is here too:
http://git.linuxtv.org/anttip/v4l-utils.git/shortlog/refs/heads/sdr

I will pull request it soon.

regards
Antti

Antti Palosaari (4):
  synch videodev2.h headers with kernel SDR API
  v4l2-ctl: add tuner support for SDR tuners
  v4l2-ctl: add support for SDR FMT
  v4l2-ctl: implement list SDR buffers command

Mauro Carvalho Chehab (1):
  libdvbv5: better handle ATSC/Annex B

 contrib/freebsd/include/linux/videodev2.h |  16 +++++
 include/linux/videodev2.h                 |  16 +++++
 lib/libdvbv5/dvb-file.c                   |  33 +++++++++-
 utils/v4l2-ctl/Makefile.am                |   2 +-
 utils/v4l2-ctl/v4l2-ctl-common.cpp        |   1 +
 utils/v4l2-ctl/v4l2-ctl-sdr.cpp           | 104 ++++++++++++++++++++++++++++++
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp     |   6 ++
 utils/v4l2-ctl/v4l2-ctl-tuner.cpp         |  53 ++++++++++++---
 utils/v4l2-ctl/v4l2-ctl.cpp               |  23 +++++++
 utils/v4l2-ctl/v4l2-ctl.h                 |  13 ++++
 10 files changed, 255 insertions(+), 12 deletions(-)
 create mode 100644 utils/v4l2-ctl/v4l2-ctl-sdr.cpp

-- 
1.8.5.3

