Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:23435 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910Ab0CJJqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 04:46:05 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by linux (Postfix) with ESMTP id CBC8014E079
	for <linux-media@vger.kernel.org>; Wed, 10 Mar 2010 10:46:02 +0100 (CET)
Message-ID: <4B976A5A.400@lbruninx.be>
Date: Wed, 10 Mar 2010 10:46:02 +0100
From: Luc Bruninx <luc2005@lbruninx.be>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Proposed patch for libv4l-0.6.4 to support Asus K70AD where webcam
 is upsid down
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I installed Ubuntu Karmic on a Asus laptop PRO79A equipped with a
motherboard K70AD. However, with the original libv4l-0.6.4 library, the
image of the webcam is upside down. I suggest you this little patch that
solved the problem on my machine.

<!--- libv4lcontrol.diff -->

--- libv4l-0.6.4/libv4lconvert/control/libv4lcontrol.c    2010-01-16
03:37:23.000000000 +0100
+++ libv4l-0.6.4-2/libv4lconvert/control/libv4lcontrol.c    2010-03-10
09:59:09.000000000 +0100
@@ -128,6 +128,10 @@
     V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED },
   { 0x04f2, 0xb071, 0, "ASUSTeK Computer Inc.        ", "K70AB     ",
     V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED },
+  /* Ajout Asus PRO79A: Motherboard K70AD ici... */
+  { 0x04f2, 0xb071, 0, "ASUSTeK Computer Inc.        ", "K70AD     ",
+    V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED },
+  /* Webcam Chicony CNF7129 */
   { 0x04f2, 0xb071, 0, "ASUSTeK Computer Inc.        ", "K70IC     ",
     V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED },
   { 0x04f2, 0xb071, 0, "ASUSTeK Computer Inc.        ", "K70IJ     ",

<!-- END libv4lcontrol.diff -->

Thank you for the interest you will bring to this suggestion.
 
Luc BRUNINX
(Belgium)
