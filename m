Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:53740 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754615AbdCTOyl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:54:41 -0400
Subject: [PATCH 12/24] staging: media: atomisp: select REGMAP_I2C needed by
 ap1302.c
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:40:50 +0000
Message-ID: <149002084851.17109.876192563486517557.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>

REGMAP_I2C should be enabled to build the driver ap1302 because it uses
regmap functions.

Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/i2c/Kconfig b/drivers/staging/media/atomisp/i2c/Kconfig
index 30b0bb9..b80d29d 100644
--- a/drivers/staging/media/atomisp/i2c/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/Kconfig
@@ -62,6 +62,7 @@ config VIDEO_MT9M114
 config VIDEO_AP1302
        tristate "AP1302 external ISP support"
        depends on I2C && VIDEO_V4L2
+       select REGMAP_I2C
        ---help---
          This is a Video4Linux2 sensor-level driver for the external
          ISP AP1302.
