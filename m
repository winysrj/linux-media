Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44700 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935344AbdDFOkz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 10:40:55 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] [media] Order the Makefile alphabetically
Date: Thu,  6 Apr 2017 16:40:51 +0200
Message-Id: <20170406144051.13008-1-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Makefiles were a free for all without a clear order defined. Sort all the
options based on the Kconfig symbol.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

---

Hi Mauro,

Here is my makefile ordering patch again, this time with all the Makefiles
in drivers/media that needed ordering.

Since we're already pretty late in the release period, I guess there won't
be any major conflicts between now and the merge window.

Maxime
---
 drivers/media/common/Makefile        |   2 +-
 drivers/media/dvb-frontends/Makefile | 220 +++++++++++++++++------------------
 drivers/media/i2c/Makefile           | 162 +++++++++++++-------------
 drivers/media/pci/Makefile           |  34 +++---
 drivers/media/platform/Makefile      |  92 +++++----------
 drivers/media/radio/Makefile         |  62 +++++-----
 drivers/media/rc/Makefile            |  74 ++++++------
 drivers/media/tuners/Makefile        |  73 ++++++------
 drivers/media/usb/Makefile           |  34 +++---
 drivers/media/v4l2-core/Makefile     |  36 +++---
 10 files changed, 381 insertions(+), 408 deletions(-)

diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
index 2d1b0a025084..e71c70afc87d 100644
--- a/drivers/media/common/Makefile
+++ b/drivers/media/common/Makefile
@@ -1,4 +1,4 @@
 obj-y += b2c2/ saa7146/ siano/ v4l2-tpg/
+obj-$(CONFIG_CYPRESS_FIRMWARE) += cypress_firmware.o
 obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
 obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
-obj-$(CONFIG_CYPRESS_FIRMWARE) += cypress_firmware.o
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index 3fccaf34ef52..9e09a596c2b2 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -16,113 +16,113 @@ drxd-objs := drxd_firm.o drxd_hard.o
 cxd2820r-objs := cxd2820r_core.o cxd2820r_c.o cxd2820r_t.o cxd2820r_t2.o
 drxk-objs := drxk_hard.o
 
