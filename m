Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47690 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab3ADR2M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 12:28:12 -0500
Message-ID: <50E71107.8050907@iki.fi>
Date: Fri, 04 Jan 2013 19:27:35 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Jose Alberto Reguero <jareguero@telefonica.net>,
	Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [PULL] AF9035
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 16427faf28674451a7a0485ab0a929402f355ffd:

   [media] tm6000: Add parameter to keep urb bufs allocated (2012-12-04 
14:54:21 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9035

for you to fetch changes up to 3cd16213e725620cca9b6c324e7841e489b05893:

   af9035: print warning when firmware is bad (2013-01-04 19:19:53 +0200)

----------------------------------------------------------------
Antti Palosaari (16):
       af9033: add support for Fitipower FC0012 tuner
       af9035: support for Fitipower FC0012 tuner devices
       af9035: dual mode related changes
       fc0012: use struct for driver config
       fc0012: add RF loop through
       fc0012: enable clock output on attach()
       af9035: add support for fc0012 dual tuner configuration
       fc0012: use config directly from the config struct
       fc0012: rework attach() to check chip id and I/O errors
       fc0012: use Kernel dev_foo() logging
       fc0012: remove unused callback and correct one comment
       af9033: update demod init sequence
       af9033: update tua9001 init sequence
       af9033: update fc0011 init sequence
       af9033: update fc2580 init sequence
       af9035: print warning when firmware is bad

Jose Alberto Reguero (1):
       af9035: dual mode support

  drivers/media/dvb-frontends/af9033.c      |  18 +++++++++
  drivers/media/dvb-frontends/af9033.h      |   1 +
  drivers/media/dvb-frontends/af9033_priv.h | 132 
++++++++++++++++++++++++++++++++++++++++++---------------------
  drivers/media/tuners/fc0012-priv.h        |  13 +------
  drivers/media/tuners/fc0012.c             | 113 
+++++++++++++++++++++++++++++++++++++++---------------
  drivers/media/tuners/fc0012.h             |  32 +++++++++++++---
  drivers/media/usb/dvb-usb-v2/af9035.c     | 285 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
  drivers/media/usb/dvb-usb-v2/af9035.h     |   3 +-
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c   |   7 +++-
  9 files changed, 455 insertions(+), 149 deletions(-)

-- 
http://palosaari.fi/
