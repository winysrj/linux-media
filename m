Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35132 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdE1Tdw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 15:33:52 -0400
Received: by mail-wm0-f52.google.com with SMTP id b84so32401822wmh.0
        for <linux-media@vger.kernel.org>; Sun, 28 May 2017 12:33:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <48f09c13-817b-f496-0721-b2bf8533d3d3@kaiser-linux.li>
References: <CAML3znFcKR9wx3wvjBDeQLn7mbtkhU0Knn56cMrXek6H-mTUjQ@mail.gmail.com>
 <9102e964-8143-edd7-3a82-014ae0d29d48@kaiser-linux.li> <CAML3znHkCFrtQqXvZkCwiMGNkRdSAnHBDTvfeoaQdtq8kRMkQQ@mail.gmail.com>
 <48f09c13-817b-f496-0721-b2bf8533d3d3@kaiser-linux.li>
From: Karl Wallin <karl.wallin.86@gmail.com>
Date: Sun, 28 May 2017 21:33:49 +0200
Message-ID: <CAML3znGvFv7Gd0jHUVGn45+Phzn6dkUEhcHY16h-6BQg4r6joQ@mail.gmail.com>
Subject: Re: Build fails Ubuntu 17.04 / "error: implicit declaration of function"
To: Thomas Kaiser <thomas@kaiser-linux.li>, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for such a quick reply :)

Of course *facepalm* should have thought of that "./build" downloads
everything again and of course replaces my modified "cec-core.c".
I ran "make" and ran into new problems:

"Make" log:
ubuntu@nuc-d54250wyk:~/media_build$ make
make -C /home/ubuntu/media_build/v4l
make[1]: Entering directory '/home/ubuntu/media_build/v4l'
creating symbolic links...
make -C firmware prep
make[2]: Entering directory '/home/ubuntu/media_build/v4l/firmware'
make[2]: Leaving directory '/home/ubuntu/media_build/v4l/firmware'
make -C firmware
make[2]: Entering directory '/home/ubuntu/media_build/v4l/firmware'
make[2]: Nothing to be done for 'default'.
make[2]: Leaving directory '/home/ubuntu/media_build/v4l/firmware'
Kernel build directory is /lib/modules/4.10.0-21-generic/build
make -C ../linux apply_patches
make[2]: Entering directory '/home/ubuntu/media_build/linux'
Patches for 4.10.0-21-generic already applied.
make[2]: Leaving directory '/home/ubuntu/media_build/linux'
make -C /lib/modules/4.10.0-21-generic/build
SUBDIRS=3D/home/ubuntu/media_build/v4l  modules
make[2]: Entering directory '/usr/src/linux-headers-4.10.0-21-generic'
  CC [M]  /home/ubuntu/media_build/v4l/cec-core.o
  CC [M]  /home/ubuntu/media_build/v4l/cec-adap.o
  CC [M]  /home/ubuntu/media_build/v4l/cec-api.o
  CC [M]  /home/ubuntu/media_build/v4l/cec-edid.o
  CC [M]  /home/ubuntu/media_build/v4l/cec-notifier.o
  LD [M]  /home/ubuntu/media_build/v4l/cec.o
  CC [M]  /home/ubuntu/media_build/v4l/msp3400-driver.o
  CC [M]  /home/ubuntu/media_build/v4l/msp3400-kthreads.o
  LD [M]  /home/ubuntu/media_build/v4l/msp3400.o
  CC [M]  /home/ubuntu/media_build/v4l/smiapp-core.o
  CC [M]  /home/ubuntu/media_build/v4l/smiapp-regs.o
  CC [M]  /home/ubuntu/media_build/v4l/smiapp-quirk.o
  CC [M]  /home/ubuntu/media_build/v4l/smiapp-limits.o
  LD [M]  /home/ubuntu/media_build/v4l/smiapp.o
  CC [M]  /home/ubuntu/media_build/v4l/et8ek8_mode.o
  CC [M]  /home/ubuntu/media_build/v4l/et8ek8_driver.o