-obj-$(CONFIG_DVB_PLL) += dvb-pll.o
-obj-$(CONFIG_DVB_STV0299) += stv0299.o
-obj-$(CONFIG_DVB_STB0899) += stb0899.o
-obj-$(CONFIG_DVB_STB6100) += stb6100.o
-obj-$(CONFIG_DVB_SP8870) += sp8870.o
-obj-$(CONFIG_DVB_CX22700) += cx22700.o
-obj-$(CONFIG_DVB_S5H1432) += s5h1432.o
-obj-$(CONFIG_DVB_CX24110) += cx24110.o
-obj-$(CONFIG_DVB_TDA8083) += tda8083.o
-obj-$(CONFIG_DVB_L64781) += l64781.o
-obj-$(CONFIG_DVB_DIB3000MB) += dib3000mb.o
-obj-$(CONFIG_DVB_DIB3000MC) += dib3000mc.o dibx000_common.o
-obj-$(CONFIG_DVB_DIB7000M) += dib7000m.o dibx000_common.o
-obj-$(CONFIG_DVB_DIB7000P) += dib7000p.o dibx000_common.o
-obj-$(CONFIG_DVB_DIB8000) += dib8000.o dibx000_common.o
-obj-$(CONFIG_DVB_DIB9000) += dib9000.o dibx000_common.o
-obj-$(CONFIG_DVB_MT312) += mt312.o
-obj-$(CONFIG_DVB_VES1820) += ves1820.o
-obj-$(CONFIG_DVB_VES1X93) += ves1x93.o
-obj-$(CONFIG_DVB_TDA1004X) += tda1004x.o
-obj-$(CONFIG_DVB_SP887X) += sp887x.o
-obj-$(CONFIG_DVB_NXT6000) += nxt6000.o
-obj-$(CONFIG_DVB_MT352) += mt352.o
-obj-$(CONFIG_DVB_ZL10036) += zl10036.o
-obj-$(CONFIG_DVB_ZL10039) += zl10039.o
-obj-$(CONFIG_DVB_ZL10353) += zl10353.o
-obj-$(CONFIG_DVB_CX22702) += cx22702.o
-obj-$(CONFIG_DVB_DRXD) += drxd.o
-obj-$(CONFIG_DVB_TDA10021) += tda10021.o
-obj-$(CONFIG_DVB_TDA10023) += tda10023.o
-obj-$(CONFIG_DVB_STV0297) += stv0297.o
-obj-$(CONFIG_DVB_NXT200X) += nxt200x.o
-obj-$(CONFIG_DVB_OR51211) += or51211.o
-obj-$(CONFIG_DVB_OR51132) += or51132.o
-obj-$(CONFIG_DVB_BCM3510) += bcm3510.o
-obj-$(CONFIG_DVB_S5H1420) += s5h1420.o
-obj-$(CONFIG_DVB_LGDT330X) += lgdt330x.o
-obj-$(CONFIG_DVB_LGDT3305) += lgdt3305.o
-obj-$(CONFIG_DVB_LGDT3306A) += lgdt3306a.o
-obj-$(CONFIG_DVB_LG2160) += lg2160.o
-obj-$(CONFIG_DVB_CX24123) += cx24123.o
-obj-$(CONFIG_DVB_LNBH25) += lnbh25.o
-obj-$(CONFIG_DVB_LNBP21) += lnbp21.o
-obj-$(CONFIG_DVB_LNBP22) += lnbp22.o
-obj-$(CONFIG_DVB_ISL6405) += isl6405.o
-obj-$(CONFIG_DVB_ISL6421) += isl6421.o
-obj-$(CONFIG_DVB_TDA10086) += tda10086.o
-obj-$(CONFIG_DVB_TDA826X) += tda826x.o
-obj-$(CONFIG_DVB_TDA8261) += tda8261.o
-obj-$(CONFIG_DVB_TUNER_DIB0070) += dib0070.o
-obj-$(CONFIG_DVB_TUNER_DIB0090) += dib0090.o
-obj-$(CONFIG_DVB_TUA6100) += tua6100.o
-obj-$(CONFIG_DVB_S5H1409) += s5h1409.o
-obj-$(CONFIG_DVB_TUNER_ITD1000) += itd1000.o
-obj-$(CONFIG_DVB_AU8522) += au8522_common.o
-obj-$(CONFIG_DVB_AU8522_DTV) += au8522_dig.o
-obj-$(CONFIG_DVB_AU8522_V4L) += au8522_decoder.o
-obj-$(CONFIG_DVB_TDA10048) += tda10048.o
-obj-$(CONFIG_DVB_TUNER_CX24113) += cx24113.o
-obj-$(CONFIG_DVB_S5H1411) += s5h1411.o
-obj-$(CONFIG_DVB_LGS8GL5) += lgs8gl5.o
-obj-$(CONFIG_DVB_TDA665x) += tda665x.o
-obj-$(CONFIG_DVB_LGS8GXX) += lgs8gxx.o
-obj-$(CONFIG_DVB_ATBM8830) += atbm8830.o
-obj-$(CONFIG_DVB_DUMMY_FE) += dvb_dummy_fe.o
-obj-$(CONFIG_DVB_AF9013) += af9013.o
-obj-$(CONFIG_DVB_CX24116) += cx24116.o
-obj-$(CONFIG_DVB_CX24117) += cx24117.o
-obj-$(CONFIG_DVB_CX24120) += cx24120.o
-obj-$(CONFIG_DVB_SI21XX) += si21xx.o
-obj-$(CONFIG_DVB_SI2168) += si2168.o
-obj-$(CONFIG_DVB_STV0288) += stv0288.o
-obj-$(CONFIG_DVB_STB6000) += stb6000.o
-obj-$(CONFIG_DVB_S921) += s921.o
-obj-$(CONFIG_DVB_STV6110) += stv6110.o
-obj-$(CONFIG_DVB_STV0900) += stv0900.o
-obj-$(CONFIG_DVB_STV090x) += stv090x.o
-obj-$(CONFIG_DVB_STV6110x) += stv6110x.o
-obj-$(CONFIG_DVB_M88DS3103) += m88ds3103.o
-obj-$(CONFIG_DVB_MN88472) += mn88472.o
-obj-$(CONFIG_DVB_MN88473) += mn88473.o
-obj-$(CONFIG_DVB_ISL6423) += isl6423.o
-obj-$(CONFIG_DVB_EC100) += ec100.o
-obj-$(CONFIG_DVB_DS3000) += ds3000.o
-obj-$(CONFIG_DVB_TS2020) += ts2020.o
-obj-$(CONFIG_DVB_MB86A16) += mb86a16.o
-obj-$(CONFIG_DVB_DRX39XYJ) += drx39xyj/
-obj-$(CONFIG_DVB_MB86A20S) += mb86a20s.o
-obj-$(CONFIG_DVB_IX2505V) += ix2505v.o
-obj-$(CONFIG_DVB_STV0367) += stv0367.o
-obj-$(CONFIG_DVB_CXD2820R) += cxd2820r.o
-obj-$(CONFIG_DVB_CXD2841ER) += cxd2841er.o
-obj-$(CONFIG_DVB_DRXK) += drxk.o
-obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
-obj-$(CONFIG_DVB_SI2165) += si2165.o
-obj-$(CONFIG_DVB_A8293) += a8293.o
-obj-$(CONFIG_DVB_SP2) += sp2.o
-obj-$(CONFIG_DVB_TDA10071) += tda10071.o
-obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
-obj-$(CONFIG_DVB_RTL2832) += rtl2832.o
-obj-$(CONFIG_DVB_RTL2832_SDR) += rtl2832_sdr.o
-obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
-obj-$(CONFIG_DVB_AF9033) += af9033.o
-obj-$(CONFIG_DVB_AS102_FE) += as102_fe.o
-obj-$(CONFIG_DVB_GP8PSK_FE) += gp8psk-fe.o
-obj-$(CONFIG_DVB_TC90522) += tc90522.o
-obj-$(CONFIG_DVB_HORUS3A) += horus3a.o
-obj-$(CONFIG_DVB_ASCOT2E) += ascot2e.o
-obj-$(CONFIG_DVB_HELENE) += helene.o
-obj-$(CONFIG_DVB_ZD1301_DEMOD) += zd1301_demod.o
+obj-$(CONFIG_DVB_A8293)		+= a8293.o
+obj-$(CONFIG_DVB_AF9013)	+= af9013.o
+obj-$(CONFIG_DVB_AF9033)	+= af9033.o
+obj-$(CONFIG_DVB_AS102_FE)	+= as102_fe.o
+obj-$(CONFIG_DVB_ASCOT2E)	+= ascot2e.o
+obj-$(CONFIG_DVB_ATBM8830)	+= atbm8830.o
+obj-$(CONFIG_DVB_AU8522)	+= au8522_common.o
+obj-$(CONFIG_DVB_AU8522_DTV)	+= au8522_dig.o
+obj-$(CONFIG_DVB_AU8522_V4L)	+= au8522_decoder.o
+obj-$(CONFIG_DVB_BCM3510)	+= bcm3510.o
+obj-$(CONFIG_DVB_CX22700)	+= cx22700.o
+obj-$(CONFIG_DVB_CX22702)	+= cx22702.o
+obj-$(CONFIG_DVB_CX24110)	+= cx24110.o
+obj-$(CONFIG_DVB_CX24116)	+= cx24116.o
+obj-$(CONFIG_DVB_CX24117)	+= cx24117.o
+obj-$(CONFIG_DVB_CX24120)	+= cx24120.o
+obj-$(CONFIG_DVB_CX24123)	+= cx24123.o
+obj-$(CONFIG_DVB_CXD2820R)	+= cxd2820r.o
+obj-$(CONFIG_DVB_CXD2841ER)	+= cxd2841er.o
+obj-$(CONFIG_DVB_DIB3000MB)	+= dib3000mb.o
+obj-$(CONFIG_DVB_DIB3000MC)	+= dib3000mc.o dibx000_common.o
+obj-$(CONFIG_DVB_DIB7000M)	+= dib7000m.o dibx000_common.o
+obj-$(CONFIG_DVB_DIB7000P)	+= dib7000p.o dibx000_common.o
+obj-$(CONFIG_DVB_DIB8000)	+= dib8000.o dibx000_common.o
+obj-$(CONFIG_DVB_DIB9000)	+= dib9000.o dibx000_common.o
+obj-$(CONFIG_DVB_DRX39XYJ)	+= drx39xyj/
+obj-$(CONFIG_DVB_DRXD)		+= drxd.o
+obj-$(CONFIG_DVB_DRXK)		+= drxk.o
+obj-$(CONFIG_DVB_DS3000)	+= ds3000.o
+obj-$(CONFIG_DVB_DUMMY_FE)	+= dvb_dummy_fe.o
+obj-$(CONFIG_DVB_EC100)		+= ec100.o
+obj-$(CONFIG_DVB_GP8PSK_FE)	+= gp8psk-fe.o
+obj-$(CONFIG_DVB_HELENE)	+= helene.o
+obj-$(CONFIG_DVB_HORUS3A)	+= horus3a.o
+obj-$(CONFIG_DVB_ISL6405)	+= isl6405.o
+obj-$(CONFIG_DVB_ISL6421)	+= isl6421.o
+obj-$(CONFIG_DVB_ISL6423)	+= isl6423.o
+obj-$(CONFIG_DVB_IX2505V)	+= ix2505v.o
+obj-$(CONFIG_DVB_L64781)	+= l64781.o
+obj-$(CONFIG_DVB_LG2160)	+= lg2160.o
+obj-$(CONFIG_DVB_LGDT3305)	+= lgdt3305.o
+obj-$(CONFIG_DVB_LGDT3306A)	+= lgdt3306a.o
+obj-$(CONFIG_DVB_LGDT330X)	+= lgdt330x.o
+obj-$(CONFIG_DVB_LGS8GL5)	+= lgs8gl5.o
+obj-$(CONFIG_DVB_LGS8GXX)	+= lgs8gxx.o
+obj-$(CONFIG_DVB_LNBH25)	+= lnbh25.o
+obj-$(CONFIG_DVB_LNBP21)	+= lnbp21.o
+obj-$(CONFIG_DVB_LNBP22)	+= lnbp22.o
+obj-$(CONFIG_DVB_M88DS3103)	+= m88ds3103.o
+obj-$(CONFIG_DVB_M88RS2000)	+= m88rs2000.o
+obj-$(CONFIG_DVB_MB86A16)	+= mb86a16.o
+obj-$(CONFIG_DVB_MB86A20S)	+= mb86a20s.o
+obj-$(CONFIG_DVB_MN88472)	+= mn88472.o
+obj-$(CONFIG_DVB_MN88473)	+= mn88473.o
+obj-$(CONFIG_DVB_MT312)		+= mt312.o
+obj-$(CONFIG_DVB_MT352)		+= mt352.o
+obj-$(CONFIG_DVB_NXT200X)	+= nxt200x.o
+obj-$(CONFIG_DVB_NXT6000)	+= nxt6000.o
+obj-$(CONFIG_DVB_OR51132)	+= or51132.o
+obj-$(CONFIG_DVB_OR51211)	+= or51211.o
+obj-$(CONFIG_DVB_PLL)	+= dvb-pll.o
+obj-$(CONFIG_DVB_RTL2830)	+= rtl2830.o
+obj-$(CONFIG_DVB_RTL2832)	+= rtl2832.o
+obj-$(CONFIG_DVB_RTL2832_SDR)	+= rtl2832_sdr.o
+obj-$(CONFIG_DVB_S5H1409)	+= s5h1409.o
+obj-$(CONFIG_DVB_S5H1411)	+= s5h1411.o
+obj-$(CONFIG_DVB_S5H1420)	+= s5h1420.o
+obj-$(CONFIG_DVB_S5H1432)	+= s5h1432.o
+obj-$(CONFIG_DVB_S921)	+= s921.o
+obj-$(CONFIG_DVB_SI2165)	+= si2165.o
+obj-$(CONFIG_DVB_SI2168)	+= si2168.o
+obj-$(CONFIG_DVB_SI21XX)	+= si21xx.o
+obj-$(CONFIG_DVB_SP2)	+= sp2.o
+obj-$(CONFIG_DVB_SP8870)	+= sp8870.o
+obj-$(CONFIG_DVB_SP887X)	+= sp887x.o
+obj-$(CONFIG_DVB_STB0899)	+= stb0899.o
+obj-$(CONFIG_DVB_STB6000)	+= stb6000.o
+obj-$(CONFIG_DVB_STB6100)	+= stb6100.o
+obj-$(CONFIG_DVB_STV0288)	+= stv0288.o
+obj-$(CONFIG_DVB_STV0297)	+= stv0297.o
+obj-$(CONFIG_DVB_STV0299)	+= stv0299.o
+obj-$(CONFIG_DVB_STV0367)	+= stv0367.o
+obj-$(CONFIG_DVB_STV0900)	+= stv0900.o
+obj-$(CONFIG_DVB_STV090x)	+= stv090x.o
+obj-$(CONFIG_DVB_STV6110)	+= stv6110.o
+obj-$(CONFIG_DVB_STV6110x)	+= stv6110x.o
+obj-$(CONFIG_DVB_TC90522)	+= tc90522.o
+obj-$(CONFIG_DVB_TDA10021)	+= tda10021.o
+obj-$(CONFIG_DVB_TDA10023)	+= tda10023.o
+obj-$(CONFIG_DVB_TDA10048)	+= tda10048.o
+obj-$(CONFIG_DVB_TDA1004X)	+= tda1004x.o
+obj-$(CONFIG_DVB_TDA10071)	+= tda10071.o
+obj-$(CONFIG_DVB_TDA10086)	+= tda10086.o
+obj-$(CONFIG_DVB_TDA18271C2DD)	+= tda18271c2dd.o
+obj-$(CONFIG_DVB_TDA665x)	+= tda665x.o
+obj-$(CONFIG_DVB_TDA8083)	+= tda8083.o
+obj-$(CONFIG_DVB_TDA8261)	+= tda8261.o
+obj-$(CONFIG_DVB_TDA826X)	+= tda826x.o
+obj-$(CONFIG_DVB_TS2020)	+= ts2020.o
+obj-$(CONFIG_DVB_TUA6100)	+= tua6100.o
+obj-$(CONFIG_DVB_TUNER_CX24113)	+= cx24113.o
+obj-$(CONFIG_DVB_TUNER_DIB0070)	+= dib0070.o
+obj-$(CONFIG_DVB_TUNER_DIB0090)	+= dib0090.o
+obj-$(CONFIG_DVB_TUNER_ITD1000)	+= itd1000.o
+obj-$(CONFIG_DVB_VES1820)	+= ves1820.o
+obj-$(CONFIG_DVB_VES1X93)	+= ves1x93.o
+obj-$(CONFIG_DVB_ZD1301_DEMOD)	+= zd1301_demod.o
+obj-$(CONFIG_DVB_ZL10036)	+= zl10036.o
+obj-$(CONFIG_DVB_ZL10039)	+= zl10039.o
+obj-$(CONFIG_DVB_ZL10353)	+= zl10353.o
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 5bc7bbeb5499..0696bd6b64cc 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -1,85 +1,85 @@
 msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
-obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
 
-obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
-obj-$(CONFIG_VIDEO_ET8EK8)	+= et8ek8/
-obj-$(CONFIG_VIDEO_CX25840) += cx25840/
-obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
-obj-y				+= soc_camera/
+obj-y					+= soc_camera/
 
-obj-$(CONFIG_VIDEO_APTINA_PLL) += aptina-pll.o
-obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
-obj-$(CONFIG_VIDEO_TDA7432) += tda7432.o
-obj-$(CONFIG_VIDEO_SAA6588) += saa6588.o
-obj-$(CONFIG_VIDEO_TDA9840) += tda9840.o
-obj-$(CONFIG_VIDEO_TEA6415C) += tea6415c.o
-obj-$(CONFIG_VIDEO_TEA6420) += tea6420.o
-obj-$(CONFIG_VIDEO_SAA7110) += saa7110.o
-obj-$(CONFIG_VIDEO_SAA711X) += saa7115.o
-obj-$(CONFIG_VIDEO_SAA717X) += saa717x.o
-obj-$(CONFIG_VIDEO_SAA7127) += saa7127.o
-obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
-obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
-obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
-obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
-obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
-obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
-obj-$(CONFIG_VIDEO_ADV7183) += adv7183.o
-obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
-obj-$(CONFIG_VIDEO_ADV7393) += adv7393.o
-obj-$(CONFIG_VIDEO_ADV7604) += adv7604.o
-obj-$(CONFIG_VIDEO_ADV7842) += adv7842.o
-obj-$(CONFIG_VIDEO_AD9389B) += ad9389b.o
-obj-$(CONFIG_VIDEO_ADV7511) += adv7511.o
-obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
-obj-$(CONFIG_VIDEO_VS6624)  += vs6624.o
-obj-$(CONFIG_VIDEO_BT819) += bt819.o
-obj-$(CONFIG_VIDEO_BT856) += bt856.o
-obj-$(CONFIG_VIDEO_BT866) += bt866.o
-obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
-obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
-obj-$(CONFIG_VIDEO_THS8200) += ths8200.o
-obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
-obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
-obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
-obj-$(CONFIG_VIDEO_TW2804) += tw2804.o
-obj-$(CONFIG_VIDEO_TW9903) += tw9903.o
-obj-$(CONFIG_VIDEO_TW9906) += tw9906.o
-obj-$(CONFIG_VIDEO_CS3308) += cs3308.o
-obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
-obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
-obj-$(CONFIG_VIDEO_M52790) += m52790.o
-obj-$(CONFIG_VIDEO_TLV320AIC23B) += tlv320aic23b.o
-obj-$(CONFIG_VIDEO_UDA1342) += uda1342.o
-obj-$(CONFIG_VIDEO_WM8775) += wm8775.o
-obj-$(CONFIG_VIDEO_WM8739) += wm8739.o
-obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
-obj-$(CONFIG_VIDEO_SONY_BTF_MPX) += sony-btf-mpx.o
-obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
-obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
-obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
-obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
-obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
-obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
-obj-$(CONFIG_VIDEO_MT9M111) += mt9m111.o
-obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
-obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
-obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
-obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
-obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
-obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
-obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
-obj-$(CONFIG_VIDEO_S5K6A3)	+= s5k6a3.o
-obj-$(CONFIG_VIDEO_S5K4ECGX)	+= s5k4ecgx.o
-obj-$(CONFIG_VIDEO_S5K5BAF)	+= s5k5baf.o
-obj-$(CONFIG_VIDEO_S5C73M3)	+= s5c73m3/
-obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
-obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
-obj-$(CONFIG_VIDEO_LM3560)	+= lm3560.o
-obj-$(CONFIG_VIDEO_LM3646)	+= lm3646.o
-obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
+obj-$(CONFIG_VIDEO_AD5820)		+= ad5820.o
+obj-$(CONFIG_VIDEO_AD9389B)		+= ad9389b.o
+obj-$(CONFIG_VIDEO_ADP1653)		+= adp1653.o
+obj-$(CONFIG_VIDEO_ADV7170)		+= adv7170.o
+obj-$(CONFIG_VIDEO_ADV7175)		+= adv7175.o
+obj-$(CONFIG_VIDEO_ADV7180)		+= adv7180.o
+obj-$(CONFIG_VIDEO_ADV7183)		+= adv7183.o
+obj-$(CONFIG_VIDEO_ADV7343)		+= adv7343.o
+obj-$(CONFIG_VIDEO_ADV7393)		+= adv7393.o
+obj-$(CONFIG_VIDEO_ADV7511)		+= adv7511.o
+obj-$(CONFIG_VIDEO_ADV7604)		+= adv7604.o
+obj-$(CONFIG_VIDEO_ADV7842)		+= adv7842.o
 obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
-obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
-obj-$(CONFIG_VIDEO_ML86V7667)	+= ml86v7667.o
-obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
-obj-$(CONFIG_VIDEO_TC358743)	+= tc358743.o
+obj-$(CONFIG_VIDEO_APTINA_PLL)		+= aptina-pll.o
+obj-$(CONFIG_VIDEO_AS3645A)		+= as3645a.o
+obj-$(CONFIG_VIDEO_BT819)		+= bt819.o
+obj-$(CONFIG_VIDEO_BT856)		+= bt856.o
+obj-$(CONFIG_VIDEO_BT866)		+= bt866.o
+obj-$(CONFIG_VIDEO_CS3308)		+= cs3308.o
+obj-$(CONFIG_VIDEO_CS5345)		+= cs5345.o
+obj-$(CONFIG_VIDEO_CS53L32A)		+= cs53l32a.o
+obj-$(CONFIG_VIDEO_CX25840)		+= cx25840/
+obj-$(CONFIG_VIDEO_ET8EK8)		+= et8ek8/
+obj-$(CONFIG_VIDEO_IR_I2C) 		+= ir-kbd-i2c.o
+obj-$(CONFIG_VIDEO_KS0127)		+= ks0127.o
+obj-$(CONFIG_VIDEO_LM3560)		+= lm3560.o
+obj-$(CONFIG_VIDEO_LM3646)		+= lm3646.o
+obj-$(CONFIG_VIDEO_M52790)		+= m52790.o
+obj-$(CONFIG_VIDEO_M5MOLS)		+= m5mols/
+obj-$(CONFIG_VIDEO_ML86V7667)		+= ml86v7667.o
+obj-$(CONFIG_VIDEO_MSP3400)		+= msp3400.o
+obj-$(CONFIG_VIDEO_MT9M032)		+= mt9m032.o
+obj-$(CONFIG_VIDEO_MT9M111)		+= mt9m111.o
+obj-$(CONFIG_VIDEO_MT9P031)		+= mt9p031.o
+obj-$(CONFIG_VIDEO_MT9T001)		+= mt9t001.o
+obj-$(CONFIG_VIDEO_MT9V011)		+= mt9v011.o
+obj-$(CONFIG_VIDEO_MT9V032)		+= mt9v032.o
+obj-$(CONFIG_VIDEO_NOON010PC30)		+= noon010pc30.o
+obj-$(CONFIG_VIDEO_OV2659)		+= ov2659.o
+obj-$(CONFIG_VIDEO_OV7640)		+= ov7640.o
+obj-$(CONFIG_VIDEO_OV7670)		+= ov7670.o
+obj-$(CONFIG_VIDEO_OV9650)		+= ov9650.o
+obj-$(CONFIG_VIDEO_S5C73M3)		+= s5c73m3/
+obj-$(CONFIG_VIDEO_S5K4ECGX)		+= s5k4ecgx.o
+obj-$(CONFIG_VIDEO_S5K5BAF)		+= s5k5baf.o
+obj-$(CONFIG_VIDEO_S5K6A3)		+= s5k6a3.o
+obj-$(CONFIG_VIDEO_S5K6AA)		+= s5k6aa.o
+obj-$(CONFIG_VIDEO_SAA6588)		+= saa6588.o
+obj-$(CONFIG_VIDEO_SAA6752HS)		+= saa6752hs.o
+obj-$(CONFIG_VIDEO_SAA7110)		+= saa7110.o
+obj-$(CONFIG_VIDEO_SAA711X)		+= saa7115.o
+obj-$(CONFIG_VIDEO_SAA7127)		+= saa7127.o
+obj-$(CONFIG_VIDEO_SAA717X)		+= saa717x.o
+obj-$(CONFIG_VIDEO_SAA7185)		+= saa7185.o
+obj-$(CONFIG_VIDEO_SMIAPP)		+= smiapp/
+obj-$(CONFIG_VIDEO_SMIAPP_PLL)		+= smiapp-pll.o
+obj-$(CONFIG_VIDEO_SONY_BTF_MPX)	+= sony-btf-mpx.o
+obj-$(CONFIG_VIDEO_SR030PC30)		+= sr030pc30.o
+obj-$(CONFIG_VIDEO_TC358743)		+= tc358743.o
+obj-$(CONFIG_VIDEO_TDA7432)		+= tda7432.o
+obj-$(CONFIG_VIDEO_TDA9840)		+= tda9840.o
+obj-$(CONFIG_VIDEO_TEA6415C)		+= tea6415c.o
+obj-$(CONFIG_VIDEO_TEA6420)		+= tea6420.o
+obj-$(CONFIG_VIDEO_THS7303)		+= ths7303.o
+obj-$(CONFIG_VIDEO_THS8200)		+= ths8200.o
+obj-$(CONFIG_VIDEO_TLV320AIC23B)	+= tlv320aic23b.o
+obj-$(CONFIG_VIDEO_TVAUDIO)		+= tvaudio.o
+obj-$(CONFIG_VIDEO_TVP514X)		+= tvp514x.o
+obj-$(CONFIG_VIDEO_TVP5150)		+= tvp5150.o
+obj-$(CONFIG_VIDEO_TVP7002)		+= tvp7002.o
+obj-$(CONFIG_VIDEO_TW2804)		+= tw2804.o
+obj-$(CONFIG_VIDEO_TW9903)		+= tw9903.o
+obj-$(CONFIG_VIDEO_TW9906)		+= tw9906.o
+obj-$(CONFIG_VIDEO_UDA1342)		+= uda1342.o
+obj-$(CONFIG_VIDEO_UPD64031A)		+= upd64031a.o
+obj-$(CONFIG_VIDEO_UPD64083)		+= upd64083.o
+obj-$(CONFIG_VIDEO_VP27SMPX)		+= vp27smpx.o
+obj-$(CONFIG_VIDEO_VPX3220)		+= vpx3220.o
+obj-$(CONFIG_VIDEO_VS6624) 		+= vs6624.o
+obj-$(CONFIG_VIDEO_WM8739)		+= wm8739.o
+obj-$(CONFIG_VIDEO_WM8775)		+= wm8775.o
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index a7e8af0f64a7..568fa35c21ec 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -15,20 +15,20 @@ obj-y        +=	ttpci/		\
 		smipcie/	\
 		netup_unidvb/
 
