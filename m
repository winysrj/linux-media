Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53431
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752102AbdHZKHc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:07:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 3/6] media: frontend.rst: convert SEC note into footnote
Date: Sat, 26 Aug 2017 07:07:11 -0300
Message-Id: <14fbbe83c1f14a851dbd2ea9005bcc2c7df288be.1503742025.git.mchehab@s-opensource.com>
In-Reply-To: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
References: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
In-Reply-To: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
References: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The description of what SEC means fits well as a footnote.
That makes the need of saying that SEC is only for Satellite
when it was mentioned, as the footnote already says that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/frontend.rst | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/Documentation/media/uapi/dvb/frontend.rst b/Documentation/media/uapi/dvb/frontend.rst
index 313f46a4c6a6..0bfade2b72cf 100644
--- a/Documentation/media/uapi/dvb/frontend.rst
+++ b/Documentation/media/uapi/dvb/frontend.rst
@@ -25,7 +25,7 @@ The DVB frontend controls several sub-devices including:
 
 -  Low noise amplifier (LNA)
 
--  Satellite Equipment Control (SEC) hardware (only for Satellite).
+-  Satellite Equipment Control (SEC) [#f1]_.
 
 The frontend can be accessed through ``/dev/dvb/adapter?/frontend?``.
 Data types and ioctl definitions can be accessed by including
@@ -36,13 +36,16 @@ Data types and ioctl definitions can be accessed by including
    Transmission via the internet (DVB-IP) is not yet handled by this
    API but a future extension is possible.
 
-On Satellite systems, the API support for the Satellite Equipment
-Control (SEC) allows to power control and to send/receive signals to
-control the antenna subsystem, selecting the polarization and choosing
-the Intermediate Frequency IF) of the Low Noise Block Converter Feed
-Horn (LNBf). It supports the DiSEqC and V-SEC protocols. The DiSEqC
-(digital SEC) specification is available at
-`Eutelsat <http://www.eutelsat.com/satellites/4_5_5.html>`__.
+
+.. [#f1]
+
+   On Satellite systems, the API support for the Satellite Equipment
+   Control (SEC) allows to power control and to send/receive signals to
+   control the antenna subsystem, selecting the polarization and choosing
+   the Intermediate Frequency IF) of the Low Noise Block Converter Feed
+   Horn (LNBf). It supports the DiSEqC and V-SEC protocols. The DiSEqC
+   (digital SEC) specification is available at
+   `Eutelsat <http://www.eutelsat.com/satellites/4_5_5.html>`__.
 
 
 .. toctree::
-- 
2.13.3
