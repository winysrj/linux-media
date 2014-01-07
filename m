Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3153 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaAGNHL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 08:07:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/6] DocBook media: fix email addresses.
Date: Tue,  7 Jan 2014 14:06:52 +0100
Message-Id: <1389100017-42855-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
References: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Mauro's old redhat email address is no longer valid, update to the
current email address.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/dvb/dvbapi.xml | 2 +-
 Documentation/DocBook/media/v4l/v4l2.xml   | 2 +-
 Documentation/DocBook/media_api.tmpl       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
index 0197bcc..49f46e8 100644
--- a/Documentation/DocBook/media/dvb/dvbapi.xml
+++ b/Documentation/DocBook/media/dvb/dvbapi.xml
@@ -18,7 +18,7 @@
 <firstname>Mauro</firstname>
 <othername role="mi">Carvalho</othername>
 <surname>Chehab</surname>
-<affiliation><address><email>mchehab@redhat.com</email></address></affiliation>
+<affiliation><address><email>m.chehab@samsung.com</email></address></affiliation>
 <contrib>Ported document to Docbook XML.</contrib>
 </author>
 </authorgroup>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 8469fe1..53f5306 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -70,7 +70,7 @@ MPEG stream embedded, sliced VBI data format in this specification.
 Remote Controller chapter.</contrib>
 	<affiliation>
 	  <address>
-	    <email>mchehab@redhat.com</email>
+	    <email>m.chehab@samsung.com</email>
 	  </address>
 	</affiliation>
       </author>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 4c8d282..df6db3a 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -91,7 +91,7 @@ Foundation. A copy of the license is included in the chapter entitled
 <firstname>Mauro</firstname>
 <surname>Chehab</surname>
 <othername role="mi">Carvalho</othername>
-<affiliation><address><email>mchehab@redhat.com</email></address></affiliation>
+<affiliation><address><email>m.chehab@samsung.com</email></address></affiliation>
 <contrib>Initial version.</contrib>
 </author>
 </authorgroup>
-- 
1.8.5.2

