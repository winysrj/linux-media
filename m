Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46998 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2HPA3E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 20:29:04 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/5] dvb-frontend statistic IOCTL validation
Date: Thu, 16 Aug 2012 03:28:36 +0300
Message-Id: <1345076921-9773-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Take two.

I added some logic to prevent statistic queries in case demodulator is clearly in state statistic query is invalid. Currently there could be checks in device driver but usually not. Gar
bage is usually returned and in some cases even I/O errors are generated as demod is put sleep and cannot answer any request.

I changed error code EPERM to EAGAIN. What I looked existing demodulator drivers there was multiple error codes used. EAGAIN was one, at least DRX-K uses it.

Also documentation is updated according to new situation.

Antti Palosaari (5):
  dvb_frontend: use Kernel dev_* logging
  dvb_frontend: return -ENOTTY for unimplement IOCTL
  dvb_frontend: do not allow statistic IOCTLs when sleeping
  DocBook: update ioctl error codes EAGAIN, ENOSYS, EOPNOTSUPP
  rtl2832: remove dummy callback implementations

 Documentation/DocBook/media/v4l/gen-errors.xml |  12 +-
 drivers/media/dvb-core/dvb_frontend.c          | 266 +++++++++++++------------
 drivers/media/dvb-frontends/rtl2832.c          |  29 ---
 3 files changed, 151 insertions(+), 156 deletions(-)

-- 
1.7.11.2

