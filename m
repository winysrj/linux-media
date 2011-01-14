Return-path: <mchehab@pedra>
Received: from bonnie-vm4.ifh.de ([141.34.50.21]:35424 "EHLO smtp.ifh.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757490Ab1ANPPJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 10:15:09 -0500
Date: Fri, 14 Jan 2011 15:51:32 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL] request for 2.6.38-rc1
Message-ID: <alpine.LRH.2.00.1101141542460.6649@pub3.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

if it is not too late, here is a pull request for some new devices from 
DiBcom. It would be nice to have it in 2.6.38-rc1.

Pull from

git://linuxtv.org/pb/media_tree.git staging/for_2.6.38-rc1.dibcom

for

DiBxxxx: Codingstype updates
DiB0700: add support for several board-layouts
DiB7090: add support for the dib7090 based
DIB9000: initial support added
DiB0090: misc improvements
DiBx000: add addition i2c-interface names
DiB8000: add diversity support
DiB0700: add function to change I2C-speed

  drivers/media/dvb/dvb-usb/dib0700.h          |    2 +
  drivers/media/dvb/dvb-usb/dib0700_core.c     |   47 +-
  drivers/media/dvb/dvb-usb/dib0700_devices.c  | 1374 ++++++++++++++--
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h      |    5 +
  drivers/media/dvb/frontends/Kconfig          |    8 +
  drivers/media/dvb/frontends/Makefile         |    1 +
  drivers/media/dvb/frontends/dib0090.c        | 1583 ++++++++++++++----
  drivers/media/dvb/frontends/dib0090.h        |   31 +
  drivers/media/dvb/frontends/dib7000p.c       | 1943 ++++++++++++++++------
  drivers/media/dvb/frontends/dib7000p.h       |   96 +-
  drivers/media/dvb/frontends/dib8000.c        |  833 ++++++----
  drivers/media/dvb/frontends/dib8000.h        |   20 +
  drivers/media/dvb/frontends/dib9000.c        | 2350 ++++++++++++++++++++++++++
  drivers/media/dvb/frontends/dib9000.h        |  131 ++
  drivers/media/dvb/frontends/dibx000_common.c |  279 +++-
  drivers/media/dvb/frontends/dibx000_common.h |  152 ++-
  16 files changed, 7487 insertions(+), 1368 deletions(-)


best regards,
--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
