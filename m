Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35692 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbdGIJqT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 05:46:19 -0400
Received: by mail-wr0-f196.google.com with SMTP id z45so18012307wrb.2
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 02:46:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH RFC 2/2] app: kaffeine: Fix missing PCR on stream recordings.
Date: Sun,  9 Jul 2017 10:43:51 +0100
Message-Id: <20170709094351.14642-2-tvboxspy@gmail.com>
In-Reply-To: <20170709094351.14642-1-tvboxspy@gmail.com>
References: <20170709094351.14642-1-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ISO/IEC standard 13818-1 or ITU-T Rec. H.222.0 standard allow transport
vendors to place PCR (Program Clock Reference) on a different PID.

This patch adds it recording to file.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 src/dvb/dvbrecording.cpp | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/dvb/dvbrecording.cpp b/src/dvb/dvbrecording.cpp
index ecb4777..12a57dc 100644
--- a/src/dvb/dvbrecording.cpp
+++ b/src/dvb/dvbrecording.cpp
@@ -961,6 +961,7 @@ void DvbRecordingFile::pmtSectionChanged(const QByteArray &pmtSectionData_)
 	pmtSectionData = pmtSectionData_;
 	DvbPmtSection pmtSection(pmtSectionData);
 	DvbPmtParser pmtParser(pmtSection);
+	int pcr_pid = pmtSection.pcr_pid();
 	QSet<int> newPids;
 
 	if (pmtParser.videoPid != -1) {
@@ -979,6 +980,13 @@ void DvbRecordingFile::pmtSectionChanged(const QByteArray &pmtSectionData_)
 		newPids.insert(pmtParser.teletextPid);
 	}
 
+	/* check PCR PID is set */
+	if (pcr_pid != 0x1fff) {
+		/* Check not already in list */
+		if (!newPids.contains(pcr_pid))
+			newPids.insert(pcr_pid);
+	}
+
 	for (int i = 0; i < pids.size(); ++i) {
 		int pid = pids.at(i);
 
-- 
2.13.2
