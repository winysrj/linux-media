Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34033 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbbKSIkm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 03:40:42 -0500
Date: Thu, 19 Nov 2015 06:40:37 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Fw: [PATCH] [media] tda10023: fix wrong register assignment
Message-ID: <20151119064037.5de24284@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti,

Could you please review this patch?

Thanks!
Mauro

Forwarded message:

Date: Tue, 8 Sep 2015 09:43:04 +0200
From: Manuel Kampert <manuel.kampert@googlemail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] tda10023: fix wrong register assignment


Register INTP1 (0x12) Bit POCLKP (bit 0) sets the output clock polarity 
of tda10023 . However, the driver tries to set the parallel output mode 
in this register which is not correct.

Parallel output mode is set on register INTP2 (0x20) INTPSEL (bit 1/0) .

Drivers affected by this patch are the anysee devices.

Signed-off-by: Manuel Kampert <manuel.kampert@googlemail.com>
---
diff --git a/drivers/media/dvb-frontends/tda10023.c 
b/drivers/media/dvb-frontends/tda10023.c

--- a/drivers/media/dvb-frontends/tda10023.c
+++ b/drivers/media/dvb-frontends/tda10023.c
@@ -269,10 +269,9 @@ static int tda10023_init (struct dvb_frontend *fe)
/* 084 */ 0x02, 0xff, 0x93, /* AGCCONF1 IFS=1 KAGCIF=2 KAGCTUN=3 */
/* 087 */ 0x2d, 0xff, 0xf6, /* SWEEP SWPOS=1 SWDYN=7 SWSTEP=1 SWLEN=2 */
/* 090 */ 0x04, 0x10, 0x00, /* SWRAMP=1 */
-/* 093 */ 0x12, 0xff, TDA10023_OUTPUT_MODE_PARALLEL_B, /*
- INTP1 POCLKP=1 FEL=1 MFS=0 */
+/* 093 */ 0x12, 0xff, 0xa1, /* POCLKP=1 */
/* 096 */ 0x2b, 0x01, 0xa1, /* INTS1 */
-/* 099 */ 0x20, 0xff, 0x04, /* INTP2 SWAPP=? MSBFIRSTP=? INTPSEL=? */
+/* 099 */ 0x20, 0xff, TDA10023_OUTPUT_MODE_PARALLEL_B, /* INTPSEL=? */
/* 102 */ 0x2c, 0xff, 0x0d, /* INTP/S TRIP=0 TRIS=0 */
/* 105 */ 0xc4, 0xff, 0x00,
/* 108 */ 0xc3, 0x30, 0x00,
@@ -291,7 +290,7 @@ static int tda10023_init (struct dvb_frontend *fe)
}

if (state->config->output_mode)
- tda10023_inittab[95] = state->config->output_mode;
+ tda10023_inittab[101] = state->config->output_mode;

tda10023_writetab(state, tda10023_inittab);

diff --git a/drivers/media/dvb-frontends/tda1002x.h 
b/drivers/media/dvb-frontends/tda1002x.h
index 0d33461..dc7258f 100644
--- a/drivers/media/dvb-frontends/tda1002x.h
+++ b/drivers/media/dvb-frontends/tda1002x.h
@@ -33,9 +33,9 @@ struct tda1002x_config {
};

enum tda10023_output_mode {
- TDA10023_OUTPUT_MODE_PARALLEL_A = 0xe0,
- TDA10023_OUTPUT_MODE_PARALLEL_B = 0xa1,
- TDA10023_OUTPUT_MODE_PARALLEL_C = 0xa0,
+ TDA10023_OUTPUT_MODE_PARALLEL_A = 0x04,
+ TDA10023_OUTPUT_MODE_PARALLEL_B = 0x05,
+ TDA10023_OUTPUT_MODE_PARALLEL_C = 0x06,
TDA10023_OUTPUT_MODE_SERIAL, /* TODO: not implemented */
};

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c 
b/drivers/media/usb/dvb-usb-v2/anysee.c
index ae917c0..698a1d2 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -291,7 +291,6 @@ static struct tda10023_config anysee_tda10023_config = {
.pll_m = 11,
.pll_p = 3,
.pll_n = 1,
- .output_mode = TDA10023_OUTPUT_MODE_PARALLEL_C,
.deltaf = 0xfeeb,
};

@@ -327,7 +326,6 @@ static struct tda10023_config 
anysee_tda10023_tda18212_config = {
.pll_m = 12,
.pll_p = 3,
.pll_n = 1,
- .output_mode = TDA10023_OUTPUT_MODE_PARALLEL_B,
.deltaf = 0xba02,
};

@@ -781,6 +779,11 @@ static int anysee_frontend_attach(struct 
dvb_usb_adapter *adap)
adap->fe[0] = dvb_attach(tda10023_attach,
&anysee_tda10023_config, &d->i2c_adap, 0x48);

+ /* output clock polarity */
+ ret = anysee_write_reg(d, 0x12, 0xa0);
+ if (ret)
+ goto error;
+
break;
case ANYSEE_HW_507SI: /* 11 */
/* E30 S2 Plus */
@@ -846,6 +849,11 @@ static int anysee_frontend_attach(struct 
dvb_usb_adapter *adap)
adap->fe[0] = dvb_attach(tda10023_attach,
&anysee_tda10023_config,
&d->i2c_adap, 0x48);
+
+ /* output clock polarity */
+ ret = anysee_write_reg(d, 0x12, 0xa0);
+ if (ret)
+ goto error;
}

/* break out if first frontend attaching fails */
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
