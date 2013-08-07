Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44683 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 00/16 STAGING] Mirics MSi3101 SDR Dongle driver
Date: Wed,  7 Aug 2013 21:51:31 +0300
Message-Id: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is driver for MSi3101 USB SDR designed by Mirics. I will pull-request
that soon for the Kernel 3.12 staging. It is not ready for mainline as
there is multiple issues. Biggest issues are; missing API controls and
stream format conversions should be implemented by libv4l2.

That driver is MSi3101 design, which consists of two chips: 1) USB ADC
called MSi2500 and RF-tuner called MSi001. So I will split that to the
two parts later...

USB ADC is a state of the art in the reverse-engineering as I was not
able to get documentation or other needed info, gah :-( Anyhow, it was
quite interesting as a point of learn the first USB ADC I have seen.
Biggest challenge was to discover how to calculate ADC sampling rate.
It was a typical Fractional-N PLL as all these are nowadays. First I
calculated sampling rates by the driver, after that brute forced PLL
registers with a different values and look what kind of data rate it is
outputting :) Nice trick - but took a lot of time.
Re-engineering such USB ADC is still a little bit easier than typical
DTV demodulator in my experience.

Another, not so hard, issue to mention was understand different stream
formats. Chip seems to offer multiple formats, best one I found seems to
offer even 14-bit resolution.

Special thanks to University Oulu HAM club, Oulun Teekkarien Radiokerho,
OH8TA, for the support I received. You rule!

Antti Palosaari (16):
  Mirics MSi3101 SDR Dongle driver
  msi3101: sample is correct term for sample
  msi3101: fix sampling rate calculation
  msi3101: add sampling mode control
  msi3101: enhance sampling results
  msi3101: fix stream re-start halt
  msi3101: add 2040:d300 Hauppauge WinTV 133559 LF
  msi3101: add debug dump for unknown stream data
  msi3101: correct ADC sampling rate calc a little
  msi3101: improve tuner synth calc step size
  msi3101: add support for stream format "252" I+Q per frame
  msi3101: init bits 23:20 on PLL register
  msi3101: fix overflow in freq setting
  msi3101: add stream format 336 I+Q pairs per frame
  msi3101: changes for tuner PLL freq limits
  msi3101: a lot of small cleanups

 drivers/staging/media/Kconfig               |    2 +
 drivers/staging/media/Makefile              |    1 +
 drivers/staging/media/msi3101/Kconfig       |    3 +
 drivers/staging/media/msi3101/Makefile      |    1 +
 drivers/staging/media/msi3101/sdr-msi3101.c | 1822 +++++++++++++++++++++++++++
 5 files changed, 1829 insertions(+)
 create mode 100644 drivers/staging/media/msi3101/Kconfig
 create mode 100644 drivers/staging/media/msi3101/Makefile
 create mode 100644 drivers/staging/media/msi3101/sdr-msi3101.c

-- 
1.7.11.7

