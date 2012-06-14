Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab2FNUix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:53 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKcrQf026672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 06/10] [media] Rename media/dvb as media/pci
Date: Thu, 14 Jun 2012 17:35:57 -0300
Message-Id: <1339706161-22713-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The remaining dvb drivers are pci, so rename them to match the
bus.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/dvb/kdapi.xml            |    2 +-
 drivers/media/Kconfig                                |    2 +-
 drivers/media/Makefile                               |    2 +-
 drivers/media/{dvb => pci}/Kconfig                   |   18 +++++++++---------
 drivers/media/{dvb => pci}/Makefile                  |    0
 drivers/media/{dvb => pci}/b2c2/Kconfig              |    0
 drivers/media/{dvb => pci}/b2c2/Makefile             |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-common.h     |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-dma.c        |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-eeprom.c     |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-fe-tuner.c   |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-hw-filter.c  |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-i2c.c        |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-misc.c       |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-pci.c        |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-reg.h        |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-sram.c       |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-usb.c        |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-usb.h        |    0
 drivers/media/{dvb => pci}/b2c2/flexcop.c            |    0
 drivers/media/{dvb => pci}/b2c2/flexcop.h            |    0
 .../media/{dvb => pci}/b2c2/flexcop_ibi_value_be.h   |    0
 .../media/{dvb => pci}/b2c2/flexcop_ibi_value_le.h   |    0
 drivers/media/{dvb => pci}/bt8xx/Kconfig             |    0
 drivers/media/{dvb => pci}/bt8xx/Makefile            |    0
 drivers/media/{dvb => pci}/bt8xx/bt878.c             |    0
 drivers/media/{dvb => pci}/bt8xx/bt878.h             |    0
 drivers/media/{dvb => pci}/bt8xx/dst.c               |    0
 drivers/media/{dvb => pci}/bt8xx/dst_ca.c            |    0
 drivers/media/{dvb => pci}/bt8xx/dst_ca.h            |    0
 drivers/media/{dvb => pci}/bt8xx/dst_common.h        |    0
 drivers/media/{dvb => pci}/bt8xx/dst_priv.h          |    0
 drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.c         |    0
 drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.h         |    0
 drivers/media/{dvb => pci}/ddbridge/Kconfig          |    0
 drivers/media/{dvb => pci}/ddbridge/Makefile         |    0
 drivers/media/{dvb => pci}/ddbridge/ddbridge-core.c  |    0
 drivers/media/{dvb => pci}/ddbridge/ddbridge-regs.h  |    0
 drivers/media/{dvb => pci}/ddbridge/ddbridge.h       |    0
 drivers/media/{dvb => pci}/dm1105/Kconfig            |    0
 drivers/media/{dvb => pci}/dm1105/Makefile           |    0
 drivers/media/{dvb => pci}/dm1105/dm1105.c           |    0
 drivers/media/{dvb => pci}/mantis/Kconfig            |    0
 drivers/media/{dvb => pci}/mantis/Makefile           |    0
 drivers/media/{dvb => pci}/mantis/hopper_cards.c     |    0
 drivers/media/{dvb => pci}/mantis/hopper_vp3028.c    |    0
 drivers/media/{dvb => pci}/mantis/hopper_vp3028.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_ca.c        |    0
 drivers/media/{dvb => pci}/mantis/mantis_ca.h        |    0
 drivers/media/{dvb => pci}/mantis/mantis_cards.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_common.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_core.c      |    0
 drivers/media/{dvb => pci}/mantis/mantis_core.h      |    0
 drivers/media/{dvb => pci}/mantis/mantis_dma.c       |    0
 drivers/media/{dvb => pci}/mantis/mantis_dma.h       |    0
 drivers/media/{dvb => pci}/mantis/mantis_dvb.c       |    0
 drivers/media/{dvb => pci}/mantis/mantis_dvb.h       |    0
 drivers/media/{dvb => pci}/mantis/mantis_evm.c       |    0
 drivers/media/{dvb => pci}/mantis/mantis_hif.c       |    0
 drivers/media/{dvb => pci}/mantis/mantis_hif.h       |    0
 drivers/media/{dvb => pci}/mantis/mantis_i2c.c       |    0
 drivers/media/{dvb => pci}/mantis/mantis_i2c.h       |    0
 drivers/media/{dvb => pci}/mantis/mantis_input.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_ioc.c       |    0
 drivers/media/{dvb => pci}/mantis/mantis_ioc.h       |    0
 drivers/media/{dvb => pci}/mantis/mantis_link.h      |    0
 drivers/media/{dvb => pci}/mantis/mantis_pci.c       |    0
 drivers/media/{dvb => pci}/mantis/mantis_pci.h       |    0
 drivers/media/{dvb => pci}/mantis/mantis_pcmcia.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_reg.h       |    0
 drivers/media/{dvb => pci}/mantis/mantis_uart.c      |    0
 drivers/media/{dvb => pci}/mantis/mantis_uart.h      |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1033.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1033.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1034.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1034.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1041.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1041.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2033.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2033.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2040.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2040.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3028.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3028.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3030.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3030.h    |    0
 drivers/media/{dvb => pci}/ngene/Kconfig             |    0
 drivers/media/{dvb => pci}/ngene/Makefile            |    0
 drivers/media/{dvb => pci}/ngene/ngene-cards.c       |    0
 drivers/media/{dvb => pci}/ngene/ngene-core.c        |    0
 drivers/media/{dvb => pci}/ngene/ngene-dvb.c         |    0
 drivers/media/{dvb => pci}/ngene/ngene-i2c.c         |    0
 drivers/media/{dvb => pci}/ngene/ngene.h             |    0
 drivers/media/{dvb => pci}/pluto2/Kconfig            |    0
 drivers/media/{dvb => pci}/pluto2/Makefile           |    0
 drivers/media/{dvb => pci}/pluto2/pluto2.c           |    0
 drivers/media/{dvb => pci}/pt1/Kconfig               |    0
 drivers/media/{dvb => pci}/pt1/Makefile              |    0
 drivers/media/{dvb => pci}/pt1/pt1.c                 |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007s.c        |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007s.h        |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007t.c        |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007t.h        |    0
 drivers/media/{dvb => pci}/ttpci/Kconfig             |    0
 drivers/media/{dvb => pci}/ttpci/Makefile            |    0
 drivers/media/{dvb => pci}/ttpci/av7110.c            |    0
 drivers/media/{dvb => pci}/ttpci/av7110.h            |    0
 drivers/media/{dvb => pci}/ttpci/av7110_av.c         |    0
 drivers/media/{dvb => pci}/ttpci/av7110_av.h         |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ca.c         |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ca.h         |    0
 drivers/media/{dvb => pci}/ttpci/av7110_hw.c         |    0
 drivers/media/{dvb => pci}/ttpci/av7110_hw.h         |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ipack.c      |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ipack.h      |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ir.c         |    0
 drivers/media/{dvb => pci}/ttpci/av7110_v4l.c        |    0
 drivers/media/{dvb => pci}/ttpci/budget-av.c         |    0
 drivers/media/{dvb => pci}/ttpci/budget-ci.c         |    0
 drivers/media/{dvb => pci}/ttpci/budget-core.c       |    0
 drivers/media/{dvb => pci}/ttpci/budget-patch.c      |    0
 drivers/media/{dvb => pci}/ttpci/budget.c            |    0
 drivers/media/{dvb => pci}/ttpci/budget.h            |    0
 drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.c      |    0
 drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.h      |    0
 drivers/media/usb/dvb-usb/Makefile                   |    2 +-
 126 files changed, 13 insertions(+), 13 deletions(-)
 rename drivers/media/{dvb => pci}/Kconfig (71%)
 rename drivers/media/{dvb => pci}/Makefile (100%)
 rename drivers/media/{dvb => pci}/b2c2/Kconfig (100%)
 rename drivers/media/{dvb => pci}/b2c2/Makefile (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-common.h (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-dma.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-eeprom.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-fe-tuner.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-hw-filter.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-i2c.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-misc.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-pci.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-reg.h (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-sram.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-usb.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-usb.h (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop.h (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop_ibi_value_be.h (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop_ibi_value_le.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/Kconfig (100%)
 rename drivers/media/{dvb => pci}/bt8xx/Makefile (100%)
 rename drivers/media/{dvb => pci}/bt8xx/bt878.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/bt878.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_ca.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_ca.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_common.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_priv.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.h (100%)
 rename drivers/media/{dvb => pci}/ddbridge/Kconfig (100%)
 rename drivers/media/{dvb => pci}/ddbridge/Makefile (100%)
 rename drivers/media/{dvb => pci}/ddbridge/ddbridge-core.c (100%)
 rename drivers/media/{dvb => pci}/ddbridge/ddbridge-regs.h (100%)
 rename drivers/media/{dvb => pci}/ddbridge/ddbridge.h (100%)
 rename drivers/media/{dvb => pci}/dm1105/Kconfig (100%)
 rename drivers/media/{dvb => pci}/dm1105/Makefile (100%)
 rename drivers/media/{dvb => pci}/dm1105/dm1105.c (100%)
 rename drivers/media/{dvb => pci}/mantis/Kconfig (100%)
 rename drivers/media/{dvb => pci}/mantis/Makefile (100%)
 rename drivers/media/{dvb => pci}/mantis/hopper_cards.c (100%)
 rename drivers/media/{dvb => pci}/mantis/hopper_vp3028.c (100%)
 rename drivers/media/{dvb => pci}/mantis/hopper_vp3028.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ca.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ca.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_cards.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_common.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_core.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_core.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dma.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dma.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dvb.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dvb.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_evm.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_hif.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_hif.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_i2c.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_i2c.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_input.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ioc.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ioc.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_link.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_pci.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_pci.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_pcmcia.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_reg.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_uart.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_uart.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1033.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1033.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1034.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1034.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1041.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1041.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2033.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2033.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2040.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2040.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3028.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3028.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3030.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3030.h (100%)
 rename drivers/media/{dvb => pci}/ngene/Kconfig (100%)
 rename drivers/media/{dvb => pci}/ngene/Makefile (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene-cards.c (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene-core.c (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene-dvb.c (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene-i2c.c (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene.h (100%)
 rename drivers/media/{dvb => pci}/pluto2/Kconfig (100%)
 rename drivers/media/{dvb => pci}/pluto2/Makefile (100%)
 rename drivers/media/{dvb => pci}/pluto2/pluto2.c (100%)
 rename drivers/media/{dvb => pci}/pt1/Kconfig (100%)
 rename drivers/media/{dvb => pci}/pt1/Makefile (100%)
 rename drivers/media/{dvb => pci}/pt1/pt1.c (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007s.c (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007s.h (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007t.c (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007t.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/Kconfig (100%)
 rename drivers/media/{dvb => pci}/ttpci/Makefile (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_av.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_av.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ca.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ca.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_hw.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_hw.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ipack.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ipack.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ir.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_v4l.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-av.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-ci.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-core.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-patch.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.h (100%)

diff --git a/Documentation/DocBook/media/dvb/kdapi.xml b/Documentation/DocBook/media/dvb/kdapi.xml
index 6c67481..6c11ec5 100644
--- a/Documentation/DocBook/media/dvb/kdapi.xml
+++ b/Documentation/DocBook/media/dvb/kdapi.xml
@@ -2,7 +2,7 @@
 <para>The kernel demux API defines a driver-internal interface for registering low-level,
 hardware specific driver to a hardware independent demux layer. It is only of interest for
 DVB device driver writers. The header file for this API is named <emphasis role="tt">demux.h</emphasis> and located in
-<emphasis role="tt">drivers/media/dvb/dvb-core</emphasis>.
+<emphasis role="tt">drivers/media/dvb-core</emphasis>.
 </para>
 <para>Maintainer note: This section must be reviewed. It is probably out of date.
 </para>
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index d71a855..bd415c4 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -164,7 +164,7 @@ source "drivers/media/radio/Kconfig"
 #
 
 source "drivers/media/dvb-core/Kconfig"
-source "drivers/media/dvb/Kconfig"
+source "drivers/media/pci/Kconfig"
 source "drivers/media/usb/Kconfig"
 
 comment "Supported FireWire (IEEE 1394) Adapters"
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 46a8dc3..90ec998 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -11,5 +11,5 @@ endif
 obj-y += v4l2-core/ common/ rc/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
-obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb/ dvb-frontends/ usb/
+obj-$(CONFIG_DVB_CORE)  += dvb-core/ pci/ dvb-frontends/ usb/
 obj-$(CONFIG_DVB_FIREDTV) += firewire/
diff --git a/drivers/media/dvb/Kconfig b/drivers/media/pci/Kconfig
similarity index 71%
rename from drivers/media/dvb/Kconfig
rename to drivers/media/pci/Kconfig
index e2565a4..3b9164a 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -13,38 +13,38 @@ if DVB_CAPTURE_DRIVERS && DVB_CORE
 
 comment "Supported SAA7146 based PCI Adapters"
 	depends on DVB_CORE && PCI && I2C
-source "drivers/media/dvb/ttpci/Kconfig"
+source "drivers/media/pci/ttpci/Kconfig"
 
 comment "Supported FlexCopII (B2C2) Adapters"
 	depends on DVB_CORE && (PCI || USB) && I2C
-source "drivers/media/dvb/b2c2/Kconfig"
+source "drivers/media/pci/b2c2/Kconfig"
 
 comment "Supported BT878 Adapters"
 	depends on DVB_CORE && PCI && I2C
-source "drivers/media/dvb/bt8xx/Kconfig"
+source "drivers/media/pci/bt8xx/Kconfig"
 
 comment "Supported Pluto2 Adapters"
 	depends on DVB_CORE && PCI && I2C
-source "drivers/media/dvb/pluto2/Kconfig"
+source "drivers/media/pci/pluto2/Kconfig"
 
 comment "Supported SDMC DM1105 Adapters"
 	depends on DVB_CORE && PCI && I2C
-source "drivers/media/dvb/dm1105/Kconfig"
+source "drivers/media/pci/dm1105/Kconfig"
 
 comment "Supported Earthsoft PT1 Adapters"
 	depends on DVB_CORE && PCI && I2C
-source "drivers/media/dvb/pt1/Kconfig"
+source "drivers/media/pci/pt1/Kconfig"
 
 comment "Supported Mantis Adapters"
 	depends on DVB_CORE && PCI && I2C
-	source "drivers/media/dvb/mantis/Kconfig"
+	source "drivers/media/pci/mantis/Kconfig"
 
 comment "Supported nGene Adapters"
 	depends on DVB_CORE && PCI && I2C
-	source "drivers/media/dvb/ngene/Kconfig"
+	source "drivers/media/pci/ngene/Kconfig"
 
 comment "Supported ddbridge ('Octopus') Adapters"
 	depends on DVB_CORE && PCI && I2C
-	source "drivers/media/dvb/ddbridge/Kconfig"
+	source "drivers/media/pci/ddbridge/Kconfig"
 
 endif # DVB_CAPTURE_DRIVERS
diff --git a/drivers/media/dvb/Makefile b/drivers/media/pci/Makefile
similarity index 100%
rename from drivers/media/dvb/Makefile
rename to drivers/media/pci/Makefile
diff --git a/drivers/media/dvb/b2c2/Kconfig b/drivers/media/pci/b2c2/Kconfig
similarity index 100%
rename from drivers/media/dvb/b2c2/Kconfig
rename to drivers/media/pci/b2c2/Kconfig
diff --git a/drivers/media/dvb/b2c2/Makefile b/drivers/media/pci/b2c2/Makefile
similarity index 100%
rename from drivers/media/dvb/b2c2/Makefile
rename to drivers/media/pci/b2c2/Makefile
diff --git a/drivers/media/dvb/b2c2/flexcop-common.h b/drivers/media/pci/b2c2/flexcop-common.h
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-common.h
rename to drivers/media/pci/b2c2/flexcop-common.h
diff --git a/drivers/media/dvb/b2c2/flexcop-dma.c b/drivers/media/pci/b2c2/flexcop-dma.c
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-dma.c
rename to drivers/media/pci/b2c2/flexcop-dma.c
diff --git a/drivers/media/dvb/b2c2/flexcop-eeprom.c b/drivers/media/pci/b2c2/flexcop-eeprom.c
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-eeprom.c
rename to drivers/media/pci/b2c2/flexcop-eeprom.c
diff --git a/drivers/media/dvb/b2c2/flexcop-fe-tuner.c b/drivers/media/pci/b2c2/flexcop-fe-tuner.c
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-fe-tuner.c
rename to drivers/media/pci/b2c2/flexcop-fe-tuner.c
diff --git a/drivers/media/dvb/b2c2/flexcop-hw-filter.c b/drivers/media/pci/b2c2/flexcop-hw-filter.c
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-hw-filter.c
rename to drivers/media/pci/b2c2/flexcop-hw-filter.c
diff --git a/drivers/media/dvb/b2c2/flexcop-i2c.c b/drivers/media/pci/b2c2/flexcop-i2c.c
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-i2c.c
rename to drivers/media/pci/b2c2/flexcop-i2c.c
diff --git a/drivers/media/dvb/b2c2/flexcop-misc.c b/drivers/media/pci/b2c2/flexcop-misc.c
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-misc.c
rename to drivers/media/pci/b2c2/flexcop-misc.c
diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/pci/b2c2/flexcop-pci.c
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-pci.c
rename to drivers/media/pci/b2c2/flexcop-pci.c
diff --git a/drivers/media/dvb/b2c2/flexcop-reg.h b/drivers/media/pci/b2c2/flexcop-reg.h
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-reg.h
rename to drivers/media/pci/b2c2/flexcop-reg.h
diff --git a/drivers/media/dvb/b2c2/flexcop-sram.c b/drivers/media/pci/b2c2/flexcop-sram.c
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-sram.c
rename to drivers/media/pci/b2c2/flexcop-sram.c
diff --git a/drivers/media/dvb/b2c2/flexcop-usb.c b/drivers/media/pci/b2c2/flexcop-usb.c
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-usb.c
rename to drivers/media/pci/b2c2/flexcop-usb.c
diff --git a/drivers/media/dvb/b2c2/flexcop-usb.h b/drivers/media/pci/b2c2/flexcop-usb.h
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop-usb.h
rename to drivers/media/pci/b2c2/flexcop-usb.h
diff --git a/drivers/media/dvb/b2c2/flexcop.c b/drivers/media/pci/b2c2/flexcop.c
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop.c
rename to drivers/media/pci/b2c2/flexcop.c
diff --git a/drivers/media/dvb/b2c2/flexcop.h b/drivers/media/pci/b2c2/flexcop.h
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop.h
rename to drivers/media/pci/b2c2/flexcop.h
diff --git a/drivers/media/dvb/b2c2/flexcop_ibi_value_be.h b/drivers/media/pci/b2c2/flexcop_ibi_value_be.h
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop_ibi_value_be.h
rename to drivers/media/pci/b2c2/flexcop_ibi_value_be.h
diff --git a/drivers/media/dvb/b2c2/flexcop_ibi_value_le.h b/drivers/media/pci/b2c2/flexcop_ibi_value_le.h
similarity index 100%
rename from drivers/media/dvb/b2c2/flexcop_ibi_value_le.h
rename to drivers/media/pci/b2c2/flexcop_ibi_value_le.h
diff --git a/drivers/media/dvb/bt8xx/Kconfig b/drivers/media/pci/bt8xx/Kconfig
similarity index 100%
rename from drivers/media/dvb/bt8xx/Kconfig
rename to drivers/media/pci/bt8xx/Kconfig
diff --git a/drivers/media/dvb/bt8xx/Makefile b/drivers/media/pci/bt8xx/Makefile
similarity index 100%
rename from drivers/media/dvb/bt8xx/Makefile
rename to drivers/media/pci/bt8xx/Makefile
diff --git a/drivers/media/dvb/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
similarity index 100%
rename from drivers/media/dvb/bt8xx/bt878.c
rename to drivers/media/pci/bt8xx/bt878.c
diff --git a/drivers/media/dvb/bt8xx/bt878.h b/drivers/media/pci/bt8xx/bt878.h
similarity index 100%
rename from drivers/media/dvb/bt8xx/bt878.h
rename to drivers/media/pci/bt8xx/bt878.h
diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
similarity index 100%
rename from drivers/media/dvb/bt8xx/dst.c
rename to drivers/media/pci/bt8xx/dst.c
diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
similarity index 100%
rename from drivers/media/dvb/bt8xx/dst_ca.c
rename to drivers/media/pci/bt8xx/dst_ca.c
diff --git a/drivers/media/dvb/bt8xx/dst_ca.h b/drivers/media/pci/bt8xx/dst_ca.h
similarity index 100%
rename from drivers/media/dvb/bt8xx/dst_ca.h
rename to drivers/media/pci/bt8xx/dst_ca.h
diff --git a/drivers/media/dvb/bt8xx/dst_common.h b/drivers/media/pci/bt8xx/dst_common.h
similarity index 100%
rename from drivers/media/dvb/bt8xx/dst_common.h
rename to drivers/media/pci/bt8xx/dst_common.h
diff --git a/drivers/media/dvb/bt8xx/dst_priv.h b/drivers/media/pci/bt8xx/dst_priv.h
similarity index 100%
rename from drivers/media/dvb/bt8xx/dst_priv.h
rename to drivers/media/pci/bt8xx/dst_priv.h
diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
similarity index 100%
rename from drivers/media/dvb/bt8xx/dvb-bt8xx.c
rename to drivers/media/pci/bt8xx/dvb-bt8xx.c
diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.h b/drivers/media/pci/bt8xx/dvb-bt8xx.h
similarity index 100%
rename from drivers/media/dvb/bt8xx/dvb-bt8xx.h
rename to drivers/media/pci/bt8xx/dvb-bt8xx.h
diff --git a/drivers/media/dvb/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
similarity index 100%
rename from drivers/media/dvb/ddbridge/Kconfig
rename to drivers/media/pci/ddbridge/Kconfig
diff --git a/drivers/media/dvb/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
similarity index 100%
rename from drivers/media/dvb/ddbridge/Makefile
rename to drivers/media/pci/ddbridge/Makefile
diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
similarity index 100%
rename from drivers/media/dvb/ddbridge/ddbridge-core.c
rename to drivers/media/pci/ddbridge/ddbridge-core.c
diff --git a/drivers/media/dvb/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
similarity index 100%
rename from drivers/media/dvb/ddbridge/ddbridge-regs.h
rename to drivers/media/pci/ddbridge/ddbridge-regs.h
diff --git a/drivers/media/dvb/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
similarity index 100%
rename from drivers/media/dvb/ddbridge/ddbridge.h
rename to drivers/media/pci/ddbridge/ddbridge.h
diff --git a/drivers/media/dvb/dm1105/Kconfig b/drivers/media/pci/dm1105/Kconfig
similarity index 100%
rename from drivers/media/dvb/dm1105/Kconfig
rename to drivers/media/pci/dm1105/Kconfig
diff --git a/drivers/media/dvb/dm1105/Makefile b/drivers/media/pci/dm1105/Makefile
similarity index 100%
rename from drivers/media/dvb/dm1105/Makefile
rename to drivers/media/pci/dm1105/Makefile
diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
similarity index 100%
rename from drivers/media/dvb/dm1105/dm1105.c
rename to drivers/media/pci/dm1105/dm1105.c
diff --git a/drivers/media/dvb/mantis/Kconfig b/drivers/media/pci/mantis/Kconfig
similarity index 100%
rename from drivers/media/dvb/mantis/Kconfig
rename to drivers/media/pci/mantis/Kconfig
diff --git a/drivers/media/dvb/mantis/Makefile b/drivers/media/pci/mantis/Makefile
similarity index 100%
rename from drivers/media/dvb/mantis/Makefile
rename to drivers/media/pci/mantis/Makefile
diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/pci/mantis/hopper_cards.c
similarity index 100%
rename from drivers/media/dvb/mantis/hopper_cards.c
rename to drivers/media/pci/mantis/hopper_cards.c
diff --git a/drivers/media/dvb/mantis/hopper_vp3028.c b/drivers/media/pci/mantis/hopper_vp3028.c
similarity index 100%
rename from drivers/media/dvb/mantis/hopper_vp3028.c
rename to drivers/media/pci/mantis/hopper_vp3028.c
diff --git a/drivers/media/dvb/mantis/hopper_vp3028.h b/drivers/media/pci/mantis/hopper_vp3028.h
similarity index 100%
rename from drivers/media/dvb/mantis/hopper_vp3028.h
rename to drivers/media/pci/mantis/hopper_vp3028.h
diff --git a/drivers/media/dvb/mantis/mantis_ca.c b/drivers/media/pci/mantis/mantis_ca.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_ca.c
rename to drivers/media/pci/mantis/mantis_ca.c
diff --git a/drivers/media/dvb/mantis/mantis_ca.h b/drivers/media/pci/mantis/mantis_ca.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_ca.h
rename to drivers/media/pci/mantis/mantis_ca.h
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_cards.c
rename to drivers/media/pci/mantis/mantis_cards.c
diff --git a/drivers/media/dvb/mantis/mantis_common.h b/drivers/media/pci/mantis/mantis_common.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_common.h
rename to drivers/media/pci/mantis/mantis_common.h
diff --git a/drivers/media/dvb/mantis/mantis_core.c b/drivers/media/pci/mantis/mantis_core.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_core.c
rename to drivers/media/pci/mantis/mantis_core.c
diff --git a/drivers/media/dvb/mantis/mantis_core.h b/drivers/media/pci/mantis/mantis_core.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_core.h
rename to drivers/media/pci/mantis/mantis_core.h
diff --git a/drivers/media/dvb/mantis/mantis_dma.c b/drivers/media/pci/mantis/mantis_dma.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_dma.c
rename to drivers/media/pci/mantis/mantis_dma.c
diff --git a/drivers/media/dvb/mantis/mantis_dma.h b/drivers/media/pci/mantis/mantis_dma.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_dma.h
rename to drivers/media/pci/mantis/mantis_dma.h
diff --git a/drivers/media/dvb/mantis/mantis_dvb.c b/drivers/media/pci/mantis/mantis_dvb.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_dvb.c
rename to drivers/media/pci/mantis/mantis_dvb.c
diff --git a/drivers/media/dvb/mantis/mantis_dvb.h b/drivers/media/pci/mantis/mantis_dvb.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_dvb.h
rename to drivers/media/pci/mantis/mantis_dvb.h
diff --git a/drivers/media/dvb/mantis/mantis_evm.c b/drivers/media/pci/mantis/mantis_evm.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_evm.c
rename to drivers/media/pci/mantis/mantis_evm.c
diff --git a/drivers/media/dvb/mantis/mantis_hif.c b/drivers/media/pci/mantis/mantis_hif.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_hif.c
rename to drivers/media/pci/mantis/mantis_hif.c
diff --git a/drivers/media/dvb/mantis/mantis_hif.h b/drivers/media/pci/mantis/mantis_hif.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_hif.h
rename to drivers/media/pci/mantis/mantis_hif.h
diff --git a/drivers/media/dvb/mantis/mantis_i2c.c b/drivers/media/pci/mantis/mantis_i2c.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_i2c.c
rename to drivers/media/pci/mantis/mantis_i2c.c
diff --git a/drivers/media/dvb/mantis/mantis_i2c.h b/drivers/media/pci/mantis/mantis_i2c.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_i2c.h
rename to drivers/media/pci/mantis/mantis_i2c.h
diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/pci/mantis/mantis_input.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_input.c
rename to drivers/media/pci/mantis/mantis_input.c
diff --git a/drivers/media/dvb/mantis/mantis_ioc.c b/drivers/media/pci/mantis/mantis_ioc.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_ioc.c
rename to drivers/media/pci/mantis/mantis_ioc.c
diff --git a/drivers/media/dvb/mantis/mantis_ioc.h b/drivers/media/pci/mantis/mantis_ioc.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_ioc.h
rename to drivers/media/pci/mantis/mantis_ioc.h
diff --git a/drivers/media/dvb/mantis/mantis_link.h b/drivers/media/pci/mantis/mantis_link.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_link.h
rename to drivers/media/pci/mantis/mantis_link.h
diff --git a/drivers/media/dvb/mantis/mantis_pci.c b/drivers/media/pci/mantis/mantis_pci.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_pci.c
rename to drivers/media/pci/mantis/mantis_pci.c
diff --git a/drivers/media/dvb/mantis/mantis_pci.h b/drivers/media/pci/mantis/mantis_pci.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_pci.h
rename to drivers/media/pci/mantis/mantis_pci.h
diff --git a/drivers/media/dvb/mantis/mantis_pcmcia.c b/drivers/media/pci/mantis/mantis_pcmcia.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_pcmcia.c
rename to drivers/media/pci/mantis/mantis_pcmcia.c
diff --git a/drivers/media/dvb/mantis/mantis_reg.h b/drivers/media/pci/mantis/mantis_reg.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_reg.h
rename to drivers/media/pci/mantis/mantis_reg.h
diff --git a/drivers/media/dvb/mantis/mantis_uart.c b/drivers/media/pci/mantis/mantis_uart.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_uart.c
rename to drivers/media/pci/mantis/mantis_uart.c
diff --git a/drivers/media/dvb/mantis/mantis_uart.h b/drivers/media/pci/mantis/mantis_uart.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_uart.h
rename to drivers/media/pci/mantis/mantis_uart.h
diff --git a/drivers/media/dvb/mantis/mantis_vp1033.c b/drivers/media/pci/mantis/mantis_vp1033.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp1033.c
rename to drivers/media/pci/mantis/mantis_vp1033.c
diff --git a/drivers/media/dvb/mantis/mantis_vp1033.h b/drivers/media/pci/mantis/mantis_vp1033.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp1033.h
rename to drivers/media/pci/mantis/mantis_vp1033.h
diff --git a/drivers/media/dvb/mantis/mantis_vp1034.c b/drivers/media/pci/mantis/mantis_vp1034.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp1034.c
rename to drivers/media/pci/mantis/mantis_vp1034.c
diff --git a/drivers/media/dvb/mantis/mantis_vp1034.h b/drivers/media/pci/mantis/mantis_vp1034.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp1034.h
rename to drivers/media/pci/mantis/mantis_vp1034.h
diff --git a/drivers/media/dvb/mantis/mantis_vp1041.c b/drivers/media/pci/mantis/mantis_vp1041.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp1041.c
rename to drivers/media/pci/mantis/mantis_vp1041.c
diff --git a/drivers/media/dvb/mantis/mantis_vp1041.h b/drivers/media/pci/mantis/mantis_vp1041.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp1041.h
rename to drivers/media/pci/mantis/mantis_vp1041.h
diff --git a/drivers/media/dvb/mantis/mantis_vp2033.c b/drivers/media/pci/mantis/mantis_vp2033.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp2033.c
rename to drivers/media/pci/mantis/mantis_vp2033.c
diff --git a/drivers/media/dvb/mantis/mantis_vp2033.h b/drivers/media/pci/mantis/mantis_vp2033.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp2033.h
rename to drivers/media/pci/mantis/mantis_vp2033.h
diff --git a/drivers/media/dvb/mantis/mantis_vp2040.c b/drivers/media/pci/mantis/mantis_vp2040.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp2040.c
rename to drivers/media/pci/mantis/mantis_vp2040.c
diff --git a/drivers/media/dvb/mantis/mantis_vp2040.h b/drivers/media/pci/mantis/mantis_vp2040.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp2040.h
rename to drivers/media/pci/mantis/mantis_vp2040.h
diff --git a/drivers/media/dvb/mantis/mantis_vp3028.c b/drivers/media/pci/mantis/mantis_vp3028.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp3028.c
rename to drivers/media/pci/mantis/mantis_vp3028.c
diff --git a/drivers/media/dvb/mantis/mantis_vp3028.h b/drivers/media/pci/mantis/mantis_vp3028.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp3028.h
rename to drivers/media/pci/mantis/mantis_vp3028.h
diff --git a/drivers/media/dvb/mantis/mantis_vp3030.c b/drivers/media/pci/mantis/mantis_vp3030.c
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp3030.c
rename to drivers/media/pci/mantis/mantis_vp3030.c
diff --git a/drivers/media/dvb/mantis/mantis_vp3030.h b/drivers/media/pci/mantis/mantis_vp3030.h
similarity index 100%
rename from drivers/media/dvb/mantis/mantis_vp3030.h
rename to drivers/media/pci/mantis/mantis_vp3030.h
diff --git a/drivers/media/dvb/ngene/Kconfig b/drivers/media/pci/ngene/Kconfig
similarity index 100%
rename from drivers/media/dvb/ngene/Kconfig
rename to drivers/media/pci/ngene/Kconfig
diff --git a/drivers/media/dvb/ngene/Makefile b/drivers/media/pci/ngene/Makefile
similarity index 100%
rename from drivers/media/dvb/ngene/Makefile
rename to drivers/media/pci/ngene/Makefile
diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
similarity index 100%
rename from drivers/media/dvb/ngene/ngene-cards.c
rename to drivers/media/pci/ngene/ngene-cards.c
diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
similarity index 100%
rename from drivers/media/dvb/ngene/ngene-core.c
rename to drivers/media/pci/ngene/ngene-core.c
diff --git a/drivers/media/dvb/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
similarity index 100%
rename from drivers/media/dvb/ngene/ngene-dvb.c
rename to drivers/media/pci/ngene/ngene-dvb.c
diff --git a/drivers/media/dvb/ngene/ngene-i2c.c b/drivers/media/pci/ngene/ngene-i2c.c
similarity index 100%
rename from drivers/media/dvb/ngene/ngene-i2c.c
rename to drivers/media/pci/ngene/ngene-i2c.c
diff --git a/drivers/media/dvb/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
similarity index 100%
rename from drivers/media/dvb/ngene/ngene.h
rename to drivers/media/pci/ngene/ngene.h
diff --git a/drivers/media/dvb/pluto2/Kconfig b/drivers/media/pci/pluto2/Kconfig
similarity index 100%
rename from drivers/media/dvb/pluto2/Kconfig
rename to drivers/media/pci/pluto2/Kconfig
diff --git a/drivers/media/dvb/pluto2/Makefile b/drivers/media/pci/pluto2/Makefile
similarity index 100%
rename from drivers/media/dvb/pluto2/Makefile
rename to drivers/media/pci/pluto2/Makefile
diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
similarity index 100%
rename from drivers/media/dvb/pluto2/pluto2.c
rename to drivers/media/pci/pluto2/pluto2.c
diff --git a/drivers/media/dvb/pt1/Kconfig b/drivers/media/pci/pt1/Kconfig
similarity index 100%
rename from drivers/media/dvb/pt1/Kconfig
rename to drivers/media/pci/pt1/Kconfig
diff --git a/drivers/media/dvb/pt1/Makefile b/drivers/media/pci/pt1/Makefile
similarity index 100%
rename from drivers/media/dvb/pt1/Makefile
rename to drivers/media/pci/pt1/Makefile
diff --git a/drivers/media/dvb/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
similarity index 100%
rename from drivers/media/dvb/pt1/pt1.c
rename to drivers/media/pci/pt1/pt1.c
diff --git a/drivers/media/dvb/pt1/va1j5jf8007s.c b/drivers/media/pci/pt1/va1j5jf8007s.c
similarity index 100%
rename from drivers/media/dvb/pt1/va1j5jf8007s.c
rename to drivers/media/pci/pt1/va1j5jf8007s.c
diff --git a/drivers/media/dvb/pt1/va1j5jf8007s.h b/drivers/media/pci/pt1/va1j5jf8007s.h
similarity index 100%
rename from drivers/media/dvb/pt1/va1j5jf8007s.h
rename to drivers/media/pci/pt1/va1j5jf8007s.h
diff --git a/drivers/media/dvb/pt1/va1j5jf8007t.c b/drivers/media/pci/pt1/va1j5jf8007t.c
similarity index 100%
rename from drivers/media/dvb/pt1/va1j5jf8007t.c
rename to drivers/media/pci/pt1/va1j5jf8007t.c
diff --git a/drivers/media/dvb/pt1/va1j5jf8007t.h b/drivers/media/pci/pt1/va1j5jf8007t.h
similarity index 100%
rename from drivers/media/dvb/pt1/va1j5jf8007t.h
rename to drivers/media/pci/pt1/va1j5jf8007t.h
diff --git a/drivers/media/dvb/ttpci/Kconfig b/drivers/media/pci/ttpci/Kconfig
similarity index 100%
rename from drivers/media/dvb/ttpci/Kconfig
rename to drivers/media/pci/ttpci/Kconfig
diff --git a/drivers/media/dvb/ttpci/Makefile b/drivers/media/pci/ttpci/Makefile
similarity index 100%
rename from drivers/media/dvb/ttpci/Makefile
rename to drivers/media/pci/ttpci/Makefile
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110.c
rename to drivers/media/pci/ttpci/av7110.c
diff --git a/drivers/media/dvb/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110.h
rename to drivers/media/pci/ttpci/av7110.h
diff --git a/drivers/media/dvb/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110_av.c
rename to drivers/media/pci/ttpci/av7110_av.c
diff --git a/drivers/media/dvb/ttpci/av7110_av.h b/drivers/media/pci/ttpci/av7110_av.h
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110_av.h
rename to drivers/media/pci/ttpci/av7110_av.h
diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/pci/ttpci/av7110_ca.c
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110_ca.c
rename to drivers/media/pci/ttpci/av7110_ca.c
diff --git a/drivers/media/dvb/ttpci/av7110_ca.h b/drivers/media/pci/ttpci/av7110_ca.h
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110_ca.h
rename to drivers/media/pci/ttpci/av7110_ca.h
diff --git a/drivers/media/dvb/ttpci/av7110_hw.c b/drivers/media/pci/ttpci/av7110_hw.c
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110_hw.c
rename to drivers/media/pci/ttpci/av7110_hw.c
diff --git a/drivers/media/dvb/ttpci/av7110_hw.h b/drivers/media/pci/ttpci/av7110_hw.h
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110_hw.h
rename to drivers/media/pci/ttpci/av7110_hw.h
diff --git a/drivers/media/dvb/ttpci/av7110_ipack.c b/drivers/media/pci/ttpci/av7110_ipack.c
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110_ipack.c
rename to drivers/media/pci/ttpci/av7110_ipack.c
diff --git a/drivers/media/dvb/ttpci/av7110_ipack.h b/drivers/media/pci/ttpci/av7110_ipack.h
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110_ipack.h
rename to drivers/media/pci/ttpci/av7110_ipack.h
diff --git a/drivers/media/dvb/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110_ir.c
rename to drivers/media/pci/ttpci/av7110_ir.c
diff --git a/drivers/media/dvb/ttpci/av7110_v4l.c b/drivers/media/pci/ttpci/av7110_v4l.c
similarity index 100%
rename from drivers/media/dvb/ttpci/av7110_v4l.c
rename to drivers/media/pci/ttpci/av7110_v4l.c
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
similarity index 100%
rename from drivers/media/dvb/ttpci/budget-av.c
rename to drivers/media/pci/ttpci/budget-av.c
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
similarity index 100%
rename from drivers/media/dvb/ttpci/budget-ci.c
rename to drivers/media/pci/ttpci/budget-ci.c
diff --git a/drivers/media/dvb/ttpci/budget-core.c b/drivers/media/pci/ttpci/budget-core.c
similarity index 100%
rename from drivers/media/dvb/ttpci/budget-core.c
rename to drivers/media/pci/ttpci/budget-core.c
diff --git a/drivers/media/dvb/ttpci/budget-patch.c b/drivers/media/pci/ttpci/budget-patch.c
similarity index 100%
rename from drivers/media/dvb/ttpci/budget-patch.c
rename to drivers/media/pci/ttpci/budget-patch.c
diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/pci/ttpci/budget.c
similarity index 100%
rename from drivers/media/dvb/ttpci/budget.c
rename to drivers/media/pci/ttpci/budget.c
diff --git a/drivers/media/dvb/ttpci/budget.h b/drivers/media/pci/ttpci/budget.h
similarity index 100%
rename from drivers/media/dvb/ttpci/budget.h
rename to drivers/media/pci/ttpci/budget.h
diff --git a/drivers/media/dvb/ttpci/ttpci-eeprom.c b/drivers/media/pci/ttpci/ttpci-eeprom.c
similarity index 100%
rename from drivers/media/dvb/ttpci/ttpci-eeprom.c
rename to drivers/media/pci/ttpci/ttpci-eeprom.c
diff --git a/drivers/media/dvb/ttpci/ttpci-eeprom.h b/drivers/media/pci/ttpci/ttpci-eeprom.h
similarity index 100%
rename from drivers/media/dvb/ttpci/ttpci-eeprom.h
rename to drivers/media/pci/ttpci/ttpci-eeprom.h
diff --git a/drivers/media/usb/dvb-usb/Makefile b/drivers/media/usb/dvb-usb/Makefile
index 23de51d..1dafb8d 100644
--- a/drivers/media/usb/dvb-usb/Makefile
+++ b/drivers/media/usb/dvb-usb/Makefile
@@ -117,5 +117,5 @@ ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends/
 # due to tuner-xc3028
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
-ccflags-y += -I$(srctree)/drivers/media/dvb/ttpci
+ccflags-y += -I$(srctree)/drivers/media/pci/ttpci
 
-- 
1.7.10.2

