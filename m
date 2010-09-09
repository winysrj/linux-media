Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:39912 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab0IIVM3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 17:12:29 -0400
Message-ID: <4C894DB8.8080908@iki.fi>
Date: Fri, 10 Sep 2010 00:12:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Stefan Lippers-Hollmann <s.l-h@gmx.de>
CC: linux-media@vger.kernel.org, TerraTux <terratux@terratec.de>
Subject: [GIT PULL FOR 2.6.37] new AF9015 devices
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Moikka Mauro!
This patch series adds support for TerraTec Cinergy T Stick Dual RC and 
TerraTec Cinergy T Stick RC. Also MxL5007T devices with ref. design IDs 
should be working. Cinergy T Stick remote is most likely not working 
since it seems to use different remote as Cinergy T Dual... Stefan could 
you test and ensure T Stick is working?

and thanks to TerraTec!

t. Antti


The following changes since commit c9889354c6d36d6278ed851c74ace02d72efdd59:

   V4L/DVB: rc-core: increase repeat time (2010-09-08 13:04:40 -0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git af9015

Antti Palosaari (6):
       af9015: simple comment update
       af9015: fix bug introduced by commit 
490ade7e3f4474f626a8f5d778ead4e599b94fbcas
       af9013: add support for MaxLinear MxL5007T tuner
       af9015: add support for TerraTec Cinergy T Stick Dual RC
       af9015: add remote support for TerraTec Cinergy T Stick Dual RC
       af9015: map TerraTec Cinergy T Stick Dual RC remote to device ID

  drivers/media/dvb/dvb-usb/Kconfig         |    1 +
  drivers/media/dvb/dvb-usb/af9015.c        |   50 +++++++++++++----------
  drivers/media/dvb/dvb-usb/af9015.h        |   63 
+++++++++++++++++++++++++++++
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h   |    1 +
  drivers/media/dvb/frontends/af9013.c      |    1 +
  drivers/media/dvb/frontends/af9013.h      |    1 +
  drivers/media/dvb/frontends/af9013_priv.h |    5 +-
  7 files changed, 99 insertions(+), 23 deletions(-)


-- 
http://palosaari.fi/
