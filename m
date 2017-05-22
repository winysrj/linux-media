Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42147 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757215AbdEVIN2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 04:13:28 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] em28xx: fix spelling mistake: "missdetected" -> "misdetected"
Date: Mon, 22 May 2017 09:13:25 +0100
Message-Id: <20170522081325.14805-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dev_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a12b599a1fa2..146341aeb782 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2855,7 +2855,7 @@ static int em28xx_hint_board(struct em28xx *dev)
 				"Your board has no unique USB ID.\n"
 				"A hint were successfully done, based on eeprom hash.\n"
 				"This method is not 100%% failproof.\n"
-				"If the board were missdetected, please email this log to:\n"
+				"If the board were misdetected, please email this log to:\n"
 				"\tV4L Mailing List  <linux-media@vger.kernel.org>\n"
 				"Board detected as %s\n",
 			       em28xx_boards[dev->model].name);
@@ -2885,7 +2885,7 @@ static int em28xx_hint_board(struct em28xx *dev)
 				"Your board has no unique USB ID.\n"
 				"A hint were successfully done, based on i2c devicelist hash.\n"
 				"This method is not 100%% failproof.\n"
-				"If the board were missdetected, please email this log to:\n"
+				"If the board were misdetected, please email this log to:\n"
 				"\tV4L Mailing List  <linux-media@vger.kernel.org>\n"
 				"Board detected as %s\n",
 				em28xx_boards[dev->model].name);
-- 
2.11.0
