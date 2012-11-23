Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3687 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab2KWL0H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:26:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/15] MAINTAINERS: add cx2341x entry.
Date: Fri, 23 Nov 2012 12:25:43 +0100
Message-Id: <4d58fb64ef3dd8277a8aa1e44a5aa692b40f0083.1353669806.git.hans.verkuil@cisco.com>
In-Reply-To: <1353669956-4843-1-git-send-email-hverkuil@xs4all.nl>
References: <1353669956-4843-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7fb3123c4bf43540c13505c82c408fa492cdd48c.1353669806.git.hans.verkuil@cisco.com>
References: <7fb3123c4bf43540c13505c82c408fa492cdd48c.1353669806.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f0a8b4..4db8384 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2179,6 +2179,15 @@ F:	Documentation/video4linux/cx18.txt
 F:	drivers/media/pci/cx18/
 F:	include/uapi/linux/ivtv*
 
+CX2341X MPEG ENCODER HELPER MODULE
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/i2c/cx2341x*
+F:	include/media/cx2341x*
+
 CX88 VIDEO4LINUX DRIVER
 M:	Mauro Carvalho Chehab <mchehab@redhat.com>
 L:	linux-media@vger.kernel.org
-- 
1.7.10.4