-obj-$(CONFIG_VIDEO_IVTV) += ivtv/
-obj-$(CONFIG_VIDEO_ZORAN) += zoran/
-obj-$(CONFIG_VIDEO_CX18) += cx18/
-obj-$(CONFIG_VIDEO_CX23885) += cx23885/
-obj-$(CONFIG_VIDEO_CX25821) += cx25821/
-obj-$(CONFIG_VIDEO_CX88) += cx88/
-obj-$(CONFIG_VIDEO_BT848) += bt8xx/
-obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
-obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
-obj-$(CONFIG_VIDEO_TW68) += tw68/
-obj-$(CONFIG_VIDEO_TW686X) += tw686x/
-obj-$(CONFIG_VIDEO_DT3155) += dt3155/
-obj-$(CONFIG_VIDEO_MEYE) += meye/
-obj-$(CONFIG_STA2X11_VIP) += sta2x11/
-obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
-obj-$(CONFIG_VIDEO_COBALT) += cobalt/
-obj-$(CONFIG_VIDEO_TW5864) += tw5864/
+obj-$(CONFIG_STA2X11_VIP)	+= sta2x11/
+obj-$(CONFIG_VIDEO_BT848)	+= bt8xx/
+obj-$(CONFIG_VIDEO_COBALT)	+= cobalt/
+obj-$(CONFIG_VIDEO_CX18)	+= cx18/
+obj-$(CONFIG_VIDEO_CX23885)	+= cx23885/
+obj-$(CONFIG_VIDEO_CX25821)	+= cx25821/
+obj-$(CONFIG_VIDEO_CX88)	+= cx88/
+obj-$(CONFIG_VIDEO_DT3155)	+= dt3155/
+obj-$(CONFIG_VIDEO_IVTV)	+= ivtv/
+obj-$(CONFIG_VIDEO_MEYE)	+= meye/
+obj-$(CONFIG_VIDEO_SAA7134)	+= saa7134/
+obj-$(CONFIG_VIDEO_SAA7164)	+= saa7164/
+obj-$(CONFIG_VIDEO_SOLO6X10)	+= solo6x10/
+obj-$(CONFIG_VIDEO_TW5864)	+= tw5864/
+obj-$(CONFIG_VIDEO_TW68)	+= tw68/
+obj-$(CONFIG_VIDEO_TW686X)	+= tw686x/
+obj-$(CONFIG_VIDEO_ZORAN)	+= zoran/
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 8959f6e6692a..880792785615 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -1,75 +1,47 @@
 #
 # Makefile for the video capture/playback device drivers.
 #
+ccflags-y += -I$(srctree)/drivers/media/i2c
 
-obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
-
-obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
-obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
-obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
-
-obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
-obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o
-
-obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
-
-obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
-obj-$(CONFIG_VIDEO_VIM2M)		+= vim2m.o
-
-obj-$(CONFIG_VIDEO_TI_VPE)		+= ti-vpe/
-
-obj-$(CONFIG_VIDEO_TI_CAL)		+= ti-vpe/
-
-obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
+obj-y					+= omap/
+obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
+obj-$(CONFIG_BLACKFIN)                  += blackfin/
+obj-$(CONFIG_DVB_C8SECTPFE)		+= sti/c8sectpfe/
+obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
+obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
+obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
+obj-$(CONFIG_VIDEO_CAFE_CCIC)		+= marvell-ccic/
 obj-$(CONFIG_VIDEO_CODA) 		+= coda/
-
-obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
-
+obj-$(CONFIG_VIDEO_M32R_AR_M64278)	+= arv.o
+obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
+obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
+obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
 obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
-
+obj-$(CONFIG_VIDEO_MMP_CAMERA)		+= marvell-ccic/
+obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
+obj-$(CONFIG_VIDEO_OMAP3)		+= omap3isp/
+obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
+obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar-vin/
+obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+= rcar-fcp.o
+obj-$(CONFIG_VIDEO_RENESAS_FDP1)	+= rcar_fdp1.o
+obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
+obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
-
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
-
+obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
+obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 obj-$(CONFIG_VIDEO_STI_BDISP)		+= sti/bdisp/
-obj-$(CONFIG_VIDEO_STI_HVA)		+= sti/hva/
-obj-$(CONFIG_DVB_C8SECTPFE)		+= sti/c8sectpfe/
-
 obj-$(CONFIG_VIDEO_STI_DELTA)		+= sti/delta/
-
-obj-$(CONFIG_BLACKFIN)                  += blackfin/
-
-obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
-
-obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
-
-obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
-
-obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+= rcar-fcp.o
-obj-$(CONFIG_VIDEO_RENESAS_FDP1)	+= rcar_fdp1.o
-obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
-obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
-
-obj-y	+= omap/
-
-obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
-
+obj-$(CONFIG_VIDEO_STI_HVA)		+= sti/hva/
+obj-$(CONFIG_VIDEO_TI_CAL)		+= ti-vpe/
+obj-$(CONFIG_VIDEO_TI_VPE)		+= ti-vpe/
+obj-$(CONFIG_VIDEO_VIA_CAMERA)		+= via-camera.o
+obj-$(CONFIG_VIDEO_VIM2M)		+= vim2m.o
+obj-$(CONFIG_VIDEO_VIU)			+= fsl-viu.o
+obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
 obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
-
-obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar-vin/
-
-obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
-
-ccflags-y += -I$(srctree)/drivers/media/i2c
-
-obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
-
-obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
-
-obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
-
-obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 120e791199b2..624f982759f8 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -2,37 +2,37 @@
 # Makefile for the kernel character device drivers.
 #
 
