Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32866 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdHLL4f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 07:56:35 -0400
Received: by mail-wm0-f67.google.com with SMTP id q189so9229214wmd.0
        for <linux-media@vger.kernel.org>; Sat, 12 Aug 2017 04:56:34 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v4 04/11] [media] ddbridge: check pointers before dereferencing
Date: Sat, 12 Aug 2017 13:55:55 +0200
Message-Id: <20170812115602.18124-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170812115602.18124-1-d.scheller.oss@gmail.com>
References: <20170812115602.18124-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes two warnings reported by smatch:

  drivers/media/pci/ddbridge/ddbridge-core.c:240 ddb_redirect() warn: variable dereferenced before check 'idev' (see line 238)
  drivers/media/pci/ddbridge/ddbridge-core.c:240 ddb_redirect() warn: variable dereferenced before check 'pdev' (see line 238)

Fixed by moving the existing checks up before accessing members.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index bbd8d556175b..d7bf01f38d98 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -170,10 +170,10 @@ static int ddb_redirect(u32 i, u32 p)
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
