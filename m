Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435Ab0DFSSd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:33 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIX9O022123
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:33 -0400
Date: Tue, 6 Apr 2010 15:18:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/26] V4L/DVB: ir-common: re-order keytables by name and
 remove duplicates
Message-ID: <20100406151804.63d7f541@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 800fc98..2e27515 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -112,69 +112,69 @@ void ir_rc5_timer_keyup(unsigned long data);
 #define DECLARE_IR_KEYTABLE(a)					\
 extern struct ir_scancode_table IR_KEYTABLE(a)
 
-DECLARE_IR_KEYTABLE(empty);
+DECLARE_IR_KEYTABLE(adstech_dvb_t_pci);
+DECLARE_IR_KEYTABLE(apac_viewcomp);
+DECLARE_IR_KEYTABLE(asus_pc39);
+DECLARE_IR_KEYTABLE(ati_tv_wonder_hd_600);
 DECLARE_IR_KEYTABLE(avermedia);
+DECLARE_IR_KEYTABLE(avermedia_a16d);
+DECLARE_IR_KEYTABLE(avermedia_cardbus);
 DECLARE_IR_KEYTABLE(avermedia_dvbt);
 DECLARE_IR_KEYTABLE(avermedia_m135a_rm_jx);
-DECLARE_IR_KEYTABLE(avermedia_cardbus);
-DECLARE_IR_KEYTABLE(apac_viewcomp);
-DECLARE_IR_KEYTABLE(pixelview);
-DECLARE_IR_KEYTABLE(pixelview_new);
-DECLARE_IR_KEYTABLE(nebula);
-DECLARE_IR_KEYTABLE(dntv_live_dvb_t);
-DECLARE_IR_KEYTABLE(iodata_bctv7e);
-DECLARE_IR_KEYTABLE(adstech_dvb_t_pci);
-DECLARE_IR_KEYTABLE(msi_tvanywhere);
-DECLARE_IR_KEYTABLE(cinergy_1400);
 DECLARE_IR_KEYTABLE(avertv_303);
+DECLARE_IR_KEYTABLE(behold);
+DECLARE_IR_KEYTABLE(behold_columbus);
+DECLARE_IR_KEYTABLE(budget_ci_old);
+DECLARE_IR_KEYTABLE(cinergy);
+DECLARE_IR_KEYTABLE(cinergy_1400);
+DECLARE_IR_KEYTABLE(dm1105_nec);
+DECLARE_IR_KEYTABLE(dntv_live_dvb_t);
 DECLARE_IR_KEYTABLE(dntv_live_dvbt_pro);
+DECLARE_IR_KEYTABLE(empty);
 DECLARE_IR_KEYTABLE(em_terratec);
-DECLARE_IR_KEYTABLE(pinnacle_grey);
-DECLARE_IR_KEYTABLE(flyvideo);
-DECLARE_IR_KEYTABLE(flydvb);
-DECLARE_IR_KEYTABLE(cinergy);
+DECLARE_IR_KEYTABLE(encore_enltv);
+DECLARE_IR_KEYTABLE(encore_enltv2);
+DECLARE_IR_KEYTABLE(encore_enltv_fm53);
+DECLARE_IR_KEYTABLE(evga_indtube);
 DECLARE_IR_KEYTABLE(eztv);
-DECLARE_IR_KEYTABLE(avermedia);
-DECLARE_IR_KEYTABLE(videomate_tv_pvr);
-DECLARE_IR_KEYTABLE(manli);
+DECLARE_IR_KEYTABLE(flydvb);
+DECLARE_IR_KEYTABLE(flyvideo);
+DECLARE_IR_KEYTABLE(fusionhdtv_mce);
+DECLARE_IR_KEYTABLE(gadmei_rm008z);
+DECLARE_IR_KEYTABLE(genius_tvgo_a11mce);
 DECLARE_IR_KEYTABLE(gotview7135);
-DECLARE_IR_KEYTABLE(purpletv);
-DECLARE_IR_KEYTABLE(pctv_sedna);
-DECLARE_IR_KEYTABLE(pv951);
-DECLARE_IR_KEYTABLE(rc5_tv);
-DECLARE_IR_KEYTABLE(winfast);
-DECLARE_IR_KEYTABLE(pinnacle_color);
 DECLARE_IR_KEYTABLE(hauppauge_new);
