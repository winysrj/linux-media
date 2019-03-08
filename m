Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E7EC43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 10:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74E1020854
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 10:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfCHKaT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:30:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40199 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfCHKaT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 05:30:19 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1h2Cld-0004Eb-LT; Fri, 08 Mar 2019 10:30:17 +0000
From:   Colin King <colin.king@canonical.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: em28xx-input: make const array addr_list static
Date:   Fri,  8 Mar 2019 10:30:17 +0000
Message-Id: <20190308103017.29114-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array addr_list on the stack but instead make it
static. Makes the object code smaller by 20 bytes

Before:
   text    data     bss     dec     hex filename^M
  16929    3626     384   20939    51cb ../usb/em28xx/em28xx-input.o

After:
   text    data     bss     dec     hex filename^M
  16829    3706     384   20919    51b7 ../usb/em28xx/em28xx-input.o

(gcc version 8.3.0, aarch64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/em28xx/em28xx-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index f84a1208d5d3..d85ea1af6aa1 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -499,7 +499,7 @@ static int em28xx_probe_i2c_ir(struct em28xx *dev)
 	 * at address 0x18, so if that address is needed for another board in
 	 * the future, please put it after 0x1f.
 	 */
-	const unsigned short addr_list[] = {
+	static const unsigned short addr_list[] = {
 		 0x1f, 0x30, 0x47, I2C_CLIENT_END
 	};
 
-- 
2.20.1