/home/ubuntu/media_build/v4l/et8ek8_driver.c: In function
'et8ek8_i2c_buffered_write_regs':
/home/ubuntu/media_build/v4l/et8ek8_driver.c:256:1: warning: the frame
size of 1104 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]
 }
 ^
  LD [M]  /home/ubuntu/media_build/v4l/et8ek8.o
  CC [M]  /home/ubuntu/media_build/v4l/cx25840-core.o
  CC [M]  /home/ubuntu/media_build/v4l/cx25840-audio.o
  CC [M]  /home/ubuntu/media_build/v4l/cx25840-firmware.o
  CC [M]  /home/ubuntu/media_build/v4l/cx25840-vbi.o
  CC [M]  /home/ubuntu/media_build/v4l/cx25840-ir.o
  LD [M]  /home/ubuntu/media_build/v4l/cx25840.o
  CC [M]  /home/ubuntu/media_build/v4l/m5mols_core.o
  CC [M]  /home/ubuntu/media_build/v4l/m5mols_controls.o
  CC [M]  /home/ubuntu/media_build/v4l/m5mols_capture.o
  LD [M]  /home/ubuntu/media_build/v4l/m5mols.o
  CC [M]  /home/ubuntu/media_build/v4l/imx074.o
  CC [M]  /home/ubuntu/media_build/v4l/mt9m001.o
  CC [M]  /home/ubuntu/media_build/v4l/mt9t031.o
  CC [M]  /home/ubuntu/media_build/v4l/mt9t112.o
  CC [M]  /home/ubuntu/media_build/v4l/mt9v022.o
  CC [M]  /home/ubuntu/media_build/v4l/ov5642.o
  CC [M]  /home/ubuntu/media_build/v4l/ov6650.o
  CC [M]  /home/ubuntu/media_build/v4l/ov772x.o
  CC [M]  /home/ubuntu/media_build/v4l/ov9640.o
  CC [M]  /home/ubuntu/media_build/v4l/ov9740.o
  CC [M]  /home/ubuntu/media_build/v4l/rj54n1cb0c.o
  CC [M]  /home/ubuntu/media_build/v4l/tw9910.o
  CC [M]  /home/ubuntu/media_build/v4l/aptina-pll.o
  CC [M]  /home/ubuntu/media_build/v4l/tvaudio.o
  CC [M]  /home/ubuntu/media_build/v4l/tda7432.o
  CC [M]  /home/ubuntu/media_build/v4l/saa6588.o
  CC [M]  /home/ubuntu/media_build/v4l/tda9840.o
  CC [M]  /home/ubuntu/media_build/v4l/tea6415c.o
  CC [M]  /home/ubuntu/media_build/v4l/tea6420.o
  CC [M]  /home/ubuntu/media_build/v4l/saa7110.o
  CC [M]  /home/ubuntu/media_build/v4l/saa7115.o
  CC [M]  /home/ubuntu/media_build/v4l/saa717x.o
  CC [M]  /home/ubuntu/media_build/v4l/saa7127.o
  CC [M]  /home/ubuntu/media_build/v4l/saa7185.o
  CC [M]  /home/ubuntu/media_build/v4l/saa6752hs.o
  CC [M]  /home/ubuntu/media_build/v4l/ad5820.o
  CC [M]  /home/ubuntu/media_build/v4l/adv7170.o
  CC [M]  /home/ubuntu/media_build/v4l/adv7175.o
  CC [M]  /home/ubuntu/media_build/v4l/adv7180.o
  CC [M]  /home/ubuntu/media_build/v4l/adv7183.o
  CC [M]  /home/ubuntu/media_build/v4l/adv7343.o
  CC [M]  /home/ubuntu/media_build/v4l/adv7393.o
  CC [M]  /home/ubuntu/media_build/v4l/adv7604.o
  CC [M]  /home/ubuntu/media_build/v4l/adv7842.o
  CC [M]  /home/ubuntu/media_build/v4l/ad9389b.o
  CC [M]  /home/ubuntu/media_build/v4l/adv7511.o
  CC [M]  /home/ubuntu/media_build/v4l/vpx3220.o
  CC [M]  /home/ubuntu/media_build/v4l/vs6624.o
  CC [M]  /home/ubuntu/media_build/v4l/bt819.o
  CC [M]  /home/ubuntu/media_build/v4l/bt856.o
  CC [M]  /home/ubuntu/media_build/v4l/bt866.o
  CC [M]  /home/ubuntu/media_build/v4l/ks0127.o
  CC [M]  /home/ubuntu/media_build/v4l/ths7303.o
  CC [M]  /home/ubuntu/media_build/v4l/ths8200.o
  CC [M]  /home/ubuntu/media_build/v4l/tvp5150.o
  CC [M]  /home/ubuntu/media_build/v4l/tvp514x.o
  CC [M]  /home/ubuntu/media_build/v4l/tvp7002.o
  CC [M]  /home/ubuntu/media_build/v4l/tw2804.o
  CC [M]  /home/ubuntu/media_build/v4l/tw9903.o
  CC [M]  /home/ubuntu/media_build/v4l/tw9906.o
  CC [M]  /home/ubuntu/media_build/v4l/cs3308.o
  CC [M]  /home/ubuntu/media_build/v4l/cs5345.o
  CC [M]  /home/ubuntu/media_build/v4l/cs53l32a.o
  CC [M]  /home/ubuntu/media_build/v4l/m52790.o
  CC [M]  /home/ubuntu/media_build/v4l/tlv320aic23b.o
  CC [M]  /home/ubuntu/media_build/v4l/uda1342.o
  CC [M]  /home/ubuntu/media_build/v4l/wm8775.o
  CC [M]  /home/ubuntu/media_build/v4l/wm8739.o
  CC [M]  /home/ubuntu/media_build/v4l/vp27smpx.o
  CC [M]  /home/ubuntu/media_build/v4l/sony-btf-mpx.o
  CC [M]  /home/ubuntu/media_build/v4l/upd64031a.o
  CC [M]  /home/ubuntu/media_build/v4l/upd64083.o
  CC [M]  /home/ubuntu/media_build/v4l/ov2640.o
  CC [M]  /home/ubuntu/media_build/v4l/ov5647.o
  CC [M]  /home/ubuntu/media_build/v4l/ov7640.o
  CC [M]  /home/ubuntu/media_build/v4l/ov7670.o
  CC [M]  /home/ubuntu/media_build/v4l/ov9650.o
  CC [M]  /home/ubuntu/media_build/v4l/mt9m032.o
  CC [M]  /home/ubuntu/media_build/v4l/mt9m111.o
  CC [M]  /home/ubuntu/media_build/v4l/mt9p031.o
  CC [M]  /home/ubuntu/media_build/v4l/mt9t001.o
  CC [M]  /home/ubuntu/media_build/v4l/mt9v011.o
  CC [M]  /home/ubuntu/media_build/v4l/mt9v032.o
  CC [M]  /home/ubuntu/media_build/v4l/sr030pc30.o
  CC [M]  /home/ubuntu/media_build/v4l/noon010pc30.o
  CC [M]  /home/ubuntu/media_build/v4l/s5k6aa.o
  CC [M]  /home/ubuntu/media_build/v4l/s5k6a3.o
  CC [M]  /home/ubuntu/media_build/v4l/s5k4ecgx.o
  CC [M]  /home/ubuntu/media_build/v4l/s5k5baf.o
  CC [M]  /home/ubuntu/media_build/v4l/s5c73m3-core.o
  CC [M]  /home/ubuntu/media_build/v4l/s5c73m3-spi.o
  CC [M]  /home/ubuntu/media_build/v4l/s5c73m3-ctrls.o
  LD [M]  /home/ubuntu/media_build/v4l/s5c73m3.o
  CC [M]  /home/ubuntu/media_build/v4l/adp1653.o
  CC [M]  /home/ubuntu/media_build/v4l/as3645a.o
  CC [M]  /home/ubuntu/media_build/v4l/lm3560.o
  CC [M]  /home/ubuntu/media_build/v4l/lm3646.o
  CC [M]  /home/ubuntu/media_build/v4l/smiapp-pll.o
  CC [M]  /home/ubuntu/media_build/v4l/ak881x.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-kbd-i2c.o
  CC [M]  /home/ubuntu/media_build/v4l/ml86v7667.o
  CC [M]  /home/ubuntu/media_build/v4l/ov2659.o
  CC [M]  /home/ubuntu/media_build/v4l/tc358743.o
  CC [M]  /home/ubuntu/media_build/v4l/tuner-xc2028.o
  CC [M]  /home/ubuntu/media_build/v4l/tuner-simple.o
  CC [M]  /home/ubuntu/media_build/v4l/tuner-types.o
  CC [M]  /home/ubuntu/media_build/v4l/mt20xx.o
  CC [M]  /home/ubuntu/media_build/v4l/tda8290.o
  CC [M]  /home/ubuntu/media_build/v4l/tea5767.o
  CC [M]  /home/ubuntu/media_build/v4l/tea5761.o
  CC [M]  /home/ubuntu/media_build/v4l/tda9887.o
  CC [M]  /home/ubuntu/media_build/v4l/tda827x.o
  CC [M]  /home/ubuntu/media_build/v4l/tda18271-maps.o
  CC [M]  /home/ubuntu/media_build/v4l/tda18271-common.o
  CC [M]  /home/ubuntu/media_build/v4l/tda18271-fe.o
  LD [M]  /home/ubuntu/media_build/v4l/tda18271.o
  CC [M]  /home/ubuntu/media_build/v4l/xc5000.o
  CC [M]  /home/ubuntu/media_build/v4l/xc4000.o
  CC [M]  /home/ubuntu/media_build/v4l/msi001.o
  CC [M]  /home/ubuntu/media_build/v4l/mt2060.o
  CC [M]  /home/ubuntu/media_build/v4l/mt2063.o
  CC [M]  /home/ubuntu/media_build/v4l/mt2266.o
  CC [M]  /home/ubuntu/media_build/v4l/qt1010.o
  CC [M]  /home/ubuntu/media_build/v4l/mt2131.o
  CC [M]  /home/ubuntu/media_build/v4l/mxl5005s.o
  CC [M]  /home/ubuntu/media_build/v4l/mxl5007t.o
  CC [M]  /home/ubuntu/media_build/v4l/mc44s803.o
  CC [M]  /home/ubuntu/media_build/v4l/max2165.o
  CC [M]  /home/ubuntu/media_build/v4l/tda18218.o
  CC [M]  /home/ubuntu/media_build/v4l/tda18212.o
  CC [M]  /home/ubuntu/media_build/v4l/e4000.o
  CC [M]  /home/ubuntu/media_build/v4l/fc2580.o
  CC [M]  /home/ubuntu/media_build/v4l/tua9001.o
  CC [M]  /home/ubuntu/media_build/v4l/si2157.o
  CC [M]  /home/ubuntu/media_build/v4l/fc0011.o
  CC [M]  /home/ubuntu/media_build/v4l/fc0012.o
  CC [M]  /home/ubuntu/media_build/v4l/fc0013.o
  CC [M]  /home/ubuntu/media_build/v4l/it913x.o
  CC [M]  /home/ubuntu/media_build/v4l/r820t.o
  CC [M]  /home/ubuntu/media_build/v4l/mxl301rf.o
  CC [M]  /home/ubuntu/media_build/v4l/qm1d1c0042.o
  CC [M]  /home/ubuntu/media_build/v4l/m88rs6000t.o
  CC [M]  /home/ubuntu/media_build/v4l/dvb-pll.o
  CC [M]  /home/ubuntu/media_build/v4l/stv0299.o
  CC [M]  /home/ubuntu/media_build/v4l/stb0899_drv.o
  CC [M]  /home/ubuntu/media_build/v4l/stb0899_algo.o
  LD [M]  /home/ubuntu/media_build/v4l/stb0899.o
  CC [M]  /home/ubuntu/media_build/v4l/stb6100.o
  CC [M]  /home/ubuntu/media_build/v4l/sp8870.o
  CC [M]  /home/ubuntu/media_build/v4l/cx22700.o
  CC [M]  /home/ubuntu/media_build/v4l/s5h1432.o
  CC [M]  /home/ubuntu/media_build/v4l/cx24110.o
  CC [M]  /home/ubuntu/media_build/v4l/tda8083.o
  CC [M]  /home/ubuntu/media_build/v4l/l64781.o
  CC [M]  /home/ubuntu/media_build/v4l/dib3000mb.o
  CC [M]  /home/ubuntu/media_build/v4l/dib3000mc.o
  CC [M]  /home/ubuntu/media_build/v4l/dibx000_common.o
  CC [M]  /home/ubuntu/media_build/v4l/dib7000m.o
  CC [M]  /home/ubuntu/media_build/v4l/dib7000p.o
  CC [M]  /home/ubuntu/media_build/v4l/dib8000.o
  CC [M]  /home/ubuntu/media_build/v4l/dib9000.o
  CC [M]  /home/ubuntu/media_build/v4l/mt312.o
  CC [M]  /home/ubuntu/media_build/v4l/ves1820.o
  CC [M]  /home/ubuntu/media_build/v4l/ves1x93.o
  CC [M]  /home/ubuntu/media_build/v4l/tda1004x.o
  CC [M]  /home/ubuntu/media_build/v4l/sp887x.o
  CC [M]  /home/ubuntu/media_build/v4l/nxt6000.o
  CC [M]  /home/ubuntu/media_build/v4l/mt352.o
  CC [M]  /home/ubuntu/media_build/v4l/zl10036.o
  CC [M]  /home/ubuntu/media_build/v4l/zl10039.o
  CC [M]  /home/ubuntu/media_build/v4l/zl10353.o
  CC [M]  /home/ubuntu/media_build/v4l/cx22702.o
  CC [M]  /home/ubuntu/media_build/v4l/drxd_firm.o
  CC [M]  /home/ubuntu/media_build/v4l/drxd_hard.o
  LD [M]  /home/ubuntu/media_build/v4l/drxd.o
  CC [M]  /home/ubuntu/media_build/v4l/tda10021.o
  CC [M]  /home/ubuntu/media_build/v4l/tda10023.o
  CC [M]  /home/ubuntu/media_build/v4l/stv0297.o
  CC [M]  /home/ubuntu/media_build/v4l/nxt200x.o
  CC [M]  /home/ubuntu/media_build/v4l/or51211.o
  CC [M]  /home/ubuntu/media_build/v4l/or51132.o
  CC [M]  /home/ubuntu/media_build/v4l/bcm3510.o
  CC [M]  /home/ubuntu/media_build/v4l/s5h1420.o
  CC [M]  /home/ubuntu/media_build/v4l/lgdt330x.o
  CC [M]  /home/ubuntu/media_build/v4l/lgdt3305.o
  CC [M]  /home/ubuntu/media_build/v4l/lgdt3306a.o
  CC [M]  /home/ubuntu/media_build/v4l/lg2160.o
  CC [M]  /home/ubuntu/media_build/v4l/cx24123.o
  CC [M]  /home/ubuntu/media_build/v4l/lnbh25.o
  CC [M]  /home/ubuntu/media_build/v4l/lnbp21.o
  CC [M]  /home/ubuntu/media_build/v4l/lnbp22.o
  CC [M]  /home/ubuntu/media_build/v4l/isl6405.o
  CC [M]  /home/ubuntu/media_build/v4l/isl6421.o
  CC [M]  /home/ubuntu/media_build/v4l/tda10086.o
  CC [M]  /home/ubuntu/media_build/v4l/tda826x.o
  CC [M]  /home/ubuntu/media_build/v4l/tda8261.o
  CC [M]  /home/ubuntu/media_build/v4l/dib0070.o
  CC [M]  /home/ubuntu/media_build/v4l/dib0090.o
  CC [M]  /home/ubuntu/media_build/v4l/tua6100.o
  CC [M]  /home/ubuntu/media_build/v4l/s5h1409.o
  CC [M]  /home/ubuntu/media_build/v4l/itd1000.o
  CC [M]  /home/ubuntu/media_build/v4l/au8522_common.o
  CC [M]  /home/ubuntu/media_build/v4l/au8522_dig.o
  CC [M]  /home/ubuntu/media_build/v4l/au8522_decoder.o
  CC [M]  /home/ubuntu/media_build/v4l/tda10048.o
  CC [M]  /home/ubuntu/media_build/v4l/cx24113.o
  CC [M]  /home/ubuntu/media_build/v4l/s5h1411.o
  CC [M]  /home/ubuntu/media_build/v4l/lgs8gl5.o
  CC [M]  /home/ubuntu/media_build/v4l/tda665x.o
  CC [M]  /home/ubuntu/media_build/v4l/lgs8gxx.o
  CC [M]  /home/ubuntu/media_build/v4l/atbm8830.o
  CC [M]  /home/ubuntu/media_build/v4l/dvb_dummy_fe.o
  CC [M]  /home/ubuntu/media_build/v4l/af9013.o
  CC [M]  /home/ubuntu/media_build/v4l/cx24116.o
  CC [M]  /home/ubuntu/media_build/v4l/cx24117.o
  CC [M]  /home/ubuntu/media_build/v4l/cx24120.o
  CC [M]  /home/ubuntu/media_build/v4l/si21xx.o
  CC [M]  /home/ubuntu/media_build/v4l/si2168.o
  CC [M]  /home/ubuntu/media_build/v4l/stv0288.o
  CC [M]  /home/ubuntu/media_build/v4l/stb6000.o
  CC [M]  /home/ubuntu/media_build/v4l/s921.o
  CC [M]  /home/ubuntu/media_build/v4l/stv6110.o
  CC [M]  /home/ubuntu/media_build/v4l/stv0900_core.o
  CC [M]  /home/ubuntu/media_build/v4l/stv0900_sw.o
  LD [M]  /home/ubuntu/media_build/v4l/stv0900.o
  CC [M]  /home/ubuntu/media_build/v4l/stv090x.o
  CC [M]  /home/ubuntu/media_build/v4l/stv6110x.o
  CC [M]  /home/ubuntu/media_build/v4l/m88ds3103.o
  CC [M]  /home/ubuntu/media_build/v4l/mn88472.o
  CC [M]  /home/ubuntu/media_build/v4l/mn88473.o
  CC [M]  /home/ubuntu/media_build/v4l/isl6423.o
  CC [M]  /home/ubuntu/media_build/v4l/ec100.o
  CC [M]  /home/ubuntu/media_build/v4l/ds3000.o
  CC [M]  /home/ubuntu/media_build/v4l/ts2020.o
  CC [M]  /home/ubuntu/media_build/v4l/mb86a16.o
  CC [M]  /home/ubuntu/media_build/v4l/drxj.o
  LD [M]  /home/ubuntu/media_build/v4l/drx39xyj.o
  CC [M]  /home/ubuntu/media_build/v4l/mb86a20s.o
  CC [M]  /home/ubuntu/media_build/v4l/ix2505v.o
  CC [M]  /home/ubuntu/media_build/v4l/stv0367.o
  CC [M]  /home/ubuntu/media_build/v4l/cxd2820r_core.o
  CC [M]  /home/ubuntu/media_build/v4l/cxd2820r_c.o
  CC [M]  /home/ubuntu/media_build/v4l/cxd2820r_t.o
  CC [M]  /home/ubuntu/media_build/v4l/cxd2820r_t2.o
  LD [M]  /home/ubuntu/media_build/v4l/cxd2820r.o
  CC [M]  /home/ubuntu/media_build/v4l/cxd2841er.o
  CC [M]  /home/ubuntu/media_build/v4l/drxk_hard.o
  LD [M]  /home/ubuntu/media_build/v4l/drxk.o
  CC [M]  /home/ubuntu/media_build/v4l/tda18271c2dd.o
  CC [M]  /home/ubuntu/media_build/v4l/si2165.o
  CC [M]  /home/ubuntu/media_build/v4l/a8293.o
  CC [M]  /home/ubuntu/media_build/v4l/sp2.o
  CC [M]  /home/ubuntu/media_build/v4l/tda10071.o
  CC [M]  /home/ubuntu/media_build/v4l/rtl2830.o
  CC [M]  /home/ubuntu/media_build/v4l/rtl2832.o
  CC [M]  /home/ubuntu/media_build/v4l/rtl2832_sdr.o
  CC [M]  /home/ubuntu/media_build/v4l/m88rs2000.o
  CC [M]  /home/ubuntu/media_build/v4l/af9033.o
  CC [M]  /home/ubuntu/media_build/v4l/as102_fe.o
  CC [M]  /home/ubuntu/media_build/v4l/gp8psk-fe.o
  CC [M]  /home/ubuntu/media_build/v4l/tc90522.o
  CC [M]  /home/ubuntu/media_build/v4l/horus3a.o
  CC [M]  /home/ubuntu/media_build/v4l/ascot2e.o
  CC [M]  /home/ubuntu/media_build/v4l/helene.o
  CC [M]  /home/ubuntu/media_build/v4l/zd1301_demod.o
  CC [M]  /home/ubuntu/media_build/v4l/media-device.o
  CC [M]  /home/ubuntu/media_build/v4l/media-devnode.o
