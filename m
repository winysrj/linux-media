Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33913 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab3CJCEm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:42 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 31/41] af9033: add IT9135 tuner config "52" init table
Date: Sun, 10 Mar 2013 04:03:23 +0200
Message-Id: <1362881013-5271-31-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dumped out from the Windows driver version 12.07.06.1

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c      |   3 +
 drivers/media/dvb-frontends/af9033_priv.h | 217 ++++++++++++++++++++++++++++++
 2 files changed, 220 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index d6fc566..920c875 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -355,6 +355,9 @@ static int af9033_init(struct dvb_frontend *fe)
 		init = tuner_init_it9135_51;
 		break;
 	case AF9033_TUNER_IT9135_52:
+		len = ARRAY_SIZE(tuner_init_it9135_52);
+		init = tuner_init_it9135_52;
+		break;
 	case AF9033_TUNER_IT9135_60:
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index 5e35ef6..01844d5 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -1092,6 +1092,223 @@ static const struct reg_val tuner_init_it9135_51[] = {
 	{ 0x80fd8b, 0x00 },
 };
 
+/* ITE Tech IT9135 Omega LNA config 2 tuner init
+   AF9033_TUNER_IT9135_52   = 0x52 */
+static const struct reg_val tuner_init_it9135_52[] = {
+	{ 0x800043, 0x00 },
+	{ 0x800046, 0x52 },
+	{ 0x800051, 0x01 },
+	{ 0x80005f, 0x00 },
+	{ 0x800060, 0x00 },
+	{ 0x800068, 0x10 },
+	{ 0x800070, 0x0a },
+	{ 0x800071, 0x05 },
+	{ 0x800072, 0x02 },
+	{ 0x800075, 0x8c },
+	{ 0x800076, 0x8c },
+	{ 0x800077, 0x8c },
+	{ 0x800078, 0xa0 },
+	{ 0x800079, 0x01 },
+	{ 0x80007e, 0x04 },
+	{ 0x80007f, 0x00 },
+	{ 0x800081, 0x0a },
+	{ 0x800082, 0x17 },
+	{ 0x800083, 0x03 },
+	{ 0x800084, 0x0a },
+	{ 0x800085, 0x03 },
+	{ 0x800086, 0xb3 },
+	{ 0x800087, 0x97 },
+	{ 0x800088, 0xc0 },
+	{ 0x800089, 0x9e },
+	{ 0x80008a, 0x01 },
+	{ 0x80008e, 0x01 },
+	{ 0x800092, 0x06 },
+	{ 0x800093, 0x00 },
+	{ 0x800094, 0x00 },
+	{ 0x800095, 0x00 },
+	{ 0x800096, 0x00 },
+	{ 0x800099, 0x01 },
+	{ 0x80009b, 0x3c },
+	{ 0x80009c, 0x28 },
+	{ 0x80009f, 0xe1 },
+	{ 0x8000a0, 0xcf },
+	{ 0x8000a3, 0x01 },
+	{ 0x8000a4, 0x5c },
+	{ 0x8000a5, 0x01 },
+	{ 0x8000a6, 0x01 },
+	{ 0x8000a9, 0x00 },
+	{ 0x8000aa, 0x01 },
+	{ 0x8000b0, 0x01 },
+	{ 0x8000b3, 0x02 },
+	{ 0x8000b4, 0x3c },
+	{ 0x8000b6, 0x14 },
+	{ 0x8000c0, 0x11 },
+	{ 0x8000c1, 0x00 },
+	{ 0x8000c2, 0x05 },
+	{ 0x8000c4, 0x00 },
+	{ 0x8000c6, 0x19 },
+	{ 0x8000c7, 0x00 },
+	{ 0x8000cc, 0x2e },
+	{ 0x8000cd, 0x51 },
+	{ 0x8000ce, 0x33 },
+	{ 0x8000f3, 0x05 },
+	{ 0x8000f4, 0x91 },
+	{ 0x8000f5, 0x8c },
+	{ 0x8000f8, 0x03 },
+	{ 0x8000f9, 0x06 },
+	{ 0x8000fa, 0x06 },
+	{ 0x8000fc, 0x03 },
+	{ 0x8000fd, 0x02 },
+	{ 0x8000fe, 0x02 },
+	{ 0x8000ff, 0x09 },
+	{ 0x800100, 0x50 },
+	{ 0x800101, 0x74 },
+	{ 0x800102, 0x77 },
+	{ 0x800103, 0x02 },
+	{ 0x800104, 0x02 },
+	{ 0x800105, 0xa4 },
+	{ 0x800106, 0x02 },
+	{ 0x800107, 0x6e },
+	{ 0x800109, 0x02 },
+	{ 0x800115, 0x0a },
+	{ 0x800116, 0x03 },
+	{ 0x800117, 0x02 },
+	{ 0x800118, 0x80 },
+	{ 0x80011a, 0xcd },
+	{ 0x80011b, 0x62 },
+	{ 0x80011c, 0xa4 },
+	{ 0x80011d, 0x8c },
+	{ 0x800122, 0x03 },
+	{ 0x800123, 0x18 },
+	{ 0x800124, 0x9e },
+	{ 0x800127, 0x00 },
+	{ 0x800128, 0x07 },
+	{ 0x80012a, 0x53 },
+	{ 0x80012b, 0x51 },
+	{ 0x80012c, 0x4e },
+	{ 0x80012d, 0x43 },
+	{ 0x800137, 0x00 },
+	{ 0x800138, 0x00 },
+	{ 0x800139, 0x07 },
+	{ 0x80013a, 0x00 },
+	{ 0x80013b, 0x06 },
+	{ 0x80013d, 0x00 },
+	{ 0x80013e, 0x01 },
+	{ 0x80013f, 0x5b },
+	{ 0x800140, 0xb6 },
+	{ 0x800141, 0x59 },
+	{ 0x80f000, 0x0f },
+	{ 0x80f016, 0x10 },
+	{ 0x80f017, 0x04 },
+	{ 0x80f018, 0x05 },
+	{ 0x80f019, 0x04 },
+	{ 0x80f01a, 0x05 },
+	{ 0x80f01f, 0x8c },
+	{ 0x80f020, 0x00 },
+	{ 0x80f021, 0x03 },
+	{ 0x80f022, 0x0a },
+	{ 0x80f023, 0x0a },
+	{ 0x80f029, 0x8c },
+	{ 0x80f02a, 0x00 },
+	{ 0x80f02b, 0x00 },
+	{ 0x80f02c, 0x01 },
+	{ 0x80f064, 0x03 },
+	{ 0x80f065, 0xf9 },
+	{ 0x80f066, 0x03 },
+	{ 0x80f067, 0x01 },
+	{ 0x80f06f, 0xe0 },
+	{ 0x80f070, 0x03 },
+	{ 0x80f072, 0x0f },
+	{ 0x80f073, 0x03 },
+	{ 0x80f077, 0x01 },
+	{ 0x80f078, 0x00 },
+	{ 0x80f085, 0xc0 },
+	{ 0x80f086, 0x01 },
+	{ 0x80f087, 0x00 },
+	{ 0x80f09b, 0x3f },
+	{ 0x80f09c, 0x00 },
+	{ 0x80f09d, 0x20 },
+	{ 0x80f09e, 0x00 },
+	{ 0x80f09f, 0x0c },
+	{ 0x80f0a0, 0x00 },
+	{ 0x80f130, 0x04 },
+	{ 0x80f132, 0x04 },
+	{ 0x80f144, 0x1a },
+	{ 0x80f146, 0x00 },
+	{ 0x80f14a, 0x01 },
+	{ 0x80f14c, 0x00 },
+	{ 0x80f14d, 0x00 },
+	{ 0x80f14f, 0x04 },
+	{ 0x80f158, 0x7f },
+	{ 0x80f15a, 0x00 },
+	{ 0x80f15b, 0x08 },
+	{ 0x80f15d, 0x03 },
+	{ 0x80f15e, 0x05 },
+	{ 0x80f163, 0x05 },
+	{ 0x80f166, 0x01 },
+	{ 0x80f167, 0x40 },
+	{ 0x80f168, 0x0f },
+	{ 0x80f17a, 0x00 },
+	{ 0x80f17b, 0x00 },
+	{ 0x80f183, 0x01 },
+	{ 0x80f19d, 0x40 },
+	{ 0x80f1bc, 0x36 },
+	{ 0x80f1bd, 0x00 },
+	{ 0x80f1cb, 0xa0 },
+	{ 0x80f1cc, 0x01 },
+	{ 0x80f204, 0x10 },
+	{ 0x80f214, 0x00 },
+	{ 0x80f24c, 0x88 },
+	{ 0x80f24d, 0x95 },
+	{ 0x80f24e, 0x9a },
+	{ 0x80f24f, 0x90 },
+	{ 0x80f25a, 0x07 },
+	{ 0x80f25b, 0xe8 },
+	{ 0x80f25c, 0x03 },
+	{ 0x80f25d, 0xb0 },
+	{ 0x80f25e, 0x04 },
+	{ 0x80f270, 0x01 },
+	{ 0x80f271, 0x02 },
+	{ 0x80f272, 0x01 },
+	{ 0x80f273, 0x02 },
+	{ 0x80f40e, 0x0a },
+	{ 0x80f40f, 0x40 },
+	{ 0x80f410, 0x08 },
+	{ 0x80f55f, 0x0a },
+	{ 0x80f561, 0x15 },
+	{ 0x80f562, 0x20 },
+	{ 0x80f5df, 0xfb },
+	{ 0x80f5e0, 0x00 },
+	{ 0x80f5e3, 0x09 },
+	{ 0x80f5e4, 0x01 },
+	{ 0x80f5e5, 0x01 },
+	{ 0x80f5f8, 0x01 },
+	{ 0x80f5fd, 0x01 },
+	{ 0x80f600, 0x05 },
+	{ 0x80f601, 0x08 },
+	{ 0x80f602, 0x0b },
+	{ 0x80f603, 0x0e },
+	{ 0x80f604, 0x11 },
+	{ 0x80f605, 0x14 },
+	{ 0x80f606, 0x17 },
+	{ 0x80f607, 0x1f },
+	{ 0x80f60e, 0x00 },
+	{ 0x80f60f, 0x04 },
+	{ 0x80f610, 0x32 },
+	{ 0x80f611, 0x10 },
+	{ 0x80f707, 0xfc },
+	{ 0x80f708, 0x00 },
+	{ 0x80f709, 0x37 },
+	{ 0x80f70a, 0x00 },
+	{ 0x80f78b, 0x01 },
+	{ 0x80f80f, 0x40 },
+	{ 0x80f810, 0x54 },
+	{ 0x80f811, 0x5a },
+	{ 0x80f905, 0x01 },
+	{ 0x80fb06, 0x03 },
+	{ 0x80fd8b, 0x00 },
+};
+
 static const struct reg_val ofsm_init_it9135_v2[] = {
 	{ 0x800051, 0x01 },
 	{ 0x800070, 0x0a },
-- 
1.7.11.7

