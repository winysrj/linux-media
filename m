Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:45519 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752763AbdCIJlJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 04:41:09 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] docs-rst: media: Push CEC documentation under CEC section
Date: Thu,  9 Mar 2017 11:40:18 +0200
Message-Id: <1489052418-12575-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC documentation added two sections on the main media kAPI level.
There should be only one.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/kapi/cec-core.rst | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 81c6d8e..79db774 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -27,11 +27,8 @@ HDMI 1.3a specification is sufficient:
 http://www.microprocessor.org/HDMISpecification13a.pdf
 
 
-The Kernel Interface
-====================
-
-CEC Adapter
------------
+CEC Adapter Interface
+---------------------
 
 The struct cec_adapter represents the CEC adapter hardware. It is created by
 calling cec_allocate_adapter() and deleted by calling cec_delete_adapter():
-- 
2.7.4
