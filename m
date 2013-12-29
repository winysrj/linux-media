Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36129 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3L2EwO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 23:52:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/6] convert drivers to SDR API
Date: Sun, 29 Dec 2013 06:51:34 +0200
Message-Id: <1388292700-18369-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is two drivers converted to API.

There is still a tons of things	to do, like expose tuner AGC control to
userspace. Also one very big task is to design how these DVB tuners should
be shared properly with DVB and V4L2 SDR API. Move used V4L2 FourCC codes
to API and many many other easy things!

[1] Kernel tree having latest SDR drivers (msi3101 and rtl2832)
[2] GNU Radio plugin to use these devices via Kernel API
[3] FM radio schematics for GNU	Radio to listen radio (by OZ9AEC)


[1] http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/sdr
[2] http://git.linuxtv.org/anttip/gr-kernel.git
[3] http://palosaari.fi/linux/v4l-dvb/wfm_rx.py

regards
Antti

Antti Palosaari (6):
  rtl2832_sdr: convert to SDR API
  msi3101: convert to SDR API
  msi3101: add u8 sample format
  msi3101: add u16 LE sample format
  msi3101: tons of small changes
  v4l: disable lockdep on vb2_fop_mmap()

 drivers/media/v4l2-core/videobuf2-core.c         |  14 +-
 drivers/staging/media/msi3101/sdr-msi3101.c      | 526 ++++++++++++++---------
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 387 ++++++++++-------
 3 files changed, 565 insertions(+), 362 deletions(-)

-- 
1.8.4.2

