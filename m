Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58336 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab2GBJe3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Jul 2012 05:34:29 -0400
Message-ID: <4FF16B1A.8000909@iki.fi>
Date: Mon, 02 Jul 2012 12:34:18 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
CC: Thomas Mair <thomas.mair86@googlemail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Aubin Constans <aconstans@wyplay.com>
Subject: [GIT PULL FOR v3.6] rtl2832 and misc changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
That set contains RTL2832 DVB-T demodulator driver by Thomas Mair which 
was requested earlier too but was not merged. The other part is tda10071 
and a8293 changes, two small bug fixes that I *do not want* for 3.5 but 
3.6 as those are not critical.

regards
Antti


The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

   Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git misc

for you to fetch changes up to 1f2375ea95c221679920f2c88d9defde9ebb4157:

   a8293: use Kernel dev_* logging (2012-07-02 11:13:58 +0300)

----------------------------------------------------------------
Antti Palosaari (5):
       tda10071: fix DiSEqC message len check
       tda10071: use decimal numbers for indexes and lengths
       tda10071: convert Kernel dev_* logging
       a8293: fix register 00 init value
       a8293: use Kernel dev_* logging

Thomas Mair (5):
       RTL2832 DVB-T demodulator driver
       rtl28xxu: support for the rtl2832 demod driver
       rtl28xxu: renamed rtl2831_rd/rtl2831_wr to rtl28xx_rd/rtl28xx_wr
       rtl28xxu: support Delock USB 2.0 DVB-T
       rtl28xxu: support Terratec Noxon DAB/DAB+ stick

  drivers/media/dvb/dvb-usb/Kconfig           |    3 +
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    3 +
  drivers/media/dvb/dvb-usb/rtl28xxu.c        |  516 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
  drivers/media/dvb/frontends/Kconfig         |    7 ++
  drivers/media/dvb/frontends/Makefile        |    1 +
  drivers/media/dvb/frontends/a8293.c         |   37 ++----
  drivers/media/dvb/frontends/rtl2832.c       |  823 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/dvb/frontends/rtl2832.h       |   74 ++++++++++++
  drivers/media/dvb/frontends/rtl2832_priv.h  |  260 
++++++++++++++++++++++++++++++++++++++++++
  drivers/media/dvb/frontends/tda10071.c      |  351 
+++++++++++++++++++++++++++++---------------------------
  drivers/media/dvb/frontends/tda10071_priv.h |   15 +--
  11 files changed, 1833 insertions(+), 257 deletions(-)
  create mode 100644 drivers/media/dvb/frontends/rtl2832.c
  create mode 100644 drivers/media/dvb/frontends/rtl2832.h
  create mode 100644 drivers/media/dvb/frontends/rtl2832_priv.h

-- 
http://palosaari.fi/

