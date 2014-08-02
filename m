Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35900 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaHBDtO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 23:49:14 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/5] Digital Devices PCIe bridge update to 0.9.15a
Date: Sat,  2 Aug 2014 06:48:50 +0300
Message-Id: <1406951335-24026-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After cold power-on, my device wasn't able to find DuoFlex C/C2/T/T2
Expansion card, which I added yesterday. I looked old and new drivers
and tried many things, but no success. Old kernel driver was ages,
many years, behind manufacturer current Linux driver and there has
been a tons of changes. So I ended up upgrading Linux kernel driver
to 0.9.15a (it was 0.5).

Now it is very near Digital Devices official driver, only modulator
and network streaming stuff is removed and CI is abusing SEC like
earlier also.

Few device models are not supported due to missing kernel driver or
missing device profile. Those devices are based of following DTV
frontend chipsets:
MaxLinear MxL5xx
STMicroelectronics STV0910
STMicroelectronics STV0367


Tree for testing is here:
http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=digitaldevices

regards
Antti


Antti Palosaari (5):
  cxd2843: do not call get_if_frequency() when it is NULL
  ddbridge: disable driver building
  ddbridge: remove driver temporarily
  ddbridge: add needed files from manufacturer driver 0.9.15a
  ddbridge: clean up driver for release

 drivers/media/dvb-frontends/cxd2843.c      |    3 +-
 drivers/media/pci/ddbridge/Makefile        |    2 -
 drivers/media/pci/ddbridge/ddbridge-core.c | 3175 +++++++++++++++++++---------
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  232 ++
 drivers/media/pci/ddbridge/ddbridge-regs.h |  347 ++-
 drivers/media/pci/ddbridge/ddbridge.c      |  456 ++++
 drivers/media/pci/ddbridge/ddbridge.h      |  407 +++-
 7 files changed, 3518 insertions(+), 1104 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-i2c.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge.c

-- 
http://palosaari.fi/

