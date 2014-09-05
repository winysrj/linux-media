Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52223 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbaIEHmL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Sep 2014 03:42:11 -0400
Received: from dyn3-82-128-191-243.psoas.suomi.net ([82.128.191.243] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XPo9p-0005rV-S6
	for linux-media@vger.kernel.org; Fri, 05 Sep 2014 10:42:09 +0300
Message-ID: <54096951.6050506@iki.fi>
Date: Fri, 05 Sep 2014 10:42:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.18] misc dtv/sdr changes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 89fffac802c18caebdf4e91c0785b522c9f6399a:

   [media] drxk_hard: fix bad alignments (2014-09-03 19:19:18 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git fix_logging

for you to fetch changes up to d47e5df7427fa9b149a3264835e7f8e1e69cbd73:

   rtl2832_sdr: logging changes (2014-09-05 10:34:42 +0300)

----------------------------------------------------------------
Antti Palosaari (12):
       airspy: fix error handling on start streaming
       airspy: coding style issues
       airspy: logging changes
       airspy: remove unneeded spinlock irq flags initialization
       airspy: enhance sample rate debug calculation precision
       msi2500: logging changes
       msi001: logging changes
       msi2500: remove unneeded spinlock irq flags initialization
       e4000: logging changes
       rtl2832_sdr: remove unneeded spinlock irq flags initialization
       rtl2832_sdr: enhance sample rate debug calculation precision
       rtl2832_sdr: logging changes

  drivers/media/dvb-frontends/rtl2832_sdr.c | 116 
++++++++++++++++++++++++++++++++++-------------------------------------
  drivers/media/tuners/e4000.c              |  71 
++++++++++++++++++++-----------------------
  drivers/media/tuners/msi001.c             |  56 
++++++++++++++++++----------------
  drivers/media/usb/airspy/airspy.c         | 222 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------------
  drivers/media/usb/msi2500/msi2500.c       | 163 
++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------
  5 files changed, 287 insertions(+), 341 deletions(-)

-- 
http://palosaari.fi/
