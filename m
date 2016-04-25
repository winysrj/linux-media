Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36198 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbcDYAaK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 20:30:10 -0400
From: Eric Engestrom <eric@engestrom.ch>
To: linux-kernel@vger.kernel.org
Cc: Eric Engestrom <eric@engestrom.ch>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 23/41] Documentation: DocBook: fix spelling mistake
Date: Mon, 25 Apr 2016 01:24:20 +0100
Message-Id: <1461543878-3639-24-git-send-email-eric@engestrom.ch>
In-Reply-To: <1461543878-3639-1-git-send-email-eric@engestrom.ch>
References: <1461543878-3639-1-git-send-email-eric@engestrom.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Eric Engestrom <eric@engestrom.ch>
---
 Documentation/DocBook/media/dvb/net.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/dvb/net.xml b/Documentation/DocBook/media/dvb/net.xml
index d2e44b7..da095ed 100644
--- a/Documentation/DocBook/media/dvb/net.xml
+++ b/Documentation/DocBook/media/dvb/net.xml
@@ -15,7 +15,7 @@
     that are present on the transport stream. This is done through
     <constant>/dev/dvb/adapter?/net?</constant> device node.
     The data will be available via virtual <constant>dvb?_?</constant>
-    network interfaces, and will be controled/routed via the standard
+    network interfaces, and will be controlled/routed via the standard
     ip tools (like ip, route, netstat, ifconfig, etc).</para>
 <para> Data types and and ioctl definitions are defined via
     <constant>linux/dvb/net.h</constant> header.</para>
-- 
2.8.0

