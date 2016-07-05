Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbcGEBb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 12/41] Documentation: FE_GET_FRONTEND.rst: improve man-like format
Date: Mon,  4 Jul 2016 22:30:47 -0300
Message-Id: <835362befa314f09b96bace01961c71494a61473.1467670142.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
index ee73fb448ef8..cb6bcb5fb9b7 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
@@ -6,18 +6,19 @@
 FE_GET_FRONTEND
 ***************
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call queries the currently effective frontend parameters. For
 this command, read-only access to the device is sufficient.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request =
-:ref:`FE_GET_FRONTEND`, struct
-dvb_frontend_parameters *p);
+.. c:function:: int ioctl(int fd, int request = FE_GET_FRONTEND, struct dvb_frontend_parameters *p)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -41,12 +42,13 @@ PARAMETERS
 
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

