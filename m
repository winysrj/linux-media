Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35899 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760440AbcLAPgV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 10:36:21 -0500
From: Sanjeev <ghane0@gmail.com>
To: linux-doc@vger.kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@kernel.org, corbet@lwn.net,
        Sanjeev Gupta <ghane0@gmail.com>
Subject: [PATCH] Doc: Correct typo, "Introdution" => "Introduction"
Date: Thu,  1 Dec 2016 23:36:00 +0800
Message-Id: <20161201153600.10955-1-ghane0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This corrects a set of spelling mistakes, probably from an
automated conversion.

Signed-off-by: Sanjeev Gupta <ghane0@gmail.com>
---
 Documentation/admin-guide/unicode.rst         | 4 ++--
 Documentation/media/dvb-drivers/intro.rst     | 4 ++--
 Documentation/media/v4l-drivers/cafe_ccic.rst | 4 ++--
 Documentation/process/1.Intro.rst             | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/unicode.rst b/Documentation/admin-guide/unicode.rst
index 4e5c3df..7425a33 100644
--- a/Documentation/admin-guide/unicode.rst
+++ b/Documentation/admin-guide/unicode.rst
@@ -9,8 +9,8 @@ The current version can be found at:
 
 	    http://www.lanana.org/docs/unicode/admin-guide/unicode.rst
 
-Introdution
------------
+Introduction
+------------
 
 The Linux kernel code has been rewritten to use Unicode to map
 characters to fonts.  By downloading a single Unicode-to-font table,
diff --git a/Documentation/media/dvb-drivers/intro.rst b/Documentation/media/dvb-drivers/intro.rst
index 7681835..d6eeb27 100644
--- a/Documentation/media/dvb-drivers/intro.rst
+++ b/Documentation/media/dvb-drivers/intro.rst
@@ -1,5 +1,5 @@
-Introdution
-===========
+Introduction
+============
 
 The main development site and GIT repository for these
 drivers is https://linuxtv.org.
diff --git a/Documentation/media/v4l-drivers/cafe_ccic.rst b/Documentation/media/v4l-drivers/cafe_ccic.rst
index b98eb3b..94f0f58 100644
--- a/Documentation/media/v4l-drivers/cafe_ccic.rst
+++ b/Documentation/media/v4l-drivers/cafe_ccic.rst
@@ -3,8 +3,8 @@ The cafe_ccic driver
 
 Author: Jonathan Corbet <corbet@lwn.net>
 
-Introdution
------------
+Introduction
+------------
 
 "cafe_ccic" is a driver for the Marvell 88ALP01 "cafe" CMOS camera
 controller.  This is the controller found in first-generation OLPC systems,
diff --git a/Documentation/process/1.Intro.rst b/Documentation/process/1.Intro.rst
index 22642b3..e782ae2 100644
--- a/Documentation/process/1.Intro.rst
+++ b/Documentation/process/1.Intro.rst
@@ -1,5 +1,5 @@
-Introdution
-===========
+Introduction
+============
 
 Executive summary
 -----------------
-- 
2.10.2

