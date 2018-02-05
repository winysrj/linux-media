Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:34240 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbeBEUK0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 15:10:26 -0500
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 3/4] v4l: dvb-frontends: stb0899: fix comparison to bitshift when dealing with a mask
Date: Mon,  5 Feb 2018 21:10:00 +0100
Message-Id: <20180205201002.23621-4-wsa+renesas@sang-engineering.com>
In-Reply-To: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to a typo, the mask was destroyed by a comparison instead of a bit
shift.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
Only build tested. To be applied individually per subsystem.

 drivers/media/dvb-frontends/stb0899_reg.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_reg.h b/drivers/media/dvb-frontends/stb0899_reg.h
index ba1ed56304a0f4..f564269249a682 100644
--- a/drivers/media/dvb-frontends/stb0899_reg.h
+++ b/drivers/media/dvb-frontends/stb0899_reg.h
@@ -374,22 +374,22 @@
 
 #define STB0899_OFF0_IF_AGC_GAIN		0xf30c
 #define STB0899_BASE_IF_AGC_GAIN		0x00000000
-#define STB0899_IF_AGC_GAIN			(0x3fff < 0)
+#define STB0899_IF_AGC_GAIN			(0x3fff << 0)
 #define STB0899_OFFST_IF_AGC_GAIN		0
 #define STB0899_WIDTH_IF_AGC_GAIN		14
 
 #define STB0899_OFF0_BB_AGC_GAIN		0xf310
 #define STB0899_BASE_BB_AGC_GAIN		0x00000000
-#define STB0899_BB_AGC_GAIN			(0x3fff < 0)
+#define STB0899_BB_AGC_GAIN			(0x3fff << 0)
 #define STB0899_OFFST_BB_AGC_GAIN		0
 #define STB0899_WIDTH_BB_AGC_GAIN		14
 
 #define STB0899_OFF0_DC_OFFSET			0xf314
 #define STB0899_BASE_DC_OFFSET			0x00000000
-#define STB0899_I				(0xff < 8)
+#define STB0899_I				(0xff << 8)
 #define STB0899_OFFST_I				8
 #define STB0899_WIDTH_I				8
-#define STB0899_Q				(0xff < 0)
+#define STB0899_Q				(0xff << 0)
 #define STB0899_OFFST_Q				8
 #define STB0899_WIDTH_Q				8
 
-- 
2.11.0
