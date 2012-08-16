Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33359 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab2HPA3R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 20:29:17 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/5] DocBook: update ioctl error codes
Date: Thu, 16 Aug 2012 03:28:40 +0300
Message-Id: <1345076921-9773-5-git-send-email-crope@iki.fi>
In-Reply-To: <1345076921-9773-1-git-send-email-crope@iki.fi>
References: <1345076921-9773-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ENOTTY is now returned for unimplemented ioctl by dvb-frontend.
Old EOPNOTSUPP & ENOSYS could be still returned by some drivers
as well as other "non standard" error codes.

EAGAIN is returned in case of device is in state where it cannot
perform requested operation. This is for example sleep and statistics
are queried. Quick check for few demodulator drivers reveals there is
a lot of different error codes used in such case currently, few to
mention still: EOPNOTSUPP, ENOSYS, EAGAIN ... Lets try harmonize.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/gen-errors.xml | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
index 5bbf3ce..737ecaa 100644
--- a/Documentation/DocBook/media/v4l/gen-errors.xml
+++ b/Documentation/DocBook/media/v4l/gen-errors.xml
@@ -7,6 +7,13 @@
     <tbody valign="top">
 	<!-- Keep it ordered alphabetically -->
       <row>
+	<entry>EAGAIN</entry>
+	<entry>The ioctl can't be handled because the device is in state where
+	       it can't perform it. This could happen for example in case where
+	       device is sleeping and ioctl is performed to query statistics.
+	</entry>
+      </row>
+      <row>
 	<entry>EBADF</entry>
 	<entry>The file descriptor is not a valid.</entry>
       </row>
@@ -51,11 +58,6 @@
 	       for periodic transfers (up to 80% of the USB bandwidth).</entry>
       </row>
       <row>
-	<entry>ENOSYS or EOPNOTSUPP</entry>
-	<entry>Function not available for this device (dvb API only. Will likely
-	       be replaced anytime soon by ENOTTY).</entry>
-      </row>
-      <row>
 	<entry>EPERM</entry>
 	<entry>Permission denied. Can be returned if the device needs write
 		permission, or some special capabilities is needed
-- 
1.7.11.2

