Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56213 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab2HMCeD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 22:34:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] DVB API: add INTERLEAVING_AUTO
Date: Mon, 13 Aug 2012 05:33:22 +0300
Message-Id: <1344825202-2296-3-git-send-email-crope@iki.fi>
In-Reply-To: <1344825202-2296-1-git-send-email-crope@iki.fi>
References: <1344825202-2296-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After thinking twice, I ended up adding own value for AUTO
interleaving instead of using NONE.

API minor number is not needed to increase as that patch should
be the same Kernel as interleaving parameter is initially added.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml | 1 +
 include/linux/dvb/frontend.h                    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 5aea35e..eddfe6f 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -821,6 +821,7 @@ typedef enum fe_hierarchy {
 	<programlisting>
 enum fe_interleaving {
 	INTERLEAVING_NONE,
+	INTERLEAVING_AUTO,
 	INTERLEAVING_240,
 	INTERLEAVING_720,
 };
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 2dd5823..c92b4d6 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -222,6 +222,7 @@ typedef enum fe_hierarchy {
 
 enum fe_interleaving {
 	INTERLEAVING_NONE,
+	INTERLEAVING_AUTO,
 	INTERLEAVING_240,
 	INTERLEAVING_720,
 };
-- 
1.7.11.2

