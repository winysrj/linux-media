Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35534 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbbHUQi6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 12:38:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] DocBook: fix an unbalanced <para> tag
Date: Fri, 21 Aug 2015 13:38:49 -0300
Message-Id: <3b4c8b200a74e30c3526f66fc59660e0c978cabc.1440175125.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The </para> got lost on some change at the DVB docbook, making
the tag unbalanced and causing a warning. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index d30751338493..51db15648099 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -164,7 +164,7 @@ are called:</para>
 from&#x00A0;0, and M enumerates the devices of each type within each
 adapter, starting from&#x00A0;0, too. We will omit the &#8220;
 <constant>/dev/dvb/adapterN/</constant>&#8221; in the further discussion
-of these devices.
+of these devices.</para>
 
 <para>More details about the data structures and function calls of all
 the devices are described in the following chapters.</para>
-- 
2.4.3

