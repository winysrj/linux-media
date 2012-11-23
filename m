Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4394 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2KWNKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:10:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <michael@mihu.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] MAINTAINERS: Taking over saa7146 maintainership from Michael Hunold.
Date: Fri, 23 Nov 2012 14:10:30 +0100
Message-Id: <a2e0787b707c15e5905e9cc9a7be50e9c077f78a.1353675798.git.hans.verkuil@cisco.com>
In-Reply-To: <1353676231-5684-1-git-send-email-hverkuil@xs4all.nl>
References: <1353676231-5684-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 80b8f68..76b1c1d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6440,10 +6440,9 @@ F:	Documentation/video4linux/saa7134/
 F:	drivers/media/pci/saa7134/
 
 SAA7146 VIDEO4LINUX-2 DRIVER
-M:	Michael Hunold <michael@mihu.de>
+M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://www.mihu.de/linux/saa7146
 S:	Maintained
 F:	drivers/media/common/saa7146/
 F:	drivers/media/pci/saa7146/
-- 
1.7.10.4

