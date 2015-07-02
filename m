Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:43539 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbbGBNdy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jul 2015 09:33:54 -0400
Message-ID: <55953D77.1060105@xs4all.nl>
Date: Thu, 02 Jul 2015 15:32:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] DocBook: fix media-ioc-device-info.xml type
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation had two media_version entries. The second one was a typo and
it should be driver_version instead. Correct this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-device-info.xml b/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
index 2ce5214..b0a21ac 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
@@ -102,7 +102,7 @@
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>media_version</structfield></entry>
+	    <entry><structfield>driver_version</structfield></entry>
 	    <entry>Media device driver version, formatted with the
 	    <constant>KERNEL_VERSION()</constant> macro. Together with the
 	    <structfield>driver</structfield> field this identifies a particular
