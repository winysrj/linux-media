Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215Ab3AOCbh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 21:31:37 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0F2VbDx010093
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 21:31:37 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv10 14/15] dvb: increase API version
Date: Tue, 15 Jan 2013 00:31:00 -0200
Message-Id: <1358217061-14982-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to statistics, we should update the DVB API version.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/dvb/dvbapi.xml | 2 +-
 include/uapi/linux/dvb/version.h           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
index 757488b..0197bcc 100644
--- a/Documentation/DocBook/media/dvb/dvbapi.xml
+++ b/Documentation/DocBook/media/dvb/dvbapi.xml
@@ -84,7 +84,7 @@ Added ISDB-T test originally written by Patrick Boettcher
 
 
 <title>LINUX DVB API</title>
-<subtitle>Version 5.8</subtitle>
+<subtitle>Version 5.10</subtitle>
 <!-- ADD THE CHAPTERS HERE -->
   <chapter id="dvb_introdution">
     &sub-intro;
diff --git a/include/uapi/linux/dvb/version.h b/include/uapi/linux/dvb/version.h
index 827cce7..e53e2ad 100644
--- a/include/uapi/linux/dvb/version.h
+++ b/include/uapi/linux/dvb/version.h
@@ -24,6 +24,6 @@
 #define _DVBVERSION_H_
 
 #define DVB_API_VERSION 5
-#define DVB_API_VERSION_MINOR 9
+#define DVB_API_VERSION_MINOR 10
 
 #endif /*_DVBVERSION_H_*/
-- 
1.7.11.7

