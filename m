Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 07/41] Documentation: FE_SET_FRONTEND.rst: improve man-like format
Date: Mon,  4 Jul 2016 22:30:42 -0300
Message-Id: <c5a7df93e65868945c0f19aa11621a1fe96e2ba6.1467670142.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
index 794089897845..38e3971825ea 100644
--- a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
+++ b/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
@@ -6,7 +6,8 @@
 FE_SET_FRONTEND
 ***************
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call starts a tuning operation using specified parameters.
 The result of this call will be successful if the parameters were valid
@@ -18,13 +19,13 @@ operation is initiated before the previous one was completed, the
 previous operation will be aborted in favor of the new one. This command
 requires read/write access to the device.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request =
-:ref:`FE_SET_FRONTEND`, struct
-dvb_frontend_parameters *p);
+.. c:function:: int ioctl(int fd, int request = FE_SET_FRONTEND, struct dvb_frontend_parameters *p)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -48,12 +49,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct dvb_frontend_parameters *p
+       -  struct dvb_frontend_parameters \*p
 
        -  Points to parameters for tuning operation.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

