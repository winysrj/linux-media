Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44710 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752450AbdCIKXE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 05:23:04 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de
Subject: [PATCH 1/1] docs-rst: Make the CSI-2 bus initialisation documentation match reality
Date: Thu,  9 Mar 2017 12:22:11 +0200
Message-Id: <1489054931-13755-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the CSI-2 bus documentation to tell that the LP-11 mode is not
mandatory as there are transmitters that cannot be explicitly set to LP-11
mode. Instead, say that this what the transmitter drivers shall do if
possible.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/kapi/csi2.rst | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/kapi/csi2.rst b/Documentation/media/kapi/csi2.rst
index 2004db0..e33fcb9 100644
--- a/Documentation/media/kapi/csi2.rst
+++ b/Documentation/media/kapi/csi2.rst
@@ -45,10 +45,11 @@ where
    * - bits_per_sample
      - Number of bits per sample.
 
-The transmitter drivers must configure the CSI-2 transmitter to *LP-11
-mode* whenever the transmitter is powered on but not active. Some
-transmitters do this automatically but some have to be explicitly
-programmed to do so.
+The transmitter drivers must, if possible, configure the CSI-2
+transmitter to *LP-11 mode* whenever the transmitter is powered on but
+not active. Some transmitters do this automatically but some have to
+be explicitly programmed to do so, and some are unable to do so
+altogether due to hardware constraints.
 
 Receiver drivers
 ----------------
-- 
2.7.4
