Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab0KJDNZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 22:13:25 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAA3DPct004016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 22:13:25 -0500
Received: from pedra (vpn-229-171.phx2.redhat.com [10.3.229.171])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oAA3DKlW031781
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 22:13:22 -0500
Date: Wed, 10 Nov 2010 01:13:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] [media] rename drivers/media/IR to drives/media/rc
Message-ID: <20101110011308.1b184c47@pedra>
In-Reply-To: <cover.1289358255.git.mchehab@redhat.com>
References: <cover.1289358255.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 rename drivers/media/{IR => rc}/Kconfig (99%)
 rename drivers/media/{IR => rc}/Makefile (100%)
 rename drivers/media/{IR => rc}/ene_ir.c (100%)
 rename drivers/media/{IR => rc}/ene_ir.h (100%)
 rename drivers/media/{IR => rc}/imon.c (100%)
 rename drivers/media/{IR => rc}/ir-core-priv.h (100%)
 rename drivers/media/{IR => rc}/ir-functions.c (100%)
 rename drivers/media/{IR => rc}/ir-jvc-decoder.c (100%)
 rename drivers/media/{IR => rc}/ir-keytable.c (100%)
 rename drivers/media/{IR => rc}/ir-lirc-codec.c (100%)
 rename drivers/media/{IR => rc}/ir-nec-decoder.c (100%)
 rename drivers/media/{IR => rc}/ir-raw-event.c (100%)
 rename drivers/media/{IR => rc}/ir-rc5-decoder.c (100%)
 rename drivers/media/{IR => rc}/ir-rc5-sz-decoder.c (100%)
 rename drivers/media/{IR => rc}/ir-rc6-decoder.c (100%)
 rename drivers/media/{IR => rc}/ir-sony-decoder.c (100%)
 rename drivers/media/{IR => rc}/ir-sysfs.c (100%)
 rename drivers/media/{IR => rc}/keymaps/Kconfig (100%)
 rename drivers/media/{IR => rc}/keymaps/Makefile (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-adstech-dvb-t-pci.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-alink-dtu-m.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-anysee.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-apac-viewcomp.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-asus-pc39.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-ati-tv-wonder-hd-600.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-a16d.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-cardbus.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-dvbt.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-m135a.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-m733a-rm-k6.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-rm-ks.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avertv-303.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-azurewave-ad-tu700.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-behold-columbus.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-behold.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-budget-ci-old.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-cinergy-1400.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-cinergy.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-dib0700-nec.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-dib0700-rc5.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-digitalnow-tinytwin.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-digittrade.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-dm1105-nec.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-dntv-live-dvb-t.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-dntv-live-dvbt-pro.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-em-terratec.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-encore-enltv-fm53.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-encore-enltv.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-encore-enltv2.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-evga-indtube.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-eztv.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-flydvb.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-flyvideo.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-fusionhdtv-mce.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-gadmei-rm008z.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-genius-tvgo-a11mce.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-gotview7135.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-hauppauge-new.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-imon-mce.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-imon-pad.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-iodata-bctv7e.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-kaiomy.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-kworld-315u.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-kworld-plus-tv-analog.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-leadtek-y04g0051.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-lirc.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-lme2510.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-manli.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-digivox-ii.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-digivox-iii.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-tvanywhere-plus.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-tvanywhere.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-nebula.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-nec-terratec-cinergy-xs.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-norwood.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-npgtech.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pctv-sedna.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pinnacle-color.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pinnacle-grey.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pinnacle-pctv-hd.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pixelview-mk12.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pixelview-new.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pixelview.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-powercolor-real-angel.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-proteus-2309.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-purpletv.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pv951.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-rc5-hauppauge-new.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-rc5-tv.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-rc6-mce.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-real-audio-220-32-keys.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-streamzap.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-tbs-nec.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-terratec-cinergy-xs.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-terratec-slim.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-tevii-nec.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-total-media-in-hand.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-trekstor.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-tt-1500.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-twinhan1027.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-videomate-s350.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-videomate-tv-pvr.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-winfast-usbii-deluxe.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-winfast.c (100%)
 rename drivers/media/{IR => rc}/lirc_dev.c (100%)
 rename drivers/media/{IR => rc}/mceusb.c (100%)
 rename drivers/media/{IR => rc}/nuvoton-cir.c (100%)
 rename drivers/media/{IR => rc}/nuvoton-cir.h (100%)
 rename drivers/media/{IR => rc}/rc-map.c (100%)
 rename drivers/media/{IR => rc}/streamzap.c (100%)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index a28541b..c21dfc2 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -99,7 +99,7 @@ config VIDEO_MEDIA
 comment "Multimedia drivers"
 
 source "drivers/media/common/Kconfig"
-source "drivers/media/IR/Kconfig"
+source "drivers/media/rc/Kconfig"
 
 #
 # Tuner drivers for DVB and V4L
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 499b081..b603ea6 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
-obj-y += common/ IR/ video/
+obj-y += common/ rc/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
 obj-$(CONFIG_DVB_CORE)  += dvb/
diff --git a/drivers/media/IR/Kconfig b/drivers/media/rc/Kconfig
similarity index 99%
rename from drivers/media/IR/Kconfig
rename to drivers/media/rc/Kconfig
index 20e02a0..d05003d 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -28,7 +28,7 @@ config LIRC
 	   LIRC daemon handles protocol decoding for IR reception and
 	   encoding for IR transmitting (aka "blasting").
 
-source "drivers/media/IR/keymaps/Kconfig"
+source "drivers/media/rc/keymaps/Kconfig"
 
 config IR_NEC_DECODER
 	tristate "Enable IR raw decoder for the NEC protocol"
diff --git a/drivers/media/IR/Makefile b/drivers/media/rc/Makefile
similarity index 100%
rename from drivers/media/IR/Makefile
rename to drivers/media/rc/Makefile
diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/rc/ene_ir.c
similarity index 100%
rename from drivers/media/IR/ene_ir.c
rename to drivers/media/rc/ene_ir.c
diff --git a/drivers/media/IR/ene_ir.h b/drivers/media/rc/ene_ir.h
similarity index 100%
rename from drivers/media/IR/ene_ir.h
rename to drivers/media/rc/ene_ir.h
diff --git a/drivers/media/IR/imon.c b/drivers/media/rc/imon.c
similarity index 100%
rename from drivers/media/IR/imon.c
rename to drivers/media/rc/imon.c
diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/rc/ir-core-priv.h
similarity index 100%
rename from drivers/media/IR/ir-core-priv.h
rename to drivers/media/rc/ir-core-priv.h
diff --git a/drivers/media/IR/ir-functions.c b/drivers/media/rc/ir-functions.c
similarity index 100%
rename from drivers/media/IR/ir-functions.c
rename to drivers/media/rc/ir-functions.c
diff --git a/drivers/media/IR/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
similarity index 100%
rename from drivers/media/IR/ir-jvc-decoder.c
rename to drivers/media/rc/ir-jvc-decoder.c
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/rc/ir-keytable.c
similarity index 100%
rename from drivers/media/IR/ir-keytable.c
rename to drivers/media/rc/ir-keytable.c
diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
similarity index 100%
rename from drivers/media/IR/ir-lirc-codec.c
rename to drivers/media/rc/ir-lirc-codec.c
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
similarity index 100%
rename from drivers/media/IR/ir-nec-decoder.c
rename to drivers/media/rc/ir-nec-decoder.c
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/rc/ir-raw-event.c
similarity index 100%
rename from drivers/media/IR/ir-raw-event.c
rename to drivers/media/rc/ir-raw-event.c
diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
similarity index 100%
rename from drivers/media/IR/ir-rc5-decoder.c
rename to drivers/media/rc/ir-rc5-decoder.c
diff --git a/drivers/media/IR/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
similarity index 100%
rename from drivers/media/IR/ir-rc5-sz-decoder.c
rename to drivers/media/rc/ir-rc5-sz-decoder.c
diff --git a/drivers/media/IR/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
similarity index 100%
rename from drivers/media/IR/ir-rc6-decoder.c
rename to drivers/media/rc/ir-rc6-decoder.c
diff --git a/drivers/media/IR/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
similarity index 100%
rename from drivers/media/IR/ir-sony-decoder.c
rename to drivers/media/rc/ir-sony-decoder.c
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/rc/ir-sysfs.c
similarity index 100%
rename from drivers/media/IR/ir-sysfs.c
rename to drivers/media/rc/ir-sysfs.c
diff --git a/drivers/media/IR/keymaps/Kconfig b/drivers/media/rc/keymaps/Kconfig
similarity index 100%
rename from drivers/media/IR/keymaps/Kconfig
rename to drivers/media/rc/keymaps/Kconfig
diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
similarity index 100%
rename from drivers/media/IR/keymaps/Makefile
rename to drivers/media/rc/keymaps/Makefile
diff --git a/drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c
rename to drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
diff --git a/drivers/media/IR/keymaps/rc-alink-dtu-m.c b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-alink-dtu-m.c
rename to drivers/media/rc/keymaps/rc-alink-dtu-m.c
diff --git a/drivers/media/IR/keymaps/rc-anysee.c b/drivers/media/rc/keymaps/rc-anysee.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-anysee.c
rename to drivers/media/rc/keymaps/rc-anysee.c
diff --git a/drivers/media/IR/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-apac-viewcomp.c
rename to drivers/media/rc/keymaps/rc-apac-viewcomp.c
diff --git a/drivers/media/IR/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-asus-pc39.c
rename to drivers/media/rc/keymaps/rc-asus-pc39.c
diff --git a/drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c
rename to drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
diff --git a/drivers/media/IR/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-avermedia-a16d.c
rename to drivers/media/rc/keymaps/rc-avermedia-a16d.c
diff --git a/drivers/media/IR/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-avermedia-cardbus.c
rename to drivers/media/rc/keymaps/rc-avermedia-cardbus.c
diff --git a/drivers/media/IR/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-avermedia-dvbt.c
rename to drivers/media/rc/keymaps/rc-avermedia-dvbt.c
diff --git a/drivers/media/IR/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-avermedia-m135a.c
rename to drivers/media/rc/keymaps/rc-avermedia-m135a.c
diff --git a/drivers/media/IR/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-avermedia-m733a-rm-k6.c
rename to drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
diff --git a/drivers/media/IR/keymaps/rc-avermedia-rm-ks.c b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-avermedia-rm-ks.c
rename to drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
diff --git a/drivers/media/IR/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-avermedia.c
rename to drivers/media/rc/keymaps/rc-avermedia.c
diff --git a/drivers/media/IR/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-avertv-303.c
rename to drivers/media/rc/keymaps/rc-avertv-303.c
diff --git a/drivers/media/IR/keymaps/rc-azurewave-ad-tu700.c b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-azurewave-ad-tu700.c
rename to drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
diff --git a/drivers/media/IR/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-behold-columbus.c
rename to drivers/media/rc/keymaps/rc-behold-columbus.c
diff --git a/drivers/media/IR/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-behold.c
rename to drivers/media/rc/keymaps/rc-behold.c
diff --git a/drivers/media/IR/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-budget-ci-old.c
rename to drivers/media/rc/keymaps/rc-budget-ci-old.c
diff --git a/drivers/media/IR/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-cinergy-1400.c
rename to drivers/media/rc/keymaps/rc-cinergy-1400.c
diff --git a/drivers/media/IR/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-cinergy.c
rename to drivers/media/rc/keymaps/rc-cinergy.c
diff --git a/drivers/media/IR/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-dib0700-nec.c
rename to drivers/media/rc/keymaps/rc-dib0700-nec.c
diff --git a/drivers/media/IR/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-dib0700-rc5.c
rename to drivers/media/rc/keymaps/rc-dib0700-rc5.c
diff --git a/drivers/media/IR/keymaps/rc-digitalnow-tinytwin.c b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-digitalnow-tinytwin.c
rename to drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
diff --git a/drivers/media/IR/keymaps/rc-digittrade.c b/drivers/media/rc/keymaps/rc-digittrade.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-digittrade.c
rename to drivers/media/rc/keymaps/rc-digittrade.c
diff --git a/drivers/media/IR/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-dm1105-nec.c
rename to drivers/media/rc/keymaps/rc-dm1105-nec.c
diff --git a/drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c
rename to drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
diff --git a/drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c
rename to drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
diff --git a/drivers/media/IR/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-em-terratec.c
rename to drivers/media/rc/keymaps/rc-em-terratec.c
diff --git a/drivers/media/IR/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-encore-enltv-fm53.c
rename to drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
diff --git a/drivers/media/IR/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-encore-enltv.c
rename to drivers/media/rc/keymaps/rc-encore-enltv.c
diff --git a/drivers/media/IR/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-encore-enltv2.c
rename to drivers/media/rc/keymaps/rc-encore-enltv2.c
diff --git a/drivers/media/IR/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-evga-indtube.c
rename to drivers/media/rc/keymaps/rc-evga-indtube.c
diff --git a/drivers/media/IR/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-eztv.c
rename to drivers/media/rc/keymaps/rc-eztv.c
diff --git a/drivers/media/IR/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-flydvb.c
rename to drivers/media/rc/keymaps/rc-flydvb.c
diff --git a/drivers/media/IR/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-flyvideo.c
rename to drivers/media/rc/keymaps/rc-flyvideo.c
diff --git a/drivers/media/IR/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-fusionhdtv-mce.c
rename to drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
diff --git a/drivers/media/IR/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-gadmei-rm008z.c
rename to drivers/media/rc/keymaps/rc-gadmei-rm008z.c
diff --git a/drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c
rename to drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
diff --git a/drivers/media/IR/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-gotview7135.c
rename to drivers/media/rc/keymaps/rc-gotview7135.c
diff --git a/drivers/media/IR/keymaps/rc-hauppauge-new.c b/drivers/media/rc/keymaps/rc-hauppauge-new.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-hauppauge-new.c
rename to drivers/media/rc/keymaps/rc-hauppauge-new.c
diff --git a/drivers/media/IR/keymaps/rc-imon-mce.c b/drivers/media/rc/keymaps/rc-imon-mce.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-imon-mce.c
rename to drivers/media/rc/keymaps/rc-imon-mce.c
diff --git a/drivers/media/IR/keymaps/rc-imon-pad.c b/drivers/media/rc/keymaps/rc-imon-pad.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-imon-pad.c
rename to drivers/media/rc/keymaps/rc-imon-pad.c
diff --git a/drivers/media/IR/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-iodata-bctv7e.c
rename to drivers/media/rc/keymaps/rc-iodata-bctv7e.c
diff --git a/drivers/media/IR/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-kaiomy.c
rename to drivers/media/rc/keymaps/rc-kaiomy.c
diff --git a/drivers/media/IR/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-kworld-315u.c
rename to drivers/media/rc/keymaps/rc-kworld-315u.c
diff --git a/drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c
rename to drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
diff --git a/drivers/media/IR/keymaps/rc-leadtek-y04g0051.c b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-leadtek-y04g0051.c
rename to drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
diff --git a/drivers/media/IR/keymaps/rc-lirc.c b/drivers/media/rc/keymaps/rc-lirc.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-lirc.c
rename to drivers/media/rc/keymaps/rc-lirc.c
diff --git a/drivers/media/IR/keymaps/rc-lme2510.c b/drivers/media/rc/keymaps/rc-lme2510.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-lme2510.c
rename to drivers/media/rc/keymaps/rc-lme2510.c
diff --git a/drivers/media/IR/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-manli.c
rename to drivers/media/rc/keymaps/rc-manli.c
diff --git a/drivers/media/IR/keymaps/rc-msi-digivox-ii.c b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-msi-digivox-ii.c
rename to drivers/media/rc/keymaps/rc-msi-digivox-ii.c
diff --git a/drivers/media/IR/keymaps/rc-msi-digivox-iii.c b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-msi-digivox-iii.c
rename to drivers/media/rc/keymaps/rc-msi-digivox-iii.c
diff --git a/drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c
rename to drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
diff --git a/drivers/media/IR/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-msi-tvanywhere.c
rename to drivers/media/rc/keymaps/rc-msi-tvanywhere.c
diff --git a/drivers/media/IR/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-nebula.c
rename to drivers/media/rc/keymaps/rc-nebula.c
diff --git a/drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c
rename to drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
diff --git a/drivers/media/IR/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-norwood.c
rename to drivers/media/rc/keymaps/rc-norwood.c
diff --git a/drivers/media/IR/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-npgtech.c
rename to drivers/media/rc/keymaps/rc-npgtech.c
diff --git a/drivers/media/IR/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-pctv-sedna.c
rename to drivers/media/rc/keymaps/rc-pctv-sedna.c
diff --git a/drivers/media/IR/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-pinnacle-color.c
rename to drivers/media/rc/keymaps/rc-pinnacle-color.c
diff --git a/drivers/media/IR/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-pinnacle-grey.c
rename to drivers/media/rc/keymaps/rc-pinnacle-grey.c
diff --git a/drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c
rename to drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
diff --git a/drivers/media/IR/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-pixelview-mk12.c
rename to drivers/media/rc/keymaps/rc-pixelview-mk12.c
diff --git a/drivers/media/IR/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-pixelview-new.c
rename to drivers/media/rc/keymaps/rc-pixelview-new.c
diff --git a/drivers/media/IR/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-pixelview.c
rename to drivers/media/rc/keymaps/rc-pixelview.c
diff --git a/drivers/media/IR/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-powercolor-real-angel.c
rename to drivers/media/rc/keymaps/rc-powercolor-real-angel.c
diff --git a/drivers/media/IR/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-proteus-2309.c
rename to drivers/media/rc/keymaps/rc-proteus-2309.c
diff --git a/drivers/media/IR/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-purpletv.c
rename to drivers/media/rc/keymaps/rc-purpletv.c
diff --git a/drivers/media/IR/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-pv951.c
rename to drivers/media/rc/keymaps/rc-pv951.c
diff --git a/drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c
rename to drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
diff --git a/drivers/media/IR/keymaps/rc-rc5-tv.c b/drivers/media/rc/keymaps/rc-rc5-tv.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-rc5-tv.c
rename to drivers/media/rc/keymaps/rc-rc5-tv.c
diff --git a/drivers/media/IR/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-rc6-mce.c
rename to drivers/media/rc/keymaps/rc-rc6-mce.c
diff --git a/drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c
rename to drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
diff --git a/drivers/media/IR/keymaps/rc-streamzap.c b/drivers/media/rc/keymaps/rc-streamzap.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-streamzap.c
rename to drivers/media/rc/keymaps/rc-streamzap.c
diff --git a/drivers/media/IR/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-tbs-nec.c
rename to drivers/media/rc/keymaps/rc-tbs-nec.c
diff --git a/drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c
rename to drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
diff --git a/drivers/media/IR/keymaps/rc-terratec-slim.c b/drivers/media/rc/keymaps/rc-terratec-slim.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-terratec-slim.c
rename to drivers/media/rc/keymaps/rc-terratec-slim.c
diff --git a/drivers/media/IR/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-tevii-nec.c
rename to drivers/media/rc/keymaps/rc-tevii-nec.c
diff --git a/drivers/media/IR/keymaps/rc-total-media-in-hand.c b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-total-media-in-hand.c
rename to drivers/media/rc/keymaps/rc-total-media-in-hand.c
diff --git a/drivers/media/IR/keymaps/rc-trekstor.c b/drivers/media/rc/keymaps/rc-trekstor.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-trekstor.c
rename to drivers/media/rc/keymaps/rc-trekstor.c
diff --git a/drivers/media/IR/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-tt-1500.c
rename to drivers/media/rc/keymaps/rc-tt-1500.c
diff --git a/drivers/media/IR/keymaps/rc-twinhan1027.c b/drivers/media/rc/keymaps/rc-twinhan1027.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-twinhan1027.c
rename to drivers/media/rc/keymaps/rc-twinhan1027.c
diff --git a/drivers/media/IR/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-videomate-s350.c
rename to drivers/media/rc/keymaps/rc-videomate-s350.c
diff --git a/drivers/media/IR/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-videomate-tv-pvr.c
rename to drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
diff --git a/drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c
rename to drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
diff --git a/drivers/media/IR/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-winfast.c
rename to drivers/media/rc/keymaps/rc-winfast.c
diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/rc/lirc_dev.c
similarity index 100%
rename from drivers/media/IR/lirc_dev.c
rename to drivers/media/rc/lirc_dev.c
diff --git a/drivers/media/IR/mceusb.c b/drivers/media/rc/mceusb.c
similarity index 100%
rename from drivers/media/IR/mceusb.c
rename to drivers/media/rc/mceusb.c
diff --git a/drivers/media/IR/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
similarity index 100%
rename from drivers/media/IR/nuvoton-cir.c
rename to drivers/media/rc/nuvoton-cir.c
diff --git a/drivers/media/IR/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
similarity index 100%
rename from drivers/media/IR/nuvoton-cir.h
rename to drivers/media/rc/nuvoton-cir.h
diff --git a/drivers/media/IR/rc-map.c b/drivers/media/rc/rc-map.c
similarity index 100%
rename from drivers/media/IR/rc-map.c
rename to drivers/media/rc/rc-map.c
diff --git a/drivers/media/IR/streamzap.c b/drivers/media/rc/streamzap.c
similarity index 100%
rename from drivers/media/IR/streamzap.c
rename to drivers/media/rc/streamzap.c
-- 
1.7.1


