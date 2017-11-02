Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58006 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752865AbdKBKL6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 06:11:58 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] em28xx: fix spelling mistake: "synchronuously" -> "synchronously"
Date: Thu,  2 Nov 2017 10:11:49 +0000
Message-Id: <20171102101153.18225-3-colin.king@canonical.com>
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
 drivers/media/usb/em28xx/em28xx-dvb.c   | 4 ++--
 drivers/media/usb/em28xx/em28xx-video.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 4a7db623fe29..9950a740e04e 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -112,10 +112,10 @@ static inline void print_err_status(struct em28xx *dev,
 
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
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 8d253a5df0a9..a2ba2d905952 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -557,10 +557,10 @@ static inline void print_err_status(struct em28xx *dev,
 
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
