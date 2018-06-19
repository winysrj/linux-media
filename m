Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:37758 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030469AbeFSSu2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:50:28 -0400
Received: by mail-wr0-f195.google.com with SMTP id d8-v6so702949wro.4
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:50:28 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 9/9] [media] dvb-frontends/stv6111: add SPDX license identifier
Date: Tue, 19 Jun 2018 20:50:16 +0200
Message-Id: <20180619185016.24402-10-d.scheller.oss@gmail.com>
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
 drivers/media/dvb-frontends/stv6111.c | 1 +
 drivers/media/dvb-frontends/stv6111.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
index 88c0cf4c5011..4185441fa78b 100644
--- a/drivers/media/dvb-frontends/stv6111.c
+++ b/drivers/media/dvb-frontends/stv6111.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Driver for the ST STV6111 tuner
  *
diff --git a/drivers/media/dvb-frontends/stv6111.h b/drivers/media/dvb-frontends/stv6111.h
index 809e62361a91..8823eb326784 100644
--- a/drivers/media/dvb-frontends/stv6111.h
+++ b/drivers/media/dvb-frontends/stv6111.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Driver for the ST STV6111 tuner
  *
-- 
2.16.4
