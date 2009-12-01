Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:17726 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZLASwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 13:52:41 -0500
Message-ID: <4B1565CD.5080908@oracle.com>
Date: Tue, 01 Dec 2009 10:51:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] media/radio/miro: depends on SND
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
In-Reply-To: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

miropcm20 uses ALSA (snd_) interfaces from the SND_MIRO
driver, so it should depend on SND.
(selecting SND_MIRO when CONFIG_SND is not enabled is a
problem.)

drivers/built-in.o: In function `vidioc_s_ctrl':
radio-miropcm20.c:(.text+0x227499): undefined reference to `snd_aci_cmd'
drivers/built-in.o: In function `vidioc_s_frequency':
radio-miropcm20.c:(.text+0x227574): undefined reference to `snd_aci_cmd'
radio-miropcm20.c:(.text+0x227588): undefined reference to `snd_aci_cmd'
drivers/built-in.o: In function `pcm20_init':
radio-miropcm20.c:(.init.text+0x2a784): undefined reference to `snd_aci_get_aci'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/radio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091201.orig/drivers/media/radio/Kconfig
+++ linux-next-20091201/drivers/media/radio/Kconfig
@@ -197,7 +197,7 @@ config RADIO_MAESTRO
 
 config RADIO_MIROPCM20
 	tristate "miroSOUND PCM20 radio"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA && VIDEO_V4L2 && SND
 	select SND_MIRO
 	---help---
 	  Choose Y here if you have this FM radio card. You also need to enable
