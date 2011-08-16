Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:33557 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1HPOET (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 10:04:19 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dream-property.net (Postfix) with ESMTP id E7995315386C
	for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 16:04:18 +0200 (CEST)
Received: from mail.dream-property.net ([127.0.0.1])
	by localhost (mail.dream-property.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Zy2ScAjf36fM for <linux-media@vger.kernel.org>;
	Tue, 16 Aug 2011 16:04:09 +0200 (CEST)
Received: from pepe.dream-property.nete (dreamboxupdate.com [82.149.226.174])
	by mail.dream-property.net (Postfix) with SMTP id B6307315387D
	for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 16:04:08 +0200 (CEST)
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] DVB: increment minor version after addition of SYS_TURBO
Date: Tue, 16 Aug 2011 14:04:07 +0000
Message-Id: <1313503447-13743-2-git-send-email-obi@linuxtv.org>
In-Reply-To: <1313503447-13743-1-git-send-email-obi@linuxtv.org>
References: <1313503447-13743-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
Depends on https://patchwork.kernel.org/patch/1045472/

 include/linux/dvb/version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
index 1421cc8..66594b1 100644
--- a/include/linux/dvb/version.h
+++ b/include/linux/dvb/version.h
@@ -24,6 +24,6 @@
 #define _DVBVERSION_H_
 
 #define DVB_API_VERSION 5
-#define DVB_API_VERSION_MINOR 3
+#define DVB_API_VERSION_MINOR 4
 
 #endif /*_DVBVERSION_H_*/
-- 
1.7.2.5

