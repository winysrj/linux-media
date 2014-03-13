Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40326 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbaCMUob (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 16:44:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] e4000/rtl2832u_sdr: use V4L2 subdev to pass V4L2 control handler
Date: Thu, 13 Mar 2014 22:44:13 +0200
Message-Id: <1394743454-18124-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now it is a little bit similar than used on V4L2 API... Looks better?

Antti Palosaari (1):
  e4000/rtl2832u_sdr: use V4L2 subdev to pass V4L2 control handler

 drivers/media/tuners/Kconfig                     |  2 +-
 drivers/media/tuners/e4000.c                     | 21 ++++++++++++---------
 drivers/media/tuners/e4000.h                     | 14 --------------
 drivers/media/tuners/e4000_priv.h                |  2 ++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c          | 11 +++++++----
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c |  9 ++++-----
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h |  7 +++++--
 7 files changed, 31 insertions(+), 35 deletions(-)

-- 
1.8.5.3

