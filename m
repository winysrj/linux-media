Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43220 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbFBTwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 15:52:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/5] DocBook: Change DTD schema to version 4.5
Date: Tue,  2 Jun 2015 16:52:40 -0300
Message-Id: <f3234d12cae3182fee1bee1c679cbfd32c75ad8e.1433274739.git.mchehab@osg.samsung.com>
In-Reply-To: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
References: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
In-Reply-To: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
References: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According with the docs at docbook.org, no backward compatible
changes were done between 4.2 and 4.5 schemas. Some fixes were
added, together with new features. So, let's use the latest
4.x schema.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 6591b3a37600..2e7d7692821e 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -1,6 +1,6 @@
 <?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" [
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.5//EN"
+	"http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" [
 <!ENTITY % media-entities SYSTEM "./media-entities.tmpl"> %media-entities;
 <!ENTITY media-indices SYSTEM "./media-indices.tmpl">
 
-- 
2.4.1