-obj-$(CONFIG_RADIO_ISA) += radio-isa.o
-obj-$(CONFIG_RADIO_AZTECH) += radio-aztech.o
-obj-$(CONFIG_RADIO_RTRACK2) += radio-rtrack2.o
-obj-$(CONFIG_RADIO_SF16FMI) += radio-sf16fmi.o
-obj-$(CONFIG_RADIO_SF16FMR2) += radio-sf16fmr2.o
-obj-$(CONFIG_RADIO_CADET) += radio-cadet.o
-obj-$(CONFIG_RADIO_TYPHOON) += radio-typhoon.o
-obj-$(CONFIG_RADIO_TERRATEC) += radio-terratec.o
-obj-$(CONFIG_RADIO_MAXIRADIO) += radio-maxiradio.o
-obj-$(CONFIG_RADIO_SHARK) += radio-shark.o
-obj-$(CONFIG_RADIO_SHARK2) += shark2.o
-obj-$(CONFIG_RADIO_RTRACK) += radio-aimslab.o
-obj-$(CONFIG_RADIO_ZOLTRIX) += radio-zoltrix.o
-obj-$(CONFIG_RADIO_GEMTEK) += radio-gemtek.o
-obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
-obj-$(CONFIG_RADIO_SI476X) += radio-si476x.o
-obj-$(CONFIG_RADIO_MIROPCM20) += radio-miropcm20.o
-obj-$(CONFIG_USB_DSBR) += dsbr100.o
-obj-$(CONFIG_RADIO_SI470X) += si470x/
-obj-$(CONFIG_RADIO_SI4713) += si4713/
-obj-$(CONFIG_USB_MR800) += radio-mr800.o
-obj-$(CONFIG_USB_KEENE) += radio-keene.o
-obj-$(CONFIG_USB_MA901) += radio-ma901.o
-obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
-obj-$(CONFIG_RADIO_SAA7706H) += saa7706h.o
-obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
-obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
-obj-$(CONFIG_RADIO_WL1273) += radio-wl1273.o
-obj-$(CONFIG_RADIO_WL128X) += wl128x/
-obj-$(CONFIG_RADIO_TEA575X) += tea575x.o
-obj-$(CONFIG_USB_RAREMONO) += radio-raremono.o
+obj-$(CONFIG_RADIO_AZTECH)	+= radio-aztech.o
+obj-$(CONFIG_RADIO_CADET)	+= radio-cadet.o
+obj-$(CONFIG_RADIO_GEMTEK)	+= radio-gemtek.o
+obj-$(CONFIG_RADIO_ISA)		+= radio-isa.o
+obj-$(CONFIG_RADIO_MAXIRADIO)	+= radio-maxiradio.o
+obj-$(CONFIG_RADIO_MIROPCM20)	+= radio-miropcm20.o
+obj-$(CONFIG_RADIO_RTRACK)	+= radio-aimslab.o
+obj-$(CONFIG_RADIO_RTRACK2)	+= radio-rtrack2.o
+obj-$(CONFIG_RADIO_SAA7706H)	+= saa7706h.o
+obj-$(CONFIG_RADIO_SF16FMI)	+= radio-sf16fmi.o
+obj-$(CONFIG_RADIO_SF16FMR2)	+= radio-sf16fmr2.o
+obj-$(CONFIG_RADIO_SHARK)	+= radio-shark.o
+obj-$(CONFIG_RADIO_SHARK2)	+= shark2.o
+obj-$(CONFIG_RADIO_SI470X)	+= si470x/
+obj-$(CONFIG_RADIO_SI4713)	+= si4713/
+obj-$(CONFIG_RADIO_SI476X)	+= radio-si476x.o
+obj-$(CONFIG_RADIO_TEA575X)	+= tea575x.o
+obj-$(CONFIG_RADIO_TEA5764)	+= radio-tea5764.o
+obj-$(CONFIG_RADIO_TEF6862)	+= tef6862.o
+obj-$(CONFIG_RADIO_TERRATEC)	+= radio-terratec.o
+obj-$(CONFIG_RADIO_TIMBERDALE)	+= radio-timb.o
+obj-$(CONFIG_RADIO_TRUST)	+= radio-trust.o
+obj-$(CONFIG_RADIO_TYPHOON)	+= radio-typhoon.o
+obj-$(CONFIG_RADIO_WL1273)	+= radio-wl1273.o
+obj-$(CONFIG_RADIO_WL128X)	+= wl128x/
+obj-$(CONFIG_RADIO_ZOLTRIX)	+= radio-zoltrix.o
+obj-$(CONFIG_USB_DSBR)		+= dsbr100.o
+obj-$(CONFIG_USB_KEENE)		+= radio-keene.o
+obj-$(CONFIG_USB_MA901)		+= radio-ma901.o
+obj-$(CONFIG_USB_MR800)		+= radio-mr800.o
+obj-$(CONFIG_USB_RAREMONO)	+= radio-raremono.o
 
 shark2-objs := radio-shark2.o radio-tea5777.o
 
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 245e2c2d0b22..a4f6154a887e 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -2,42 +2,42 @@ rc-core-objs	:= rc-main.o rc-ir-raw.o
 
 obj-y += keymaps/
 
-obj-$(CONFIG_RC_CORE) += rc-core.o
-obj-$(CONFIG_LIRC) += lirc_dev.o
-obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
-obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
-obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
-obj-$(CONFIG_IR_JVC_DECODER) += ir-jvc-decoder.o
-obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
-obj-$(CONFIG_IR_SANYO_DECODER) += ir-sanyo-decoder.o
-obj-$(CONFIG_IR_SHARP_DECODER) += ir-sharp-decoder.o
-obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
-obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
-obj-$(CONFIG_IR_XMP_DECODER) += ir-xmp-decoder.o
+obj-$(CONFIG_IR_JVC_DECODER)		+= ir-jvc-decoder.o
+obj-$(CONFIG_IR_LIRC_CODEC)		+= ir-lirc-codec.o
+obj-$(CONFIG_IR_MCE_KBD_DECODER)	+= ir-mce_kbd-decoder.o
+obj-$(CONFIG_IR_NEC_DECODER)		+= ir-nec-decoder.o
+obj-$(CONFIG_IR_RC5_DECODER)		+= ir-rc5-decoder.o
+obj-$(CONFIG_IR_RC6_DECODER)		+= ir-rc6-decoder.o
+obj-$(CONFIG_IR_SANYO_DECODER)		+= ir-sanyo-decoder.o
+obj-$(CONFIG_IR_SHARP_DECODER)		+= ir-sharp-decoder.o
+obj-$(CONFIG_IR_SONY_DECODER)		+= ir-sony-decoder.o
+obj-$(CONFIG_IR_XMP_DECODER)		+= ir-xmp-decoder.o
+obj-$(CONFIG_LIRC)			+= lirc_dev.o
+obj-$(CONFIG_RC_CORE)			+= rc-core.o
 
 # stand-alone IR receivers/transmitters
