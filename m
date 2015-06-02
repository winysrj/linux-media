Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbbFBTwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 15:52:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/5] DocBook: specify language and encoding for the document
Date: Tue,  2 Jun 2015 16:52:39 -0300
Message-Id: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define the usage of UTF-8 encoding and let clear that the document
is in English.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 43eda245a1b5..6591b3a37600 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -1,4 +1,4 @@
-<?xml version="1.0"?>
+<?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
 	"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" [
 <!ENTITY % media-entities SYSTEM "./media-entities.tmpl"> %media-entities;
@@ -33,7 +33,7 @@
 <!ENTITY dash-ent-24            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
 ]>
 
-<book id="media_api">
+<book id="media_api" lang="en">
 <bookinfo>
 	<title>LINUX MEDIA INFRASTRUCTURE API</title>
 
-- 
2.4.1

