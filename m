Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46318 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757054AbcGJNLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 09:11:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: lars@opdenkamp.eu, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/5] MAINTAINERS: add entry for the pulse8-cec driver
Date: Sun, 10 Jul 2016 15:11:20 +0200
Message-Id: <1468156281-25731-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
References: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add entry for the pulse8-cec driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a975b8e..7486757 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9258,6 +9258,13 @@ F:	include/linux/tracehook.h
 F:	include/uapi/linux/ptrace.h
 F:	kernel/ptrace.c
 
+PULSE8-CEC DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/staging/media/pulse8-cec
+
 PVRUSB2 VIDEO4LINUX DRIVER
 M:	Mike Isely <isely@pobox.com>
 L:	pvrusb2@isely.net	(subscribers-only)
-- 
2.8.1

