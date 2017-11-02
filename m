Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58007 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752970AbdKBKL7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 06:11:59 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] msi2500: fix spelling mistake: "synchronuously" -> "synchronously"
Date: Thu,  2 Nov 2017 10:11:50 +0000
Message-Id: <20171102101153.18225-4-colin.king@canonical.com>
In-Reply-To: <20171102101153.18225-1-colin.king@canonical.com>
References: <20171102101153.18225-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in error message text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/msi2500/msi2500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index a097d3dbc141..65ef755adfdc 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -386,7 +386,7 @@ static void msi2500_isoc_handler(struct urb *urb)
 	if (unlikely(urb->status == -ENOENT ||
 		     urb->status == -ECONNRESET ||
 		     urb->status == -ESHUTDOWN)) {
-		dev_dbg(dev->dev, "URB (%p) unlinked %ssynchronuously\n",
+		dev_dbg(dev->dev, "URB (%p) unlinked %ssynchronously\n",
 			urb, urb->status == -ENOENT ? "" : "a");
 		return;
 	}
-- 
2.14.1
