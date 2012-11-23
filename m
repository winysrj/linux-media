Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3724 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2KWL0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:26:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/15] MAINTAINERS: add radio-gemtek entry.
Date: Fri, 23 Nov 2012 12:25:50 +0100
Message-Id: <2e7c39a7e5d69826afd721d8916444f4eba16020.1353669806.git.hans.verkuil@cisco.com>
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
index 12377a2..5758e93 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3318,6 +3318,14 @@ W:	http://www.icp-vortex.com/
 S:	Supported
 F:	drivers/scsi/gdt*
 
+GEMTEK FM RADIO RECEIVER DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/radio/radio-gemtek*
+
 GENERIC GPIO I2C DRIVER
 M:	Haavard Skinnemoen <hskinnemoen@gmail.com>
 S:	Supported
-- 
1.7.10.4

