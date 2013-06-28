Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9514 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab3F1Jel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 05:34:41 -0400
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-doc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] DocBook: upgrade media_api DocBook version to 4.2
Date: Fri, 28 Jun 2013 11:34:20 +0200
Message-id: <1372412060-6989-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the last three errors of media_api DocBook validatation:
# make DOCBOOKS=media_api.xml XMLTOFLAGS='-m Documentation/DocBook/stylesheet.xsl' htmldocs
(...)
media_api.xml:414: element imagedata: validity error : Value "SVG" for attribute format of imagedata is not among the enumerated set
media_api.xml:432: element imagedata: validity error : Value "SVG" for attribute format of imagedata is not among the enumerated set
media_api.xml:452: element imagedata: validity error : Value "SVG" for attribute format of imagedata is not among the enumerated set
(...)

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Hi,

The patch upgrades DocBook to version supporting SVG attribute.
Version 4.2 is already used by uio-howto.tmpl so I suppose it should be safe.
After this patch it will be possible to build media_api DocBook with validation
turned on.

Regards
Andrzej
---
 Documentation/DocBook/media_api.tmpl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 6a8b715..9c92bb8 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -1,6 +1,6 @@
 <?xml version="1.0"?>
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" [
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
+	"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" [
 <!ENTITY % media-entities SYSTEM "./media-entities.tmpl"> %media-entities;
 <!ENTITY media-indices SYSTEM "./media-indices.tmpl">
 
-- 
1.8.1.2

