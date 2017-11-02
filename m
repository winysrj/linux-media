Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57999 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbdKBKL5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 06:11:57 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] cx231xx: fix spelling mistake: "synchronuously" -> "synchronously"
Date: Thu,  2 Nov 2017 10:11:48 +0000
Message-Id: <20171102101153.18225-2-colin.king@canonical.com>
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
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 4 ++--
 drivers/media/usb/cx231xx/cx231xx-vbi.c   | 4 ++--
 drivers/media/usb/cx231xx/cx231xx-video.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index c18bb33e060e..54abc1a7c8e1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -179,10 +179,10 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 
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
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 330b86e4e38f..d3bfe8e23b1f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -43,10 +43,10 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 
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
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 179b8481a870..226059fc672b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -199,10 +199,10 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 
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
