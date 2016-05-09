Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42464 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbcEIRSB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2016 13:18:01 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/2] [media] update cx23885 and em28xx cardlists
Date: Mon,  9 May 2016 14:16:18 -0300
Message-Id: <685f11097ab21221d734a259f2ba20684ffe3f05.1462814171.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some new boards were added without updating those lists.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/video4linux/CARDLIST.cx23885 | 2 ++
 Documentation/video4linux/CARDLIST.em28xx  | 1 +
 2 files changed, 3 insertions(+)

diff --git a/Documentation/video4linux/CARDLIST.cx23885 b/Documentation/video4linux/CARDLIST.cx23885
index 44a4cfbfdc40..85a8fdcfcdaa 100644
--- a/Documentation/video4linux/CARDLIST.cx23885
+++ b/Documentation/video4linux/CARDLIST.cx23885
@@ -52,3 +52,5 @@
  51 -> DVBSky T982                                         [4254:0982]
  52 -> Hauppauge WinTV-HVR5525                             [0070:f038]
  53 -> Hauppauge WinTV Starburst                           [0070:c12a]
+ 54 -> ViewCast 260e                                       [1576:0260]
+ 55 -> ViewCast 460e                                       [1576:0460]
diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index 67209998a439..ae9d5a852305 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -96,3 +96,4 @@
  95 -> Leadtek VC100                            (em2861)        [0413:6f07]
  96 -> Terratec Cinergy T2 Stick HD             (em28178)
  97 -> Elgato EyeTV Hybrid 2008 INT             (em2884)        [0fd9:0018]
+ 98 -> PLEX PX-BCUD                             (em28178)
-- 
2.5.5

