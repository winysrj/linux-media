Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:51377 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3KCAgY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Nov 2013 20:36:24 -0400
Received: from mail.swsoft.eu ([109.70.220.2])
	by relay.swsoft.eu with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <mbroemme@parallels.com>)
	id 1VclSe-0001pY-Ao
	for linux-media@vger.kernel.org; Sun, 03 Nov 2013 01:22:36 +0100
Received: from parallels.com (cable-78-34-76-230.netcologne.de [78.34.76.230])
	by code.dyndns.org (Postfix) with ESMTPSA id 7ED7A140CAF	for
 <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:22:35 +0100 (CET)
Date: Sun, 3 Nov 2013 01:22:35 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 00/12] DDBridge 0.9.10 driver updates
Message-ID: <20131103002235.GD7956@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've updated the current DDBridge to latest version 0.9.10 from Ralph
Metzler available at:

http://www.metzlerbros.de/dddvb/dddvb-0.9.10.tar.bz2

I've merged the driver to work with current v4l/dvb tree and I will
maintain the driver for v4l/dvb in future. The coming patch series is
the first version and I explicitly want to get feedback and hints if
some parts are merged at wrong places, etc... The following changes
were made:

  - MSI enabled by default (some issues left with i2c timeouts)
  - no support for Digital Devices Octonet
  - no support for DVB Netstream
  - removed unused module parameters 'tt' and 'vlan' (used by Octonet)
  - removed unused registers to cleanup code (might be added later again
    if needed)

The following devices are supported by the driver update:

  - Octopus DVB adapter
  - Octopus V3 DVB adapter
  - Octopus LE DVB adapter
  - Octopus OEM
  - Octopus Mini
  - Cine S2 V6 DVB adapter
  - Cine S2 V6.5 DVB adapter
  - Octopus CI
  - Octopus CI single
  - DVBCT V6.1 DVB adapter
  - DVB-C modulator
  - SaTiX-S2 V3 DVB adapter

I might merge the Octonet and DVB Netstream drivers from Ralphs source
later once the current committed DDBridge driver updates are merged in
mainline.

Signed-off-by: Maik Broemme <mbroemme@parallels.com>

Maik Broemme (12):
  dvb-frontends: Support for DVB-C2 to DVB frontends
  tda18271c2dd: Fix description of NXP TDA18271C2 silicon tuner
  stv0367dd: Support for STV 0367 DVB-C/T (DD) demodulator
  tda18212dd: Support for NXP TDA18212 (DD) silicon tuner
  cxd2843: Support for CXD2843ER demodulator for DVB-T/T2/C/C2
  dvb-core: export dvb_usercopy and new DVB device constants
  ddbridge: Updated ddbridge registers
  ddbridge: Moved i2c interfaces into separate file
  ddbridge: Support for the Digital Devices Resi DVB-C Modulator card
  ddbridge: Update ddbridge driver to version 0.9.10
  ddbridge: Update ddbridge header for 0.9.10 changes
  ddbridge: Kconfig and Makefile fixes to build latest ddbridge

 drivers/media/dvb-core/dvbdev.c              |    1 
 drivers/media/dvb-core/dvbdev.h              |    2 
 drivers/media/dvb-frontends/Kconfig          |   31 
 drivers/media/dvb-frontends/Makefile         |    3 
 drivers/media/dvb-frontends/cxd2843.c        | 1647 ++++++++++++
 drivers/media/dvb-frontends/cxd2843.h        |   47 
 drivers/media/dvb-frontends/stv0367dd.c      | 2329 ++++++++++++++++++
 drivers/media/dvb-frontends/stv0367dd.h      |   48 
 drivers/media/dvb-frontends/stv0367dd_regs.h | 3442 +++++++++++++++++++++++++++
 drivers/media/dvb-frontends/tda18212dd.c     |  934 +++++++
 drivers/media/dvb-frontends/tda18212dd.h     |   37 
 drivers/media/pci/ddbridge/Kconfig           |   21 
 drivers/media/pci/ddbridge/Makefile          |    2 
 drivers/media/pci/ddbridge/ddbridge-core.c   | 3085 +++++++++++++++++-------
 drivers/media/pci/ddbridge/ddbridge-i2c.c    |  239 +
 drivers/media/pci/ddbridge/ddbridge-mod.c    | 1033 ++++++++
 drivers/media/pci/ddbridge/ddbridge-regs.h   |  273 +-
 drivers/media/pci/ddbridge/ddbridge.h        |  408 ++-
 include/uapi/linux/dvb/frontend.h            |    1 
 19 files changed, 12555 insertions(+), 1028 deletions(-)

--Maik
