Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37592 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbaBDBkQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Feb 2014 20:40:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/4] use V4L2 control framework for DVB tuner
Date: Tue,  4 Feb 2014 03:39:56 +0200
Message-Id: <1391478000-24239-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro blamed a little my earlier solution where I provided runtime
tuner gain controls using DVB .set_config() callback. So here it is,
new solution which uses V4L2 control framework instead.

Hehe, implementation didn't look bad at all IMHO. It was a pretty
simple, but sounds strange as tuner sits on DVB API.

Antti

Antti Palosaari (4):
  rtl28xxu: attach SDR module later
  e4000: implement controls via v4l2 control framework
  rtl2832_sdr: use E4000 tuner controls via V4L framework
  e4000: remove .set_config() which was for controls

 drivers/media/tuners/e4000.c                     | 104 +++++++++++++++++++----
 drivers/media/tuners/e4000.h                     |  18 ++--
 drivers/media/tuners/e4000_priv.h                |  12 +++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c          |  21 ++++-
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c |  92 ++++++++------------
 5 files changed, 164 insertions(+), 83 deletions(-)

-- 
1.8.5.3

