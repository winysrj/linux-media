Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57193 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732180AbeHCQcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 12:32:41 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] media: au0828: fix spelling mistake: "completition" -> "completion"
Date: Fri,  3 Aug 2018 15:35:58 +0100
Message-Id: <20180803143601.4211-2-colin.king@canonical.com>
In-Reply-To: <20180803143601.4211-1-colin.king@canonical.com>
References: <20180803143601.4211-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in au0828_isocdbg debug message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/au0828/au0828-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 70e187971590..62b45062b1e6 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -133,7 +133,7 @@ static void au0828_irq_callback(struct urb *urb)
 		au0828_isocdbg("au0828_irq_callback called: status kill\n");
 		return;
 	default:            /* unknown error */
-		au0828_isocdbg("urb completition error %d.\n", urb->status);
+		au0828_isocdbg("urb completion error %d.\n", urb->status);
 		break;
 	}
 
-- 
2.17.1
