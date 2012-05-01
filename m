Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38849 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2EAEMp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 00:12:45 -0400
Received: by mail-vx0-f174.google.com with SMTP id p1so2537594vcq.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 21:12:44 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 03/10] increment DVB API to version 5.6 for ATSC-MH frontend control
Date: Tue,  1 May 2012 00:12:18 -0400
Message-Id: <1335845545-20879-3-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
References: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 include/linux/dvb/version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.5.4

