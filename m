Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38778 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbeFWPg1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:27 -0400
Received: by mail-wm0-f66.google.com with SMTP id 69-v6so5601495wmf.3
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:27 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 09/19] [media] ddbridge/mci: update copyright year in headers
Date: Sat, 23 Jun 2018 17:36:05 +0200
Message-Id: <20180623153615.27630-10-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Update the copyright year information in the MCI headers to 2017-2018.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-mci.c | 6 +++---
 drivers/media/pci/ddbridge/ddbridge-mci.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.c b/drivers/media/pci/ddbridge/ddbridge-mci.c
index 4ac634fc96e4..46b20b06e2a6 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.c
@@ -2,9 +2,9 @@
 /*
  * ddbridge-mci.c: Digital Devices microcode interface
  *
- * Copyright (C) 2017 Digital Devices GmbH
- *                    Ralph Metzler <rjkm@metzlerbros.de>
- *                    Marcus Metzler <mocm@metzlerbros.de>
+ * Copyright (C) 2017-2018 Digital Devices GmbH
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.h b/drivers/media/pci/ddbridge/ddbridge-mci.h
index 209cc2b92dff..389f6376603b 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.h
@@ -2,9 +2,9 @@
 /*
  * ddbridge-mci.h: Digital Devices micro code interface
  *
- * Copyright (C) 2017 Digital Devices GmbH
- *                    Marcus Metzler <mocm@metzlerbros.de>
- *                    Ralph Metzler <rjkm@metzlerbros.de>
+ * Copyright (C) 2017-2018 Digital Devices GmbH
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
-- 
2.16.4
