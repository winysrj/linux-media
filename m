Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:47228 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3B1LEv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Feb 2013 06:04:51 -0500
Message-ID: <512F25AA.3010506@schinagl.nl>
Date: Thu, 28 Feb 2013 10:38:50 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Christoph Pfister <christophpfister@gmail.com>,
	Johannes Stezenbach <js@linuxtv.org>
Subject: [RFC][PATCH]
Content-Type: multipart/mixed;
 boundary="------------040508000806010700010904"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040508000806010700010904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hey all,

as an original Austrian, I was curious about the current status of the 
at DVB-T scan tables. I found that neither the original source was any 
longer available, nor where all frequencies listed. I thus located the 
new list [1] and updated the list accordingly. I am not aware if any of 
the original authors of at-Official (from git log) that are actual 
employees of the ORS and thus renamed the file to at-All as that is more 
representative and more in line with other files.

With regard to the content of the scan table, I could not find 
information on any of the parameters except for the bandwith so I 
assumed they where all identical (3/4 QAM16 8K 1/4). The only exception 
is 578 MHz, which has been both 1/4 and 1/8th guard-interval and thus 
left it as such. Since I'm many kilometers away from Austria I have no 
way of scanning all those frequencies. While I assume the list from the 
ORS is accurate, some confirmation before pushing would be appreciated. 
I'll wait a while before pushing this one from my local repository.

Oliver


[1] 
http://www.ors.at/fileadmin/user_upload/downloads/DVB-T_Kanalbezeichnungen_und_Mittenfrequenzen.pdf


--------------040508000806010700010904
Content-Type: text/x-patch;
 name="0001-Update-for-Austrian-DVB-T.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Update-for-Austrian-DVB-T.patch"

>From 3cda18f8369c515bd47d1ae1e2ffc88cfbb97436 Mon Sep 17 00:00:00 2001
From: Oliver Schinagl <oliver@schinagl.nl>
Date: Thu, 28 Feb 2013 11:16:20 +0100
Subject: [PATCH] Update for Austrian DVB-T

Renamed at-Official to at-All.
Added and updated all frequencies. from
http://www.ors.at/fileadmin/user_upload/downloads/DVB-T_Kanalbezeichnungen_und_Mittenfrequenzen.pdf
No further details are given besides an 8MHz bandwith so assuming the previous settings for now.
---
 dvb-t/at-All      | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 dvb-t/at-Official | 24 ------------------------
 2 files changed, 53 insertions(+), 24 deletions(-)
 create mode 100644 dvb-t/at-All
 delete mode 100644 dvb-t/at-Official

diff --git a/dvb-t/at-All b/dvb-t/at-All
new file mode 100644
index 0000000..183dc0c
--- /dev/null
+++ b/dvb-t/at-All
@@ -0,0 +1,53 @@
+# Austria, all DVB-T transmitters run by ORS
+# Created from 
+# http://www.ors.at/fileadmin/user_upload/downloads/DVB-T_Kanalbezeichnungen_und_Mittenfrequenzen.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 474000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 482000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 490000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 498000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 506000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 514000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 522000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 530000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 538000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 546000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 554000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 562000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 570000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 578000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 578000000 8MHz 3/4 NONE QAM16 8k 1/8 NONE
+T 586000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 594000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 602000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 610000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 618000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 626000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 634000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 642000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 650000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 658000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 666000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 674000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 682000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 690000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 698000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 706000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 714000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 722000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 730000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 738000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 746000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 754000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 762000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 770000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 778000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 786000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 794000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 802000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 810000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 826000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 834000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 842000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 850000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
+T 858000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
diff --git a/dvb-t/at-Official b/dvb-t/at-Official
deleted file mode 100644
index cdb221c..0000000
--- a/dvb-t/at-Official
+++ /dev/null
@@ -1,24 +0,0 @@
-# Austria, all DVB-T transmitters run by ORS
-# Created from http://www.ors.at/view08/ors.php?mid=94
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 474000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 490000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 498000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 514000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 522000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 530000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 538000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 546000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 554000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 562000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 578000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 578000000 8MHz 3/4 NONE QAM16 8k 1/8 NONE
-T 594000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 602000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 610000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 634000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 650000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 666000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 698000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 722000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-T 754000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
-- 
1.7.12.4


--------------040508000806010700010904--
