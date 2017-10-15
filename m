Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33723 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbdJOUwE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 16:52:04 -0400
Received: by mail-wm0-f66.google.com with SMTP id u138so6186462wmu.0
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 13:52:03 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 4/8] [media] ddbridge/ci: change debug printing to debug severity
Date: Sun, 15 Oct 2017 22:51:53 +0200
Message-Id: <20171015205157.14342-5-d.scheller.oss@gmail.com>
In-Reply-To: <20171015205157.14342-1-d.scheller.oss@gmail.com>
References: <20171015205157.14342-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

slot_ts_enable_xo2() logged debug output to info instead of debug, so
fix this up.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-ci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index c775b17c3228..457c711aaced 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -260,7 +260,7 @@ static int slot_ts_enable_xo2(struct dvb_ca_en50221 *ca, int slot)
 {
 	struct ddb_ci *ci = ca->data;
 
-	dev_info(ci->port->dev->dev, "%s\n", __func__);
+	dev_dbg(ci->port->dev->dev, "%s\n", __func__);
 	write_creg(ci, 0x00, 0x10);
 	return 0;
 }
-- 
2.13.6
