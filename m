Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33415
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752359AbdI0VrH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 11/17] media: rc-core.h: minor adjustments at rc_driver_type doc
Date: Wed, 27 Sep 2017 18:46:54 -0300
Message-Id: <22ecc271a5accdef5b746c0749f9f1b7cba5121d.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The description of this enum doesn't match what it
actually represents. Adjust it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/rc-core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 314a1edb6189..a381abe9186e 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -30,9 +30,9 @@ do {								\
 } while (0)
 
 /**
- * enum rc_driver_type - type of the RC output
+ * enum rc_driver_type - type of the RC driver.
  *
- * @RC_DRIVER_SCANCODE:	 Driver or hardware generates a scancode
+ * @RC_DRIVER_SCANCODE:	 Driver or hardware generates a scancode.
  * @RC_DRIVER_IR_RAW:	 Driver or hardware generates pulse/space sequences.
  *			 It needs a Infra-Red pulse/space decoder
  * @RC_DRIVER_IR_RAW_TX: Device transmitter only,
-- 
2.13.5
