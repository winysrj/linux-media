Return-path: <mchehab@localhost.localdomain>
Received: from mail.kapsi.fi ([217.30.184.167]:38944 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab0IMA25 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 20:28:57 -0400
Message-ID: <4C8D7045.4030408@iki.fi>
Date: Mon, 13 Sep 2010 03:28:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Stefan Lippers-Hollmann <s.l-h@gmx.de>
CC: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 2.6.37] AF9015 changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Moikka Mauro,
This replaces my earlier pull request. Amongst the other changes, I 
rewrote whole remote controller part. Now it reads IR codes directly 
from the memory. This makes possible to switch upcoming remote core system.

@Stefan, now you can add easily support for your TerraTec remote. Please 
send patch me.

t. Antti


The following changes since commit c9889354c6d36d6278ed851c74ace02d72efdd59:

   V4L/DVB: rc-core: increase repeat time (2010-09-08 13:04:40 -0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git af9015

Antti Palosaari (9):
       af9015: simple comment update
       af9015: fix bug introduced by commit 
490ade7e3f4474f626a8f5d778ead4e599b94fbc
       af9013: add support for MaxLinear MxL5007T tuner
       af9015: add support for TerraTec Cinergy T Stick Dual RC
       af9015: add remote support for TerraTec Cinergy T Stick Dual RC
       af9015: map TerraTec Cinergy T Stick Dual RC remote to device ID
       af9015: reimplement remote controller
       af9013: optimize code size
       af9015: use value from config instead hardcoded one

  drivers/media/dvb/dvb-usb/Kconfig         |    1 +
  drivers/media/dvb/dvb-usb/af9015.c        |  241 +++----
  drivers/media/dvb/dvb-usb/af9015.h        | 1081 
++++++++++-------------------
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h   |    1 +
  drivers/media/dvb/frontends/af9013.c      |  195 +-----
  drivers/media/dvb/frontends/af9013.h      |    1 +
  drivers/media/dvb/frontends/af9013_priv.h |   48 ++-
  7 files changed, 581 insertions(+), 987 deletions(-)

-- 
http://palosaari.fi/
