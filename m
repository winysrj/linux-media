Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24782 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751578AbdHPMWr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:22:47 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl
Subject: [PATCH v2 2/2] docs-rst: media: Document broken frame handling in stream stop for CSI-2
Date: Wed, 16 Aug 2017 15:20:18 +0300
Message-Id: <1502886018-31488-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some CSI-2 transmitters will finish an ongoing frame whereas others will
not. Document that receiver drivers should not assume a particular
behaviour but to work in both cases.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/kapi/csi2.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/media/kapi/csi2.rst b/Documentation/media/kapi/csi2.rst
index e33fcb9..0560100 100644
--- a/Documentation/media/kapi/csi2.rst
+++ b/Documentation/media/kapi/csi2.rst
@@ -51,6 +51,16 @@ not active. Some transmitters do this automatically but some have to
 be explicitly programmed to do so, and some are unable to do so
 altogether due to hardware constraints.
 
+Stopping the transmitter
+^^^^^^^^^^^^^^^^^^^^^^^^
+
+A transmitter stops sending the stream of images as a result of
+calling the ``.s_stream()`` callback. Some transmitters may stop the
+stream at a frame boundary whereas others stop immediately,
+effectively leaving the current frame unfinished. The receiver driver
+should not make assumptions either way, but function properly in both
+cases.
+
 Receiver drivers
 ----------------
 
-- 
2.7.4
