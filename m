Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52760 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbcIGJxA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 05:53:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] [v4l-utils] libdvb5: Fix multiple definition of dvb_dev_remote_init linking error
Date: Wed,  7 Sep 2016 12:53:26 +0300
Message-Id: <1473242006-1284-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function is defined in a header file when HAVE_DVBV5_REMOTE is not
set. It needs to be marked as static inline.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 lib/include/libdvbv5/dvb-dev.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-dev.h b/lib/include/libdvbv5/dvb-dev.h
index da42671143a5..02b87016a3d3 100644
--- a/lib/include/libdvbv5/dvb-dev.h
+++ b/lib/include/libdvbv5/dvb-dev.h
@@ -449,8 +449,11 @@ int dvb_dev_remote_init(struct dvb_device *d, char *server, int port);
 
 #else
 
-int dvb_dev_remote_init(struct dvb_device *d, char *server, int port)
-{ return -1; };
+static inline int dvb_dev_remote_init(struct dvb_device *d, char *server,
+				      int port)
+{
+	return -1;
+};
 
 #endif
 
-- 
Regards,

Laurent Pinchart

