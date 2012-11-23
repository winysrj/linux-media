Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4425 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab2KWL0P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:26:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 15/15] MAINTAINERS: add vivi entry.
Date: Fri, 23 Nov 2012 12:25:56 +0100
Message-Id: <89762f8eb16398a5c47fc322f8dea1ee4e39e80b.1353669806.git.hans.verkuil@cisco.com>
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
index 4a61ea4..80b8f68 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8185,6 +8185,14 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/via/via-velocity.*
 
+VIVI VIRTUAL VIDEO DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/platform/vivi*
+
 VLAN (802.1Q)
 M:	Patrick McHardy <kaber@trash.net>
 L:	netdev@vger.kernel.org
-- 
1.7.10.4