-DECLARE_IR_KEYTABLE(rc5_hauppauge_new);
-DECLARE_IR_KEYTABLE(npgtech);
+DECLARE_IR_KEYTABLE(iodata_bctv7e);
+DECLARE_IR_KEYTABLE(kaiomy);
+DECLARE_IR_KEYTABLE(kworld_315u);
+DECLARE_IR_KEYTABLE(kworld_plus_tv_analog);
+DECLARE_IR_KEYTABLE(manli);
+DECLARE_IR_KEYTABLE(msi_tvanywhere);
+DECLARE_IR_KEYTABLE(msi_tvanywhere_plus);
+DECLARE_IR_KEYTABLE(nebula);
+DECLARE_IR_KEYTABLE(nec_terratec_cinergy_xs);
 DECLARE_IR_KEYTABLE(norwood);
-DECLARE_IR_KEYTABLE(proteus_2309);
-DECLARE_IR_KEYTABLE(budget_ci_old);
-DECLARE_IR_KEYTABLE(asus_pc39);
-DECLARE_IR_KEYTABLE(encore_enltv);
-DECLARE_IR_KEYTABLE(encore_enltv2);
-DECLARE_IR_KEYTABLE(tt_1500);
-DECLARE_IR_KEYTABLE(fusionhdtv_mce);
-DECLARE_IR_KEYTABLE(behold);
-DECLARE_IR_KEYTABLE(behold_columbus);
+DECLARE_IR_KEYTABLE(npgtech);
+DECLARE_IR_KEYTABLE(pctv_sedna);
+DECLARE_IR_KEYTABLE(pinnacle_color);
+DECLARE_IR_KEYTABLE(pinnacle_grey);
 DECLARE_IR_KEYTABLE(pinnacle_pctv_hd);
-DECLARE_IR_KEYTABLE(genius_tvgo_a11mce);
+DECLARE_IR_KEYTABLE(pixelview);
+DECLARE_IR_KEYTABLE(pixelview_new);
 DECLARE_IR_KEYTABLE(powercolor_real_angel);
-DECLARE_IR_KEYTABLE(avermedia_a16d);
-DECLARE_IR_KEYTABLE(encore_enltv_fm53);
+DECLARE_IR_KEYTABLE(proteus_2309);
+DECLARE_IR_KEYTABLE(purpletv);
+DECLARE_IR_KEYTABLE(pv951);
+DECLARE_IR_KEYTABLE(rc5_hauppauge_new);
+DECLARE_IR_KEYTABLE(rc5_tv);
 DECLARE_IR_KEYTABLE(real_audio_220_32_keys);
-DECLARE_IR_KEYTABLE(msi_tvanywhere_plus);
-DECLARE_IR_KEYTABLE(ati_tv_wonder_hd_600);
-DECLARE_IR_KEYTABLE(kworld_plus_tv_analog);
-DECLARE_IR_KEYTABLE(kaiomy);
-DECLARE_IR_KEYTABLE(dm1105_nec);
-DECLARE_IR_KEYTABLE(tevii_nec);
 DECLARE_IR_KEYTABLE(tbs_nec);
-DECLARE_IR_KEYTABLE(evga_indtube);
 DECLARE_IR_KEYTABLE(terratec_cinergy_xs);
+DECLARE_IR_KEYTABLE(tevii_nec);
+DECLARE_IR_KEYTABLE(tt_1500);
 DECLARE_IR_KEYTABLE(videomate_s350);
-DECLARE_IR_KEYTABLE(gadmei_rm008z);
-DECLARE_IR_KEYTABLE(nec_terratec_cinergy_xs);
+DECLARE_IR_KEYTABLE(videomate_tv_pvr);
+DECLARE_IR_KEYTABLE(winfast);
 DECLARE_IR_KEYTABLE(winfast_usbii_deluxe);
-DECLARE_IR_KEYTABLE(kworld_315u);
+
 #endif
-- 
1.6.6.1