/home/ubuntu/media_build/v4l/media-devnode.c: In function
'media_devnode_register':
/home/ubuntu/media_build/v4l/media-devnode.c:257:8: error: implicit
declaration of function 'cdev_device_add'
[-Werror=3Dimplicit-function-declaration]
  ret =3D cdev_device_add(&devnode->cdev, &devnode->dev);
        ^~~~~~~~~~~~~~~
/home/ubuntu/media_build/v4l/media-devnode.c: In function
'media_devnode_unregister':
/home/ubuntu/media_build/v4l/media-devnode.c:293:2: error: implicit
declaration of function 'cdev_device_del'
[-Werror=3Dimplicit-function-declaration]
  cdev_device_del(&devnode->cdev, &devnode->dev);
  ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
scripts/Makefile.build:294: recipe for target
'/home/ubuntu/media_build/v4l/media-devnode.o' failed
make[3]: *** [/home/ubuntu/media_build/v4l/media-devnode.o] Error 1
Makefile:1524: recipe for target '_module_/home/ubuntu/media_build/v4l' fai=
led
make[2]: *** [_module_/home/ubuntu/media_build/v4l] Error 2
make[2]: Leaving directory '/usr/src/linux-headers-4.10.0-21-generic'
Makefile:51: recipe for target 'default' failed
make[1]: *** [default] Error 2
make[1]: Leaving directory '/home/ubuntu/media_build/v4l'
Makefile:26: recipe for target 'all' failed
make: *** [all] Error 2

