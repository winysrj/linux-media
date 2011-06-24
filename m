Return-path: <mchehab@pedra>
Received: from h5.dl5rb.org.uk ([81.2.74.5]:45741 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752895Ab1FXNaW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 09:30:22 -0400
Date: Fri, 24 Jun 2011 14:30:09 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jaroslav Kysela <perex@perex.cz>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
	linux-mips@linux-mips.org
Subject: [PATCH] MEDIA: Fix non-ISA_DMA_API link failure of sound code
Message-ID: <20110624133009.GA30076@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A build with ISA && ISA_DMA && !ISA_DMA_API results in:

  CC      sound/isa/es18xx.o
sound/isa/es18xx.c: In function ‘snd_es18xx_playback1_prepare’:
sound/isa/es18xx.c:501:9: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/es18xx.c: In function ‘snd_es18xx_playback_pointer’:
sound/isa/es18xx.c:818:3: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[2]: *** [sound/isa/es18xx.o] Error 1
  CC      sound/isa/sscape.o
sound/isa/sscape.c: In function ‘upload_dma_data’:
sound/isa/sscape.c:481:3: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[2]: *** [sound/isa/sscape.o] Error 1
  CC      sound/isa/ad1816a/ad1816a_lib.o
sound/isa/ad1816a/ad1816a_lib.c: In function ‘snd_ad1816a_playback_prepare’:
sound/isa/ad1816a/ad1816a_lib.c:244:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/ad1816a/ad1816a_lib.c: In function ‘snd_ad1816a_playback_pointer’:
sound/isa/ad1816a/ad1816a_lib.c:302:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
sound/isa/ad1816a/ad1816a_lib.c: In function ‘snd_ad1816a_free’:
sound/isa/ad1816a/ad1816a_lib.c:544:3: error: implicit declaration of function ‘snd_dma_disable’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/ad1816a/ad1816a_lib.o] Error 1
make[3]: Target `__build' not remade because of errors.
make[2]: *** [sound/isa/ad1816a] Error 2
  CC      sound/isa/es1688/es1688_lib.o
sound/isa/es1688/es1688_lib.c: In function ‘snd_es1688_playback_prepare’:
sound/isa/es1688/es1688_lib.c:417:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/es1688/es1688_lib.c: In function ‘snd_es1688_playback_pointer’:
sound/isa/es1688/es1688_lib.c:509:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/es1688/es1688_lib.o] Error 1
make[3]: Target `__build' not remade because of errors.
make[2]: *** [sound/isa/es1688] Error 2
  CC      sound/isa/gus/gus_dma.o
sound/isa/gus/gus_dma.c: In function ‘snd_gf1_dma_program’:
sound/isa/gus/gus_dma.c:79:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/gus/gus_dma.c: In function ‘snd_gf1_dma_done’:
sound/isa/gus/gus_dma.c:177:3: error: implicit declaration of function ‘snd_dma_disable’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/gus/gus_dma.o] Error 1
  CC      sound/isa/gus/gus_pcm.o
sound/isa/gus/gus_pcm.c: In function ‘snd_gf1_pcm_capture_prepare’:
sound/isa/gus/gus_pcm.c:591:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/gus/gus_pcm.c: In function ‘snd_gf1_pcm_capture_pointer’:
sound/isa/gus/gus_pcm.c:619:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/gus/gus_pcm.o] Error 1
make[3]: Target `__build' not remade because of errors.
make[2]: *** [sound/isa/gus] Error 2
  CC      sound/isa/sb/sb16_csp.o
sound/isa/sb/sb16_csp.c: In function ‘snd_sb_csp_ioctl’:
sound/isa/sb/sb16_csp.c:228:227: error: case label does not reduce to an integer constant
make[3]: *** [sound/isa/sb/sb16_csp.o] Error 1
  CC      sound/isa/sb/sb16_main.o
sound/isa/sb/sb16_main.c: In function ‘snd_sb16_playback_prepare’:
sound/isa/sb/sb16_main.c:276:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/sb/sb16_main.c: In function ‘snd_sb16_playback_pointer’:
sound/isa/sb/sb16_main.c:456:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/sb/sb16_main.o] Error 1
  CC      sound/isa/sb/sb8_main.o
sound/isa/sb/sb8_main.c: In function ‘snd_sb8_playback_prepare’:
sound/isa/sb/sb8_main.c:172:3: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/sb/sb8_main.c: In function ‘snd_sb8_playback_pointer’:
sound/isa/sb/sb8_main.c:425:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/sb/sb8_main.o] Error 1
make[3]: Target `__build' not remade because of errors.
make[2]: *** [sound/isa/sb] Error 2
  CC      sound/isa/wss/wss_lib.o
sound/isa/wss/wss_lib.c: In function ‘snd_wss_playback_prepare’:
sound/isa/wss/wss_lib.c:1025:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/wss/wss_lib.c: In function ‘snd_wss_playback_pointer’:
sound/isa/wss/wss_lib.c:1160:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
sound/isa/wss/wss_lib.c: In function ‘snd_wss_free’:
sound/isa/wss/wss_lib.c:1695:3: error: implicit declaration of function ‘snd_dma_disable’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/wss/wss_lib.o] Error 1

The root cause for this is hidden in this Kconfig warning:

warning: (RADIO_MIROPCM20) selects SND_ISA which has unmet direct dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API)

Adding a dependency on ISA_DMA_API to RADIO_MIROPCM20 fixes these issues.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 drivers/media/radio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index e4c97fd..0aeed28 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -168,7 +168,7 @@ config RADIO_MAXIRADIO
 
 config RADIO_MIROPCM20
 	tristate "miroSOUND PCM20 radio"
-	depends on ISA && VIDEO_V4L2 && SND
+	depends on ISA && ISA_DMA_API && VIDEO_V4L2 && SND
 	select SND_ISA
 	select SND_MIRO
 	---help---
