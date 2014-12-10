Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:41077 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764AbaLJHWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 02:22:48 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 59C522A0086
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 08:22:37 +0100 (CET)
Message-ID: <5487F4BD.3060307@xs4all.nl>
Date: Wed, 10 Dec 2014 08:22:37 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: vivi -> vivid
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vivi driver no longer exists and is replaced by the vivid driver.
Update MAINTAINERS accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

---
diff --git a/MAINTAINERS b/MAINTAINERS
index 9c49eb6..6dc7f50 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10032,13 +10032,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/via/via-velocity.*
 
-VIVI VIRTUAL VIDEO DRIVER
+VIVID VIRTUAL VIDEO DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Maintained
-F:	drivers/media/platform/vivi*
+F:	drivers/media/platform/vivid/*
 
 VLAN (802.1Q)
 M:	Patrick McHardy <kaber@trash.net>
