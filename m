Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49621 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729830AbeGMOpI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 10:45:08 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>,
        VDR User <user.vdr@gmail.com>
Subject: [PATCH v3 4/5] keytable: convert keymaps to new toml format
Date: Fri, 13 Jul 2018 15:30:10 +0100
Message-Id: <51e8f72d1ae568e621aa1824112c39566a4e8b62.1531491416.git.sean@mess.org>
In-Reply-To: <cover.1531491415.git.sean@mess.org>
References: <cover.1531491415.git.sean@mess.org>
In-Reply-To: <cover.1531491415.git.sean@mess.org>
References: <cover.1531491415.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert all the existing keymaps to toml, so that only one format is used.

Include the protocol variant as well. This will be useful in the future if
we want to use rc keymaps for transmitting IR.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/gen_keytables.pl               |  33 ++-
 utils/keytable/ir-keytable.1.in               |   4 +-
 utils/keytable/rc_keymaps/adstech_dvb_t_pci   |  45 ---
 .../rc_keymaps/adstech_dvb_t_pci.toml         |  48 ++++
 utils/keytable/rc_keymaps/af9005              |  37 ---
 utils/keytable/rc_keymaps/af9005.toml         |  40 +++
 utils/keytable/rc_keymaps/alink_dtu_m         |  19 --
 utils/keytable/rc_keymaps/alink_dtu_m.toml    |  23 ++
 .../keytable/rc_keymaps/allwinner_ba10_tv_box |  15 -
 .../rc_keymaps/allwinner_i12_a20_tv_box       |  28 --
 utils/keytable/rc_keymaps/anysee              |  45 ---
 utils/keytable/rc_keymaps/anysee.toml         |  49 ++++
 utils/keytable/rc_keymaps/apac_viewcomp       |  32 ---
 utils/keytable/rc_keymaps/apac_viewcomp.toml  |  35 +++
 utils/keytable/rc_keymaps/astrometa_t2hybrid  |  22 --
 .../rc_keymaps/astrometa_t2hybrid.toml        |  26 ++
 utils/keytable/rc_keymaps/asus_pc39           |  40 ---
 utils/keytable/rc_keymaps/asus_pc39.toml      |  44 +++
 utils/keytable/rc_keymaps/asus_ps3_100        |  42 ---
 utils/keytable/rc_keymaps/asus_ps3_100.toml   |  46 +++
 .../keytable/rc_keymaps/ati_tv_wonder_hd_600  |  25 --
 .../rc_keymaps/ati_tv_wonder_hd_600.toml      |  28 ++
 utils/keytable/rc_keymaps/ati_x10             |  49 ----
 utils/keytable/rc_keymaps/ati_x10.toml        |  52 ++++
 utils/keytable/rc_keymaps/avermedia           |  37 ---
 utils/keytable/rc_keymaps/avermedia.toml      |  40 +++
 utils/keytable/rc_keymaps/avermedia_a16d      |  35 ---
 utils/keytable/rc_keymaps/avermedia_a16d.toml |  38 +++
 utils/keytable/rc_keymaps/avermedia_cardbus   |  55 ----
 .../rc_keymaps/avermedia_cardbus.toml         |  58 ++++
 utils/keytable/rc_keymaps/avermedia_dvbt      |  35 ---
 utils/keytable/rc_keymaps/avermedia_dvbt.toml |  38 +++
 utils/keytable/rc_keymaps/avermedia_m135a     |  81 ------
 .../keytable/rc_keymaps/avermedia_m135a.toml  |  85 ++++++
 .../keytable/rc_keymaps/avermedia_m733a_rm_k6 |  45 ---
 .../rc_keymaps/avermedia_m733a_rm_k6.toml     |  49 ++++
 utils/keytable/rc_keymaps/avermedia_rm_ks     |  28 --
 .../keytable/rc_keymaps/avermedia_rm_ks.toml  |  32 +++
 utils/keytable/rc_keymaps/avertv_303          |  37 ---
 utils/keytable/rc_keymaps/avertv_303.toml     |  40 +++
 utils/keytable/rc_keymaps/az6027              |   3 -
 utils/keytable/rc_keymaps/az6027.toml         |   6 +
 utils/keytable/rc_keymaps/azurewave_ad_tu700  |  54 ----
 .../rc_keymaps/azurewave_ad_tu700.toml        |  58 ++++
 utils/keytable/rc_keymaps/behold              |  35 ---
 utils/keytable/rc_keymaps/behold.toml         |  39 +++
 utils/keytable/rc_keymaps/behold_columbus     |  29 --
 .../keytable/rc_keymaps/behold_columbus.toml  |  32 +++
 utils/keytable/rc_keymaps/budget_ci_old       |  46 ---
 utils/keytable/rc_keymaps/budget_ci_old.toml  |  49 ++++
 utils/keytable/rc_keymaps/cec                 |  98 -------
 utils/keytable/rc_keymaps/cec.toml            | 101 +++++++
 utils/keytable/rc_keymaps/cinergy             |  37 ---
 utils/keytable/rc_keymaps/cinergy.toml        |  40 +++
 utils/keytable/rc_keymaps/cinergy_1400        |  38 ---
 utils/keytable/rc_keymaps/cinergy_1400.toml   |  41 +++
 utils/keytable/rc_keymaps/cinergyt2           |  38 ---
 utils/keytable/rc_keymaps/cinergyt2.toml      |  41 +++
 utils/keytable/rc_keymaps/d680_dmb            |  36 ---
 utils/keytable/rc_keymaps/d680_dmb.toml       |  39 +++
 utils/keytable/rc_keymaps/delock_61959        |  33 ---
 utils/keytable/rc_keymaps/delock_61959.toml   |  37 +++
 utils/keytable/rc_keymaps/dib0700_nec         |  71 -----
 utils/keytable/rc_keymaps/dib0700_nec.toml    |  75 +++++
 utils/keytable/rc_keymaps/dib0700_rc5         | 181 ------------
 utils/keytable/rc_keymaps/dib0700_rc5.toml    | 185 ++++++++++++
 utils/keytable/rc_keymaps/dibusb              | 112 --------
 utils/keytable/rc_keymaps/dibusb.toml         | 115 ++++++++
 utils/keytable/rc_keymaps/digitalnow_tinytwin |  50 ----
 .../rc_keymaps/digitalnow_tinytwin.toml       |  54 ++++
 utils/keytable/rc_keymaps/digittrade          |  29 --
 utils/keytable/rc_keymaps/digittrade.toml     |  33 +++
 utils/keytable/rc_keymaps/digitv              |  56 ----
 utils/keytable/rc_keymaps/digitv.toml         |  59 ++++
 utils/keytable/rc_keymaps/dm1105_nec          |  32 ---
 utils/keytable/rc_keymaps/dm1105_nec.toml     |  35 +++
 utils/keytable/rc_keymaps/dntv_live_dvb_t     |  33 ---
 .../keytable/rc_keymaps/dntv_live_dvb_t.toml  |  36 +++
 utils/keytable/rc_keymaps/dntv_live_dvbt_pro  |  54 ----
 .../rc_keymaps/dntv_live_dvbt_pro.toml        |  57 ++++
 utils/keytable/rc_keymaps/dtt200u             |  19 --
 utils/keytable/rc_keymaps/dtt200u.toml        |  23 ++
 utils/keytable/rc_keymaps/dvbsky              |  33 ---
 utils/keytable/rc_keymaps/dvbsky.toml         |  37 +++
 utils/keytable/rc_keymaps/dvico_mce           |  46 ---
 utils/keytable/rc_keymaps/dvico_mce.toml      |  50 ++++
 utils/keytable/rc_keymaps/dvico_portable      |  37 ---
 utils/keytable/rc_keymaps/dvico_portable.toml |  41 +++
 utils/keytable/rc_keymaps/em_terratec         |  29 --
 utils/keytable/rc_keymaps/em_terratec.toml    |  32 +++
 utils/keytable/rc_keymaps/encore_enltv        |  53 ----
 utils/keytable/rc_keymaps/encore_enltv.toml   |  56 ++++
 utils/keytable/rc_keymaps/encore_enltv2       |  40 ---
 utils/keytable/rc_keymaps/encore_enltv2.toml  |  43 +++
 utils/keytable/rc_keymaps/encore_enltv_fm53   |  30 --
 .../rc_keymaps/encore_enltv_fm53.toml         |  33 +++
 utils/keytable/rc_keymaps/evga_indtube        |  17 --
 utils/keytable/rc_keymaps/evga_indtube.toml   |  20 ++
 utils/keytable/rc_keymaps/eztv                |  45 ---
 utils/keytable/rc_keymaps/eztv.toml           |  48 ++++
 utils/keytable/rc_keymaps/flydvb              |  33 ---
 utils/keytable/rc_keymaps/flydvb.toml         |  36 +++
 utils/keytable/rc_keymaps/flyvideo            |  28 --
 utils/keytable/rc_keymaps/flyvideo.toml       |  31 ++
 utils/keytable/rc_keymaps/fusionhdtv_mce      |  46 ---
 utils/keytable/rc_keymaps/fusionhdtv_mce.toml |  49 ++++
 utils/keytable/rc_keymaps/gadmei_rm008z       |  32 ---
 utils/keytable/rc_keymaps/gadmei_rm008z.toml  |  35 +++
 utils/keytable/rc_keymaps/geekbox             |  13 -
 utils/keytable/rc_keymaps/geekbox.toml        |  17 ++
 utils/keytable/rc_keymaps/genius_tvgo_a11mce  |  33 ---
 .../rc_keymaps/genius_tvgo_a11mce.toml        |  36 +++
 utils/keytable/rc_keymaps/gotview7135         |  35 ---
 utils/keytable/rc_keymaps/gotview7135.toml    |  38 +++
 utils/keytable/rc_keymaps/haupp               |  46 ---
 utils/keytable/rc_keymaps/haupp.toml          |  49 ++++
 utils/keytable/rc_keymaps/hauppauge           | 173 -----------
 utils/keytable/rc_keymaps/hauppauge.toml      | 177 ++++++++++++
 utils/keytable/rc_keymaps/hisi_poplar         |  30 --
 utils/keytable/rc_keymaps/hisi_poplar.toml    |  34 +++
 utils/keytable/rc_keymaps/hisi_tv_demo        |  42 ---
 utils/keytable/rc_keymaps/hisi_tv_demo.toml   |  46 +++
 utils/keytable/rc_keymaps/imon_mce            |  78 -----
 utils/keytable/rc_keymaps/imon_mce.toml       |  82 ++++++
 utils/keytable/rc_keymaps/imon_pad            |  91 ------
 utils/keytable/rc_keymaps/imon_pad.toml       |  94 ++++++
 utils/keytable/rc_keymaps/imon_rsc            |  44 ---
 utils/keytable/rc_keymaps/imon_rsc.toml       |  48 ++++
 utils/keytable/rc_keymaps/iodata_bctv7e       |  37 ---
 utils/keytable/rc_keymaps/iodata_bctv7e.toml  |  40 +++
 utils/keytable/rc_keymaps/it913x_v1           |  53 ----
 utils/keytable/rc_keymaps/it913x_v1.toml      |  57 ++++
 utils/keytable/rc_keymaps/it913x_v2           |  48 ----
 utils/keytable/rc_keymaps/it913x_v2.toml      |  52 ++++
 utils/keytable/rc_keymaps/kaiomy              |  33 ---
 utils/keytable/rc_keymaps/kaiomy.toml         |  36 +++
 utils/keytable/rc_keymaps/kworld_315u         |  33 ---
 utils/keytable/rc_keymaps/kworld_315u.toml    |  37 +++
 utils/keytable/rc_keymaps/kworld_pc150u       |  45 ---
 utils/keytable/rc_keymaps/kworld_pc150u.toml  |  48 ++++
 .../keytable/rc_keymaps/kworld_plus_tv_analog |  32 ---
 .../rc_keymaps/kworld_plus_tv_analog.toml     |  35 +++
 utils/keytable/rc_keymaps/leadtek_y04g0051    |  51 ----
 .../keytable/rc_keymaps/leadtek_y04g0051.toml |  55 ++++
 utils/keytable/rc_keymaps/lme2510             |  67 -----
 utils/keytable/rc_keymaps/lme2510.toml        |  71 +++++
 utils/keytable/rc_keymaps/manli               |  32 ---
 utils/keytable/rc_keymaps/manli.toml          |  35 +++
 utils/keytable/rc_keymaps/medion_x10          |  54 ----
 utils/keytable/rc_keymaps/medion_x10.toml     |  57 ++++
 .../keytable/rc_keymaps/medion_x10_digitainer |  50 ----
 .../rc_keymaps/medion_x10_digitainer.toml     |  53 ++++
 utils/keytable/rc_keymaps/medion_x10_or2x     |  46 ---
 .../keytable/rc_keymaps/medion_x10_or2x.toml  |  49 ++++
 utils/keytable/rc_keymaps/megasky             |  17 --
 utils/keytable/rc_keymaps/megasky.toml        |  20 ++
 utils/keytable/rc_keymaps/msi_digivox_ii      |  19 --
 utils/keytable/rc_keymaps/msi_digivox_ii.toml |  23 ++
 utils/keytable/rc_keymaps/msi_digivox_iii     |  33 ---
 .../keytable/rc_keymaps/msi_digivox_iii.toml  |  37 +++
 utils/keytable/rc_keymaps/msi_tvanywhere      |  25 --
 utils/keytable/rc_keymaps/msi_tvanywhere.toml |  28 ++
 utils/keytable/rc_keymaps/msi_tvanywhere_plus |  37 ---
 .../rc_keymaps/msi_tvanywhere_plus.toml       |  40 +++
 utils/keytable/rc_keymaps/nebula              |  56 ----
 utils/keytable/rc_keymaps/nebula.toml         |  60 ++++
 .../rc_keymaps/nec_terratec_cinergy_xs        |  86 ------
 .../rc_keymaps/nec_terratec_cinergy_xs.toml   |  90 ++++++
 utils/keytable/rc_keymaps/norwood             |  36 ---
 utils/keytable/rc_keymaps/norwood.toml        |  39 +++
 utils/keytable/rc_keymaps/npgtech             |  36 ---
 utils/keytable/rc_keymaps/npgtech.toml        |  39 +++
 utils/keytable/rc_keymaps/opera1              |  27 --
 utils/keytable/rc_keymaps/opera1.toml         |  30 ++
 utils/keytable/rc_keymaps/pctv_sedna          |  33 ---
 utils/keytable/rc_keymaps/pctv_sedna.toml     |  36 +++
 utils/keytable/rc_keymaps/pinnacle310e        |  54 ----
 utils/keytable/rc_keymaps/pinnacle310e.toml   |  57 ++++
 utils/keytable/rc_keymaps/pinnacle_color      |  43 ---
 utils/keytable/rc_keymaps/pinnacle_color.toml |  46 +++
 utils/keytable/rc_keymaps/pinnacle_grey       |  42 ---
 utils/keytable/rc_keymaps/pinnacle_grey.toml  |  45 +++
 utils/keytable/rc_keymaps/pinnacle_pctv_hd    |  27 --
 .../keytable/rc_keymaps/pinnacle_pctv_hd.toml |  31 ++
 utils/keytable/rc_keymaps/pixelview           |  33 ---
 utils/keytable/rc_keymaps/pixelview.toml      |  36 +++
 utils/keytable/rc_keymaps/pixelview_002t      |  27 --
 utils/keytable/rc_keymaps/pixelview_002t.toml |  31 ++
 utils/keytable/rc_keymaps/pixelview_mk12      |  32 ---
 utils/keytable/rc_keymaps/pixelview_mk12.toml |  36 +++
 utils/keytable/rc_keymaps/pixelview_new       |  32 ---
 utils/keytable/rc_keymaps/pixelview_new.toml  |  35 +++
 .../keytable/rc_keymaps/powercolor_real_angel |  36 ---
 .../rc_keymaps/powercolor_real_angel.toml     |  39 +++
 utils/keytable/rc_keymaps/proteus_2309        |  25 --
 utils/keytable/rc_keymaps/proteus_2309.toml   |  28 ++
 utils/keytable/rc_keymaps/purpletv            |  36 ---
 utils/keytable/rc_keymaps/purpletv.toml       |  39 +++
 utils/keytable/rc_keymaps/pv951               |  32 ---
 utils/keytable/rc_keymaps/pv951.toml          |  35 +++
 utils/keytable/rc_keymaps/rc6_mce             |  65 -----
 utils/keytable/rc_keymaps/rc6_mce.toml        |  69 +++++
 .../rc_keymaps/real_audio_220_32_keys         |  29 --
 .../rc_keymaps/real_audio_220_32_keys.toml    |  32 +++
 utils/keytable/rc_keymaps/reddo               |  24 --
 utils/keytable/rc_keymaps/reddo.toml          |  28 ++
 utils/keytable/rc_keymaps/snapstream_firefly  |  49 ----
 .../rc_keymaps/snapstream_firefly.toml        |  52 ++++
 utils/keytable/rc_keymaps/streamzap           |  36 ---
 utils/keytable/rc_keymaps/streamzap.toml      |  39 +++
 utils/keytable/rc_keymaps/su3000              |  36 ---
 utils/keytable/rc_keymaps/su3000.toml         |  40 +++
 utils/keytable/rc_keymaps/tango               |  51 ----
 utils/keytable/rc_keymaps/tango.toml          |  55 ++++
 utils/keytable/rc_keymaps/tbs_nec             |  35 ---
 utils/keytable/rc_keymaps/tbs_nec.toml        |  38 +++
 utils/keytable/rc_keymaps/technisat_ts35      |  34 ---
 utils/keytable/rc_keymaps/technisat_ts35.toml |  37 +++
 utils/keytable/rc_keymaps/technisat_usb2      |  34 ---
 utils/keytable/rc_keymaps/technisat_usb2.toml |  38 +++
 .../rc_keymaps/terratec_cinergy_c_pci         |  49 ----
 .../rc_keymaps/terratec_cinergy_c_pci.toml    |  52 ++++
 .../rc_keymaps/terratec_cinergy_s2_hd         |  49 ----
 .../rc_keymaps/terratec_cinergy_s2_hd.toml    |  52 ++++
 utils/keytable/rc_keymaps/terratec_cinergy_xs |  48 ----
 .../rc_keymaps/terratec_cinergy_xs.toml       |  51 ++++
 utils/keytable/rc_keymaps/terratec_slim       |  29 --
 utils/keytable/rc_keymaps/terratec_slim.toml  |  33 +++
 utils/keytable/rc_keymaps/terratec_slim_2     |  19 --
 .../keytable/rc_keymaps/terratec_slim_2.toml  |  23 ++
 utils/keytable/rc_keymaps/tevii_nec           |  48 ----
 utils/keytable/rc_keymaps/tevii_nec.toml      |  51 ++++
 utils/keytable/rc_keymaps/tivo                |  46 ---
 utils/keytable/rc_keymaps/tivo.toml           |  50 ++++
 utils/keytable/rc_keymaps/total_media_in_hand |  36 ---
 .../rc_keymaps/total_media_in_hand.toml       |  40 +++
 .../rc_keymaps/total_media_in_hand_02         |  36 ---
 .../rc_keymaps/total_media_in_hand_02.toml    |  40 +++
 utils/keytable/rc_keymaps/trekstor            |  29 --
 utils/keytable/rc_keymaps/trekstor.toml       |  33 +++
 utils/keytable/rc_keymaps/tt_1500             |  40 ---
 utils/keytable/rc_keymaps/tt_1500.toml        |  44 +++
 utils/keytable/rc_keymaps/tvwalkertwin        |  18 --
 utils/keytable/rc_keymaps/tvwalkertwin.toml   |  21 ++
 utils/keytable/rc_keymaps/twinhan_dtv_cab_ci  |  54 ----
 .../rc_keymaps/twinhan_dtv_cab_ci.toml        |  57 ++++
 utils/keytable/rc_keymaps/twinhan_vp1027_dvbs |  54 ----
 .../rc_keymaps/twinhan_vp1027_dvbs.toml       |  58 ++++
 utils/keytable/rc_keymaps/videomate_k100      |  52 ----
 utils/keytable/rc_keymaps/videomate_k100.toml |  55 ++++
 utils/keytable/rc_keymaps/videomate_s350      |  45 ---
 utils/keytable/rc_keymaps/videomate_s350.toml |  48 ++++
 utils/keytable/rc_keymaps/videomate_tv_pvr    |  38 ---
 .../keytable/rc_keymaps/videomate_tv_pvr.toml |  41 +++
 utils/keytable/rc_keymaps/vp702x              |   3 -
 utils/keytable/rc_keymaps/vp702x.toml         |   6 +
 utils/keytable/rc_keymaps/winfast             |  57 ----
 utils/keytable/rc_keymaps/winfast.toml        |  60 ++++
 .../keytable/rc_keymaps/winfast_usbii_deluxe  |  29 --
 .../rc_keymaps/winfast_usbii_deluxe.toml      |  32 +++
 utils/keytable/rc_keymaps/wobo_i5             |   9 -
 utils/keytable/rc_keymaps/zx_irdec            |  41 ---
 utils/keytable/rc_keymaps/zx_irdec.toml       |  45 +++
 .../allwinner_ba10_tv_box                     |  15 -
 .../allwinner_ba10_tv_box.toml                |  18 ++
 .../allwinner_i12_a20_tv_box                  |  28 --
 .../allwinner_i12_a20_tv_box.toml             |  31 ++
 utils/keytable/rc_keymaps_userspace/wobo_i5   |   9 -
 .../rc_keymaps_userspace/wobo_i5.toml         |  12 +
 utils/keytable/rc_maps.cfg                    | 268 +++++++++---------
 270 files changed, 6121 insertions(+), 5717 deletions(-)
 delete mode 100644 utils/keytable/rc_keymaps/adstech_dvb_t_pci
 create mode 100644 utils/keytable/rc_keymaps/adstech_dvb_t_pci.toml
 delete mode 100644 utils/keytable/rc_keymaps/af9005
 create mode 100644 utils/keytable/rc_keymaps/af9005.toml
 delete mode 100644 utils/keytable/rc_keymaps/alink_dtu_m
 create mode 100644 utils/keytable/rc_keymaps/alink_dtu_m.toml
 delete mode 100644 utils/keytable/rc_keymaps/allwinner_ba10_tv_box
 delete mode 100644 utils/keytable/rc_keymaps/allwinner_i12_a20_tv_box
 delete mode 100644 utils/keytable/rc_keymaps/anysee
 create mode 100644 utils/keytable/rc_keymaps/anysee.toml
 delete mode 100644 utils/keytable/rc_keymaps/apac_viewcomp
 create mode 100644 utils/keytable/rc_keymaps/apac_viewcomp.toml
 delete mode 100644 utils/keytable/rc_keymaps/astrometa_t2hybrid
 create mode 100644 utils/keytable/rc_keymaps/astrometa_t2hybrid.toml
 delete mode 100644 utils/keytable/rc_keymaps/asus_pc39
 create mode 100644 utils/keytable/rc_keymaps/asus_pc39.toml
 delete mode 100644 utils/keytable/rc_keymaps/asus_ps3_100
 create mode 100644 utils/keytable/rc_keymaps/asus_ps3_100.toml
 delete mode 100644 utils/keytable/rc_keymaps/ati_tv_wonder_hd_600
 create mode 100644 utils/keytable/rc_keymaps/ati_tv_wonder_hd_600.toml
 delete mode 100644 utils/keytable/rc_keymaps/ati_x10
 create mode 100644 utils/keytable/rc_keymaps/ati_x10.toml
 delete mode 100644 utils/keytable/rc_keymaps/avermedia
 create mode 100644 utils/keytable/rc_keymaps/avermedia.toml
 delete mode 100644 utils/keytable/rc_keymaps/avermedia_a16d
 create mode 100644 utils/keytable/rc_keymaps/avermedia_a16d.toml
 delete mode 100644 utils/keytable/rc_keymaps/avermedia_cardbus
 create mode 100644 utils/keytable/rc_keymaps/avermedia_cardbus.toml
 delete mode 100644 utils/keytable/rc_keymaps/avermedia_dvbt
 create mode 100644 utils/keytable/rc_keymaps/avermedia_dvbt.toml
 delete mode 100644 utils/keytable/rc_keymaps/avermedia_m135a
 create mode 100644 utils/keytable/rc_keymaps/avermedia_m135a.toml
 delete mode 100644 utils/keytable/rc_keymaps/avermedia_m733a_rm_k6
 create mode 100644 utils/keytable/rc_keymaps/avermedia_m733a_rm_k6.toml
 delete mode 100644 utils/keytable/rc_keymaps/avermedia_rm_ks
 create mode 100644 utils/keytable/rc_keymaps/avermedia_rm_ks.toml
 delete mode 100644 utils/keytable/rc_keymaps/avertv_303
 create mode 100644 utils/keytable/rc_keymaps/avertv_303.toml
 delete mode 100644 utils/keytable/rc_keymaps/az6027
 create mode 100644 utils/keytable/rc_keymaps/az6027.toml
 delete mode 100644 utils/keytable/rc_keymaps/azurewave_ad_tu700
 create mode 100644 utils/keytable/rc_keymaps/azurewave_ad_tu700.toml
 delete mode 100644 utils/keytable/rc_keymaps/behold
 create mode 100644 utils/keytable/rc_keymaps/behold.toml
 delete mode 100644 utils/keytable/rc_keymaps/behold_columbus
 create mode 100644 utils/keytable/rc_keymaps/behold_columbus.toml
 delete mode 100644 utils/keytable/rc_keymaps/budget_ci_old
 create mode 100644 utils/keytable/rc_keymaps/budget_ci_old.toml
 delete mode 100644 utils/keytable/rc_keymaps/cec
 create mode 100644 utils/keytable/rc_keymaps/cec.toml
 delete mode 100644 utils/keytable/rc_keymaps/cinergy
 create mode 100644 utils/keytable/rc_keymaps/cinergy.toml
 delete mode 100644 utils/keytable/rc_keymaps/cinergy_1400
 create mode 100644 utils/keytable/rc_keymaps/cinergy_1400.toml
 delete mode 100644 utils/keytable/rc_keymaps/cinergyt2
 create mode 100644 utils/keytable/rc_keymaps/cinergyt2.toml
 delete mode 100644 utils/keytable/rc_keymaps/d680_dmb
 create mode 100644 utils/keytable/rc_keymaps/d680_dmb.toml
 delete mode 100644 utils/keytable/rc_keymaps/delock_61959
 create mode 100644 utils/keytable/rc_keymaps/delock_61959.toml
 delete mode 100644 utils/keytable/rc_keymaps/dib0700_nec
 create mode 100644 utils/keytable/rc_keymaps/dib0700_nec.toml
 delete mode 100644 utils/keytable/rc_keymaps/dib0700_rc5
 create mode 100644 utils/keytable/rc_keymaps/dib0700_rc5.toml
 delete mode 100644 utils/keytable/rc_keymaps/dibusb
 create mode 100644 utils/keytable/rc_keymaps/dibusb.toml
 delete mode 100644 utils/keytable/rc_keymaps/digitalnow_tinytwin
 create mode 100644 utils/keytable/rc_keymaps/digitalnow_tinytwin.toml
 delete mode 100644 utils/keytable/rc_keymaps/digittrade
 create mode 100644 utils/keytable/rc_keymaps/digittrade.toml
 delete mode 100644 utils/keytable/rc_keymaps/digitv
 create mode 100644 utils/keytable/rc_keymaps/digitv.toml
 delete mode 100644 utils/keytable/rc_keymaps/dm1105_nec
 create mode 100644 utils/keytable/rc_keymaps/dm1105_nec.toml
 delete mode 100644 utils/keytable/rc_keymaps/dntv_live_dvb_t
 create mode 100644 utils/keytable/rc_keymaps/dntv_live_dvb_t.toml
 delete mode 100644 utils/keytable/rc_keymaps/dntv_live_dvbt_pro
 create mode 100644 utils/keytable/rc_keymaps/dntv_live_dvbt_pro.toml
 delete mode 100644 utils/keytable/rc_keymaps/dtt200u
 create mode 100644 utils/keytable/rc_keymaps/dtt200u.toml
 delete mode 100644 utils/keytable/rc_keymaps/dvbsky
 create mode 100644 utils/keytable/rc_keymaps/dvbsky.toml
 delete mode 100644 utils/keytable/rc_keymaps/dvico_mce
 create mode 100644 utils/keytable/rc_keymaps/dvico_mce.toml
 delete mode 100644 utils/keytable/rc_keymaps/dvico_portable
 create mode 100644 utils/keytable/rc_keymaps/dvico_portable.toml
 delete mode 100644 utils/keytable/rc_keymaps/em_terratec
 create mode 100644 utils/keytable/rc_keymaps/em_terratec.toml
 delete mode 100644 utils/keytable/rc_keymaps/encore_enltv
 create mode 100644 utils/keytable/rc_keymaps/encore_enltv.toml
 delete mode 100644 utils/keytable/rc_keymaps/encore_enltv2
 create mode 100644 utils/keytable/rc_keymaps/encore_enltv2.toml
 delete mode 100644 utils/keytable/rc_keymaps/encore_enltv_fm53
 create mode 100644 utils/keytable/rc_keymaps/encore_enltv_fm53.toml
 delete mode 100644 utils/keytable/rc_keymaps/evga_indtube
 create mode 100644 utils/keytable/rc_keymaps/evga_indtube.toml
 delete mode 100644 utils/keytable/rc_keymaps/eztv
 create mode 100644 utils/keytable/rc_keymaps/eztv.toml
 delete mode 100644 utils/keytable/rc_keymaps/flydvb
 create mode 100644 utils/keytable/rc_keymaps/flydvb.toml
 delete mode 100644 utils/keytable/rc_keymaps/flyvideo
 create mode 100644 utils/keytable/rc_keymaps/flyvideo.toml
 delete mode 100644 utils/keytable/rc_keymaps/fusionhdtv_mce
 create mode 100644 utils/keytable/rc_keymaps/fusionhdtv_mce.toml
 delete mode 100644 utils/keytable/rc_keymaps/gadmei_rm008z
 create mode 100644 utils/keytable/rc_keymaps/gadmei_rm008z.toml
 delete mode 100644 utils/keytable/rc_keymaps/geekbox
 create mode 100644 utils/keytable/rc_keymaps/geekbox.toml
 delete mode 100644 utils/keytable/rc_keymaps/genius_tvgo_a11mce
 create mode 100644 utils/keytable/rc_keymaps/genius_tvgo_a11mce.toml
 delete mode 100644 utils/keytable/rc_keymaps/gotview7135
 create mode 100644 utils/keytable/rc_keymaps/gotview7135.toml
 delete mode 100644 utils/keytable/rc_keymaps/haupp
 create mode 100644 utils/keytable/rc_keymaps/haupp.toml
 delete mode 100644 utils/keytable/rc_keymaps/hauppauge
 create mode 100644 utils/keytable/rc_keymaps/hauppauge.toml
 delete mode 100644 utils/keytable/rc_keymaps/hisi_poplar
 create mode 100644 utils/keytable/rc_keymaps/hisi_poplar.toml
 delete mode 100644 utils/keytable/rc_keymaps/hisi_tv_demo
 create mode 100644 utils/keytable/rc_keymaps/hisi_tv_demo.toml
 delete mode 100644 utils/keytable/rc_keymaps/imon_mce
 create mode 100644 utils/keytable/rc_keymaps/imon_mce.toml
 delete mode 100644 utils/keytable/rc_keymaps/imon_pad
 create mode 100644 utils/keytable/rc_keymaps/imon_pad.toml
 delete mode 100644 utils/keytable/rc_keymaps/imon_rsc
 create mode 100644 utils/keytable/rc_keymaps/imon_rsc.toml
 delete mode 100644 utils/keytable/rc_keymaps/iodata_bctv7e
 create mode 100644 utils/keytable/rc_keymaps/iodata_bctv7e.toml
 delete mode 100644 utils/keytable/rc_keymaps/it913x_v1
 create mode 100644 utils/keytable/rc_keymaps/it913x_v1.toml
 delete mode 100644 utils/keytable/rc_keymaps/it913x_v2
 create mode 100644 utils/keytable/rc_keymaps/it913x_v2.toml
 delete mode 100644 utils/keytable/rc_keymaps/kaiomy
 create mode 100644 utils/keytable/rc_keymaps/kaiomy.toml
 delete mode 100644 utils/keytable/rc_keymaps/kworld_315u
 create mode 100644 utils/keytable/rc_keymaps/kworld_315u.toml
 delete mode 100644 utils/keytable/rc_keymaps/kworld_pc150u
 create mode 100644 utils/keytable/rc_keymaps/kworld_pc150u.toml
 delete mode 100644 utils/keytable/rc_keymaps/kworld_plus_tv_analog
 create mode 100644 utils/keytable/rc_keymaps/kworld_plus_tv_analog.toml
 delete mode 100644 utils/keytable/rc_keymaps/leadtek_y04g0051
 create mode 100644 utils/keytable/rc_keymaps/leadtek_y04g0051.toml
 delete mode 100644 utils/keytable/rc_keymaps/lme2510
 create mode 100644 utils/keytable/rc_keymaps/lme2510.toml
 delete mode 100644 utils/keytable/rc_keymaps/manli
 create mode 100644 utils/keytable/rc_keymaps/manli.toml
 delete mode 100644 utils/keytable/rc_keymaps/medion_x10
 create mode 100644 utils/keytable/rc_keymaps/medion_x10.toml
 delete mode 100644 utils/keytable/rc_keymaps/medion_x10_digitainer
 create mode 100644 utils/keytable/rc_keymaps/medion_x10_digitainer.toml
 delete mode 100644 utils/keytable/rc_keymaps/medion_x10_or2x
 create mode 100644 utils/keytable/rc_keymaps/medion_x10_or2x.toml
 delete mode 100644 utils/keytable/rc_keymaps/megasky
 create mode 100644 utils/keytable/rc_keymaps/megasky.toml
 delete mode 100644 utils/keytable/rc_keymaps/msi_digivox_ii
 create mode 100644 utils/keytable/rc_keymaps/msi_digivox_ii.toml
 delete mode 100644 utils/keytable/rc_keymaps/msi_digivox_iii
 create mode 100644 utils/keytable/rc_keymaps/msi_digivox_iii.toml
 delete mode 100644 utils/keytable/rc_keymaps/msi_tvanywhere
 create mode 100644 utils/keytable/rc_keymaps/msi_tvanywhere.toml
 delete mode 100644 utils/keytable/rc_keymaps/msi_tvanywhere_plus
 create mode 100644 utils/keytable/rc_keymaps/msi_tvanywhere_plus.toml
 delete mode 100644 utils/keytable/rc_keymaps/nebula
 create mode 100644 utils/keytable/rc_keymaps/nebula.toml
 delete mode 100644 utils/keytable/rc_keymaps/nec_terratec_cinergy_xs
 create mode 100644 utils/keytable/rc_keymaps/nec_terratec_cinergy_xs.toml
 delete mode 100644 utils/keytable/rc_keymaps/norwood
 create mode 100644 utils/keytable/rc_keymaps/norwood.toml
 delete mode 100644 utils/keytable/rc_keymaps/npgtech
 create mode 100644 utils/keytable/rc_keymaps/npgtech.toml
 delete mode 100644 utils/keytable/rc_keymaps/opera1
 create mode 100644 utils/keytable/rc_keymaps/opera1.toml
 delete mode 100644 utils/keytable/rc_keymaps/pctv_sedna
 create mode 100644 utils/keytable/rc_keymaps/pctv_sedna.toml
 delete mode 100644 utils/keytable/rc_keymaps/pinnacle310e
 create mode 100644 utils/keytable/rc_keymaps/pinnacle310e.toml
 delete mode 100644 utils/keytable/rc_keymaps/pinnacle_color
 create mode 100644 utils/keytable/rc_keymaps/pinnacle_color.toml
 delete mode 100644 utils/keytable/rc_keymaps/pinnacle_grey
 create mode 100644 utils/keytable/rc_keymaps/pinnacle_grey.toml
 delete mode 100644 utils/keytable/rc_keymaps/pinnacle_pctv_hd
 create mode 100644 utils/keytable/rc_keymaps/pinnacle_pctv_hd.toml
 delete mode 100644 utils/keytable/rc_keymaps/pixelview
 create mode 100644 utils/keytable/rc_keymaps/pixelview.toml
 delete mode 100644 utils/keytable/rc_keymaps/pixelview_002t
 create mode 100644 utils/keytable/rc_keymaps/pixelview_002t.toml
 delete mode 100644 utils/keytable/rc_keymaps/pixelview_mk12
 create mode 100644 utils/keytable/rc_keymaps/pixelview_mk12.toml
 delete mode 100644 utils/keytable/rc_keymaps/pixelview_new
 create mode 100644 utils/keytable/rc_keymaps/pixelview_new.toml
 delete mode 100644 utils/keytable/rc_keymaps/powercolor_real_angel
 create mode 100644 utils/keytable/rc_keymaps/powercolor_real_angel.toml
 delete mode 100644 utils/keytable/rc_keymaps/proteus_2309
 create mode 100644 utils/keytable/rc_keymaps/proteus_2309.toml
 delete mode 100644 utils/keytable/rc_keymaps/purpletv
 create mode 100644 utils/keytable/rc_keymaps/purpletv.toml
 delete mode 100644 utils/keytable/rc_keymaps/pv951
 create mode 100644 utils/keytable/rc_keymaps/pv951.toml
 delete mode 100644 utils/keytable/rc_keymaps/rc6_mce
 create mode 100644 utils/keytable/rc_keymaps/rc6_mce.toml
 delete mode 100644 utils/keytable/rc_keymaps/real_audio_220_32_keys
 create mode 100644 utils/keytable/rc_keymaps/real_audio_220_32_keys.toml
 delete mode 100644 utils/keytable/rc_keymaps/reddo
 create mode 100644 utils/keytable/rc_keymaps/reddo.toml
 delete mode 100644 utils/keytable/rc_keymaps/snapstream_firefly
 create mode 100644 utils/keytable/rc_keymaps/snapstream_firefly.toml
 delete mode 100644 utils/keytable/rc_keymaps/streamzap
 create mode 100644 utils/keytable/rc_keymaps/streamzap.toml
 delete mode 100644 utils/keytable/rc_keymaps/su3000
 create mode 100644 utils/keytable/rc_keymaps/su3000.toml
 delete mode 100644 utils/keytable/rc_keymaps/tango
 create mode 100644 utils/keytable/rc_keymaps/tango.toml
 delete mode 100644 utils/keytable/rc_keymaps/tbs_nec
 create mode 100644 utils/keytable/rc_keymaps/tbs_nec.toml
 delete mode 100644 utils/keytable/rc_keymaps/technisat_ts35
 create mode 100644 utils/keytable/rc_keymaps/technisat_ts35.toml
 delete mode 100644 utils/keytable/rc_keymaps/technisat_usb2
 create mode 100644 utils/keytable/rc_keymaps/technisat_usb2.toml
 delete mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_c_pci
 create mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_c_pci.toml
 delete mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_s2_hd
 create mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_s2_hd.toml
 delete mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_xs
 create mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_xs.toml
 delete mode 100644 utils/keytable/rc_keymaps/terratec_slim
 create mode 100644 utils/keytable/rc_keymaps/terratec_slim.toml
 delete mode 100644 utils/keytable/rc_keymaps/terratec_slim_2
 create mode 100644 utils/keytable/rc_keymaps/terratec_slim_2.toml
 delete mode 100644 utils/keytable/rc_keymaps/tevii_nec
 create mode 100644 utils/keytable/rc_keymaps/tevii_nec.toml
 delete mode 100644 utils/keytable/rc_keymaps/tivo
 create mode 100644 utils/keytable/rc_keymaps/tivo.toml
 delete mode 100644 utils/keytable/rc_keymaps/total_media_in_hand
 create mode 100644 utils/keytable/rc_keymaps/total_media_in_hand.toml
 delete mode 100644 utils/keytable/rc_keymaps/total_media_in_hand_02
 create mode 100644 utils/keytable/rc_keymaps/total_media_in_hand_02.toml
 delete mode 100644 utils/keytable/rc_keymaps/trekstor
 create mode 100644 utils/keytable/rc_keymaps/trekstor.toml
 delete mode 100644 utils/keytable/rc_keymaps/tt_1500
 create mode 100644 utils/keytable/rc_keymaps/tt_1500.toml
 delete mode 100644 utils/keytable/rc_keymaps/tvwalkertwin
 create mode 100644 utils/keytable/rc_keymaps/tvwalkertwin.toml
 delete mode 100644 utils/keytable/rc_keymaps/twinhan_dtv_cab_ci
 create mode 100644 utils/keytable/rc_keymaps/twinhan_dtv_cab_ci.toml
 delete mode 100644 utils/keytable/rc_keymaps/twinhan_vp1027_dvbs
 create mode 100644 utils/keytable/rc_keymaps/twinhan_vp1027_dvbs.toml
 delete mode 100644 utils/keytable/rc_keymaps/videomate_k100
 create mode 100644 utils/keytable/rc_keymaps/videomate_k100.toml
 delete mode 100644 utils/keytable/rc_keymaps/videomate_s350
 create mode 100644 utils/keytable/rc_keymaps/videomate_s350.toml
 delete mode 100644 utils/keytable/rc_keymaps/videomate_tv_pvr
 create mode 100644 utils/keytable/rc_keymaps/videomate_tv_pvr.toml
 delete mode 100644 utils/keytable/rc_keymaps/vp702x
 create mode 100644 utils/keytable/rc_keymaps/vp702x.toml
 delete mode 100644 utils/keytable/rc_keymaps/winfast
 create mode 100644 utils/keytable/rc_keymaps/winfast.toml
 delete mode 100644 utils/keytable/rc_keymaps/winfast_usbii_deluxe
 create mode 100644 utils/keytable/rc_keymaps/winfast_usbii_deluxe.toml
 delete mode 100644 utils/keytable/rc_keymaps/wobo_i5
 delete mode 100644 utils/keytable/rc_keymaps/zx_irdec
 create mode 100644 utils/keytable/rc_keymaps/zx_irdec.toml
 delete mode 100644 utils/keytable/rc_keymaps_userspace/allwinner_ba10_tv_box
 create mode 100644 utils/keytable/rc_keymaps_userspace/allwinner_ba10_tv_box.toml
 delete mode 100644 utils/keytable/rc_keymaps_userspace/allwinner_i12_a20_tv_box
 create mode 100644 utils/keytable/rc_keymaps_userspace/allwinner_i12_a20_tv_box.toml
 delete mode 100644 utils/keytable/rc_keymaps_userspace/wobo_i5
 create mode 100644 utils/keytable/rc_keymaps_userspace/wobo_i5.toml

