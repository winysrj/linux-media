Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 10/41] Documentation: FE_READ_SIGNAL_STRENGTH: improve man-like format
Date: Mon,  4 Jul 2016 22:30:45 -0300
Message-Id: <4771b8234765bb35335b689cd785ca8b4eb85797.1467670142.git.mchehab@s-opensource.com>
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
 .../linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst   | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst b/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
index d2dd0fba5363..2a3342dc39a2 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
@@ -6,19 +6,20 @@
 FE_READ_SIGNAL_STRENGTH
 ***********************
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call returns the signal strength value for the signal
 currently received by the front-end. For this command, read-only access
 to the device is sufficient.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl( int fd, int request =
-:ref:`FE_READ_SIGNAL_STRENGTH`,
-uint16_t *strength);
+.. c:function:: int ioctl( int fd, int request = FE_READ_SIGNAL_STRENGTH, uint16_t *strength)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -43,12 +44,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  uint16_t *strength
+       -  uint16_t \*strength
 
-       -  The signal strength value is stored into *strength.
+       -  The signal strength value is stored into \*strength.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

