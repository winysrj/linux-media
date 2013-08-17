Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53538 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3HQXYI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 19:24:08 -0400
Received: from dyn3-82-128-190-204.psoas.suomi.net ([82.128.190.204] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VApqo-0008JI-Jt
	for linux-media@vger.kernel.org; Sun, 18 Aug 2013 02:24:06 +0300
Message-ID: <521005EB.9090400@iki.fi>
Date: Sun, 18 Aug 2013 02:23:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [PULL STAGING] Mirics MSi3101 SDR Dongle driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Linux Media!

I have send all these patches to the mailing list and I haven't make any 
changes but commit log messages. Whilst adding explanation does not make 
much sense in trivial patches I decided to do it as :)
http://lwn.net/Articles/560392/

I request that driver to the staging as there is unresolved issues, most 
notable is not less than API.

I wrote also small blog post about this device and driver:
http://blog.palosaari.fi/2013/08/mirics-msi3101-sdr-linux-driver.html


regards
Antti


The following changes since commit 1c26190a8d492adadac4711fe5762d46204b18b0:

   [media] exynos4-is: Correct colorspace handling at FIMC-LITE 
(2013-06-28 15:33:27 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git mirics

for you to fetch changes up to 2aefec530bdde273efa8894386d9f6a0b1f3caf0:

   msi3101: few improvements for RF tuner (2013-08-18 02:04:20 +0300)

----------------------------------------------------------------
Antti Palosaari (19):
       Mirics MSi3101 SDR Dongle driver
       msi3101: sample is correct term for sample
       msi3101: fix sampling rate calculation
       msi3101: add sampling mode control
       msi3101: enhance sampling results
       msi3101: fix stream re-start halt
       msi3101: add 2040:d300 Hauppauge WinTV 133559 LF
       msi3101: add debug dump for unknown stream data
       msi3101: correct ADC sampling rate calc a little bit
       msi3101: improve tuner synth calc step size
       msi3101: add support for stream format "252" I+Q per frame
       msi3101: init bits 23:20 on PLL register
       msi3101: fix overflow in freq setting
       msi3101: add stream format 336 I+Q pairs per frame
       msi3101: changes for tuner PLL freq limits
       msi3101: a lot of small cleanups
       msi3101: implement stream format 504
       msi3101: change stream format 384
       msi3101: few improvements for RF tuner

  drivers/staging/media/Kconfig               |    2 +
  drivers/staging/media/Makefile              |    1 +
  drivers/staging/media/msi3101/Kconfig       |    3 +
  drivers/staging/media/msi3101/Makefile      |    1 +
  drivers/staging/media/msi3101/sdr-msi3101.c | 1928 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  5 files changed, 1935 insertions(+)
  create mode 100644 drivers/staging/media/msi3101/Kconfig
  create mode 100644 drivers/staging/media/msi3101/Makefile
  create mode 100644 drivers/staging/media/msi3101/sdr-msi3101.c

-- 
http://palosaari.fi/
