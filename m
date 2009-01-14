Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:46746 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759044AbZANQMV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 11:12:21 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2: Fix EXPOSURE_AUTO_PRIORITY control documentation
Date: Wed, 14 Jan 2009 17:12:06 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Schimek <mschimek@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141712.06644.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
--

As the source isn't under version control I've generated a diff against the
0.24 tarball.

--- controls.sgml	2009-01-14 17:06:58.000000000 +0100
+++ controls.sgml	2009-01-14 17:07:13.000000000 +0100
@@ -1548,7 +1548,7 @@
             <entry>boolean</entry>
           </row><row><entry spanname="descr">When
 <constant>V4L2_CID_EXPOSURE_AUTO</constant> is set to
-<constant>AUTO</constant> or <constant>SHUTTER_PRIORITY</constant>,
+<constant>AUTO</constant> or <constant>APERTURE_PRIORITY</constant>,
 this control determines if the device may dynamically vary the frame
 rate. By default this feature is disabled (0) and the frame rate must
 remain constant.</entry>
