Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:39429 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030520AbeFSSu1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:50:27 -0400
Received: by mail-wr0-f193.google.com with SMTP id w7-v6so695207wrn.6
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:50:26 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 7/9] [media] dvb-frontends/stv0910: add SPDX license identifier
Date: Tue, 19 Jun 2018 20:50:14 +0200
Message-Id: <20180619185016.24402-8-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185016.24402-1-d.scheller.oss@gmail.com>
References: <20180619185016.24402-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

As it is clear that the driver is licensed under the terms of GPLv2-only
by now, add a matching SPDX license identifier to all driver files.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c      | 1 +
 drivers/media/dvb-frontends/stv0910.h      | 1 +
 drivers/media/dvb-frontends/stv0910_regs.h | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 16f73c16ac61..a81d3cc0acae 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Driver for the ST STV0910 DVB-S/S2 demodulator.
  *
diff --git a/drivers/media/dvb-frontends/stv0910.h b/drivers/media/dvb-frontends/stv0910.h
index c3985bee749f..19b48409e050 100644
--- a/drivers/media/dvb-frontends/stv0910.h
+++ b/drivers/media/dvb-frontends/stv0910.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Driver for the ST STV0910 DVB-S/S2 demodulator.
  *
diff --git a/drivers/media/dvb-frontends/stv0910_regs.h b/drivers/media/dvb-frontends/stv0910_regs.h
index 4440892df61f..12ae86fae965 100644
--- a/drivers/media/dvb-frontends/stv0910_regs.h
+++ b/drivers/media/dvb-frontends/stv0910_regs.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * @DVB-S/DVB-S2 STMicroelectronics STV0900 register definitions
  * Author Manfred Voelkel, August 2013
-- 
2.16.4
