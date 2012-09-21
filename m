Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1084 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab2IULom (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 07:44:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/3] DocBook: EAGAIN == EWOULDBLOCK
Date: Fri, 21 Sep 2012 13:44:26 +0200
Message-Id: <187f1fb0891d7ddeef202c6be7d86209c354a632.1348227670.git.hans.verkuil@cisco.com>
In-Reply-To: <1348227868-20895-1-git-send-email-hverkuil@xs4all.nl>
References: <1348227868-20895-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Merge the two entries since they are one and the same error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/gen-errors.xml |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
index 737ecaa..7e29a4e 100644
--- a/Documentation/DocBook/media/v4l/gen-errors.xml
+++ b/Documentation/DocBook/media/v4l/gen-errors.xml
@@ -7,10 +7,12 @@
     <tbody valign="top">
 	<!-- Keep it ordered alphabetically -->
       <row>
-	<entry>EAGAIN</entry>
+	<entry>EAGAIN (aka EWOULDBLOCK)</entry>
 	<entry>The ioctl can't be handled because the device is in state where
 	       it can't perform it. This could happen for example in case where
 	       device is sleeping and ioctl is performed to query statistics.
+	       It is also returned when the ioctl would need to wait
+	       for an event, but the device was opened in non-blocking mode.
 	</entry>
       </row>
       <row>
@@ -63,11 +65,6 @@
 		permission, or some special capabilities is needed
 		(e. g. root)</entry>
       </row>
-      <row>
-	<entry>EWOULDBLOCK</entry>
-	<entry>Operation would block. Used when the ioctl would need to wait
-	       for an event, but the device was opened in non-blocking mode.</entry>
-      </row>
     </tbody>
   </tgroup>
 </table>
-- 
1.7.10.4

