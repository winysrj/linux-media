Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36578 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752610AbdGITmd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:33 -0400
Received: by mail-wr0-f196.google.com with SMTP id 77so20374816wrb.3
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:32 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 07/14] [media] ddbridge: check pointers before dereferencing
Date: Sun,  9 Jul 2017 21:42:14 +0200
Message-Id: <20170709194221.10255-8-d.scheller.oss@gmail.com>
In-Reply-To: <20170709194221.10255-1-d.scheller.oss@gmail.com>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes two warnings reported by smatch:

  drivers/media/pci/ddbridge/ddbridge-core.c:240 ddb_redirect() warn: variable dereferenced before check 'idev' (see line 238)
  drivers/media/pci/ddbridge/ddbridge-core.c:240 ddb_redirect() warn: variable dereferenced before check 'pdev' (see line 238)

Fixed by moving the existing checks up before accessing members.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index cf45a5ad9853..175f173d3e86 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -169,10 +169,10 @@ static int ddb_redirect(u32 i, u32 p)
 	struct ddb *pdev = ddbs[(p >> 4) & 0x3f];
 	struct ddb_port *port;
 
-	if (!idev->has_dma || !pdev->has_dma)
-		return -EINVAL;
 	if (!idev || !pdev)
 		return -EINVAL;
+	if (!idev->has_dma || !pdev->has_dma)
+		return -EINVAL;
 
 	port = &pdev->port[p & 0x0f];
 	if (!port->output)
-- 
2.13.0
