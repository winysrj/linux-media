Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab3EULRy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 07:17:54 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4LBHrH1005062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 21 May 2013 07:17:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] update saa7134 and tuner cardlists
Date: Tue, 21 May 2013 08:17:47 -0300
Message-Id: <1369135067-661-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those are automatically updated using the cardlist script.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/video4linux/CARDLIST.saa7134 | 1 +
 Documentation/video4linux/CARDLIST.tuner   | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index b3ad683..8df17d0 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -190,3 +190,4 @@
 189 -> Kworld PC150-U                           [17de:a134]
 190 -> Asus My Cinema PS3-100                   [1043:48cd]
 191 -> Hawell HW-9004V1
+192 -> AverMedia AverTV Satellite Hybrid+FM A706 [1461:2055]
diff --git a/Documentation/video4linux/CARDLIST.tuner b/Documentation/video4linux/CARDLIST.tuner
index 5b83a3f..ac88621 100644
--- a/Documentation/video4linux/CARDLIST.tuner
+++ b/Documentation/video4linux/CARDLIST.tuner
@@ -86,6 +86,6 @@ tuner=85 - Philips FQ1236 MK5
 tuner=86 - Tena TNF5337 MFD
 tuner=87 - Xceive 4000 tuner
 tuner=88 - Xceive 5000C tuner
-tuner=89 - Sony PAL+SECAM (BTF-PG472Z)
-tuner=90 - Sony NTSC-M-JP (BTF-PK467Z)
-tuner=91 - Sony NTSC-M (BTF-PB463Z)
+tuner=89 - Sony BTF-PG472Z PAL/SECAM
+tuner=90 - Sony BTF-PK467Z NTSC-M-JP
+tuner=91 - Sony BTF-PB463Z NTSC-M
-- 
1.8.1.4

