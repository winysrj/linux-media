Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:34835 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab0HMHhx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Aug 2010 03:37:53 -0400
Message-ID: <4C64F648.2090105@iki.fi>
Date: Fri, 13 Aug 2010 10:37:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, Simon Kenyon <simon@koala.ie>,
	Nikola Pajkovsky <npajkovs@redhat.com>
Subject: [GIT PULL] NXP TDA18218 silicon tuner driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Moikka Mauro,

Here is new silicon tuner driver. I hope all those GIT procedures are 
done correctly, it was rather pain to learn GIT and in-Kernel-tree 
compilation. Hoping I can still see old kind of out-Kernel-tree...

Special thanks goes to Simon Kenyon <simon@koala.ie> for stick donate.



The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

   Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git tda18218

Antti Palosaari (3):
       NXP TDA18218 silicon tuner driver
       af9013: add support for tda18218 silicon tuner
       af9015: add support for tda18218 silicon tuner

  drivers/media/common/tuners/Kconfig         |    7 +
  drivers/media/common/tuners/Makefile        |    1 +
  drivers/media/common/tuners/tda18218.c      |  334 
+++++++++++++++++++++++++++
  drivers/media/common/tuners/tda18218.h      |   45 ++++
  drivers/media/common/tuners/tda18218_priv.h |  106 +++++++++
  drivers/media/dvb/dvb-usb/af9015.c          |   14 +-
  drivers/media/dvb/frontends/af9013.c        |   14 ++
  drivers/media/dvb/frontends/af9013_priv.h   |    5 +-
  8 files changed, 521 insertions(+), 5 deletions(-)
  create mode 100644 drivers/media/common/tuners/tda18218.c
  create mode 100644 drivers/media/common/tuners/tda18218.h
  create mode 100644 drivers/media/common/tuners/tda18218_priv.h


t. Antti
-- 
http://palosaari.fi/
