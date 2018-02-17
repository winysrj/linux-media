Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:53944 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbeBQPDe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Feb 2018 10:03:34 -0500
Received: by mail-wm0-f66.google.com with SMTP id t74so7942508wme.3
        for <linux-media@vger.kernel.org>; Sat, 17 Feb 2018 07:03:33 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH v2 1/7] [media] ddbridge/ci: further deduplicate code/logic in ddb_ci_attach()
Date: Sat, 17 Feb 2018 16:03:22 +0100
Message-Id: <20180217150328.686-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180217150328.686-1-d.scheller.oss@gmail.com>
References: <20180217150328.686-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Deduplicate the checks for a valid ptr in port->en, and also handle the
default case to also catch eventually yet unsupported CI hardware.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-ci.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index 5828111487b0..ed19890710d6 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -325,24 +325,20 @@ int ddb_ci_attach(struct ddb_port *port, u32 bitrate)
 	case DDB_CI_EXTERNAL_SONY:
 		cxd_cfg.bitrate = bitrate;
 		port->en = cxd2099_attach(&cxd_cfg, port, &port->i2c->adap);
-		if (!port->en)
-			return -ENODEV;
 		break;
-
 	case DDB_CI_EXTERNAL_XO2:
 	case DDB_CI_EXTERNAL_XO2_B:
 		ci_xo2_attach(port);
-		if (!port->en)
-			return -ENODEV;
 		break;
-
 	case DDB_CI_INTERNAL:
 		ci_attach(port);
-		if (!port->en)
-			return -ENODEV;
 		break;
+	default:
+		return -ENODEV;
 	}
 
+	if (!port->en)
+		return -ENODEV;
 	dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
 	return 0;
 }
-- 
2.13.6
