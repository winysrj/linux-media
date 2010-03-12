Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60719 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933244Ab0CLOMv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 09:12:51 -0500
Received: by bwz1 with SMTP id 1so1060379bwz.21
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 06:12:49 -0800 (PST)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 1/6] V4L/DVB: tlg2300: remove unused #include <linux/version.h>
Date: Fri, 12 Mar 2010 22:12:22 +0800
Message-Id: <1268403142-5868-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <linux/version.h>('s) in
  drivers/media/video/tlg2300/pd-main.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/video/tlg2300/pd-main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
index 2cf0ebf..b8b6e3f 100644
--- a/drivers/media/video/tlg2300/pd-main.c
+++ b/drivers/media/video/tlg2300/pd-main.c
@@ -24,7 +24,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-- 
1.6.1.3

