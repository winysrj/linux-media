Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:57304 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751946AbeDEKBc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:01:32 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 1/2] Add instructions for building static binaries
Date: Thu,  5 Apr 2018 13:00:39 +0300
Message-Id: <1522922440-8622-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1522922440-8622-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1522922440-8622-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Static binaries are useful e.g. when copying test binaries to other
systems. Document how to build them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 INSTALL | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/INSTALL b/INSTALL
index 765fa26..8c98a76 100644
--- a/INSTALL
+++ b/INSTALL
@@ -53,6 +53,22 @@ export PKG_CONFIG_LIBDIR=/path/to/cross/root/lib
 ./configure --host=arm-linux-gnueabihf --without-jpeg
 make
 
+Building static binaries:
+-------------------------
+
+Fully static binares can be built by setting LDFLAGS for the configure and
+using an option for disabling shared libraries:
+
+	$ LDFLAGS="--static -static" ./configure --disable-shared
+
+Note that this requires static variants of all the libraries needed for
+linking which may not be available in all systems.
+
+In order to build binaries that are not dependent on libraries contained
+in v4l-utils, simply use the --disable-shared option:
+
+	$ ./configure --disable-shared
+
 Android Cross Compiling and Installing:
 ----------------
 
-- 
2.7.4
