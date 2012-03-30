Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41603 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab2C3MdG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Mar 2012 08:33:06 -0400
Message-ID: <4F75A7FE.8090405@iki.fi>
Date: Fri, 30 Mar 2012 15:33:02 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T Stick
 [0ccd:0093]
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve Mauro and all the other hackers,

I did some massive rewrite for my old AF9035/AF9033 driver that was 
never merged. Anyhow, here it is.

New drivers here are:
Infineon TUA 9001 silicon tuner driver
Afatech AF9033 DVB-T demodulator driver
Afatech AF9035 DVB USB driver

AF9035 integrates AF9033. Both chips are also sold separately. AF9033 
will not likely work as a stand-alone since I didn't have hardware to 
test, but in theory it is quite well split out from the DVB USB 
interface driver (AF9035).

Tips for cheap AF9035 based dual devices are welcome!

regards
Antti


The following changes since commit 26315a507f6acda933f0d41200de8fec51775867:

   em28xx-dvb: stop URBs when stopping the streaming (2012-03-28 
15:32:23 +0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git af9035

Antti Palosaari (3):
       Infineon TUA 9001 silicon tuner driver
       Afatech AF9033 DVB-T demodulator driver
       Afatech AF9035 DVB USB driver

  drivers/media/common/tuners/Kconfig        |    6 +
  drivers/media/common/tuners/Makefile       |    1 +
  drivers/media/common/tuners/tua9001.c      |  215 ++++++++
  drivers/media/common/tuners/tua9001.h      |   46 ++
  drivers/media/common/tuners/tua9001_priv.h |   34 ++
  drivers/media/dvb/dvb-usb/Kconfig          |    9 +
  drivers/media/dvb/dvb-usb/Makefile         |    3 +
  drivers/media/dvb/dvb-usb/af9035.c         |  799 
++++++++++++++++++++++++++++
  drivers/media/dvb/dvb-usb/af9035.h         |  102 ++++
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |    1 +
  drivers/media/dvb/frontends/Kconfig        |    5 +
  drivers/media/dvb/frontends/Makefile       |    1 +
  drivers/media/dvb/frontends/af9033.c       |  706 ++++++++++++++++++++++++
  drivers/media/dvb/frontends/af9033.h       |   73 +++
  drivers/media/dvb/frontends/af9033_priv.h  |  242 +++++++++
  15 files changed, 2243 insertions(+), 0 deletions(-)
  create mode 100644 drivers/media/common/tuners/tua9001.c
  create mode 100644 drivers/media/common/tuners/tua9001.h
  create mode 100644 drivers/media/common/tuners/tua9001_priv.h
  create mode 100644 drivers/media/dvb/dvb-usb/af9035.c
  create mode 100644 drivers/media/dvb/dvb-usb/af9035.h
  create mode 100644 drivers/media/dvb/frontends/af9033.c
  create mode 100644 drivers/media/dvb/frontends/af9033.h
  create mode 100644 drivers/media/dvb/frontends/af9033_priv.h
-- 
http://palosaari.fi/
