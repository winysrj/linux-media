Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:32801 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab1EYUmZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 16:42:25 -0400
Message-ID: <4DDD69AE.3070606@iki.fi>
Date: Wed, 25 May 2011 23:42:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
CC: Steve Kerrison <steve@stevekerrison.com>,
	Dan Carpenter <error27@gmail.com>
Subject: [GIT PULL FOR 2.6.40] PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moikka Mauro,

Fixes...


The following changes since commit 87cf028f3aa1ed51fe29c36df548aa714dc7438f:

   [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control 
through GPIO reworked (2011-05-21 11:10:28 -0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git pctv_290e

Antti Palosaari (7):
       em28xx-dvb: add module param "options" and use it for LNA
       cxd2820r: malloc buffers instead of stack
       cxd2820r: fix bitfields
       em28xx: EM28174 remote support
       em28xx: add remote for PCTV nanoStick T2 290e
       em28xx: correct PCTV nanoStick T2 290e device name
       cxd2820r: correct missing error checks

  drivers/media/dvb/frontends/cxd2820r.h      |    4 +-
  drivers/media/dvb/frontends/cxd2820r_core.c |   22 +++++++++++++---
  drivers/media/dvb/frontends/cxd2820r_priv.h |    4 +-
  drivers/media/video/em28xx/em28xx-cards.c   |    8 +++---
  drivers/media/video/em28xx/em28xx-dvb.c     |   37 
++++++++++++++++++++++++---
  drivers/media/video/em28xx/em28xx-input.c   |    1 +
  6 files changed, 60 insertions(+), 16 deletions(-)


Antti

-- 
http://palosaari.fi/
