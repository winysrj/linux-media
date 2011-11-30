Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47585 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab1K3RZB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:25:01 -0500
Message-ID: <4ED666E9.2020405@iki.fi>
Date: Wed, 30 Nov 2011 19:24:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PULL] af9013
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Morjens Mauro,

I rewrote whole af9013 demodulator driver in order to decrease I2C load. 
Please pull that to the next Kernel merge window.

Antti

The following changes since commit a235af24a74a0fa03ece0a9f5e28a72e4d1e2cad:

   ce168: remove experimental from Kconfig (2011-11-19 23:07:54 +0200)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git misc

Antti Palosaari (1):
       af9013: rewrite whole driver

  drivers/media/dvb/dvb-usb/af9015.c        |   82 +-
  drivers/media/dvb/frontends/af9013.c      | 1756 
++++++++++++++---------------
  drivers/media/dvb/frontends/af9013.h      |  113 +-
  drivers/media/dvb/frontends/af9013_priv.h |   93 +-
  4 files changed, 1017 insertions(+), 1027 deletions(-)

-- 
http://palosaari.fi/
