Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:53557 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751004AbdE3KTm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 06:19:42 -0400
Message-ID: <1496139572.2618.19.camel@perches.com>
Subject: Re: [PATCH v2] [media] vb2: core: Lower the log level of debug
 outputs
From: Joe Perches <joe@perches.com>
To: Hirokazu Honda <hiroh@chromium.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 May 2017 03:19:32 -0700
In-Reply-To: <20170530094901.1807-1-hiroh@chromium.org>
References: <20170530094901.1807-1-hiroh@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-05-30 at 18:49 +0900, Hirokazu Honda wrote:
> Some debug output whose log level is set 1 flooded the log.
> Their log level is lowered to find the important log easily.

Maybe use pr_debug instead?

Perhaps it would be better to change the level to a bitmap
so these can be more individually controlled.

Maybe add MODULE_PARM_DESC too.

Perhaps something like below (without the pr_debug conversion)

---
 drivers/media/v4l2-core/videobuf2-core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 94afbbf92807..88ae2b238115 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -31,12 +31,13 @@
 
 static int debug;
 module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debugging output control bitmap (values from 0-31)")
 
-#define dprintk(level, fmt, arg...)					      \
-	do {								      \
-		if (debug >= level)					      \
-			pr_info("vb2-core: %s: " fmt, __func__, ## arg); \
-	} while (0)
+#define dprintk(level, fmt, ...)					\
+do {									\
+	if (debug & BIT(level))						\
+		pr_info("vb2-core: %s: " fmt, __func__, ##__VA_ARGS__);	\
+} while (0)
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 
