Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33984 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757083AbaIDChE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:04 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 29/37] MAINTAINERS: IT913X driver filenames
Date: Thu,  4 Sep 2014 05:36:37 +0300
Message-Id: <1409798205-25645-29-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I removed tuner_ prefix from the driver file names. Update
maintainers entry according to that.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aefa948..182a4a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5033,7 +5033,7 @@ W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
-F:	drivers/media/tuners/tuner_it913x*
+F:	drivers/media/tuners/it913x*
 
 IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
-- 
http://palosaari.fi/

