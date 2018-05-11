Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:45451 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752504AbeEKIgw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 04:36:52 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Subject: [PATCH 3/3] media: lirc-func.rst: new ioctl LIRC_GET_REC_TIMEOUT is not in a separate file
Date: Fri, 11 May 2018 09:36:50 +0100
Message-Id: <20180511083650.20020-3-sean@mess.org>
In-Reply-To: <20180511083650.20020-1-sean@mess.org>
References: <20180511083650.20020-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the warning:

Documentation/media/uapi/rc/lirc-func.rst:9: WARNING: toctree contains reference to nonexisting document 'media/uapi/rc/lirc-get-rec-timeout'

The ioctl is documented in lirc-set-rec-timeout.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-func.rst | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/media/uapi/rc/lirc-func.rst b/Documentation/media/uapi/rc/lirc-func.rst
index 9656423a3f28..ddb4620de294 100644
--- a/Documentation/media/uapi/rc/lirc-func.rst
+++ b/Documentation/media/uapi/rc/lirc-func.rst
@@ -17,7 +17,6 @@ LIRC Function Reference
     lirc-get-rec-resolution
     lirc-set-send-duty-cycle
     lirc-get-timeout
-    lirc-get-rec-timeout
     lirc-set-rec-timeout
     lirc-set-rec-carrier
     lirc-set-rec-carrier-range
-- 
2.14.3
