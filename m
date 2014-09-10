Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58687 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaIJHZc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 03:25:32 -0400
Received: from dyn3-82-128-191-243.psoas.suomi.net ([82.128.191.243] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XRcHT-0005TD-3e
	for linux-media@vger.kernel.org; Wed, 10 Sep 2014 10:25:31 +0300
Message-ID: <540FFCEA.70807@iki.fi>
Date: Wed, 10 Sep 2014 10:25:30 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.18] HackRF SDR driver
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f5281fc81e9a0a3e80b78720c5ae2ed06da3bfae:

   [media] vpif: Fix compilation with allmodconfig (2014-09-09 18:08:08 
-0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git hackrf

for you to fetch changes up to a8483a8ee416c37f6c44cf7883309e5badcabc33:

   MAINTAINERS: add HackRF SDR driver (2014-09-10 10:20:15 +0300)

----------------------------------------------------------------
Antti Palosaari (2):
       hackrf: HackRF SDR driver
       MAINTAINERS: add HackRF SDR driver

  MAINTAINERS                       |   10 ++
  drivers/media/usb/Kconfig         |    3 +-
  drivers/media/usb/Makefile        |    3 +-
  drivers/media/usb/hackrf/Kconfig  |   10 ++
  drivers/media/usb/hackrf/Makefile |    1 +
  drivers/media/usb/hackrf/hackrf.c | 1142 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  6 files changed, 1167 insertions(+), 2 deletions(-)
  create mode 100644 drivers/media/usb/hackrf/Kconfig
  create mode 100644 drivers/media/usb/hackrf/Makefile
  create mode 100644 drivers/media/usb/hackrf/hackrf.c

-- 
http://palosaari.fi/
