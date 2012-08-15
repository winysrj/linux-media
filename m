Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50418 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab2HOCVk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 22:21:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/6] DVB suspend / resume
Date: Wed, 15 Aug 2012 05:21:03 +0300
Message-Id: <1344997269-20338-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB frontend and DVB USB v2 suspend / resume implementation.

Antti Palosaari (6):
  dvb_core: export function to perform retune
  dvb_usb_v2: implement power-management for suspend
  dvb_frontend: implement suspend / resume
  dvb_usb_v2: .reset_resume() support
  dvb_usb_v2: af9015, af9035, anysee use .reset_resume
  dvb_usb_v2: ce6230, rtl28xxu use .reset_resume

 drivers/media/dvb-core/dvb_frontend.c       |  38 ++++++++++
 drivers/media/dvb-core/dvb_frontend.h       |   2 +
 drivers/media/usb/dvb-usb-v2/af9015.c       |   1 +
 drivers/media/usb/dvb-usb-v2/af9035.c       |   1 +
 drivers/media/usb/dvb-usb-v2/anysee.c       |   1 +
 drivers/media/usb/dvb-usb-v2/ce6230.c       |   1 +
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      |   3 +
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 105 ++++++++++++++++++++--------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |   1 +
 9 files changed, 125 insertions(+), 28 deletions(-)

-- 
1.7.11.2

