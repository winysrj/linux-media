Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45798 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbcGRB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 03/36] [media] doc-rst: Remove deprecated API.html document
Date: Sun, 17 Jul 2016 22:55:46 -0300
Message-Id: <92effdf8b8b214165d5437f02b0ccbe80ba244cf.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document points to some old stuff. Just remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/video4linux/API.html | 27 ---------------------------
 1 file changed, 27 deletions(-)
 delete mode 100644 Documentation/video4linux/API.html

diff --git a/Documentation/video4linux/API.html b/Documentation/video4linux/API.html
deleted file mode 100644
index eaf948cf1ae7..000000000000
--- a/Documentation/video4linux/API.html
+++ /dev/null
@@ -1,27 +0,0 @@
-<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
-<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
- <head>
-  <meta content="text/html;charset=ISO-8859-2" http-equiv="Content-Type" />
-  <title>V4L API</title>
- </head>
- <body>
-  <h1>Video For Linux APIs</h1>
-  <table border="0">
-   <tr>
-    <td>
-     <a href="https://linuxtv.org/downloads/legacy/video4linux/API/V4L1_API.html">V4L original API</a>
-    </td>
-    <td>
-     Obsoleted by V4L2 API
-    </td>
-   </tr>
-   <tr>
-    <td>
-     <a href="http://v4l2spec.bytesex.org/spec-single/v4l2.html">V4L2 API</a>
-    </td>
-    <td>Should be used for new projects
-    </td>
-   </tr>
-  </table>
- </body>
-</html>
-- 
2.7.4

