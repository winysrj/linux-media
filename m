Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38639 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031AbbJOGhI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 02:37:08 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH v4 69/79] include/uapi/linux/dvb/video.h: remove stdint.h include
Date: Thu, 15 Oct 2015 07:56:47 +0200
Message-Id: <1444888618-4506-70-git-send-email-mikko.rapeli@iki.fi>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kernel headers should use linux/types.h instead.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/dvb/video.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/dvb/video.h b/include/uapi/linux/dvb/video.h
index d3d14a59..4939256 100644
--- a/include/uapi/linux/dvb/video.h
+++ b/include/uapi/linux/dvb/video.h
@@ -26,7 +26,6 @@
 
 #include <linux/types.h>
 #ifndef __KERNEL__
-#include <stdint.h>
 #include <time.h>
 #endif
 
-- 
2.5.0

