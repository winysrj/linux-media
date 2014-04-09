Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45354 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934092AbaDIVc7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 17:32:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 0/2] rtl2832_sdr module attach related fixes
Date: Thu, 10 Apr 2014 00:32:39 +0300
Message-Id: <1397079161-24144-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V2: I split patch to two.

Pull request for kernel 3.15 will follow right after that mail.

regards,
Antti

Antti Palosaari (2):
  rtl28xxu: do not hard depend on staging SDR module
  rtl28xxu: silence error log about disabled rtl2832_sdr module

 drivers/media/usb/dvb-usb-v2/Makefile   |  1 -
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 48 +++++++++++++++++++++++++++++----
 2 files changed, 43 insertions(+), 6 deletions(-)

-- 
1.9.0

