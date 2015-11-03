Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:44592 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756052AbbKCU6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 15:58:48 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [v4l-utils 3/5] utils/v4l2-compliance: Include <fcntl.h> instead of <sys/fcntl.h>
Date: Tue,  3 Nov 2015 21:58:38 +0100
Message-Id: <1446584320-25016-4-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Code should not be including <sys/fcntl.h> header, but instead it
should include the public <fcntl.h> header.

On glibc and uClibc, <sys/fcntl.h> simply includes <fcntl.h>, but with
the musl C library, it spits out a warning telling you that you're not
doing the right thing:

In file included from ./v4l-helpers.h:12:0,
                 from ./cv4l-helpers.h:5,
                 from v4l2-compliance.h:36,
                 from v4l2-test-controls.cpp:33:
.../sysroot/usr/include/sys/fcntl.h:1:2: warning: #warning redirecting incorrect #include <sys/fcntl.h> to <fcntl.h> [-Wcpp]
 #warning redirecting incorrect #include <sys/fcntl.h> to <fcntl.h>

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 utils/v4l2-compliance/v4l-helpers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/v4l2-compliance/v4l-helpers.h b/utils/v4l2-compliance/v4l-helpers.h
index d8a273d..9aafa34 100644
--- a/utils/v4l2-compliance/v4l-helpers.h
+++ b/utils/v4l2-compliance/v4l-helpers.h
@@ -9,7 +9,7 @@
 #include <time.h>
 #include <unistd.h>
 #include <sys/ioctl.h>
-#include <sys/fcntl.h>
+#include <fcntl.h>
 #include <sys/mman.h>
 #include <errno.h>
 
-- 
2.6.2

