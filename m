Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:39120 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1HHOyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 10:54:47 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: user.vdr@gmail.com, alannisota@gmail.com
Subject: [PATCH 1/3] DVB: Add SYS_TURBO for north american turbo code FEC
Date: Mon,  8 Aug 2011 14:54:35 +0000
Message-Id: <1312815277-9502-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Allow to distinguish turbo code from DVB-S

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |    1 +
 include/linux/dvb/frontend.h                    |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 207e1a5..75bea04 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -352,6 +352,7 @@ typedef enum fe_delivery_system {
 	SYS_CMMB,
 	SYS_DAB,
 	SYS_DVBT2,
+	SYS_TURBO,
 } fe_delivery_system_t;
 </programlisting>
 		</section>
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 36a3ed6..1b1094c 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -349,6 +349,7 @@ typedef enum fe_delivery_system {
 	SYS_CMMB,
 	SYS_DAB,
 	SYS_DVBT2,
+	SYS_TURBO,
 } fe_delivery_system_t;
 
 struct dtv_cmds_h {
-- 
1.7.2.5

