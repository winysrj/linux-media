Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36733 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030465AbeFSSuV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:50:21 -0400
Received: by mail-wr0-f193.google.com with SMTP id f16-v6so706708wrm.3
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:50:21 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 1/9] [media] mxl5xx/stv0910/stv6111/ddbridge: fix MODULE_LICENSE to 'GPL v2'
Date: Tue, 19 Jun 2018 20:50:08 +0200
Message-Id: <20180619185016.24402-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185016.24402-1-d.scheller.oss@gmail.com>
References: <20180619185016.24402-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

In commit 3db30defab4b ("use correct MODULE_LINCESE for GPL v2 only
according to notice in header") in the upstream repository for the
mentioned four drivers at https://github.com/DigitalDevices/dddvb.git
(plus a few more which aren't part of the mainline kernel tree), the
MODULE_LICENSE was fixed to "GPL v2" and are now in sync with the
GPL copyright boilerplate. Apply this change to the kernel tree
drivers aswell.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/mxl5xx.c       | 2 +-
 drivers/media/dvb-frontends/stv0910.c      | 2 +-
 drivers/media/dvb-frontends/stv6111.c      | 2 +-
 drivers/media/pci/ddbridge/ddbridge-main.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 274d8fca0763..1067701bdd06 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -1895,4 +1895,4 @@ EXPORT_SYMBOL_GPL(mxl5xx_attach);
 
 MODULE_DESCRIPTION("MaxLinear MxL5xx DVB-S/S2 tuner-demodulator driver");
 MODULE_AUTHOR("Ralph and Marcus Metzler, Metzler Brothers Systementwicklung GbR");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 41444fa1c0bb..8d72de0ff5b0 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1841,4 +1841,4 @@ EXPORT_SYMBOL_GPL(stv0910_attach);
 
 MODULE_DESCRIPTION("ST STV0910 multistandard frontend driver");
 MODULE_AUTHOR("Ralph and Marcus Metzler, Manfred Voelkel");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
index 9b715b6fe152..25208a120cb7 100644
--- a/drivers/media/dvb-frontends/stv6111.c
+++ b/drivers/media/dvb-frontends/stv6111.c
@@ -688,4 +688,4 @@ EXPORT_SYMBOL_GPL(stv6111_attach);
 
 MODULE_DESCRIPTION("ST STV6111 satellite tuner driver");
 MODULE_AUTHOR("Ralph Metzler, Manfred Voelkel");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index f4748cfd904b..6f3ea927bde5 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -318,5 +318,5 @@ module_exit(module_exit_ddbridge);
 
 MODULE_DESCRIPTION("Digital Devices PCIe Bridge");
 MODULE_AUTHOR("Ralph and Marcus Metzler, Metzler Brothers Systementwicklung GbR");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DDBRIDGE_VERSION);
-- 
2.16.4
