Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:37795 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3JCL0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 07:26:51 -0400
Received: by mail-qc0-f180.google.com with SMTP id p19so1490457qcv.39
        for <linux-media@vger.kernel.org>; Thu, 03 Oct 2013 04:26:50 -0700 (PDT)
Date: Thu, 3 Oct 2013 07:26:45 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: [GIT PULL] dvb-usb: fix error handling in ttusb_dec_probe()
Message-ID: <20131003072645.4a02db3b@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
b4559ace2ca8c88666584279f582b998c6591fb0:

  [media] ts2020: keep 1.06 MHz as default value for frequency_div
  (2013-10-02 06:48:15 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb ttusb

for you to fetch changes up to 6f0be418ace3bf7ebb19434a8308cea2223fe6e4:

  dvb-usb: fix error handling in ttusb_dec_probe() (2013-10-02 12:00:26
  -0400)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      dvb-usb: fix error handling in ttusb_dec_probe()

 drivers/media/usb/ttusb-dec/ttusb_dec.c | 152 ++++++++++++----------
 1 file changed, 82 insertions(+), 70 deletions(-)
