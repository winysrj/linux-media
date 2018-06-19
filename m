Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:41800 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030552AbeFSSvX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:51:23 -0400
Received: by mail-wr0-f195.google.com with SMTP id h10-v6so686322wrq.8
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:51:22 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, jasmin@anw.at,
        rjkm@metzlerbros.de, mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] dvb-frontends/cxd2099: fix MODULE_LICENSE to 'GPL v2'
Date: Tue, 19 Jun 2018 20:51:17 +0200
Message-Id: <20180619185119.24548-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185119.24548-1-d.scheller.oss@gmail.com>
References: <20180619185119.24548-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

In commit 3db30defab4b ("use correct MODULE_LINCESE for GPL v2 only
according to notice in header") in the upstream repository for the
mentioned driver at https://github.com/DigitalDevices/dddvb.git, the
MODULE_LICENSE was fixed to "GPL v2" and is now in sync with the GPL
copyright boilerplate. Apply this change to the kernel tree driver
aswell.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2099.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cxd2099.c b/drivers/media/dvb-frontends/cxd2099.c
index 4a0ce3037fd6..42de3d0badba 100644
--- a/drivers/media/dvb-frontends/cxd2099.c
+++ b/drivers/media/dvb-frontends/cxd2099.c
@@ -701,4 +701,4 @@ module_i2c_driver(cxd2099_driver);
 
 MODULE_DESCRIPTION("Sony CXD2099AR Common Interface controller driver");
 MODULE_AUTHOR("Ralph Metzler");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
-- 
2.16.4
