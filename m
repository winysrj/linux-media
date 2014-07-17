Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3611 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaGQTlY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 15:41:24 -0400
Message-ID: <53C826DD.1050903@xs4all.nl>
Date: Thu, 17 Jul 2014 21:41:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: davinci compiler warnings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Can you take a look at these new warnings? I've just upgraded my compiler for
the daily build to 4.9.1, so that's probably why they weren't seen before.

Regards,

	Hans

/home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c: In function 'vpif_remove':
/home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:1389:36: warning: iteration 1u invokes undefined behavior [-Waggressive-loop-optimizations]
   vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
                                    ^
/home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:1385:2: note: containing loop
  for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
  ^
/home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c: In function 'vpif_remove':
/home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c:1581:36: warning: iteration 1u invokes undefined behavior [-Waggressive-loop-optimizations]
   vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
                                    ^
/home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c:1577:2: note: containing loop
  for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
  ^
/home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c:1580:23: warning: array subscript is above array bounds [-Warray-bounds]
   common = &ch->common[i];
                       ^
