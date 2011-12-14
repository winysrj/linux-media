Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53770 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321Ab1LNW53 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 17:57:29 -0500
Message-ID: <4EE929D5.6010106@iki.fi>
Date: Thu, 15 Dec 2011 00:57:25 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.3] HDIC HD29L2 DMB-TH demodulator driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please PULL that new driver to the Kernel 3.3!

Antti

The following changes since commit 6dbc13e364ad49deb9dd93c4ab84af53ffb52435:

   mxl5007t: implement .get_if_frequency() (2011-10-10 00:57:07 +0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git hdic

Antti Palosaari (1):
       HDIC HD29L2 DMB-TH demodulator driver

  drivers/media/dvb/frontends/Kconfig       |    7 +
  drivers/media/dvb/frontends/Makefile      |    1 +
  drivers/media/dvb/frontends/hd29l2.c      |  863 
+++++++++++++++++++++++++++++
  drivers/media/dvb/frontends/hd29l2.h      |   66 +++
  drivers/media/dvb/frontends/hd29l2_priv.h |  314 +++++++++++
  5 files changed, 1251 insertions(+), 0 deletions(-)
  create mode 100644 drivers/media/dvb/frontends/hd29l2.c
  create mode 100644 drivers/media/dvb/frontends/hd29l2.h
  create mode 100644 drivers/media/dvb/frontends/hd29l2_priv.h


-- 
http://palosaari.fi/
