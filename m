Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:21231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab0KQTSS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:18:18 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJIHPM003285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:18:18 -0500
Received: from pedra (vpn-230-120.phx2.redhat.com [10.3.230.120])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJC5xM007699
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:17:19 -0500
Date: Wed, 17 Nov 2010 17:08:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/10] [media] rc: use rc_map_ prefix for all rc map tables
Message-ID: <20101117170832.6e535b1f@pedra>
In-Reply-To: <cover.1290020731.git.mchehab@redhat.com>
References: <cover.1290020731.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/dvb/mantis/mantis_input.c
index 572929a..db6d54d 100644
--- a/drivers/media/dvb/mantis/mantis_input.c
+++ b/drivers/media/dvb/mantis/mantis_input.c
@@ -95,7 +95,7 @@ static struct rc_map_table mantis_ir_table[] = {
 	{ 0x00, KEY_BLUE	},
 };
 
-static struct rc_keymap ir_mantis_map = {
+static struct rc_map_list ir_mantis_map = {
 	.map = {
 		.scan = mantis_ir_table,
 		.size = ARRAY_SIZE(mantis_ir_table),
@@ -109,7 +109,7 @@ int mantis_input_init(struct mantis_pci *mantis)
 	struct rc_dev *dev;
 	int err;
 
-	err = ir_register_map(&ir_mantis_map);
+	err = rc_map_register(&ir_mantis_map);
 	if (err)
 		goto out;
 
@@ -145,7 +145,7 @@ int mantis_input_init(struct mantis_pci *mantis)
 out_dev:
 	rc_free_device(dev);
 out_map:
-	ir_unregister_map(&ir_mantis_map);
+	rc_map_unregister(&ir_mantis_map);
 out:
 	return err;
 }
@@ -153,7 +153,7 @@ out:
 int mantis_exit(struct mantis_pci *mantis)
 {
 	rc_unregister_device(mantis->rc);
-	ir_unregister_map(&ir_mantis_map);
+	rc_map_unregister(&ir_mantis_map);
 	return 0;
 }
 
diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
index da6556d..136d395 100644
--- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -63,7 +63,7 @@ static struct rc_map_table adstech_dvb_t_pci[] = {
 	{ 0x1c, KEY_VOLUMEDOWN },
 };
 
-static struct rc_keymap adstech_dvb_t_pci_map = {
+static struct rc_map_list adstech_dvb_t_pci_map = {
 	.map = {
 		.scan    = adstech_dvb_t_pci,
 		.size    = ARRAY_SIZE(adstech_dvb_t_pci),
@@ -74,12 +74,12 @@ static struct rc_keymap adstech_dvb_t_pci_map = {
 
 static int __init init_rc_map_adstech_dvb_t_pci(void)
 {
-	return ir_register_map(&adstech_dvb_t_pci_map);
+	return rc_map_register(&adstech_dvb_t_pci_map);
 }
 
 static void __exit exit_rc_map_adstech_dvb_t_pci(void)
 {
-	ir_unregister_map(&adstech_dvb_t_pci_map);
+	rc_map_unregister(&adstech_dvb_t_pci_map);
 }
 
 module_init(init_rc_map_adstech_dvb_t_pci)
diff --git a/drivers/media/rc/keymaps/rc-alink-dtu-m.c b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
index 36e1eb1..fe652e9 100644
--- a/drivers/media/rc/keymaps/rc-alink-dtu-m.c
+++ b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
@@ -42,7 +42,7 @@ static struct rc_map_table alink_dtu_m[] = {
 	{ 0x081d, KEY_CHANNELDOWN },
 };
 
-static struct rc_keymap alink_dtu_m_map = {
+static struct rc_map_list alink_dtu_m_map = {
 	.map = {
 		.scan    = alink_dtu_m,
 		.size    = ARRAY_SIZE(alink_dtu_m),
@@ -53,12 +53,12 @@ static struct rc_keymap alink_dtu_m_map = {
 
 static int __init init_rc_map_alink_dtu_m(void)
 {
-	return ir_register_map(&alink_dtu_m_map);
+	return rc_map_register(&alink_dtu_m_map);
 }
 
 static void __exit exit_rc_map_alink_dtu_m(void)
 {
-	ir_unregister_map(&alink_dtu_m_map);
+	rc_map_unregister(&alink_dtu_m_map);
 }
 
 module_init(init_rc_map_alink_dtu_m)
diff --git a/drivers/media/rc/keymaps/rc-anysee.c b/drivers/media/rc/keymaps/rc-anysee.c
index 6ca91e0..884f1b5 100644
--- a/drivers/media/rc/keymaps/rc-anysee.c
+++ b/drivers/media/rc/keymaps/rc-anysee.c
@@ -67,7 +67,7 @@ static struct rc_map_table anysee[] = {
 	{ 0x0851, KEY_PAUSE },
 };
 
-static struct rc_keymap anysee_map = {
+static struct rc_map_list anysee_map = {
 	.map = {
 		.scan    = anysee,
 		.size    = ARRAY_SIZE(anysee),
@@ -78,12 +78,12 @@ static struct rc_keymap anysee_map = {
 
 static int __init init_rc_map_anysee(void)
 {
-	return ir_register_map(&anysee_map);
+	return rc_map_register(&anysee_map);
 }
 
 static void __exit exit_rc_map_anysee(void)
 {
-	ir_unregister_map(&anysee_map);
+	rc_map_unregister(&anysee_map);
 }
 
 module_init(init_rc_map_anysee)
diff --git a/drivers/media/rc/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
index a40a1b6..7af1882 100644
--- a/drivers/media/rc/keymaps/rc-apac-viewcomp.c
+++ b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
@@ -54,7 +54,7 @@ static struct rc_map_table apac_viewcomp[] = {
 	{ 0x18, KEY_KPMINUS },		/* fine tune <<<< */
 };
 
-static struct rc_keymap apac_viewcomp_map = {
+static struct rc_map_list apac_viewcomp_map = {
 	.map = {
 		.scan    = apac_viewcomp,
 		.size    = ARRAY_SIZE(apac_viewcomp),
@@ -65,12 +65,12 @@ static struct rc_keymap apac_viewcomp_map = {
 
 static int __init init_rc_map_apac_viewcomp(void)
 {
-	return ir_register_map(&apac_viewcomp_map);
+	return rc_map_register(&apac_viewcomp_map);
 }
 
 static void __exit exit_rc_map_apac_viewcomp(void)
 {
-	ir_unregister_map(&apac_viewcomp_map);
+	rc_map_unregister(&apac_viewcomp_map);
 }
 
 module_init(init_rc_map_apac_viewcomp)
diff --git a/drivers/media/rc/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
index 2a58ffe..b248115 100644
--- a/drivers/media/rc/keymaps/rc-asus-pc39.c
+++ b/drivers/media/rc/keymaps/rc-asus-pc39.c
@@ -65,7 +65,7 @@ static struct rc_map_table asus_pc39[] = {
 	{ 0x083e, KEY_DVD },		/* dvd */
 };
 
-static struct rc_keymap asus_pc39_map = {
+static struct rc_map_list asus_pc39_map = {
 	.map = {
 		.scan    = asus_pc39,
 		.size    = ARRAY_SIZE(asus_pc39),
@@ -76,12 +76,12 @@ static struct rc_keymap asus_pc39_map = {
 
 static int __init init_rc_map_asus_pc39(void)
 {
-	return ir_register_map(&asus_pc39_map);
+	return rc_map_register(&asus_pc39_map);
 }
 
 static void __exit exit_rc_map_asus_pc39(void)
 {
-	ir_unregister_map(&asus_pc39_map);
+	rc_map_unregister(&asus_pc39_map);
 }
 
 module_init(init_rc_map_asus_pc39)
diff --git a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
index ac0a7d9..f766b24 100644
--- a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
+++ b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -43,7 +43,7 @@ static struct rc_map_table ati_tv_wonder_hd_600[] = {
 	{ 0x17, KEY_VOLUMEDOWN},
 };
 
-static struct rc_keymap ati_tv_wonder_hd_600_map = {
+static struct rc_map_list ati_tv_wonder_hd_600_map = {
 	.map = {
 		.scan    = ati_tv_wonder_hd_600,
 		.size    = ARRAY_SIZE(ati_tv_wonder_hd_600),
@@ -54,12 +54,12 @@ static struct rc_keymap ati_tv_wonder_hd_600_map = {
 
 static int __init init_rc_map_ati_tv_wonder_hd_600(void)
 {
-	return ir_register_map(&ati_tv_wonder_hd_600_map);
+	return rc_map_register(&ati_tv_wonder_hd_600_map);
 }
 
 static void __exit exit_rc_map_ati_tv_wonder_hd_600(void)
 {
-	ir_unregister_map(&ati_tv_wonder_hd_600_map);
+	rc_map_unregister(&ati_tv_wonder_hd_600_map);
 }
 
 module_init(init_rc_map_ati_tv_wonder_hd_600)
diff --git a/drivers/media/rc/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
index df3360f..ec9beee 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-a16d.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
@@ -49,7 +49,7 @@ static struct rc_map_table avermedia_a16d[] = {
 	{ 0x2a, KEY_MENU},
 };
 
-static struct rc_keymap avermedia_a16d_map = {
+static struct rc_map_list avermedia_a16d_map = {
 	.map = {
 		.scan    = avermedia_a16d,
 		.size    = ARRAY_SIZE(avermedia_a16d),
@@ -60,12 +60,12 @@ static struct rc_keymap avermedia_a16d_map = {
 
 static int __init init_rc_map_avermedia_a16d(void)
 {
-	return ir_register_map(&avermedia_a16d_map);
+	return rc_map_register(&avermedia_a16d_map);
 }
 
 static void __exit exit_rc_map_avermedia_a16d(void)
 {
-	ir_unregister_map(&avermedia_a16d_map);
+	rc_map_unregister(&avermedia_a16d_map);
 }
 
 module_init(init_rc_map_avermedia_a16d)
diff --git a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
index 40f2f2d..bdf97b7 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
@@ -71,7 +71,7 @@ static struct rc_map_table avermedia_cardbus[] = {
 	{ 0x43, KEY_CHANNELUP },	/* Channel up */
 };
 
-static struct rc_keymap avermedia_cardbus_map = {
+static struct rc_map_list avermedia_cardbus_map = {
 	.map = {
 		.scan    = avermedia_cardbus,
 		.size    = ARRAY_SIZE(avermedia_cardbus),
@@ -82,12 +82,12 @@ static struct rc_keymap avermedia_cardbus_map = {
 
 static int __init init_rc_map_avermedia_cardbus(void)
 {
-	return ir_register_map(&avermedia_cardbus_map);
+	return rc_map_register(&avermedia_cardbus_map);
 }
 
 static void __exit exit_rc_map_avermedia_cardbus(void)
 {
-	ir_unregister_map(&avermedia_cardbus_map);
+	rc_map_unregister(&avermedia_cardbus_map);
 }
 
 module_init(init_rc_map_avermedia_cardbus)
diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
index b4a1aa1..3ddb41b 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -52,7 +52,7 @@ static struct rc_map_table avermedia_dvbt[] = {
 	{ 0x3e, KEY_VOLUMEUP },		/* 'volume +' */
 };
 
-static struct rc_keymap avermedia_dvbt_map = {
+static struct rc_map_list avermedia_dvbt_map = {
 	.map = {
 		.scan    = avermedia_dvbt,
 		.size    = ARRAY_SIZE(avermedia_dvbt),
@@ -63,12 +63,12 @@ static struct rc_keymap avermedia_dvbt_map = {
 
 static int __init init_rc_map_avermedia_dvbt(void)
 {
-	return ir_register_map(&avermedia_dvbt_map);
+	return rc_map_register(&avermedia_dvbt_map);
 }
 
 static void __exit exit_rc_map_avermedia_dvbt(void)
 {
-	ir_unregister_map(&avermedia_dvbt_map);
+	rc_map_unregister(&avermedia_dvbt_map);
 }
 
 module_init(init_rc_map_avermedia_dvbt)
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index 971c6f9..357fea5 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -121,7 +121,7 @@ static struct rc_map_table avermedia_m135a[] = {
 	{ 0x041e, KEY_NEXT },
 };
 
-static struct rc_keymap avermedia_m135a_map = {
+static struct rc_map_list avermedia_m135a_map = {
 	.map = {
 		.scan    = avermedia_m135a,
 		.size    = ARRAY_SIZE(avermedia_m135a),
@@ -132,12 +132,12 @@ static struct rc_keymap avermedia_m135a_map = {
 
 static int __init init_rc_map_avermedia_m135a(void)
 {
-	return ir_register_map(&avermedia_m135a_map);
+	return rc_map_register(&avermedia_m135a_map);
 }
 
 static void __exit exit_rc_map_avermedia_m135a(void)
 {
-	ir_unregister_map(&avermedia_m135a_map);
+	rc_map_unregister(&avermedia_m135a_map);
 }
 
 module_init(init_rc_map_avermedia_m135a)
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
index 74f3a20..e694e6e 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -69,7 +69,7 @@ static struct rc_map_table avermedia_m733a_rm_k6[] = {
 	{ 0x041e, KEY_NEXT },
 };
 
-static struct rc_keymap avermedia_m733a_rm_k6_map = {
+static struct rc_map_list avermedia_m733a_rm_k6_map = {
 	.map = {
 		.scan    = avermedia_m733a_rm_k6,
 		.size    = ARRAY_SIZE(avermedia_m733a_rm_k6),
@@ -80,12 +80,12 @@ static struct rc_keymap avermedia_m733a_rm_k6_map = {
 
 static int __init init_rc_map_avermedia_m733a_rm_k6(void)
 {
-	return ir_register_map(&avermedia_m733a_rm_k6_map);
+	return rc_map_register(&avermedia_m733a_rm_k6_map);
 }
 
 static void __exit exit_rc_map_avermedia_m733a_rm_k6(void)
 {
-	ir_unregister_map(&avermedia_m733a_rm_k6_map);
+	rc_map_unregister(&avermedia_m733a_rm_k6_map);
 }
 
 module_init(init_rc_map_avermedia_m733a_rm_k6)
diff --git a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
index dc6a321..f4ca1ff 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
@@ -53,7 +53,7 @@ static struct rc_map_table avermedia_rm_ks[] = {
 	{ 0x0556, KEY_ZOOM },
 };
 
-static struct rc_keymap avermedia_rm_ks_map = {
+static struct rc_map_list avermedia_rm_ks_map = {
 	.map = {
 		.scan    = avermedia_rm_ks,
 		.size    = ARRAY_SIZE(avermedia_rm_ks),
@@ -64,12 +64,12 @@ static struct rc_keymap avermedia_rm_ks_map = {
 
 static int __init init_rc_map_avermedia_rm_ks(void)
 {
-	return ir_register_map(&avermedia_rm_ks_map);
+	return rc_map_register(&avermedia_rm_ks_map);
 }
 
 static void __exit exit_rc_map_avermedia_rm_ks(void)
 {
-	ir_unregister_map(&avermedia_rm_ks_map);
+	rc_map_unregister(&avermedia_rm_ks_map);
 }
 
 module_init(init_rc_map_avermedia_rm_ks)
diff --git a/drivers/media/rc/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
index a5ef695..edfa715 100644
--- a/drivers/media/rc/keymaps/rc-avermedia.c
+++ b/drivers/media/rc/keymaps/rc-avermedia.c
@@ -60,7 +60,7 @@ static struct rc_map_table avermedia[] = {
 	{ 0x31, KEY_CHANNELUP }		/* CHANNEL/PAGE+ */
 };
 
-static struct rc_keymap avermedia_map = {
+static struct rc_map_list avermedia_map = {
 	.map = {
 		.scan    = avermedia,
 		.size    = ARRAY_SIZE(avermedia),
@@ -71,12 +71,12 @@ static struct rc_keymap avermedia_map = {
 
 static int __init init_rc_map_avermedia(void)
 {
-	return ir_register_map(&avermedia_map);
+	return rc_map_register(&avermedia_map);
 }
 
 static void __exit exit_rc_map_avermedia(void)
 {
-	ir_unregister_map(&avermedia_map);
+	rc_map_unregister(&avermedia_map);
 }
 
 module_init(init_rc_map_avermedia)
diff --git a/drivers/media/rc/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
index 386ba59..32e9498 100644
--- a/drivers/media/rc/keymaps/rc-avertv-303.c
+++ b/drivers/media/rc/keymaps/rc-avertv-303.c
@@ -59,7 +59,7 @@ static struct rc_map_table avertv_303[] = {
 	{ 0x1b, KEY_UP },
 };
 
-static struct rc_keymap avertv_303_map = {
+static struct rc_map_list avertv_303_map = {
 	.map = {
 		.scan    = avertv_303,
 		.size    = ARRAY_SIZE(avertv_303),
@@ -70,12 +70,12 @@ static struct rc_keymap avertv_303_map = {
 
 static int __init init_rc_map_avertv_303(void)
 {
-	return ir_register_map(&avertv_303_map);
+	return rc_map_register(&avertv_303_map);
 }
 
 static void __exit exit_rc_map_avertv_303(void)
 {
-	ir_unregister_map(&avertv_303_map);
+	rc_map_unregister(&avertv_303_map);
 }
 
 module_init(init_rc_map_avertv_303)
diff --git a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
index fbaaba5..c3f6d62 100644
--- a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
+++ b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
@@ -76,7 +76,7 @@ static struct rc_map_table azurewave_ad_tu700[] = {
 	{ 0x005f, KEY_BLUE },
 };
 
-static struct rc_keymap azurewave_ad_tu700_map = {
+static struct rc_map_list azurewave_ad_tu700_map = {
 	.map = {
 		.scan    = azurewave_ad_tu700,
 		.size    = ARRAY_SIZE(azurewave_ad_tu700),
@@ -87,12 +87,12 @@ static struct rc_keymap azurewave_ad_tu700_map = {
 
 static int __init init_rc_map_azurewave_ad_tu700(void)
 {
-	return ir_register_map(&azurewave_ad_tu700_map);
+	return rc_map_register(&azurewave_ad_tu700_map);
 }
 
 static void __exit exit_rc_map_azurewave_ad_tu700(void)
 {
-	ir_unregister_map(&azurewave_ad_tu700_map);
+	rc_map_unregister(&azurewave_ad_tu700_map);
 }
 
 module_init(init_rc_map_azurewave_ad_tu700)
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index 33accf5..4b787fa 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -82,7 +82,7 @@ static struct rc_map_table behold_columbus[] = {
 
 };
 
-static struct rc_keymap behold_columbus_map = {
+static struct rc_map_list behold_columbus_map = {
 	.map = {
 		.scan    = behold_columbus,
 		.size    = ARRAY_SIZE(behold_columbus),
@@ -93,12 +93,12 @@ static struct rc_keymap behold_columbus_map = {
 
 static int __init init_rc_map_behold_columbus(void)
 {
-	return ir_register_map(&behold_columbus_map);
+	return rc_map_register(&behold_columbus_map);
 }
 
 static void __exit exit_rc_map_behold_columbus(void)
 {
-	ir_unregister_map(&behold_columbus_map);
+	rc_map_unregister(&behold_columbus_map);
 }
 
 module_init(init_rc_map_behold_columbus)
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index 4402414..ae4d235 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -115,7 +115,7 @@ static struct rc_map_table behold[] = {
 
 };
 
-static struct rc_keymap behold_map = {
+static struct rc_map_list behold_map = {
 	.map = {
 		.scan    = behold,
 		.size    = ARRAY_SIZE(behold),
@@ -126,12 +126,12 @@ static struct rc_keymap behold_map = {
 
 static int __init init_rc_map_behold(void)
 {
-	return ir_register_map(&behold_map);
+	return rc_map_register(&behold_map);
 }
 
 static void __exit exit_rc_map_behold(void)
 {
-	ir_unregister_map(&behold_map);
+	rc_map_unregister(&behold_map);
 }
 
 module_init(init_rc_map_behold)
diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
index e4827a6..97fc386 100644
--- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -66,7 +66,7 @@ static struct rc_map_table budget_ci_old[] = {
 	{ 0x3e, KEY_TUNER },
 };
 
-static struct rc_keymap budget_ci_old_map = {
+static struct rc_map_list budget_ci_old_map = {
 	.map = {
 		.scan    = budget_ci_old,
 		.size    = ARRAY_SIZE(budget_ci_old),
@@ -77,12 +77,12 @@ static struct rc_keymap budget_ci_old_map = {
 
 static int __init init_rc_map_budget_ci_old(void)
 {
-	return ir_register_map(&budget_ci_old_map);
+	return rc_map_register(&budget_ci_old_map);
 }
 
 static void __exit exit_rc_map_budget_ci_old(void)
 {
-	ir_unregister_map(&budget_ci_old_map);
+	rc_map_unregister(&budget_ci_old_map);
 }
 
 module_init(init_rc_map_budget_ci_old)
diff --git a/drivers/media/rc/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
index 6a69866..284534b 100644
--- a/drivers/media/rc/keymaps/rc-cinergy-1400.c
+++ b/drivers/media/rc/keymaps/rc-cinergy-1400.c
@@ -58,7 +58,7 @@ static struct rc_map_table cinergy_1400[] = {
 	{ 0x5c, KEY_NEXT },
 };
 
-static struct rc_keymap cinergy_1400_map = {
+static struct rc_map_list cinergy_1400_map = {
 	.map = {
 		.scan    = cinergy_1400,
 		.size    = ARRAY_SIZE(cinergy_1400),
@@ -69,12 +69,12 @@ static struct rc_keymap cinergy_1400_map = {
 
 static int __init init_rc_map_cinergy_1400(void)
 {
-	return ir_register_map(&cinergy_1400_map);
+	return rc_map_register(&cinergy_1400_map);
 }
 
 static void __exit exit_rc_map_cinergy_1400(void)
 {
-	ir_unregister_map(&cinergy_1400_map);
+	rc_map_unregister(&cinergy_1400_map);
 }
 
 module_init(init_rc_map_cinergy_1400)
diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
index ba36d14..99520ff 100644
--- a/drivers/media/rc/keymaps/rc-cinergy.c
+++ b/drivers/media/rc/keymaps/rc-cinergy.c
@@ -52,7 +52,7 @@ static struct rc_map_table cinergy[] = {
 	{ 0x23, KEY_STOP },
 };
 
-static struct rc_keymap cinergy_map = {
+static struct rc_map_list cinergy_map = {
 	.map = {
 		.scan    = cinergy,
 		.size    = ARRAY_SIZE(cinergy),
@@ -63,12 +63,12 @@ static struct rc_keymap cinergy_map = {
 
 static int __init init_rc_map_cinergy(void)
 {
-	return ir_register_map(&cinergy_map);
+	return rc_map_register(&cinergy_map);
 }
 
 static void __exit exit_rc_map_cinergy(void)
 {
-	ir_unregister_map(&cinergy_map);
+	rc_map_unregister(&cinergy_map);
 }
 
 module_init(init_rc_map_cinergy)
diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index 921230d..c59851b 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -98,7 +98,7 @@ static struct rc_map_table dib0700_nec_table[] = {
 	{ 0x4542, KEY_SELECT }, /* Select video input, 'Select' for Teletext */
 };
 
-static struct rc_keymap dib0700_nec_map = {
+static struct rc_map_list dib0700_nec_map = {
 	.map = {
 		.scan    = dib0700_nec_table,
 		.size    = ARRAY_SIZE(dib0700_nec_table),
@@ -109,12 +109,12 @@ static struct rc_keymap dib0700_nec_map = {
 
 static int __init init_rc_map(void)
 {
-	return ir_register_map(&dib0700_nec_map);
+	return rc_map_register(&dib0700_nec_map);
 }
 
 static void __exit exit_rc_map(void)
 {
-	ir_unregister_map(&dib0700_nec_map);
+	rc_map_unregister(&dib0700_nec_map);
 }
 
 module_init(init_rc_map)
diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
index 9febb72..4af12e4 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
@@ -209,7 +209,7 @@ static struct rc_map_table dib0700_rc5_table[] = {
 	{ 0x1d3d, KEY_POWER },
 };
 
-static struct rc_keymap dib0700_rc5_map = {
+static struct rc_map_list dib0700_rc5_map = {
 	.map = {
 		.scan    = dib0700_rc5_table,
 		.size    = ARRAY_SIZE(dib0700_rc5_table),
@@ -220,12 +220,12 @@ static struct rc_keymap dib0700_rc5_map = {
 
 static int __init init_rc_map(void)
 {
-	return ir_register_map(&dib0700_rc5_map);
+	return rc_map_register(&dib0700_rc5_map);
 }
 
 static void __exit exit_rc_map(void)
 {
-	ir_unregister_map(&dib0700_rc5_map);
+	rc_map_unregister(&dib0700_rc5_map);
 }
 
 module_init(init_rc_map)
diff --git a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
index da50d7d..f68b450 100644
--- a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
+++ b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
@@ -72,7 +72,7 @@ static struct rc_map_table digitalnow_tinytwin[] = {
 	{ 0x005a, KEY_PREVIOUS },        /* REPLAY */
 };
 
-static struct rc_keymap digitalnow_tinytwin_map = {
+static struct rc_map_list digitalnow_tinytwin_map = {
 	.map = {
 		.scan    = digitalnow_tinytwin,
 		.size    = ARRAY_SIZE(digitalnow_tinytwin),
@@ -83,12 +83,12 @@ static struct rc_keymap digitalnow_tinytwin_map = {
 
 static int __init init_rc_map_digitalnow_tinytwin(void)
 {
-	return ir_register_map(&digitalnow_tinytwin_map);
+	return rc_map_register(&digitalnow_tinytwin_map);
 }
 
 static void __exit exit_rc_map_digitalnow_tinytwin(void)
 {
-	ir_unregister_map(&digitalnow_tinytwin_map);
+	rc_map_unregister(&digitalnow_tinytwin_map);
 }
 
 module_init(init_rc_map_digitalnow_tinytwin)
diff --git a/drivers/media/rc/keymaps/rc-digittrade.c b/drivers/media/rc/keymaps/rc-digittrade.c
index 706f95d..21d4987 100644
--- a/drivers/media/rc/keymaps/rc-digittrade.c
+++ b/drivers/media/rc/keymaps/rc-digittrade.c
@@ -56,7 +56,7 @@ static struct rc_map_table digittrade[] = {
 	{ 0x0054, KEY_0 },
 };
 
-static struct rc_keymap digittrade_map = {
+static struct rc_map_list digittrade_map = {
 	.map = {
 		.scan    = digittrade,
 		.size    = ARRAY_SIZE(digittrade),
@@ -67,12 +67,12 @@ static struct rc_keymap digittrade_map = {
 
 static int __init init_rc_map_digittrade(void)
 {
-	return ir_register_map(&digittrade_map);
+	return rc_map_register(&digittrade_map);
 }
 
 static void __exit exit_rc_map_digittrade(void)
 {
-	ir_unregister_map(&digittrade_map);
+	rc_map_unregister(&digittrade_map);
 }
 
 module_init(init_rc_map_digittrade)
diff --git a/drivers/media/rc/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
index 9023dc9..d024fbf 100644
--- a/drivers/media/rc/keymaps/rc-dm1105-nec.c
+++ b/drivers/media/rc/keymaps/rc-dm1105-nec.c
@@ -50,7 +50,7 @@ static struct rc_map_table dm1105_nec[] = {
 	{ 0x1b, KEY_B},			/* recall */
 };
 
-static struct rc_keymap dm1105_nec_map = {
+static struct rc_map_list dm1105_nec_map = {
 	.map = {
 		.scan    = dm1105_nec,
 		.size    = ARRAY_SIZE(dm1105_nec),
@@ -61,12 +61,12 @@ static struct rc_keymap dm1105_nec_map = {
 
 static int __init init_rc_map_dm1105_nec(void)
 {
-	return ir_register_map(&dm1105_nec_map);
+	return rc_map_register(&dm1105_nec_map);
 }
 
 static void __exit exit_rc_map_dm1105_nec(void)
 {
-	ir_unregister_map(&dm1105_nec_map);
+	rc_map_unregister(&dm1105_nec_map);
 }
 
 module_init(init_rc_map_dm1105_nec)
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
index 7fbeaed..43912bd 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
@@ -52,7 +52,7 @@ static struct rc_map_table dntv_live_dvb_t[] = {
 	{ 0x1f, KEY_VOLUMEDOWN },
 };
 
-static struct rc_keymap dntv_live_dvb_t_map = {
+static struct rc_map_list dntv_live_dvb_t_map = {
 	.map = {
 		.scan    = dntv_live_dvb_t,
 		.size    = ARRAY_SIZE(dntv_live_dvb_t),
@@ -63,12 +63,12 @@ static struct rc_keymap dntv_live_dvb_t_map = {
 
 static int __init init_rc_map_dntv_live_dvb_t(void)
 {
-	return ir_register_map(&dntv_live_dvb_t_map);
+	return rc_map_register(&dntv_live_dvb_t_map);
 }
 
 static void __exit exit_rc_map_dntv_live_dvb_t(void)
 {
-	ir_unregister_map(&dntv_live_dvb_t_map);
+	rc_map_unregister(&dntv_live_dvb_t_map);
 }
 
 module_init(init_rc_map_dntv_live_dvb_t)
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
index 660f2e7..015e99d 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
@@ -71,7 +71,7 @@ static struct rc_map_table dntv_live_dvbt_pro[] = {
 	{ 0x5d, KEY_BLUE },
 };
 
-static struct rc_keymap dntv_live_dvbt_pro_map = {
+static struct rc_map_list dntv_live_dvbt_pro_map = {
 	.map = {
 		.scan    = dntv_live_dvbt_pro,
 		.size    = ARRAY_SIZE(dntv_live_dvbt_pro),
@@ -82,12 +82,12 @@ static struct rc_keymap dntv_live_dvbt_pro_map = {
 
 static int __init init_rc_map_dntv_live_dvbt_pro(void)
 {
-	return ir_register_map(&dntv_live_dvbt_pro_map);
+	return rc_map_register(&dntv_live_dvbt_pro_map);
 }
 
 static void __exit exit_rc_map_dntv_live_dvbt_pro(void)
 {
-	ir_unregister_map(&dntv_live_dvbt_pro_map);
+	rc_map_unregister(&dntv_live_dvbt_pro_map);
 }
 
 module_init(init_rc_map_dntv_live_dvbt_pro)
diff --git a/drivers/media/rc/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
index 4d0ad8c..269d429 100644
--- a/drivers/media/rc/keymaps/rc-em-terratec.c
+++ b/drivers/media/rc/keymaps/rc-em-terratec.c
@@ -43,7 +43,7 @@ static struct rc_map_table em_terratec[] = {
 	{ 0x40, KEY_ZOOM },
 };
 
-static struct rc_keymap em_terratec_map = {
+static struct rc_map_list em_terratec_map = {
 	.map = {
 		.scan    = em_terratec,
 		.size    = ARRAY_SIZE(em_terratec),
@@ -54,12 +54,12 @@ static struct rc_keymap em_terratec_map = {
 
 static int __init init_rc_map_em_terratec(void)
 {
-	return ir_register_map(&em_terratec_map);
+	return rc_map_register(&em_terratec_map);
 }
 
 static void __exit exit_rc_map_em_terratec(void)
 {
-	ir_unregister_map(&em_terratec_map);
+	rc_map_unregister(&em_terratec_map);
 }
 
 module_init(init_rc_map_em_terratec)
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
index 3005d4b..e388698 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -55,7 +55,7 @@ static struct rc_map_table encore_enltv_fm53[] = {
 	{ 0x47, KEY_SLEEP},		/* shutdown */
 };
 
-static struct rc_keymap encore_enltv_fm53_map = {
+static struct rc_map_list encore_enltv_fm53_map = {
 	.map = {
 		.scan    = encore_enltv_fm53,
 		.size    = ARRAY_SIZE(encore_enltv_fm53),
@@ -66,12 +66,12 @@ static struct rc_keymap encore_enltv_fm53_map = {
 
 static int __init init_rc_map_encore_enltv_fm53(void)
 {
-	return ir_register_map(&encore_enltv_fm53_map);
+	return rc_map_register(&encore_enltv_fm53_map);
 }
 
 static void __exit exit_rc_map_encore_enltv_fm53(void)
 {
-	ir_unregister_map(&encore_enltv_fm53_map);
+	rc_map_unregister(&encore_enltv_fm53_map);
 }
 
 module_init(init_rc_map_encore_enltv_fm53)
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index d16db50..afa4e92 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -86,7 +86,7 @@ static struct rc_map_table encore_enltv[] = {
 	{ 0x57, KEY_BLUE },		/* AP4 */
 };
 
-static struct rc_keymap encore_enltv_map = {
+static struct rc_map_list encore_enltv_map = {
 	.map = {
 		.scan    = encore_enltv,
 		.size    = ARRAY_SIZE(encore_enltv),
@@ -97,12 +97,12 @@ static struct rc_keymap encore_enltv_map = {
 
 static int __init init_rc_map_encore_enltv(void)
 {
-	return ir_register_map(&encore_enltv_map);
+	return rc_map_register(&encore_enltv_map);
 }
 
 static void __exit exit_rc_map_encore_enltv(void)
 {
-	ir_unregister_map(&encore_enltv_map);
+	rc_map_unregister(&encore_enltv_map);
 }
 
 module_init(init_rc_map_encore_enltv)
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index a5e07c7..7d5b00e 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -64,7 +64,7 @@ static struct rc_map_table encore_enltv2[] = {
 	{ 0x79, KEY_STOP },
 };
 
-static struct rc_keymap encore_enltv2_map = {
+static struct rc_map_list encore_enltv2_map = {
 	.map = {
 		.scan    = encore_enltv2,
 		.size    = ARRAY_SIZE(encore_enltv2),
@@ -75,12 +75,12 @@ static struct rc_keymap encore_enltv2_map = {
 
 static int __init init_rc_map_encore_enltv2(void)
 {
-	return ir_register_map(&encore_enltv2_map);
+	return rc_map_register(&encore_enltv2_map);
 }
 
 static void __exit exit_rc_map_encore_enltv2(void)
 {
-	ir_unregister_map(&encore_enltv2_map);
+	rc_map_unregister(&encore_enltv2_map);
 }
 
 module_init(init_rc_map_encore_enltv2)
diff --git a/drivers/media/rc/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
index e2d0590..a2bf24f 100644
--- a/drivers/media/rc/keymaps/rc-evga-indtube.c
+++ b/drivers/media/rc/keymaps/rc-evga-indtube.c
@@ -35,7 +35,7 @@ static struct rc_map_table evga_indtube[] = {
 	{ 0x13, KEY_CAMERA},
 };
 
-static struct rc_keymap evga_indtube_map = {
+static struct rc_map_list evga_indtube_map = {
 	.map = {
 		.scan    = evga_indtube,
 		.size    = ARRAY_SIZE(evga_indtube),
@@ -46,12 +46,12 @@ static struct rc_keymap evga_indtube_map = {
 
 static int __init init_rc_map_evga_indtube(void)
 {
-	return ir_register_map(&evga_indtube_map);
+	return rc_map_register(&evga_indtube_map);
 }
 
 static void __exit exit_rc_map_evga_indtube(void)
 {
-	ir_unregister_map(&evga_indtube_map);
+	rc_map_unregister(&evga_indtube_map);
 }
 
 module_init(init_rc_map_evga_indtube)
diff --git a/drivers/media/rc/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
index ee134c5..1e8e5b2 100644
--- a/drivers/media/rc/keymaps/rc-eztv.c
+++ b/drivers/media/rc/keymaps/rc-eztv.c
@@ -70,7 +70,7 @@ static struct rc_map_table eztv[] = {
 	{ 0x21, KEY_DOT },	/* . (decimal dot) */
 };
 
-static struct rc_keymap eztv_map = {
+static struct rc_map_list eztv_map = {
 	.map = {
 		.scan    = eztv,
 		.size    = ARRAY_SIZE(eztv),
@@ -81,12 +81,12 @@ static struct rc_keymap eztv_map = {
 
 static int __init init_rc_map_eztv(void)
 {
-	return ir_register_map(&eztv_map);
+	return rc_map_register(&eztv_map);
 }
 
 static void __exit exit_rc_map_eztv(void)
 {
-	ir_unregister_map(&eztv_map);
+	rc_map_unregister(&eztv_map);
 }
 
 module_init(init_rc_map_eztv)
diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
index ef90a05..aea2f4a 100644
--- a/drivers/media/rc/keymaps/rc-flydvb.c
+++ b/drivers/media/rc/keymaps/rc-flydvb.c
@@ -51,7 +51,7 @@ static struct rc_map_table flydvb[] = {
 	{ 0x0e, KEY_NEXT },		/* End >>| */
 };
 
-static struct rc_keymap flydvb_map = {
+static struct rc_map_list flydvb_map = {
 	.map = {
 		.scan    = flydvb,
 		.size    = ARRAY_SIZE(flydvb),
@@ -62,12 +62,12 @@ static struct rc_keymap flydvb_map = {
 
 static int __init init_rc_map_flydvb(void)
 {
-	return ir_register_map(&flydvb_map);
+	return rc_map_register(&flydvb_map);
 }
 
 static void __exit exit_rc_map_flydvb(void)
 {
-	ir_unregister_map(&flydvb_map);
+	rc_map_unregister(&flydvb_map);
 }
 
 module_init(init_rc_map_flydvb)
diff --git a/drivers/media/rc/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
index 20a1333..5bbe683 100644
--- a/drivers/media/rc/keymaps/rc-flyvideo.c
+++ b/drivers/media/rc/keymaps/rc-flyvideo.c
@@ -44,7 +44,7 @@ static struct rc_map_table flyvideo[] = {
 	{ 0x0a, KEY_ANGLE },	/* no label, may be used as the PAUSE button */
 };
 
-static struct rc_keymap flyvideo_map = {
+static struct rc_map_list flyvideo_map = {
 	.map = {
 		.scan    = flyvideo,
 		.size    = ARRAY_SIZE(flyvideo),
@@ -55,12 +55,12 @@ static struct rc_keymap flyvideo_map = {
 
 static int __init init_rc_map_flyvideo(void)
 {
-	return ir_register_map(&flyvideo_map);
+	return rc_map_register(&flyvideo_map);
 }
 
 static void __exit exit_rc_map_flyvideo(void)
 {
-	ir_unregister_map(&flyvideo_map);
+	rc_map_unregister(&flyvideo_map);
 }
 
 module_init(init_rc_map_flyvideo)
diff --git a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
index 2687af7..c80b25c 100644
--- a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
+++ b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
@@ -72,7 +72,7 @@ static struct rc_map_table fusionhdtv_mce[] = {
 	{ 0x4e, KEY_POWER },
 };
 
-static struct rc_keymap fusionhdtv_mce_map = {
+static struct rc_map_list fusionhdtv_mce_map = {
 	.map = {
 		.scan    = fusionhdtv_mce,
 		.size    = ARRAY_SIZE(fusionhdtv_mce),
@@ -83,12 +83,12 @@ static struct rc_keymap fusionhdtv_mce_map = {
 
 static int __init init_rc_map_fusionhdtv_mce(void)
 {
-	return ir_register_map(&fusionhdtv_mce_map);
+	return rc_map_register(&fusionhdtv_mce_map);
 }
 
 static void __exit exit_rc_map_fusionhdtv_mce(void)
 {
-	ir_unregister_map(&fusionhdtv_mce_map);
+	rc_map_unregister(&fusionhdtv_mce_map);
 }
 
 module_init(init_rc_map_fusionhdtv_mce)
diff --git a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
index fb247ba..068c9ea 100644
--- a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
+++ b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
@@ -55,7 +55,7 @@ static struct rc_map_table gadmei_rm008z[] = {
 	{ 0x15, KEY_ENTER},		/* OK */
 };
 
-static struct rc_keymap gadmei_rm008z_map = {
+static struct rc_map_list gadmei_rm008z_map = {
 	.map = {
 		.scan    = gadmei_rm008z,
 		.size    = ARRAY_SIZE(gadmei_rm008z),
@@ -66,12 +66,12 @@ static struct rc_keymap gadmei_rm008z_map = {
 
 static int __init init_rc_map_gadmei_rm008z(void)
 {
-	return ir_register_map(&gadmei_rm008z_map);
+	return rc_map_register(&gadmei_rm008z_map);
 }
 
 static void __exit exit_rc_map_gadmei_rm008z(void)
 {
-	ir_unregister_map(&gadmei_rm008z_map);
+	rc_map_unregister(&gadmei_rm008z_map);
 }
 
 module_init(init_rc_map_gadmei_rm008z)
diff --git a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
index 7e6834a..cdbbed4 100644
--- a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
+++ b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
@@ -58,7 +58,7 @@ static struct rc_map_table genius_tvgo_a11mce[] = {
 	{ 0x50, KEY_BLUE },
 };
 
-static struct rc_keymap genius_tvgo_a11mce_map = {
+static struct rc_map_list genius_tvgo_a11mce_map = {
 	.map = {
 		.scan    = genius_tvgo_a11mce,
 		.size    = ARRAY_SIZE(genius_tvgo_a11mce),
@@ -69,12 +69,12 @@ static struct rc_keymap genius_tvgo_a11mce_map = {
 
 static int __init init_rc_map_genius_tvgo_a11mce(void)
 {
-	return ir_register_map(&genius_tvgo_a11mce_map);
+	return rc_map_register(&genius_tvgo_a11mce_map);
 }
 
 static void __exit exit_rc_map_genius_tvgo_a11mce(void)
 {
-	ir_unregister_map(&genius_tvgo_a11mce_map);
+	rc_map_unregister(&genius_tvgo_a11mce_map);
 }
 
 module_init(init_rc_map_genius_tvgo_a11mce)
diff --git a/drivers/media/rc/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
index 54222ca..a38bdde 100644
--- a/drivers/media/rc/keymaps/rc-gotview7135.c
+++ b/drivers/media/rc/keymaps/rc-gotview7135.c
@@ -53,7 +53,7 @@ static struct rc_map_table gotview7135[] = {
 	{ 0x38, KEY_F24 },	/* NORMAL TIMESHIFT */
 };
 
-static struct rc_keymap gotview7135_map = {
+static struct rc_map_list gotview7135_map = {
 	.map = {
 		.scan    = gotview7135,
 		.size    = ARRAY_SIZE(gotview7135),
@@ -64,12 +64,12 @@ static struct rc_keymap gotview7135_map = {
 
 static int __init init_rc_map_gotview7135(void)
 {
-	return ir_register_map(&gotview7135_map);
+	return rc_map_register(&gotview7135_map);
 }
 
 static void __exit exit_rc_map_gotview7135(void)
 {
-	ir_unregister_map(&gotview7135_map);
+	rc_map_unregister(&gotview7135_map);
 }
 
 module_init(init_rc_map_gotview7135)
diff --git a/drivers/media/rc/keymaps/rc-hauppauge-new.c b/drivers/media/rc/keymaps/rc-hauppauge-new.c
index 2396257..bd11da4 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge-new.c
@@ -74,7 +74,7 @@ static struct rc_map_table hauppauge_new[] = {
 	{ 0x3d, KEY_POWER },		/* system power (green button) */
 };
 
-static struct rc_keymap hauppauge_new_map = {
+static struct rc_map_list hauppauge_new_map = {
 	.map = {
 		.scan    = hauppauge_new,
 		.size    = ARRAY_SIZE(hauppauge_new),
@@ -85,12 +85,12 @@ static struct rc_keymap hauppauge_new_map = {
 
 static int __init init_rc_map_hauppauge_new(void)
 {
-	return ir_register_map(&hauppauge_new_map);
+	return rc_map_register(&hauppauge_new_map);
 }
 
 static void __exit exit_rc_map_hauppauge_new(void)
 {
-	ir_unregister_map(&hauppauge_new_map);
+	rc_map_unregister(&hauppauge_new_map);
 }
 
 module_init(init_rc_map_hauppauge_new)
diff --git a/drivers/media/rc/keymaps/rc-imon-mce.c b/drivers/media/rc/keymaps/rc-imon-mce.c
index 291e5d8..cb67184 100644
--- a/drivers/media/rc/keymaps/rc-imon-mce.c
+++ b/drivers/media/rc/keymaps/rc-imon-mce.c
@@ -115,7 +115,7 @@ static struct rc_map_table imon_mce[] = {
 
 };
 
-static struct rc_keymap imon_mce_map = {
+static struct rc_map_list imon_mce_map = {
 	.map = {
 		.scan    = imon_mce,
 		.size    = ARRAY_SIZE(imon_mce),
@@ -127,12 +127,12 @@ static struct rc_keymap imon_mce_map = {
 
 static int __init init_rc_map_imon_mce(void)
 {
-	return ir_register_map(&imon_mce_map);
+	return rc_map_register(&imon_mce_map);
 }
 
 static void __exit exit_rc_map_imon_mce(void)
 {
-	ir_unregister_map(&imon_mce_map);
+	rc_map_unregister(&imon_mce_map);
 }
 
 module_init(init_rc_map_imon_mce)
diff --git a/drivers/media/rc/keymaps/rc-imon-pad.c b/drivers/media/rc/keymaps/rc-imon-pad.c
index 33f28d4..eef46b7 100644
--- a/drivers/media/rc/keymaps/rc-imon-pad.c
+++ b/drivers/media/rc/keymaps/rc-imon-pad.c
@@ -129,7 +129,7 @@ static struct rc_map_table imon_pad[] = {
 	{ 0x29b715b7, KEY_DASHBOARD }, /* AppLauncher */
 };
 
-static struct rc_keymap imon_pad_map = {
+static struct rc_map_list imon_pad_map = {
 	.map = {
 		.scan    = imon_pad,
 		.size    = ARRAY_SIZE(imon_pad),
@@ -141,12 +141,12 @@ static struct rc_keymap imon_pad_map = {
 
 static int __init init_rc_map_imon_pad(void)
 {
-	return ir_register_map(&imon_pad_map);
+	return rc_map_register(&imon_pad_map);
 }
 
 static void __exit exit_rc_map_imon_pad(void)
 {
-	ir_unregister_map(&imon_pad_map);
+	rc_map_unregister(&imon_pad_map);
 }
 
 module_init(init_rc_map_imon_pad)
diff --git a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
index 5e5263f..1f59e16 100644
--- a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
+++ b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
@@ -62,7 +62,7 @@ static struct rc_map_table iodata_bctv7e[] = {
 	{ 0x01, KEY_NEXT },		/* skip >| */
 };
 
-static struct rc_keymap iodata_bctv7e_map = {
+static struct rc_map_list iodata_bctv7e_map = {
 	.map = {
 		.scan    = iodata_bctv7e,
 		.size    = ARRAY_SIZE(iodata_bctv7e),
@@ -73,12 +73,12 @@ static struct rc_keymap iodata_bctv7e_map = {
 
 static int __init init_rc_map_iodata_bctv7e(void)
 {
-	return ir_register_map(&iodata_bctv7e_map);
+	return rc_map_register(&iodata_bctv7e_map);
 }
 
 static void __exit exit_rc_map_iodata_bctv7e(void)
 {
-	ir_unregister_map(&iodata_bctv7e_map);
+	rc_map_unregister(&iodata_bctv7e_map);
 }
 
 module_init(init_rc_map_iodata_bctv7e)
diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
index 527ab1b..f31dc5c 100644
--- a/drivers/media/rc/keymaps/rc-kaiomy.c
+++ b/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -61,7 +61,7 @@ static struct rc_map_table kaiomy[] = {
 	{ 0x1f, KEY_BLUE},
 };
 
-static struct rc_keymap kaiomy_map = {
+static struct rc_map_list kaiomy_map = {
 	.map = {
 		.scan    = kaiomy,
 		.size    = ARRAY_SIZE(kaiomy),
@@ -72,12 +72,12 @@ static struct rc_keymap kaiomy_map = {
 
 static int __init init_rc_map_kaiomy(void)
 {
-	return ir_register_map(&kaiomy_map);
+	return rc_map_register(&kaiomy_map);
 }
 
 static void __exit exit_rc_map_kaiomy(void)
 {
-	ir_unregister_map(&kaiomy_map);
+	rc_map_unregister(&kaiomy_map);
 }
 
 module_init(init_rc_map_kaiomy)
diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
index f58703e..3ce6ef7 100644
--- a/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -57,7 +57,7 @@ static struct rc_map_table kworld_315u[] = {
 	{ 0x611f, KEY_BLUE },
 };
 
-static struct rc_keymap kworld_315u_map = {
+static struct rc_map_list kworld_315u_map = {
 	.map = {
 		.scan    = kworld_315u,
 		.size    = ARRAY_SIZE(kworld_315u),
@@ -68,12 +68,12 @@ static struct rc_keymap kworld_315u_map = {
 
 static int __init init_rc_map_kworld_315u(void)
 {
-	return ir_register_map(&kworld_315u_map);
+	return rc_map_register(&kworld_315u_map);
 }
 
 static void __exit exit_rc_map_kworld_315u(void)
 {
-	ir_unregister_map(&kworld_315u_map);
+	rc_map_unregister(&kworld_315u_map);
 }
 
 module_init(init_rc_map_kworld_315u)
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index f6235bb..e45f0b8 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -73,7 +73,7 @@ static struct rc_map_table kworld_plus_tv_analog[] = {
 	{ 0x23, KEY_GREEN},		/* C */
 };
 
-static struct rc_keymap kworld_plus_tv_analog_map = {
+static struct rc_map_list kworld_plus_tv_analog_map = {
 	.map = {
 		.scan    = kworld_plus_tv_analog,
 		.size    = ARRAY_SIZE(kworld_plus_tv_analog),
@@ -84,12 +84,12 @@ static struct rc_keymap kworld_plus_tv_analog_map = {
 
 static int __init init_rc_map_kworld_plus_tv_analog(void)
 {
-	return ir_register_map(&kworld_plus_tv_analog_map);
+	return rc_map_register(&kworld_plus_tv_analog_map);
 }
 
 static void __exit exit_rc_map_kworld_plus_tv_analog(void)
 {
-	ir_unregister_map(&kworld_plus_tv_analog_map);
+	rc_map_unregister(&kworld_plus_tv_analog_map);
 }
 
 module_init(init_rc_map_kworld_plus_tv_analog)
diff --git a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
index e1b8726..8faa54f 100644
--- a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
+++ b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
@@ -73,7 +73,7 @@ static struct rc_map_table leadtek_y04g0051[] = {
 	{ 0x035f, KEY_CHANNELDOWN },
 };
 
-static struct rc_keymap leadtek_y04g0051_map = {
+static struct rc_map_list leadtek_y04g0051_map = {
 	.map = {
 		.scan    = leadtek_y04g0051,
 		.size    = ARRAY_SIZE(leadtek_y04g0051),
@@ -84,12 +84,12 @@ static struct rc_keymap leadtek_y04g0051_map = {
 
 static int __init init_rc_map_leadtek_y04g0051(void)
 {
-	return ir_register_map(&leadtek_y04g0051_map);
+	return rc_map_register(&leadtek_y04g0051_map);
 }
 
 static void __exit exit_rc_map_leadtek_y04g0051(void)
 {
-	ir_unregister_map(&leadtek_y04g0051_map);
+	rc_map_unregister(&leadtek_y04g0051_map);
 }
 
 module_init(init_rc_map_leadtek_y04g0051)
diff --git a/drivers/media/rc/keymaps/rc-lirc.c b/drivers/media/rc/keymaps/rc-lirc.c
index d4dfee7..e8e23e2 100644
--- a/drivers/media/rc/keymaps/rc-lirc.c
+++ b/drivers/media/rc/keymaps/rc-lirc.c
@@ -15,7 +15,7 @@ static struct rc_map_table lirc[] = {
 	{ },
 };
 
-static struct rc_keymap lirc_map = {
+static struct rc_map_list lirc_map = {
 	.map = {
 		.scan    = lirc,
 		.size    = ARRAY_SIZE(lirc),
@@ -26,12 +26,12 @@ static struct rc_keymap lirc_map = {
 
 static int __init init_rc_map_lirc(void)
 {
-	return ir_register_map(&lirc_map);
+	return rc_map_register(&lirc_map);
 }
 
 static void __exit exit_rc_map_lirc(void)
 {
-	ir_unregister_map(&lirc_map);
+	rc_map_unregister(&lirc_map);
 }
 
 module_init(init_rc_map_lirc)
diff --git a/drivers/media/rc/keymaps/rc-lme2510.c b/drivers/media/rc/keymaps/rc-lme2510.c
index eb2d396..875cd81 100644
--- a/drivers/media/rc/keymaps/rc-lme2510.c
+++ b/drivers/media/rc/keymaps/rc-lme2510.c
@@ -42,7 +42,7 @@ static struct rc_map_table lme2510_rc[] = {
 
 };
 
-static struct rc_keymap lme2510_map = {
+static struct rc_map_list lme2510_map = {
 	.map = {
 		.scan    = lme2510_rc,
 		.size    = ARRAY_SIZE(lme2510_rc),
@@ -53,12 +53,12 @@ static struct rc_keymap lme2510_map = {
 
 static int __init init_rc_lme2510_map(void)
 {
-	return ir_register_map(&lme2510_map);
+	return rc_map_register(&lme2510_map);
 }
 
 static void __exit exit_rc_lme2510_map(void)
 {
-	ir_unregister_map(&lme2510_map);
+	rc_map_unregister(&lme2510_map);
 }
 
 module_init(init_rc_lme2510_map)
diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
index b24b082..23b2d04 100644
--- a/drivers/media/rc/keymaps/rc-manli.c
+++ b/drivers/media/rc/keymaps/rc-manli.c
@@ -108,7 +108,7 @@ static struct rc_map_table manli[] = {
 	/* 0x1d unused ? */
 };
 
-static struct rc_keymap manli_map = {
+static struct rc_map_list manli_map = {
 	.map = {
 		.scan    = manli,
 		.size    = ARRAY_SIZE(manli),
@@ -119,12 +119,12 @@ static struct rc_keymap manli_map = {
 
 static int __init init_rc_map_manli(void)
 {
-	return ir_register_map(&manli_map);
+	return rc_map_register(&manli_map);
 }
 
 static void __exit exit_rc_map_manli(void)
 {
-	ir_unregister_map(&manli_map);
+	rc_map_unregister(&manli_map);
 }
 
 module_init(init_rc_map_manli)
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
index 4ad89b7..7b9a01b 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
@@ -41,7 +41,7 @@ static struct rc_map_table msi_digivox_ii[] = {
 	{ 0x001f, KEY_VOLUMEDOWN },
 };
 
-static struct rc_keymap msi_digivox_ii_map = {
+static struct rc_map_list msi_digivox_ii_map = {
 	.map = {
 		.scan    = msi_digivox_ii,
 		.size    = ARRAY_SIZE(msi_digivox_ii),
@@ -52,12 +52,12 @@ static struct rc_keymap msi_digivox_ii_map = {
 
 static int __init init_rc_map_msi_digivox_ii(void)
 {
-	return ir_register_map(&msi_digivox_ii_map);
+	return rc_map_register(&msi_digivox_ii_map);
 }
 
 static void __exit exit_rc_map_msi_digivox_ii(void)
 {
-	ir_unregister_map(&msi_digivox_ii_map);
+	rc_map_unregister(&msi_digivox_ii_map);
 }
 
 module_init(init_rc_map_msi_digivox_ii)
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
index d3304e7..ae9d06b 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
@@ -59,7 +59,7 @@ static struct rc_map_table msi_digivox_iii[] = {
 	{ 0x61d643, KEY_POWER2 },          /* [red power button] */
 };
 
-static struct rc_keymap msi_digivox_iii_map = {
+static struct rc_map_list msi_digivox_iii_map = {
 	.map = {
 		.scan    = msi_digivox_iii,
 		.size    = ARRAY_SIZE(msi_digivox_iii),
@@ -70,12 +70,12 @@ static struct rc_keymap msi_digivox_iii_map = {
 
 static int __init init_rc_map_msi_digivox_iii(void)
 {
-	return ir_register_map(&msi_digivox_iii_map);
+	return rc_map_register(&msi_digivox_iii_map);
 }
 
 static void __exit exit_rc_map_msi_digivox_iii(void)
 {
-	ir_unregister_map(&msi_digivox_iii_map);
+	rc_map_unregister(&msi_digivox_iii_map);
 }
 
 module_init(init_rc_map_msi_digivox_iii)
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
index 51999c4..fa8fd0a 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -97,7 +97,7 @@ static struct rc_map_table msi_tvanywhere_plus[] = {
 	{ 0x1d, KEY_RESTART },		/* Reset */
 };
 
-static struct rc_keymap msi_tvanywhere_plus_map = {
+static struct rc_map_list msi_tvanywhere_plus_map = {
 	.map = {
 		.scan    = msi_tvanywhere_plus,
 		.size    = ARRAY_SIZE(msi_tvanywhere_plus),
@@ -108,12 +108,12 @@ static struct rc_keymap msi_tvanywhere_plus_map = {
 
 static int __init init_rc_map_msi_tvanywhere_plus(void)
 {
-	return ir_register_map(&msi_tvanywhere_plus_map);
+	return rc_map_register(&msi_tvanywhere_plus_map);
 }
 
 static void __exit exit_rc_map_msi_tvanywhere_plus(void)
 {
-	ir_unregister_map(&msi_tvanywhere_plus_map);
+	rc_map_unregister(&msi_tvanywhere_plus_map);
 }
 
 module_init(init_rc_map_msi_tvanywhere_plus)
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
index 619df9d..18b37fa 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
@@ -43,7 +43,7 @@ static struct rc_map_table msi_tvanywhere[] = {
 	{ 0x1f, KEY_VOLUMEDOWN },
 };
 
-static struct rc_keymap msi_tvanywhere_map = {
+static struct rc_map_list msi_tvanywhere_map = {
 	.map = {
 		.scan    = msi_tvanywhere,
 		.size    = ARRAY_SIZE(msi_tvanywhere),
@@ -54,12 +54,12 @@ static struct rc_keymap msi_tvanywhere_map = {
 
 static int __init init_rc_map_msi_tvanywhere(void)
 {
-	return ir_register_map(&msi_tvanywhere_map);
+	return rc_map_register(&msi_tvanywhere_map);
 }
 
 static void __exit exit_rc_map_msi_tvanywhere(void)
 {
-	ir_unregister_map(&msi_tvanywhere_map);
+	rc_map_unregister(&msi_tvanywhere_map);
 }
 
 module_init(init_rc_map_msi_tvanywhere)
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index 8672859..3e6f077 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -70,7 +70,7 @@ static struct rc_map_table nebula[] = {
 	{ 0x36, KEY_PC },
 };
 
-static struct rc_keymap nebula_map = {
+static struct rc_map_list nebula_map = {
 	.map = {
 		.scan    = nebula,
 		.size    = ARRAY_SIZE(nebula),
@@ -81,12 +81,12 @@ static struct rc_keymap nebula_map = {
 
 static int __init init_rc_map_nebula(void)
 {
-	return ir_register_map(&nebula_map);
+	return rc_map_register(&nebula_map);
 }
 
 static void __exit exit_rc_map_nebula(void)
 {
-	ir_unregister_map(&nebula_map);
+	rc_map_unregister(&nebula_map);
 }
 
 module_init(init_rc_map_nebula)
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index 2f560dc..26f114c 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -79,7 +79,7 @@ static struct rc_map_table nec_terratec_cinergy_xs[] = {
 	{ 0x145c, KEY_NEXT},
 };
 
-static struct rc_keymap nec_terratec_cinergy_xs_map = {
+static struct rc_map_list nec_terratec_cinergy_xs_map = {
 	.map = {
 		.scan    = nec_terratec_cinergy_xs,
 		.size    = ARRAY_SIZE(nec_terratec_cinergy_xs),
@@ -90,12 +90,12 @@ static struct rc_keymap nec_terratec_cinergy_xs_map = {
 
 static int __init init_rc_map_nec_terratec_cinergy_xs(void)
 {
-	return ir_register_map(&nec_terratec_cinergy_xs_map);
+	return rc_map_register(&nec_terratec_cinergy_xs_map);
 }
 
 static void __exit exit_rc_map_nec_terratec_cinergy_xs(void)
 {
-	ir_unregister_map(&nec_terratec_cinergy_xs_map);
+	rc_map_unregister(&nec_terratec_cinergy_xs_map);
 }
 
 module_init(init_rc_map_nec_terratec_cinergy_xs)
diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
index f4a8503..629ee9d 100644
--- a/drivers/media/rc/keymaps/rc-norwood.c
+++ b/drivers/media/rc/keymaps/rc-norwood.c
@@ -59,7 +59,7 @@ static struct rc_map_table norwood[] = {
 	{ 0x65, KEY_POWER },		/* Computer power      */
 };
 
-static struct rc_keymap norwood_map = {
+static struct rc_map_list norwood_map = {
 	.map = {
 		.scan    = norwood,
 		.size    = ARRAY_SIZE(norwood),
@@ -70,12 +70,12 @@ static struct rc_keymap norwood_map = {
 
 static int __init init_rc_map_norwood(void)
 {
-	return ir_register_map(&norwood_map);
+	return rc_map_register(&norwood_map);
 }
 
 static void __exit exit_rc_map_norwood(void)
 {
-	ir_unregister_map(&norwood_map);
+	rc_map_unregister(&norwood_map);
 }
 
 module_init(init_rc_map_norwood)
diff --git a/drivers/media/rc/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
index fdfa549..4aa588b 100644
--- a/drivers/media/rc/keymaps/rc-npgtech.c
+++ b/drivers/media/rc/keymaps/rc-npgtech.c
@@ -54,7 +54,7 @@ static struct rc_map_table npgtech[] = {
 
 };
 
-static struct rc_keymap npgtech_map = {
+static struct rc_map_list npgtech_map = {
 	.map = {
 		.scan    = npgtech,
 		.size    = ARRAY_SIZE(npgtech),
@@ -65,12 +65,12 @@ static struct rc_keymap npgtech_map = {
 
 static int __init init_rc_map_npgtech(void)
 {
-	return ir_register_map(&npgtech_map);
+	return rc_map_register(&npgtech_map);
 }
 
 static void __exit exit_rc_map_npgtech(void)
 {
-	ir_unregister_map(&npgtech_map);
+	rc_map_unregister(&npgtech_map);
 }
 
 module_init(init_rc_map_npgtech)
diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
index 86c1101..fa5ae59 100644
--- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -54,7 +54,7 @@ static struct rc_map_table pctv_sedna[] = {
 	{ 0x1f, KEY_PLAY },	/* Play */
 };
 
-static struct rc_keymap pctv_sedna_map = {
+static struct rc_map_list pctv_sedna_map = {
 	.map = {
 		.scan    = pctv_sedna,
 		.size    = ARRAY_SIZE(pctv_sedna),
@@ -65,12 +65,12 @@ static struct rc_keymap pctv_sedna_map = {
 
 static int __init init_rc_map_pctv_sedna(void)
 {
-	return ir_register_map(&pctv_sedna_map);
+	return rc_map_register(&pctv_sedna_map);
 }
 
 static void __exit exit_rc_map_pctv_sedna(void)
 {
-	ir_unregister_map(&pctv_sedna_map);
+	rc_map_unregister(&pctv_sedna_map);
 }
 
 module_init(init_rc_map_pctv_sedna)
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
index d3f4cd4..23b8c50 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-color.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-color.c
@@ -68,7 +68,7 @@ static struct rc_map_table pinnacle_color[] = {
 	{ 0x0a, KEY_BACKSPACE },
 };
 
-static struct rc_keymap pinnacle_color_map = {
+static struct rc_map_list pinnacle_color_map = {
 	.map = {
 		.scan    = pinnacle_color,
 		.size    = ARRAY_SIZE(pinnacle_color),
@@ -79,12 +79,12 @@ static struct rc_keymap pinnacle_color_map = {
 
 static int __init init_rc_map_pinnacle_color(void)
 {
-	return ir_register_map(&pinnacle_color_map);
+	return rc_map_register(&pinnacle_color_map);
 }
 
 static void __exit exit_rc_map_pinnacle_color(void)
 {
-	ir_unregister_map(&pinnacle_color_map);
+	rc_map_unregister(&pinnacle_color_map);
 }
 
 module_init(init_rc_map_pinnacle_color)
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
index 1f48b43..6ba8c36 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-grey.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
@@ -63,7 +63,7 @@ static struct rc_map_table pinnacle_grey[] = {
 	{ 0x18, KEY_EPG },
 };
 
-static struct rc_keymap pinnacle_grey_map = {
+static struct rc_map_list pinnacle_grey_map = {
 	.map = {
 		.scan    = pinnacle_grey,
 		.size    = ARRAY_SIZE(pinnacle_grey),
@@ -74,12 +74,12 @@ static struct rc_keymap pinnacle_grey_map = {
 
 static int __init init_rc_map_pinnacle_grey(void)
 {
-	return ir_register_map(&pinnacle_grey_map);
+	return rc_map_register(&pinnacle_grey_map);
 }
 
 static void __exit exit_rc_map_pinnacle_grey(void)
 {
-	ir_unregister_map(&pinnacle_grey_map);
+	rc_map_unregister(&pinnacle_grey_map);
 }
 
 module_init(init_rc_map_pinnacle_grey)
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
index dc7267c..bb10ffe 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -47,7 +47,7 @@ static struct rc_map_table pinnacle_pctv_hd[] = {
 	{ 0x3f, KEY_EPG },	/* Labeled "?" */
 };
 
-static struct rc_keymap pinnacle_pctv_hd_map = {
+static struct rc_map_list pinnacle_pctv_hd_map = {
 	.map = {
 		.scan    = pinnacle_pctv_hd,
 		.size    = ARRAY_SIZE(pinnacle_pctv_hd),
@@ -58,12 +58,12 @@ static struct rc_keymap pinnacle_pctv_hd_map = {
 
 static int __init init_rc_map_pinnacle_pctv_hd(void)
 {
-	return ir_register_map(&pinnacle_pctv_hd_map);
+	return rc_map_register(&pinnacle_pctv_hd_map);
 }
 
 static void __exit exit_rc_map_pinnacle_pctv_hd(void)
 {
-	ir_unregister_map(&pinnacle_pctv_hd_map);
+	rc_map_unregister(&pinnacle_pctv_hd_map);
 }
 
 module_init(init_rc_map_pinnacle_pctv_hd)
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 93f7248..8d9f664 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -57,7 +57,7 @@ static struct rc_map_table pixelview_mk12[] = {
 	{ 0x866b07, KEY_RADIO },	/* FM */
 };
 
-static struct rc_keymap pixelview_map = {
+static struct rc_map_list pixelview_map = {
 	.map = {
 		.scan    = pixelview_mk12,
 		.size    = ARRAY_SIZE(pixelview_mk12),
@@ -68,12 +68,12 @@ static struct rc_keymap pixelview_map = {
 
 static int __init init_rc_map_pixelview(void)
 {
-	return ir_register_map(&pixelview_map);
+	return rc_map_register(&pixelview_map);
 }
 
 static void __exit exit_rc_map_pixelview(void)
 {
-	ir_unregister_map(&pixelview_map);
+	rc_map_unregister(&pixelview_map);
 }
 
 module_init(init_rc_map_pixelview)
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index e6d60d2..777a700 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -57,7 +57,7 @@ static struct rc_map_table pixelview_new[] = {
 	{ 0x34, KEY_RADIO },
 };
 
-static struct rc_keymap pixelview_new_map = {
+static struct rc_map_list pixelview_new_map = {
 	.map = {
 		.scan    = pixelview_new,
 		.size    = ARRAY_SIZE(pixelview_new),
@@ -68,12 +68,12 @@ static struct rc_keymap pixelview_new_map = {
 
 static int __init init_rc_map_pixelview_new(void)
 {
-	return ir_register_map(&pixelview_new_map);
+	return rc_map_register(&pixelview_new_map);
 }
 
 static void __exit exit_rc_map_pixelview_new(void)
 {
-	ir_unregister_map(&pixelview_new_map);
+	rc_map_unregister(&pixelview_new_map);
 }
 
 module_init(init_rc_map_pixelview_new)
diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
index 2a76710..0ec5988 100644
--- a/drivers/media/rc/keymaps/rc-pixelview.c
+++ b/drivers/media/rc/keymaps/rc-pixelview.c
@@ -56,7 +56,7 @@ static struct rc_map_table pixelview[] = {
 	{ 0x18, KEY_MUTE },		/* mute/unmute */
 };
 
-static struct rc_keymap pixelview_map = {
+static struct rc_map_list pixelview_map = {
 	.map = {
 		.scan    = pixelview,
 		.size    = ARRAY_SIZE(pixelview),
@@ -67,12 +67,12 @@ static struct rc_keymap pixelview_map = {
 
 static int __init init_rc_map_pixelview(void)
 {
-	return ir_register_map(&pixelview_map);
+	return rc_map_register(&pixelview_map);
 }
 
 static void __exit exit_rc_map_pixelview(void)
 {
-	ir_unregister_map(&pixelview_map);
+	rc_map_unregister(&pixelview_map);
 }
 
 module_init(init_rc_map_pixelview)
diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
index 7cc0d57..5f9d546 100644
--- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -55,7 +55,7 @@ static struct rc_map_table powercolor_real_angel[] = {
 	{ 0x25, KEY_POWER },		/* power */
 };
 
-static struct rc_keymap powercolor_real_angel_map = {
+static struct rc_map_list powercolor_real_angel_map = {
 	.map = {
 		.scan    = powercolor_real_angel,
 		.size    = ARRAY_SIZE(powercolor_real_angel),
@@ -66,12 +66,12 @@ static struct rc_keymap powercolor_real_angel_map = {
 
 static int __init init_rc_map_powercolor_real_angel(void)
 {
-	return ir_register_map(&powercolor_real_angel_map);
+	return rc_map_register(&powercolor_real_angel_map);
 }
 
 static void __exit exit_rc_map_powercolor_real_angel(void)
 {
-	ir_unregister_map(&powercolor_real_angel_map);
+	rc_map_unregister(&powercolor_real_angel_map);
 }
 
 module_init(init_rc_map_powercolor_real_angel)
diff --git a/drivers/media/rc/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
index d5e62a5..8a3a643 100644
--- a/drivers/media/rc/keymaps/rc-proteus-2309.c
+++ b/drivers/media/rc/keymaps/rc-proteus-2309.c
@@ -43,7 +43,7 @@ static struct rc_map_table proteus_2309[] = {
 	{ 0x14, KEY_F1 },
 };
 
-static struct rc_keymap proteus_2309_map = {
+static struct rc_map_list proteus_2309_map = {
 	.map = {
 		.scan    = proteus_2309,
 		.size    = ARRAY_SIZE(proteus_2309),
@@ -54,12 +54,12 @@ static struct rc_keymap proteus_2309_map = {
 
 static int __init init_rc_map_proteus_2309(void)
 {
-	return ir_register_map(&proteus_2309_map);
+	return rc_map_register(&proteus_2309_map);
 }
 
 static void __exit exit_rc_map_proteus_2309(void)
 {
-	ir_unregister_map(&proteus_2309_map);
+	rc_map_unregister(&proteus_2309_map);
 }
 
 module_init(init_rc_map_proteus_2309)
diff --git a/drivers/media/rc/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
index 5dbfd91..ef90296 100644
--- a/drivers/media/rc/keymaps/rc-purpletv.c
+++ b/drivers/media/rc/keymaps/rc-purpletv.c
@@ -55,7 +55,7 @@ static struct rc_map_table purpletv[] = {
 
 };
 
-static struct rc_keymap purpletv_map = {
+static struct rc_map_list purpletv_map = {
 	.map = {
 		.scan    = purpletv,
 		.size    = ARRAY_SIZE(purpletv),
@@ -66,12 +66,12 @@ static struct rc_keymap purpletv_map = {
 
 static int __init init_rc_map_purpletv(void)
 {
-	return ir_register_map(&purpletv_map);
+	return rc_map_register(&purpletv_map);
 }
 
 static void __exit exit_rc_map_purpletv(void)
 {
-	ir_unregister_map(&purpletv_map);
+	rc_map_unregister(&purpletv_map);
 }
 
 module_init(init_rc_map_purpletv)
diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
index d9c7e2f..83a418d 100644
--- a/drivers/media/rc/keymaps/rc-pv951.c
+++ b/drivers/media/rc/keymaps/rc-pv951.c
@@ -52,7 +52,7 @@ static struct rc_map_table pv951[] = {
 	{ 0x1c, KEY_MEDIA },		/* PC/TV */
 };
 
-static struct rc_keymap pv951_map = {
+static struct rc_map_list pv951_map = {
 	.map = {
 		.scan    = pv951,
 		.size    = ARRAY_SIZE(pv951),
@@ -63,12 +63,12 @@ static struct rc_keymap pv951_map = {
 
 static int __init init_rc_map_pv951(void)
 {
-	return ir_register_map(&pv951_map);
+	return rc_map_register(&pv951_map);
 }
 
 static void __exit exit_rc_map_pv951(void)
 {
-	ir_unregister_map(&pv951_map);
+	rc_map_unregister(&pv951_map);
 }
 
 module_init(init_rc_map_pv951)
diff --git a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
index eef2e87..df534b0 100644
--- a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
@@ -77,7 +77,7 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 	{ 0x1e3d, KEY_POWER },		/* system power (green button) */
 };
 
-static struct rc_keymap rc5_hauppauge_new_map = {
+static struct rc_map_list rc5_hauppauge_new_map = {
 	.map = {
 		.scan    = rc5_hauppauge_new,
 		.size    = ARRAY_SIZE(rc5_hauppauge_new),
@@ -88,12 +88,12 @@ static struct rc_keymap rc5_hauppauge_new_map = {
 
 static int __init init_rc_map_rc5_hauppauge_new(void)
 {
-	return ir_register_map(&rc5_hauppauge_new_map);
+	return rc_map_register(&rc5_hauppauge_new_map);
 }
 
 static void __exit exit_rc_map_rc5_hauppauge_new(void)
 {
-	ir_unregister_map(&rc5_hauppauge_new_map);
+	rc_map_unregister(&rc5_hauppauge_new_map);
 }
 
 module_init(init_rc_map_rc5_hauppauge_new)
diff --git a/drivers/media/rc/keymaps/rc-rc5-tv.c b/drivers/media/rc/keymaps/rc-rc5-tv.c
index efa1488..4fcef9f 100644
--- a/drivers/media/rc/keymaps/rc-rc5-tv.c
+++ b/drivers/media/rc/keymaps/rc-rc5-tv.c
@@ -55,7 +55,7 @@ static struct rc_map_table rc5_tv[] = {
 
 };
 
-static struct rc_keymap rc5_tv_map = {
+static struct rc_map_list rc5_tv_map = {
 	.map = {
 		.scan    = rc5_tv,
 		.size    = ARRAY_SIZE(rc5_tv),
@@ -66,12 +66,12 @@ static struct rc_keymap rc5_tv_map = {
 
 static int __init init_rc_map_rc5_tv(void)
 {
-	return ir_register_map(&rc5_tv_map);
+	return rc_map_register(&rc5_tv_map);
 }
 
 static void __exit exit_rc_map_rc5_tv(void)
 {
-	ir_unregister_map(&rc5_tv_map);
+	rc_map_unregister(&rc5_tv_map);
 }
 
 module_init(init_rc_map_rc5_tv)
diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index 81f4172..3bf3337 100644
--- a/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -87,7 +87,7 @@ static struct rc_map_table rc6_mce[] = {
 	{ 0x800f0481, KEY_PLAYPAUSE },
 };
 
-static struct rc_keymap rc6_mce_map = {
+static struct rc_map_list rc6_mce_map = {
 	.map = {
 		.scan    = rc6_mce,
 		.size    = ARRAY_SIZE(rc6_mce),
@@ -98,12 +98,12 @@ static struct rc_keymap rc6_mce_map = {
 
 static int __init init_rc_map_rc6_mce(void)
 {
-	return ir_register_map(&rc6_mce_map);
+	return rc_map_register(&rc6_mce_map);
 }
 
 static void __exit exit_rc_map_rc6_mce(void)
 {
-	ir_unregister_map(&rc6_mce_map);
+	rc_map_unregister(&rc6_mce_map);
 }
 
 module_init(init_rc_map_rc6_mce)
diff --git a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
index 884416c..2d14598 100644
--- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -52,7 +52,7 @@ static struct rc_map_table real_audio_220_32_keys[] = {
 
 };
 
-static struct rc_keymap real_audio_220_32_keys_map = {
+static struct rc_map_list real_audio_220_32_keys_map = {
 	.map = {
 		.scan    = real_audio_220_32_keys,
 		.size    = ARRAY_SIZE(real_audio_220_32_keys),
@@ -63,12 +63,12 @@ static struct rc_keymap real_audio_220_32_keys_map = {
 
 static int __init init_rc_map_real_audio_220_32_keys(void)
 {
-	return ir_register_map(&real_audio_220_32_keys_map);
+	return rc_map_register(&real_audio_220_32_keys_map);
 }
 
 static void __exit exit_rc_map_real_audio_220_32_keys(void)
 {
-	ir_unregister_map(&real_audio_220_32_keys_map);
+	rc_map_unregister(&real_audio_220_32_keys_map);
 }
 
 module_init(init_rc_map_real_audio_220_32_keys)
diff --git a/drivers/media/rc/keymaps/rc-streamzap.c b/drivers/media/rc/keymaps/rc-streamzap.c
index 5a86a71..92cc10d 100644
--- a/drivers/media/rc/keymaps/rc-streamzap.c
+++ b/drivers/media/rc/keymaps/rc-streamzap.c
@@ -56,7 +56,7 @@ static struct rc_map_table streamzap[] = {
 
 };
 
-static struct rc_keymap streamzap_map = {
+static struct rc_map_list streamzap_map = {
 	.map = {
 		.scan    = streamzap,
 		.size    = ARRAY_SIZE(streamzap),
@@ -67,12 +67,12 @@ static struct rc_keymap streamzap_map = {
 
 static int __init init_rc_map_streamzap(void)
 {
-	return ir_register_map(&streamzap_map);
+	return rc_map_register(&streamzap_map);
 }
 
 static void __exit exit_rc_map_streamzap(void)
 {
-	ir_unregister_map(&streamzap_map);
+	rc_map_unregister(&streamzap_map);
 }
 
 module_init(init_rc_map_streamzap)
diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
index 6e2f5b5..15b9a9b 100644
--- a/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -47,7 +47,7 @@ static struct rc_map_table tbs_nec[] = {
 	{ 0x1b, KEY_MODE},
 };
 
-static struct rc_keymap tbs_nec_map = {
+static struct rc_map_list tbs_nec_map = {
 	.map = {
 		.scan    = tbs_nec,
 		.size    = ARRAY_SIZE(tbs_nec),
@@ -58,12 +58,12 @@ static struct rc_keymap tbs_nec_map = {
 
 static int __init init_rc_map_tbs_nec(void)
 {
-	return ir_register_map(&tbs_nec_map);
+	return rc_map_register(&tbs_nec_map);
 }
 
 static void __exit exit_rc_map_tbs_nec(void)
 {
-	ir_unregister_map(&tbs_nec_map);
+	rc_map_unregister(&tbs_nec_map);
 }
 
 module_init(init_rc_map_tbs_nec)
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
index 540020a..bc38e34 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
@@ -66,7 +66,7 @@ static struct rc_map_table terratec_cinergy_xs[] = {
 	{ 0x5c, KEY_NEXT},
 };
 
-static struct rc_keymap terratec_cinergy_xs_map = {
+static struct rc_map_list terratec_cinergy_xs_map = {
 	.map = {
 		.scan    = terratec_cinergy_xs,
 		.size    = ARRAY_SIZE(terratec_cinergy_xs),
@@ -77,12 +77,12 @@ static struct rc_keymap terratec_cinergy_xs_map = {
 
 static int __init init_rc_map_terratec_cinergy_xs(void)
 {
-	return ir_register_map(&terratec_cinergy_xs_map);
+	return rc_map_register(&terratec_cinergy_xs_map);
 }
 
 static void __exit exit_rc_map_terratec_cinergy_xs(void)
 {
-	ir_unregister_map(&terratec_cinergy_xs_map);
+	rc_map_unregister(&terratec_cinergy_xs_map);
 }
 
 module_init(init_rc_map_terratec_cinergy_xs)
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim.c b/drivers/media/rc/keymaps/rc-terratec-slim.c
index a1513f0..1abafa5 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim.c
@@ -53,7 +53,7 @@ static struct rc_map_table terratec_slim[] = {
 	{ 0x02bd45, KEY_POWER2 },          /* [red power button] */
 };
 
-static struct rc_keymap terratec_slim_map = {
+static struct rc_map_list terratec_slim_map = {
 	.map = {
 		.scan    = terratec_slim,
 		.size    = ARRAY_SIZE(terratec_slim),
@@ -64,12 +64,12 @@ static struct rc_keymap terratec_slim_map = {
 
 static int __init init_rc_map_terratec_slim(void)
 {
-	return ir_register_map(&terratec_slim_map);
+	return rc_map_register(&terratec_slim_map);
 }
 
 static void __exit exit_rc_map_terratec_slim(void)
 {
-	ir_unregister_map(&terratec_slim_map);
+	rc_map_unregister(&terratec_slim_map);
 }
 
 module_init(init_rc_map_terratec_slim)
diff --git a/drivers/media/rc/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
index 6b2fc43..ef5ba3f 100644
--- a/drivers/media/rc/keymaps/rc-tevii-nec.c
+++ b/drivers/media/rc/keymaps/rc-tevii-nec.c
@@ -62,7 +62,7 @@ static struct rc_map_table tevii_nec[] = {
 	{ 0x58, KEY_SWITCHVIDEOMODE},
 };
 
-static struct rc_keymap tevii_nec_map = {
+static struct rc_map_list tevii_nec_map = {
 	.map = {
 		.scan    = tevii_nec,
 		.size    = ARRAY_SIZE(tevii_nec),
@@ -73,12 +73,12 @@ static struct rc_keymap tevii_nec_map = {
 
 static int __init init_rc_map_tevii_nec(void)
 {
-	return ir_register_map(&tevii_nec_map);
+	return rc_map_register(&tevii_nec_map);
 }
 
 static void __exit exit_rc_map_tevii_nec(void)
 {
-	ir_unregister_map(&tevii_nec_map);
+	rc_map_unregister(&tevii_nec_map);
 }
 
 module_init(init_rc_map_tevii_nec)
diff --git a/drivers/media/rc/keymaps/rc-total-media-in-hand.c b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
index 61a4234..20ac4e1 100644
--- a/drivers/media/rc/keymaps/rc-total-media-in-hand.c
+++ b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
@@ -59,7 +59,7 @@ static struct rc_map_table total_media_in_hand[] = {
 	{ 0x02bd45, KEY_INFO },            /* [red (I)] */
 };
 
-static struct rc_keymap total_media_in_hand_map = {
+static struct rc_map_list total_media_in_hand_map = {
 	.map = {
 		.scan    = total_media_in_hand,
 		.size    = ARRAY_SIZE(total_media_in_hand),
@@ -70,12 +70,12 @@ static struct rc_keymap total_media_in_hand_map = {
 
 static int __init init_rc_map_total_media_in_hand(void)
 {
-	return ir_register_map(&total_media_in_hand_map);
+	return rc_map_register(&total_media_in_hand_map);
 }
 
 static void __exit exit_rc_map_total_media_in_hand(void)
 {
-	ir_unregister_map(&total_media_in_hand_map);
+	rc_map_unregister(&total_media_in_hand_map);
 }
 
 module_init(init_rc_map_total_media_in_hand)
diff --git a/drivers/media/rc/keymaps/rc-trekstor.c b/drivers/media/rc/keymaps/rc-trekstor.c
index 2d7bbf8..f8190ea 100644
--- a/drivers/media/rc/keymaps/rc-trekstor.c
+++ b/drivers/media/rc/keymaps/rc-trekstor.c
@@ -54,7 +54,7 @@ static struct rc_map_table trekstor[] = {
 	{ 0x009f, KEY_LEFT },            /* Left */
 };
 
-static struct rc_keymap trekstor_map = {
+static struct rc_map_list trekstor_map = {
 	.map = {
 		.scan    = trekstor,
 		.size    = ARRAY_SIZE(trekstor),
@@ -65,12 +65,12 @@ static struct rc_keymap trekstor_map = {
 
 static int __init init_rc_map_trekstor(void)
 {
-	return ir_register_map(&trekstor_map);
+	return rc_map_register(&trekstor_map);
 }
 
 static void __exit exit_rc_map_trekstor(void)
 {
-	ir_unregister_map(&trekstor_map);
+	rc_map_unregister(&trekstor_map);
 }
 
 module_init(init_rc_map_trekstor)
diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
index f3fe9f3..bb19487 100644
--- a/drivers/media/rc/keymaps/rc-tt-1500.c
+++ b/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -56,7 +56,7 @@ static struct rc_map_table tt_1500[] = {
 	{ 0x3f, KEY_FORWARD },
 };
 
-static struct rc_keymap tt_1500_map = {
+static struct rc_map_list tt_1500_map = {
 	.map = {
 		.scan    = tt_1500,
 		.size    = ARRAY_SIZE(tt_1500),
@@ -67,12 +67,12 @@ static struct rc_keymap tt_1500_map = {
 
 static int __init init_rc_map_tt_1500(void)
 {
-	return ir_register_map(&tt_1500_map);
+	return rc_map_register(&tt_1500_map);
 }
 
 static void __exit exit_rc_map_tt_1500(void)
 {
-	ir_unregister_map(&tt_1500_map);
+	rc_map_unregister(&tt_1500_map);
 }
 
 module_init(init_rc_map_tt_1500)
diff --git a/drivers/media/rc/keymaps/rc-twinhan1027.c b/drivers/media/rc/keymaps/rc-twinhan1027.c
index 67cc6e0..8bf8df6 100644
--- a/drivers/media/rc/keymaps/rc-twinhan1027.c
+++ b/drivers/media/rc/keymaps/rc-twinhan1027.c
@@ -61,7 +61,7 @@ static struct rc_map_table twinhan_vp1027[] = {
 	{ 0x5f, KEY_BLUE },
 };
 
-static struct rc_keymap twinhan_vp1027_map = {
+static struct rc_map_list twinhan_vp1027_map = {
 	.map = {
 		.scan    = twinhan_vp1027,
 		.size    = ARRAY_SIZE(twinhan_vp1027),
@@ -72,12 +72,12 @@ static struct rc_keymap twinhan_vp1027_map = {
 
 static int __init init_rc_map_twinhan_vp1027(void)
 {
-	return ir_register_map(&twinhan_vp1027_map);
+	return rc_map_register(&twinhan_vp1027_map);
 }
 
 static void __exit exit_rc_map_twinhan_vp1027(void)
 {
-	ir_unregister_map(&twinhan_vp1027_map);
+	rc_map_unregister(&twinhan_vp1027_map);
 }
 
 module_init(init_rc_map_twinhan_vp1027)
diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
index f8a0d10..9e474a6 100644
--- a/drivers/media/rc/keymaps/rc-videomate-s350.c
+++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
@@ -59,7 +59,7 @@ static struct rc_map_table videomate_s350[] = {
 	{ 0x20, KEY_TEXT},
 };
 
-static struct rc_keymap videomate_s350_map = {
+static struct rc_map_list videomate_s350_map = {
 	.map = {
 		.scan    = videomate_s350,
 		.size    = ARRAY_SIZE(videomate_s350),
@@ -70,12 +70,12 @@ static struct rc_keymap videomate_s350_map = {
 
 static int __init init_rc_map_videomate_s350(void)
 {
-	return ir_register_map(&videomate_s350_map);
+	return rc_map_register(&videomate_s350_map);
 }
 
 static void __exit exit_rc_map_videomate_s350(void)
 {
-	ir_unregister_map(&videomate_s350_map);
+	rc_map_unregister(&videomate_s350_map);
 }
 
 module_init(init_rc_map_videomate_s350)
diff --git a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
index 04d1024..5f2a46e 100644
--- a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
+++ b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
@@ -61,7 +61,7 @@ static struct rc_map_table videomate_tv_pvr[] = {
 	{ 0x21, KEY_SLEEP },
 };
 
-static struct rc_keymap videomate_tv_pvr_map = {
+static struct rc_map_list videomate_tv_pvr_map = {
 	.map = {
 		.scan    = videomate_tv_pvr,
 		.size    = ARRAY_SIZE(videomate_tv_pvr),
@@ -72,12 +72,12 @@ static struct rc_keymap videomate_tv_pvr_map = {
 
 static int __init init_rc_map_videomate_tv_pvr(void)
 {
-	return ir_register_map(&videomate_tv_pvr_map);
+	return rc_map_register(&videomate_tv_pvr_map);
 }
 
 static void __exit exit_rc_map_videomate_tv_pvr(void)
 {
-	ir_unregister_map(&videomate_tv_pvr_map);
+	rc_map_unregister(&videomate_tv_pvr_map);
 }
 
 module_init(init_rc_map_videomate_tv_pvr)
diff --git a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
index 78fc7da..bd8d021 100644
--- a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
+++ b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
@@ -56,7 +56,7 @@ static struct rc_map_table winfast_usbii_deluxe[] = {
 
 };
 
-static struct rc_keymap winfast_usbii_deluxe_map = {
+static struct rc_map_list winfast_usbii_deluxe_map = {
 	.map = {
 		.scan    = winfast_usbii_deluxe,
 		.size    = ARRAY_SIZE(winfast_usbii_deluxe),
@@ -67,12 +67,12 @@ static struct rc_keymap winfast_usbii_deluxe_map = {
 
 static int __init init_rc_map_winfast_usbii_deluxe(void)
 {
-	return ir_register_map(&winfast_usbii_deluxe_map);
+	return rc_map_register(&winfast_usbii_deluxe_map);
 }
 
 static void __exit exit_rc_map_winfast_usbii_deluxe(void)
 {
-	ir_unregister_map(&winfast_usbii_deluxe_map);
+	rc_map_unregister(&winfast_usbii_deluxe_map);
 }
 
 module_init(init_rc_map_winfast_usbii_deluxe)
diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
index a8fbd76..2747db4 100644
--- a/drivers/media/rc/keymaps/rc-winfast.c
+++ b/drivers/media/rc/keymaps/rc-winfast.c
@@ -76,7 +76,7 @@ static struct rc_map_table winfast[] = {
 	{ 0x3f, KEY_F24 }		/* MCE -CH,  on Y04G0033 */
 };
 
-static struct rc_keymap winfast_map = {
+static struct rc_map_list winfast_map = {
 	.map = {
 		.scan    = winfast,
 		.size    = ARRAY_SIZE(winfast),
@@ -87,12 +87,12 @@ static struct rc_keymap winfast_map = {
 
 static int __init init_rc_map_winfast(void)
 {
-	return ir_register_map(&winfast_map);
+	return rc_map_register(&winfast_map);
 }
 
 static void __exit exit_rc_map_winfast(void)
 {
-	ir_unregister_map(&winfast_map);
+	rc_map_unregister(&winfast_map);
 }
 
 module_init(init_rc_map_winfast)
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index b989f5d..0b0524c 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -31,9 +31,9 @@
 static LIST_HEAD(rc_map_list);
 static DEFINE_SPINLOCK(rc_map_lock);
 
-static struct rc_keymap *seek_rc_map(const char *name)
+static struct rc_map_list *seek_rc_map(const char *name)
 {
-	struct rc_keymap *map = NULL;
+	struct rc_map_list *map = NULL;
 
 	spin_lock(&rc_map_lock);
 	list_for_each_entry(map, &rc_map_list, list) {
@@ -47,10 +47,10 @@ static struct rc_keymap *seek_rc_map(const char *name)
 	return NULL;
 }
 
-struct rc_map *get_rc_map(const char *name)
+struct rc_map *rc_map_get(const char *name)
 {
 
-	struct rc_keymap *map;
+	struct rc_map_list *map;
 
 	map = seek_rc_map(name);
 #ifdef MODULE
@@ -74,31 +74,31 @@ struct rc_map *get_rc_map(const char *name)
 
 	return &map->map;
 }
-EXPORT_SYMBOL_GPL(get_rc_map);
+EXPORT_SYMBOL_GPL(rc_map_get);
 
-int ir_register_map(struct rc_keymap *map)
+int rc_map_register(struct rc_map_list *map)
 {
 	spin_lock(&rc_map_lock);
 	list_add_tail(&map->list, &rc_map_list);
 	spin_unlock(&rc_map_lock);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ir_register_map);
+EXPORT_SYMBOL_GPL(rc_map_register);
 
-void ir_unregister_map(struct rc_keymap *map)
+void rc_map_unregister(struct rc_map_list *map)
 {
 	spin_lock(&rc_map_lock);
 	list_del(&map->list);
 	spin_unlock(&rc_map_lock);
 }
-EXPORT_SYMBOL_GPL(ir_unregister_map);
+EXPORT_SYMBOL_GPL(rc_map_unregister);
 
 
 static struct rc_map_table empty[] = {
 	{ 0x2a, KEY_COFFEE },
 };
 
-static struct rc_keymap empty_map = {
+static struct rc_map_list empty_map = {
 	.map = {
 		.scan    = empty,
 		.size    = ARRAY_SIZE(empty),
@@ -996,9 +996,9 @@ int rc_register_device(struct rc_dev *dev)
 	if (!dev || !dev->map_name)
 		return -EINVAL;
 
-	rc_map = get_rc_map(dev->map_name);
+	rc_map = rc_map_get(dev->map_name);
 	if (!rc_map)
-		rc_map = get_rc_map(RC_MAP_EMPTY);
+		rc_map = rc_map_get(RC_MAP_EMPTY);
 	if (!rc_map || !rc_map->scan || rc_map->size == 0)
 		return -EINVAL;
 
@@ -1113,7 +1113,7 @@ static int __init rc_core_init(void)
 
 	/* Initialize/load the decoders/keymap code that will be used */
 	ir_raw_init();
-	ir_register_map(&empty_map);
+	rc_map_register(&empty_map);
 
 	return 0;
 }
@@ -1121,7 +1121,7 @@ static int __init rc_core_init(void)
 static void __exit rc_core_exit(void)
 {
 	class_unregister(&ir_input_class);
-	ir_unregister_map(&empty_map);
+	rc_map_unregister(&empty_map);
 }
 
 module_init(rc_core_init);
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 5e9c06a..1a3d51d 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -40,16 +40,16 @@ struct rc_map {
 	spinlock_t		lock;
 };
 
-struct rc_keymap {
+struct rc_map_list {
 	struct list_head	 list;
 	struct rc_map map;
 };
 
 /* Routines from rc-map.c */
 
-int ir_register_map(struct rc_keymap *map);
-void ir_unregister_map(struct rc_keymap *map);
-struct rc_map *get_rc_map(const char *name);
+int rc_map_register(struct rc_map_list *map);
+void rc_map_unregister(struct rc_map_list *map);
+struct rc_map *rc_map_get(const char *name);
 void rc_map_init(void);
 
 /* Names of the several keytables defined in-kernel */
-- 
1.7.1


