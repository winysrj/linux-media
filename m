Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46327 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbeFXMzz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Jun 2018 08:55:55 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH v2 2/4] keytable: convert keymaps to new toml format
Date: Sun, 24 Jun 2018 13:55:49 +0100
Message-Id: <cccd85d3718559570403dc655c818aeb0199e344.1529844415.git.sean@mess.org>
In-Reply-To: <cover.1529844415.git.sean@mess.org>
References: <cover.1529844415.git.sean@mess.org>
In-Reply-To: <cover.1529844415.git.sean@mess.org>
References: <cover.1529844415.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We will be added new BPF based keymaps which require the toml format.
Convert all the existing keymaps to toml, so that only one format is used.

Include the protocol variant as well. This will be useful in the future if
we want to use rc keymaps for transmitting IR.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/gen_keytables.pl               |  33 ++-
 utils/keytable/ir-keytable.1.in               |   4 +-
 utils/keytable/rc_keymaps/adstech_dvb_t_pci   |  45 ---
 .../rc_keymaps/adstech_dvb_t_pci.toml         |  47 +++
 utils/keytable/rc_keymaps/af9005              |  37 ---
 utils/keytable/rc_keymaps/af9005.toml         |  39 +++
 utils/keytable/rc_keymaps/alink_dtu_m         |  19 --
 utils/keytable/rc_keymaps/alink_dtu_m.toml    |  23 ++
 .../keytable/rc_keymaps/allwinner_ba10_tv_box |  15 -
 .../rc_keymaps/allwinner_i12_a20_tv_box       |  28 --
 utils/keytable/rc_keymaps/anysee              |  45 ---
 utils/keytable/rc_keymaps/anysee.toml         |  49 ++++
 utils/keytable/rc_keymaps/apac_viewcomp       |  32 ---
 utils/keytable/rc_keymaps/apac_viewcomp.toml  |  34 +++
 utils/keytable/rc_keymaps/astrometa_t2hybrid  |  22 --
 .../rc_keymaps/astrometa_t2hybrid.toml        |  26 ++
 utils/keytable/rc_keymaps/asus_pc39           |  40 ---
 utils/keytable/rc_keymaps/asus_pc39.toml      |  44 +++
 utils/keytable/rc_keymaps/asus_ps3_100        |  42 ---
 utils/keytable/rc_keymaps/asus_ps3_100.toml   |  46 +++
 .../keytable/rc_keymaps/ati_tv_wonder_hd_600  |  25 --
 .../rc_keymaps/ati_tv_wonder_hd_600.toml      |  27 ++
 utils/keytable/rc_keymaps/ati_x10             |  49 ----
 utils/keytable/rc_keymaps/ati_x10.toml        |  51 ++++
 utils/keytable/rc_keymaps/avermedia           |  37 ---
 utils/keytable/rc_keymaps/avermedia.toml      |  39 +++
 utils/keytable/rc_keymaps/avermedia_a16d      |  35 ---
 utils/keytable/rc_keymaps/avermedia_a16d.toml |  37 +++
 utils/keytable/rc_keymaps/avermedia_cardbus   |  55 ----
 .../rc_keymaps/avermedia_cardbus.toml         |  57 ++++
 utils/keytable/rc_keymaps/avermedia_dvbt      |  35 ---
 utils/keytable/rc_keymaps/avermedia_dvbt.toml |  37 +++
 utils/keytable/rc_keymaps/avermedia_m135a     |  81 ------
 .../keytable/rc_keymaps/avermedia_m135a.toml  |  85 ++++++
 .../keytable/rc_keymaps/avermedia_m733a_rm_k6 |  45 ---
 .../rc_keymaps/avermedia_m733a_rm_k6.toml     |  49 ++++
 utils/keytable/rc_keymaps/avermedia_rm_ks     |  28 --
 .../keytable/rc_keymaps/avermedia_rm_ks.toml  |  32 +++
 utils/keytable/rc_keymaps/avertv_303          |  37 ---
 utils/keytable/rc_keymaps/avertv_303.toml     |  39 +++
 utils/keytable/rc_keymaps/az6027              |   3 -
 utils/keytable/rc_keymaps/az6027.toml         |   5 +
 utils/keytable/rc_keymaps/azurewave_ad_tu700  |  54 ----
 .../rc_keymaps/azurewave_ad_tu700.toml        |  58 ++++
 utils/keytable/rc_keymaps/behold              |  35 ---
 utils/keytable/rc_keymaps/behold.toml         |  39 +++
 utils/keytable/rc_keymaps/behold_columbus     |  29 --
 .../keytable/rc_keymaps/behold_columbus.toml  |  31 ++
 utils/keytable/rc_keymaps/budget_ci_old       |  46 ---
 utils/keytable/rc_keymaps/budget_ci_old.toml  |  48 ++++
 utils/keytable/rc_keymaps/cec                 |  98 -------
 utils/keytable/rc_keymaps/cec.toml            | 100 +++++++
 utils/keytable/rc_keymaps/cinergy             |  37 ---
 utils/keytable/rc_keymaps/cinergy.toml        |  39 +++
 utils/keytable/rc_keymaps/cinergy_1400        |  38 ---
 utils/keytable/rc_keymaps/cinergy_1400.toml   |  40 +++
 utils/keytable/rc_keymaps/cinergyt2           |  38 ---
 utils/keytable/rc_keymaps/cinergyt2.toml      |  40 +++
 utils/keytable/rc_keymaps/d680_dmb            |  36 ---
 utils/keytable/rc_keymaps/d680_dmb.toml       |  38 +++
 utils/keytable/rc_keymaps/delock_61959        |  33 ---
 utils/keytable/rc_keymaps/delock_61959.toml   |  37 +++
 utils/keytable/rc_keymaps/dib0700_nec         |  71 -----
 utils/keytable/rc_keymaps/dib0700_nec.toml    |  75 +++++
 utils/keytable/rc_keymaps/dib0700_rc5         | 181 ------------
 utils/keytable/rc_keymaps/dib0700_rc5.toml    | 185 ++++++++++++
 utils/keytable/rc_keymaps/dibusb              | 112 --------
 utils/keytable/rc_keymaps/dibusb.toml         | 114 ++++++++
 utils/keytable/rc_keymaps/digitalnow_tinytwin |  50 ----
 .../rc_keymaps/digitalnow_tinytwin.toml       |  54 ++++
 utils/keytable/rc_keymaps/digittrade          |  29 --
 utils/keytable/rc_keymaps/digittrade.toml     |  33 +++
 utils/keytable/rc_keymaps/digitv              |  56 ----
 utils/keytable/rc_keymaps/digitv.toml         |  58 ++++
 utils/keytable/rc_keymaps/dm1105_nec          |  32 ---
 utils/keytable/rc_keymaps/dm1105_nec.toml     |  34 +++
 utils/keytable/rc_keymaps/dntv_live_dvb_t     |  33 ---
 .../keytable/rc_keymaps/dntv_live_dvb_t.toml  |  35 +++
 utils/keytable/rc_keymaps/dntv_live_dvbt_pro  |  54 ----
 .../rc_keymaps/dntv_live_dvbt_pro.toml        |  56 ++++
 utils/keytable/rc_keymaps/dtt200u             |  19 --
 utils/keytable/rc_keymaps/dtt200u.toml        |  23 ++
 utils/keytable/rc_keymaps/dvbsky              |  33 ---
 utils/keytable/rc_keymaps/dvbsky.toml         |  37 +++
 utils/keytable/rc_keymaps/dvico_mce           |  46 ---
 utils/keytable/rc_keymaps/dvico_mce.toml      |  50 ++++
 utils/keytable/rc_keymaps/dvico_portable      |  37 ---
 utils/keytable/rc_keymaps/dvico_portable.toml |  41 +++
 utils/keytable/rc_keymaps/em_terratec         |  29 --
 utils/keytable/rc_keymaps/em_terratec.toml    |  31 ++
 utils/keytable/rc_keymaps/encore_enltv        |  53 ----
 utils/keytable/rc_keymaps/encore_enltv.toml   |  55 ++++
 utils/keytable/rc_keymaps/encore_enltv2       |  40 ---
 utils/keytable/rc_keymaps/encore_enltv2.toml  |  42 +++
 utils/keytable/rc_keymaps/encore_enltv_fm53   |  30 --
 .../rc_keymaps/encore_enltv_fm53.toml         |  32 +++
 utils/keytable/rc_keymaps/evga_indtube        |  17 --
 utils/keytable/rc_keymaps/evga_indtube.toml   |  19 ++
 utils/keytable/rc_keymaps/eztv                |  45 ---
 utils/keytable/rc_keymaps/eztv.toml           |  47 +++
 utils/keytable/rc_keymaps/flydvb              |  33 ---
 utils/keytable/rc_keymaps/flydvb.toml         |  35 +++
 utils/keytable/rc_keymaps/flyvideo            |  28 --
 utils/keytable/rc_keymaps/flyvideo.toml       |  30 ++
 utils/keytable/rc_keymaps/fusionhdtv_mce      |  46 ---
 utils/keytable/rc_keymaps/fusionhdtv_mce.toml |  48 ++++
 utils/keytable/rc_keymaps/gadmei_rm008z       |  32 ---
 utils/keytable/rc_keymaps/gadmei_rm008z.toml  |  34 +++
 utils/keytable/rc_keymaps/geekbox             |  13 -
 utils/keytable/rc_keymaps/geekbox.toml        |  17 ++
 utils/keytable/rc_keymaps/genius_tvgo_a11mce  |  33 ---
 .../rc_keymaps/genius_tvgo_a11mce.toml        |  35 +++
 utils/keytable/rc_keymaps/gotview7135         |  35 ---
 utils/keytable/rc_keymaps/gotview7135.toml    |  37 +++
 utils/keytable/rc_keymaps/haupp               |  46 ---
 utils/keytable/rc_keymaps/haupp.toml          |  48 ++++
 utils/keytable/rc_keymaps/hauppauge           | 173 -----------
 utils/keytable/rc_keymaps/hauppauge.toml      | 177 ++++++++++++
 utils/keytable/rc_keymaps/hisi_poplar         |  30 --
 utils/keytable/rc_keymaps/hisi_poplar.toml    |  34 +++
 utils/keytable/rc_keymaps/hisi_tv_demo        |  42 ---
 utils/keytable/rc_keymaps/hisi_tv_demo.toml   |  46 +++
 utils/keytable/rc_keymaps/imon_mce            |  78 -----
 utils/keytable/rc_keymaps/imon_mce.toml       |  82 ++++++
 utils/keytable/rc_keymaps/imon_pad            |  91 ------
 utils/keytable/rc_keymaps/imon_pad.toml       |  93 ++++++
 utils/keytable/rc_keymaps/imon_rsc            |  44 ---
 utils/keytable/rc_keymaps/imon_rsc.toml       |  48 ++++
 utils/keytable/rc_keymaps/iodata_bctv7e       |  37 ---
 utils/keytable/rc_keymaps/iodata_bctv7e.toml  |  39 +++
 utils/keytable/rc_keymaps/it913x_v1           |  53 ----
 utils/keytable/rc_keymaps/it913x_v1.toml      |  57 ++++
 utils/keytable/rc_keymaps/it913x_v2           |  48 ----
 utils/keytable/rc_keymaps/it913x_v2.toml      |  52 ++++
 utils/keytable/rc_keymaps/kaiomy              |  33 ---
 utils/keytable/rc_keymaps/kaiomy.toml         |  35 +++
 utils/keytable/rc_keymaps/kworld_315u         |  33 ---
 utils/keytable/rc_keymaps/kworld_315u.toml    |  37 +++
 utils/keytable/rc_keymaps/kworld_pc150u       |  45 ---
 utils/keytable/rc_keymaps/kworld_pc150u.toml  |  47 +++
 .../keytable/rc_keymaps/kworld_plus_tv_analog |  32 ---
 .../rc_keymaps/kworld_plus_tv_analog.toml     |  34 +++
 utils/keytable/rc_keymaps/leadtek_y04g0051    |  51 ----
 .../keytable/rc_keymaps/leadtek_y04g0051.toml |  55 ++++
 utils/keytable/rc_keymaps/lme2510             |  67 -----
 utils/keytable/rc_keymaps/lme2510.toml        |  71 +++++
 utils/keytable/rc_keymaps/manli               |  32 ---
 utils/keytable/rc_keymaps/manli.toml          |  34 +++
 utils/keytable/rc_keymaps/medion_x10          |  54 ----
 utils/keytable/rc_keymaps/medion_x10.toml     |  56 ++++
 .../keytable/rc_keymaps/medion_x10_digitainer |  50 ----
 .../rc_keymaps/medion_x10_digitainer.toml     |  52 ++++
 utils/keytable/rc_keymaps/medion_x10_or2x     |  46 ---
 .../keytable/rc_keymaps/medion_x10_or2x.toml  |  48 ++++
 utils/keytable/rc_keymaps/megasky             |  17 --
 utils/keytable/rc_keymaps/megasky.toml        |  19 ++
 utils/keytable/rc_keymaps/msi_digivox_ii      |  19 --
 utils/keytable/rc_keymaps/msi_digivox_ii.toml |  23 ++
 utils/keytable/rc_keymaps/msi_digivox_iii     |  33 ---
 .../keytable/rc_keymaps/msi_digivox_iii.toml  |  37 +++
 utils/keytable/rc_keymaps/msi_tvanywhere      |  25 --
 utils/keytable/rc_keymaps/msi_tvanywhere.toml |  27 ++
 utils/keytable/rc_keymaps/msi_tvanywhere_plus |  37 ---
 .../rc_keymaps/msi_tvanywhere_plus.toml       |  39 +++
 utils/keytable/rc_keymaps/nebula              |  56 ----
 utils/keytable/rc_keymaps/nebula.toml         |  60 ++++
 .../rc_keymaps/nec_terratec_cinergy_xs        |  86 ------
 .../rc_keymaps/nec_terratec_cinergy_xs.toml   |  90 ++++++
 utils/keytable/rc_keymaps/norwood             |  36 ---
 utils/keytable/rc_keymaps/norwood.toml        |  38 +++
 utils/keytable/rc_keymaps/npgtech             |  36 ---
 utils/keytable/rc_keymaps/npgtech.toml        |  38 +++
 utils/keytable/rc_keymaps/opera1              |  27 --
 utils/keytable/rc_keymaps/opera1.toml         |  29 ++
 utils/keytable/rc_keymaps/pctv_sedna          |  33 ---
 utils/keytable/rc_keymaps/pctv_sedna.toml     |  35 +++
 utils/keytable/rc_keymaps/pinnacle310e        |  54 ----
 utils/keytable/rc_keymaps/pinnacle310e.toml   |  56 ++++
 utils/keytable/rc_keymaps/pinnacle_color      |  43 ---
 utils/keytable/rc_keymaps/pinnacle_color.toml |  45 +++
 utils/keytable/rc_keymaps/pinnacle_grey       |  42 ---
 utils/keytable/rc_keymaps/pinnacle_grey.toml  |  44 +++
 utils/keytable/rc_keymaps/pinnacle_pctv_hd    |  27 --
 .../keytable/rc_keymaps/pinnacle_pctv_hd.toml |  31 ++
 utils/keytable/rc_keymaps/pixelview           |  33 ---
 utils/keytable/rc_keymaps/pixelview.toml      |  35 +++
 utils/keytable/rc_keymaps/pixelview_002t      |  27 --
 utils/keytable/rc_keymaps/pixelview_002t.toml |  31 ++
 utils/keytable/rc_keymaps/pixelview_mk12      |  32 ---
 utils/keytable/rc_keymaps/pixelview_mk12.toml |  36 +++
 utils/keytable/rc_keymaps/pixelview_new       |  32 ---
 utils/keytable/rc_keymaps/pixelview_new.toml  |  34 +++
 .../keytable/rc_keymaps/powercolor_real_angel |  36 ---
 .../rc_keymaps/powercolor_real_angel.toml     |  38 +++
 utils/keytable/rc_keymaps/proteus_2309        |  25 --
 utils/keytable/rc_keymaps/proteus_2309.toml   |  27 ++
 utils/keytable/rc_keymaps/purpletv            |  36 ---
 utils/keytable/rc_keymaps/purpletv.toml       |  38 +++
 utils/keytable/rc_keymaps/pv951               |  32 ---
 utils/keytable/rc_keymaps/pv951.toml          |  34 +++
 utils/keytable/rc_keymaps/rc6_mce             |  65 -----
 utils/keytable/rc_keymaps/rc6_mce.toml        |  69 +++++
 .../rc_keymaps/real_audio_220_32_keys         |  29 --
 .../rc_keymaps/real_audio_220_32_keys.toml    |  31 ++
 utils/keytable/rc_keymaps/reddo               |  24 --
 utils/keytable/rc_keymaps/reddo.toml          |  28 ++
 utils/keytable/rc_keymaps/snapstream_firefly  |  49 ----
 .../rc_keymaps/snapstream_firefly.toml        |  51 ++++
 utils/keytable/rc_keymaps/streamzap           |  36 ---
 utils/keytable/rc_keymaps/streamzap.toml      |  38 +++
 utils/keytable/rc_keymaps/su3000              |  36 ---
 utils/keytable/rc_keymaps/su3000.toml         |  40 +++
 utils/keytable/rc_keymaps/tango               |  51 ----
 utils/keytable/rc_keymaps/tango.toml          |  55 ++++
 utils/keytable/rc_keymaps/tbs_nec             |  35 ---
 utils/keytable/rc_keymaps/tbs_nec.toml        |  37 +++
 utils/keytable/rc_keymaps/technisat_ts35      |  34 ---
 utils/keytable/rc_keymaps/technisat_ts35.toml |  36 +++
 utils/keytable/rc_keymaps/technisat_usb2      |  34 ---
 utils/keytable/rc_keymaps/technisat_usb2.toml |  38 +++
 .../rc_keymaps/terratec_cinergy_c_pci         |  49 ----
 .../rc_keymaps/terratec_cinergy_c_pci.toml    |  51 ++++
 .../rc_keymaps/terratec_cinergy_s2_hd         |  49 ----
 .../rc_keymaps/terratec_cinergy_s2_hd.toml    |  51 ++++
 utils/keytable/rc_keymaps/terratec_cinergy_xs |  48 ----
 .../rc_keymaps/terratec_cinergy_xs.toml       |  50 ++++
 utils/keytable/rc_keymaps/terratec_slim       |  29 --
 utils/keytable/rc_keymaps/terratec_slim.toml  |  33 +++
 utils/keytable/rc_keymaps/terratec_slim_2     |  19 --
 .../keytable/rc_keymaps/terratec_slim_2.toml  |  23 ++
 utils/keytable/rc_keymaps/tevii_nec           |  48 ----
 utils/keytable/rc_keymaps/tevii_nec.toml      |  50 ++++
 utils/keytable/rc_keymaps/tivo                |  46 ---
 utils/keytable/rc_keymaps/tivo.toml           |  48 ++++
 utils/keytable/rc_keymaps/total_media_in_hand |  36 ---
 .../rc_keymaps/total_media_in_hand.toml       |  40 +++
 .../rc_keymaps/total_media_in_hand_02         |  36 ---
 .../rc_keymaps/total_media_in_hand_02.toml    |  40 +++
 utils/keytable/rc_keymaps/trekstor            |  29 --
 utils/keytable/rc_keymaps/trekstor.toml       |  33 +++
 utils/keytable/rc_keymaps/tt_1500             |  40 ---
 utils/keytable/rc_keymaps/tt_1500.toml        |  44 +++
 utils/keytable/rc_keymaps/tvwalkertwin        |  18 --
 utils/keytable/rc_keymaps/tvwalkertwin.toml   |  20 ++
 utils/keytable/rc_keymaps/twinhan_dtv_cab_ci  |  54 ----
 .../rc_keymaps/twinhan_dtv_cab_ci.toml        |  56 ++++
 utils/keytable/rc_keymaps/twinhan_vp1027_dvbs |  54 ----
 .../rc_keymaps/twinhan_vp1027_dvbs.toml       |  58 ++++
 utils/keytable/rc_keymaps/videomate_k100      |  52 ----
 utils/keytable/rc_keymaps/videomate_k100.toml |  54 ++++
 utils/keytable/rc_keymaps/videomate_s350      |  45 ---
 utils/keytable/rc_keymaps/videomate_s350.toml |  47 +++
 utils/keytable/rc_keymaps/videomate_tv_pvr    |  38 ---
 .../keytable/rc_keymaps/videomate_tv_pvr.toml |  40 +++
 utils/keytable/rc_keymaps/vp702x              |   3 -
 utils/keytable/rc_keymaps/vp702x.toml         |   5 +
 utils/keytable/rc_keymaps/winfast             |  57 ----
 utils/keytable/rc_keymaps/winfast.toml        |  59 ++++
 .../keytable/rc_keymaps/winfast_usbii_deluxe  |  29 --
 .../rc_keymaps/winfast_usbii_deluxe.toml      |  31 ++
 utils/keytable/rc_keymaps/wobo_i5             |   9 -
 utils/keytable/rc_keymaps/zx_irdec            |  41 ---
 utils/keytable/rc_keymaps/zx_irdec.toml       |  45 +++
 .../allwinner_ba10_tv_box                     |  15 -
 .../allwinner_ba10_tv_box.toml                |  17 ++
 .../allwinner_i12_a20_tv_box                  |  28 --
 .../allwinner_i12_a20_tv_box.toml             |  30 ++
 utils/keytable/rc_keymaps_userspace/wobo_i5   |   9 -
 .../rc_keymaps_userspace/wobo_i5.toml         |  11 +
 utils/keytable/rc_maps.cfg                    | 268 +++++++++---------
 270 files changed, 6038 insertions(+), 5717 deletions(-)
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
index 3045f257..71b36adb 100755
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
+	print OUT "name = \"$keyname\"\n";
+	print OUT "protocol = \"$type\"\n";
+	if ($type eq "nec" || $type eq "rc5" || $type eq "rc6" || $type eq "sony") {
+		print OUT "[${type}]\n";
+		print OUT "variant = \"$variant\"\n";
+	}
+	print OUT "[${type}.scancodes]\n";
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
index db1843b3..795fd883 100644
--- a/utils/keytable/ir-keytable.1.in
+++ b/utils/keytable/ir-keytable.1.in
@@ -94,11 +94,11 @@ To list all connected Remote Controller devices:
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
index 00000000..14cc77f7
--- /dev/null
+++ b/utils/keytable/rc_keymaps/adstech_dvb_t_pci.toml
@@ -0,0 +1,47 @@
+name = "adstech_dvb_t_pci"
+protocol = "unknown"
+[unknown.scancodes]
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
index 00000000..a535e8e8
--- /dev/null
+++ b/utils/keytable/rc_keymaps/af9005.toml
@@ -0,0 +1,39 @@
+name = "af9005"
+protocol = "unknown"
+[unknown.scancodes]
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
index 00000000..830ffdd4
--- /dev/null
+++ b/utils/keytable/rc_keymaps/alink_dtu_m.toml
@@ -0,0 +1,23 @@
+name = "alink_dtu_m"
+protocol = "nec"
+[nec]
+variant = "nec"
+[nec.scancodes]
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
index 00000000..e70751c4
--- /dev/null
+++ b/utils/keytable/rc_keymaps/anysee.toml
@@ -0,0 +1,49 @@
+name = "anysee"
+protocol = "nec"
+[nec]
+variant = "nec"
+[nec.scancodes]
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
index 00000000..ac7be9e4
--- /dev/null
+++ b/utils/keytable/rc_keymaps/apac_viewcomp.toml
@@ -0,0 +1,34 @@
+name = "apac_viewcomp"
+protocol = "unknown"
+[unknown.scancodes]
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
index 00000000..c9e1ddd2
--- /dev/null
+++ b/utils/keytable/rc_keymaps/astrometa_t2hybrid.toml
@@ -0,0 +1,26 @@
+name = "astrometa_t2hybrid"
+protocol = "nec"
+[nec]
+variant = "nec"
+[nec.scancodes]
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
index 00000000..6093650d
--- /dev/null
+++ b/utils/keytable/rc_keymaps/asus_pc39.toml
@@ -0,0 +1,44 @@
+name = "asus_pc39"
+protocol = "rc5"
+[rc5]
+variant = "rc5"
+[rc5.scancodes]
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
index 00000000..5c43bd39
--- /dev/null
+++ b/utils/keytable/rc_keymaps/asus_ps3_100.toml
@@ -0,0 +1,46 @@
+name = "asus_ps3_100"
+protocol = "rc5"
+[rc5]
+variant = "rc5"
+[rc5.scancodes]
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
index 00000000..37a07e7c
--- /dev/null
+++ b/utils/keytable/rc_keymaps/ati_tv_wonder_hd_600.toml
@@ -0,0 +1,27 @@
+name = "ati_tv_wonder_hd_600"
+protocol = "unknown"
+[unknown.scancodes]
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
index 00000000..1b055923
--- /dev/null
+++ b/utils/keytable/rc_keymaps/ati_x10.toml
@@ -0,0 +1,51 @@
+name = "ati_x10"
+protocol = "other"
+[other.scancodes]
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
index 00000000..4822424c
--- /dev/null
+++ b/utils/keytable/rc_keymaps/avermedia.toml
@@ -0,0 +1,39 @@
+name = "avermedia"
+protocol = "unknown"
+[unknown.scancodes]
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
index 00000000..e1aff583
--- /dev/null
+++ b/utils/keytable/rc_keymaps/avermedia_a16d.toml
@@ -0,0 +1,37 @@
+name = "avermedia_a16d"
+protocol = "unknown"
+[unknown.scancodes]
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
diff --git a/utils/keytable/rc_keymaps/avermedia_cardbus b/utils/keytable/rc_keymaps/avermedia_cardbus
deleted file mode 100644
index c4e4d369..00000000
--- a/utils/keytable/rc_keymaps/avermedia_cardbus
+++ /dev/null
@@ -1,55 +0,0 @@
-# table avermedia_cardbus, type: UNKNOWN
-0x00 KEY_POWER
-0x01 KEY_TUNER
-0x03 KEY_TEXT
-0x04 KEY_EPG
-0x05 KEY_1
-0x06 KEY_2
-0x07 KEY_3
-0x08 KEY_AUDIO
-0x09 KEY_4
-0x0a KEY_5
-0x0b KEY_6
-0x0c KEY_ZOOM
-0x0d KEY_7
-0x0e KEY_8
-0x0f KEY_9
-0x10 KEY_PAGEUP
-0x11 KEY_0
-0x12 KEY_INFO
-0x13 KEY_AGAIN
-0x14 KEY_MUTE
-0x15 KEY_EDIT
-0x17 KEY_SAVE
-0x18 KEY_PLAYPAUSE
-0x19 KEY_RECORD
-0x1a KEY_PLAY
-0x1b KEY_STOP
-0x1c KEY_FASTFORWARD
-0x1d KEY_REWIND
-0x1e KEY_VOLUMEDOWN
-0x1f KEY_VOLUMEUP
-0x22 KEY_SLEEP
-0x23 KEY_ZOOM
-0x26 KEY_SCREEN
-0x27 KEY_ANGLE
-0x28 KEY_SELECT
-0x29 KEY_BLUE
-0x2a KEY_BACKSPACE
-0x2b KEY_VIDEO
-0x2c KEY_DOWN
-0x2e KEY_DOT
-0x2f KEY_TV
-0x32 KEY_LEFT
-0x33 KEY_CLEAR
-0x35 KEY_RED
-0x36 KEY_UP
-0x37 KEY_HOME
-0x39 KEY_GREEN
-0x3d KEY_YELLOW
-0x3e KEY_OK
-0x3f KEY_RIGHT
-0x40 KEY_NEXT
-0x41 KEY_PREVIOUS
-0x42 KEY_CHANNELDOWN
-0x43 KEY_CHANNELUP
diff --git a/utils/keytable/rc_keymaps/avermedia_cardbus.toml b/utils/keytable/rc_keymaps/avermedia_cardbus.toml
new file mode 100644
index 00000000..bf96cbc4
--- /dev/null
+++ b/utils/keytable/rc_keymaps/avermedia_cardbus.toml
@@ -0,0 +1,57 @@
+name = "avermedia_cardbus"
+protocol = "unknown"
+[unknown.scancodes]
+0x00 = "KEY_POWER"
+0x01 = "KEY_TUNER"
+0x03 = "KEY_TEXT"
+0x04 = "KEY_EPG"
+0x05 = "KEY_1"
+0x06 = "KEY_2"
+0x07 = "KEY_3"
+0x08 = "KEY_AUDIO"
+0x09 = "KEY_4"
+0x0a = "KEY_5"
+0x0b = "KEY_6"
+0x0c = "KEY_ZOOM"
+0x0d = "KEY_7"
+0x0e = "KEY_8"
+0x0f = "KEY_9"
+0x10 = "KEY_PAGEUP"
+0x11 = "KEY_0"
+0x12 = "KEY_INFO"
+0x13 = "KEY_AGAIN"
+0x14 = "KEY_MUTE"
+0x15 = "KEY_EDIT"
+0x17 = "KEY_SAVE"
+0x18 = "KEY_PLAYPAUSE"
+0x19 = "KEY_RECORD"
+0x1a = "KEY_PLAY"
+0x1b = "KEY_STOP"
+0x1c = "KEY_FASTFORWARD"
+0x1d = "KEY_REWIND"
+0x1e = "KEY_VOLUMEDOWN"
+0x1f = "KEY_VOLUMEUP"
+0x22 = "KEY_SLEEP"
+0x23 = "KEY_ZOOM"
+0x26 = "KEY_SCREEN"
+0x27 = "KEY_ANGLE"
+0x28 = "KEY_SELECT"
+0x29 = "KEY_BLUE"
+0x2a = "KEY_BACKSPACE"
+0x2b = "KEY_VIDEO"
+0x2c = "KEY_DOWN"
+0x2e = "KEY_DOT"
+0x2f = "KEY_TV"
+0x32 = "KEY_LEFT"
+0x33 = "KEY_CLEAR"
+0x35 = "KEY_RED"
+0x36 = "KEY_UP"
+0x37 = "KEY_HOME"
+0x39 = "KEY_GREEN"
+0x3d = "KEY_YELLOW"
+0x3e = "KEY_OK"
+0x3f = "KEY_RIGHT"
+0x40 = "KEY_NEXT"
+0x41 = "KEY_PREVIOUS"
+0x42 = "KEY_CHANNELDOWN"
+0x43 = "KEY_CHANNELUP"
diff --git a/utils/keytable/rc_keymaps/avermedia_dvbt b/utils/keytable/rc_keymaps/avermedia_dvbt
deleted file mode 100644
index f939f390..00000000
--- a/utils/keytable/rc_keymaps/avermedia_dvbt
+++ /dev/null
@@ -1,35 +0,0 @@
-# table avermedia_dvbt, type: UNKNOWN
-0x28 KEY_0
-0x22 KEY_1
-0x12 KEY_2
-0x32 KEY_3
-0x24 KEY_4
-0x14 KEY_5
-0x34 KEY_6
-0x26 KEY_7
-0x16 KEY_8
-0x36 KEY_9
-0x20 KEY_VIDEO
-0x10 KEY_TEXT
-0x00 KEY_POWER
-0x04 KEY_AUDIO
-0x06 KEY_ZOOM
-0x18 KEY_SWITCHVIDEOMODE
-0x38 KEY_SEARCH
-0x08 KEY_INFO
-0x2a KEY_REWIND
-0x1a KEY_FASTFORWARD
-0x3a KEY_RECORD
-0x0a KEY_MUTE
-0x2c KEY_RECORD
-0x1c KEY_PAUSE
-0x3c KEY_STOP
-0x0c KEY_PLAY
-0x2e KEY_RED
-0x01 KEY_BLUE
-0x0e KEY_YELLOW
-0x21 KEY_GREEN
-0x11 KEY_CHANNELDOWN
-0x31 KEY_CHANNELUP
-0x1e KEY_VOLUMEDOWN
-0x3e KEY_VOLUMEUP
diff --git a/utils/keytable/rc_keymaps/avermedia_dvbt.toml b/utils/keytable/rc_keymaps/avermedia_dvbt.toml
new file mode 100644
index 00000000..7f171a63
--- /dev/null
+++ b/utils/keytable/rc_keymaps/avermedia_dvbt.toml
@@ -0,0 +1,37 @@
+name = "avermedia_dvbt"
+protocol = "unknown"
+[unknown.scancodes]
+0x28 = "KEY_0"
+0x22 = "KEY_1"
+0x12 = "KEY_2"
+0x32 = "KEY_3"
+0x24 = "KEY_4"
+0x14 = "KEY_5"
+0x34 = "KEY_6"
+0x26 = "KEY_7"
+0x16 = "KEY_8"
+0x36 = "KEY_9"
+0x20 = "KEY_VIDEO"
+0x10 = "KEY_TEXT"
+0x00 = "KEY_POWER"
+0x04 = "KEY_AUDIO"
+0x06 = "KEY_ZOOM"
+0x18 = "KEY_SWITCHVIDEOMODE"
+0x38 = "KEY_SEARCH"
+0x08 = "KEY_INFO"
+0x2a = "KEY_REWIND"
+0x1a = "KEY_FASTFORWARD"
+0x3a = "KEY_RECORD"
+0x0a = "KEY_MUTE"
+0x2c = "KEY_RECORD"
+0x1c = "KEY_PAUSE"
+0x3c = "KEY_STOP"
+0x0c = "KEY_PLAY"
+0x2e = "KEY_RED"
+0x01 = "KEY_BLUE"
+0x0e = "KEY_YELLOW"
+0x21 = "KEY_GREEN"
+0x11 = "KEY_CHANNELDOWN"
+0x31 = "KEY_CHANNELUP"
+0x1e = "KEY_VOLUMEDOWN"
+0x3e = "KEY_VOLUMEUP"
diff --git a/utils/keytable/rc_keymaps/avermedia_m135a b/utils/keytable/rc_keymaps/avermedia_m135a
deleted file mode 100644
index bc7006ad..00000000
--- a/utils/keytable/rc_keymaps/avermedia_m135a
+++ /dev/null
@@ -1,81 +0,0 @@
-# table avermedia_m135a, type: NEC
-0x0200 KEY_POWER2
-0x022e KEY_DOT
-0x0201 KEY_MODE
-0x0205 KEY_1
-0x0206 KEY_2
-0x0207 KEY_3
-0x0209 KEY_4
-0x020a KEY_5
-0x020b KEY_6
-0x020d KEY_7
-0x020e KEY_8
-0x020f KEY_9
-0x0211 KEY_0
-0x0213 KEY_RIGHT
-0x0212 KEY_LEFT
-0x0215 KEY_MENU
-0x0217 KEY_CAMERA
-0x0210 KEY_SHUFFLE
-0x0303 KEY_CHANNELUP
-0x0302 KEY_CHANNELDOWN
-0x021f KEY_VOLUMEUP
-0x021e KEY_VOLUMEDOWN
-0x020c KEY_ENTER
-0x0214 KEY_MUTE
-0x0208 KEY_AUDIO
-0x0203 KEY_TEXT
-0x0204 KEY_EPG
-0x022b KEY_TV2
-0x021d KEY_RED
-0x021c KEY_YELLOW
-0x0301 KEY_GREEN
-0x0300 KEY_BLUE
-0x021a KEY_PLAYPAUSE
-0x0219 KEY_RECORD
-0x0218 KEY_PLAY
-0x021b KEY_STOP
-0x0401 KEY_POWER2
-0x0406 KEY_MUTE
-0x0408 KEY_MODE
-0x0409 KEY_1
-0x040a KEY_2
-0x040b KEY_3
-0x040c KEY_4
-0x040d KEY_5
-0x040e KEY_6
-0x040f KEY_7
-0x0410 KEY_8
-0x0411 KEY_9
-0x044c KEY_DOT
-0x0412 KEY_0
-0x0407 KEY_REFRESH
-0x0413 KEY_AUDIO
-0x0440 KEY_SCREEN
-0x0441 KEY_HOME
-0x0442 KEY_BACK
-0x0447 KEY_UP
-0x0448 KEY_DOWN
-0x0449 KEY_LEFT
-0x044a KEY_RIGHT
-0x044b KEY_OK
-0x0404 KEY_VOLUMEUP
-0x0405 KEY_VOLUMEDOWN
-0x0402 KEY_CHANNELUP
-0x0403 KEY_CHANNELDOWN
-0x0443 KEY_RED
-0x0444 KEY_GREEN
-0x0445 KEY_YELLOW
-0x0446 KEY_BLUE
-0x0414 KEY_TEXT
-0x0415 KEY_EPG
-0x041a KEY_TV2
-0x041b KEY_CAMERA
-0x0417 KEY_RECORD
-0x0416 KEY_PLAYPAUSE
-0x0418 KEY_STOP
-0x0419 KEY_PAUSE
-0x041f KEY_PREVIOUS
-0x041c KEY_REWIND
-0x041d KEY_FORWARD
-0x041e KEY_NEXT
diff --git a/utils/keytable/rc_keymaps/avermedia_m135a.toml b/utils/keytable/rc_keymaps/avermedia_m135a.toml
new file mode 100644
index 00000000..c6903e5a
--- /dev/null
+++ b/utils/keytable/rc_keymaps/avermedia_m135a.toml
@@ -0,0 +1,85 @@
+name = "avermedia_m135a"
+protocol = "nec"
+[nec]
+variant = "nec"
+[nec.scancodes]
+0x0200 = "KEY_POWER2"
+0x022e = "KEY_DOT"
+0x0201 = "KEY_MODE"
+0x0205 = "KEY_1"
+0x0206 = "KEY_2"
+0x0207 = "KEY_3"
+0x0209 = "KEY_4"
+0x020a = "KEY_5"
+0x020b = "KEY_6"
+0x020d = "KEY_7"
+0x020e = "KEY_8"
+0x020f = "KEY_9"
+0x0211 = "KEY_0"
+0x0213 = "KEY_RIGHT"
+0x0212 = "KEY_LEFT"
+0x0215 = "KEY_MENU"
+0x0217 = "KEY_CAMERA"
+0x0210 = "KEY_SHUFFLE"
+0x0303 = "KEY_CHANNELUP"
+0x0302 = "KEY_CHANNELDOWN"
+0x021f = "KEY_VOLUMEUP"
+0x021e = "KEY_VOLUMEDOWN"
+0x020c = "KEY_ENTER"
+0x0214 = "KEY_MUTE"
+0x0208 = "KEY_AUDIO"
+0x0203 = "KEY_TEXT"
+0x0204 = "KEY_EPG"
+0x022b = "KEY_TV2"
+0x021d = "KEY_RED"
+0x021c = "KEY_YELLOW"
+0x0301 = "KEY_GREEN"
+0x0300 = "KEY_BLUE"
+0x021a = "KEY_PLAYPAUSE"
+0x0219 = "KEY_RECORD"
+0x0218 = "KEY_PLAY"
+0x021b = "KEY_STOP"
+0x0401 = "KEY_POWER2"
+0x0406 = "KEY_MUTE"
+0x0408 = "KEY_MODE"
+0x0409 = "KEY_1"
+0x040a = "KEY_2"
+0x040b = "KEY_3"
+0x040c = "KEY_4"
+0x040d = "KEY_5"
+0x040e = "KEY_6"
+0x040f = "KEY_7"
+0x0410 = "KEY_8"
+0x0411 = "KEY_9"
+0x044c = "KEY_DOT"
+0x0412 = "KEY_0"
+0x0407 = "KEY_REFRESH"
+0x0413 = "KEY_AUDIO"
+0x0440 = "KEY_SCREEN"
+0x0441 = "KEY_HOME"
+0x0442 = "KEY_BACK"
+0x0447 = "KEY_UP"
+0x0448 = "KEY_DOWN"
+0x0449 = "KEY_LEFT"
+0x044a = "KEY_RIGHT"
+0x044b = "KEY_OK"
+0x0404 = "KEY_VOLUMEUP"
+0x0405 = "KEY_VOLUMEDOWN"
+0x0402 = "KEY_CHANNELUP"
+0x0403 = "KEY_CHANNELDOWN"
+0x0443 = "KEY_RED"
+0x0444 = "KEY_GREEN"
+0x0445 = "KEY_YELLOW"
+0x0446 = "KEY_BLUE"
+0x0414 = "KEY_TEXT"
+0x0415 = "KEY_EPG"
+0x041a = "KEY_TV2"
+0x041b = "KEY_CAMERA"
+0x0417 = "KEY_RECORD"
+0x0416 = "KEY_PLAYPAUSE"
+0x0418 = "KEY_STOP"
+0x0419 = "KEY_PAUSE"
+0x041f = "KEY_PREVIOUS"
+0x041c = "KEY_REWIND"
+0x041d = "KEY_FORWARD"
+0x041e = "KEY_NEXT"
diff --git a/utils/keytable/rc_keymaps/avermedia_m733a_rm_k6 b/utils/keytable/rc_keymaps/avermedia_m733a_rm_k6
deleted file mode 100644
index 94d9a355..00000000
--- a/utils/keytable/rc_keymaps/avermedia_m733a_rm_k6
+++ /dev/null
@@ -1,45 +0,0 @@
-# table avermedia_m733a_rm_k6, type: NEC
-0x0401 KEY_POWER2
-0x0406 KEY_MUTE
-0x0408 KEY_MODE
-0x0409 KEY_1
-0x040a KEY_2
-0x040b KEY_3
-0x040c KEY_4
-0x040d KEY_5
-0x040e KEY_6
-0x040f KEY_7
-0x0410 KEY_8
-0x0411 KEY_9
-0x044c KEY_DOT
-0x0412 KEY_0
-0x0407 KEY_REFRESH
-0x0413 KEY_AUDIO
-0x0440 KEY_SCREEN
-0x0441 KEY_HOME
-0x0442 KEY_BACK
-0x0447 KEY_UP
-0x0448 KEY_DOWN
-0x0449 KEY_LEFT
-0x044a KEY_RIGHT
-0x044b KEY_OK
-0x0404 KEY_VOLUMEUP
-0x0405 KEY_VOLUMEDOWN
-0x0402 KEY_CHANNELUP
-0x0403 KEY_CHANNELDOWN
-0x0443 KEY_RED
-0x0444 KEY_GREEN
-0x0445 KEY_YELLOW
-0x0446 KEY_BLUE
-0x0414 KEY_TEXT
-0x0415 KEY_EPG
-0x041a KEY_TV2
-0x041b KEY_CAMERA
-0x0417 KEY_RECORD
-0x0416 KEY_PLAYPAUSE
-0x0418 KEY_STOP
-0x0419 KEY_PAUSE
-0x041f KEY_PREVIOUS
-0x041c KEY_REWIND
-0x041d KEY_FORWARD
-0x041e KEY_NEXT
diff --git a/utils/keytable/rc_keymaps/avermedia_m733a_rm_k6.toml b/utils/keytable/rc_keymaps/avermedia_m733a_rm_k6.toml
new file mode 100644
index 00000000..43352324
--- /dev/null
+++ b/utils/keytable/rc_keymaps/avermedia_m733a_rm_k6.toml
@@ -0,0 +1,49 @@
+name = "avermedia_m733a_rm_k6"
+protocol = "nec"
+[nec]
+variant = "nec"
+[nec.scancodes]
+0x0401 = "KEY_POWER2"
+0x0406 = "KEY_MUTE"
+0x0408 = "KEY_MODE"
+0x0409 = "KEY_1"
+0x040a = "KEY_2"
+0x040b = "KEY_3"
+0x040c = "KEY_4"
+0x040d = "KEY_5"
+0x040e = "KEY_6"
+0x040f = "KEY_7"
+0x0410 = "KEY_8"
+0x0411 = "KEY_9"
+0x044c = "KEY_DOT"
+0x0412 = "KEY_0"
+0x0407 = "KEY_REFRESH"
+0x0413 = "KEY_AUDIO"
+0x0440 = "KEY_SCREEN"
+0x0441 = "KEY_HOME"
+0x0442 = "KEY_BACK"
+0x0447 = "KEY_UP"
+0x0448 = "KEY_DOWN"
+0x0449 = "KEY_LEFT"
+0x044a = "KEY_RIGHT"
+0x044b = "KEY_OK"
+0x0404 = "KEY_VOLUMEUP"
+0x0405 = "KEY_VOLUMEDOWN"
+0x0402 = "KEY_CHANNELUP"
+0x0403 = "KEY_CHANNELDOWN"
+0x0443 = "KEY_RED"
+0x0444 = "KEY_GREEN"
+0x0445 = "KEY_YELLOW"
+0x0446 = "KEY_BLUE"
+0x0414 = "KEY_TEXT"
+0x0415 = "KEY_EPG"
+0x041a = "KEY_TV2"
+0x041b = "KEY_CAMERA"
+0x0417 = "KEY_RECORD"
+0x0416 = "KEY_PLAYPAUSE"
+0x0418 = "KEY_STOP"
+0x0419 = "KEY_PAUSE"
+0x041f = "KEY_PREVIOUS"
+0x041c = "KEY_REWIND"
+0x041d = "KEY_FORWARD"
+0x041e = "KEY_NEXT"
diff --git a/utils/keytable/rc_keymaps/avermedia_rm_ks b/utils/keytable/rc_keymaps/avermedia_rm_ks
deleted file mode 100644
index 80566202..00000000
--- a/utils/keytable/rc_keymaps/avermedia_rm_ks
+++ /dev/null
@@ -1,28 +0,0 @@
-# table avermedia_rm_ks, type: NEC
-0x0501 KEY_POWER2
-0x0502 KEY_CHANNELUP
-0x0503 KEY_CHANNELDOWN
-0x0504 KEY_VOLUMEUP
-0x0505 KEY_VOLUMEDOWN
-0x0506 KEY_MUTE
-0x0507 KEY_AGAIN
-0x0508 KEY_VIDEO
-0x0509 KEY_1
-0x050a KEY_2
-0x050b KEY_3
-0x050c KEY_4
-0x050d KEY_5
-0x050e KEY_6
-0x050f KEY_7
-0x0510 KEY_8
-0x0511 KEY_9
-0x0512 KEY_0
-0x0513 KEY_AUDIO
-0x0515 KEY_EPG
-0x0516 KEY_PLAYPAUSE
-0x0517 KEY_RECORD
-0x0518 KEY_STOP
-0x051c KEY_BACK
-0x051d KEY_FORWARD
-0x054d KEY_INFO
-0x0556 KEY_ZOOM
diff --git a/utils/keytable/rc_keymaps/avermedia_rm_ks.toml b/utils/keytable/rc_keymaps/avermedia_rm_ks.toml
new file mode 100644
index 00000000..2b59ff75
--- /dev/null
+++ b/utils/keytable/rc_keymaps/avermedia_rm_ks.toml
@@ -0,0 +1,32 @@
+name = "avermedia_rm_ks"
+protocol = "nec"
+[nec]
+variant = "nec"
+[nec.scancodes]
+0x0501 = "KEY_POWER2"
+0x0502 = "KEY_CHANNELUP"
+0x0503 = "KEY_CHANNELDOWN"
+0x0504 = "KEY_VOLUMEUP"
+0x0505 = "KEY_VOLUMEDOWN"
+0x0506 = "KEY_MUTE"
+0x0507 = "KEY_AGAIN"
+0x0508 = "KEY_VIDEO"
+0x0509 = "KEY_1"
+0x050a = "KEY_2"
+0x050b = "KEY_3"
+0x050c = "KEY_4"
+0x050d = "KEY_5"
+0x050e = "KEY_6"
+0x050f = "KEY_7"
+0x0510 = "KEY_8"
+0x0511 = "KEY_9"
+0x0512 = "KEY_0"
+0x0513 = "KEY_AUDIO"
+0x0515 = "KEY_EPG"
+0x0516 = "KEY_PLAYPAUSE"
+0x0517 = "KEY_RECORD"
+0x0518 = "KEY_STOP"
+0x051c = "KEY_BACK"
+0x051d = "KEY_FORWARD"
+0x054d = "KEY_INFO"
+0x0556 = "KEY_ZOOM"
diff --git a/utils/keytable/rc_keymaps/avertv_303 b/utils/keytable/rc_keymaps/avertv_303
deleted file mode 100644
index f60e43fc..00000000
--- a/utils/keytable/rc_keymaps/avertv_303
+++ /dev/null
@@ -1,37 +0,0 @@
-# table avertv_303, type: UNKNOWN
-0x2a KEY_1
-0x32 KEY_2
-0x3a KEY_3
-0x4a KEY_4
-0x52 KEY_5
-0x5a KEY_6
-0x6a KEY_7
-0x72 KEY_8
-0x7a KEY_9
-0x0e KEY_0
-0x02 KEY_POWER
-0x22 KEY_VIDEO
-0x42 KEY_AUDIO
-0x62 KEY_ZOOM
-0x0a KEY_TV
-0x12 KEY_CD
-0x1a KEY_TEXT
-0x16 KEY_SUBTITLE
-0x1e KEY_REWIND
-0x06 KEY_PRINT
-0x2e KEY_SEARCH
-0x36 KEY_SLEEP
-0x3e KEY_SHUFFLE
-0x26 KEY_MUTE
-0x4e KEY_RECORD
-0x56 KEY_PAUSE
-0x5e KEY_STOP
-0x46 KEY_PLAY
-0x6e KEY_RED
-0x0b KEY_GREEN
-0x66 KEY_YELLOW
-0x03 KEY_BLUE
-0x76 KEY_LEFT
-0x7e KEY_RIGHT
-0x13 KEY_DOWN
-0x1b KEY_UP
diff --git a/utils/keytable/rc_keymaps/avertv_303.toml b/utils/keytable/rc_keymaps/avertv_303.toml
new file mode 100644
index 00000000..a44ad724
--- /dev/null
+++ b/utils/keytable/rc_keymaps/avertv_303.toml
@@ -0,0 +1,39 @@
+name = "avertv_303"
+protocol = "unknown"
+[unknown.scancodes]
+0x2a = "KEY_1"
+0x32 = "KEY_2"
+0x3a = "KEY_3"
+0x4a = "KEY_4"
+0x52 = "KEY_5"
+0x5a = "KEY_6"
+0x6a = "KEY_7"
+0x72 = "KEY_8"
+0x7a = "KEY_9"
+0x0e = "KEY_0"
+0x02 = "KEY_POWER"
+0x22 = "KEY_VIDEO"
+0x42 = "KEY_AUDIO"
+0x62 = "KEY_ZOOM"
+0x0a = "KEY_TV"
+0x12 = "KEY_CD"
+0x1a = "KEY_TEXT"
+0x16 = "KEY_SUBTITLE"
+0x1e = "KEY_REWIND"
+0x06 = "KEY_PRINT"
+0x2e = "KEY_SEARCH"
+0x36 = "KEY_SLEEP"
+0x3e = "KEY_SHUFFLE"
+0x26 = "KEY_MUTE"
+0x4e = "KEY_RECORD"
+0x56 = "KEY_PAUSE"
+0x5e = "KEY_STOP"
+0x46 = "KEY_PLAY"
+0x6e = "KEY_RED"
+0x0b = "KEY_GREEN"
+0x66 = "KEY_YELLOW"
+0x03 = "KEY_BLUE"
+0x76 = "KEY_LEFT"
+0x7e = "KEY_RIGHT"
+0x13 = "KEY_DOWN"
+0x1b = "KEY_UP"
diff --git a/utils/keytable/rc_keymaps/az6027 b/utils/keytable/rc_keymaps/az6027
deleted file mode 100644
index cf83f188..00000000
--- a/utils/keytable/rc_keymaps/az6027
+++ /dev/null
@@ -1,3 +0,0 @@
-# table az6027, type: UNKNOWN
-0x01 KEY_1
-0x02 KEY_2
diff --git a/utils/keytable/rc_keymaps/az6027.toml b/utils/keytable/rc_keymaps/az6027.toml
new file mode 100644
index 00000000..0e2af495
--- /dev/null
+++ b/utils/keytable/rc_keymaps/az6027.toml
@@ -0,0 +1,5 @@
+name = "az6027"
+protocol = "unknown"
+[unknown.scancodes]
+0x01 = "KEY_1"
+0x02 = "KEY_2"
diff --git a/utils/keytable/rc_keymaps/azurewave_ad_tu700 b/utils/keytable/rc_keymaps/azurewave_ad_tu700
deleted file mode 100644
index 11a513ba..00000000
--- a/utils/keytable/rc_keymaps/azurewave_ad_tu700
+++ /dev/null
@@ -1,54 +0,0 @@
-# table azurewave_ad_tu700, type: NEC
-0x0000 KEY_TAB
-0x0001 KEY_2
-0x0002 KEY_CHANNELDOWN
-0x0003 KEY_1
-0x0004 KEY_MENU
-0x0005 KEY_CHANNELUP
-0x0006 KEY_3
-0x0007 KEY_SLEEP
-0x0008 KEY_VIDEO
-0x0009 KEY_4
-0x000a KEY_VOLUMEDOWN
-0x000c KEY_CANCEL
-0x000d KEY_7
-0x000e KEY_AGAIN
-0x000f KEY_TEXT
-0x0010 KEY_MUTE
-0x0011 KEY_RECORD
-0x0012 KEY_FASTFORWARD
-0x0013 KEY_BACK
-0x0014 KEY_PLAY
-0x0015 KEY_0
-0x0016 KEY_POWER2
-0x0017 KEY_FAVORITES
-0x0018 KEY_RED
-0x0019 KEY_8
-0x001a KEY_STOP
-0x001b KEY_9
-0x001c KEY_EPG
-0x001d KEY_5
-0x001e KEY_VOLUMEUP
-0x001f KEY_6
-0x0040 KEY_REWIND
-0x0041 KEY_PREVIOUS
-0x0042 KEY_NEXT
-0x0043 KEY_SUBTITLE
-0x0045 KEY_KPPLUS
-0x0046 KEY_KPMINUS
-0x0047 KEY_NEW
-0x0048 KEY_INFO
-0x0049 KEY_MODE
-0x004a KEY_CLEAR
-0x004b KEY_UP
-0x004c KEY_PAUSE
-0x004d KEY_ZOOM
-0x004e KEY_LEFT
-0x004f KEY_OK
-0x0050 KEY_LANGUAGE
-0x0051 KEY_DOWN
-0x0052 KEY_RIGHT
-0x0053 KEY_GREEN
-0x0054 KEY_CAMERA
-0x005e KEY_YELLOW
-0x005f KEY_BLUE
diff --git a/utils/keytable/rc_keymaps/azurewave_ad_tu700.toml b/utils/keytable/rc_keymaps/azurewave_ad_tu700.toml
new file mode 100644
index 00000000..d54fc1dc
--- /dev/null
+++ b/utils/keytable/rc_keymaps/azurewave_ad_tu700.toml
@@ -0,0 +1,58 @@
+name = "azurewave_ad_tu700"
+protocol = "nec"
+[nec]
+variant = "nec"
+[nec.scancodes]
+0x0000 = "KEY_TAB"
+0x0001 = "KEY_2"
+0x0002 = "KEY_CHANNELDOWN"
+0x0003 = "KEY_1"
+0x0004 = "KEY_MENU"
+0x0005 = "KEY_CHANNELUP"
+0x0006 = "KEY_3"
+0x0007 = "KEY_SLEEP"
+0x0008 = "KEY_VIDEO"
+0x0009 = "KEY_4"
+0x000a = "KEY_VOLUMEDOWN"
+0x000c = "KEY_CANCEL"
+0x000d = "KEY_7"
+0x000e = "KEY_AGAIN"
+0x000f = "KEY_TEXT"
+0x0010 = "KEY_MUTE"
+0x0011 = "KEY_RECORD"
+0x0012 = "KEY_FASTFORWARD"
+0x0013 = "KEY_BACK"
+0x0014 = "KEY_PLAY"
+0x0015 = "KEY_0"
+0x0016 = "KEY_POWER2"
+0x0017 = "KEY_FAVORITES"
+0x0018 = "KEY_RED"
+0x0019 = "KEY_8"
+0x001a = "KEY_STOP"
+0x001b = "KEY_9"
+0x001c = "KEY_EPG"
+0x001d = "KEY_5"
+0x001e = "KEY_VOLUMEUP"
+0x001f = "KEY_6"
+0x0040 = "KEY_REWIND"
+0x0041 = "KEY_PREVIOUS"
+0x0042 = "KEY_NEXT"
+0x0043 = "KEY_SUBTITLE"
+0x0045 = "KEY_KPPLUS"
+0x0046 = "KEY_KPMINUS"
+0x0047 = "KEY_NEW"
+0x0048 = "KEY_INFO"
+0x0049 = "KEY_MODE"
+0x004a = "KEY_CLEAR"
+0x004b = "KEY_UP"
+0x004c = "KEY_PAUSE"
+0x004d = "KEY_ZOOM"
+0x004e = "KEY_LEFT"
+0x004f = "KEY_OK"
+0x0050 = "KEY_LANGUAGE"
+0x0051 = "KEY_DOWN"
+0x0052 = "KEY_RIGHT"
+0x0053 = "KEY_GREEN"
+0x0054 = "KEY_CAMERA"
+0x005e = "KEY_YELLOW"
+0x005f = "KEY_BLUE"
diff --git a/utils/keytable/rc_keymaps/behold b/utils/keytable/rc_keymaps/behold
deleted file mode 100644
index 15c6b55f..00000000
--- a/utils/keytable/rc_keymaps/behold
+++ /dev/null
@@ -1,35 +0,0 @@
-# table behold, type: NEC
-0x866b1c KEY_TUNER
-0x866b12 KEY_POWER
-0x866b01 KEY_1
-0x866b02 KEY_2
-0x866b03 KEY_3
-0x866b04 KEY_4
-0x866b05 KEY_5
-0x866b06 KEY_6
-0x866b07 KEY_7
-0x866b08 KEY_8
-0x866b09 KEY_9
-0x866b0a KEY_AGAIN
-0x866b00 KEY_0
-0x866b17 KEY_MODE
-0x866b14 KEY_SCREEN
-0x866b10 KEY_ZOOM
-0x866b0b KEY_CHANNELUP
-0x866b18 KEY_VOLUMEDOWN
-0x866b16 KEY_OK
-0x866b0c KEY_VOLUMEUP
-0x866b15 KEY_CHANNELDOWN
-0x866b11 KEY_MUTE
-0x866b0d KEY_INFO
-0x866b0f KEY_RECORD
-0x866b1b KEY_PLAYPAUSE
-0x866b1a KEY_STOP
-0x866b0e KEY_TEXT
-0x866b1f KEY_RED
-0x866b1e KEY_VIDEO
-0x866b1d KEY_SLEEP
-0x866b13 KEY_GREEN
-0x866b19 KEY_BLUE
-0x866b58 KEY_SLOW
-0x866b5c KEY_CAMERA
diff --git a/utils/keytable/rc_keymaps/behold.toml b/utils/keytable/rc_keymaps/behold.toml
new file mode 100644
index 00000000..d3d5f5b2
--- /dev/null
+++ b/utils/keytable/rc_keymaps/behold.toml
@@ -0,0 +1,39 @@
+name = "behold"
+protocol = "nec"
+[nec]
+variant = "necx"
+[nec.scancodes]
+0x866b1c = "KEY_TUNER"
+0x866b12 = "KEY_POWER"
+0x866b01 = "KEY_1"
+0x866b02 = "KEY_2"
+0x866b03 = "KEY_3"
+0x866b04 = "KEY_4"
+0x866b05 = "KEY_5"
+0x866b06 = "KEY_6"
+0x866b07 = "KEY_7"
+0x866b08 = "KEY_8"
+0x866b09 = "KEY_9"
+0x866b0a = "KEY_AGAIN"
+0x866b00 = "KEY_0"
+0x866b17 = "KEY_MODE"
+0x866b14 = "KEY_SCREEN"
+0x866b10 = "KEY_ZOOM"
+0x866b0b = "KEY_CHANNELUP"
+0x866b18 = "KEY_VOLUMEDOWN"
+0x866b16 = "KEY_OK"
+0x866b0c = "KEY_VOLUMEUP"
+0x866b15 = "KEY_CHANNELDOWN"
+0x866b11 = "KEY_MUTE"
+0x866b0d = "KEY_INFO"
+0x866b0f = "KEY_RECORD"
+0x866b1b = "KEY_PLAYPAUSE"
+0x866b1a = "KEY_STOP"
+0x866b0e = "KEY_TEXT"
+0x866b1f = "KEY_RED"
+0x866b1e = "KEY_VIDEO"
+0x866b1d = "KEY_SLEEP"
+0x866b13 = "KEY_GREEN"
+0x866b19 = "KEY_BLUE"
+0x866b58 = "KEY_SLOW"
+0x866b5c = "KEY_CAMERA"
diff --git a/utils/keytable/rc_keymaps/behold_columbus b/utils/keytable/rc_keymaps/behold_columbus
deleted file mode 100644
index bf0a54a5..00000000
--- a/utils/keytable/rc_keymaps/behold_columbus
+++ /dev/null
@@ -1,29 +0,0 @@
-# table behold_columbus, type: UNKNOWN
-0x13 KEY_MUTE
-0x11 KEY_VIDEO
-0x1C KEY_TUNER
-0x12 KEY_POWER
-0x01 KEY_1
-0x02 KEY_2
-0x03 KEY_3
-0x0D KEY_SETUP
-0x04 KEY_4
-0x05 KEY_5
-0x06 KEY_6
-0x19 KEY_CAMERA
-0x07 KEY_7
-0x08 KEY_8
-0x09 KEY_9
-0x10 KEY_ZOOM
-0x0A KEY_AGAIN
-0x00 KEY_0
-0x0B KEY_CHANNELUP
-0x0C KEY_VOLUMEUP
-0x1B KEY_TIME
-0x1D KEY_RECORD
-0x15 KEY_CHANNELDOWN
-0x18 KEY_VOLUMEDOWN
-0x0E KEY_STOP
-0x1E KEY_PAUSE
-0x0F KEY_PREVIOUS
-0x1A KEY_NEXT
diff --git a/utils/keytable/rc_keymaps/behold_columbus.toml b/utils/keytable/rc_keymaps/behold_columbus.toml
new file mode 100644
index 00000000..8a912055
--- /dev/null
+++ b/utils/keytable/rc_keymaps/behold_columbus.toml
@@ -0,0 +1,31 @@
+name = "behold_columbus"
+protocol = "unknown"
+[unknown.scancodes]
+0x13 = "KEY_MUTE"
+0x11 = "KEY_VIDEO"
+0x1C = "KEY_TUNER"
+0x12 = "KEY_POWER"
+0x01 = "KEY_1"
+0x02 = "KEY_2"
+0x03 = "KEY_3"
+0x0D = "KEY_SETUP"
+0x04 = "KEY_4"
+0x05 = "KEY_5"
+0x06 = "KEY_6"
+0x19 = "KEY_CAMERA"
+0x07 = "KEY_7"
+0x08 = "KEY_8"
+0x09 = "KEY_9"
+0x10 = "KEY_ZOOM"
+0x0A = "KEY_AGAIN"
+0x00 = "KEY_0"
+0x0B = "KEY_CHANNELUP"
+0x0C = "KEY_VOLUMEUP"
+0x1B = "KEY_TIME"
+0x1D = "KEY_RECORD"
+0x15 = "KEY_CHANNELDOWN"
+0x18 = "KEY_VOLUMEDOWN"
+0x0E = "KEY_STOP"
+0x1E = "KEY_PAUSE"
+0x0F = "KEY_PREVIOUS"
+0x1A = "KEY_NEXT"
diff --git a/utils/keytable/rc_keymaps/budget_ci_old b/utils/keytable/rc_keymaps/budget_ci_old
deleted file mode 100644
index b62e94ed..00000000
--- a/utils/keytable/rc_keymaps/budget_ci_old
+++ /dev/null
@@ -1,46 +0,0 @@
-# table budget_ci_old, type: UNKNOWN
-0x00 KEY_0
-0x01 KEY_1
-0x02 KEY_2
-0x03 KEY_3
-0x04 KEY_4
-0x05 KEY_5
-0x06 KEY_6
-0x07 KEY_7
-0x08 KEY_8
-0x09 KEY_9
-0x0a KEY_ENTER
-0x0b KEY_RED
-0x0c KEY_POWER
-0x0d KEY_MUTE
-0x0f KEY_A
-0x10 KEY_VOLUMEUP
-0x11 KEY_VOLUMEDOWN
-0x14 KEY_B
-0x1c KEY_UP
-0x1d KEY_DOWN
-0x1e KEY_OPTION
-0x1f KEY_BREAK
-0x20 KEY_CHANNELUP
-0x21 KEY_CHANNELDOWN
-0x22 KEY_PREVIOUS
-0x24 KEY_RESTART
-0x25 KEY_OK
-0x26 KEY_CYCLEWINDOWS
-0x28 KEY_ENTER
-0x29 KEY_PAUSE
-0x2b KEY_RIGHT
-0x2c KEY_LEFT
-0x2e KEY_MENU
-0x30 KEY_SLOW
-0x31 KEY_PREVIOUS
-0x32 KEY_REWIND
-0x34 KEY_FASTFORWARD
-0x35 KEY_PLAY
-0x36 KEY_STOP
-0x37 KEY_RECORD
-0x38 KEY_TUNER
-0x3a KEY_C
-0x3c KEY_EXIT
-0x3d KEY_POWER2
-0x3e KEY_TUNER
diff --git a/utils/keytable/rc_keymaps/budget_ci_old.toml b/utils/keytable/rc_keymaps/budget_ci_old.toml
new file mode 100644
index 00000000..deab7b09
--- /dev/null
+++ b/utils/keytable/rc_keymaps/budget_ci_old.toml
@@ -0,0 +1,48 @@
+name = "budget_ci_old"
+protocol = "unknown"
+[unknown.scancodes]
+0x00 = "KEY_0"
+0x01 = "KEY_1"
+0x02 = "KEY_2"
+0x03 = "KEY_3"
+0x04 = "KEY_4"
+0x05 = "KEY_5"
+0x06 = "KEY_6"
+0x07 = "KEY_7"
+0x08 = "KEY_8"
+0x09 = "KEY_9"
+0x0a = "KEY_ENTER"
+0x0b = "KEY_RED"
+0x0c = "KEY_POWER"
+0x0d = "KEY_MUTE"
+0x0f = "KEY_A"
+0x10 = "KEY_VOLUMEUP"
+0x11 = "KEY_VOLUMEDOWN"
+0x14 = "KEY_B"
+0x1c = "KEY_UP"
+0x1d = "KEY_DOWN"
+0x1e = "KEY_OPTION"
+0x1f = "KEY_BREAK"
+0x20 = "KEY_CHANNELUP"
+0x21 = "KEY_CHANNELDOWN"
+0x22 = "KEY_PREVIOUS"
+0x24 = "KEY_RESTART"
+0x25 = "KEY_OK"
+0x26 = "KEY_CYCLEWINDOWS"
+0x28 = "KEY_ENTER"
+0x29 = "KEY_PAUSE"
+0x2b = "KEY_RIGHT"
+0x2c = "KEY_LEFT"
+0x2e = "KEY_MENU"
+0x30 = "KEY_SLOW"
+0x31 = "KEY_PREVIOUS"
+0x32 = "KEY_REWIND"
+0x34 = "KEY_FASTFORWARD"
+0x35 = "KEY_PLAY"
+0x36 = "KEY_STOP"
+0x37 = "KEY_RECORD"
+0x38 = "KEY_TUNER"
+0x3a = "KEY_C"
+0x3c = "KEY_EXIT"
+0x3d = "KEY_POWER2"
+0x3e = "KEY_TUNER"
diff --git a/utils/keytable/rc_keymaps/cec b/utils/keytable/rc_keymaps/cec
deleted file mode 100644
index e6c619ab..00000000
--- a/utils/keytable/rc_keymaps/cec
+++ /dev/null
@@ -1,98 +0,0 @@
-# table cec, type: CEC
-0x00 KEY_OK
-0x01 KEY_UP
-0x02 KEY_DOWN
-0x03 KEY_LEFT
-0x04 KEY_RIGHT
-0x05 KEY_RIGHT_UP
-0x06 KEY_RIGHT_DOWN
-0x07 KEY_LEFT_UP
-0x08 KEY_LEFT_DOWN
-0x09 KEY_ROOT_MENU
-0x0a KEY_SETUP
-0x0b KEY_MENU
-0x0c KEY_FAVORITES
-0x0d KEY_EXIT
-0x10 KEY_MEDIA_TOP_MENU
-0x11 KEY_CONTEXT_MENU
-0x1d KEY_DIGITS
-0x1e KEY_NUMERIC_11
-0x1f KEY_NUMERIC_12
-0x20 KEY_NUMERIC_0
-0x21 KEY_NUMERIC_1
-0x22 KEY_NUMERIC_2
-0x23 KEY_NUMERIC_3
-0x24 KEY_NUMERIC_4
-0x25 KEY_NUMERIC_5
-0x26 KEY_NUMERIC_6
-0x27 KEY_NUMERIC_7
-0x28 KEY_NUMERIC_8
-0x29 KEY_NUMERIC_9
-0x2a KEY_DOT
-0x2b KEY_ENTER
-0x2c KEY_CLEAR
-0x2f KEY_NEXT_FAVORITE
-0x30 KEY_CHANNELUP
-0x31 KEY_CHANNELDOWN
-0x32 KEY_PREVIOUS
-0x33 KEY_SOUND
-0x34 KEY_VIDEO
-0x35 KEY_INFO
-0x36 KEY_HELP
-0x37 KEY_PAGEUP
-0x38 KEY_PAGEDOWN
-0x40 KEY_POWER
-0x41 KEY_VOLUMEUP
-0x42 KEY_VOLUMEDOWN
-0x43 KEY_MUTE
-0x44 KEY_PLAYCD
-0x45 KEY_STOPCD
-0x46 KEY_PAUSECD
-0x47 KEY_RECORD
-0x48 KEY_REWIND
-0x49 KEY_FASTFORWARD
-0x4a KEY_EJECTCD
-0x4b KEY_FORWARD
-0x4c KEY_BACK
-0x4d KEY_STOP_RECORD
-0x4e KEY_PAUSE_RECORD
-0x50 KEY_ANGLE
-0x51 KEY_TV2
-0x52 KEY_VOD
-0x53 KEY_EPG
-0x54 KEY_TIME
-0x55 KEY_CONFIG
-0x58 KEY_AUDIO_DESC
-0x59 KEY_WWW
-0x5a KEY_3D_MODE
-0x60 KEY_PLAYCD
-0x6005 KEY_FASTFORWARD
-0x6006 KEY_FASTFORWARD
-0x6007 KEY_FASTFORWARD
-0x6015 KEY_SLOW
-0x6016 KEY_SLOW
-0x6017 KEY_SLOW
-0x6009 KEY_FASTREVERSE
-0x600a KEY_FASTREVERSE
-0x600b KEY_FASTREVERSE
-0x6019 KEY_SLOWREVERSE
-0x601a KEY_SLOWREVERSE
-0x601b KEY_SLOWREVERSE
-0x6020 KEY_REWIND
-0x6024 KEY_PLAYCD
-0x6025 KEY_PAUSECD
-0x61 KEY_PLAYPAUSE
-0x62 KEY_RECORD
-0x63 KEY_PAUSE_RECORD
-0x64 KEY_STOPCD
-0x65 KEY_MUTE
-0x66 KEY_UNMUTE
-0x6b KEY_POWER
-0x6c KEY_SLEEP
-0x6d KEY_WAKEUP
-0x71 KEY_BLUE
-0x72 KEY_RED
-0x73 KEY_GREEN
-0x74 KEY_YELLOW
-0x75 KEY_F5
-0x76 KEY_DATA
diff --git a/utils/keytable/rc_keymaps/cec.toml b/utils/keytable/rc_keymaps/cec.toml
new file mode 100644
index 00000000..837c13fb
--- /dev/null
+++ b/utils/keytable/rc_keymaps/cec.toml
@@ -0,0 +1,100 @@
+name = "cec"
+protocol = "cec"
+[cec.scancodes]
+0x00 = "KEY_OK"
+0x01 = "KEY_UP"
+0x02 = "KEY_DOWN"
+0x03 = "KEY_LEFT"
+0x04 = "KEY_RIGHT"
+0x05 = "KEY_RIGHT_UP"
+0x06 = "KEY_RIGHT_DOWN"
+0x07 = "KEY_LEFT_UP"
+0x08 = "KEY_LEFT_DOWN"
+0x09 = "KEY_ROOT_MENU"
+0x0a = "KEY_SETUP"
+0x0b = "KEY_MENU"
+0x0c = "KEY_FAVORITES"
+0x0d = "KEY_EXIT"
+0x10 = "KEY_MEDIA_TOP_MENU"
+0x11 = "KEY_CONTEXT_MENU"
+0x1d = "KEY_DIGITS"
+0x1e = "KEY_NUMERIC_11"
+0x1f = "KEY_NUMERIC_12"
+0x20 = "KEY_NUMERIC_0"
+0x21 = "KEY_NUMERIC_1"
+0x22 = "KEY_NUMERIC_2"
+0x23 = "KEY_NUMERIC_3"
+0x24 = "KEY_NUMERIC_4"
+0x25 = "KEY_NUMERIC_5"
+0x26 = "KEY_NUMERIC_6"
+0x27 = "KEY_NUMERIC_7"
+0x28 = "KEY_NUMERIC_8"
+0x29 = "KEY_NUMERIC_9"
+0x2a = "KEY_DOT"
+0x2b = "KEY_ENTER"
+0x2c = "KEY_CLEAR"
+0x2f = "KEY_NEXT_FAVORITE"
+0x30 = "KEY_CHANNELUP"
+0x31 = "KEY_CHANNELDOWN"
+0x32 = "KEY_PREVIOUS"
+0x33 = "KEY_SOUND"
+0x34 = "KEY_VIDEO"
+0x35 = "KEY_INFO"
+0x36 = "KEY_HELP"
+0x37 = "KEY_PAGEUP"
+0x38 = "KEY_PAGEDOWN"
+0x40 = "KEY_POWER"
+0x41 = "KEY_VOLUMEUP"
+0x42 = "KEY_VOLUMEDOWN"
+0x43 = "KEY_MUTE"
+0x44 = "KEY_PLAYCD"
+0x45 = "KEY_STOPCD"
+0x46 = "KEY_PAUSECD"
+0x47 = "KEY_RECORD"
+0x48 = "KEY_REWIND"
+0x49 = "KEY_FASTFORWARD"
+0x4a = "KEY_EJECTCD"
+0x4b = "KEY_FORWARD"
+0x4c = "KEY_BACK"
+0x4d = "KEY_STOP_RECORD"
+0x4e = "KEY_PAUSE_RECORD"
+0x50 = "KEY_ANGLE"
+0x51 = "KEY_TV2"
+0x52 = "KEY_VOD"
+0x53 = "KEY_EPG"
+0x54 = "KEY_TIME"
+0x55 = "KEY_CONFIG"
+0x58 = "KEY_AUDIO_DESC"
+0x59 = "KEY_WWW"
+0x5a = "KEY_3D_MODE"
+0x60 = "KEY_PLAYCD"
+0x6005 = "KEY_FASTFORWARD"
+0x6006 = "KEY_FASTFORWARD"
+0x6007 = "KEY_FASTFORWARD"
+0x6015 = "KEY_SLOW"
+0x6016 = "KEY_SLOW"
+0x6017 = "KEY_SLOW"
+0x6009 = "KEY_FASTREVERSE"
+0x600a = "KEY_FASTREVERSE"
+0x600b = "KEY_FASTREVERSE"
+0x6019 = "KEY_SLOWREVERSE"
+0x601a = "KEY_SLOWREVERSE"
+0x601b = "KEY_SLOWREVERSE"
+0x6020 = "KEY_REWIND"
+0x6024 = "KEY_PLAYCD"
+0x6025 = "KEY_PAUSECD"
+0x61 = "KEY_PLAYPAUSE"
+0x62 = "KEY_RECORD"
+0x63 = "KEY_PAUSE_RECORD"
+0x64 = "KEY_STOPCD"
+0x65 = "KEY_MUTE"
+0x66 = "KEY_UNMUTE"
+0x6b = "KEY_POWER"
+0x6c = "KEY_SLEEP"
+0x6d = "KEY_WAKEUP"
+0x71 = "KEY_BLUE"
+0x72 = "KEY_RED"
+0x73 = "KEY_GREEN"
+0x74 = "KEY_YELLOW"
+0x75 = "KEY_F5"
+0x76 = "KEY_DATA"
diff --git a/utils/keytable/rc_keymaps/cinergy b/utils/keytable/rc_keymaps/cinergy
deleted file mode 100644
index 666f9ee4..00000000
--- a/utils/keytable/rc_keymaps/cinergy
+++ /dev/null
@@ -1,37 +0,0 @@
-# table cinergy, type: UNKNOWN
-0x00 KEY_0
-0x01 KEY_1
-0x02 KEY_2
-0x03 KEY_3
-0x04 KEY_4
-0x05 KEY_5
-0x06 KEY_6
-0x07 KEY_7
-0x08 KEY_8
-0x09 KEY_9
-0x0a KEY_POWER
-0x0b KEY_MEDIA
-0x0c KEY_ZOOM
-0x0d KEY_CHANNELUP
-0x0e KEY_CHANNELDOWN
-0x0f KEY_VOLUMEUP
-0x10 KEY_VOLUMEDOWN
-0x11 KEY_TUNER
-0x12 KEY_NUMLOCK
-0x13 KEY_AUDIO
-0x14 KEY_MUTE
-0x15 KEY_UP
-0x16 KEY_DOWN
-0x17 KEY_LEFT
-0x18 KEY_RIGHT
-0x19 BTN_LEFT
-0x1a BTN_RIGHT
-0x1b KEY_WWW
-0x1c KEY_REWIND
-0x1d KEY_FORWARD
-0x1e KEY_RECORD
-0x1f KEY_PLAY
-0x20 KEY_PREVIOUSSONG
-0x21 KEY_NEXTSONG
-0x22 KEY_PAUSE
-0x23 KEY_STOP
diff --git a/utils/keytable/rc_keymaps/cinergy.toml b/utils/keytable/rc_keymaps/cinergy.toml
new file mode 100644
index 00000000..ca5d9c8c
--- /dev/null
+++ b/utils/keytable/rc_keymaps/cinergy.toml
@@ -0,0 +1,39 @@
+name = "cinergy"
+protocol = "unknown"
+[unknown.scancodes]
+0x00 = "KEY_0"
+0x01 = "KEY_1"
+0x02 = "KEY_2"
+0x03 = "KEY_3"
+0x04 = "KEY_4"
+0x05 = "KEY_5"
+0x06 = "KEY_6"
+0x07 = "KEY_7"
+0x08 = "KEY_8"
+0x09 = "KEY_9"
+0x0a = "KEY_POWER"
+0x0b = "KEY_MEDIA"
+0x0c = "KEY_ZOOM"
+0x0d = "KEY_CHANNELUP"
+0x0e = "KEY_CHANNELDOWN"
+0x0f = "KEY_VOLUMEUP"
+0x10 = "KEY_VOLUMEDOWN"
+0x11 = "KEY_TUNER"
+0x12 = "KEY_NUMLOCK"
+0x13 = "KEY_AUDIO"
+0x14 = "KEY_MUTE"
+0x15 = "KEY_UP"
+0x16 = "KEY_DOWN"
+0x17 = "KEY_LEFT"
+0x18 = "KEY_RIGHT"
+0x19 = "BTN_LEFT"
+0x1a = "BTN_RIGHT"
+0x1b = "KEY_WWW"
+0x1c = "KEY_REWIND"
+0x1d = "KEY_FORWARD"
+0x1e = "KEY_RECORD"
+0x1f = "KEY_PLAY"
+0x20 = "KEY_PREVIOUSSONG"
+0x21 = "KEY_NEXTSONG"
+0x22 = "KEY_PAUSE"
+0x23 = "KEY_STOP"
diff --git a/utils/keytable/rc_keymaps/cinergy_1400 b/utils/keytable/rc_keymaps/cinergy_1400
deleted file mode 100644
index c592f789..00000000
--- a/utils/keytable/rc_keymaps/cinergy_1400
+++ /dev/null
@@ -1,38 +0,0 @@
-# table cinergy_1400, type: UNKNOWN
-0x01 KEY_POWER
-0x02 KEY_1
-0x03 KEY_2
-0x04 KEY_3
-0x05 KEY_4
-0x06 KEY_5
-0x07 KEY_6
-0x08 KEY_7
-0x09 KEY_8
-0x0a KEY_9
-0x0c KEY_0
-0x0b KEY_VIDEO
-0x0d KEY_REFRESH
-0x0e KEY_SELECT
-0x0f KEY_EPG
-0x10 KEY_UP
-0x11 KEY_LEFT
-0x12 KEY_OK
-0x13 KEY_RIGHT
-0x14 KEY_DOWN
-0x15 KEY_TEXT
-0x16 KEY_INFO
-0x17 KEY_RED
-0x18 KEY_GREEN
-0x19 KEY_YELLOW
-0x1a KEY_BLUE
-0x1b KEY_CHANNELUP
-0x1c KEY_VOLUMEUP
-0x1d KEY_MUTE
-0x1e KEY_VOLUMEDOWN
-0x1f KEY_CHANNELDOWN
-0x40 KEY_PAUSE
-0x4c KEY_PLAY
-0x58 KEY_RECORD
-0x54 KEY_PREVIOUS
-0x48 KEY_STOP
-0x5c KEY_NEXT
diff --git a/utils/keytable/rc_keymaps/cinergy_1400.toml b/utils/keytable/rc_keymaps/cinergy_1400.toml
new file mode 100644
index 00000000..74785a20
--- /dev/null
+++ b/utils/keytable/rc_keymaps/cinergy_1400.toml
@@ -0,0 +1,40 @@
+name = "cinergy_1400"
+protocol = "unknown"
+[unknown.scancodes]
+0x01 = "KEY_POWER"
+0x02 = "KEY_1"
+0x03 = "KEY_2"
+0x04 = "KEY_3"
+0x05 = "KEY_4"
+0x06 = "KEY_5"
+0x07 = "KEY_6"
+0x08 = "KEY_7"
+0x09 = "KEY_8"
+0x0a = "KEY_9"
+0x0c = "KEY_0"
+0x0b = "KEY_VIDEO"
+0x0d = "KEY_REFRESH"
+0x0e = "KEY_SELECT"
+0x0f = "KEY_EPG"
+0x10 = "KEY_UP"
+0x11 = "KEY_LEFT"
+0x12 = "KEY_OK"
+0x13 = "KEY_RIGHT"
+0x14 = "KEY_DOWN"
+0x15 = "KEY_TEXT"
+0x16 = "KEY_INFO"
+0x17 = "KEY_RED"
+0x18 = "KEY_GREEN"
+0x19 = "KEY_YELLOW"
+0x1a = "KEY_BLUE"
+0x1b = "KEY_CHANNELUP"
+0x1c = "KEY_VOLUMEUP"
+0x1d = "KEY_MUTE"
+0x1e = "KEY_VOLUMEDOWN"
+0x1f = "KEY_CHANNELDOWN"
+0x40 = "KEY_PAUSE"
+0x4c = "KEY_PLAY"
+0x58 = "KEY_RECORD"
+0x54 = "KEY_PREVIOUS"
+0x48 = "KEY_STOP"
+0x5c = "KEY_NEXT"
diff --git a/utils/keytable/rc_keymaps/cinergyt2 b/utils/keytable/rc_keymaps/cinergyt2
deleted file mode 100644
index ea0c3766..00000000
--- a/utils/keytable/rc_keymaps/cinergyt2
+++ /dev/null
@@ -1,38 +0,0 @@
-# table cinergyt2, type: UNKNOWN
-0x0401 KEY_POWER
-0x0402 KEY_1
-0x0403 KEY_2
-0x0404 KEY_3
-0x0405 KEY_4
-0x0406 KEY_5
-0x0407 KEY_6
-0x0408 KEY_7
-0x0409 KEY_8
-0x040a KEY_9
-0x040c KEY_0
-0x040b KEY_VIDEO
-0x040d KEY_REFRESH
-0x040e KEY_SELECT
-0x040f KEY_EPG
-0x0410 KEY_UP
-0x0414 KEY_DOWN
-0x0411 KEY_LEFT
-0x0413 KEY_RIGHT
-0x0412 KEY_OK
-0x0415 KEY_TEXT
-0x0416 KEY_INFO
-0x0417 KEY_RED
-0x0418 KEY_GREEN
-0x0419 KEY_YELLOW
-0x041a KEY_BLUE
-0x041c KEY_VOLUMEUP
-0x041e KEY_VOLUMEDOWN
-0x041d KEY_MUTE
-0x041b KEY_CHANNELUP
-0x041f KEY_CHANNELDOWN
-0x0440 KEY_PAUSE
-0x044c KEY_PLAY
-0x0458 KEY_RECORD
-0x0454 KEY_PREVIOUS
-0x0448 KEY_STOP
-0x045c KEY_NEXT
diff --git a/utils/keytable/rc_keymaps/cinergyt2.toml b/utils/keytable/rc_keymaps/cinergyt2.toml
new file mode 100644
index 00000000..49699e0b
--- /dev/null
+++ b/utils/keytable/rc_keymaps/cinergyt2.toml
@@ -0,0 +1,40 @@
+name = "cinergyt2"
+protocol = "unknown"
+[unknown.scancodes]
+0x0401 = "KEY_POWER"
+0x0402 = "KEY_1"
+0x0403 = "KEY_2"
+0x0404 = "KEY_3"
+0x0405 = "KEY_4"
+0x0406 = "KEY_5"
+0x0407 = "KEY_6"
+0x0408 = "KEY_7"
+0x0409 = "KEY_8"
+0x040a = "KEY_9"
+0x040c = "KEY_0"
+0x040b = "KEY_VIDEO"
+0x040d = "KEY_REFRESH"
+0x040e = "KEY_SELECT"
+0x040f = "KEY_EPG"
+0x0410 = "KEY_UP"
+0x0414 = "KEY_DOWN"
+0x0411 = "KEY_LEFT"
+0x0413 = "KEY_RIGHT"
+0x0412 = "KEY_OK"
+0x0415 = "KEY_TEXT"
+0x0416 = "KEY_INFO"
+0x0417 = "KEY_RED"
+0x0418 = "KEY_GREEN"
+0x0419 = "KEY_YELLOW"
+0x041a = "KEY_BLUE"
+0x041c = "KEY_VOLUMEUP"
+0x041e = "KEY_VOLUMEDOWN"
+0x041d = "KEY_MUTE"
+0x041b = "KEY_CHANNELUP"
+0x041f = "KEY_CHANNELDOWN"
+0x0440 = "KEY_PAUSE"
+0x044c = "KEY_PLAY"
+0x0458 = "KEY_RECORD"
+0x0454 = "KEY_PREVIOUS"
+0x0448 = "KEY_STOP"
+0x045c = "KEY_NEXT"
diff --git a/utils/keytable/rc_keymaps/d680_dmb b/utils/keytable/rc_keymaps/d680_dmb
deleted file mode 100644
index 2efa19b7..00000000
--- a/utils/keytable/rc_keymaps/d680_dmb
+++ /dev/null
@@ -1,36 +0,0 @@
-# table d680_dmb, type: UNKNOWN
-0x0038 KEY_SWITCHVIDEOMODE
-0x080c KEY_ZOOM
-0x0800 KEY_0
-0x0001 KEY_1
-0x0802 KEY_2
-0x0003 KEY_3
-0x0804 KEY_4
-0x0005 KEY_5
-0x0806 KEY_6
-0x0007 KEY_7
-0x0808 KEY_8
-0x0009 KEY_9
-0x000a KEY_MUTE
-0x0829 KEY_BACK
-0x0012 KEY_CHANNELUP
-0x0813 KEY_CHANNELDOWN
-0x002b KEY_VOLUMEUP
-0x082c KEY_VOLUMEDOWN
-0x0020 KEY_UP
-0x0821 KEY_DOWN
-0x0011 KEY_LEFT
-0x0810 KEY_RIGHT
-0x000d KEY_OK
-0x081f KEY_RECORD
-0x0017 KEY_PLAYPAUSE
-0x0816 KEY_PLAYPAUSE
-0x000b KEY_STOP
-0x0827 KEY_FASTFORWARD
-0x0026 KEY_REWIND
-0x081e KEY_UNKNOWN
-0x000e KEY_UNKNOWN
-0x082d KEY_UNKNOWN
-0x000f KEY_UNKNOWN
-0x0814 KEY_SHUFFLE
-0x0025 KEY_POWER
diff --git a/utils/keytable/rc_keymaps/d680_dmb.toml b/utils/keytable/rc_keymaps/d680_dmb.toml
new file mode 100644
index 00000000..c30ae77d
--- /dev/null
+++ b/utils/keytable/rc_keymaps/d680_dmb.toml
@@ -0,0 +1,38 @@
+name = "d680_dmb"
+protocol = "unknown"
+[unknown.scancodes]
+0x0038 = "KEY_SWITCHVIDEOMODE"
+0x080c = "KEY_ZOOM"
+0x0800 = "KEY_0"
+0x0001 = "KEY_1"
+0x0802 = "KEY_2"
+0x0003 = "KEY_3"
+0x0804 = "KEY_4"
+0x0005 = "KEY_5"
+0x0806 = "KEY_6"
+0x0007 = "KEY_7"
+0x0808 = "KEY_8"
+0x0009 = "KEY_9"
+0x000a = "KEY_MUTE"
+0x0829 = "KEY_BACK"
+0x0012 = "KEY_CHANNELUP"
+0x0813 = "KEY_CHANNELDOWN"
+0x002b = "KEY_VOLUMEUP"
+0x082c = "KEY_VOLUMEDOWN"
+0x0020 = "KEY_UP"
+0x0821 = "KEY_DOWN"
+0x0011 = "KEY_LEFT"
+0x0810 = "KEY_RIGHT"
+0x000d = "KEY_OK"
+0x081f = "KEY_RECORD"
+0x0017 = "KEY_PLAYPAUSE"
+0x0816 = "KEY_PLAYPAUSE"
+0x000b = "KEY_STOP"
+0x0827 = "KEY_FASTFORWARD"
+0x0026 = "KEY_REWIND"
+0x081e = "KEY_UNKNOWN"
+0x000e = "KEY_UNKNOWN"
+0x082d = "KEY_UNKNOWN"
+0x000f = "KEY_UNKNOWN"
+0x0814 = "KEY_SHUFFLE"
+0x0025 = "KEY_POWER"
diff --git a/utils/keytable/rc_keymaps/delock_61959 b/utils/keytable/rc_keymaps/delock_61959
deleted file mode 100644
index 2c51f945..00000000
--- a/utils/keytable/rc_keymaps/delock_61959
+++ /dev/null
@@ -1,33 +0,0 @@
-# table delock_61959, type: NEC
-0x866b16 KEY_POWER2
-0x866b0c KEY_POWER
-0x866b00 KEY_1
-0x866b01 KEY_2
-0x866b02 KEY_3
-0x866b03 KEY_4
-0x866b04 KEY_5
-0x866b05 KEY_6
-0x866b06 KEY_7
-0x866b07 KEY_8
-0x866b08 KEY_9
-0x866b14 KEY_0
-0x866b0a KEY_ZOOM
-0x866b10 KEY_CAMERA
-0x866b0e KEY_CHANNEL
-0x866b13 KEY_ESC
-0x866b20 KEY_UP
-0x866b21 KEY_DOWN
-0x866b42 KEY_LEFT
-0x866b43 KEY_RIGHT
-0x866b0b KEY_OK
-0x866b11 KEY_CHANNELUP
-0x866b1b KEY_CHANNELDOWN
-0x866b12 KEY_VOLUMEUP
-0x866b48 KEY_VOLUMEDOWN
-0x866b44 KEY_MUTE
-0x866b1a KEY_RECORD
-0x866b41 KEY_PLAY
-0x866b40 KEY_STOP
-0x866b19 KEY_PAUSE
-0x866b1c KEY_FASTFORWARD
-0x866b1e KEY_REWIND
diff --git a/utils/keytable/rc_keymaps/delock_61959.toml b/utils/keytable/rc_keymaps/delock_61959.toml
new file mode 100644
index 00000000..1e368aa7
--- /dev/null
+++ b/utils/keytable/rc_keymaps/delock_61959.toml
@@ -0,0 +1,37 @@
+name = "delock_61959"
+protocol = "nec"
+[nec]
+variant = "necx"
+[nec.scancodes]
+0x866b16 = "KEY_POWER2"
+0x866b0c = "KEY_POWER"
+0x866b00 = "KEY_1"
+0x866b01 = "KEY_2"
+0x866b02 = "KEY_3"
+0x866b03 = "KEY_4"
+0x866b04 = "KEY_5"
+0x866b05 = "KEY_6"
+0x866b06 = "KEY_7"
+0x866b07 = "KEY_8"
+0x866b08 = "KEY_9"
+0x866b14 = "KEY_0"
+0x866b0a = "KEY_ZOOM"
+0x866b10 = "KEY_CAMERA"
+0x866b0e = "KEY_CHANNEL"
+0x866b13 = "KEY_ESC"
+0x866b20 = "KEY_UP"
+0x866b21 = "KEY_DOWN"
+0x866b42 = "KEY_LEFT"
+0x866b43 = "KEY_RIGHT"
+0x866b0b = "KEY_OK"
+0x866b11 = "KEY_CHANNELUP"
+0x866b1b = "KEY_CHANNELDOWN"
+0x866b12 = "KEY_VOLUMEUP"
+0x866b48 = "KEY_VOLUMEDOWN"
+0x866b44 = "KEY_MUTE"
+0x866b1a = "KEY_RECORD"
+0x866b41 = "KEY_PLAY"
+0x866b40 = "KEY_STOP"
+0x866b19 = "KEY_PAUSE"
+0x866b1c = "KEY_FASTFORWARD"
+0x866b1e = "KEY_REWIND"
diff --git a/utils/keytable/rc_keymaps/dib0700_nec b/utils/keytable/rc_keymaps/dib0700_nec
deleted file mode 100644
index 55cd2cf6..00000000
--- a/utils/keytable/rc_keymaps/dib0700_nec
+++ /dev/null
@@ -1,71 +0,0 @@
-# table dib0700_nec, type: NEC
-0x866b13 KEY_MUTE
-0x866b12 KEY_POWER
-0x866b01 KEY_1
-0x866b02 KEY_2
-0x866b03 KEY_3
-0x866b04 KEY_4
-0x866b05 KEY_5
-0x866b06 KEY_6
-0x866b07 KEY_7
-0x866b08 KEY_8
-0x866b09 KEY_9
-0x866b00 KEY_0
-0x866b0d KEY_CHANNELUP
-0x866b19 KEY_CHANNELDOWN
-0x866b10 KEY_VOLUMEUP
-0x866b0c KEY_VOLUMEDOWN
-0x866b0a KEY_CAMERA
-0x866b0b KEY_ZOOM
-0x866b1b KEY_BACKSPACE
-0x866b15 KEY_ENTER
-0x866b1d KEY_UP
-0x866b1e KEY_DOWN
-0x866b0e KEY_LEFT
-0x866b0f KEY_RIGHT
-0x866b18 KEY_RECORD
-0x866b1a KEY_STOP
-0x7a00 KEY_MENU
-0x7a01 KEY_RECORD
-0x7a02 KEY_PLAY
-0x7a03 KEY_STOP
-0x7a10 KEY_CHANNELUP
-0x7a11 KEY_CHANNELDOWN
-0x7a12 KEY_VOLUMEUP
-0x7a13 KEY_VOLUMEDOWN
-0x7a40 KEY_POWER
-0x7a41 KEY_MUTE
-0x4501 KEY_POWER
-0x4502 KEY_MUTE
-0x4503 KEY_1
-0x4504 KEY_2
-0x4505 KEY_3
-0x4506 KEY_4
-0x4507 KEY_5
-0x4508 KEY_6
-0x4509 KEY_7
-0x450a KEY_8
-0x450b KEY_9
-0x450c KEY_LAST
-0x450d KEY_0
-0x450e KEY_ENTER
-0x450f KEY_RED
-0x4510 KEY_CHANNELUP
-0x4511 KEY_GREEN
-0x4512 KEY_VOLUMEDOWN
-0x4513 KEY_OK
-0x4514 KEY_VOLUMEUP
-0x4515 KEY_YELLOW
-0x4516 KEY_CHANNELDOWN
-0x4517 KEY_BLUE
-0x4518 KEY_LEFT
-0x4519 KEY_PLAYPAUSE
-0x451a KEY_RIGHT
-0x451b KEY_REWIND
-0x451c KEY_L
-0x451d KEY_FASTFORWARD
-0x451e KEY_STOP
-0x451f KEY_MENU
-0x4540 KEY_RECORD
-0x4541 KEY_SCREEN
-0x4542 KEY_SELECT
diff --git a/utils/keytable/rc_keymaps/dib0700_nec.toml b/utils/keytable/rc_keymaps/dib0700_nec.toml
new file mode 100644
index 00000000..ee98481d
--- /dev/null
+++ b/utils/keytable/rc_keymaps/dib0700_nec.toml
@@ -0,0 +1,75 @@
+name = "dib0700_nec"
+protocol = "nec"
+[nec]
+variant = "nec"
+[nec.scancodes]
+0x866b13 = "KEY_MUTE"
+0x866b12 = "KEY_POWER"
+0x866b01 = "KEY_1"
+0x866b02 = "KEY_2"
+0x866b03 = "KEY_3"
+0x866b04 = "KEY_4"
+0x866b05 = "KEY_5"
+0x866b06 = "KEY_6"
+0x866b07 = "KEY_7"
+0x866b08 = "KEY_8"
+0x866b09 = "KEY_9"
+0x866b00 = "KEY_0"
+0x866b0d = "KEY_CHANNELUP"
+0x866b19 = "KEY_CHANNELDOWN"
+0x866b10 = "KEY_VOLUMEUP"
+0x866b0c = "KEY_VOLUMEDOWN"
+0x866b0a = "KEY_CAMERA"
+0x866b0b = "KEY_ZOOM"
+0x866b1b = "KEY_BACKSPACE"
+0x866b15 = "KEY_ENTER"
+0x866b1d = "KEY_UP"
+0x866b1e = "KEY_DOWN"
+0x866b0e = "KEY_LEFT"
+0x866b0f = "KEY_RIGHT"
+0x866b18 = "KEY_RECORD"
+0x866b1a = "KEY_STOP"
+0x7a00 = "KEY_MENU"
+0x7a01 = "KEY_RECORD"
+0x7a02 = "KEY_PLAY"
+0x7a03 = "KEY_STOP"
+0x7a10 = "KEY_CHANNELUP"
+0x7a11 = "KEY_CHANNELDOWN"
+0x7a12 = "KEY_VOLUMEUP"
+0x7a13 = "KEY_VOLUMEDOWN"
+0x7a40 = "KEY_POWER"
+0x7a41 = "KEY_MUTE"
+0x4501 = "KEY_POWER"
+0x4502 = "KEY_MUTE"
+0x4503 = "KEY_1"
+0x4504 = "KEY_2"
+0x4505 = "KEY_3"
+0x4506 = "KEY_4"
+0x4507 = "KEY_5"
+0x4508 = "KEY_6"
+0x4509 = "KEY_7"
+0x450a = "KEY_8"
+0x450b = "KEY_9"
+0x450c = "KEY_LAST"
+0x450d = "KEY_0"
+0x450e = "KEY_ENTER"
+0x450f = "KEY_RED"
+0x4510 = "KEY_CHANNELUP"
+0x4511 = "KEY_GREEN"
+0x4512 = "KEY_VOLUMEDOWN"
+0x4513 = "KEY_OK"
+0x4514 = "KEY_VOLUMEUP"
+0x4515 = "KEY_YELLOW"
+0x4516 = "KEY_CHANNELDOWN"
+0x4517 = "KEY_BLUE"
+0x4518 = "KEY_LEFT"
+0x4519 = "KEY_PLAYPAUSE"
+0x451a = "KEY_RIGHT"
+0x451b = "KEY_REWIND"
+0x451c = "KEY_L"
+0x451d = "KEY_FASTFORWARD"
+0x451e = "KEY_STOP"
+0x451f = "KEY_MENU"
+0x4540 = "KEY_RECORD"
+0x4541 = "KEY_SCREEN"
+0x4542 = "KEY_SELECT"
diff --git a/utils/keytable/rc_keymaps/dib0700_rc5 b/utils/keytable/rc_keymaps/dib0700_rc5
deleted file mode 100644
index 4f8377f3..00000000
--- a/utils/keytable/rc_keymaps/dib0700_rc5
+++ /dev/null
@@ -1,181 +0,0 @@
-# table dib0700_rc5, type: RC5
-0x0700 KEY_MUTE
-0x0701 KEY_MENU
-0x0739 KEY_POWER
-0x0703 KEY_VOLUMEUP
-0x0709 KEY_VOLUMEDOWN
-0x0706 KEY_CHANNELUP
-0x070c KEY_CHANNELDOWN
-0x070f KEY_1
-0x0715 KEY_2
-0x0710 KEY_3
-0x0718 KEY_4
-0x071b KEY_5
-0x071e KEY_6
-0x0711 KEY_7
-0x0721 KEY_8
-0x0712 KEY_9
-0x0727 KEY_0
-0x0724 KEY_SCREEN
-0x072a KEY_TEXT
-0x072d KEY_REWIND
-0x0730 KEY_PLAY
-0x0733 KEY_FASTFORWARD
-0x0736 KEY_RECORD
-0x073c KEY_STOP
-0x073f KEY_CANCEL
-0xeb01 KEY_POWER
-0xeb02 KEY_1
-0xeb03 KEY_2
-0xeb04 KEY_3
-0xeb05 KEY_4
-0xeb06 KEY_5
-0xeb07 KEY_6
-0xeb08 KEY_7
-0xeb09 KEY_8
-0xeb0a KEY_9
-0xeb0b KEY_VIDEO
-0xeb0c KEY_0
-0xeb0d KEY_REFRESH
-0xeb0f KEY_EPG
-0xeb10 KEY_UP
-0xeb11 KEY_LEFT
-0xeb12 KEY_OK
-0xeb13 KEY_RIGHT
-0xeb14 KEY_DOWN
-0xeb16 KEY_INFO
-0xeb17 KEY_RED
-0xeb18 KEY_GREEN
-0xeb19 KEY_YELLOW
-0xeb1a KEY_BLUE
-0xeb1b KEY_CHANNELUP
-0xeb1c KEY_VOLUMEUP
-0xeb1d KEY_MUTE
-0xeb1e KEY_VOLUMEDOWN
-0xeb1f KEY_CHANNELDOWN
-0xeb40 KEY_PAUSE
-0xeb41 KEY_HOME
-0xeb42 KEY_MENU
-0xeb43 KEY_SUBTITLE
-0xeb44 KEY_TEXT
-0xeb45 KEY_DELETE
-0xeb46 KEY_TV
-0xeb47 KEY_DVD
-0xeb48 KEY_STOP
-0xeb49 KEY_VIDEO
-0xeb4a KEY_AUDIO
-0xeb4b KEY_SCREEN
-0xeb4c KEY_PLAY
-0xeb4d KEY_BACK
-0xeb4e KEY_REWIND
-0xeb4f KEY_FASTFORWARD
-0xeb54 KEY_PREVIOUS
-0xeb58 KEY_RECORD
-0xeb5c KEY_NEXT
-0x1e00 KEY_0
-0x1e01 KEY_1
-0x1e02 KEY_2
-0x1e03 KEY_3
-0x1e04 KEY_4
-0x1e05 KEY_5
-0x1e06 KEY_6
-0x1e07 KEY_7
-0x1e08 KEY_8
-0x1e09 KEY_9
-0x1e0a KEY_KPASTERISK
-0x1e0b KEY_RED
-0x1e0c KEY_RADIO
-0x1e0d KEY_MENU
-0x1e0e KEY_GRAVE
-0x1e0f KEY_MUTE
-0x1e10 KEY_VOLUMEUP
-0x1e11 KEY_VOLUMEDOWN
-0x1e12 KEY_CHANNEL
-0x1e14 KEY_UP
-0x1e15 KEY_DOWN
-0x1e16 KEY_LEFT
-0x1e17 KEY_RIGHT
-0x1e18 KEY_VIDEO
-0x1e19 KEY_AUDIO
-0x1e1a KEY_MEDIA
-0x1e1b KEY_EPG
-0x1e1c KEY_TV
-0x1e1e KEY_NEXT
-0x1e1f KEY_BACK
-0x1e20 KEY_CHANNELUP
-0x1e21 KEY_CHANNELDOWN
-0x1e24 KEY_LAST
-0x1e25 KEY_OK
-0x1e29 KEY_BLUE
-0x1e2e KEY_GREEN
-0x1e30 KEY_PAUSE
-0x1e32 KEY_REWIND
-0x1e34 KEY_FASTFORWARD
-0x1e35 KEY_PLAY
-0x1e36 KEY_STOP
-0x1e37 KEY_RECORD
-0x1e38 KEY_YELLOW
-0x1e3b KEY_GOTO
-0x1e3d KEY_POWER
-0x0042 KEY_POWER
-0x077c KEY_TUNER
-0x0f4e KEY_PRINT
-0x0840 KEY_SCREEN
-0x0f71 KEY_DOT
-0x0743 KEY_0
-0x0c41 KEY_1
-0x0443 KEY_2
-0x0b7f KEY_3
-0x0e41 KEY_4
-0x0643 KEY_5
-0x097f KEY_6
-0x0d7e KEY_7
-0x057c KEY_8
-0x0a40 KEY_9
-0x0e4e KEY_CLEAR
-0x047c KEY_CHANNEL
-0x0f41 KEY_LAST
-0x0342 KEY_MUTE
-0x064c KEY_RESERVED
-0x0172 KEY_SHUFFLE
-0x0c4e KEY_PLAYPAUSE
-0x0b70 KEY_RECORD
-0x037d KEY_VOLUMEUP
-0x017d KEY_VOLUMEDOWN
-0x0242 KEY_CHANNELUP
-0x007d KEY_CHANNELDOWN
-0x1d00 KEY_0
-0x1d01 KEY_1
-0x1d02 KEY_2
-0x1d03 KEY_3
-0x1d04 KEY_4
-0x1d05 KEY_5
-0x1d06 KEY_6
-0x1d07 KEY_7
-0x1d08 KEY_8
-0x1d09 KEY_9
-0x1d0a KEY_TEXT
-0x1d0d KEY_MENU
-0x1d0f KEY_MUTE
-0x1d10 KEY_VOLUMEUP
-0x1d11 KEY_VOLUMEDOWN
-0x1d12 KEY_CHANNEL
-0x1d14 KEY_UP
-0x1d15 KEY_DOWN
-0x1d16 KEY_LEFT
-0x1d17 KEY_RIGHT
-0x1d1c KEY_TV
-0x1d1e KEY_NEXT
-0x1d1f KEY_BACK
-0x1d20 KEY_CHANNELUP
-0x1d21 KEY_CHANNELDOWN
-0x1d24 KEY_LAST
-0x1d25 KEY_OK
-0x1d30 KEY_PAUSE
-0x1d32 KEY_REWIND
-0x1d34 KEY_FASTFORWARD
-0x1d35 KEY_PLAY
-0x1d36 KEY_STOP
-0x1d37 KEY_RECORD
-0x1d3b KEY_GOTO
-0x1d3d KEY_POWER
diff --git a/utils/keytable/rc_keymaps/dib0700_rc5.toml b/utils/keytable/rc_keymaps/dib0700_rc5.toml
new file mode 100644
index 00000000..8950b931
--- /dev/null
+++ b/utils/keytable/rc_keymaps/dib0700_rc5.toml
@@ -0,0 +1,185 @@
+name = "dib0700_rc5"
+protocol = "rc5"
+[rc5]
+variant = "rc5"
+[rc5.scancodes]
+0x0700 = "KEY_MUTE"
+0x0701 = "KEY_MENU"
+0x0739 = "KEY_POWER"
+0x0703 = "KEY_VOLUMEUP"
+0x0709 = "KEY_VOLUMEDOWN"
+0x0706 = "KEY_CHANNELUP"
+0x070c = "KEY_CHANNELDOWN"
+0x070f = "KEY_1"
+0x0715 = "KEY_2"
+0x0710 = "KEY_3"
+0x0718 = "KEY_4"
+0x071b = "KEY_5"
+0x071e = "KEY_6"
+0x0711 = "KEY_7"
+0x0721 = "KEY_8"
+0x0712 = "KEY_9"
+0x0727 = "KEY_0"
+0x0724 = "KEY_SCREEN"
+0x072a = "KEY_TEXT"
+0x072d = "KEY_REWIND"
+0x0730 = "KEY_PLAY"
+0x0733 = "KEY_FASTFORWARD"
+0x0736 = "KEY_RECORD"
+0x073c = "KEY_STOP"
+0x073f = "KEY_CANCEL"
+0xeb01 = "KEY_POWER"
+0xeb02 = "KEY_1"
+0xeb03 = "KEY_2"
+0xeb04 = "KEY_3"
+0xeb05 = "KEY_4"
+0xeb06 = "KEY_5"
+0xeb07 = "KEY_6"
+0xeb08 = "KEY_7"
+0xeb09 = "KEY_8"
+0xeb0a = "KEY_9"
+0xeb0b = "KEY_VIDEO"
+0xeb0c = "KEY_0"
+0xeb0d = "KEY_REFRESH"
+0xeb0f = "KEY_EPG"
+0xeb10 = "KEY_UP"
+0xeb11 = "KEY_LEFT"
+0xeb12 = "KEY_OK"
+0xeb13 = "KEY_RIGHT"
+0xeb14 = "KEY_DOWN"
+0xeb16 = "KEY_INFO"
+0xeb17 = "KEY_RED"
+0xeb18 = "KEY_GREEN"
+0xeb19 = "KEY_YELLOW"
+0xeb1a = "KEY_BLUE"
+0xeb1b = "KEY_CHANNELUP"
+0xeb1c = "KEY_VOLUMEUP"
+0xeb1d = "KEY_MUTE"
+0xeb1e = "KEY_VOLUMEDOWN"
+0xeb1f = "KEY_CHANNELDOWN"
+0xeb40 = "KEY_PAUSE"
+0xeb41 = "KEY_HOME"
+0xeb42 = "KEY_MENU"
+0xeb43 = "KEY_SUBTITLE"
+0xeb44 = "KEY_TEXT"
+0xeb45 = "KEY_DELETE"
+0xeb46 = "KEY_TV"
+0xeb47 = "KEY_DVD"
+0xeb48 = "KEY_STOP"
+0xeb49 = "KEY_VIDEO"
+0xeb4a = "KEY_AUDIO"
+0xeb4b = "KEY_SCREEN"
+0xeb4c = "KEY_PLAY"
+0xeb4d = "KEY_BACK"
+0xeb4e = "KEY_REWIND"
+0xeb4f = "KEY_FASTFORWARD"
+0xeb54 = "KEY_PREVIOUS"
+0xeb58 = "KEY_RECORD"
+0xeb5c = "KEY_NEXT"
+0x1e00 = "KEY_0"
+0x1e01 = "KEY_1"
+0x1e02 = "KEY_2"
+0x1e03 = "KEY_3"
+0x1e04 = "KEY_4"
+0x1e05 = "KEY_5"
+0x1e06 = "KEY_6"
+0x1e07 = "KEY_7"
+0x1e08 = "KEY_8"
+0x1e09 = "KEY_9"
+0x1e0a = "KEY_KPASTERISK"
+0x1e0b = "KEY_RED"
+0x1e0c = "KEY_RADIO"
+0x1e0d = "KEY_MENU"
+0x1e0e = "KEY_GRAVE"
+0x1e0f = "KEY_MUTE"
+0x1e10 = "KEY_VOLUMEUP"
+0x1e11 = "KEY_VOLUMEDOWN"
+0x1e12 = "KEY_CHANNEL"
+0x1e14 = "KEY_UP"
+0x1e15 = "KEY_DOWN"
+0x1e16 = "KEY_LEFT"
+0x1e17 = "KEY_RIGHT"
+0x1e18 = "KEY_VIDEO"
+0x1e19 = "KEY_AUDIO"
+0x1e1a = "KEY_MEDIA"
+0x1e1b = "KEY_EPG"
+0x1e1c = "KEY_TV"
+0x1e1e = "KEY_NEXT"
+0x1e1f = "KEY_BACK"
+0x1e20 = "KEY_CHANNELUP"
+0x1e21 = "KEY_CHANNELDOWN"
+0x1e24 = "KEY_LAST"
+0x1e25 = "KEY_OK"
+0x1e29 = "KEY_BLUE"
+0x1e2e = "KEY_GREEN"
+0x1e30 = "KEY_PAUSE"
+0x1e32 = "KEY_REWIND"
+0x1e34 = "KEY_FASTFORWARD"
+0x1e35 = "KEY_PLAY"
+0x1e36 = "KEY_STOP"
+0x1e37 = "KEY_RECORD"
+0x1e38 = "KEY_YELLOW"
+0x1e3b = "KEY_GOTO"
+0x1e3d = "KEY_POWER"
+0x0042 = "KEY_POWER"
+0x077c = "KEY_TUNER"
+0x0f4e = "KEY_PRINT"
+0x0840 = "KEY_SCREEN"
+0x0f71 = "KEY_DOT"
+0x0743 = "KEY_0"
+0x0c41 = "KEY_1"
+0x0443 = "KEY_2"
+0x0b7f = "KEY_3"
+0x0e41 = "KEY_4"
+0x0643 = "KEY_5"
+0x097f = "KEY_6"
+0x0d7e = "KEY_7"
+0x057c = "KEY_8"
+0x0a40 = "KEY_9"
+0x0e4e = "KEY_CLEAR"
+0x047c = "KEY_CHANNEL"
+0x0f41 = "KEY_LAST"
+0x0342 = "KEY_MUTE"
+0x064c = "KEY_RESERVED"
+0x0172 = "KEY_SHUFFLE"
+0x0c4e = "KEY_PLAYPAUSE"
+0x0b70 = "KEY_RECORD"
+0x037d = "KEY_VOLUMEUP"
+0x017d = "KEY_VOLUMEDOWN"
+0x0242 = "KEY_CHANNELUP"
+0x007d = "KEY_CHANNELDOWN"
+0x1d00 = "KEY_0"
+0x1d01 = "KEY_1"
+0x1d02 = "KEY_2"
+0x1d03 = "KEY_3"
+0x1d04 = "KEY_4"
+0x1d05 = "KEY_5"
+0x1d06 = "KEY_6"
+0x1d07 = "KEY_7"
+0x1d08 = "KEY_8"
+0x1d09 = "KEY_9"
+0x1d0a = "KEY_TEXT"
+0x1d0d = "KEY_MENU"
+0x1d0f = "KEY_MUTE"
+0x1d10 = "KEY_VOLUMEUP"
+0x1d11 = "KEY_VOLUMEDOWN"
+0x1d12 = "KEY_CHANNEL"
+0x1d14 = "KEY_UP"
+0x1d15 = "KEY_DOWN"
+0x1d16 = "KEY_LEFT"
+0x1d17 = "KEY_RIGHT"
+0x1d1c = "KEY_TV"
+0x1d1e = "KEY_NEXT"
+0x1d1f = "KEY_BACK"
+0x1d20 = "KEY_CHANNELUP"
+0x1d21 = "KEY_CHANNELDOWN"
+0x1d24 = "KEY_LAST"
+0x1d25 = "KEY_OK"
+0x1d30 = "KEY_PAUSE"
+0x1d32 = "KEY_REWIND"
+0x1d34 = "KEY_FASTFORWARD"
+0x1d35 = "KEY_PLAY"
+0x1d36 = "KEY_STOP"
+0x1d37 = "KEY_RECORD"
+0x1d3b = "KEY_GOTO"
+0x1d3d = "KEY_POWER"
diff --git a/utils/keytable/rc_keymaps/dibusb b/utils/keytable/rc_keymaps/dibusb
deleted file mode 100644
index b00b96d0..00000000
--- a/utils/keytable/rc_keymaps/dibusb
+++ /dev/null
@@ -1,112 +0,0 @@
-# table dibusb, type: UNKNOWN
-0x0016 KEY_POWER
-0x0010 KEY_MUTE
-0x0003 KEY_1
-0x0001 KEY_2
-0x0006 KEY_3
-0x0009 KEY_4
-0x001d KEY_5
-0x001f KEY_6
-0x000d KEY_7
-0x0019 KEY_8
-0x001b KEY_9
-0x0015 KEY_0
-0x0005 KEY_CHANNELUP
-0x0002 KEY_CHANNELDOWN
-0x001e KEY_VOLUMEUP
-0x000a KEY_VOLUMEDOWN
-0x0011 KEY_RECORD
-0x0017 KEY_FAVORITES
-0x0014 KEY_PLAY
-0x001a KEY_STOP
-0x0040 KEY_REWIND
-0x0012 KEY_FASTFORWARD
-0x000e KEY_PREVIOUS
-0x004c KEY_PAUSE
-0x004d KEY_SCREEN
-0x0054 KEY_AUDIO
-0x000c KEY_CANCEL
-0x001c KEY_EPG
-0x0000 KEY_TAB
-0x0048 KEY_INFO
-0x0004 KEY_LIST
-0x000f KEY_TEXT
-0x8612 KEY_POWER
-0x860f KEY_SELECT
-0x860c KEY_UNKNOWN
-0x860b KEY_EPG
-0x8610 KEY_MUTE
-0x8601 KEY_1
-0x8602 KEY_2
-0x8603 KEY_3
-0x8604 KEY_4
-0x8605 KEY_5
-0x8606 KEY_6
-0x8607 KEY_7
-0x8608 KEY_8
-0x8609 KEY_9
-0x860a KEY_0
-0x8618 KEY_ZOOM
-0x861c KEY_UNKNOWN
-0x8613 KEY_UNKNOWN
-0x8600 KEY_UNDO
-0x861d KEY_RECORD
-0x860d KEY_STOP
-0x860e KEY_PAUSE
-0x8616 KEY_PLAY
-0x8611 KEY_BACK
-0x8619 KEY_FORWARD
-0x8614 KEY_UNKNOWN
-0x8615 KEY_ESC
-0x861a KEY_UP
-0x861e KEY_DOWN
-0x861f KEY_LEFT
-0x861b KEY_RIGHT
-0x8000 KEY_MUTE
-0x8001 KEY_TEXT
-0x8002 KEY_HOME
-0x8003 KEY_POWER
-0x8004 KEY_RED
-0x8005 KEY_GREEN
-0x8006 KEY_YELLOW
-0x8007 KEY_BLUE
-0x8008 KEY_DVD
-0x8009 KEY_AUDIO
-0x800a KEY_IMAGES
-0x800b KEY_VIDEO
-0x800c KEY_BACK
-0x800d KEY_UP
-0x800e KEY_RADIO
-0x800f KEY_EPG
-0x8010 KEY_LEFT
-0x8011 KEY_OK
-0x8012 KEY_RIGHT
-0x8013 KEY_UNKNOWN
-0x8014 KEY_TV
-0x8015 KEY_DOWN
-0x8016 KEY_MENU
-0x8017 KEY_LAST
-0x8018 KEY_RECORD
-0x8019 KEY_STOP
-0x801a KEY_PAUSE
-0x801b KEY_PLAY
-0x801c KEY_PREVIOUS
-0x801d KEY_REWIND
-0x801e KEY_FASTFORWARD
-0x801f KEY_NEXT
-0x8040 KEY_1
-0x8041 KEY_2
-0x8042 KEY_3
-0x8043 KEY_CHANNELUP
-0x8044 KEY_4
-0x8045 KEY_5
-0x8046 KEY_6
-0x8047 KEY_CHANNELDOWN
-0x8048 KEY_7
-0x8049 KEY_8
-0x804a KEY_9
-0x804b KEY_VOLUMEUP
-0x804c KEY_CLEAR
-0x804d KEY_0
-0x804e KEY_ENTER
-0x804f KEY_VOLUMEDOWN
diff --git a/utils/keytable/rc_keymaps/dibusb.toml b/utils/keytable/rc_keymaps/dibusb.toml
new file mode 100644
index 00000000..a37b541d
--- /dev/null
+++ b/utils/keytable/rc_keymaps/dibusb.toml
@@ -0,0 +1,114 @@
+name = "dibusb"
+protocol = "unknown"
+[unknown.scancodes]
+0x0016 = "KEY_POWER"
+0x0010 = "KEY_MUTE"
+0x0003 = "KEY_1"
+0x0001 = "KEY_2"
+0x0006 = "KEY_3"
+0x0009 = "KEY_4"
+0x001d = "KEY_5"
+0x001f = "KEY_6"
+0x000d = "KEY_7"
+0x0019 = "KEY_8"
+0x001b = "KEY_9"
+0x0015 = "KEY_0"
+0x0005 = "KEY_CHANNELUP"
+0x0002 = "KEY_CHANNELDOWN"
+0x001e = "KEY_VOLUMEUP"
+0x000a = "KEY_VOLUMEDOWN"
+0x0011 = "KEY_RECORD"
+0x0017 = "KEY_FAVORITES"
+0x0014 = "KEY_PLAY"
+0x001a = "KEY_STOP"
+0x0040 = "KEY_REWIND"
+0x0012 = "KEY_FASTFORWARD"
+0x000e = "KEY_PREVIOUS"
+0x004c = "KEY_PAUSE"
+0x004d = "KEY_SCREEN"
+0x0054 = "KEY_AUDIO"
+0x000c = "KEY_CANCEL"
+0x001c = "KEY_EPG"
+0x0000 = "KEY_TAB"
+0x0048 = "KEY_INFO"
+0x0004 = "KEY_LIST"
+0x000f = "KEY_TEXT"
+0x8612 = "KEY_POWER"
+0x860f = "KEY_SELECT"
+0x860c = "KEY_UNKNOWN"
+0x860b = "KEY_EPG"
+0x8610 = "KEY_MUTE"
+0x8601 = "KEY_1"
+0x8602 = "KEY_2"
+0x8603 = "KEY_3"
+0x8604 = "KEY_4"
+0x8605 = "KEY_5"
+0x8606 = "KEY_6"
+0x8607 = "KEY_7"
+0x8608 = "KEY_8"
+0x8609 = "KEY_9"
+0x860a = "KEY_0"
+0x8618 = "KEY_ZOOM"
+0x861c = "KEY_UNKNOWN"
+0x8613 = "KEY_UNKNOWN"
+0x8600 = "KEY_UNDO"
+0x861d = "KEY_RECORD"
+0x860d = "KEY_STOP"
+0x860e = "KEY_PAUSE"
+0x8616 = "KEY_PLAY"
+0x8611 = "KEY_BACK"
+0x8619 = "KEY_FORWARD"
+0x8614 = "KEY_UNKNOWN"
+0x8615 = "KEY_ESC"
+0x861a = "KEY_UP"
+0x861e = "KEY_DOWN"
+0x861f = "KEY_LEFT"
+0x861b = "KEY_RIGHT"
+0x8000 = "KEY_MUTE"
+0x8001 = "KEY_TEXT"
+0x8002 = "KEY_HOME"
+0x8003 = "KEY_POWER"
+0x8004 = "KEY_RED"
+0x8005 = "KEY_GREEN"
+0x8006 = "KEY_YELLOW"
+0x8007 = "KEY_BLUE"
+0x8008 = "KEY_DVD"
+0x8009 = "KEY_AUDIO"
+0x800a = "KEY_IMAGES"
+0x800b = "KEY_VIDEO"
+0x800c = "KEY_BACK"
+0x800d = "KEY_UP"
+0x800e = "KEY_RADIO"
+0x800f = "KEY_EPG"
+0x8010 = "KEY_LEFT"
+0x8011 = "KEY_OK"
+0x8012 = "KEY_RIGHT"
+0x8013 = "KEY_UNKNOWN"
+0x8014 = "KEY_TV"
+0x8015 = "KEY_DOWN"
+0x8016 = "KEY_MENU"
+0x8017 = "KEY_LAST"
+0x8018 = "KEY_RECORD"
+0x8019 = "KEY_STOP"
+0x801a = "KEY_PAUSE"
+0x801b = "KEY_PLAY"
+0x801c = "KEY_PREVIOUS"
+0x801d = "KEY_REWIND"
+0x801e = "KEY_FASTFORWARD"
+0x801f = "KEY_NEXT"
+0x8040 = "KEY_1"
+0x8041 = "KEY_2"
+0x8042 = "KEY_3"
+0x8043 = "KEY_CHANNELUP"
+0x8044 = "KEY_4"
+0x8045 = "KEY_5"
+0x8046 = "KEY_6"
+0x8047 = "KEY_CHANNELDOWN"
+0x8048 = "KEY_7"
+0x8049 = "KEY_8"
+0x804a = "KEY_9"
+0x804b = "KEY_VOLUMEUP"
+0x804c = "KEY_CLEAR"
+0x804d = "KEY_0"
+0x804e = "KEY_ENTER"
+0x804f = "KEY_VOLUMEDOWN"
diff --git a/utils/keytable/rc_keymaps/digitalnow_tinytwin b/utils/keytable/rc_keymaps/digitalnow_tinytwin
deleted file mode 100644
index eb5e6773..00000000
--- a/utils/keytable/rc_keymaps/digitalnow_tinytwin
+++ /dev/null
@@ -1,50 +0,0 @@
-# table digitalnow_tinytwin, type: NEC
-0x0000 KEY_MUTE
-0x0001 KEY_VOLUMEUP
-0x0002 KEY_POWER2
-0x0003 KEY_2
-0x0004 KEY_3
-0x0005 KEY_4
-0x0006 KEY_6
-0x0007 KEY_7
-0x0008 KEY_8
-0x0009 KEY_NUMERIC_STAR
-0x000a KEY_0
-0x000b KEY_NUMERIC_POUND
-0x000c KEY_RIGHT
-0x000d KEY_HOMEPAGE
-0x000e KEY_RED
-0x0010 KEY_POWER
-0x0011 KEY_YELLOW
-0x0012 KEY_DOWN
-0x0013 KEY_GREEN
-0x0014 KEY_CYCLEWINDOWS
-0x0015 KEY_FAVORITES
-0x0016 KEY_UP
-0x0017 KEY_LEFT
-0x0018 KEY_OK
-0x0019 KEY_BLUE
-0x001a KEY_REWIND
-0x001b KEY_PLAY
-0x001c KEY_5
-0x001d KEY_9
-0x001e KEY_VOLUMEDOWN
-0x001f KEY_1
-0x0040 KEY_STOP
-0x0042 KEY_PAUSE
-0x0043 KEY_SCREEN
-0x0044 KEY_FORWARD
-0x0045 KEY_NEXT
-0x0048 KEY_RECORD
-0x0049 KEY_VIDEO
-0x004a KEY_EPG
-0x004b KEY_CHANNELUP
-0x004c KEY_HELP
-0x004d KEY_RADIO
-0x004f KEY_CHANNELDOWN
-0x0050 KEY_DVD
-0x0051 KEY_AUDIO
-0x0052 KEY_TITLE
-0x0053 KEY_NEW
-0x0057 KEY_MENU
-0x005a KEY_PREVIOUS
diff --git a/utils/keytable/rc_keymaps/digitalnow_tinytwin.toml b/utils/keytable/rc_keymaps/digitalnow_tinytwin.toml
new file mode 100644
index 00000000..e4f84a51
--- /dev/null
+++ b/utils/keytable/rc_keymaps/digitalnow_tinytwin.toml
@@ -0,0 +1,54 @@
+name = "digitalnow_tinytwin"
+protocol = "nec"
+[nec]
+variant = "nec"
+[nec.scancodes]
+0x0000 = "KEY_MUTE"
+0x0001 = "KEY_VOLUMEUP"
+0x0002 = "KEY_POWER2"
+0x0003 = "KEY_2"
+0x0004 = "KEY_3"
+0x0005 = "KEY_4"
+0x0006 = "KEY_6"
+0x0007 = "KEY_7"
+0x0008 = "KEY_8"
+0x0009 = "KEY_NUMERIC_STAR"
+0x000a = "KEY_0"
+0x000b = "KEY_NUMERIC_POUND"
+0x000c = "KEY_RIGHT"
+0x000d = "KEY_HOMEPAGE"
+0x000e = "KEY_RED"
+0x0010 = "KEY_POWER"
+0x0011 = "KEY_YELLOW"
+0x0012 = "KEY_DOWN"
+0x0013 = "KEY_GREEN"
+0x0014 = "KEY_CYCLEWINDOWS"
+0x0015 = "KEY_FAVORITES"
+0x0016 = "KEY_UP"
+0x0017 = "KEY_LEFT"
+0x0018 = "KEY_OK"
+0x0019 = "KEY_BLUE"
+0x001a = "KEY_REWIND"
+0x001b = "KEY_PLAY"
+0x001c = "KEY_5"
+0x001d = "KEY_9"
+0x001e = "KEY_VOLUMEDOWN"
+0x001f = "KEY_1"
+0x0040 = "KEY_STOP"
+0x0042 = "KEY_PAUSE"
+0x0043 = "KEY_SCREEN"
+0x0044 = "KEY_FORWARD"
+0x0045 = "KEY_NEXT"
+0x0048 = "KEY_RECORD"
+0x0049 = "KEY_VIDEO"
+0x004a = "KEY_EPG"
+0x004b = "KEY_CHANNELUP"
+0x004c = "KEY_HELP"
+0x004d = "KEY_RADIO"
+0x004f = "KEY_CHANNELDOWN"
+0x0050 = "KEY_DVD"
+0x0051 = "KEY_AUDIO"
+0x0052 = "KEY_TITLE"
+0x0053 = "KEY_NEW"
+0x0057 = "KEY_MENU"
+0x005a = "KEY_PREVIOUS"
diff --git a/utils/keytable/rc_keymaps/digittrade b/utils/keytable/rc_keymaps/digittrade
deleted file mode 100644
index 73ee3dab..00000000
--- a/utils/keytable/rc_keymaps/digittrade
+++ /dev/null
@@ -1,29 +0,0 @@
-# table digittrade, type: NEC
-0x0000 KEY_9
-0x0001 KEY_EPG
-0x0002 KEY_VOLUMEDOWN
-0x0003 KEY_TEXT
-0x0004 KEY_8
-0x0005 KEY_MUTE
-0x0006 KEY_POWER2
-0x0009 KEY_ZOOM
-0x000a KEY_RECORD
-0x000d KEY_SUBTITLE
-0x000e KEY_STOP
-0x0010 KEY_OK
-0x0011 KEY_2
-0x0012 KEY_4
-0x0015 KEY_3
-0x0016 KEY_5
-0x0017 KEY_CHANNELDOWN
-0x0019 KEY_CHANNELUP
-0x001a KEY_PAUSE
-0x001b KEY_1
-0x001d KEY_AUDIO
-0x001e KEY_PLAY
-0x001f KEY_CAMERA
-0x0040 KEY_VOLUMEUP
-0x0048 KEY_7
-0x004c KEY_6
-0x004d KEY_PLAYPAUSE
-0x0054 KEY_0
diff --git a/utils/keytable/rc_keymaps/digittrade.toml b/utils/keytable/rc_keymaps/digittrade.toml
new file mode 100644
index 00000000..bb8a1901
--- /dev/null
+++ b/utils/keytable/rc_keymaps/digittrade.toml
@@ -0,0 +1,33 @@
+name = "digittrade"
+protocol = "nec"
+[nec]
+variant = "nec"
+[nec.scancodes]
+0x0000 = "KEY_9"
+0x0001 = "KEY_EPG"
+0x0002 = "KEY_VOLUMEDOWN"
+0x0003 = "KEY_TEXT"
+0x0004 = "KEY_8"
+0x0005 = "KEY_MUTE"
+0x0006 = "KEY_POWER2"
+0x0009 = "KEY_ZOOM"
+0x000a = "KEY_RECORD"
+0x000d = "KEY_SUBTITLE"
+0x000e = "KEY_STOP"
+0x0010 = "KEY_OK"
+0x0011 = "KEY_2"
+0x0012 = "KEY_4"
+0x0015 = "KEY_3"
+0x0016 = "KEY_5"
+0x0017 = "KEY_CHANNELDOWN"
+0x0019 = "KEY_CHANNELUP"
+0x001a = "KEY_PAUSE"
+0x001b = "KEY_1"
+0x001d = "KEY_AUDIO"
+0x001e = "KEY_PLAY"
+0x001f = "KEY_CAMERA"
+0x0040 = "KEY_VOLUMEUP"
+0x0048 = "KEY_7"
+0x004c = "KEY_6"
+0x004d = "KEY_PLAYPAUSE"
+0x0054 = "KEY_0"
diff --git a/utils/keytable/rc_keymaps/digitv b/utils/keytable/rc_keymaps/digitv
deleted file mode 100644
index 1ad8dda6..00000000
--- a/utils/keytable/rc_keymaps/digitv
+++ /dev/null
@@ -1,56 +0,0 @@
-# table digitv, type: UNKNOWN
-0x5f55 KEY_0
-0x6f55 KEY_1
-0x9f55 KEY_2
-0xaf55 KEY_3
-0x5f56 KEY_4
-0x6f56 KEY_5
-0x9f56 KEY_6
-0xaf56 KEY_7
-0x5f59 KEY_8
-0x6f59 KEY_9
-0x9f59 KEY_TV
-0xaf59 KEY_AUX
-0x5f5a KEY_DVD
-0x6f5a KEY_POWER
-0x9f5a KEY_CAMERA
-0xaf5a KEY_AUDIO
-0x5f65 KEY_INFO
-0x6f65 KEY_F13
-0x9f65 KEY_F14
-0xaf65 KEY_EPG
-0x5f66 KEY_EXIT
-0x6f66 KEY_MENU
-0x9f66 KEY_UP
-0xaf66 KEY_DOWN
-0x5f69 KEY_LEFT
-0x6f69 KEY_RIGHT
-0x9f69 KEY_ENTER
-0xaf69 KEY_CHANNELUP
-0x5f6a KEY_CHANNELDOWN
-0x6f6a KEY_VOLUMEUP
-0x9f6a KEY_VOLUMEDOWN
-0xaf6a KEY_RED
-0x5f95 KEY_GREEN
-0x6f95 KEY_YELLOW
-0x9f95 KEY_BLUE
-0xaf95 KEY_SUBTITLE
-0x5f96 KEY_F15
-0x6f96 KEY_TEXT
-0x9f96 KEY_MUTE
-0xaf96 KEY_REWIND
-0x5f99 KEY_STOP
-0x6f99 KEY_PLAY
-0x9f99 KEY_FASTFORWARD
-0xaf99 KEY_F16
-0x5f9a KEY_PAUSE
-0x6f9a KEY_PLAY
-0x9f9a KEY_RECORD
-0xaf9a KEY_F17
-0x5fa5 KEY_KPPLUS
-0x6fa5 KEY_KPMINUS
-0x9fa5 KEY_F18
-0xafa5 KEY_F19
-0x5fa6 KEY_EMAIL
-0x6fa6 KEY_PHONE
-0x9fa6 KEY_PC
diff --git a/utils/keytable/rc_keymaps/digitv.toml b/utils/keytable/rc_keymaps/digitv.toml
new file mode 100644
index 00000000..5f05bdf3
--- /dev/null
+++ b/utils/keytable/rc_keymaps/digitv.toml
@@ -0,0 +1,58 @@
+name = "digitv"
+protocol = "unknown"
+[unknown.scancodes]
+0x5f55 = "KEY_0"
+0x6f55 = "KEY_1"
+0x9f55 = "KEY_2"
+0xaf55 = "KEY_3"
+0x5f56 = "KEY_4"
+0x6f56 = "KEY_5"
+0x9f56 = "KEY_6"
+0xaf56 = "KEY_7"
+0x5f59 = "KEY_8"
+0x6f59 = "KEY_9"
+0x9f59 = "KEY_TV"
+0xaf59 = "KEY_AUX"
+0x5f5a = "KEY_DVD"
+0x6f5a = "KEY_POWER"
+0x9f5a = "KEY_CAMERA"
+0xaf5a = "KEY_AUDIO"
+0x5f65 = "KEY_INFO"
+0x6f65 = "KEY_F13"
+0x9f65 = "KEY_F14"
+0xaf65 = "KEY_EPG"
+0x5f66 = "KEY_EXIT"
+0x6f66 = "KEY_MENU"
+0x9f66 = "KEY_UP"
+0xaf66 = "KEY_DOWN"
+0x5f69 = "KEY_LEFT"
+0x6f69 = "KEY_RIGHT"
+0x9f69 = "KEY_ENTER"
+0xaf69 = "KEY_CHANNELUP"
+0x5f6a = "KEY_CHANNELDOWN"
+0x6f6a = "KEY_VOLUMEUP"
+0x9f6a = "KEY_VOLUMEDOWN"
+0xaf6a = "KEY_RED"
+0x5f95 = "KEY_GREEN"
+0x6f95 = "KEY_YELLOW"
+0x9f95 = "KEY_BLUE"
+0xaf95 = "KEY_SUBTITLE"
+0x5f96 = "KEY_F15"
+0x6f96 = "KEY_TEXT"
+0x9f96 = "KEY_MUTE"
+0xaf96 = "KEY_REWIND"
+0x5f99 = "KEY_STOP"
+0x6f99 = "KEY_PLAY"
+0x9f99 = "KEY_FASTFORWARD"
+0xaf99 = "KEY_F16"
+0x5f9a = "KEY_PAUSE"
+0x6f9a = "KEY_PLAY"
+0x9f9a = "KEY_RECORD"
+0xaf9a = "KEY_F17"
+0x5fa5 = "KEY_KPPLUS"
+0x6fa5 = "KEY_KPMINUS"
+0x9fa5 = "KEY_F18"
+0xafa5 = "KEY_F19"
+0x5fa6 = "KEY_EMAIL"
+0x6fa6 = "KEY_PHONE"
+0x9fa6 = "KEY_PC"
diff --git a/utils/keytable/rc_keymaps/dm1105_nec b/utils/keytable/rc_keymaps/dm1105_nec
deleted file mode 100644
index d7e26b1a..00000000
--- a/utils/keytable/rc_keymaps/dm1105_nec
+++ /dev/null
@@ -1,32 +0,0 @@
-# table dm1105_nec, type: UNKNOWN
-0x0a KEY_POWER2
-0x0c KEY_MUTE
-0x11 KEY_1
-0x12 KEY_2
-0x13 KEY_3
-0x14 KEY_4
-0x15 KEY_5
-0x16 KEY_6
-0x17 KEY_7
-0x18 KEY_8
-0x19 KEY_9
-0x10 KEY_0
-0x1c KEY_CHANNELUP
-0x0f KEY_CHANNELDOWN
-0x1a KEY_VOLUMEUP
-0x0e KEY_VOLUMEDOWN
-0x04 KEY_RECORD
-0x09 KEY_CHANNEL
-0x08 KEY_BACKSPACE
-0x07 KEY_FASTFORWARD
-0x0b KEY_PAUSE
-0x02 KEY_ESC
-0x03 KEY_TAB
-0x00 KEY_UP
-0x1f KEY_ENTER
-0x01 KEY_DOWN
-0x05 KEY_RECORD
-0x06 KEY_STOP
-0x40 KEY_ZOOM
-0x1e KEY_TV
-0x1b KEY_B
diff --git a/utils/keytable/rc_keymaps/dm1105_nec.toml b/utils/keytable/rc_keymaps/dm1105_nec.toml
new file mode 100644
index 00000000..e1c35bce
--- /dev/null
+++ b/utils/keytable/rc_keymaps/dm1105_nec.toml
@@ -0,0 +1,34 @@
+name = "dm1105_nec"
+protocol = "unknown"
+[unknown.scancodes]
+0x0a = "KEY_POWER2"
+0x0c = "KEY_MUTE"
+0x11 = "KEY_1"
+0x12 = "KEY_2"
+0x13 = "KEY_3"
+0x14 = "KEY_4"
+0x15 = "KEY_5"
+0x16 = "KEY_6"
+0x17 = "KEY_7"
+0x18 = "KEY_8"
+0x19 = "KEY_9"
+0x10 = "KEY_0"
+0x1c = "KEY_CHANNELUP"
+0x0f = "KEY_CHANNELDOWN"
+0x1a = "KEY_VOLUMEUP"
+0x0e = "KEY_VOLUMEDOWN"
+0x04 = "KEY_RECORD"
+0x09 = "KEY_CHANNEL"
+0x08 = "KEY_BACKSPACE"
+0x07 = "KEY_FASTFORWARD"
+0x0b = "KEY_PAUSE"
+0x02 = "KEY_ESC"
+0x03 = "KEY_TAB"
+0x00 = "KEY_UP"
+0x1f = "KEY_ENTER"
+0x01 = "KEY_DOWN"
+0x05 = "KEY_RECORD"
+0x06 = "KEY_STOP"
+0x40 = "KEY_ZOOM"
+0x1e = "KEY_TV"
+0x1b = "KEY_B"
diff --git a/utils/keytable/rc_keymaps/dntv_live_dvb_t b/utils/keytable/rc_keymaps/dntv_live_dvb_t
deleted file mode 100644
index 7020acb9..00000000
--- a/utils/keytable/rc_keymaps/dntv_live_dvb_t
+++ /dev/null
@@ -1,33 +0,0 @@
-# table dntv_live_dvb_t, type: UNKNOWN
-0x00 KEY_ESC
-0x0a KEY_0
-0x01 KEY_1
-0x02 KEY_2
-0x03 KEY_3
-0x04 KEY_4
-0x05 KEY_5
-0x06 KEY_6
-0x07 KEY_7
-0x08 KEY_8
-0x09 KEY_9
-0x0b KEY_TUNER
-0x0c KEY_SEARCH
-0x0d KEY_STOP
-0x0e KEY_PAUSE
-0x0f KEY_VIDEO
-0x10 KEY_MUTE
-0x11 KEY_REWIND
-0x12 KEY_POWER
-0x13 KEY_CAMERA
-0x14 KEY_AUDIO
-0x15 KEY_CLEAR
-0x16 KEY_PLAY
-0x17 KEY_ENTER
-0x18 KEY_ZOOM
-0x19 KEY_FASTFORWARD
-0x1a KEY_CHANNELUP
-0x1b KEY_VOLUMEUP
-0x1c KEY_INFO
-0x1d KEY_RECORD
-0x1e KEY_CHANNELDOWN
-0x1f KEY_VOLUMEDOWN
diff --git a/utils/keytable/rc_keymaps/dntv_live_dvb_t.toml b/utils/keytable/rc_keymaps/dntv_live_dvb_t.toml
new file mode 100644
index 00000000..b604892c
--- /dev/null
+++ b/utils/keytable/rc_keymaps/dntv_live_dvb_t.toml
@@ -0,0 +1,35 @@
+name = "dntv_live_dvb_t"
+protocol = "unknown"
+[unknown.scancodes]
+0x00 = "KEY_ESC"
+0x0a = "KEY_0"
+0x01 = "KEY_1"
+0x02 = "KEY_2"
+0x03 = "KEY_3"
+0x04 = "KEY_4"
+0x05 = "KEY_5"
+0x06 = "KEY_6"
+0x07 = "KEY_7"
+0x08 = "KEY_8"
+0x09 = "KEY_9"
+0x0b = "KEY_TUNER"
+0x0c = "KEY_SEARCH"
+0x0d = "KEY_STOP"
+0x0e = "KEY_PAUSE"
+0x0f = "KEY_VIDEO"
+0x10 = "KEY_MUTE"
+0x11 = "KEY_REWIND"
+0x12 = "KEY_POWER"
+0x13 = "KEY_CAMERA"
+0x14 = "KEY_AUDIO"
+0x15 = "KEY_CLEAR"
+0x16 = "KEY_PLAY"
+0x17 = "KEY_ENTER"
+0x18 = "KEY_ZOOM"
+0x19 = "KEY_FASTFORWARD"
+0x1a = "KEY_CHANNELUP"
+0x1b = "KEY_VOLUMEUP"
+0x1c = "KEY_INFO"
+0x1d = "KEY_RECORD"
+0x1e = "KEY_CHANNELDOWN"
+0x1f = "KEY_VOLUMEDOWN"
diff --git a/utils/keytable/rc_keymaps/dntv_live_dvbt_pro b/utils/keytable/rc_keymaps/dntv_live_dvbt_pro
deleted file mode 100644
index 442f4bc0..00000000
--- a/utils/keytable/rc_keymaps/dntv_live_dvbt_pro
+++ /dev/null
@@ -1,54 +0,0 @@
-# table dntv_live_dvbt_pro, type: UNKNOWN
-0x16 KEY_POWER
-0x5b KEY_HOME
-0x55 KEY_TV
-0x58 KEY_TUNER
-0x5a KEY_RADIO
-0x59 KEY_DVD
-0x03 KEY_1
-0x01 KEY_2
-0x06 KEY_3
-0x09 KEY_4
-0x1d KEY_5
-0x1f KEY_6
-0x0d KEY_7
-0x19 KEY_8
-0x1b KEY_9
-0x0c KEY_CANCEL
-0x15 KEY_0
-0x4a KEY_CLEAR
-0x13 KEY_BACK
-0x00 KEY_TAB
-0x4b KEY_UP
-0x4e KEY_LEFT
-0x4f KEY_OK
-0x52 KEY_RIGHT
-0x51 KEY_DOWN
-0x1e KEY_VOLUMEUP
-0x0a KEY_VOLUMEDOWN
-0x02 KEY_CHANNELDOWN
-0x05 KEY_CHANNELUP
-0x11 KEY_RECORD
-0x14 KEY_PLAY
-0x4c KEY_PAUSE
-0x1a KEY_STOP
-0x40 KEY_REWIND
-0x12 KEY_FASTFORWARD
-0x41 KEY_PREVIOUSSONG
-0x42 KEY_NEXTSONG
-0x54 KEY_CAMERA
-0x50 KEY_LANGUAGE
-0x47 KEY_TV2
-0x4d KEY_SCREEN
-0x43 KEY_SUBTITLE
-0x10 KEY_MUTE
-0x49 KEY_AUDIO
-0x07 KEY_SLEEP
-0x08 KEY_VIDEO
-0x0e KEY_PREVIOUS
-0x45 KEY_ZOOM
-0x46 KEY_ANGLE
-0x56 KEY_RED
-0x57 KEY_GREEN
-0x5c KEY_YELLOW
-0x5d KEY_BLUE
diff --git a/utils/keytable/rc_keymaps/dntv_live_dvbt_pro.toml b/utils/keytable/rc_keymaps/dntv_live_dvbt_pro.toml
new file mode 100644
index 00000000..28c49212
--- /dev/null
+++ b/utils/keytable/rc_keymaps/dntv_live_dvbt_pro.toml
@@ -0,0 +1,56 @@
+name = "dntv_live_dvbt_pro"
+protocol = "unknown"
+[unknown.scancodes]
+0x16 = "KEY_POWER"
+0x5b = "KEY_HOME"
+0x55 = "KEY_TV"
+0x58 = "KEY_TUNER"
+0x5a = "KEY_RADIO"
+0x59 = "KEY_DVD"
+0x03 = "KEY_1"
+0x01 = "KEY_2"
+0x06 = "KEY_3"
+0x09 = "KEY_4"
+0x1d = "KEY_5"
+0x1f = "KEY_6"
+0x0d = "KEY_7"
+0x19 = "KEY_8"
+0x1b = "KEY_9"
+0x0c = "KEY_CANCEL"
+0x15 = "KEY_0"
+0x4a = "KEY_CLEAR"
+0x13 = "KEY_BACK"
+0x00 = "KEY_TAB"
+0x4b = "KEY_UP"
+0x4e = "KEY_LEFT"
+0x4f = "KEY_OK"
+0x52 = "KEY_RIGHT"
+0x51 = "KEY_DOWN"
+0x1e = "KEY_VOLUMEUP"
+0x0a = "KEY_VOLUMEDOWN"
+0x02 = "KEY_CHANNELDOWN"
+0x05 = "KEY_CHANNELUP"
+0x11 = "KEY_RECORD"
+0x14 = "KEY_PLAY"
+0x4c = "KEY_PAUSE"
+0x1a = "KEY_STOP"
+0x40 = "KEY_REWIND"
+0x12 = "KEY_FASTFORWARD"
+0x41 = "KEY_PREVIOUSSONG"
+0x42 = "KEY_NEXTSONG"
+0x54 = "KEY_CAMERA"
+0x50 = "KEY_LANGUAGE"
+0x47 = "KEY_TV2"
+0x4d = "KEY_SCREEN"
+0x43 = "KEY_SUBTITLE"
+0x10 = "KEY_MUTE"
+0x49 = "KEY_AUDIO"
+0x07 = "KEY_SLEEP"
+0x08 = "KEY_VIDEO"
+0x0e = "KEY_PREVIOUS"
+0x45 = "KEY_ZOOM"
+0x46 = "KEY_ANGLE"
+0x56 = "KEY_RED"
+0x57 = "KEY_GREEN"
+0x5c = "KEY_YELLOW"
+0x5d = "KEY_BLUE"
diff --git a/utils/keytable/rc_keymaps/dtt200u b/utils/keytable/rc_keymaps/dtt200u
deleted file mode 100644
index cc4a1fc0..00000000
--- a/utils/keytable/rc_keymaps/dtt200u
+++ /dev/null
@@ -1,19 +0,0 @@
-# table dtt200u, type: NEC
-0x8001 KEY_MUTE
-0x8002 KEY_CHANNELDOWN
-0x8003 KEY_VOLUMEDOWN
-0x8004 KEY_1
-0x8005 KEY_2
-0x8006 KEY_3
-0x8007 KEY_4
-0x8008 KEY_5
-0x8009 KEY_6
-0x800a KEY_7
-0x800c KEY_ZOOM
-0x800d KEY_0
-0x800e KEY_SELECT
-0x8012 KEY_POWER
-0x801a KEY_CHANNELUP
-0x801b KEY_8
-0x801e KEY_VOLUMEUP
-0x801f KEY_9
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
index 00000000..baa2618e
--- /dev/null
+++ b/utils/keytable/rc_keymaps_userspace/wobo_i5.toml
@@ -0,0 +1,11 @@
+name = "wobo_i5"
+protocol = "nec"
+[nec.scancodes]
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
