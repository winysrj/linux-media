Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 08/41] Documentation: FE_READ_UNCORRECTED_BLOCKS: improve man-like format
Date: Mon,  4 Jul 2016 22:30:43 -0300
Message-Id: <526e1e900e65c60f0178ef9867b6eeb55393b395.1467670142.git.mchehab@s-opensource.com>
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
 .../linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst  | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst b/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
index fa770d25b3de..0ec53ab669ee 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
@@ -6,7 +6,8 @@
 FE_READ_UNCORRECTED_BLOCKS
 **************************
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call returns the number of uncorrected blocks detected by the
 device driver during its lifetime. For meaningful measurements, the
@@ -14,13 +15,13 @@ increment in block count during a specific time interval should be
 calculated. For this command, read-only access to the device is
 sufficient.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl( int fd, int request =
-:ref:`FE_READ_UNCORRECTED_BLOCKS`,
-uint32_t *ublocks);
+.. c:function:: int ioctl( int fd, int request =FE_READ_UNCORRECTED_BLOCKS, uint32_t *ublocks)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -45,12 +46,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  uint32_t *ublocks
+       -  uint32_t \*ublocks
 
        -  The total number of uncorrected blocks seen by the driver so far.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

