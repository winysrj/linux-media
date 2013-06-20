Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030361Ab3FTOLd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 10:11:33 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5KEBXqP016272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 10:11:33 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] Fix build when drivers are builtin and frontend modules
Date: Thu, 20 Jun 2013 11:11:28 -0300
Message-Id: <1371737488-14395-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1371737488-14395-1-git-send-email-mchehab@redhat.com>
References: <1371737488-14395-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a large number of reports that the media build is
not compiling when some drivers are compiled as builtin, while
the needed frontends are compiled as module.

On the last one of such reports:
	From: kbuild test robot <fengguang.wu@intel.com>
	Subject: saa7134-dvb.c:undefined reference to `zl10039_attach'

The .config file has:

	CONFIG_VIDEO_SAA7134=y
	CONFIG_VIDEO_SAA7134_DVB=y
	# CONFIG_MEDIA_ATTACH is not set
	CONFIG_DVB_ZL10039=m

And it produces all those errors:

   drivers/built-in.o: In function `set_type':
   tuner-core.c:(.text+0x2f263e): undefined reference to `tea5767_attach'
   tuner-core.c:(.text+0x2f273e): undefined reference to `tda9887_attach'
   drivers/built-in.o: In function `tuner_probe':
   tuner-core.c:(.text+0x2f2d20): undefined reference to `tea5767_autodetection'
   drivers/built-in.o: In function `av7110_attach':
   av7110.c:(.text+0x330bda): undefined reference to `ves1x93_attach'
   av7110.c:(.text+0x330bf7): undefined reference to `stv0299_attach'
   av7110.c:(.text+0x330c63): undefined reference to `tda8083_attach'
   av7110.c:(.text+0x330d09): undefined reference to `ves1x93_attach'
   av7110.c:(.text+0x330d33): undefined reference to `tda8083_attach'
   av7110.c:(.text+0x330d5d): undefined reference to `stv0297_attach'
   av7110.c:(.text+0x330dbe): undefined reference to `stv0299_attach'
   drivers/built-in.o: In function `tuner_attach_dtt7520x':
   ngene-cards.c:(.text+0x3381cb): undefined reference to `dvb_pll_attach'
   drivers/built-in.o: In function `demod_attach_lg330x':
   ngene-cards.c:(.text+0x33828a): undefined reference to `lgdt330x_attach'
   drivers/built-in.o: In function `demod_attach_stv0900':
   ngene-cards.c:(.text+0x3383d5): undefined reference to `stv090x_attach'
   drivers/built-in.o: In function `cineS2_probe':
   ngene-cards.c:(.text+0x338b7f): undefined reference to `drxk_attach'
   drivers/built-in.o: In function `configure_tda827x_fe':
   saa7134-dvb.c:(.text+0x346ae7): undefined reference to `tda10046_attach'
   drivers/built-in.o: In function `dvb_init':
   saa7134-dvb.c:(.text+0x347283): undefined reference to `mt352_attach'
   saa7134-dvb.c:(.text+0x3472cd): undefined reference to `mt352_attach'
   saa7134-dvb.c:(.text+0x34731c): undefined reference to `tda10046_attach'
   saa7134-dvb.c:(.text+0x34733c): undefined reference to `tda10046_attach'
   saa7134-dvb.c:(.text+0x34735c): undefined reference to `tda10046_attach'
   saa7134-dvb.c:(.text+0x347378): undefined reference to `tda10046_attach'
   saa7134-dvb.c:(.text+0x3473db): undefined reference to `tda10046_attach'
   drivers/built-in.o:saa7134-dvb.c:(.text+0x347502): more undefined references to `tda10046_attach' follow
   drivers/built-in.o: In function `dvb_init':
   saa7134-dvb.c:(.text+0x347812): undefined reference to `mt352_attach'
   saa7134-dvb.c:(.text+0x347951): undefined reference to `mt312_attach'
   saa7134-dvb.c:(.text+0x3479a9): undefined reference to `mt312_attach'
>> saa7134-dvb.c:(.text+0x3479c1): undefined reference to `zl10039_attach'

This is happening because a builtin module can't use directly a symbol
found on a module. By enabling CONFIG_MEDIA_ATTACH, the configuration
becomes valid, as dvb_attach() macro loads the module if needed, making
the symbol available to the builtin module.

While this bug started to appear after the patches that use IS_DEFINED
macro (like changeset 7b34be71db533f3e0cf93d53cf62d036cdb5418a), this
bug is a way ancient than that.

The thing is that, before the IS_DEFINED() patches, the logic used to be:

       && defined(MODULE))
struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
					u8 i2c_addr,
					struct i2c_adapter *i2c);
static inline struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
					u8 i2c_addr,
					struct i2c_adapter *i2c)
{
	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
	return NULL;
}

The above code, with the .config file used, was evoluting to FALSE
(instead of TRUE as it should be, as CONFIG_DVB_ZL10039 is 'm'),
and were adding the static inline code at saa7134-dvb, instead
of the external call. So, while it weren't producing any compilation
error, the code weren't working either.

So, as the overhead for using CONFIG_MEDIA_ATTACH is minimal, just
enable it, if MODULES is defined.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig        | 12 +++++++++---
 drivers/media/tuners/Kconfig | 20 --------------------
 2 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 7f5a7ca..8270388 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -136,9 +136,9 @@ config DVB_NET
 
 # This Kconfig option is used by both PCI and USB drivers
 config TTPCI_EEPROM
-        tristate
-        depends on I2C
-        default n
+	tristate
+	depends on I2C
+	default n
 
 source "drivers/media/dvb-core/Kconfig"
 
@@ -189,6 +189,12 @@ config MEDIA_SUBDRV_AUTOSELECT
 
 	  If unsure say Y.
 
+config MEDIA_ATTACH
+	bool
+	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT
+	depends on MODULES
+	default MODULES
+
 source "drivers/media/i2c/Kconfig"
 source "drivers/media/tuners/Kconfig"
 source "drivers/media/dvb-frontends/Kconfig"
diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index f6768ca..15665de 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -1,23 +1,3 @@
-config MEDIA_ATTACH
-	bool "Load and attach frontend and tuner driver modules as needed"
-	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT
-	depends on MODULES
-	default y if !EXPERT
-	help
-	  Remove the static dependency of DVB card drivers on all
-	  frontend modules for all possible card variants. Instead,
-	  allow the card drivers to only load the frontend modules
-	  they require.
-
-	  Also, tuner module will automatically load a tuner driver
-	  when needed, for analog mode.
-
-	  This saves several KBytes of memory.
-
-	  Note: You will need module-init-tools v3.2 or later for this feature.
-
-	  If unsure say Y.
-
 # Analog TV tuners, auto-loaded via tuner.ko
 config MEDIA_TUNER
 	tristate
-- 
1.8.1.4

