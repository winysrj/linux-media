Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3346 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab2KWL0H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:26:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/15] MAINTAINERS: add entry for the quickcam parallel port webcams.
Date: Fri, 23 Nov 2012 12:25:44 +0100
Message-Id: <0962d2ac8a7522ca3d4e4178ef0639b2818b1ee4.1353669806.git.hans.verkuil@cisco.com>
In-Reply-To: <1353669956-4843-1-git-send-email-hverkuil@xs4all.nl>
References: <1353669956-4843-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7fb3123c4bf43540c13505c82c408fa492cdd48c.1353669806.git.hans.verkuil@cisco.com>
References: <7fb3123c4bf43540c13505c82c408fa492cdd48c.1353669806.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4db8384..5d5462d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6069,6 +6069,14 @@ L:	linux-hexagon@vger.kernel.org
 S:	Supported
 F:	arch/hexagon/
 
+QUICKCAM PARALLEL PORT WEBCAMS
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Odd Fixes
+F:	drivers/media/parport/*-qcam*
+
 RADOS BLOCK DEVICE (RBD)
 M:	Yehuda Sadeh <yehuda@inktank.com>
 M:	Sage Weil <sage@inktank.com>
-- 
1.7.10.4