-obj-$(CONFIG_RC_ATI_REMOTE) += ati_remote.o
-obj-$(CONFIG_IR_HIX5HD2) += ir-hix5hd2.o
-obj-$(CONFIG_IR_IMON) += imon.o
-obj-$(CONFIG_IR_ITE_CIR) += ite-cir.o
-obj-$(CONFIG_IR_MCEUSB) += mceusb.o
-obj-$(CONFIG_IR_FINTEK) += fintek-cir.o
-obj-$(CONFIG_IR_MESON) += meson-ir.o
-obj-$(CONFIG_IR_NUVOTON) += nuvoton-cir.o
-obj-$(CONFIG_IR_ENE) += ene_ir.o
-obj-$(CONFIG_IR_REDRAT3) += redrat3.o
-obj-$(CONFIG_IR_RX51) += ir-rx51.o
-obj-$(CONFIG_IR_SPI) += ir-spi.o
-obj-$(CONFIG_IR_STREAMZAP) += streamzap.o
-obj-$(CONFIG_IR_WINBOND_CIR) += winbond-cir.o
-obj-$(CONFIG_RC_LOOPBACK) += rc-loopback.o
-obj-$(CONFIG_IR_GPIO_CIR) += gpio-ir-recv.o
-obj-$(CONFIG_IR_IGORPLUGUSB) += igorplugusb.o
-obj-$(CONFIG_IR_IGUANA) += iguanair.o
-obj-$(CONFIG_IR_TTUSBIR) += ttusbir.o
-obj-$(CONFIG_RC_ST) += st_rc.o
-obj-$(CONFIG_IR_SUNXI) += sunxi-cir.o
-obj-$(CONFIG_IR_IMG) += img-ir/
-obj-$(CONFIG_IR_SERIAL) += serial_ir.o
-obj-$(CONFIG_IR_SIR) += sir_ir.o
-obj-$(CONFIG_IR_MTK) += mtk-cir.o
+obj-$(CONFIG_IR_ENE)			+= ene_ir.o
+obj-$(CONFIG_IR_FINTEK)			+= fintek-cir.o
+obj-$(CONFIG_IR_GPIO_CIR)		+= gpio-ir-recv.o
+obj-$(CONFIG_IR_HIX5HD2)		+= ir-hix5hd2.o
+obj-$(CONFIG_IR_IGORPLUGUSB)		+= igorplugusb.o
+obj-$(CONFIG_IR_IGUANA)			+= iguanair.o
+obj-$(CONFIG_IR_IMG)			+= img-ir/
+obj-$(CONFIG_IR_IMON)			+= imon.o
+obj-$(CONFIG_IR_ITE_CIR)		+= ite-cir.o
+obj-$(CONFIG_IR_MCEUSB)			+= mceusb.o
+obj-$(CONFIG_IR_MESON)			+= meson-ir.o
+obj-$(CONFIG_IR_MTK)			+= mtk-cir.o
+obj-$(CONFIG_IR_NUVOTON)		+= nuvoton-cir.o
+obj-$(CONFIG_IR_REDRAT3)		+= redrat3.o
+obj-$(CONFIG_IR_RX51)			+= ir-rx51.o
+obj-$(CONFIG_IR_SERIAL)			+= serial_ir.o
+obj-$(CONFIG_IR_SIR)			+= sir_ir.o
+obj-$(CONFIG_IR_SPI)			+= ir-spi.o
+obj-$(CONFIG_IR_STREAMZAP)		+= streamzap.o
+obj-$(CONFIG_IR_SUNXI)			+= sunxi-cir.o
+obj-$(CONFIG_IR_TTUSBIR)		+= ttusbir.o
+obj-$(CONFIG_IR_WINBOND_CIR)		+= winbond-cir.o
+obj-$(CONFIG_RC_ATI_REMOTE)		+= ati_remote.o
+obj-$(CONFIG_RC_LOOPBACK)		+= rc-loopback.o
+obj-$(CONFIG_RC_ST)			+= st_rc.o
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index 06a9ab65e5fa..96e5f89e5c08 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -4,43 +4,44 @@
 
 tda18271-objs := tda18271-maps.o tda18271-common.o tda18271-fe.o
 
-obj-$(CONFIG_MEDIA_TUNER_XC2028) += tuner-xc2028.o
-obj-$(CONFIG_MEDIA_TUNER_SIMPLE) += tuner-simple.o
+obj-$(CONFIG_MEDIA_TUNER_SIMPLE)	+= tuner-simple.o
+obj-$(CONFIG_MEDIA_TUNER_XC2028)	+= tuner-xc2028.o
+
 # tuner-types will be merged into tuner-simple, in the future
-obj-$(CONFIG_MEDIA_TUNER_SIMPLE) += tuner-types.o
-obj-$(CONFIG_MEDIA_TUNER_MT20XX) += mt20xx.o
-obj-$(CONFIG_MEDIA_TUNER_TDA8290) += tda8290.o
-obj-$(CONFIG_MEDIA_TUNER_TEA5767) += tea5767.o
-obj-$(CONFIG_MEDIA_TUNER_TEA5761) += tea5761.o
-obj-$(CONFIG_MEDIA_TUNER_TDA9887) += tda9887.o
-obj-$(CONFIG_MEDIA_TUNER_TDA827X) += tda827x.o
-obj-$(CONFIG_MEDIA_TUNER_TDA18271) += tda18271.o
-obj-$(CONFIG_MEDIA_TUNER_XC5000) += xc5000.o
-obj-$(CONFIG_MEDIA_TUNER_XC4000) += xc4000.o
-obj-$(CONFIG_MEDIA_TUNER_MSI001) += msi001.o
-obj-$(CONFIG_MEDIA_TUNER_MT2060) += mt2060.o
-obj-$(CONFIG_MEDIA_TUNER_MT2063) += mt2063.o
-obj-$(CONFIG_MEDIA_TUNER_MT2266) += mt2266.o
-obj-$(CONFIG_MEDIA_TUNER_QT1010) += qt1010.o
-obj-$(CONFIG_MEDIA_TUNER_MT2131) += mt2131.o
-obj-$(CONFIG_MEDIA_TUNER_MXL5005S) += mxl5005s.o
-obj-$(CONFIG_MEDIA_TUNER_MXL5007T) += mxl5007t.o
-obj-$(CONFIG_MEDIA_TUNER_MC44S803) += mc44s803.o
-obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
-obj-$(CONFIG_MEDIA_TUNER_TDA18218) += tda18218.o
-obj-$(CONFIG_MEDIA_TUNER_TDA18212) += tda18212.o
-obj-$(CONFIG_MEDIA_TUNER_E4000) += e4000.o
-obj-$(CONFIG_MEDIA_TUNER_FC2580) += fc2580.o
-obj-$(CONFIG_MEDIA_TUNER_TUA9001) += tua9001.o
-obj-$(CONFIG_MEDIA_TUNER_SI2157) += si2157.o
-obj-$(CONFIG_MEDIA_TUNER_FC0011) += fc0011.o
-obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
-obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
-obj-$(CONFIG_MEDIA_TUNER_IT913X) += it913x.o
-obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
-obj-$(CONFIG_MEDIA_TUNER_MXL301RF) += mxl301rf.o
-obj-$(CONFIG_MEDIA_TUNER_QM1D1C0042) += qm1d1c0042.o
-obj-$(CONFIG_MEDIA_TUNER_M88RS6000T) += m88rs6000t.o
+obj-$(CONFIG_MEDIA_TUNER_E4000)		+= e4000.o
+obj-$(CONFIG_MEDIA_TUNER_FC0011)	+= fc0011.o
+obj-$(CONFIG_MEDIA_TUNER_FC0012)	+= fc0012.o
+obj-$(CONFIG_MEDIA_TUNER_FC0013)	+= fc0013.o
+obj-$(CONFIG_MEDIA_TUNER_FC2580)	+= fc2580.o
+obj-$(CONFIG_MEDIA_TUNER_IT913X)	+= it913x.o
+obj-$(CONFIG_MEDIA_TUNER_M88RS6000T)	+= m88rs6000t.o
+obj-$(CONFIG_MEDIA_TUNER_MAX2165)	+= max2165.o
+obj-$(CONFIG_MEDIA_TUNER_MC44S803)	+= mc44s803.o
+obj-$(CONFIG_MEDIA_TUNER_MSI001)	+= msi001.o
+obj-$(CONFIG_MEDIA_TUNER_MT2060)	+= mt2060.o
+obj-$(CONFIG_MEDIA_TUNER_MT2063)	+= mt2063.o
+obj-$(CONFIG_MEDIA_TUNER_MT20XX)	+= mt20xx.o
+obj-$(CONFIG_MEDIA_TUNER_MT2131)	+= mt2131.o
+obj-$(CONFIG_MEDIA_TUNER_MT2266)	+= mt2266.o
+obj-$(CONFIG_MEDIA_TUNER_MXL301RF)	+= mxl301rf.o
+obj-$(CONFIG_MEDIA_TUNER_MXL5005S)	+= mxl5005s.o
+obj-$(CONFIG_MEDIA_TUNER_MXL5007T)	+= mxl5007t.o
+obj-$(CONFIG_MEDIA_TUNER_QM1D1C0042)	+= qm1d1c0042.o
+obj-$(CONFIG_MEDIA_TUNER_QT1010)	+= qt1010.o
+obj-$(CONFIG_MEDIA_TUNER_R820T)		+= r820t.o
+obj-$(CONFIG_MEDIA_TUNER_SI2157)	+= si2157.o
+obj-$(CONFIG_MEDIA_TUNER_SIMPLE)	+= tuner-types.o
+obj-$(CONFIG_MEDIA_TUNER_TDA18212)	+= tda18212.o
+obj-$(CONFIG_MEDIA_TUNER_TDA18218)	+= tda18218.o
+obj-$(CONFIG_MEDIA_TUNER_TDA18271)	+= tda18271.o
+obj-$(CONFIG_MEDIA_TUNER_TDA827X)	+= tda827x.o
+obj-$(CONFIG_MEDIA_TUNER_TDA8290)	+= tda8290.o
+obj-$(CONFIG_MEDIA_TUNER_TDA9887)	+= tda9887.o
+obj-$(CONFIG_MEDIA_TUNER_TEA5761)	+= tea5761.o
+obj-$(CONFIG_MEDIA_TUNER_TEA5767)	+= tea5767.o
+obj-$(CONFIG_MEDIA_TUNER_TUA9001)	+= tua9001.o
+obj-$(CONFIG_MEDIA_TUNER_XC4000)	+= xc4000.o
+obj-$(CONFIG_MEDIA_TUNER_XC5000)	+= xc5000.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 0f15e3351ddc..1bc9a6218afa 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -6,22 +6,22 @@
 obj-y += ttusb-dec/ ttusb-budget/ dvb-usb/ dvb-usb-v2/ siano/ b2c2/
 obj-y += zr364xx/ stkwebcam/ s2255/
 
