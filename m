Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbcGEBb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 13/41] Documentation: FE_GET_EVENT.rst: improve man-like format
Date: Mon,  4 Jul 2016 22:30:48 -0300
Message-Id: <be9bc0ac80e133b4e78aa2eb7328d44677ac335e.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parsing this file were causing lots of warnings with sphinx,
due to the c function prototypes.

Fix that by prepending them with .. c:function::

While here, use the same way we document man-like pages,
at the V4L side of the book and add escapes to asterisks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
index 08a090212f96..e0c66b877ada 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
@@ -6,7 +6,8 @@
 FE_GET_EVENT
 ************
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call returns a frontend event if available. If an event is
 not available, the behavior depends on whether the device is in blocking
@@ -14,12 +15,13 @@ or non-blocking mode. In the latter case, the call fails immediately
 with errno set to ``EWOULDBLOCK``. In the former case, the call blocks until
 an event becomes available.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = QPSK_GET_EVENT, struct
-dvb_frontend_event *ev);
+.. c:function:: int  ioctl(int fd, int request = QPSK_GET_EVENT, struct dvb_frontend_event *ev)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -52,7 +54,8 @@ PARAMETERS
        -  if any, is to be stored.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

