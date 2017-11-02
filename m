Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58011 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755215AbdKBKL7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 06:11:59 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] pwc: fix spelling mistake: "synchronuously" -> "synchronously"
Date: Thu,  2 Nov 2017 10:11:51 +0000
Message-Id: <20171102101153.18225-5-colin.king@canonical.com>
In-Reply-To: <20171102101153.18225-1-colin.king@canonical.com>
References: <20171102101153.18225-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in error message text and break line
to clean up checkpatch warning

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/pwc/pwc-if.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index eb6921d2743e..54b036d39c5b 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -262,7 +262,8 @@ static void pwc_isoc_handler(struct urb *urb)
 
 	if (urb->status == -ENOENT || urb->status == -ECONNRESET ||
 	    urb->status == -ESHUTDOWN) {
-		PWC_DEBUG_OPEN("URB (%p) unlinked %ssynchronuously.\n", urb, urb->status == -ENOENT ? "" : "a");
+		PWC_DEBUG_OPEN("URB (%p) unlinked %ssynchronously.\n",
+			       urb, urb->status == -ENOENT ? "" : "a");
 		return;
 	}
 
-- 
2.14.1
