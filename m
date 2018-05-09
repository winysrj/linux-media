Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51674 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934085AbeEIJHc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 05:07:32 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cx231xx: Fix spelling mistake: "senario" -> "scenario"
Date: Wed,  9 May 2018 10:07:31 +0100
Message-Id: <20180509090731.11275-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dev_err message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
index 5bc74149fcb9..746c34ab0ec8 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
@@ -769,7 +769,7 @@ int initialize_cx231xx(struct cx231xx *dev)
 			break;
 		default:
 			dev_err(dev->dev,
-				"bad senario!!!!!\nconfig_info=%x\n",
+				"bad scenario!!!!!\nconfig_info=%x\n",
 				config_info & SELFPOWER_MASK);
 			return -ENODEV;
 		}
-- 
2.17.0
