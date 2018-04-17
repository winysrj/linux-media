Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46593 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753002AbeDQOQk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 10:16:40 -0400
Date: Tue, 17 Apr 2018 11:16:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>
Subject: [PATCH v4l-utils] v4l2-compliance: identify if compiled with 32 or
 64 bits
Message-ID: <20180417111634.2e6f2cb0@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we need to have a 32 bits version in order to check for
compat32 issues, let's print if v4l2-compliance was built
with 32 or 64 bits.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/utils/v4l2-compliance/v4l2-compliance.cpp b/utils/v4l2-compliance/v4l2-compliance.cpp
index eb1f90fd7ad8..ecfcc7716bca 100644
--- a/utils/v4l2-compliance/v4l2-compliance.cpp
+++ b/utils/v4l2-compliance/v4l2-compliance.cpp
@@ -1271,9 +1271,9 @@ int main(int argc, char **argv)
 #ifdef SHA
 #define STR(x) #x
 #define STRING(x) STR(x)
-	printf("v4l2-compliance SHA   : %s\n", STRING(SHA));
+	printf("v4l2-compliance SHA   : %s, %zd bits\n", STRING(SHA), sizeof(void *) * 8);
 #else
-	printf("v4l2-compliance SHA   : not available\n");
+	printf("v4l2-compliance SHA   : not available, %zd bits\n", sizeof(void *) * 8);
 #endif
 
 	struct utsname uts;


Thanks,
Mauro
