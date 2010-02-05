Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:58774 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009Ab0BEOTX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 09:19:23 -0500
Received: from localhost (localhost [127.0.0.1])
	by bamako.nerim.net (Postfix) with ESMTP id EE67F39DF14
	for <linux-media@vger.kernel.org>; Fri,  5 Feb 2010 15:19:16 +0100 (CET)
Received: from bamako.nerim.net ([127.0.0.1])
	by localhost (bamako.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kMB1lDXk9z0t for <linux-media@vger.kernel.org>;
	Fri,  5 Feb 2010 15:19:16 +0100 (CET)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by bamako.nerim.net (Postfix) with ESMTP id F111D39DEF4
	for <linux-media@vger.kernel.org>; Fri,  5 Feb 2010 15:19:15 +0100 (CET)
Date: Fri, 5 Feb 2010 15:19:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] adv7180 builds since kernel 2.6.26
Message-ID: <20100205151917.4f85bdc2@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDEO_ADV7180 is listed twice in v4l/versions.txt: once in [2.6.31]
and once in [2.6.26]. As I have tested that it builds fine in 2.6.26,
drop the former entry.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 v4l/versions.txt |    1 -
 1 file changed, 1 deletion(-)

--- v4l-dvb.orig/v4l/versions.txt	2010-01-25 21:25:50.000000000 +0100
+++ v4l-dvb/v4l/versions.txt	2010-02-05 15:13:47.000000000 +0100
@@ -18,7 +18,6 @@ VIDEO_DM355_CCDC
 # Start version for those drivers - probably compile with older versions
 VIDEO_CX25821
 VIDEO_CX25821_ALSA
-VIDEO_ADV7180
 RADIO_TEF6862
 # follow_pfn needed by VIDEOBUF_DMA_CONTIG and drivers that use it
 VIDEOBUF_DMA_CONTIG


-- 
Jean Delvare
