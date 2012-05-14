Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55766 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab2ENWLY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 18:11:24 -0400
Received: by qadb17 with SMTP id b17so3179695qad.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:11:24 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 03/11] increment DVB API to version 5.6 for ATSC-MH frontend control
Date: Mon, 14 May 2012 18:10:45 -0400
Message-Id: <1337033453-22119-3-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
References: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

increment the DVB API version to 5.6 to signify support for
controlling an ATSC-MH frontend.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 include/linux/dvb/version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
index 0559e2b..43d9e8d 100644
--- a/include/linux/dvb/version.h
+++ b/include/linux/dvb/version.h
@@ -24,6 +24,6 @@
 #define _DVBVERSION_H_
 
 #define DVB_API_VERSION 5
-#define DVB_API_VERSION_MINOR 5
+#define DVB_API_VERSION_MINOR 6
 
 #endif /*_DVBVERSION_H_*/
-- 
1.7.9.5

