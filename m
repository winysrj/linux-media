Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38604 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 09/41] Documentation: FE_READ_SNR: improve man-like format
Date: Mon,  4 Jul 2016 22:30:44 -0300
Message-Id: <9d0c96ba41f6c1c91d9dfa75159a0e5b841c2066.1467670142.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/dvb/FE_READ_SNR.rst | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst b/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
index 2f9759a310f0..11b4f72d684e 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
@@ -6,18 +6,20 @@
 FE_READ_SNR
 ***********
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call returns the signal-to-noise ratio for the signal
 currently received by the front-end. For this command, read-only access
 to the device is sufficient.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = :ref:`FE_READ_SNR`,
-uint16_t *snr);
+.. c:function:: int  ioctl(int fd, int request = FE_READ_SNR, int16_t *snr)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -40,12 +42,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  uint16_t *snr
+       -  uint16_t \*snr
 
-       -  The signal-to-noise ratio is stored into *snr.
+       -  The signal-to-noise ratio is stored into \*snr.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

