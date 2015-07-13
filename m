Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36271 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbbGMXgu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 19:36:50 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: mchehab@osg.samsung.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, corbet@lwn.net
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [media] DocBook: Fix typo in intro.xml
Date: Tue, 14 Jul 2015 08:36:50 +0900
Message-Id: <1436830610-19316-1-git-send-email-standby24x7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix spelling typos in intro.xml.
This xml file is not created from comments within source,
I fix the xml file.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/media/dvb/intro.xml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index bcc72c2..4abf6d9 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -163,8 +163,8 @@ are called:</para>
 <para>where N enumerates the DVB PCI cards in a system starting
 from&#x00A0;0, and M enumerates the devices of each type within each
 adapter, starting from&#x00A0;0, too. We will omit the &#8220;
-<constant>/dev/dvb/adapterN/</constant>&#8221; in the further dicussion
-of these devices. The naming scheme for the devices is the same wheter
+<constant>/dev/dvb/adapterN/</constant>&#8221; in the further discussion
+of these devices. The naming scheme for the devices is the same whether
 devfs is used or not.</para>
 
 <para>More details about the data structures and function calls of all
-- 
2.5.0.rc1

