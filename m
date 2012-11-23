Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4021 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab2KWL0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:26:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/15] MAINTAINERS: add radio-aimslab entry.
Date: Fri, 23 Nov 2012 12:25:49 +0100
Message-Id: <135c43ae9e6816a72e991e4f35467b2afc18cc08.1353669806.git.hans.verkuil@cisco.com>
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
index 89db772..12377a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -463,6 +463,14 @@ S:	Maintained
 F:	drivers/scsi/aic7xxx/
 F:	drivers/scsi/aic7xxx_old/
 
+AIMSLAB FM RADIO RECEIVER DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/radio/radio-aimslab*
+
 AIO
 M:	Benjamin LaHaise <bcrl@kvack.org>
 L:	linux-aio@kvack.org
-- 
1.7.10.4

