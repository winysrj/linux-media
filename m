Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57342 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2GZLNp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 07:13:45 -0400
Received: by mail-yw0-f46.google.com with SMTP id m54so1795176yhm.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 04:13:44 -0700 (PDT)
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Russell King <linux@arm.linux.org.uk>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
	alsa-devel@alsa-project.org, Katsuya MATSUBARA <matsu@igel.co.jp>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 2/4] ALSA: pcm - Don't define ARCH_HAS_DMA_MMAP_COHERENT privately for ARM
Date: Thu, 26 Jul 2012 20:13:09 +0900
Message-Id: <1343301191-26001-3-git-send-email-hdk@igel.co.jp>
In-Reply-To: <1343301191-26001-1-git-send-email-hdk@igel.co.jp>
References: <1343301191-26001-1-git-send-email-hdk@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

The ARM architecture now defines ARCH_HAS_DMA_MMAP_COHERENT, there's no
need to define it privately anymore.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 sound/core/pcm_native.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 53b5ada..84ead60 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3156,13 +3156,6 @@ static const struct vm_operations_struct snd_pcm_vm_ops_data_fault = {
 	.fault =	snd_pcm_mmap_data_fault,
 };
 
-#ifndef ARCH_HAS_DMA_MMAP_COHERENT
-/* This should be defined / handled globally! */
-#ifdef CONFIG_ARM
-#define ARCH_HAS_DMA_MMAP_COHERENT
-#endif
-#endif
-
 /*
  * mmap the DMA buffer on RAM
  */
-- 
1.7.0.4

