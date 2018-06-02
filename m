Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:42597 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750740AbeFBOPS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Jun 2018 10:15:18 -0400
Date: Sat, 2 Jun 2018 15:15:16 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Subject: Re: [RFC PATCH v1 0/4] Add BPF decoders to ir-keytable
Message-ID: <20180602141516.issu2eoheetik2xy@gofer.mess.org>
References: <cover.1527941987.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1527941987.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 02, 2018 at 01:37:54PM +0100, Sean Young wrote:
> This is not ready for merging yet, however while I finish this work I would
> like some feedback and ideas.
> 
> The idea is that IR decoders can be written in C, compiled to BPF relocatable
> object file. Any global variables can overriden, so we can supports lots
> of variants of similiar protocols (just like in the lircd.conf file).
> 
> The existing rc_keymap file format can't be used for variables, so I've
> converted the format to toml. An alternative would be to use the existing
> lircd.conf file format, but it's a very awkward file to parse in C and it
> contains many features which are irrelevant to us.
> 
> We use libelf to load the bpf relocatable object file.
> 
> After loading our example grundig keymap with bpf decoder, the output of
> ir-keytable is:
> 
> Found /sys/class/rc/rc0/ (/dev/input/event8) with:
> 	Name: Winbond CIR
> 	Driver: winbond-cir, table: rc-rc6-mce
> 	lirc device: /dev/lirc0
> 	Attached bpf protocols: grundig
> 	Supported protocols: lirc rc-5 rc-5-sz jvc sony nec sanyo mce_kbd rc-6 sharp xmp imon 
> 	Enabled protocols: lirc
> 	bus: 25, vendor/product: 10ad:00f1, version: 0x0004
> 	Repeat delay = 500 ms, repeat period = 125 ms
> 
> 
> Steps to complete this work:
>  - Write more IR decoders
>  - More rc_keymaps
>  - More testing
>  - lircd.conf to toml converter script (python/perl?)
> 
> Sean Young (4):
>   keytable: add toml keymap reader
>   keytable: convert keymaps to new toml format

This commit has not made it to the list yet, I guess because it is so large.

Here it is:

https://git.linuxtv.org/syoung/v4l-utils.git/commit/?id=8e0522c73d832f086958e6cd7774a3e37bbab6bf