diff --git a/utils/keytable/gen_keytables.pl b/utils/keytable/gen_keytables.pl
index 3045f257..fbb0db71 100755
--- a/utils/keytable/gen_keytables.pl
+++ b/utils/keytable/gen_keytables.pl
@@ -16,12 +16,13 @@ my @ir_files = (
 
 my $debug = 1;
 my $dir="rc_keymaps";
-my $deftype = "UNKNOWN";
+my $deftype = "unknown";
 
 my $keyname="";
 my $out;
 my $read=0;
 my $type = $deftype;
+my $variant = $deftype;
 my $check_type = 0;
 my $name;
 my $warn;
@@ -37,9 +38,15 @@ sub flush($$)
 	my $defined;
 
 	return if (!$keyname || !$out);
-	print "Creating $dir/$keyname\n";
-	open OUT, ">$dir/$keyname";
-	print OUT "# table $keyname, type: $type\n";
+	print "Creating $dir/$keyname.toml\n";
+	open OUT, ">$dir/$keyname.toml";
+	print OUT "[[protocols]]\n";
+	print OUT "name = \"$keyname\"\n";
+	print OUT "protocol = \"$type\"\n";
+	if ($type eq "nec" || $type eq "rc5" || $type eq "rc6" || $type eq "sony") {
+		print OUT "variant = \"$variant\"\n";
+	}
+	print OUT "[protocols.scancodes]\n";
 	print OUT $out;
 	close OUT;
 
@@ -50,11 +57,11 @@ sub flush($$)
 	}
 
 	if ($defined) {
-		printf OUT_MAP "*\t%-24s %s\n", $rc_map_names{$name} , $keyname;
+		printf OUT_MAP "*\t%-24s %s.toml\n", $rc_map_names{$name} , $keyname;
 	} else {
 		my $fname = $filename;
 		$fname =~ s,.*/,,;
-		printf OUT_MAP "# *\t*\t\t\t %-20s # found in %s\n", $keyname, $fname;
+		printf OUT_MAP "# *\t*\t\t\t %-20s # found in %s\n", "$keyname.toml", $fname;
 	}
 
 	$keyname = "";
