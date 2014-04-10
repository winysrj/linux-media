Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60125 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030235AbaDJMLs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 08:11:48 -0400
Message-ID: <53468A82.7010501@iki.fi>
Date: Thu, 10 Apr 2014 15:11:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [GIT PULL 3.15] rtl2832_sdr attach fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a83b93a7480441a47856dc9104bea970e84cda87:

   [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31 
08:02:16 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git fixes3.15_rtl2832_sdr_attach

for you to fetch changes up to 613f11d8dee62e4e7ecdc7670a54560773a324f9:

   rtl28xxu: silence error log about disabled rtl2832_sdr module 
(2014-04-10 01:01:24 +0300)

----------------------------------------------------------------
Antti Palosaari (2):
       rtl28xxu: do not hard depend on staging SDR module
       rtl28xxu: silence error log about disabled rtl2832_sdr module

  drivers/media/usb/dvb-usb-v2/Makefile   |  1 -
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 48 
+++++++++++++++++++++++++++++++++++++++++++-----
  2 files changed, 43 insertions(+), 6 deletions(-)


-- 
http://palosaari.fi/
