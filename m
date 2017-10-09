Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55517 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751647AbdJIKTf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 06/24] media: i2c-addr.h: get rid of now unused defines
Date: Mon,  9 Oct 2017 07:19:12 -0300
Message-Id: <e380c6c6a38157c8339755f348404040ee642f63.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some of the previously used I2C addresses there aren't used
anymore. So, get rid of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/i2c-addr.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/media/i2c-addr.h b/include/media/i2c-addr.h
index 5d0f56054d26..fba0457b74c4 100644
--- a/include/media/i2c-addr.h
+++ b/include/media/i2c-addr.h
@@ -10,21 +10,14 @@
  */
 
 /* bttv address list */
-#define I2C_ADDR_TSA5522	0xc2
 #define I2C_ADDR_TDA7432	0x8a
 #define I2C_ADDR_TDA8425	0x82
 #define I2C_ADDR_TDA9840	0x84
-#define I2C_ADDR_TDA9850	0xb6 /* also used by 9855,9873 */
 #define I2C_ADDR_TDA9874	0xb0 /* also used by 9875 */
 #define I2C_ADDR_TDA9875	0xb0
-#define I2C_ADDR_HAUPEE		0xa0
-#define I2C_ADDR_STBEE		0xae
-#define I2C_ADDR_VHX		0xc0
 #define I2C_ADDR_MSP3400	0x80
 #define I2C_ADDR_MSP3400_ALT	0x88
 #define I2C_ADDR_TEA6300	0x80 /* also used by 6320 */
-#define I2C_ADDR_DPL3518	0x84
-#define I2C_ADDR_TDA9887	0x86
 
 /*
  * i2c bus addresses for the chips supported by tvaudio.c
-- 
2.13.6
