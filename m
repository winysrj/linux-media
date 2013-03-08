Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:39693 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3CHKsl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 05:48:41 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so925426eek.39
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2013 02:48:40 -0800 (PST)
Message-ID: <5139C206.3070700@kotsbak.com>
Date: Fri, 08 Mar 2013 11:48:38 +0100
From: Marius Kotsbak <marius@kotsbak.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: 694728@bugs.debian.org
Subject: [media-ctl] Patch to Debian packaging
Content-Type: multipart/mixed;
 boundary="------------040306090602070306010204"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040306090602070306010204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Patch attached to get the provided Debian packaging working again.

--
Marius

--------------040306090602070306010204
Content-Type: text/x-patch;
 name="0001-debian-update-according-to-renames-done-in-commit-9a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-debian-update-according-to-renames-done-in-commit-9a.pa";
 filename*1="tch"

>From 3f33eb034a2b2e0bcc52960b694a33b7347cb8b0 Mon Sep 17 00:00:00 2001
From: "Marius B. Kotsbak" <marius@geneseque.com>
Date: Fri, 8 Mar 2013 11:32:17 +0100
Subject: [PATCH] debian: update according to renames done in commit
 9a5f1e0365265310545abdd43da7d28a44fd43a6.

---
 debian/libmediactl-dev.install   |    2 +-
 debian/libv4l2subdev-dev.install |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/debian/libmediactl-dev.install b/debian/libmediactl-dev.install
index 002caa4..4180102 100644
--- a/debian/libmediactl-dev.install
+++ b/debian/libmediactl-dev.install
@@ -1,4 +1,4 @@
-usr/include/mediactl/media.h
+usr/include/mediactl/mediactl.h
 usr/lib/libmediactl.a
 usr/lib/libmediactl.so
 usr/lib/libmediactl.la
diff --git a/debian/libv4l2subdev-dev.install b/debian/libv4l2subdev-dev.install
index b7dde11..4da3669 100644
--- a/debian/libv4l2subdev-dev.install
+++ b/debian/libv4l2subdev-dev.install
@@ -1,4 +1,4 @@
-usr/include/mediactl/subdev.h
+usr/include/mediactl/v4l2subdev.h
 usr/lib/libv4l2subdev.a
 usr/lib/libv4l2subdev.so
 usr/lib/libv4l2subdev.la
-- 
1.7.10.4


--------------040306090602070306010204--
