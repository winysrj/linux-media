Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:40723 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030554AbeFSSvY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:51:24 -0400
Received: by mail-wr0-f194.google.com with SMTP id l41-v6so691393wre.7
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:51:23 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, jasmin@anw.at,
        rjkm@metzlerbros.de, mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/3] [media] dvb-frontends/cxd2099: add SPDX license identifier
Date: Tue, 19 Jun 2018 20:51:18 +0200
Message-Id: <20180619185119.24548-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185119.24548-1-d.scheller.oss@gmail.com>
References: <20180619185119.24548-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

As both the MODULE_LICENSE and the boilerplates are now in sync and clear
that the driver is licensed under the terms of the GPLv2-only, add a
matching SPDX license identifier tag.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2099.c | 1 +
 drivers/media/dvb-frontends/cxd2099.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/cxd2099.c b/drivers/media/dvb-frontends/cxd2099.c
index 42de3d0badba..5264e873850e 100644
--- a/drivers/media/dvb-frontends/cxd2099.c
+++ b/drivers/media/dvb-frontends/cxd2099.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * cxd2099.c: Driver for the Sony CXD2099AR Common Interface Controller
  *
diff --git a/drivers/media/dvb-frontends/cxd2099.h b/drivers/media/dvb-frontends/cxd2099.h
index ec1910dec3f3..0c101bdef01d 100644
--- a/drivers/media/dvb-frontends/cxd2099.h
+++ b/drivers/media/dvb-frontends/cxd2099.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * cxd2099.h: Driver for the Sony CXD2099AR Common Interface Controller
  *
-- 
2.16.4
