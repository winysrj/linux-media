Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47597 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbZKGVtL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:49:11 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:49:12 +0000
Message-ID: <1257630552.15927.404.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 12/75] dvb-usb: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/dvb-usb/a800.c            |    1 +
 drivers/media/dvb/dvb-usb/af9005.c          |    1 +
 drivers/media/dvb/dvb-usb/af9015.c          |    1 +
 drivers/media/dvb/dvb-usb/cxusb.c           |    2 ++
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    1 +
 drivers/media/dvb/dvb-usb/dibusb-mb.c       |    4 ++++
 drivers/media/dvb/dvb-usb/digitv.c          |    1 +
 drivers/media/dvb/dvb-usb/dtt200u.c         |    5 +++++
 drivers/media/dvb/dvb-usb/dw2102.c          |    4 ++++
 drivers/media/dvb/dvb-usb/gp8psk.c          |    1 +
 drivers/media/dvb/dvb-usb/m920x.c           |    4 ++++
 drivers/media/dvb/dvb-usb/nova-t-usb2.c     |    1 +
 drivers/media/dvb/dvb-usb/opera1.c          |    1 +
 drivers/media/dvb/dvb-usb/ttusb2.c          |    2 ++
 drivers/media/dvb/dvb-usb/umt-010.c         |    1 +
 drivers/media/dvb/dvb-usb/vp702x.c          |    1 +
 drivers/media/dvb/dvb-usb/vp7045.c          |    1 +
 17 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/dvb/dvb-usb/a800.c
index 6247239..ae74174 100644
--- a/drivers/media/dvb/dvb-usb/a800.c
+++ b/drivers/media/dvb/dvb-usb/a800.c
@@ -195,3 +195,4 @@ MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_DESCRIPTION("AVerMedia AverTV DVB-T USB 2.0 (A800)");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-avertv-a800-02.fw");
diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb/af9005.c
index ca5a0a4..d26c70b 100644
--- a/drivers/media/dvb/dvb-usb/af9005.c
+++ b/drivers/media/dvb/dvb-usb/af9005.c
@@ -1142,3 +1142,4 @@ MODULE_AUTHOR("Luca Olivetti <luca@ventoso.org>");
 MODULE_DESCRIPTION("Driver for Afatech 9005 DVB-T USB1.1 stick");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("af9005.fw");
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index bad3e10..8463faf 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1687,3 +1687,4 @@ module_exit(af9015_usb_module_exit);
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Driver for Afatech AF9015 DVB-T");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-af9015.fw");
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index bc44d30..556f643 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1864,3 +1864,5 @@ MODULE_DESCRIPTION("Driver for Conexant USB2.0 hybrid reference design");
 MODULE_VERSION("1.0-alpha");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
+MODULE_FIRMWARE("dvb-usb-bluebird-01.fw");
+MODULE_FIRMWARE("dvb-usb-bluebird-02.fw");
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index d003ff0..ee6a60b 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -1951,6 +1951,7 @@ MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
 	.size_of_priv      = sizeof(struct dib0700_state), \
 	.i2c_algo          = &dib0700_i2c_algo, \
 	.identify_state    = dib0700_identify_state
+MODULE_FIRMWARE("dvb-usb-dib0700-1.20.fw");
 
 #define DIB0700_DEFAULT_STREAMING_CONFIG(ep) \
 	.streaming_ctrl   = dib0700_streaming_ctrl, \
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c b/drivers/media/dvb/dvb-usb/dibusb-mb.c
index eeef50b..87f1775 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mb.c
@@ -467,3 +467,7 @@ MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_DESCRIPTION("Driver for DiBcom USB DVB-T devices (DiB3000M-B based)");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-dibusb-5.0.0.11.fw");
+MODULE_FIRMWARE("dvb-usb-dibusb-an2235-01.fw");
+MODULE_FIRMWARE("dvb-usb-adstech-usb2-02.fw");
+MODULE_FIRMWARE("dvb-usb-dibusb-6.0.0.8.fw");
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index 955147d..09e2d44 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -361,3 +361,4 @@ MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_DESCRIPTION("Driver for Nebula Electronics uDigiTV DVB-T USB2.0");
 MODULE_VERSION("1.0-alpha");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-digitv-02.fw");
