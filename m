Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62126 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbbBFSTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2015 13:19:49 -0500
From: Luis de Bethencourt <luis@debethencourt.com>
Date: Fri, 6 Feb 2015 18:17:52 +0000
To: mchehab@osg.samsung.com
Cc: corbet@lwn.net, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] DocBook: grammatical correction on DVB Overview
Message-ID: <20150206181752.GA25234@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 Documentation/DocBook/media/dvb/intro.xml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index 2048b53..e98bfa9 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -85,8 +85,8 @@ real time and re-inserted into the TS.</para>
  <para>Demultiplexer which filters the incoming DVB stream</para>
 
 <para>The demultiplexer splits the TS into its components like audio and
-video streams. Besides usually several of such audio and video streams
-it also contains data streams with information about the programs
+video streams. As well as several of such audio and video streams, it
+usually also contains data streams with information about the programs
 offered in this or other streams of the same provider.</para>
 
 </listitem>
-- 
2.1.3