@@ -104,6 +111,7 @@ sub parse_file($$)
 				next;
 			}
 			if (m/RC_PROTO_([\w\d_]+)/) {
+				$variant = lc $1;
 				$type = $1;
 
 				# Proper name the RC6 protocol
@@ -114,13 +122,14 @@ sub parse_file($$)
 
 				# NECX protocol variant uses nec decoder
 				$type =~ s/^NECX$/NEC/;
+				$type = lc $type;
 			}
 			next;
 		}
 
 		if ($read) {
 			if (m/(0x[\dA-Fa-f]+)[\s\,]+(KEY|BTN)(\_[^\s\,\}]+)/) {
-				$out .= "$1 $2$3\n";
+				$out .= "$1 = \"$2$3\"\n";
 				next;
 			}
 			if (m/\}/) {
@@ -198,11 +207,11 @@ print OUT_MAP << "EOF";
 #		/etc/rc_keymaps.
 # For example:
 # driver	table				file
-# cx8800	*				./keycodes/rc5_hauppauge_new
-# *		rc-avermedia-m135a-rm-jx	./keycodes/kworld_315u
-# saa7134	rc-avermedia-m135a-rm-jx	./keycodes/keycodes/nec_terratec_cinergy_xs
-# em28xx	*				./keycodes/kworld_315u
-# *		*				./keycodes/rc5_hauppauge_new
+# cx8800	*				./keycodes/rc5_hauppauge_new.toml
+# *		rc-avermedia-m135a-rm-jx	./keycodes/kworld_315u.toml
+# saa7134	rc-avermedia-m135a-rm-jx	./keycodes/keycodes/nec_terratec_cinergy_xs.toml
+# em28xx	*				./keycodes/kworld_315u.toml
+# *		*				./keycodes/rc5_hauppauge_new.toml
 
 # Table to automatically load the rc maps for the bundled IR's provided with the
 # devices supported by the linux kernel
diff --git a/utils/keytable/ir-keytable.1.in b/utils/keytable/ir-keytable.1.in
index 0be8a5a7..60f9dfe9 100644
--- a/utils/keytable/ir-keytable.1.in
+++ b/utils/keytable/ir-keytable.1.in
@@ -98,11 +98,11 @@ To list all connected Remote Controller devices:
 .PP
 To clean the keycode table and use a newer one:
 .br
-	\fBir\-keytable \-c \-w /etc/rc_keymaps/nec_terratec_cinergy_xs\fR
+	\fBir\-keytable \-c \-w /etc/rc_keymaps/nec_terratec_cinergy_xs.toml\fR
 .PP
 To append more codes to the existing table:
 .br
-	\fBir\-keytable \-w /etc/rc_keymaps/nec_terratec_cinergy_xs\fR
+	\fBir\-keytable \-w /etc/rc_keymaps/nec_terratec_cinergy_xs.toml\fR
 .PP
 To read the current keytable, on the second remote controller:
 	\fBir\-keytable \-s rc1 \-r\fR
diff --git a/utils/keytable/rc_keymaps/adstech_dvb_t_pci b/utils/keytable/rc_keymaps/adstech_dvb_t_pci
deleted file mode 100644
index df317cd7..00000000
--- a/utils/keytable/rc_keymaps/adstech_dvb_t_pci
+++ /dev/null
@@ -1,45 +0,0 @@
-# table adstech_dvb_t_pci, type: UNKNOWN
-0x4d KEY_0
-0x57 KEY_1
-0x4f KEY_2
-0x53 KEY_3
-0x56 KEY_4
-0x4e KEY_5
-0x5e KEY_6
-0x54 KEY_7
-0x4c KEY_8
-0x5c KEY_9
-0x5b KEY_POWER
-0x5f KEY_MUTE
-0x55 KEY_GOTO
-0x5d KEY_SEARCH
-0x17 KEY_EPG
-0x1f KEY_MENU
-0x0f KEY_UP
-0x46 KEY_DOWN
-0x16 KEY_LEFT
-0x1e KEY_RIGHT
-0x0e KEY_SELECT
-0x5a KEY_INFO
-0x52 KEY_EXIT
-0x59 KEY_PREVIOUS
-0x51 KEY_NEXT
-0x58 KEY_REWIND
-0x50 KEY_FORWARD
-0x44 KEY_PLAYPAUSE
-0x07 KEY_STOP
-0x1b KEY_RECORD
-0x13 KEY_TUNER
-0x0a KEY_A
-0x12 KEY_B
-0x03 KEY_RED
-0x01 KEY_GREEN
-0x00 KEY_YELLOW
-0x06 KEY_DVD
-0x48 KEY_AUX
-0x40 KEY_VIDEO
-0x19 KEY_AUDIO
-0x0b KEY_CHANNELUP
-0x08 KEY_CHANNELDOWN
-0x15 KEY_VOLUMEUP
-0x1c KEY_VOLUMEDOWN
diff --git a/utils/keytable/rc_keymaps/adstech_dvb_t_pci.toml b/utils/keytable/rc_keymaps/adstech_dvb_t_pci.toml
new file mode 100644
index 00000000..280f5f86
--- /dev/null
+++ b/utils/keytable/rc_keymaps/adstech_dvb_t_pci.toml
@@ -0,0 +1,48 @@
+[[protocols]]
+name = "adstech_dvb_t_pci"
+protocol = "unknown"
+[protocols.scancodes]
+0x4d = "KEY_0"
+0x57 = "KEY_1"
+0x4f = "KEY_2"
+0x53 = "KEY_3"
+0x56 = "KEY_4"
+0x4e = "KEY_5"
+0x5e = "KEY_6"
+0x54 = "KEY_7"
+0x4c = "KEY_8"
+0x5c = "KEY_9"
+0x5b = "KEY_POWER"
+0x5f = "KEY_MUTE"
+0x55 = "KEY_GOTO"
+0x5d = "KEY_SEARCH"
+0x17 = "KEY_EPG"
+0x1f = "KEY_MENU"
+0x0f = "KEY_UP"
+0x46 = "KEY_DOWN"
+0x16 = "KEY_LEFT"
+0x1e = "KEY_RIGHT"
+0x0e = "KEY_SELECT"
+0x5a = "KEY_INFO"
+0x52 = "KEY_EXIT"
+0x59 = "KEY_PREVIOUS"
+0x51 = "KEY_NEXT"
+0x58 = "KEY_REWIND"
+0x50 = "KEY_FORWARD"
+0x44 = "KEY_PLAYPAUSE"
+0x07 = "KEY_STOP"
+0x1b = "KEY_RECORD"
+0x13 = "KEY_TUNER"
+0x0a = "KEY_A"
+0x12 = "KEY_B"
+0x03 = "KEY_RED"
+0x01 = "KEY_GREEN"
+0x00 = "KEY_YELLOW"
+0x06 = "KEY_DVD"
+0x48 = "KEY_AUX"
+0x40 = "KEY_VIDEO"
+0x19 = "KEY_AUDIO"
+0x0b = "KEY_CHANNELUP"
+0x08 = "KEY_CHANNELDOWN"
+0x15 = "KEY_VOLUMEUP"
+0x1c = "KEY_VOLUMEDOWN"
diff --git a/utils/keytable/rc_keymaps/af9005 b/utils/keytable/rc_keymaps/af9005
deleted file mode 100644
index b5d32c38..00000000
--- a/utils/keytable/rc_keymaps/af9005
+++ /dev/null
@@ -1,37 +0,0 @@
-# table af9005, type: UNKNOWN
-0x01b7 KEY_POWER
-0x01a7 KEY_VOLUMEUP
-0x0187 KEY_CHANNELUP
-0x017f KEY_MUTE
-0x01bf KEY_VOLUMEDOWN
-0x013f KEY_CHANNELDOWN
-0x01df KEY_1
-0x015f KEY_2
-0x019f KEY_3
-0x011f KEY_4
-0x01ef KEY_5
-0x016f KEY_6
-0x01af KEY_7
-0x0127 KEY_8
-0x0107 KEY_9
-0x01cf KEY_ZOOM
-0x014f KEY_0
-0x018f KEY_GOTO
-0x00bd KEY_POWER
-0x007d KEY_VOLUMEUP
-0x00fd KEY_CHANNELUP
-0x009d KEY_MUTE
-0x005d KEY_VOLUMEDOWN
-0x00dd KEY_CHANNELDOWN
-0x00ad KEY_1
-0x006d KEY_2
-0x00ed KEY_3
-0x008d KEY_4
-0x004d KEY_5
-0x00cd KEY_6
-0x00b5 KEY_7
-0x0075 KEY_8
-0x00f5 KEY_9
-0x0095 KEY_ZOOM
-0x0055 KEY_0
-0x00d5 KEY_GOTO
diff --git a/utils/keytable/rc_keymaps/af9005.toml b/utils/keytable/rc_keymaps/af9005.toml
new file mode 100644
index 00000000..f3152031
--- /dev/null
+++ b/utils/keytable/rc_keymaps/af9005.toml
@@ -0,0 +1,40 @@
+[[protocols]]
+name = "af9005"
+protocol = "unknown"
+[protocols.scancodes]
+0x01b7 = "KEY_POWER"
+0x01a7 = "KEY_VOLUMEUP"
+0x0187 = "KEY_CHANNELUP"
+0x017f = "KEY_MUTE"
+0x01bf = "KEY_VOLUMEDOWN"
+0x013f = "KEY_CHANNELDOWN"
+0x01df = "KEY_1"
+0x015f = "KEY_2"
+0x019f = "KEY_3"
+0x011f = "KEY_4"
+0x01ef = "KEY_5"
+0x016f = "KEY_6"
+0x01af = "KEY_7"
+0x0127 = "KEY_8"
+0x0107 = "KEY_9"
+0x01cf = "KEY_ZOOM"
+0x014f = "KEY_0"
+0x018f = "KEY_GOTO"
+0x00bd = "KEY_POWER"
+0x007d = "KEY_VOLUMEUP"
+0x00fd = "KEY_CHANNELUP"
+0x009d = "KEY_MUTE"
+0x005d = "KEY_VOLUMEDOWN"
+0x00dd = "KEY_CHANNELDOWN"
+0x00ad = "KEY_1"
+0x006d = "KEY_2"
+0x00ed = "KEY_3"
+0x008d = "KEY_4"
+0x004d = "KEY_5"
+0x00cd = "KEY_6"
+0x00b5 = "KEY_7"
+0x0075 = "KEY_8"
+0x00f5 = "KEY_9"
+0x0095 = "KEY_ZOOM"
+0x0055 = "KEY_0"
+0x00d5 = "KEY_GOTO"
diff --git a/utils/keytable/rc_keymaps/alink_dtu_m b/utils/keytable/rc_keymaps/alink_dtu_m
deleted file mode 100644
index 64a0d24b..00000000
--- a/utils/keytable/rc_keymaps/alink_dtu_m
+++ /dev/null
@@ -1,19 +0,0 @@
-# table alink_dtu_m, type: NEC
-0x0800 KEY_VOLUMEUP
-0x0801 KEY_1
-0x0802 KEY_3
-0x0803 KEY_7
-0x0804 KEY_9
-0x0805 KEY_NEW
-0x0806 KEY_0
-0x0807 KEY_CHANNEL
-0x080d KEY_5
-0x080f KEY_2
-0x0812 KEY_POWER2
-0x0814 KEY_CHANNELUP
-0x0816 KEY_VOLUMEDOWN
-0x0818 KEY_6
-0x081a KEY_MUTE
-0x081b KEY_8
-0x081c KEY_4
-0x081d KEY_CHANNELDOWN
diff --git a/utils/keytable/rc_keymaps/alink_dtu_m.toml b/utils/keytable/rc_keymaps/alink_dtu_m.toml
new file mode 100644
index 00000000..fcdb07f4
--- /dev/null
+++ b/utils/keytable/rc_keymaps/alink_dtu_m.toml
@@ -0,0 +1,23 @@
+[[protocols]]
+name = "alink_dtu_m"
+protocol = "nec"
+variant = "nec"
+[protocols.scancodes]
+0x0800 = "KEY_VOLUMEUP"
+0x0801 = "KEY_1"
+0x0802 = "KEY_3"
+0x0803 = "KEY_7"
+0x0804 = "KEY_9"
+0x0805 = "KEY_NEW"
+0x0806 = "KEY_0"
+0x0807 = "KEY_CHANNEL"
+0x080d = "KEY_5"
+0x080f = "KEY_2"
+0x0812 = "KEY_POWER2"
+0x0814 = "KEY_CHANNELUP"
+0x0816 = "KEY_VOLUMEDOWN"
+0x0818 = "KEY_6"
+0x081a = "KEY_MUTE"
+0x081b = "KEY_8"
+0x081c = "KEY_4"
+0x081d = "KEY_CHANNELDOWN"
diff --git a/utils/keytable/rc_keymaps/allwinner_ba10_tv_box b/utils/keytable/rc_keymaps/allwinner_ba10_tv_box
deleted file mode 100644
index 5df16e31..00000000
--- a/utils/keytable/rc_keymaps/allwinner_ba10_tv_box
+++ /dev/null
@@ -1,15 +0,0 @@
-# table allwinner_ba10_tv_box, type: NEC
-0x206 KEY_UP
-0x216 KEY_VOLUMEDOWN
-0x217 KEY_NEXTSONG
-0x21a KEY_POWER
-0x21b KEY_BACK
-0x21e KEY_OK
-0x21f KEY_DOWN
-0x244 KEY_VOLUMEUP
-0x254 KEY_PREVIOUSSONG
-0x255 KEY_PLAYPAUSE
-0x258 KEY_MENU
-0x259 KEY_HOMEPAGE
-0x25c KEY_RIGHT
-0x25d KEY_LEFT
diff --git a/utils/keytable/rc_keymaps/allwinner_i12_a20_tv_box b/utils/keytable/rc_keymaps/allwinner_i12_a20_tv_box
deleted file mode 100644
index e87717cd..00000000
--- a/utils/keytable/rc_keymaps/allwinner_i12_a20_tv_box
+++ /dev/null
@@ -1,28 +0,0 @@
-# table allwinner_i12_a20_tv_box, type: NEC
-0x00 KEY_7
-0x01 KEY_4
-0x02 KEY_1
-0x03 KEY_VOLUMEDOWN
-0x04 KEY_8
-0x05 KEY_5
-0x06 KEY_2
-0x07 KEY_BACK
-0x08 KEY_9
-0x09 KEY_6
-0x0a KEY_3
-0x0b KEY_NEXTSONG
-0x0c KEY_WWW
-0x0d KEY_0
-0x0e KEY_BACKSPACE
-0x40 KEY_VOLUMEUP
-0x41 KEY_LEFT
-0x42 KEY_HOMEPAGE
-0x43 KEY_POWER
-0x44 KEY_DOWN
-0x45 KEY_OK
-0x46 KEY_UP
-0x47 KEY_CONTEXT_MENU
-0x48 KEY_PREVIOUSSONG
-0x49 KEY_RIGHT
-0x4a KEY_MENU
-0x4b KEY_MUTE
diff --git a/utils/keytable/rc_keymaps/anysee b/utils/keytable/rc_keymaps/anysee
deleted file mode 100644
index 5e0ac1de..00000000
--- a/utils/keytable/rc_keymaps/anysee
+++ /dev/null
@@ -1,45 +0,0 @@
-# table anysee, type: NEC
-0x0800 KEY_0
-0x0801 KEY_1
-0x0802 KEY_2
-0x0803 KEY_3
-0x0804 KEY_4
-0x0805 KEY_5
-0x0806 KEY_6
-0x0807 KEY_7
-0x0808 KEY_8
-0x0809 KEY_9
-0x080a KEY_POWER2
-0x080b KEY_VIDEO
-0x080c KEY_CHANNEL
-0x080d KEY_NEXT
-0x080e KEY_MENU
-0x080f KEY_EPG
-0x0810 KEY_CLEAR
-0x0811 KEY_CHANNELUP
-0x0812 KEY_VOLUMEDOWN
-0x0813 KEY_VOLUMEUP
-0x0814 KEY_CHANNELDOWN
-0x0815 KEY_OK
-0x0816 KEY_RADIO
-0x0817 KEY_INFO
-0x0818 KEY_PREVIOUS
-0x0819 KEY_FAVORITES
-0x081a KEY_SUBTITLE
-0x081b KEY_CAMERA
-0x081c KEY_YELLOW
-0x081d KEY_RED
-0x081e KEY_LANGUAGE
-0x081f KEY_GREEN
-0x0820 KEY_SLEEP
-0x0821 KEY_SCREEN
-0x0822 KEY_ZOOM
-0x0824 KEY_FN
-0x0825 KEY_FN
-0x0842 KEY_MUTE
-0x0844 KEY_BLUE
-0x0847 KEY_TEXT
-0x0848 KEY_STOP
-0x0849 KEY_RECORD
-0x0850 KEY_PLAY
-0x0851 KEY_PAUSE
diff --git a/utils/keytable/rc_keymaps/anysee.toml b/utils/keytable/rc_keymaps/anysee.toml
new file mode 100644
index 00000000..2f7d14fe
--- /dev/null
+++ b/utils/keytable/rc_keymaps/anysee.toml
@@ -0,0 +1,49 @@
+[[protocols]]
+name = "anysee"
+protocol = "nec"
+variant = "nec"
+[protocols.scancodes]
+0x0800 = "KEY_0"
+0x0801 = "KEY_1"
+0x0802 = "KEY_2"
+0x0803 = "KEY_3"
+0x0804 = "KEY_4"
+0x0805 = "KEY_5"
+0x0806 = "KEY_6"
+0x0807 = "KEY_7"
+0x0808 = "KEY_8"
+0x0809 = "KEY_9"
+0x080a = "KEY_POWER2"
+0x080b = "KEY_VIDEO"
+0x080c = "KEY_CHANNEL"
+0x080d = "KEY_NEXT"
+0x080e = "KEY_MENU"
+0x080f = "KEY_EPG"
+0x0810 = "KEY_CLEAR"
+0x0811 = "KEY_CHANNELUP"
+0x0812 = "KEY_VOLUMEDOWN"
+0x0813 = "KEY_VOLUMEUP"
+0x0814 = "KEY_CHANNELDOWN"
+0x0815 = "KEY_OK"
+0x0816 = "KEY_RADIO"
+0x0817 = "KEY_INFO"
+0x0818 = "KEY_PREVIOUS"
+0x0819 = "KEY_FAVORITES"
+0x081a = "KEY_SUBTITLE"
+0x081b = "KEY_CAMERA"
+0x081c = "KEY_YELLOW"
+0x081d = "KEY_RED"
+0x081e = "KEY_LANGUAGE"
+0x081f = "KEY_GREEN"
+0x0820 = "KEY_SLEEP"
+0x0821 = "KEY_SCREEN"
+0x0822 = "KEY_ZOOM"
+0x0824 = "KEY_FN"
+0x0825 = "KEY_FN"
+0x0842 = "KEY_MUTE"
+0x0844 = "KEY_BLUE"
+0x0847 = "KEY_TEXT"
+0x0848 = "KEY_STOP"
+0x0849 = "KEY_RECORD"
+0x0850 = "KEY_PLAY"
+0x0851 = "KEY_PAUSE"
diff --git a/utils/keytable/rc_keymaps/apac_viewcomp b/utils/keytable/rc_keymaps/apac_viewcomp
deleted file mode 100644
index 13e4232a..00000000
--- a/utils/keytable/rc_keymaps/apac_viewcomp
+++ /dev/null
@@ -1,32 +0,0 @@
-# table apac_viewcomp, type: UNKNOWN
-0x01 KEY_1
-0x02 KEY_2
-0x03 KEY_3
-0x04 KEY_4
-0x05 KEY_5
-0x06 KEY_6
-0x07 KEY_7
-0x08 KEY_8
-0x09 KEY_9
-0x00 KEY_0
-0x17 KEY_LAST
-0x0a KEY_LIST
-0x1c KEY_TUNER
-0x15 KEY_SEARCH
-0x12 KEY_POWER
-0x1f KEY_VOLUMEDOWN
-0x1b KEY_VOLUMEUP
-0x1e KEY_CHANNELDOWN
-0x1a KEY_CHANNELUP
-0x11 KEY_VIDEO
-0x0f KEY_ZOOM
-0x13 KEY_MUTE
-0x10 KEY_TEXT
-0x0d KEY_STOP
-0x0e KEY_RECORD
-0x1d KEY_PLAYPAUSE
-0x19 KEY_PLAY
-0x16 KEY_GOTO
-0x14 KEY_REFRESH
-0x0c KEY_KPPLUS
-0x18 KEY_KPMINUS
diff --git a/utils/keytable/rc_keymaps/apac_viewcomp.toml b/utils/keytable/rc_keymaps/apac_viewcomp.toml
new file mode 100644
index 00000000..17e5fd4a
--- /dev/null
+++ b/utils/keytable/rc_keymaps/apac_viewcomp.toml
@@ -0,0 +1,35 @@
+[[protocols]]
+name = "apac_viewcomp"
+protocol = "unknown"
+[protocols.scancodes]
+0x01 = "KEY_1"
+0x02 = "KEY_2"
+0x03 = "KEY_3"
+0x04 = "KEY_4"
+0x05 = "KEY_5"
+0x06 = "KEY_6"
+0x07 = "KEY_7"
+0x08 = "KEY_8"
+0x09 = "KEY_9"
+0x00 = "KEY_0"
+0x17 = "KEY_LAST"
+0x0a = "KEY_LIST"
+0x1c = "KEY_TUNER"
+0x15 = "KEY_SEARCH"
+0x12 = "KEY_POWER"
+0x1f = "KEY_VOLUMEDOWN"
+0x1b = "KEY_VOLUMEUP"
+0x1e = "KEY_CHANNELDOWN"
+0x1a = "KEY_CHANNELUP"
+0x11 = "KEY_VIDEO"
+0x0f = "KEY_ZOOM"
+0x13 = "KEY_MUTE"
+0x10 = "KEY_TEXT"
+0x0d = "KEY_STOP"
+0x0e = "KEY_RECORD"
+0x1d = "KEY_PLAYPAUSE"
+0x19 = "KEY_PLAY"
+0x16 = "KEY_GOTO"
+0x14 = "KEY_REFRESH"
+0x0c = "KEY_KPPLUS"
+0x18 = "KEY_KPMINUS"
diff --git a/utils/keytable/rc_keymaps/astrometa_t2hybrid b/utils/keytable/rc_keymaps/astrometa_t2hybrid
deleted file mode 100644
index 17a3b1a6..00000000
--- a/utils/keytable/rc_keymaps/astrometa_t2hybrid
+++ /dev/null
@@ -1,22 +0,0 @@
-# table astrometa_t2hybrid, type: NEC
-0x4d KEY_POWER2
-0x54 KEY_VIDEO
-0x16 KEY_MUTE
-0x4c KEY_RECORD
-0x05 KEY_CHANNELUP
-0x0c KEY_TIME
-0x0a KEY_VOLUMEDOWN
-0x40 KEY_ZOOM
-0x1e KEY_VOLUMEUP
-0x12 KEY_0
-0x02 KEY_CHANNELDOWN
-0x1c KEY_AGAIN
-0x09 KEY_1
-0x1d KEY_2
-0x1f KEY_3
-0x0d KEY_4
-0x19 KEY_5
-0x1b KEY_6
-0x11 KEY_7
-0x15 KEY_8
-0x17 KEY_9
diff --git a/utils/keytable/rc_keymaps/astrometa_t2hybrid.toml b/utils/keytable/rc_keymaps/astrometa_t2hybrid.toml
new file mode 100644
index 00000000..34cdbb15
--- /dev/null
+++ b/utils/keytable/rc_keymaps/astrometa_t2hybrid.toml
@@ -0,0 +1,26 @@
+[[protocols]]
+name = "astrometa_t2hybrid"
+protocol = "nec"
+variant = "nec"
+[protocols.scancodes]
+0x4d = "KEY_POWER2"
+0x54 = "KEY_VIDEO"
+0x16 = "KEY_MUTE"
+0x4c = "KEY_RECORD"
+0x05 = "KEY_CHANNELUP"
+0x0c = "KEY_TIME"
+0x0a = "KEY_VOLUMEDOWN"
+0x40 = "KEY_ZOOM"
+0x1e = "KEY_VOLUMEUP"
+0x12 = "KEY_0"
+0x02 = "KEY_CHANNELDOWN"
+0x1c = "KEY_AGAIN"
+0x09 = "KEY_1"
+0x1d = "KEY_2"
+0x1f = "KEY_3"
+0x0d = "KEY_4"
+0x19 = "KEY_5"
+0x1b = "KEY_6"
+0x11 = "KEY_7"
+0x15 = "KEY_8"
+0x17 = "KEY_9"
diff --git a/utils/keytable/rc_keymaps/asus_pc39 b/utils/keytable/rc_keymaps/asus_pc39
deleted file mode 100644
index e498751f..00000000
--- a/utils/keytable/rc_keymaps/asus_pc39
+++ /dev/null
@@ -1,40 +0,0 @@
-# table asus_pc39, type: RC5
-0x082a KEY_0
-0x0816 KEY_1
-0x0812 KEY_2
-0x0814 KEY_3
-0x0836 KEY_4
-0x0832 KEY_5
-0x0834 KEY_6
-0x080e KEY_7
-0x080a KEY_8
-0x080c KEY_9
-0x0801 KEY_RADIO
-0x083c KEY_MENU
-0x0815 KEY_VOLUMEUP
-0x0826 KEY_VOLUMEDOWN
-0x0808 KEY_UP
-0x0804 KEY_DOWN
-0x0818 KEY_LEFT
-0x0810 KEY_RIGHT
-0x081a KEY_VIDEO
-0x0806 KEY_AUDIO
-0x081e KEY_TV
-0x0822 KEY_EXIT
-0x0835 KEY_CHANNELUP
-0x0824 KEY_CHANNELDOWN
-0x0825 KEY_ENTER
-0x0839 KEY_PAUSE
-0x0821 KEY_PREVIOUS
-0x0819 KEY_NEXT
-0x0831 KEY_REWIND
-0x0805 KEY_FASTFORWARD
-0x0809 KEY_STOP
-0x0811 KEY_RECORD
-0x0829 KEY_POWER
-0x082e KEY_ZOOM
-0x082c KEY_MACRO
-0x081c KEY_HOME
-0x083a KEY_PVR
-0x0802 KEY_MUTE
-0x083e KEY_DVD
diff --git a/utils/keytable/rc_keymaps/asus_pc39.toml b/utils/keytable/rc_keymaps/asus_pc39.toml
new file mode 100644
index 00000000..6922ade6
--- /dev/null
+++ b/utils/keytable/rc_keymaps/asus_pc39.toml
@@ -0,0 +1,44 @@
+[[protocols]]
+name = "asus_pc39"
+protocol = "rc5"
+variant = "rc5"
+[protocols.scancodes]
+0x082a = "KEY_0"
+0x0816 = "KEY_1"
+0x0812 = "KEY_2"
+0x0814 = "KEY_3"
+0x0836 = "KEY_4"
+0x0832 = "KEY_5"
+0x0834 = "KEY_6"
+0x080e = "KEY_7"
+0x080a = "KEY_8"
+0x080c = "KEY_9"
+0x0801 = "KEY_RADIO"
+0x083c = "KEY_MENU"
+0x0815 = "KEY_VOLUMEUP"
+0x0826 = "KEY_VOLUMEDOWN"
+0x0808 = "KEY_UP"
+0x0804 = "KEY_DOWN"
+0x0818 = "KEY_LEFT"
+0x0810 = "KEY_RIGHT"
+0x081a = "KEY_VIDEO"
+0x0806 = "KEY_AUDIO"
+0x081e = "KEY_TV"
+0x0822 = "KEY_EXIT"
+0x0835 = "KEY_CHANNELUP"
+0x0824 = "KEY_CHANNELDOWN"
+0x0825 = "KEY_ENTER"
+0x0839 = "KEY_PAUSE"
+0x0821 = "KEY_PREVIOUS"
+0x0819 = "KEY_NEXT"
+0x0831 = "KEY_REWIND"
+0x0805 = "KEY_FASTFORWARD"
+0x0809 = "KEY_STOP"
+0x0811 = "KEY_RECORD"
+0x0829 = "KEY_POWER"
+0x082e = "KEY_ZOOM"
+0x082c = "KEY_MACRO"
+0x081c = "KEY_HOME"
+0x083a = "KEY_PVR"
+0x0802 = "KEY_MUTE"
+0x083e = "KEY_DVD"
diff --git a/utils/keytable/rc_keymaps/asus_ps3_100 b/utils/keytable/rc_keymaps/asus_ps3_100
deleted file mode 100644
index 240a6b24..00000000
--- a/utils/keytable/rc_keymaps/asus_ps3_100
+++ /dev/null
@@ -1,42 +0,0 @@
-# table asus_ps3_100, type: RC5
-0x081c KEY_HOME
-0x081e KEY_TV
-0x0803 KEY_TEXT
-0x0829 KEY_POWER
-0x080b KEY_RED
-0x080d KEY_YELLOW
-0x0806 KEY_BLUE
-0x0807 KEY_GREEN
-0x082a KEY_0
-0x0816 KEY_1
-0x0812 KEY_2
-0x0814 KEY_3
-0x0836 KEY_4
-0x0832 KEY_5
-0x0834 KEY_6
-0x080e KEY_7
-0x080a KEY_8
-0x080c KEY_9
-0x0815 KEY_VOLUMEUP
-0x0826 KEY_VOLUMEDOWN
-0x0835 KEY_CHANNELUP
-0x0824 KEY_CHANNELDOWN
-0x0808 KEY_UP
-0x0804 KEY_DOWN
-0x0818 KEY_LEFT
-0x0810 KEY_RIGHT
-0x0825 KEY_ENTER
-0x0822 KEY_EXIT
-0x082c KEY_AB
-0x0820 KEY_AUDIO
-0x0837 KEY_SCREEN
-0x082e KEY_ZOOM
-0x0802 KEY_MUTE
-0x0831 KEY_REWIND
-0x0811 KEY_RECORD
-0x0809 KEY_STOP
-0x0805 KEY_FASTFORWARD
-0x0821 KEY_PREVIOUS
-0x081a KEY_PAUSE
-0x0839 KEY_PLAY
-0x0819 KEY_NEXT
diff --git a/utils/keytable/rc_keymaps/asus_ps3_100.toml b/utils/keytable/rc_keymaps/asus_ps3_100.toml
new file mode 100644
index 00000000..500deeb6
--- /dev/null
+++ b/utils/keytable/rc_keymaps/asus_ps3_100.toml
@@ -0,0 +1,46 @@
+[[protocols]]
+name = "asus_ps3_100"
+protocol = "rc5"
+variant = "rc5"
+[protocols.scancodes]
+0x081c = "KEY_HOME"
+0x081e = "KEY_TV"
+0x0803 = "KEY_TEXT"
+0x0829 = "KEY_POWER"
+0x080b = "KEY_RED"
+0x080d = "KEY_YELLOW"
+0x0806 = "KEY_BLUE"
+0x0807 = "KEY_GREEN"
+0x082a = "KEY_0"
+0x0816 = "KEY_1"
+0x0812 = "KEY_2"
+0x0814 = "KEY_3"
+0x0836 = "KEY_4"
+0x0832 = "KEY_5"
+0x0834 = "KEY_6"
+0x080e = "KEY_7"
+0x080a = "KEY_8"
+0x080c = "KEY_9"
+0x0815 = "KEY_VOLUMEUP"
+0x0826 = "KEY_VOLUMEDOWN"
+0x0835 = "KEY_CHANNELUP"
+0x0824 = "KEY_CHANNELDOWN"
+0x0808 = "KEY_UP"
+0x0804 = "KEY_DOWN"
+0x0818 = "KEY_LEFT"
+0x0810 = "KEY_RIGHT"
+0x0825 = "KEY_ENTER"
+0x0822 = "KEY_EXIT"
+0x082c = "KEY_AB"
+0x0820 = "KEY_AUDIO"
+0x0837 = "KEY_SCREEN"
+0x082e = "KEY_ZOOM"
+0x0802 = "KEY_MUTE"
+0x0831 = "KEY_REWIND"
+0x0811 = "KEY_RECORD"
+0x0809 = "KEY_STOP"
+0x0805 = "KEY_FASTFORWARD"
+0x0821 = "KEY_PREVIOUS"
+0x081a = "KEY_PAUSE"
+0x0839 = "KEY_PLAY"
+0x0819 = "KEY_NEXT"
diff --git a/utils/keytable/rc_keymaps/ati_tv_wonder_hd_600 b/utils/keytable/rc_keymaps/ati_tv_wonder_hd_600
deleted file mode 100644
index bd9b93db..00000000
--- a/utils/keytable/rc_keymaps/ati_tv_wonder_hd_600
+++ /dev/null
@@ -1,25 +0,0 @@
-# table ati_tv_wonder_hd_600, type: UNKNOWN
-0x00 KEY_RECORD
-0x01 KEY_PLAYPAUSE
-0x02 KEY_STOP
-0x03 KEY_POWER
-0x04 KEY_PREVIOUS
-0x05 KEY_REWIND
-0x06 KEY_FORWARD
-0x07 KEY_NEXT
-0x08 KEY_EPG
-0x09 KEY_HOME
-0x0a KEY_MENU
-0x0b KEY_CHANNELUP
-0x0c KEY_BACK
-0x0d KEY_UP
-0x0e KEY_INFO
-0x0f KEY_CHANNELDOWN
-0x10 KEY_LEFT
-0x11 KEY_SELECT
-0x12 KEY_RIGHT
-0x13 KEY_VOLUMEUP
-0x14 KEY_LAST
-0x15 KEY_DOWN
-0x16 KEY_MUTE
-0x17 KEY_VOLUMEDOWN
diff --git a/utils/keytable/rc_keymaps/ati_tv_wonder_hd_600.toml b/utils/keytable/rc_keymaps/ati_tv_wonder_hd_600.toml
new file mode 100644
index 00000000..2ddc0378
--- /dev/null
+++ b/utils/keytable/rc_keymaps/ati_tv_wonder_hd_600.toml
@@ -0,0 +1,28 @@
+[[protocols]]
+name = "ati_tv_wonder_hd_600"
+protocol = "unknown"
+[protocols.scancodes]
+0x00 = "KEY_RECORD"
+0x01 = "KEY_PLAYPAUSE"
+0x02 = "KEY_STOP"
+0x03 = "KEY_POWER"
+0x04 = "KEY_PREVIOUS"
+0x05 = "KEY_REWIND"
+0x06 = "KEY_FORWARD"
+0x07 = "KEY_NEXT"
+0x08 = "KEY_EPG"
+0x09 = "KEY_HOME"
+0x0a = "KEY_MENU"
+0x0b = "KEY_CHANNELUP"
+0x0c = "KEY_BACK"
+0x0d = "KEY_UP"
+0x0e = "KEY_INFO"
+0x0f = "KEY_CHANNELDOWN"
+0x10 = "KEY_LEFT"
+0x11 = "KEY_SELECT"
+0x12 = "KEY_RIGHT"
+0x13 = "KEY_VOLUMEUP"
+0x14 = "KEY_LAST"
+0x15 = "KEY_DOWN"
+0x16 = "KEY_MUTE"
+0x17 = "KEY_VOLUMEDOWN"
diff --git a/utils/keytable/rc_keymaps/ati_x10 b/utils/keytable/rc_keymaps/ati_x10
deleted file mode 100644
index 09219d1d..00000000
--- a/utils/keytable/rc_keymaps/ati_x10
+++ /dev/null
@@ -1,49 +0,0 @@
-# table ati_x10, type: OTHER
-0x00 KEY_A
-0x01 KEY_B
-0x02 KEY_POWER
-0x03 KEY_TV
-0x04 KEY_DVD
-0x05 KEY_WWW
-0x06 KEY_BOOKMARKS
-0x07 KEY_EDIT
-0x09 KEY_VOLUMEDOWN
-0x08 KEY_VOLUMEUP
-0x0a KEY_MUTE
-0x0b KEY_CHANNELUP
-0x0c KEY_CHANNELDOWN
-0x0d KEY_1
-0x0e KEY_2
-0x0f KEY_3
-0x10 KEY_4
-0x11 KEY_5
-0x12 KEY_6
-0x13 KEY_7
-0x14 KEY_8
-0x15 KEY_9
-0x16 KEY_MENU
-0x17 KEY_0
-0x18 KEY_SETUP
-0x19 KEY_C
-0x1a KEY_UP
-0x1b KEY_D
-0x1c KEY_PROPS
-0x1d KEY_LEFT
-0x1e KEY_OK
-0x1f KEY_RIGHT
-0x20 KEY_SCREEN
-0x21 KEY_E
-0x22 KEY_DOWN
-0x23 KEY_F
-0x24 KEY_REWIND
-0x25 KEY_PLAY
-0x26 KEY_FASTFORWARD
-0x27 KEY_RECORD
-0x28 KEY_STOPCD
-0x29 KEY_PAUSE
-0x2a KEY_NEXT
-0x2b KEY_PREVIOUS
-0x2d KEY_INFO
-0x2e KEY_HOME
-0x2f KEY_END
-0x30 KEY_SELECT
diff --git a/utils/keytable/rc_keymaps/ati_x10.toml b/utils/keytable/rc_keymaps/ati_x10.toml
new file mode 100644
index 00000000..eb81813f
--- /dev/null
+++ b/utils/keytable/rc_keymaps/ati_x10.toml
@@ -0,0 +1,52 @@
+[[protocols]]
+name = "ati_x10"
+protocol = "other"
+[protocols.scancodes]
+0x00 = "KEY_A"
+0x01 = "KEY_B"
+0x02 = "KEY_POWER"
+0x03 = "KEY_TV"
+0x04 = "KEY_DVD"
+0x05 = "KEY_WWW"
+0x06 = "KEY_BOOKMARKS"
+0x07 = "KEY_EDIT"
+0x09 = "KEY_VOLUMEDOWN"
+0x08 = "KEY_VOLUMEUP"
+0x0a = "KEY_MUTE"
+0x0b = "KEY_CHANNELUP"
+0x0c = "KEY_CHANNELDOWN"
+0x0d = "KEY_1"
+0x0e = "KEY_2"
+0x0f = "KEY_3"
+0x10 = "KEY_4"
+0x11 = "KEY_5"
+0x12 = "KEY_6"
+0x13 = "KEY_7"
+0x14 = "KEY_8"
+0x15 = "KEY_9"
+0x16 = "KEY_MENU"
+0x17 = "KEY_0"
+0x18 = "KEY_SETUP"
+0x19 = "KEY_C"
+0x1a = "KEY_UP"
+0x1b = "KEY_D"
+0x1c = "KEY_PROPS"
+0x1d = "KEY_LEFT"
+0x1e = "KEY_OK"
+0x1f = "KEY_RIGHT"
+0x20 = "KEY_SCREEN"
+0x21 = "KEY_E"
+0x22 = "KEY_DOWN"
+0x23 = "KEY_F"
+0x24 = "KEY_REWIND"
+0x25 = "KEY_PLAY"
+0x26 = "KEY_FASTFORWARD"
+0x27 = "KEY_RECORD"
+0x28 = "KEY_STOPCD"
+0x29 = "KEY_PAUSE"
+0x2a = "KEY_NEXT"
+0x2b = "KEY_PREVIOUS"
+0x2d = "KEY_INFO"
+0x2e = "KEY_HOME"
+0x2f = "KEY_END"
+0x30 = "KEY_SELECT"
diff --git a/utils/keytable/rc_keymaps/avermedia b/utils/keytable/rc_keymaps/avermedia
deleted file mode 100644
index d6939add..00000000
--- a/utils/keytable/rc_keymaps/avermedia
+++ /dev/null
@@ -1,37 +0,0 @@
-# table avermedia, type: UNKNOWN
-0x28 KEY_1
-0x18 KEY_2
-0x38 KEY_3
-0x24 KEY_4
-0x14 KEY_5
-0x34 KEY_6
-0x2c KEY_7
-0x1c KEY_8
-0x3c KEY_9
-0x22 KEY_0
-0x20 KEY_TV
-0x10 KEY_CD
-0x30 KEY_TEXT
-0x00 KEY_POWER
-0x08 KEY_VIDEO
-0x04 KEY_AUDIO
-0x0c KEY_ZOOM
-0x12 KEY_SUBTITLE
-0x32 KEY_REWIND
-0x02 KEY_PRINT
-0x2a KEY_SEARCH
-0x1a KEY_SLEEP
-0x3a KEY_CAMERA
-0x0a KEY_MUTE
-0x26 KEY_RECORD
-0x16 KEY_PAUSE
-0x36 KEY_STOP
-0x06 KEY_PLAY
-0x2e KEY_RED
-0x21 KEY_GREEN
-0x0e KEY_YELLOW
-0x01 KEY_BLUE
-0x1e KEY_VOLUMEDOWN
-0x3e KEY_VOLUMEUP
-0x11 KEY_CHANNELDOWN
-0x31 KEY_CHANNELUP
diff --git a/utils/keytable/rc_keymaps/avermedia.toml b/utils/keytable/rc_keymaps/avermedia.toml
new file mode 100644
index 00000000..6a8b5d49
--- /dev/null
+++ b/utils/keytable/rc_keymaps/avermedia.toml
@@ -0,0 +1,40 @@
+[[protocols]]
+name = "avermedia"
+protocol = "unknown"
+[protocols.scancodes]
+0x28 = "KEY_1"
+0x18 = "KEY_2"
+0x38 = "KEY_3"
+0x24 = "KEY_4"
+0x14 = "KEY_5"
+0x34 = "KEY_6"
+0x2c = "KEY_7"
+0x1c = "KEY_8"
+0x3c = "KEY_9"
+0x22 = "KEY_0"
+0x20 = "KEY_TV"
+0x10 = "KEY_CD"
+0x30 = "KEY_TEXT"
+0x00 = "KEY_POWER"
+0x08 = "KEY_VIDEO"
+0x04 = "KEY_AUDIO"
+0x0c = "KEY_ZOOM"
+0x12 = "KEY_SUBTITLE"
+0x32 = "KEY_REWIND"
+0x02 = "KEY_PRINT"
+0x2a = "KEY_SEARCH"
+0x1a = "KEY_SLEEP"
+0x3a = "KEY_CAMERA"
+0x0a = "KEY_MUTE"
+0x26 = "KEY_RECORD"
+0x16 = "KEY_PAUSE"
+0x36 = "KEY_STOP"
+0x06 = "KEY_PLAY"
+0x2e = "KEY_RED"
+0x21 = "KEY_GREEN"
+0x0e = "KEY_YELLOW"
+0x01 = "KEY_BLUE"
+0x1e = "KEY_VOLUMEDOWN"
+0x3e = "KEY_VOLUMEUP"
+0x11 = "KEY_CHANNELDOWN"
+0x31 = "KEY_CHANNELUP"
diff --git a/utils/keytable/rc_keymaps/avermedia_a16d b/utils/keytable/rc_keymaps/avermedia_a16d
deleted file mode 100644
index ccbafe7a..00000000
--- a/utils/keytable/rc_keymaps/avermedia_a16d
+++ /dev/null
@@ -1,35 +0,0 @@
-# table avermedia_a16d, type: UNKNOWN
-0x20 KEY_LIST
-0x00 KEY_POWER
-0x28 KEY_1
-0x18 KEY_2
-0x38 KEY_3
-0x24 KEY_4
-0x14 KEY_5
-0x34 KEY_6
-0x2c KEY_7
-0x1c KEY_8
-0x3c KEY_9
-0x12 KEY_SUBTITLE
-0x22 KEY_0
-0x32 KEY_REWIND
-0x3a KEY_SHUFFLE
-0x02 KEY_PRINT
-0x11 KEY_CHANNELDOWN
-0x31 KEY_CHANNELUP
-0x0c KEY_ZOOM
-0x1e KEY_VOLUMEDOWN
-0x3e KEY_VOLUMEUP
-0x0a KEY_MUTE
-0x04 KEY_AUDIO
-0x26 KEY_RECORD
-0x06 KEY_PLAY
-0x36 KEY_STOP
-0x16 KEY_PAUSE
-0x2e KEY_REWIND
-0x0e KEY_FASTFORWARD
-0x30 KEY_TEXT
-0x21 KEY_GREEN
-0x01 KEY_BLUE
-0x08 KEY_EPG
-0x2a KEY_MENU
diff --git a/utils/keytable/rc_keymaps/avermedia_a16d.toml b/utils/keytable/rc_keymaps/avermedia_a16d.toml
new file mode 100644
index 00000000..f9d92db4
--- /dev/null
+++ b/utils/keytable/rc_keymaps/avermedia_a16d.toml
@@ -0,0 +1,38 @@
+[[protocols]]
+name = "avermedia_a16d"
+protocol = "unknown"
+[protocols.scancodes]
+0x20 = "KEY_LIST"
+0x00 = "KEY_POWER"
+0x28 = "KEY_1"
+0x18 = "KEY_2"
+0x38 = "KEY_3"
+0x24 = "KEY_4"
+0x14 = "KEY_5"
+0x34 = "KEY_6"
+0x2c = "KEY_7"
+0x1c = "KEY_8"
+0x3c = "KEY_9"
+0x12 = "KEY_SUBTITLE"
+0x22 = "KEY_0"
+0x32 = "KEY_REWIND"
+0x3a = "KEY_SHUFFLE"
+0x02 = "KEY_PRINT"
+0x11 = "KEY_CHANNELDOWN"
+0x31 = "KEY_CHANNELUP"
+0x0c = "KEY_ZOOM"
+0x1e = "KEY_VOLUMEDOWN"
+0x3e = "KEY_VOLUMEUP"
+0x0a = "KEY_MUTE"
+0x04 = "KEY_AUDIO"
+0x26 = "KEY_RECORD"
+0x06 = "KEY_PLAY"
+0x36 = "KEY_STOP"
+0x16 = "KEY_PAUSE"
+0x2e = "KEY_REWIND"
+0x0e = "KEY_FASTFORWARD"
+0x30 = "KEY_TEXT"
+0x21 = "KEY_GREEN"
+0x01 = "KEY_BLUE"
+0x08 = "KEY_EPG"
+0x2a = "KEY_MENU"
diff --git a/utils/keytable/rc_keymaps/zx_irdec b/utils/keytable/rc_keymaps/zx_irdec
deleted file mode 100644
index f8376dea..00000000
--- a/utils/keytable/rc_keymaps/zx_irdec
+++ /dev/null
@@ -1,41 +0,0 @@
-# table zx_irdec, type: NEC
-0x01 KEY_1
-0x02 KEY_2
-0x03 KEY_3
-0x04 KEY_4
-0x05 KEY_5
-0x06 KEY_6
-0x07 KEY_7
-0x08 KEY_8
-0x09 KEY_9
-0x31 KEY_0
-0x16 KEY_DELETE
-0x0a KEY_MODE
-0x0c KEY_VOLUMEUP
-0x18 KEY_VOLUMEDOWN
-0x0b KEY_CHANNELUP
-0x15 KEY_CHANNELDOWN
-0x0d KEY_PAGEUP
-0x13 KEY_PAGEDOWN
-0x46 KEY_FASTFORWARD
-0x43 KEY_REWIND
-0x44 KEY_PLAYPAUSE
-0x45 KEY_STOP
-0x49 KEY_OK
-0x47 KEY_UP
-0x4b KEY_DOWN
-0x48 KEY_LEFT
-0x4a KEY_RIGHT
-0x4d KEY_MENU
-0x56 KEY_APPSELECT
-0x4c KEY_BACK
-0x1e KEY_INFO
-0x4e KEY_F1
-0x4f KEY_F2
-0x50 KEY_F3
-0x51 KEY_F4
-0x1c KEY_AUDIO
-0x12 KEY_MUTE
-0x11 KEY_DOT
-0x1d KEY_SETUP
-0x40 KEY_POWER
diff --git a/utils/keytable/rc_keymaps/zx_irdec.toml b/utils/keytable/rc_keymaps/zx_irdec.toml
new file mode 100644
index 00000000..ec1b6c12
--- /dev/null
+++ b/utils/keytable/rc_keymaps/zx_irdec.toml
@@ -0,0 +1,45 @@
+[[protocols]]
+name = "zx_irdec"
+protocol = "nec"
+variant = "nec"
+[protocols.scancodes]
+0x01 = "KEY_1"
+0x02 = "KEY_2"
+0x03 = "KEY_3"
+0x04 = "KEY_4"
+0x05 = "KEY_5"
+0x06 = "KEY_6"
+0x07 = "KEY_7"
+0x08 = "KEY_8"
+0x09 = "KEY_9"
+0x31 = "KEY_0"
+0x16 = "KEY_DELETE"
+0x0a = "KEY_MODE"
+0x0c = "KEY_VOLUMEUP"
+0x18 = "KEY_VOLUMEDOWN"
+0x0b = "KEY_CHANNELUP"
+0x15 = "KEY_CHANNELDOWN"
+0x0d = "KEY_PAGEUP"
+0x13 = "KEY_PAGEDOWN"
+0x46 = "KEY_FASTFORWARD"
+0x43 = "KEY_REWIND"
+0x44 = "KEY_PLAYPAUSE"
+0x45 = "KEY_STOP"
+0x49 = "KEY_OK"
+0x47 = "KEY_UP"
+0x4b = "KEY_DOWN"
+0x48 = "KEY_LEFT"
+0x4a = "KEY_RIGHT"
+0x4d = "KEY_MENU"
+0x56 = "KEY_APPSELECT"
+0x4c = "KEY_BACK"
+0x1e = "KEY_INFO"
+0x4e = "KEY_F1"
+0x4f = "KEY_F2"
+0x50 = "KEY_F3"
+0x51 = "KEY_F4"
+0x1c = "KEY_AUDIO"
+0x12 = "KEY_MUTE"
+0x11 = "KEY_DOT"
+0x1d = "KEY_SETUP"
+0x40 = "KEY_POWER"
diff --git a/utils/keytable/rc_keymaps_userspace/allwinner_ba10_tv_box b/utils/keytable/rc_keymaps_userspace/allwinner_ba10_tv_box
deleted file mode 100644
index 5df16e31..00000000
--- a/utils/keytable/rc_keymaps_userspace/allwinner_ba10_tv_box
+++ /dev/null
@@ -1,15 +0,0 @@
-# table allwinner_ba10_tv_box, type: NEC
-0x206 KEY_UP
-0x216 KEY_VOLUMEDOWN
-0x217 KEY_NEXTSONG
-0x21a KEY_POWER
-0x21b KEY_BACK
-0x21e KEY_OK
-0x21f KEY_DOWN
-0x244 KEY_VOLUMEUP
-0x254 KEY_PREVIOUSSONG
-0x255 KEY_PLAYPAUSE
-0x258 KEY_MENU
-0x259 KEY_HOMEPAGE
-0x25c KEY_RIGHT
-0x25d KEY_LEFT
diff --git a/utils/keytable/rc_keymaps_userspace/allwinner_ba10_tv_box.toml b/utils/keytable/rc_keymaps_userspace/allwinner_ba10_tv_box.toml
new file mode 100644
index 00000000..adc40180
--- /dev/null
+++ b/utils/keytable/rc_keymaps_userspace/allwinner_ba10_tv_box.toml
@@ -0,0 +1,18 @@
+[[protocols]]
+name = "allwinner_ba10_tv_box"
+protocol = "nec"
+[protocols.scancodes]
+0x206 = "KEY_UP"
+0x216 = "KEY_VOLUMEDOWN"
+0x217 = "KEY_NEXTSONG"
+0x21a = "KEY_POWER"
+0x21b = "KEY_BACK"
+0x21e = "KEY_OK"
+0x21f = "KEY_DOWN"
+0x244 = "KEY_VOLUMEUP"
+0x254 = "KEY_PREVIOUSSONG"
+0x255 = "KEY_PLAYPAUSE"
+0x258 = "KEY_MENU"
+0x259 = "KEY_HOMEPAGE"
+0x25c = "KEY_RIGHT"
+0x25d = "KEY_LEFT"
diff --git a/utils/keytable/rc_keymaps_userspace/allwinner_i12_a20_tv_box b/utils/keytable/rc_keymaps_userspace/allwinner_i12_a20_tv_box
deleted file mode 100644
index e87717cd..00000000
--- a/utils/keytable/rc_keymaps_userspace/allwinner_i12_a20_tv_box
+++ /dev/null
@@ -1,28 +0,0 @@
-# table allwinner_i12_a20_tv_box, type: NEC
-0x00 KEY_7
-0x01 KEY_4
-0x02 KEY_1
-0x03 KEY_VOLUMEDOWN
-0x04 KEY_8
-0x05 KEY_5
-0x06 KEY_2
-0x07 KEY_BACK
-0x08 KEY_9
-0x09 KEY_6
-0x0a KEY_3
-0x0b KEY_NEXTSONG
-0x0c KEY_WWW
-0x0d KEY_0
-0x0e KEY_BACKSPACE
-0x40 KEY_VOLUMEUP
-0x41 KEY_LEFT
-0x42 KEY_HOMEPAGE
-0x43 KEY_POWER
-0x44 KEY_DOWN
-0x45 KEY_OK
-0x46 KEY_UP
-0x47 KEY_CONTEXT_MENU
-0x48 KEY_PREVIOUSSONG
-0x49 KEY_RIGHT
-0x4a KEY_MENU
-0x4b KEY_MUTE
diff --git a/utils/keytable/rc_keymaps_userspace/allwinner_i12_a20_tv_box.toml b/utils/keytable/rc_keymaps_userspace/allwinner_i12_a20_tv_box.toml
new file mode 100644
index 00000000..d5ffe939
--- /dev/null
+++ b/utils/keytable/rc_keymaps_userspace/allwinner_i12_a20_tv_box.toml
@@ -0,0 +1,31 @@
+[[protocols]]
+name = "allwinner_i12_a20_tv_box"
+protocol = "nec"
+[protocols.scancodes]
+0x00 = "KEY_7"
+0x01 = "KEY_4"
+0x02 = "KEY_1"
+0x03 = "KEY_VOLUMEDOWN"
+0x04 = "KEY_8"
+0x05 = "KEY_5"
+0x06 = "KEY_2"
+0x07 = "KEY_BACK"
+0x08 = "KEY_9"
+0x09 = "KEY_6"
+0x0a = "KEY_3"
+0x0b = "KEY_NEXTSONG"
+0x0c = "KEY_WWW"
+0x0d = "KEY_0"
+0x0e = "KEY_BACKSPACE"
+0x40 = "KEY_VOLUMEUP"
+0x41 = "KEY_LEFT"
+0x42 = "KEY_HOMEPAGE"
+0x43 = "KEY_POWER"
+0x44 = "KEY_DOWN"
+0x45 = "KEY_OK"
+0x46 = "KEY_UP"
+0x47 = "KEY_CONTEXT_MENU"
+0x48 = "KEY_PREVIOUSSONG"
+0x49 = "KEY_RIGHT"
+0x4a = "KEY_MENU"
+0x4b = "KEY_MUTE"
diff --git a/utils/keytable/rc_keymaps_userspace/wobo_i5 b/utils/keytable/rc_keymaps_userspace/wobo_i5
deleted file mode 100644
index 38362c5d..00000000
--- a/utils/keytable/rc_keymaps_userspace/wobo_i5
+++ /dev/null
@@ -1,9 +0,0 @@
-# table wobo_i5, type: NEC
-0x01 KEY_POWER
-0x05 KEY_UP
-0x06 KEY_LEFT
-0x08 KEY_RIGHT
-0x09 KEY_PLAYPAUSE
-0x0a KEY_DOWN
-0x0c KEY_MENU
-0x0e KEY_BACK
diff --git a/utils/keytable/rc_keymaps_userspace/wobo_i5.toml b/utils/keytable/rc_keymaps_userspace/wobo_i5.toml
new file mode 100644
index 00000000..f88de434
--- /dev/null
+++ b/utils/keytable/rc_keymaps_userspace/wobo_i5.toml
@@ -0,0 +1,12 @@
+[[protocols]]
+name = "wobo_i5"
+protocol = "nec"
+[protocols.scancodes]
+0x01 = "KEY_POWER"
+0x05 = "KEY_UP"
+0x06 = "KEY_LEFT"
+0x08 = "KEY_RIGHT"
+0x09 = "KEY_PLAYPAUSE"
+0x0a = "KEY_DOWN"
+0x0c = "KEY_MENU"
+0x0e = "KEY_BACK"
diff --git a/utils/keytable/rc_maps.cfg b/utils/keytable/rc_maps.cfg
index 9c4cad96..03904687 100644
--- a/utils/keytable/rc_maps.cfg
+++ b/utils/keytable/rc_maps.cfg
@@ -20,142 +20,142 @@
 #		/etc/rc_keymaps.
 # For example:
 # driver	table				file
-# cx8800	*				./keycodes/rc5_hauppauge_new
-# *		rc-avermedia-m135a-rm-jx	./keycodes/kworld_315u
-# saa7134	rc-avermedia-m135a-rm-jx	./keycodes/keycodes/nec_terratec_cinergy_xs
-# em28xx	*				./keycodes/kworld_315u
-# *		*				./keycodes/rc5_hauppauge_new
+# cx8800	*				./keycodes/rc5_hauppauge_new.toml
+# *		rc-avermedia-m135a-rm-jx	./keycodes/kworld_315u.toml
+# saa7134	rc-avermedia-m135a-rm-jx	./keycodes/keycodes/nec_terratec_cinergy_xs.toml
+# em28xx	*				./keycodes/kworld_315u.toml
+# *		*				./keycodes/rc5_hauppauge_new.toml
 
 # Table to automatically load the rc maps for the bundled IR's provided with the
 # devices supported by the linux kernel
 
 #driver table                    file
-*	rc-adstech-dvb-t-pci     adstech_dvb_t_pci
-*	rc-alink-dtu-m           alink_dtu_m
-*	rc-anysee                anysee
-*	rc-apac-viewcomp         apac_viewcomp
-*	rc-astrometa-t2hybrid    astrometa_t2hybrid
-*	rc-asus-pc39             asus_pc39
-*	rc-asus-ps3-100          asus_ps3_100
-*	rc-ati-tv-wonder-hd-600  ati_tv_wonder_hd_600
-*	rc-ati-x10               ati_x10
-*	rc-avermedia-a16d        avermedia_a16d
-*	rc-avermedia-cardbus     avermedia_cardbus
-*	rc-avermedia-dvbt        avermedia_dvbt
-*	rc-avermedia-m135a       avermedia_m135a
-*	rc-avermedia-m733a-rm-k6 avermedia_m733a_rm_k6
-*	rc-avermedia-rm-ks       avermedia_rm_ks
-*	rc-avermedia             avermedia
-*	rc-avertv-303            avertv_303
-*	rc-azurewave-ad-tu700    azurewave_ad_tu700
-*	rc-behold-columbus       behold_columbus
-*	rc-behold                behold
-*	rc-budget-ci-old         budget_ci_old
-*	rc-cec                   cec
-*	rc-cinergy-1400          cinergy_1400
-*	rc-cinergy               cinergy
-*	rc-d680-dmb              d680_dmb
-*	rc-delock-61959          delock_61959
-*	rc-dib0700-nec           dib0700_nec
-*	rc-dib0700-rc5           dib0700_rc5
-*	rc-digitalnow-tinytwin   digitalnow_tinytwin
-*	rc-digittrade            digittrade
-*	rc-dm1105-nec            dm1105_nec
-*	rc-dntv-live-dvb-t       dntv_live_dvb_t
-*	rc-dntv-live-dvbt-pro    dntv_live_dvbt_pro
-*	rc-dtt200u               dtt200u
-*	rc-dvbsky                dvbsky
-*	rc-dvico-mce             dvico_mce
-*	rc-dvico-portable        dvico_portable
-*	rc-em-terratec           em_terratec
-*	rc-encore-enltv-fm53     encore_enltv_fm53
-*	rc-encore-enltv          encore_enltv
-*	rc-encore-enltv2         encore_enltv2
-*	rc-evga-indtube          evga_indtube
-*	rc-eztv                  eztv
-*	rc-flydvb                flydvb
-*	rc-flyvideo              flyvideo
-*	rc-fusionhdtv-mce        fusionhdtv_mce
-*	rc-gadmei-rm008z         gadmei_rm008z
-*	rc-geekbox               geekbox
-*	rc-genius-tvgo-a11mce    genius_tvgo_a11mce
-*	rc-gotview7135           gotview7135
-*	rc-hauppauge             hauppauge
-*	rc-hisi-poplar           hisi_poplar
-*	rc-hisi-tv-demo          hisi_tv_demo
-*	rc-imon-mce              imon_mce
-*	rc-imon-pad              imon_pad
-*	rc-imon-rsc              imon_rsc
-*	rc-iodata-bctv7e         iodata_bctv7e
-*	rc-it913x-v1             it913x_v1
-*	rc-it913x-v2             it913x_v2
-*	rc-kaiomy                kaiomy
-*	rc-kworld-315u           kworld_315u
-*	rc-kworld-pc150u         kworld_pc150u
-*	rc-kworld-plus-tv-analog kworld_plus_tv_analog
-*	rc-leadtek-y04g0051      leadtek_y04g0051
-*	rc-lme2510               lme2510
-*	rc-manli                 manli
-*	rc-medion-x10-digitainer medion_x10_digitainer
-*	rc-medion-x10-or2x       medion_x10_or2x
-*	rc-medion-x10            medion_x10
-*	rc-msi-digivox-ii        msi_digivox_ii
-*	rc-msi-digivox-iii       msi_digivox_iii
-*	rc-msi-tvanywhere-plus   msi_tvanywhere_plus
-*	rc-msi-tvanywhere        msi_tvanywhere
-*	rc-nebula                nebula
-*	rc-nec-terratec-cinergy-xs nec_terratec_cinergy_xs
-*	rc-norwood               norwood
-*	rc-npgtech               npgtech
-*	rc-pctv-sedna            pctv_sedna
-*	rc-pinnacle-color        pinnacle_color
-*	rc-pinnacle-grey         pinnacle_grey
-*	rc-pinnacle-pctv-hd      pinnacle_pctv_hd
-*	rc-pixelview-002t        pixelview_002t
-*	rc-pixelview-mk12        pixelview_mk12
-*	rc-pixelview-new         pixelview_new
-*	rc-pixelview             pixelview
-*	rc-powercolor-real-angel powercolor_real_angel
-*	rc-proteus-2309          proteus_2309
-*	rc-purpletv              purpletv
-*	rc-pv951                 pv951
-*	rc-rc6-mce               rc6_mce
-*	rc-real-audio-220-32-keys real_audio_220_32_keys
-*	rc-reddo                 reddo
-*	rc-snapstream-firefly    snapstream_firefly
-*	rc-streamzap             streamzap
-*	rc-su3000                su3000
-*	rc-tango                 tango
-*	rc-tbs-nec               tbs_nec
-*	rc-technisat-ts35        technisat_ts35
-*	rc-technisat-usb2        technisat_usb2
-*	rc-terratec-cinergy-c-pci terratec_cinergy_c_pci
-*	rc-terratec-cinergy-s2-hd terratec_cinergy_s2_hd
-*	rc-terratec-cinergy-xs   terratec_cinergy_xs
-*	rc-terratec-slim-2       terratec_slim_2
-*	rc-terratec-slim         terratec_slim
-*	rc-tevii-nec             tevii_nec
-*	rc-tivo                  tivo
-*	rc-total-media-in-hand-02 total_media_in_hand_02
-*	rc-total-media-in-hand   total_media_in_hand
-*	rc-trekstor              trekstor
-*	rc-tt-1500               tt_1500
-*	rc-twinhan-dtv-cab-ci    twinhan_dtv_cab_ci
-*	rc-twinhan1027           twinhan_vp1027_dvbs
-*	rc-videomate-k100        videomate_k100
-*	rc-videomate-s350        videomate_s350
-*	rc-videomate-tv-pvr      videomate_tv_pvr
-*	rc-winfast-usbii-deluxe  winfast_usbii_deluxe
-*	rc-winfast               winfast
-*	rc-zx-irdec              zx_irdec
-# *	*			 af9005               # found in af9005-remote.c
-# *	*			 az6027               # found in az6027.c
-# *	*			 cinergyt2            # found in cinergyT2-core.c
-# *	*			 dibusb               # found in dibusb-common.c
-# *	*			 digitv               # found in digitv.c
-# *	*			 megasky              # found in m920x.c
-# *	*			 tvwalkertwin         # found in m920x.c
-# *	*			 pinnacle310e         # found in m920x.c
-# *	*			 haupp                # found in nova-t-usb2.c
-# *	*			 opera1               # found in opera1.c
-# *	*			 vp702x               # found in vp702x.c
+*	rc-adstech-dvb-t-pci     adstech_dvb_t_pci.toml
+*	rc-alink-dtu-m           alink_dtu_m.toml
+*	rc-anysee                anysee.toml
+*	rc-apac-viewcomp         apac_viewcomp.toml
+*	rc-astrometa-t2hybrid    astrometa_t2hybrid.toml
+*	rc-asus-pc39             asus_pc39.toml
+*	rc-asus-ps3-100          asus_ps3_100.toml
+*	rc-ati-tv-wonder-hd-600  ati_tv_wonder_hd_600.toml
+*	rc-ati-x10               ati_x10.toml
+*	rc-avermedia-a16d        avermedia_a16d.toml
+*	rc-avermedia-cardbus     avermedia_cardbus.toml
+*	rc-avermedia-dvbt        avermedia_dvbt.toml
+*	rc-avermedia-m135a       avermedia_m135a.toml
+*	rc-avermedia-m733a-rm-k6 avermedia_m733a_rm_k6.toml
+*	rc-avermedia-rm-ks       avermedia_rm_ks.toml
+*	rc-avermedia             avermedia.toml
+*	rc-avertv-303            avertv_303.toml
+*	rc-azurewave-ad-tu700    azurewave_ad_tu700.toml
+*	rc-behold-columbus       behold_columbus.toml
+*	rc-behold                behold.toml
+*	rc-budget-ci-old         budget_ci_old.toml
+*	rc-cec                   cec.toml
+*	rc-cinergy-1400          cinergy_1400.toml
+*	rc-cinergy               cinergy.toml
+*	rc-d680-dmb              d680_dmb.toml
+*	rc-delock-61959          delock_61959.toml
+*	rc-dib0700-nec           dib0700_nec.toml
+*	rc-dib0700-rc5           dib0700_rc5.toml
+*	rc-digitalnow-tinytwin   digitalnow_tinytwin.toml
+*	rc-digittrade            digittrade.toml
+*	rc-dm1105-nec            dm1105_nec.toml
+*	rc-dntv-live-dvb-t       dntv_live_dvb_t.toml
+*	rc-dntv-live-dvbt-pro    dntv_live_dvbt_pro.toml
+*	rc-dtt200u               dtt200u.toml
+*	rc-dvbsky                dvbsky.toml
+*	rc-dvico-mce             dvico_mce.toml
+*	rc-dvico-portable        dvico_portable.toml
+*	rc-em-terratec           em_terratec.toml
+*	rc-encore-enltv-fm53     encore_enltv_fm53.toml
+*	rc-encore-enltv          encore_enltv.toml
+*	rc-encore-enltv2         encore_enltv2.toml
+*	rc-evga-indtube          evga_indtube.toml
+*	rc-eztv                  eztv.toml
+*	rc-flydvb                flydvb.toml
+*	rc-flyvideo              flyvideo.toml
+*	rc-fusionhdtv-mce        fusionhdtv_mce.toml
+*	rc-gadmei-rm008z         gadmei_rm008z.toml
+*	rc-geekbox               geekbox.toml
+*	rc-genius-tvgo-a11mce    genius_tvgo_a11mce.toml
+*	rc-gotview7135           gotview7135.toml
+*	rc-hauppauge             hauppauge.toml
+*	rc-hisi-poplar           hisi_poplar.toml
+*	rc-hisi-tv-demo          hisi_tv_demo.toml
+*	rc-imon-mce              imon_mce.toml
+*	rc-imon-pad              imon_pad.toml
+*	rc-imon-rsc              imon_rsc.toml
+*	rc-iodata-bctv7e         iodata_bctv7e.toml
+*	rc-it913x-v1             it913x_v1.toml
+*	rc-it913x-v2             it913x_v2.toml
+*	rc-kaiomy                kaiomy.toml
+*	rc-kworld-315u           kworld_315u.toml
+*	rc-kworld-pc150u         kworld_pc150u.toml
+*	rc-kworld-plus-tv-analog kworld_plus_tv_analog.toml
+*	rc-leadtek-y04g0051      leadtek_y04g0051.toml
+*	rc-lme2510               lme2510.toml
+*	rc-manli                 manli.toml
+*	rc-medion-x10-digitainer medion_x10_digitainer.toml
+*	rc-medion-x10-or2x       medion_x10_or2x.toml
+*	rc-medion-x10            medion_x10.toml
+*	rc-msi-digivox-ii        msi_digivox_ii.toml
+*	rc-msi-digivox-iii       msi_digivox_iii.toml
+*	rc-msi-tvanywhere-plus   msi_tvanywhere_plus.toml
+*	rc-msi-tvanywhere        msi_tvanywhere.toml
+*	rc-nebula                nebula.toml
+*	rc-nec-terratec-cinergy-xs nec_terratec_cinergy_xs.toml
+*	rc-norwood               norwood.toml
+*	rc-npgtech               npgtech.toml
+*	rc-pctv-sedna            pctv_sedna.toml
+*	rc-pinnacle-color        pinnacle_color.toml
+*	rc-pinnacle-grey         pinnacle_grey.toml
+*	rc-pinnacle-pctv-hd      pinnacle_pctv_hd.toml
+*	rc-pixelview-002t        pixelview_002t.toml
+*	rc-pixelview-mk12        pixelview_mk12.toml
+*	rc-pixelview-new         pixelview_new.toml
+*	rc-pixelview             pixelview.toml
+*	rc-powercolor-real-angel powercolor_real_angel.toml
+*	rc-proteus-2309          proteus_2309.toml
+*	rc-purpletv              purpletv.toml
+*	rc-pv951                 pv951.toml
+*	rc-rc6-mce               rc6_mce.toml
+*	rc-real-audio-220-32-keys real_audio_220_32_keys.toml
+*	rc-reddo                 reddo.toml
+*	rc-snapstream-firefly    snapstream_firefly.toml
+*	rc-streamzap             streamzap.toml
+*	rc-su3000                su3000.toml
+*	rc-tango                 tango.toml
+*	rc-tbs-nec               tbs_nec.toml
+*	rc-technisat-ts35        technisat_ts35.toml
+*	rc-technisat-usb2        technisat_usb2.toml
+*	rc-terratec-cinergy-c-pci terratec_cinergy_c_pci.toml
+*	rc-terratec-cinergy-s2-hd terratec_cinergy_s2_hd.toml
+*	rc-terratec-cinergy-xs   terratec_cinergy_xs.toml
+*	rc-terratec-slim-2       terratec_slim_2.toml
+*	rc-terratec-slim         terratec_slim.toml
+*	rc-tevii-nec             tevii_nec.toml
+*	rc-tivo                  tivo.toml
+*	rc-total-media-in-hand-02 total_media_in_hand_02.toml
+*	rc-total-media-in-hand   total_media_in_hand.toml
+*	rc-trekstor              trekstor.toml
+*	rc-tt-1500               tt_1500.toml
+*	rc-twinhan-dtv-cab-ci    twinhan_dtv_cab_ci.toml
+*	rc-twinhan1027           twinhan_vp1027_dvbs.toml
+*	rc-videomate-k100        videomate_k100.toml
+*	rc-videomate-s350        videomate_s350.toml
+*	rc-videomate-tv-pvr      videomate_tv_pvr.toml
+*	rc-winfast-usbii-deluxe  winfast_usbii_deluxe.toml
+*	rc-winfast               winfast.toml
+*	rc-zx-irdec              zx_irdec.toml
+# *	*			 af9005.toml          # found in af9005-remote.c
+# *	*			 az6027.toml          # found in az6027.c
+# *	*			 cinergyt2.toml       # found in cinergyT2-core.c
+# *	*			 dibusb.toml          # found in dibusb-common.c
+# *	*			 digitv.toml          # found in digitv.c
+# *	*			 megasky.toml         # found in m920x.c
+# *	*			 tvwalkertwin.toml    # found in m920x.c
+# *	*			 pinnacle310e.toml    # found in m920x.c
+# *	*			 haupp.toml           # found in nova-t-usb2.c
+# *	*			 opera1.toml          # found in opera1.c
+# *	*			 vp702x.toml          # found in vp702x.c
-- 
2.17.1