diff --git a/drivers/media/dvb/dvb-usb/dtt200u.c b/drivers/media/dvb/dvb-usb/dtt200u.c
index a1b12b0..38ecca0 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u.c
@@ -365,3 +365,8 @@ MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_DESCRIPTION("Driver for the WideView/Yakumo/Hama/Typhoon/Club3D/Miglia DVB-T USB2.0 devices");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-dtt200u-01.fw");
+MODULE_FIRMWARE("dvb-usb-wt220u-02.fw");
+MODULE_FIRMWARE("dvb-usb-wt220u-fc03.fw");
+MODULE_FIRMWARE("dvb-usb-wt220u-zl0353-01.fw");
+MODULE_FIRMWARE("dvb-usb-wt220u-miglia-01.fw");
diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index 5bb9479..9c499eb 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -1272,3 +1272,7 @@ MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,"
 				" TeVii S600, S630, S650 USB2.0 devices");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-dw2102.fw");
+MODULE_FIRMWARE("dvb-usb-dw2104.fw");
+MODULE_FIRMWARE("dvb-usb-dw3101.fw");
+MODULE_FIRMWARE("dvb-usb-s630.fw");
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
index afb444d..d823495 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -305,3 +305,4 @@ MODULE_AUTHOR("Alan Nisota <alannisota@gamil.com>");
 MODULE_DESCRIPTION("Driver for Genpix 8psk-to-USB2 DVB-S");
 MODULE_VERSION("1.1");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-gp8psk-01.fw");
diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index ef9b7be..f72559c 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -928,6 +928,10 @@ MODULE_AUTHOR("Aapo Tahkola <aet@rasterburn.org>");
 MODULE_DESCRIPTION("DVB Driver for ULI M920x");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-megasky-02.fw");
+MODULE_FIRMWARE("dvb-usb-digivox-02.fw");
+MODULE_FIRMWARE("dvb-usb-tvwalkert.fw");
+MODULE_FIRMWARE("dvb-usb-dposh-01.fw");
 
 /*
  * Local variables:
diff --git a/drivers/media/dvb/dvb-usb/nova-t-usb2.c b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
index b41d66e..62288f7 100644
--- a/drivers/media/dvb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
@@ -246,3 +246,4 @@ MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_DESCRIPTION("Hauppauge WinTV-NOVA-T usb2");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-nova-t-usb2-02.fw");
diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index d4e2309..8455ac6 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -585,3 +585,4 @@ MODULE_AUTHOR("Marco Gittler (c) g.marco@freenet.de");
 MODULE_DESCRIPTION("Driver for Opera1 DVB-S device");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-opera-01.fw");
diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index 20ca9d9..e092f0f 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -333,3 +333,5 @@ MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_DESCRIPTION("Driver for Pinnacle PCTV 400e DVB-S USB2.0");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-pctv-400e-01.fw");
+MODULE_FIRMWARE("dvb-usb-tt-s2400-01.fw");
diff --git a/drivers/media/dvb/dvb-usb/umt-010.c b/drivers/media/dvb/dvb-usb/umt-010.c
index 118aab1..59437e5 100644
--- a/drivers/media/dvb/dvb-usb/umt-010.c
+++ b/drivers/media/dvb/dvb-usb/umt-010.c
@@ -166,3 +166,4 @@ MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_DESCRIPTION("Driver for HanfTek UMT 010 USB2.0 DVB-T device");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-umt-010-02.fw");
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index ef4e37d..84ccd6e 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -335,3 +335,4 @@ MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_DESCRIPTION("Driver for Twinhan StarBox DVB-S USB2.0 and clones");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-vp702x-02.fw");
diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
index a59faa2..7bfd0bf 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -311,3 +311,4 @@ MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_DESCRIPTION("Driver for Twinhan MagicBox/Alpha and DNTV tinyUSB2 DVB-T USB2.0");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-usb-vp7045-01.fw");
-- 
1.6.5.2



