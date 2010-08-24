Return-path: <mchehab@pedra>
Received: from smtp22.services.sfr.fr ([93.17.128.12]:61299 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab0HXJu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 05:50:58 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2211.sfr.fr (SMTP Server) with ESMTP id D32C570000A1
	for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 11:50:53 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (unknown [93.5.34.224])
	by msfrf2211.sfr.fr (SMTP Server) with SMTP id 45DB670000A2
	for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 11:50:49 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.5.34.224] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 11:50:49 +0200
Subject: [PATCH] cx88: Kconfig: Remove EXPERIMENTAL dependency from
 VIDEO_CX88_ALSA
From: lawrence rust <lawrence@softsystem.co.uk>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 11:50:48 +0200
Message-ID: <1282643448.1381.15.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The cx88-alsa module has been around since January 2006 and has seen no
significant changes since September 2007.  It is stable in operation
and so I believe that the 'experimental' tag is no longer warranted.
---
 drivers/media/video/cx88/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index c7e5851..f5e64f1 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -17,7 +17,7 @@ config VIDEO_CX88
 
 config VIDEO_CX88_ALSA
 	tristate "Conexant 2388x DMA audio support"
-	depends on VIDEO_CX88 && SND && EXPERIMENTAL
+	depends on VIDEO_CX88 && SND
 	select SND_PCM
 	---help---
 	  This is a video4linux driver for direct (DMA) audio on
-- 
1.7.0.4




