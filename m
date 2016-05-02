Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m008e.mx.aol.com ([204.29.186.7]:49395 "EHLO
	omr-m008e.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbcEBOKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2016 10:10:07 -0400
Subject: Re: [PATCH] [media] em28xx_dvb: add support for PLEX PX-BCUD (ISDB-S
 usb dongle)
To: Akihiro TSUKADA <tskd08@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
References: <a0564a33-161b-3e2e-d4d3-c6ed896a7b89@aim.com>
 <e1c557f3-c110-f330-3270-bd168f8508f1@gmail.com>
From: Satoshi Nagahama <sattnag@aim.com>
Message-ID: <4be8d312-e549-1de2-cdc1-829ceece70f9@aim.com>
Date: Mon, 2 May 2016 23:10:00 +0900
MIME-Version: 1.0
In-Reply-To: <e1c557f3-c110-f330-3270-bd168f8508f1@gmail.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akihiro,

Thank you for your review and comments.
I did two changes as you commented.

 > * The names of _REG_ROWS / reg_index might be a bit vague to others.
 >   I would prefer _CHIP_IDS / chip_id  or something like that.
 >
 > * reg_index should not be static as it is per device property.
 >   Instead, it shouldj be defined in qm1d1c0042_init() locally, or
 >   in struct qm1d1c0042_state, if "reg_index" can be used elsewhere.
 >
 > Thre rest looks OK to me.
 >
 > regards,
 > akihiro


Changed the definition name to QM1D1C0042_NUM_CHIP_IDS from QM1D1C0042_NUM_REG_ROWS
Changed the variable reg_index into local from static.

Signed-off-by: Satoshi Nagahama <sattnag@aim.com>
---
  drivers/media/tuners/qm1d1c0042.c | 12 +++++-------
  1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
index bc2fb74..132af21 100644
--- a/drivers/media/tuners/qm1d1c0042.c
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -32,9 +32,9 @@
  #include "qm1d1c0042.h"

  #define QM1D1C0042_NUM_REGS 0x20
-#define QM1D1C0042_NUM_REG_ROWS 2
+#define QM1D1C0042_NUM_CHIP_IDS 2

-static const u8 reg_initval[QM1D1C0042_NUM_REG_ROWS][QM1D1C0042_NUM_REGS] = { {
+static const u8 reg_initval[QM1D1C0042_NUM_CHIP_IDS][QM1D1C0042_NUM_REGS] = { {
  		0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
  		0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
  		0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
@@ -47,8 +47,6 @@ static const u8 reg_initval[QM1D1C0042_NUM_REG_ROWS][QM1D1C0042_NUM_REGS] = { {
  	}
  };

-static int reg_index;
-
  static const struct qm1d1c0042_config default_cfg = {
  	.xtal_freq = 16000,
  	.lpf = 1,
@@ -326,7 +324,7 @@ static int qm1d1c0042_init(struct dvb_frontend *fe)
  {
  	struct qm1d1c0042_state *state;
  	u8 val;
-	int i, ret;
+	int i, ret, reg_index;

  	state = fe->tuner_priv;

@@ -346,9 +344,9 @@ static int qm1d1c0042_init(struct dvb_frontend *fe)
  	ret = reg_read(state, 0x00, &val);
  	if (ret < 0)
  		goto failed;
-	for (reg_index = 0; reg_index < QM1D1C0042_NUM_REG_ROWS; reg_index++)
+	for (reg_index = 0; reg_index < QM1D1C0042_NUM_CHIP_IDS; reg_index++)
  		if (val == reg_initval[reg_index][0x00]) break;
-	if (reg_index >= QM1D1C0042_NUM_REG_ROWS)
+	if (reg_index >= QM1D1C0042_NUM_CHIP_IDS)
  		goto failed;
  	memcpy(state->regs, reg_initval[reg_index], QM1D1C0042_NUM_REGS);
  	usleep_range(2000, 3000);
-- 
2.8.0