>   keytable: add support for BPF based decoders
>   keytable: add bpf protocols
> 
>  Makefile.am                                   |    4 +-
>  configure.ac                                  |   16 +
>  include/linux/bpf.h                           | 2644 +++++++++++++++++
>  utils/keytable/Makefile.am                    |   13 +-
>  utils/keytable/bpf.c                          |  515 ++++
>  utils/keytable/bpf.h                          |  110 +
>  utils/keytable/bpf_load.c                     |  457 +++
>  utils/keytable/bpf_load.h                     |   41 +
>  utils/keytable/bpf_protocols/Makefile.am      |   14 +
>  utils/keytable/bpf_protocols/bpf_helpers.h    |  302 ++
>  utils/keytable/bpf_protocols/grundig.c        |  113 +
>  utils/keytable/gen_keytables.pl               |   33 +-
>  utils/keytable/ir-keytable.1.in               |    4 +-
>  utils/keytable/keytable.c                     |  370 ++-
>  utils/keytable/rc_keymaps/adstech_dvb_t_pci   |   45 -
>  .../rc_keymaps/adstech_dvb_t_pci.toml         |   47 +
>  utils/keytable/rc_keymaps/af9005              |   37 -
>  utils/keytable/rc_keymaps/af9005.toml         |   39 +
>  utils/keytable/rc_keymaps/alink_dtu_m         |   19 -
>  utils/keytable/rc_keymaps/alink_dtu_m.toml    |   23 +
>  .../keytable/rc_keymaps/allwinner_ba10_tv_box |   15 -
>  .../rc_keymaps/allwinner_i12_a20_tv_box       |   28 -
>  utils/keytable/rc_keymaps/anysee              |   45 -
>  utils/keytable/rc_keymaps/anysee.toml         |   49 +
>  utils/keytable/rc_keymaps/apac_viewcomp       |   32 -
>  utils/keytable/rc_keymaps/apac_viewcomp.toml  |   34 +
>  utils/keytable/rc_keymaps/astrometa_t2hybrid  |   22 -
>  .../rc_keymaps/astrometa_t2hybrid.toml        |   26 +
>  utils/keytable/rc_keymaps/asus_pc39           |   40 -
>  utils/keytable/rc_keymaps/asus_pc39.toml      |   44 +
>  utils/keytable/rc_keymaps/asus_ps3_100        |   42 -
>  utils/keytable/rc_keymaps/asus_ps3_100.toml   |   46 +
>  .../keytable/rc_keymaps/ati_tv_wonder_hd_600  |   25 -
>  .../rc_keymaps/ati_tv_wonder_hd_600.toml      |   27 +
>  utils/keytable/rc_keymaps/ati_x10             |   49 -
>  utils/keytable/rc_keymaps/ati_x10.toml        |   51 +
>  utils/keytable/rc_keymaps/avermedia           |   37 -
>  utils/keytable/rc_keymaps/avermedia.toml      |   39 +
>  utils/keytable/rc_keymaps/avermedia_a16d      |   35 -
>  utils/keytable/rc_keymaps/avermedia_a16d.toml |   37 +
>  utils/keytable/rc_keymaps/avermedia_cardbus   |   55 -
>  .../rc_keymaps/avermedia_cardbus.toml         |   57 +
>  utils/keytable/rc_keymaps/avermedia_dvbt      |   35 -
>  utils/keytable/rc_keymaps/avermedia_dvbt.toml |   37 +
>  utils/keytable/rc_keymaps/avermedia_m135a     |   81 -
>  .../keytable/rc_keymaps/avermedia_m135a.toml  |   85 +
>  .../keytable/rc_keymaps/avermedia_m733a_rm_k6 |   45 -
>  .../rc_keymaps/avermedia_m733a_rm_k6.toml     |   49 +
>  utils/keytable/rc_keymaps/avermedia_rm_ks     |   28 -
>  .../keytable/rc_keymaps/avermedia_rm_ks.toml  |   32 +
>  utils/keytable/rc_keymaps/avertv_303          |   37 -
>  utils/keytable/rc_keymaps/avertv_303.toml     |   39 +
>  utils/keytable/rc_keymaps/az6027              |    3 -
>  utils/keytable/rc_keymaps/az6027.toml         |    5 +
>  utils/keytable/rc_keymaps/azurewave_ad_tu700  |   54 -
>  .../rc_keymaps/azurewave_ad_tu700.toml        |   58 +
>  utils/keytable/rc_keymaps/behold              |   35 -
>  utils/keytable/rc_keymaps/behold.toml         |   39 +
>  utils/keytable/rc_keymaps/behold_columbus     |   29 -
>  .../keytable/rc_keymaps/behold_columbus.toml  |   31 +
>  utils/keytable/rc_keymaps/budget_ci_old       |   46 -
>  utils/keytable/rc_keymaps/budget_ci_old.toml  |   48 +
>  utils/keytable/rc_keymaps/cec                 |   98 -
>  utils/keytable/rc_keymaps/cec.toml            |  100 +
>  utils/keytable/rc_keymaps/cinergy             |   37 -
>  utils/keytable/rc_keymaps/cinergy.toml        |   39 +
>  utils/keytable/rc_keymaps/cinergy_1400        |   38 -
>  utils/keytable/rc_keymaps/cinergy_1400.toml   |   40 +
>  utils/keytable/rc_keymaps/cinergyt2           |   38 -
>  utils/keytable/rc_keymaps/cinergyt2.toml      |   40 +
>  utils/keytable/rc_keymaps/d680_dmb            |   36 -
>  utils/keytable/rc_keymaps/d680_dmb.toml       |   38 +
>  utils/keytable/rc_keymaps/delock_61959        |   33 -
>  utils/keytable/rc_keymaps/delock_61959.toml   |   37 +
>  utils/keytable/rc_keymaps/dib0700_nec         |   71 -
>  utils/keytable/rc_keymaps/dib0700_nec.toml    |   75 +
>  utils/keytable/rc_keymaps/dib0700_rc5         |  181 --
>  utils/keytable/rc_keymaps/dib0700_rc5.toml    |  185 ++
>  utils/keytable/rc_keymaps/dibusb              |  112 -
>  utils/keytable/rc_keymaps/dibusb.toml         |  114 +
>  utils/keytable/rc_keymaps/digitalnow_tinytwin |   50 -
>  .../rc_keymaps/digitalnow_tinytwin.toml       |   54 +
>  utils/keytable/rc_keymaps/digittrade          |   29 -
>  utils/keytable/rc_keymaps/digittrade.toml     |   33 +
>  utils/keytable/rc_keymaps/digitv              |   56 -
>  utils/keytable/rc_keymaps/digitv.toml         |   58 +
>  utils/keytable/rc_keymaps/dm1105_nec          |   32 -
>  utils/keytable/rc_keymaps/dm1105_nec.toml     |   34 +
>  utils/keytable/rc_keymaps/dntv_live_dvb_t     |   33 -
>  .../keytable/rc_keymaps/dntv_live_dvb_t.toml  |   35 +
>  utils/keytable/rc_keymaps/dntv_live_dvbt_pro  |   54 -
>  .../rc_keymaps/dntv_live_dvbt_pro.toml        |   56 +
>  utils/keytable/rc_keymaps/dtt200u             |   19 -
>  utils/keytable/rc_keymaps/dtt200u.toml        |   23 +
>  utils/keytable/rc_keymaps/dvbsky              |   33 -
>  utils/keytable/rc_keymaps/dvbsky.toml         |   37 +
>  utils/keytable/rc_keymaps/dvico_mce           |   46 -
>  utils/keytable/rc_keymaps/dvico_mce.toml      |   50 +
>  utils/keytable/rc_keymaps/dvico_portable      |   37 -
>  utils/keytable/rc_keymaps/dvico_portable.toml |   41 +
>  utils/keytable/rc_keymaps/em_terratec         |   29 -
>  utils/keytable/rc_keymaps/em_terratec.toml    |   31 +
>  utils/keytable/rc_keymaps/encore_enltv        |   53 -
>  utils/keytable/rc_keymaps/encore_enltv.toml   |   55 +
>  utils/keytable/rc_keymaps/encore_enltv2       |   40 -
>  utils/keytable/rc_keymaps/encore_enltv2.toml  |   42 +
>  utils/keytable/rc_keymaps/encore_enltv_fm53   |   30 -
>  .../rc_keymaps/encore_enltv_fm53.toml         |   32 +
>  utils/keytable/rc_keymaps/evga_indtube        |   17 -
>  utils/keytable/rc_keymaps/evga_indtube.toml   |   19 +
>  utils/keytable/rc_keymaps/eztv                |   45 -
>  utils/keytable/rc_keymaps/eztv.toml           |   47 +
>  utils/keytable/rc_keymaps/flydvb              |   33 -
>  utils/keytable/rc_keymaps/flydvb.toml         |   35 +
>  utils/keytable/rc_keymaps/flyvideo            |   28 -
>  utils/keytable/rc_keymaps/flyvideo.toml       |   30 +
>  utils/keytable/rc_keymaps/fusionhdtv_mce      |   46 -
>  utils/keytable/rc_keymaps/fusionhdtv_mce.toml |   48 +
>  utils/keytable/rc_keymaps/gadmei_rm008z       |   32 -
>  utils/keytable/rc_keymaps/gadmei_rm008z.toml  |   34 +
>  utils/keytable/rc_keymaps/geekbox             |   13 -
>  utils/keytable/rc_keymaps/geekbox.toml        |   17 +
>  utils/keytable/rc_keymaps/genius_tvgo_a11mce  |   33 -
>  .../rc_keymaps/genius_tvgo_a11mce.toml        |   35 +
>  utils/keytable/rc_keymaps/gotview7135         |   35 -
>  utils/keytable/rc_keymaps/gotview7135.toml    |   37 +
>  utils/keytable/rc_keymaps/haupp               |   46 -
>  utils/keytable/rc_keymaps/haupp.toml          |   48 +
>  utils/keytable/rc_keymaps/hauppauge           |  173 --
>  utils/keytable/rc_keymaps/hauppauge.toml      |  177 ++
>  utils/keytable/rc_keymaps/hisi_poplar         |   30 -
>  utils/keytable/rc_keymaps/hisi_poplar.toml    |   34 +
>  utils/keytable/rc_keymaps/hisi_tv_demo        |   42 -
>  utils/keytable/rc_keymaps/hisi_tv_demo.toml   |   46 +
>  utils/keytable/rc_keymaps/imon_mce            |   78 -
>  utils/keytable/rc_keymaps/imon_mce.toml       |   82 +
>  utils/keytable/rc_keymaps/imon_pad            |   91 -
>  utils/keytable/rc_keymaps/imon_pad.toml       |   93 +
>  utils/keytable/rc_keymaps/imon_rsc            |   44 -
>  utils/keytable/rc_keymaps/imon_rsc.toml       |   48 +
>  utils/keytable/rc_keymaps/iodata_bctv7e       |   37 -
>  utils/keytable/rc_keymaps/iodata_bctv7e.toml  |   39 +
>  utils/keytable/rc_keymaps/it913x_v1           |   53 -
>  utils/keytable/rc_keymaps/it913x_v1.toml      |   57 +
>  utils/keytable/rc_keymaps/it913x_v2           |   48 -
>  utils/keytable/rc_keymaps/it913x_v2.toml      |   52 +
>  utils/keytable/rc_keymaps/kaiomy              |   33 -
>  utils/keytable/rc_keymaps/kaiomy.toml         |   35 +
>  utils/keytable/rc_keymaps/kworld_315u         |   33 -
>  utils/keytable/rc_keymaps/kworld_315u.toml    |   37 +
>  utils/keytable/rc_keymaps/kworld_pc150u       |   45 -
>  utils/keytable/rc_keymaps/kworld_pc150u.toml  |   47 +
>  .../keytable/rc_keymaps/kworld_plus_tv_analog |   32 -
>  .../rc_keymaps/kworld_plus_tv_analog.toml     |   34 +
>  utils/keytable/rc_keymaps/leadtek_y04g0051    |   51 -
>  .../keytable/rc_keymaps/leadtek_y04g0051.toml |   55 +
>  utils/keytable/rc_keymaps/lme2510             |   67 -
>  utils/keytable/rc_keymaps/lme2510.toml        |   71 +
>  utils/keytable/rc_keymaps/manli               |   32 -
>  utils/keytable/rc_keymaps/manli.toml          |   34 +
>  utils/keytable/rc_keymaps/medion_x10          |   54 -
>  utils/keytable/rc_keymaps/medion_x10.toml     |   56 +
>  .../keytable/rc_keymaps/medion_x10_digitainer |   50 -
>  .../rc_keymaps/medion_x10_digitainer.toml     |   52 +
>  utils/keytable/rc_keymaps/medion_x10_or2x     |   46 -
>  .../keytable/rc_keymaps/medion_x10_or2x.toml  |   48 +
>  utils/keytable/rc_keymaps/megasky             |   17 -
>  utils/keytable/rc_keymaps/megasky.toml        |   19 +
>  utils/keytable/rc_keymaps/msi_digivox_ii      |   19 -
>  utils/keytable/rc_keymaps/msi_digivox_ii.toml |   23 +
>  utils/keytable/rc_keymaps/msi_digivox_iii     |   33 -
>  .../keytable/rc_keymaps/msi_digivox_iii.toml  |   37 +
>  utils/keytable/rc_keymaps/msi_tvanywhere      |   25 -
>  utils/keytable/rc_keymaps/msi_tvanywhere.toml |   27 +
>  utils/keytable/rc_keymaps/msi_tvanywhere_plus |   37 -
>  .../rc_keymaps/msi_tvanywhere_plus.toml       |   39 +
>  utils/keytable/rc_keymaps/nebula              |   56 -
>  utils/keytable/rc_keymaps/nebula.toml         |   60 +
>  .../rc_keymaps/nec_terratec_cinergy_xs        |   86 -
>  .../rc_keymaps/nec_terratec_cinergy_xs.toml   |   90 +
>  utils/keytable/rc_keymaps/norwood             |   36 -
>  utils/keytable/rc_keymaps/norwood.toml        |   38 +
>  utils/keytable/rc_keymaps/npgtech             |   36 -
>  utils/keytable/rc_keymaps/npgtech.toml        |   38 +
>  utils/keytable/rc_keymaps/opera1              |   27 -
>  utils/keytable/rc_keymaps/opera1.toml         |   29 +
>  utils/keytable/rc_keymaps/pctv_sedna          |   33 -
>  utils/keytable/rc_keymaps/pctv_sedna.toml     |   35 +
>  utils/keytable/rc_keymaps/pinnacle310e        |   54 -
>  utils/keytable/rc_keymaps/pinnacle310e.toml   |   56 +
>  utils/keytable/rc_keymaps/pinnacle_color      |   43 -
>  utils/keytable/rc_keymaps/pinnacle_color.toml |   45 +
>  utils/keytable/rc_keymaps/pinnacle_grey       |   42 -
>  utils/keytable/rc_keymaps/pinnacle_grey.toml  |   44 +
>  utils/keytable/rc_keymaps/pinnacle_pctv_hd    |   27 -
>  .../keytable/rc_keymaps/pinnacle_pctv_hd.toml |   31 +
>  utils/keytable/rc_keymaps/pixelview           |   33 -
>  utils/keytable/rc_keymaps/pixelview.toml      |   35 +
>  utils/keytable/rc_keymaps/pixelview_002t      |   27 -
>  utils/keytable/rc_keymaps/pixelview_002t.toml |   31 +
>  utils/keytable/rc_keymaps/pixelview_mk12      |   32 -
>  utils/keytable/rc_keymaps/pixelview_mk12.toml |   36 +
>  utils/keytable/rc_keymaps/pixelview_new       |   32 -
>  utils/keytable/rc_keymaps/pixelview_new.toml  |   34 +
>  .../keytable/rc_keymaps/powercolor_real_angel |   36 -
>  .../rc_keymaps/powercolor_real_angel.toml     |   38 +
>  utils/keytable/rc_keymaps/proteus_2309        |   25 -
>  utils/keytable/rc_keymaps/proteus_2309.toml   |   27 +
>  utils/keytable/rc_keymaps/purpletv            |   36 -
>  utils/keytable/rc_keymaps/purpletv.toml       |   38 +
>  utils/keytable/rc_keymaps/pv951               |   32 -
>  utils/keytable/rc_keymaps/pv951.toml          |   34 +
>  utils/keytable/rc_keymaps/rc6_mce             |   65 -
>  utils/keytable/rc_keymaps/rc6_mce.toml        |   69 +
>  .../rc_keymaps/real_audio_220_32_keys         |   29 -
>  .../rc_keymaps/real_audio_220_32_keys.toml    |   31 +
>  utils/keytable/rc_keymaps/reddo               |   24 -
>  utils/keytable/rc_keymaps/reddo.toml          |   28 +
>  utils/keytable/rc_keymaps/snapstream_firefly  |   49 -
>  .../rc_keymaps/snapstream_firefly.toml        |   51 +
>  utils/keytable/rc_keymaps/streamzap           |   36 -
>  utils/keytable/rc_keymaps/streamzap.toml      |   38 +
>  utils/keytable/rc_keymaps/su3000              |   36 -
>  utils/keytable/rc_keymaps/su3000.toml         |   40 +
>  utils/keytable/rc_keymaps/tango               |   51 -
>  utils/keytable/rc_keymaps/tango.toml          |   55 +
>  utils/keytable/rc_keymaps/tbs_nec             |   35 -
>  utils/keytable/rc_keymaps/tbs_nec.toml        |   37 +
>  utils/keytable/rc_keymaps/technisat_ts35      |   34 -
>  utils/keytable/rc_keymaps/technisat_ts35.toml |   36 +
>  utils/keytable/rc_keymaps/technisat_usb2      |   34 -
>  utils/keytable/rc_keymaps/technisat_usb2.toml |   38 +
>  .../rc_keymaps/terratec_cinergy_c_pci         |   49 -
>  .../rc_keymaps/terratec_cinergy_c_pci.toml    |   51 +
>  .../rc_keymaps/terratec_cinergy_s2_hd         |   49 -
>  .../rc_keymaps/terratec_cinergy_s2_hd.toml    |   51 +
>  utils/keytable/rc_keymaps/terratec_cinergy_xs |   48 -
>  .../rc_keymaps/terratec_cinergy_xs.toml       |   50 +
>  utils/keytable/rc_keymaps/terratec_slim       |   29 -
>  utils/keytable/rc_keymaps/terratec_slim.toml  |   33 +
>  utils/keytable/rc_keymaps/terratec_slim_2     |   19 -
>  .../keytable/rc_keymaps/terratec_slim_2.toml  |   23 +
>  utils/keytable/rc_keymaps/tevii_nec           |   48 -
>  utils/keytable/rc_keymaps/tevii_nec.toml      |   50 +
>  utils/keytable/rc_keymaps/tivo                |   46 -
>  utils/keytable/rc_keymaps/tivo.toml           |   48 +
>  utils/keytable/rc_keymaps/total_media_in_hand |   36 -
>  .../rc_keymaps/total_media_in_hand.toml       |   40 +
>  .../rc_keymaps/total_media_in_hand_02         |   36 -
>  .../rc_keymaps/total_media_in_hand_02.toml    |   40 +
>  utils/keytable/rc_keymaps/trekstor            |   29 -
>  utils/keytable/rc_keymaps/trekstor.toml       |   33 +
>  utils/keytable/rc_keymaps/tt_1500             |   40 -
>  utils/keytable/rc_keymaps/tt_1500.toml        |   44 +
>  utils/keytable/rc_keymaps/tvwalkertwin        |   18 -
>  utils/keytable/rc_keymaps/tvwalkertwin.toml   |   20 +
>  utils/keytable/rc_keymaps/twinhan_dtv_cab_ci  |   54 -
>  .../rc_keymaps/twinhan_dtv_cab_ci.toml        |   56 +
>  utils/keytable/rc_keymaps/twinhan_vp1027_dvbs |   54 -
>  .../rc_keymaps/twinhan_vp1027_dvbs.toml       |   58 +
>  utils/keytable/rc_keymaps/videomate_k100      |   52 -
>  utils/keytable/rc_keymaps/videomate_k100.toml |   54 +
>  utils/keytable/rc_keymaps/videomate_s350      |   45 -
>  utils/keytable/rc_keymaps/videomate_s350.toml |   47 +
>  utils/keytable/rc_keymaps/videomate_tv_pvr    |   38 -
>  .../keytable/rc_keymaps/videomate_tv_pvr.toml |   40 +
>  utils/keytable/rc_keymaps/vp702x              |    3 -
>  utils/keytable/rc_keymaps/vp702x.toml         |    5 +
>  utils/keytable/rc_keymaps/winfast             |   57 -
>  utils/keytable/rc_keymaps/winfast.toml        |   59 +
>  .../keytable/rc_keymaps/winfast_usbii_deluxe  |   29 -
>  .../rc_keymaps/winfast_usbii_deluxe.toml      |   31 +
>  utils/keytable/rc_keymaps/wobo_i5             |    9 -
>  utils/keytable/rc_keymaps/zx_irdec            |   41 -
>  utils/keytable/rc_keymaps/zx_irdec.toml       |   45 +
>  utils/keytable/rc_keymaps_bpf/RP75_LCD.toml   |   45 +
>  .../allwinner_ba10_tv_box                     |   15 -
>  .../allwinner_ba10_tv_box.toml                |   17 +
>  .../allwinner_i12_a20_tv_box                  |   28 -
>  .../allwinner_i12_a20_tv_box.toml             |   30 +
>  utils/keytable/rc_keymaps_userspace/wobo_i5   |    9 -
>  .../rc_keymaps_userspace/wobo_i5.toml         |   11 +
>  utils/keytable/rc_maps.cfg                    |  268 +-
>  utils/keytable/toml.c                         | 1903 ++++++++++++
>  utils/keytable/toml.h                         |  110 +
>  v4l-utils.spec.in                             |    2 +-
>  286 files changed, 12689 insertions(+), 5725 deletions(-)
>  create mode 100644 include/linux/bpf.h
>  create mode 100644 utils/keytable/bpf.c
>  create mode 100644 utils/keytable/bpf.h
>  create mode 100644 utils/keytable/bpf_load.c
>  create mode 100644 utils/keytable/bpf_load.h
>  create mode 100644 utils/keytable/bpf_protocols/Makefile.am
>  create mode 100644 utils/keytable/bpf_protocols/bpf_helpers.h
>  create mode 100644 utils/keytable/bpf_protocols/grundig.c
>  delete mode 100644 utils/keytable/rc_keymaps/adstech_dvb_t_pci
>  create mode 100644 utils/keytable/rc_keymaps/adstech_dvb_t_pci.toml
>  delete mode 100644 utils/keytable/rc_keymaps/af9005
>  create mode 100644 utils/keytable/rc_keymaps/af9005.toml
>  delete mode 100644 utils/keytable/rc_keymaps/alink_dtu_m
>  create mode 100644 utils/keytable/rc_keymaps/alink_dtu_m.toml
>  delete mode 100644 utils/keytable/rc_keymaps/allwinner_ba10_tv_box
>  delete mode 100644 utils/keytable/rc_keymaps/allwinner_i12_a20_tv_box
>  delete mode 100644 utils/keytable/rc_keymaps/anysee
>  create mode 100644 utils/keytable/rc_keymaps/anysee.toml
>  delete mode 100644 utils/keytable/rc_keymaps/apac_viewcomp
>  create mode 100644 utils/keytable/rc_keymaps/apac_viewcomp.toml
>  delete mode 100644 utils/keytable/rc_keymaps/astrometa_t2hybrid
>  create mode 100644 utils/keytable/rc_keymaps/astrometa_t2hybrid.toml
>  delete mode 100644 utils/keytable/rc_keymaps/asus_pc39
>  create mode 100644 utils/keytable/rc_keymaps/asus_pc39.toml
>  delete mode 100644 utils/keytable/rc_keymaps/asus_ps3_100
>  create mode 100644 utils/keytable/rc_keymaps/asus_ps3_100.toml
>  delete mode 100644 utils/keytable/rc_keymaps/ati_tv_wonder_hd_600
>  create mode 100644 utils/keytable/rc_keymaps/ati_tv_wonder_hd_600.toml
>  delete mode 100644 utils/keytable/rc_keymaps/ati_x10
>  create mode 100644 utils/keytable/rc_keymaps/ati_x10.toml
>  delete mode 100644 utils/keytable/rc_keymaps/avermedia
>  create mode 100644 utils/keytable/rc_keymaps/avermedia.toml
>  delete mode 100644 utils/keytable/rc_keymaps/avermedia_a16d
>  create mode 100644 utils/keytable/rc_keymaps/avermedia_a16d.toml
>  delete mode 100644 utils/keytable/rc_keymaps/avermedia_cardbus
>  create mode 100644 utils/keytable/rc_keymaps/avermedia_cardbus.toml
>  delete mode 100644 utils/keytable/rc_keymaps/avermedia_dvbt
>  create mode 100644 utils/keytable/rc_keymaps/avermedia_dvbt.toml
>  delete mode 100644 utils/keytable/rc_keymaps/avermedia_m135a
>  create mode 100644 utils/keytable/rc_keymaps/avermedia_m135a.toml
>  delete mode 100644 utils/keytable/rc_keymaps/avermedia_m733a_rm_k6
>  create mode 100644 utils/keytable/rc_keymaps/avermedia_m733a_rm_k6.toml
>  delete mode 100644 utils/keytable/rc_keymaps/avermedia_rm_ks
>  create mode 100644 utils/keytable/rc_keymaps/avermedia_rm_ks.toml
>  delete mode 100644 utils/keytable/rc_keymaps/avertv_303
>  create mode 100644 utils/keytable/rc_keymaps/avertv_303.toml
>  delete mode 100644 utils/keytable/rc_keymaps/az6027
>  create mode 100644 utils/keytable/rc_keymaps/az6027.toml
>  delete mode 100644 utils/keytable/rc_keymaps/azurewave_ad_tu700
>  create mode 100644 utils/keytable/rc_keymaps/azurewave_ad_tu700.toml
>  delete mode 100644 utils/keytable/rc_keymaps/behold
>  create mode 100644 utils/keytable/rc_keymaps/behold.toml
>  delete mode 100644 utils/keytable/rc_keymaps/behold_columbus
>  create mode 100644 utils/keytable/rc_keymaps/behold_columbus.toml
>  delete mode 100644 utils/keytable/rc_keymaps/budget_ci_old
>  create mode 100644 utils/keytable/rc_keymaps/budget_ci_old.toml
>  delete mode 100644 utils/keytable/rc_keymaps/cec
>  create mode 100644 utils/keytable/rc_keymaps/cec.toml
>  delete mode 100644 utils/keytable/rc_keymaps/cinergy
>  create mode 100644 utils/keytable/rc_keymaps/cinergy.toml
>  delete mode 100644 utils/keytable/rc_keymaps/cinergy_1400
>  create mode 100644 utils/keytable/rc_keymaps/cinergy_1400.toml
>  delete mode 100644 utils/keytable/rc_keymaps/cinergyt2
>  create mode 100644 utils/keytable/rc_keymaps/cinergyt2.toml
>  delete mode 100644 utils/keytable/rc_keymaps/d680_dmb
>  create mode 100644 utils/keytable/rc_keymaps/d680_dmb.toml
>  delete mode 100644 utils/keytable/rc_keymaps/delock_61959
>  create mode 100644 utils/keytable/rc_keymaps/delock_61959.toml
>  delete mode 100644 utils/keytable/rc_keymaps/dib0700_nec
>  create mode 100644 utils/keytable/rc_keymaps/dib0700_nec.toml
>  delete mode 100644 utils/keytable/rc_keymaps/dib0700_rc5
>  create mode 100644 utils/keytable/rc_keymaps/dib0700_rc5.toml
>  delete mode 100644 utils/keytable/rc_keymaps/dibusb
>  create mode 100644 utils/keytable/rc_keymaps/dibusb.toml
>  delete mode 100644 utils/keytable/rc_keymaps/digitalnow_tinytwin
>  create mode 100644 utils/keytable/rc_keymaps/digitalnow_tinytwin.toml
>  delete mode 100644 utils/keytable/rc_keymaps/digittrade
>  create mode 100644 utils/keytable/rc_keymaps/digittrade.toml
>  delete mode 100644 utils/keytable/rc_keymaps/digitv
>  create mode 100644 utils/keytable/rc_keymaps/digitv.toml
>  delete mode 100644 utils/keytable/rc_keymaps/dm1105_nec
>  create mode 100644 utils/keytable/rc_keymaps/dm1105_nec.toml
>  delete mode 100644 utils/keytable/rc_keymaps/dntv_live_dvb_t
>  create mode 100644 utils/keytable/rc_keymaps/dntv_live_dvb_t.toml
>  delete mode 100644 utils/keytable/rc_keymaps/dntv_live_dvbt_pro
>  create mode 100644 utils/keytable/rc_keymaps/dntv_live_dvbt_pro.toml
>  delete mode 100644 utils/keytable/rc_keymaps/dtt200u
>  create mode 100644 utils/keytable/rc_keymaps/dtt200u.toml
>  delete mode 100644 utils/keytable/rc_keymaps/dvbsky
>  create mode 100644 utils/keytable/rc_keymaps/dvbsky.toml
>  delete mode 100644 utils/keytable/rc_keymaps/dvico_mce
>  create mode 100644 utils/keytable/rc_keymaps/dvico_mce.toml
>  delete mode 100644 utils/keytable/rc_keymaps/dvico_portable
>  create mode 100644 utils/keytable/rc_keymaps/dvico_portable.toml
>  delete mode 100644 utils/keytable/rc_keymaps/em_terratec
>  create mode 100644 utils/keytable/rc_keymaps/em_terratec.toml
>  delete mode 100644 utils/keytable/rc_keymaps/encore_enltv
>  create mode 100644 utils/keytable/rc_keymaps/encore_enltv.toml
>  delete mode 100644 utils/keytable/rc_keymaps/encore_enltv2
>  create mode 100644 utils/keytable/rc_keymaps/encore_enltv2.toml
>  delete mode 100644 utils/keytable/rc_keymaps/encore_enltv_fm53
>  create mode 100644 utils/keytable/rc_keymaps/encore_enltv_fm53.toml
>  delete mode 100644 utils/keytable/rc_keymaps/evga_indtube
>  create mode 100644 utils/keytable/rc_keymaps/evga_indtube.toml
>  delete mode 100644 utils/keytable/rc_keymaps/eztv
>  create mode 100644 utils/keytable/rc_keymaps/eztv.toml
>  delete mode 100644 utils/keytable/rc_keymaps/flydvb
>  create mode 100644 utils/keytable/rc_keymaps/flydvb.toml
>  delete mode 100644 utils/keytable/rc_keymaps/flyvideo
>  create mode 100644 utils/keytable/rc_keymaps/flyvideo.toml
>  delete mode 100644 utils/keytable/rc_keymaps/fusionhdtv_mce
>  create mode 100644 utils/keytable/rc_keymaps/fusionhdtv_mce.toml
>  delete mode 100644 utils/keytable/rc_keymaps/gadmei_rm008z
>  create mode 100644 utils/keytable/rc_keymaps/gadmei_rm008z.toml
>  delete mode 100644 utils/keytable/rc_keymaps/geekbox
>  create mode 100644 utils/keytable/rc_keymaps/geekbox.toml
>  delete mode 100644 utils/keytable/rc_keymaps/genius_tvgo_a11mce
>  create mode 100644 utils/keytable/rc_keymaps/genius_tvgo_a11mce.toml
>  delete mode 100644 utils/keytable/rc_keymaps/gotview7135
>  create mode 100644 utils/keytable/rc_keymaps/gotview7135.toml
>  delete mode 100644 utils/keytable/rc_keymaps/haupp
>  create mode 100644 utils/keytable/rc_keymaps/haupp.toml
>  delete mode 100644 utils/keytable/rc_keymaps/hauppauge
>  create mode 100644 utils/keytable/rc_keymaps/hauppauge.toml
>  delete mode 100644 utils/keytable/rc_keymaps/hisi_poplar
>  create mode 100644 utils/keytable/rc_keymaps/hisi_poplar.toml
>  delete mode 100644 utils/keytable/rc_keymaps/hisi_tv_demo
>  create mode 100644 utils/keytable/rc_keymaps/hisi_tv_demo.toml
>  delete mode 100644 utils/keytable/rc_keymaps/imon_mce
>  create mode 100644 utils/keytable/rc_keymaps/imon_mce.toml
>  delete mode 100644 utils/keytable/rc_keymaps/imon_pad
>  create mode 100644 utils/keytable/rc_keymaps/imon_pad.toml
>  delete mode 100644 utils/keytable/rc_keymaps/imon_rsc
>  create mode 100644 utils/keytable/rc_keymaps/imon_rsc.toml
>  delete mode 100644 utils/keytable/rc_keymaps/iodata_bctv7e
>  create mode 100644 utils/keytable/rc_keymaps/iodata_bctv7e.toml
>  delete mode 100644 utils/keytable/rc_keymaps/it913x_v1
>  create mode 100644 utils/keytable/rc_keymaps/it913x_v1.toml
>  delete mode 100644 utils/keytable/rc_keymaps/it913x_v2
>  create mode 100644 utils/keytable/rc_keymaps/it913x_v2.toml
>  delete mode 100644 utils/keytable/rc_keymaps/kaiomy
>  create mode 100644 utils/keytable/rc_keymaps/kaiomy.toml
>  delete mode 100644 utils/keytable/rc_keymaps/kworld_315u
>  create mode 100644 utils/keytable/rc_keymaps/kworld_315u.toml
>  delete mode 100644 utils/keytable/rc_keymaps/kworld_pc150u
>  create mode 100644 utils/keytable/rc_keymaps/kworld_pc150u.toml
>  delete mode 100644 utils/keytable/rc_keymaps/kworld_plus_tv_analog
>  create mode 100644 utils/keytable/rc_keymaps/kworld_plus_tv_analog.toml
>  delete mode 100644 utils/keytable/rc_keymaps/leadtek_y04g0051
>  create mode 100644 utils/keytable/rc_keymaps/leadtek_y04g0051.toml
>  delete mode 100644 utils/keytable/rc_keymaps/lme2510
>  create mode 100644 utils/keytable/rc_keymaps/lme2510.toml
>  delete mode 100644 utils/keytable/rc_keymaps/manli
>  create mode 100644 utils/keytable/rc_keymaps/manli.toml
>  delete mode 100644 utils/keytable/rc_keymaps/medion_x10
>  create mode 100644 utils/keytable/rc_keymaps/medion_x10.toml
>  delete mode 100644 utils/keytable/rc_keymaps/medion_x10_digitainer
>  create mode 100644 utils/keytable/rc_keymaps/medion_x10_digitainer.toml
>  delete mode 100644 utils/keytable/rc_keymaps/medion_x10_or2x
>  create mode 100644 utils/keytable/rc_keymaps/medion_x10_or2x.toml
>  delete mode 100644 utils/keytable/rc_keymaps/megasky
>  create mode 100644 utils/keytable/rc_keymaps/megasky.toml
>  delete mode 100644 utils/keytable/rc_keymaps/msi_digivox_ii
>  create mode 100644 utils/keytable/rc_keymaps/msi_digivox_ii.toml
>  delete mode 100644 utils/keytable/rc_keymaps/msi_digivox_iii
>  create mode 100644 utils/keytable/rc_keymaps/msi_digivox_iii.toml
>  delete mode 100644 utils/keytable/rc_keymaps/msi_tvanywhere
>  create mode 100644 utils/keytable/rc_keymaps/msi_tvanywhere.toml
>  delete mode 100644 utils/keytable/rc_keymaps/msi_tvanywhere_plus
>  create mode 100644 utils/keytable/rc_keymaps/msi_tvanywhere_plus.toml
>  delete mode 100644 utils/keytable/rc_keymaps/nebula
>  create mode 100644 utils/keytable/rc_keymaps/nebula.toml
>  delete mode 100644 utils/keytable/rc_keymaps/nec_terratec_cinergy_xs
>  create mode 100644 utils/keytable/rc_keymaps/nec_terratec_cinergy_xs.toml
>  delete mode 100644 utils/keytable/rc_keymaps/norwood
>  create mode 100644 utils/keytable/rc_keymaps/norwood.toml
>  delete mode 100644 utils/keytable/rc_keymaps/npgtech
>  create mode 100644 utils/keytable/rc_keymaps/npgtech.toml
>  delete mode 100644 utils/keytable/rc_keymaps/opera1
>  create mode 100644 utils/keytable/rc_keymaps/opera1.toml
>  delete mode 100644 utils/keytable/rc_keymaps/pctv_sedna
>  create mode 100644 utils/keytable/rc_keymaps/pctv_sedna.toml
>  delete mode 100644 utils/keytable/rc_keymaps/pinnacle310e
>  create mode 100644 utils/keytable/rc_keymaps/pinnacle310e.toml
>  delete mode 100644 utils/keytable/rc_keymaps/pinnacle_color
>  create mode 100644 utils/keytable/rc_keymaps/pinnacle_color.toml
>  delete mode 100644 utils/keytable/rc_keymaps/pinnacle_grey
>  create mode 100644 utils/keytable/rc_keymaps/pinnacle_grey.toml
>  delete mode 100644 utils/keytable/rc_keymaps/pinnacle_pctv_hd
>  create mode 100644 utils/keytable/rc_keymaps/pinnacle_pctv_hd.toml
>  delete mode 100644 utils/keytable/rc_keymaps/pixelview
>  create mode 100644 utils/keytable/rc_keymaps/pixelview.toml
>  delete mode 100644 utils/keytable/rc_keymaps/pixelview_002t
>  create mode 100644 utils/keytable/rc_keymaps/pixelview_002t.toml
>  delete mode 100644 utils/keytable/rc_keymaps/pixelview_mk12
>  create mode 100644 utils/keytable/rc_keymaps/pixelview_mk12.toml
>  delete mode 100644 utils/keytable/rc_keymaps/pixelview_new
>  create mode 100644 utils/keytable/rc_keymaps/pixelview_new.toml
>  delete mode 100644 utils/keytable/rc_keymaps/powercolor_real_angel
>  create mode 100644 utils/keytable/rc_keymaps/powercolor_real_angel.toml
>  delete mode 100644 utils/keytable/rc_keymaps/proteus_2309
>  create mode 100644 utils/keytable/rc_keymaps/proteus_2309.toml
>  delete mode 100644 utils/keytable/rc_keymaps/purpletv
>  create mode 100644 utils/keytable/rc_keymaps/purpletv.toml
>  delete mode 100644 utils/keytable/rc_keymaps/pv951
>  create mode 100644 utils/keytable/rc_keymaps/pv951.toml
>  delete mode 100644 utils/keytable/rc_keymaps/rc6_mce
>  create mode 100644 utils/keytable/rc_keymaps/rc6_mce.toml
>  delete mode 100644 utils/keytable/rc_keymaps/real_audio_220_32_keys
>  create mode 100644 utils/keytable/rc_keymaps/real_audio_220_32_keys.toml
>  delete mode 100644 utils/keytable/rc_keymaps/reddo
>  create mode 100644 utils/keytable/rc_keymaps/reddo.toml
>  delete mode 100644 utils/keytable/rc_keymaps/snapstream_firefly
>  create mode 100644 utils/keytable/rc_keymaps/snapstream_firefly.toml
>  delete mode 100644 utils/keytable/rc_keymaps/streamzap
>  create mode 100644 utils/keytable/rc_keymaps/streamzap.toml
>  delete mode 100644 utils/keytable/rc_keymaps/su3000
>  create mode 100644 utils/keytable/rc_keymaps/su3000.toml
>  delete mode 100644 utils/keytable/rc_keymaps/tango
>  create mode 100644 utils/keytable/rc_keymaps/tango.toml
>  delete mode 100644 utils/keytable/rc_keymaps/tbs_nec
>  create mode 100644 utils/keytable/rc_keymaps/tbs_nec.toml
>  delete mode 100644 utils/keytable/rc_keymaps/technisat_ts35
>  create mode 100644 utils/keytable/rc_keymaps/technisat_ts35.toml
>  delete mode 100644 utils/keytable/rc_keymaps/technisat_usb2
>  create mode 100644 utils/keytable/rc_keymaps/technisat_usb2.toml
>  delete mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_c_pci
>  create mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_c_pci.toml
>  delete mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_s2_hd
>  create mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_s2_hd.toml
>  delete mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_xs
>  create mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_xs.toml
>  delete mode 100644 utils/keytable/rc_keymaps/terratec_slim
>  create mode 100644 utils/keytable/rc_keymaps/terratec_slim.toml
>  delete mode 100644 utils/keytable/rc_keymaps/terratec_slim_2
>  create mode 100644 utils/keytable/rc_keymaps/terratec_slim_2.toml
>  delete mode 100644 utils/keytable/rc_keymaps/tevii_nec
>  create mode 100644 utils/keytable/rc_keymaps/tevii_nec.toml
>  delete mode 100644 utils/keytable/rc_keymaps/tivo
>  create mode 100644 utils/keytable/rc_keymaps/tivo.toml
>  delete mode 100644 utils/keytable/rc_keymaps/total_media_in_hand
>  create mode 100644 utils/keytable/rc_keymaps/total_media_in_hand.toml
>  delete mode 100644 utils/keytable/rc_keymaps/total_media_in_hand_02
>  create mode 100644 utils/keytable/rc_keymaps/total_media_in_hand_02.toml
>  delete mode 100644 utils/keytable/rc_keymaps/trekstor
>  create mode 100644 utils/keytable/rc_keymaps/trekstor.toml
>  delete mode 100644 utils/keytable/rc_keymaps/tt_1500
>  create mode 100644 utils/keytable/rc_keymaps/tt_1500.toml
>  delete mode 100644 utils/keytable/rc_keymaps/tvwalkertwin
>  create mode 100644 utils/keytable/rc_keymaps/tvwalkertwin.toml
>  delete mode 100644 utils/keytable/rc_keymaps/twinhan_dtv_cab_ci
>  create mode 100644 utils/keytable/rc_keymaps/twinhan_dtv_cab_ci.toml
>  delete mode 100644 utils/keytable/rc_keymaps/twinhan_vp1027_dvbs
>  create mode 100644 utils/keytable/rc_keymaps/twinhan_vp1027_dvbs.toml
>  delete mode 100644 utils/keytable/rc_keymaps/videomate_k100
>  create mode 100644 utils/keytable/rc_keymaps/videomate_k100.toml
>  delete mode 100644 utils/keytable/rc_keymaps/videomate_s350
>  create mode 100644 utils/keytable/rc_keymaps/videomate_s350.toml
>  delete mode 100644 utils/keytable/rc_keymaps/videomate_tv_pvr
>  create mode 100644 utils/keytable/rc_keymaps/videomate_tv_pvr.toml
>  delete mode 100644 utils/keytable/rc_keymaps/vp702x
>  create mode 100644 utils/keytable/rc_keymaps/vp702x.toml
>  delete mode 100644 utils/keytable/rc_keymaps/winfast
>  create mode 100644 utils/keytable/rc_keymaps/winfast.toml
>  delete mode 100644 utils/keytable/rc_keymaps/winfast_usbii_deluxe
>  create mode 100644 utils/keytable/rc_keymaps/winfast_usbii_deluxe.toml
>  delete mode 100644 utils/keytable/rc_keymaps/wobo_i5
>  delete mode 100644 utils/keytable/rc_keymaps/zx_irdec
>  create mode 100644 utils/keytable/rc_keymaps/zx_irdec.toml
>  create mode 100644 utils/keytable/rc_keymaps_bpf/RP75_LCD.toml
>  delete mode 100644 utils/keytable/rc_keymaps_userspace/allwinner_ba10_tv_box
>  create mode 100644 utils/keytable/rc_keymaps_userspace/allwinner_ba10_tv_box.toml
>  delete mode 100644 utils/keytable/rc_keymaps_userspace/allwinner_i12_a20_tv_box
>  create mode 100644 utils/keytable/rc_keymaps_userspace/allwinner_i12_a20_tv_box.toml
>  delete mode 100644 utils/keytable/rc_keymaps_userspace/wobo_i5
>  create mode 100644 utils/keytable/rc_keymaps_userspace/wobo_i5.toml
>  create mode 100644 utils/keytable/toml.c
>  create mode 100644 utils/keytable/toml.h
> 
> -- 
> 2.17.0
