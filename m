Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34926 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab2FUTxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:53:40 -0400
Received: by ghrr11 with SMTP id r11so883954ghr.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:53:39 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	<linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 03/10] staging: solo6x10: Replace C++ style comment with C style
Date: Thu, 21 Jun 2012 16:52:05 -0300
Message-Id: <1340308332-1118-3-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/solo6x10/v4l2-enc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index f8f0da9..9333a00 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -466,7 +466,7 @@ static void write_bytes(u8 **out, unsigned *bits, const u8 *src, unsigned count)
 static void write_bits(u8 **out, unsigned *bits, u32 value, unsigned count)
 {
 
-	value <<= 32 - count; // shift to the right
+	value <<= 32 - count; /* shift to the right */
 
 	while (count--) {
 		**out <<= 1;
-- 
1.7.4.4

