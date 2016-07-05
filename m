Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38663 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbcGEBb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 14/41] Documentation: FE_DISHNETWORK_SEND_LEGACY_CMD: improve man-like format
Date: Mon,  4 Jul 2016 22:30:49 -0300
Message-Id: <29abbd81ce999719ec8e94597a3f8c6f02980af4.1467670142.git.mchehab@s-opensource.com>
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
 .../media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst         | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst b/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
index 890b5edb0350..ff94ac9122d0 100644
--- a/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
+++ b/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
@@ -6,7 +6,8 @@
 FE_DISHNETWORK_SEND_LEGACY_CMD
 ******************************
 
-DESCRIPTION
+Description
+-----------
 
 WARNING: This is a very obscure legacy command, used only at stv0299
 driver. Should not be used on newer drivers.
@@ -17,13 +18,13 @@ frontend, for Dish Network legacy switches.
 As support for this ioctl were added in 2004, this means that such
 dishes were already legacy in 2004.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request =
-:ref:`FE_DISHNETWORK_SEND_LEGACY_CMD`,
-unsigned long cmd);
+.. c:function:: int  ioctl(int fd, int request = FE_DISHNETWORK_SEND_LEGACY_CMD, unsigned long cmd)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -39,7 +40,8 @@ PARAMETERS
        -  sends the specified raw cmd to the dish via DISEqC.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

