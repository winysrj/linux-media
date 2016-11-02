Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41893 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754011AbcKBMqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/11] MAINTAINERS: update paths
Date: Wed,  2 Nov 2016 13:46:35 +0100
Message-Id: <20161102124635.11989-12-hverkuil@xs4all.nl>
In-Reply-To: <20161102124635.11989-1-hverkuil@xs4all.nl>
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cec framework and the pulse8-cec driver have been moved out
of staging, so update the MAINTAINERS paths.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93e9f42..5106590 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2958,15 +2958,15 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Supported
-F:	Documentation/cec.txt
+F:	Documentation/media/kapi/cec-core.rst
 F:	Documentation/media/uapi/cec
-F:	drivers/staging/media/cec/
+F:	drivers/media/cec/
 F:	drivers/media/cec-edid.c
 F:	drivers/media/rc/keymaps/rc-cec.c
 F:	include/media/cec.h
 F:	include/media/cec-edid.h
-F:	include/linux/cec.h
-F:	include/linux/cec-funcs.h
+F:	include/uapi/linux/cec.h
+F:	include/uapi/linux/cec-funcs.h
 
 CELL BROADBAND ENGINE ARCHITECTURE
 M:	Arnd Bergmann <arnd@arndb.de>
@@ -9783,7 +9783,7 @@ M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
-F:	drivers/staging/media/pulse8-cec
+F:	drivers/media/usb/pulse8-cec/*
 
 PVRUSB2 VIDEO4LINUX DRIVER
 M:	Mike Isely <isely@pobox.com>
-- 
2.10.1

