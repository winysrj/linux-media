Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:49600 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3LJLkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 06:40:52 -0500
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 1/4] closing uvc file when init fails
Date: Tue, 10 Dec 2013 12:40:34 +0100
Message-id: <1386675637-18243-2-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
References: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds uvc device file closing when inits in uvc_open() function fails.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 uvc-gadget.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/uvc-gadget.c b/uvc-gadget.c
index 0764838..5512e2c 100644
--- a/uvc-gadget.c
+++ b/uvc-gadget.c
@@ -880,6 +880,7 @@ uvc_open(struct uvc_device **uvc, char *devname)
 	return 0;
 
 err:
+	close(fd);
 	return ret;
 }
 
-- 
1.7.9.5

