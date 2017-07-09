Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33986 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751122AbdGIJqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 05:46:13 -0400
Received: by mail-wr0-f196.google.com with SMTP id k67so17867258wrc.1
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 02:46:12 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH RFC 1/2] app: kaffeine: Fix missing PCR on live streams.
Date: Sun,  9 Jul 2017 10:43:50 +0100
Message-Id: <20170709094351.14642-1-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ISO/IEC standard 13818-1 or ITU-T Rec. H.222.0 standard allow transport
vendors to place PCR (Program Clock Reference) on a different PID.

If the PCR is unset the value is 0x1fff, most vendors appear to set it the
same as video pid in which case it need not be set.

The PCR PID is at an offset of 8 in pmtSection structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 src/dvb/dvbliveview.cpp | 8 ++++++++
 src/dvb/dvbsi.h         | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/src/dvb/dvbliveview.cpp b/src/dvb/dvbliveview.cpp
index cfad892..3e92fa6 100644
--- a/src/dvb/dvbliveview.cpp
+++ b/src/dvb/dvbliveview.cpp
@@ -518,6 +518,7 @@ void DvbLiveView::updatePids(bool forcePatPmtUpdate)
 	DvbPmtSection pmtSection(internal->pmtSectionData);
 	DvbPmtParser pmtParser(pmtSection);
 	QSet<int> newPids;
+	int pcr_pid = pmtSection.pcr_pid();
 	bool updatePatPmt = forcePatPmtUpdate;
 	bool isTimeShifting = internal->timeShiftFile.isOpen();
 
@@ -543,6 +544,13 @@ void DvbLiveView::updatePids(bool forcePatPmtUpdate)
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
 
diff --git a/src/dvb/dvbsi.h b/src/dvb/dvbsi.h
index 4d27252..9b4bbe0 100644
--- a/src/dvb/dvbsi.h
+++ b/src/dvb/dvbsi.h
@@ -1098,6 +1098,11 @@ public:
 		return (at(3) << 8) | at(4);
 	}
 
+	int pcr_pid() const
+	{
+		return ((at(8) & 0x1f) << 8) | at(9);
+	}
+
 	DvbDescriptor descriptors() const
 	{
 		return DvbDescriptor(getData() + 12, descriptorsLength);
-- 
2.13.2
