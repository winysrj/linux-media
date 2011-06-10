Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:63560 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1FJKn2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 06:43:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id BEC42106757
	for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 12:43:26 +0200 (CEST)
Date: Fri, 10 Jun 2011 12:43:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] media: DVB_NET must depend on DVB_CORE
Message-ID: <Pine.LNX.4.64.1106101243050.12671@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index dc61895..c2ee0aa 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -87,7 +87,7 @@ config DVB_CORE
 config DVB_NET
 	bool "DVB Network Support"
 	default (NET && INET)
-	depends on NET && INET
+	depends on NET && INET && DVB_CORE
 	help
 	  The DVB network support in the DVB core can
 	  optionally be disabled if this
-- 
1.7.2.5

