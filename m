Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4543 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab2KWL0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:26:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/15] MAINTAINERS: add radio-miropcm20 entry.
Date: Fri, 23 Nov 2012 12:25:52 +0100
Message-Id: <3aad58bbfe8d4f9eb4c0f01f56b1fd703db984c3.1353669806.git.hans.verkuil@cisco.com>
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
index 4870e1b..bd09f47 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4974,6 +4974,14 @@ S:	Supported
 F:	Documentation/mips/
 F:	arch/mips/
 
+MIROSOUND PCM20 FM RADIO RECEIVER DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Odd Fixes
+F:	drivers/media/radio/radio-miropcm20*
+
 MODULE SUPPORT
 M:	Rusty Russell <rusty@rustcorp.com.au>
 S:	Maintained
-- 
1.7.10.4

