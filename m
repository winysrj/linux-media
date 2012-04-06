Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50007 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab2DFLLd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 07:11:33 -0400
Message-ID: <4F7ECF61.5090005@iki.fi>
Date: Fri, 06 Apr 2012 14:11:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
CC: Gianluca Gennari <gennarone@gmail.com>,
	=?windows-1252?Q?Michael_B=FC?= =?windows-1252?Q?sch?=
	<m@bues.ch>, Hans-Frieder Vogt <hfvogt@gmx.net>,
	Pierangelo Terzulli <pierigno@gmail.com>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi>
In-Reply-To: <4F75A7FE.8090405@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PULL-request update.

On 30.03.2012 15:33, Antti Palosaari wrote:
> Terve Mauro and all the other hackers,
>
> I did some massive rewrite for my old AF9035/AF9033 driver that was
> never merged. Anyhow, here it is.
>
> New drivers here are:
> Infineon TUA 9001 silicon tuner driver
> Afatech AF9033 DVB-T demodulator driver
> Afatech AF9035 DVB USB driver

Fitipower FC0011 silicon tuner driver

> AF9035 integrates AF9033. Both chips are also sold separately. AF9033
> will not likely work as a stand-alone since I didn't have hardware to
> test, but in theory it is quite well split out from the DVB USB
> interface driver (AF9035).

The following changes since commit 26315a507f6acda933f0d41200de8fec51775867:

   em28xx-dvb: stop URBs when stopping the streaming (2012-03-28 
15:32:23 +0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git af9035

Antti Palosaari (15):
       Infineon TUA 9001 silicon tuner driver
       Afatech AF9033 DVB-T demodulator driver
       Afatech AF9035 DVB USB driver
       af9035: enhancement for unknown tuner ID handling
       af9035: reimplement firmware downloader
       af9035: add missing error check
       af9033: correct debug print
       af9033: implement .read_snr()
       af9035: add log writing if unsupported Xtal freq is given
       af9035: fix and enhance I2C adapter
       af9035: initial support for IT9135 chip
       af9033: do some minor changes for .get_frontend()
       af9035: minor changes for af9035_fc0011_tuner_callback()
       af9035: reorganise USB ID and device list
       af9035: disable frontend0 I2C-gate control

Gianluca Gennari (5):
       af9035: add USB id for 07ca:a867
       af9035: add support for the tda18218 tuner
       af9035: use module_usb_driver macro
       af9035: fix warning
       af9033: implement get_frontend

Hans-Frieder Vogt (2):
       af9035: i2c read fix
       af9035: add Avermedia Volar HD (A867R) support

Michael Buesch (7):
       af9035: Add USB read checksumming
       Add fc0011 tuner driver
       af9035: Add fc0011 tuner support
       af9035: Add Afatech USB PIDs
       fc0011: use usleep_range()
       af9035: Use usleep_range() in fc0011 support code
       fc0011: Reduce number of retries

Pierangelo Terzulli (1):
       af9035: add AVerMedia Twinstar (A825) [07ca:0825]

  MAINTAINERS                                |    7 +
  drivers/media/common/tuners/Kconfig        |   13 +
  drivers/media/common/tuners/Makefile       |    2 +
  drivers/media/common/tuners/fc0011.c       |  524 +++++++++++++
  drivers/media/common/tuners/fc0011.h       |   41 +
  drivers/media/common/tuners/tua9001.c      |  215 +++++
  drivers/media/common/tuners/tua9001.h      |   46 ++
  drivers/media/common/tuners/tua9001_priv.h |   34 +
  drivers/media/dvb/dvb-usb/Kconfig          |   12 +
  drivers/media/dvb/dvb-usb/Makefile         |    3 +
  drivers/media/dvb/dvb-usb/af9035.c         | 1164 
++++++++++++++++++++++++++++
  drivers/media/dvb/dvb-usb/af9035.h         |  120 +++
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |    8 +
  drivers/media/dvb/frontends/Kconfig        |    5 +
  drivers/media/dvb/frontends/Makefile       |    1 +
  drivers/media/dvb/frontends/af9033.c       |  919 ++++++++++++++++++++++
  drivers/media/dvb/frontends/af9033.h       |   75 ++
  drivers/media/dvb/frontends/af9033_priv.h  |  470 +++++++++++
  18 files changed, 3659 insertions(+), 0 deletions(-)
  create mode 100644 drivers/media/common/tuners/fc0011.c
  create mode 100644 drivers/media/common/tuners/fc0011.h
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
