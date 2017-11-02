Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58014 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755282AbdKBKMA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 06:12:00 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] stk1160: fix spelling mistake: "synchronuously" -> "synchronously"
Date: Thu,  2 Nov 2017 10:11:52 +0000
Message-Id: <20171102101153.18225-6-colin.king@canonical.com>
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
 drivers/media/usb/stk1160/stk1160-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index ce8ebbe395a6..423c03a0638d 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -38,10 +38,10 @@ static inline void print_err_status(struct stk1160 *dev,
 
 	switch (status) {
 	case -ENOENT:
-		errmsg = "unlinked synchronuously";
+		errmsg = "unlinked synchronously";
 		break;
 	case -ECONNRESET:
-		errmsg = "unlinked asynchronuously";
+		errmsg = "unlinked asynchronously";
 		break;
 	case -ENOSR:
 		errmsg = "Buffer error (overrun)";
-- 
2.14.1
