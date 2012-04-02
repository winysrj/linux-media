Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58244 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2DBV0i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 17:26:38 -0400
Received: by wgbdr13 with SMTP id dr13so3083820wgb.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 14:26:36 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: m@bues.ch, hfvogt@gmx.net, mchehab@redhat.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 0/5] af9035: support for tda18218 tuner, new USB IDs and more
Date: Mon,  2 Apr 2012 23:25:12 +0200
Message-Id: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
this is a series of small patches for the new af9035 driver.
It adds basic support for the tda18218 tuner (and the related devices of the
Avermedia A835 serie), including a small patch to tune VHF channels.
Also, there is new USB ID for the 07ca:a867 device (Avermedia A867).
Finally, there are a couple of clean-ups.

My A867 and A835 sticks works pretty well with this new driver.
The driver is fast and responsive and there is no problem tuning all the
channels available in my area: a full scan finds all of them.

The only minor issue is that the signal strength is stuck to 100% with all
channels, with both sticks and with all the 3 firmwares.
SNR works properly.

After a quick test I couldn't find any difference between the 3 firmwares.
Anyway, the A867 seems a bit faster than the A835, and also it locked a very
weak mux that previously I was able to lock only with the PCTV 290e.

Best regards,
Gianluca Gennari

Gianluca Gennari (5):
  af9035: add USB id for 07ca:a867
  af9035: add support for the tda18218 tuner
  tda18218: fix IF frequency for 7MHz bandwidth channels
  af9035: fix warning
  af9035: use module_usb_driver macro

 drivers/media/common/tuners/tda18218.c    |    2 +-
 drivers/media/dvb/dvb-usb/Kconfig         |    1 +
 drivers/media/dvb/dvb-usb/af9035.c        |   60 +++++++++++++++-------------
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h   |    3 +
 drivers/media/dvb/frontends/af9033.c      |    4 ++
 drivers/media/dvb/frontends/af9033.h      |    1 +
 drivers/media/dvb/frontends/af9033_priv.h |   34 ++++++++++++++++
 7 files changed, 76 insertions(+), 29 deletions(-)

-- 
1.7.5.4