+obj-$(CONFIG_DVB_AS102)		+= as102/
+obj-$(CONFIG_USB_AIRSPY)	+= airspy/
+obj-$(CONFIG_USB_GSPCA)		+= gspca/
+obj-$(CONFIG_USB_HACKRF)	+= hackrf/
+obj-$(CONFIG_USB_MSI2500)	+= msi2500/
+obj-$(CONFIG_USB_PULSE8_CEC)	+= pulse8-cec/
+obj-$(CONFIG_USB_PWC)		+= pwc/
 obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
-obj-$(CONFIG_USB_GSPCA)         += gspca/
-obj-$(CONFIG_USB_PWC)           += pwc/
-obj-$(CONFIG_USB_AIRSPY)        += airspy/
-obj-$(CONFIG_USB_HACKRF)        += hackrf/
-obj-$(CONFIG_USB_MSI2500)       += msi2500/
-obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
-obj-$(CONFIG_VIDEO_AU0828) += au0828/
+obj-$(CONFIG_VIDEO_AU0828)	+= au0828/
+obj-$(CONFIG_VIDEO_CPIA2)	+= cpia2/
+obj-$(CONFIG_VIDEO_CX231XX)	+= cx231xx/
+obj-$(CONFIG_VIDEO_EM28XX)	+= em28xx/
+obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
 obj-$(CONFIG_VIDEO_HDPVR)	+= hdpvr/
-obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
-obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
-obj-$(CONFIG_VIDEO_STK1160) += stk1160/
-obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
-obj-$(CONFIG_VIDEO_TM6000) += tm6000/
-obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
-obj-$(CONFIG_VIDEO_USBTV) += usbtv/
-obj-$(CONFIG_VIDEO_GO7007) += go7007/
-obj-$(CONFIG_DVB_AS102) += as102/
-obj-$(CONFIG_USB_PULSE8_CEC) += pulse8-cec/
+obj-$(CONFIG_VIDEO_PVRUSB2)	+= pvrusb2/
+obj-$(CONFIG_VIDEO_STK1160)	+= stk1160/
+obj-$(CONFIG_VIDEO_TM6000)	+= tm6000/
+obj-$(CONFIG_VIDEO_USBTV)	+= usbtv/
+obj-$(CONFIG_VIDEO_USBVISION)	+= usbvision/
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 795a5352761d..c5ddce79c6d1 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -16,30 +16,30 @@ endif
 ifeq ($(CONFIG_TRACEPOINTS),y)
   videodev-objs += vb2-trace.o v4l2-trace.o
 endif
-videodev-$(CONFIG_MEDIA_CONTROLLER) += v4l2-mc.o
+videodev-$(CONFIG_MEDIA_CONTROLLER)	+= v4l2-mc.o
 
-obj-$(CONFIG_VIDEO_V4L2) += videodev.o
-obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
-obj-$(CONFIG_VIDEO_V4L2) += v4l2-dv-timings.o
+obj-$(CONFIG_V4L2_MEM2MEM_DEV)		+= v4l2-mem2mem.o
 
-obj-$(CONFIG_VIDEO_TUNER) += tuner.o
+obj-$(CONFIG_V4L2_FLASH_LED_CLASS)	+= v4l2-flash-led-class.o
 
-obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
+obj-$(CONFIG_VIDEO_TUNER)		+= tuner.o
 
-obj-$(CONFIG_V4L2_FLASH_LED_CLASS) += v4l2-flash-led-class.o
+obj-$(CONFIG_VIDEO_V4L2)		+= videodev.o
+obj-$(CONFIG_VIDEO_V4L2)		+= v4l2-common.o
+obj-$(CONFIG_VIDEO_V4L2)		+= v4l2-dv-timings.o
 
-obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
-obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
-obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
-obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
-obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
+obj-$(CONFIG_VIDEOBUF_DMA_CONTIG)	+= videobuf-dma-contig.o
+obj-$(CONFIG_VIDEOBUF_DMA_SG)		+= videobuf-dma-sg.o
+obj-$(CONFIG_VIDEOBUF_DVB)		+= videobuf-dvb.o
+obj-$(CONFIG_VIDEOBUF_GEN)		+= videobuf-core.o
+obj-$(CONFIG_VIDEOBUF_VMALLOC)		+= videobuf-vmalloc.o
 
-obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o videobuf2-v4l2.o
-obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
-obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
-obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
-obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
-obj-$(CONFIG_VIDEOBUF2_DVB) += videobuf2-dvb.o
+obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o videobuf2-v4l2.o
+obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG)	+= videobuf2-dma-contig.o
+obj-$(CONFIG_VIDEOBUF2_DMA_SG)		+= videobuf2-dma-sg.o
+obj-$(CONFIG_VIDEOBUF2_DVB)		+= videobuf2-dvb.o
+obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
+obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
-- 
2.11.0
