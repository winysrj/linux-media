Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:56530 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030338Ab2GLQMe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 12:12:34 -0400
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 01045DB
	for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 16:12:15 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas5.st.com [10.75.90.71])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 6B0635360
	for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 16:12:15 +0000 (GMT)
From: Nicolas THERY <nicolas.thery@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 12 Jul 2012 18:12:12 +0200
Subject: [PATCH for 3.6] v4l: DocBook: fix version number typo
Message-ID: <4FFEF75C.5020309@st.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Nicolas Thery <nicolas.thery@st.com>
---
 Documentation/DocBook/media/v4l/compat.xml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 97b8951..e519ce6 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2460,7 +2460,7 @@ that used it. It was originally scheduled for removal in 2.6.35.
     </section>
      <section>
-      <title>V4L2 in Linux 3.5</title>
+      <title>V4L2 in Linux 3.6</title>
       <orderedlist>
 	<listitem>
 	  <para>Replaced <structfield>input</structfield> in