Ok so using logic I should do the same changes in
"/home/ubuntu/media_build/v4l/media-devnode.c":
In ""/home/ubuntu/media_build/v4l/media-devnode.c" changed row 257 from:
"ret =3D cdev_device_add(&devnode->cdev, &devnode->dev);" to:
"ret =3D device_add(&devnode->dev);"
and row 293 from:
"cdev_device_del(&devnode->cdev, &devnode->dev);" to:
"device_del(&devnode->dev);"
and then run "make"

However it fails again :(

"Make" log:
ubuntu@nuc-d54250wyk:~/media_build$ make
make -C /home/ubuntu/media_build/v4l
make[1]: Entering directory '/home/ubuntu/media_build/v4l'
creating symbolic links...
make -C firmware prep
make[2]: Entering directory '/home/ubuntu/media_build/v4l/firmware'
make[2]: Leaving directory '/home/ubuntu/media_build/v4l/firmware'
make -C firmware
make[2]: Entering directory '/home/ubuntu/media_build/v4l/firmware'
make[2]: Nothing to be done for 'default'.
make[2]: Leaving directory '/home/ubuntu/media_build/v4l/firmware'
Kernel build directory is /lib/modules/4.10.0-21-generic/build
make -C ../linux apply_patches
make[2]: Entering directory '/home/ubuntu/media_build/linux'
Patches for 4.10.0-21-generic already applied.
make[2]: Leaving directory '/home/ubuntu/media_build/linux'
make -C /lib/modules/4.10.0-21-generic/build
SUBDIRS=3D/home/ubuntu/media_build/v4l  modules
make[2]: Entering directory '/usr/src/linux-headers-4.10.0-21-generic'
  CC [M]  /home/ubuntu/media_build/v4l/media-devnode.o
  CC [M]  /home/ubuntu/media_build/v4l/media-entity.o
  LD [M]  /home/ubuntu/media_build/v4l/media.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-dev.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-ioctl.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-device.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-fh.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-event.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-ctrls.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-subdev.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-clk.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-async.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-compat-ioctl32.o
  CC [M]  /home/ubuntu/media_build/v4l/vb2-trace.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-trace.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-mc.o
  LD [M]  /home/ubuntu/media_build/v4l/videodev.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-common.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-dv-timings.o
  CC [M]  /home/ubuntu/media_build/v4l/tuner-core.o
  LD [M]  /home/ubuntu/media_build/v4l/tuner.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-mem2mem.o
  CC [M]  /home/ubuntu/media_build/v4l/v4l2-flash-led-class.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf-core.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf-dma-sg.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf-dma-contig.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf-vmalloc.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf-dvb.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf2-core.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf2-v4l2.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf2-memops.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf2-vmalloc.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf2-dma-contig.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf2-dma-sg.o
  CC [M]  /home/ubuntu/media_build/v4l/videobuf2-dvb.o
  CC [M]  /home/ubuntu/media_build/v4l/dvbdev.o
  CC [M]  /home/ubuntu/media_build/v4l/dmxdev.o
  CC [M]  /home/ubuntu/media_build/v4l/dvb_demux.o
  CC [M]  /home/ubuntu/media_build/v4l/dvb_ca_en50221.o
  CC [M]  /home/ubuntu/media_build/v4l/dvb_frontend.o
  CC [M]  /home/ubuntu/media_build/v4l/dvb_net.o
  CC [M]  /home/ubuntu/media_build/v4l/dvb_ringbuffer.o
  CC [M]  /home/ubuntu/media_build/v4l/dvb_math.o
  LD [M]  /home/ubuntu/media_build/v4l/dvb-core.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-adstech-dvb-t-pci.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-alink-dtu-m.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-anysee.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-apac-viewcomp.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-asus-pc39.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-asus-ps3-100.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-ati-tv-wonder-hd-600.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-ati-x10.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-avermedia-a16d.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-avermedia.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-avermedia-cardbus.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-avermedia-dvbt.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-avermedia-m135a.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-avermedia-m733a-rm-k6.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-avermedia-rm-ks.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-avertv-303.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-azurewave-ad-tu700.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-behold.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-behold-columbus.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-budget-ci-old.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-cec.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-cinergy-1400.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-cinergy.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-d680-dmb.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-delock-61959.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-dib0700-nec.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-dib0700-rc5.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-digitalnow-tinytwin.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-digittrade.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-dm1105-nec.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-dntv-live-dvb-t.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-dntv-live-dvbt-pro.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-dtt200u.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-dvbsky.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-dvico-mce.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-dvico-portable.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-em-terratec.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-encore-enltv2.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-encore-enltv.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-encore-enltv-fm53.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-evga-indtube.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-eztv.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-flydvb.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-flyvideo.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-fusionhdtv-mce.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-gadmei-rm008z.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-geekbox.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-genius-tvgo-a11mce.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-gotview7135.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-imon-mce.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-imon-pad.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-iodata-bctv7e.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-it913x-v1.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-it913x-v2.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-kaiomy.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-kworld-315u.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-kworld-pc150u.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-kworld-plus-tv-analog.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-leadtek-y04g0051.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-lme2510.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-manli.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-medion-x10.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-medion-x10-digitainer.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-medion-x10-or2x.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-msi-digivox-ii.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-msi-digivox-iii.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-msi-tvanywhere.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-msi-tvanywhere-plus.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-nebula.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-nec-terratec-cinergy-xs.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-norwood.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-npgtech.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-pctv-sedna.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-pinnacle-color.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-pinnacle-grey.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-pinnacle-pctv-hd.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-pixelview.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-pixelview-mk12.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-pixelview-002t.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-pixelview-new.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-powercolor-real-angel.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-proteus-2309.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-purpletv.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-pv951.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-hauppauge.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-rc6-mce.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-real-audio-220-32-keys.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-reddo.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-snapstream-firefly.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-streamzap.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-tbs-nec.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-technisat-ts35.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-technisat-usb2.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-terratec-cinergy-c-pci.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-terratec-cinergy-s2-hd.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-terratec-cinergy-xs.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-terratec-slim.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-terratec-slim-2.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-tevii-nec.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-tivo.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-total-media-in-hand.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-total-media-in-hand-02.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-trekstor.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-tt-1500.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-twinhan-dtv-cab-ci.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-twinhan1027.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-videomate-m1f.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-videomate-s350.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-videomate-tv-pvr.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-winfast.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-winfast-usbii-deluxe.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-su3000.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-main.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-ir-raw.o
  LD [M]  /home/ubuntu/media_build/v4l/rc-core.o
  CC [M]  /home/ubuntu/media_build/v4l/lirc_dev.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-nec-decoder.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-rc5-decoder.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-rc6-decoder.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-jvc-decoder.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-sony-decoder.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-sanyo-decoder.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-sharp-decoder.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-mce_kbd-decoder.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-lirc-codec.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-xmp-decoder.o
  CC [M]  /home/ubuntu/media_build/v4l/ati_remote.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-hix5hd2.o
  CC [M]  /home/ubuntu/media_build/v4l/imon.o
  CC [M]  /home/ubuntu/media_build/v4l/ite-cir.o
  CC [M]  /home/ubuntu/media_build/v4l/mceusb.o
  CC [M]  /home/ubuntu/media_build/v4l/fintek-cir.o
  CC [M]  /home/ubuntu/media_build/v4l/nuvoton-cir.o
  CC [M]  /home/ubuntu/media_build/v4l/ene_ir.o
  CC [M]  /home/ubuntu/media_build/v4l/redrat3.o
  CC [M]  /home/ubuntu/media_build/v4l/ir-spi.o
  CC [M]  /home/ubuntu/media_build/v4l/streamzap.o
  CC [M]  /home/ubuntu/media_build/v4l/winbond-cir.o
  CC [M]  /home/ubuntu/media_build/v4l/rc-loopback.o
  CC [M]  /home/ubuntu/media_build/v4l/gpio-ir-recv.o
  CC [M]  /home/ubuntu/media_build/v4l/igorplugusb.o
  CC [M]  /home/ubuntu/media_build/v4l/iguanair.o
  CC [M]  /home/ubuntu/media_build/v4l/ttusbir.o
  CC [M]  /home/ubuntu/media_build/v4l/serial_ir.o
/home/ubuntu/media_build/v4l/serial_ir.c:837:21: error: expected ')'
before 'int'
 module_param_hw(io, int, ioport, 0444);
                     ^~~
/home/ubuntu/media_build/v4l/serial_ir.c:841:25: error: expected ')'
before 'ulong'
 module_param_hw(iommap, ulong, other, 0444);
                         ^~~~~
/home/ubuntu/media_build/v4l/serial_ir.c:849:26: error: expected ')'
before 'int'
 module_param_hw(ioshift, int, other, 0444);
                          ^~~
/home/ubuntu/media_build/v4l/serial_ir.c:852:22: error: expected ')'
before 'int'
 module_param_hw(irq, int, irq, 0444);
                      ^~~
/home/ubuntu/media_build/v4l/serial_ir.c:855:28: error: expected ')'
before 'bool'
 module_param_hw(share_irq, bool, other, 0444);
                            ^~~~
scripts/Makefile.build:301: recipe for target
'/home/ubuntu/media_build/v4l/serial_ir.o' failed
make[3]: *** [/home/ubuntu/media_build/v4l/serial_ir.o] Error 1
Makefile:1524: recipe for target '_module_/home/ubuntu/media_build/v4l' fai=
led
make[2]: *** [_module_/home/ubuntu/media_build/v4l] Error 2
make[2]: Leaving directory '/usr/src/linux-headers-4.10.0-21-generic'
Makefile:51: recipe for target 'default' failed
make[1]: *** [default] Error 2
make[1]: Leaving directory '/home/ubuntu/media_build/v4l'
Makefile:26: recipe for target 'all' failed
make: *** [all] Error 2

So I'm guessing that "/home/ubuntu/media_build/v4l/serial_ir.c" needs
to be modified since it expects a ")" before the integer (numerical)
value?

/Karl
Med v=C3=A4nlig h=C3=A4lsning / Best Regards - Karl Wallin

karl.wallin.86@gmail.com

P.S. Om mitt mail b=C3=B6r vidarebefodras, v=C3=A4nligen g=C3=B6r detta ist=
=C3=A4llet f=C3=B6r
att =C3=A5terkomma med en email-adress i ett svar till mig. / If my mail
should be forwarded then please forward it instead of replying to me
with an email address. P.S.


2017-05-28 21:14 GMT+02:00 Thomas Kaiser <thomas@kaiser-linux.li>:
> On 28.05.2017 21:06, Karl Wallin wrote:
>>
>> Hi Thomas,
>>
>> Thanks for the help (and to Vincent as well) :)
>>
>> In "/home/ubuntu/media_build/v4l/cec-core.c" changed row 142 from:
>> "ret =3D cdev_device_add(&devnode->cdev, &devnode->dev);" to:
>> "ret =3D device_add(&devnode->dev);"
>> and row 186 from:
>> "cdev_device_del(&devnode->cdev, &devnode->dev);" to:
>> "device_del(&devnode->dev);"
>>
>> Even if I do that when I try to build it again (using ./build) it
>> seems to reload / revert the cec-core.c to the original file since I
>> still get these errors even though I saved the changes in Notepadqq:
>> "/home/ubuntu/media_build/v4l/cec-core.c:142:8: error: implicit
>> declaration of function 'cdev_device_add'
>> [-Werror=3Dimplicit-function-declaration]
>>    ret =3D cdev_device_add(&devnode->cdev, &devnode->dev);"
>> and
>> "/home/ubuntu/media_build/v4l/cec-core.c:186:2: error: implicit
>> declaration of function 'cdev_device_del'
>> [-Werror=3Dimplicit-function-declaration]
>>    cdev_device_del(&devnode->cdev, &devnode->dev);"
>>
>> I am probably missing something here since it worked for you, would be
>> grateful for your help :)
>>
>> /Karl
>> Med v=C3=A4nlig h=C3=A4lsning / Best Regards - Karl Wallin
>>
>
> Hi Karl
>
> The build downloads the latest source and overwrites your change (I think=
?)
>
> I used "make" to compile.
>
> After your have run the build script. Do the changes as you have describe=
d
> above. Run "make" to compile and "sudo make install" to install. This sho=
uld
> do the trick.
>
> Thomas
