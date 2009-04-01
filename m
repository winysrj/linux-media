Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41283 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZDACDh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 22:03:37 -0400
Date: Wed, 1 Apr 2009 06:03:27 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-next@vger.kernel.org, mchehab@infradead.org,
	linux-media@vger.kernel.org, srinivasa.deevi@conexant.com
Subject: [PATCH] cx231xx: fix wrong usage of select in kconfig
Message-ID: <20090401020327.GA6808@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDEO_CX231XX_ALSA depends on SND && SND_PCM,
but if we select it from VIDEO_CX231XX entry
it does not automatically select SND_PCM.
It causes build error:
ERROR: "snd_pcm_period_elapsed" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!

Documentation/kbuild/kconfig-language.txt:
Note:
        select should be used with care. select will force
        a symbol to a value without visiting the dependencies.
        By abusing select you are able to select a symbol FOO even
        if FOO depends on BAR that is not set.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/media/video/cx231xx/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx231xx/Kconfig b/drivers/media/video/cx231xx/Kconfig
index 9115654..85ae751 100644
--- a/drivers/media/video/cx231xx/Kconfig
+++ b/drivers/media/video/cx231xx/Kconfig
@@ -6,7 +6,6 @@ config VIDEO_CX231XX
        select VIDEO_IR
        select VIDEOBUF_VMALLOC
        select VIDEO_CX25840
-       select VIDEO_CX231XX_ALSA
 
 	---help---
 	  This is a video4linux driver for Conexant 231xx USB based TV cards.
