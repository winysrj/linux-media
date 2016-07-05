Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbcGEBb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 11/41] Documentation: FE_READ_BER.rst: improve man-like format
Date: Mon,  4 Jul 2016 22:30:46 -0300
Message-Id: <f93a168dcac3174ac489d028bca8525e747b7be2.1467670142.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/dvb/FE_READ_BER.rst | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_READ_BER.rst b/Documentation/linux_tv/media/dvb/FE_READ_BER.rst
index 218e2298615b..f0b364baba96 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_BER.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_BER.rst
@@ -6,7 +6,8 @@
 FE_READ_BER
 ***********
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call returns the bit error rate for the signal currently
 received/demodulated by the front-end. For this command, read-only
@@ -14,10 +15,10 @@ access to the device is sufficient.
 
 SYNOPSIS
 
-int ioctl(int fd, int request = :ref:`FE_READ_BER`,
-uint32_t *ber);
+.. c:function:: int  ioctl(int fd, int request = FE_READ_BER, uint32_t *ber)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -40,12 +41,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  uint32_t *ber
+       -  uint32_t \*ber
 
-       -  The bit error rate is stored into *ber.
+       -  The bit error rate is stored into \*ber.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

