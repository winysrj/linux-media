Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48627 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbCVLbw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 07:31:52 -0400
Message-ID: <550EA826.2030603@iki.fi>
Date: Sun, 22 Mar 2015 13:31:50 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Benjamin Larsson <benjamin@southpole.se>
Subject: [GIT PULL 4.1] Astrometa / mn88472 / mn88473
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two fixes for r820t which I reviewed quite carefully and should be OK.

mn88472 and mn88473 are staging demodulator drivers.

regards
Antti

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

   [media] mn88473: simplify bandwidth registers setting code 
(2015-03-03 13:09:12 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git astrometa

for you to fetch changes up to 16c00dacdd0437c5a62b5db4329520bdbe5dd26c:

   mn88473: implement lock for all delivery systems (2015-03-22 13:25:18 
+0200)

----------------------------------------------------------------
Antti Palosaari (2):
       mn88473: define symbol rate limits
       mn88472: define symbol rate limits

Benjamin Larsson (9):
       r820t: add DVBC profile in sysfreq_sel
       r820t: change read_gain() code to match register layout
       rtl28xxu: lower the rc poll time to mitigate i2c transfer errors
       mn88472: implement lock for all delivery systems
       mn88472: implement firmware parity check
       mn88473: implement firmware parity check
       mn88473: check if firmware is already running before loading it
       mn88472: check if firmware is already running before loading it
       mn88473: implement lock for all delivery systems

  drivers/media/tuners/r820t.c            | 15 ++++++++++++++-
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c |  2 +-
  drivers/staging/media/mn88472/mn88472.c | 52 
++++++++++++++++++++++++++++++++++++++++++++++++----
  drivers/staging/media/mn88473/mn88473.c | 80 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
  4 files changed, 140 insertions(+), 9 deletions(-)
-- 
http://palosaari.fi/
