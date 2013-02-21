Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f182.google.com ([209.85.160.182]:60451 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3BUWyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Feb 2013 17:54:52 -0500
Received: by mail-gh0-f182.google.com with SMTP id z15so11866ghb.27
        for <linux-media@vger.kernel.org>; Thu, 21 Feb 2013 14:54:52 -0800 (PST)
From: Ismael Luceno <ismael.luceno@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: [PATCH] solo6x10: Maintainer change
Date: Thu, 21 Feb 2013 19:53:58 -0300
Message-Id: <1361487238-4921-1-git-send-email-ismael.luceno@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b95564..eb277c9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7315,8 +7315,8 @@ S:	Odd Fixes
 F:	drivers/staging/sm7xxfb/
 
 STAGING - SOFTLOGIC 6x10 MPEG CODEC
-M:	Ben Collins <bcollins@bluecherry.net>
-S:	Odd Fixes
+M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
+S:	Supported
 F:	drivers/staging/media/solo6x10/
 
 STAGING - SPEAKUP CONSOLE SPEECH DRIVER
-- 
1.8.1.3

