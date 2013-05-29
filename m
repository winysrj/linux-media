Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14969 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965855Ab3E2M2U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 08:28:20 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNK001837YS6330@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 May 2013 13:28:19 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org
Cc: 'Javier Martin' <javier.martin@vista-silicon.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Subject: RE: [PATCH 0/9] CODA patches in preparation for decoding support
Date: Wed, 29 May 2013 14:28:15 +0200
Message-id: <021701ce5c67$fe85ede0$fb91c9a0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Patches 5/9 an 6/9 have a style issues (Line > 80) found by checkpatch.
Can you comment on this?

Also patch 8/9 does not apply cleanly to my branch. I think that it might be
because
I am missing patches that were taken by Hans.

Warnings from checkpatch:

Patch 5/9

WARNING: line over 80 characters
#73: FILE: drivers/media/platform/coda.c:959:
+		coda_parabuf_write(ctx, i * 3 + 2, paddr + ysize + ysize/4);
/* Cr */

WARNING: line over 80 characters
#99: FILE: drivers/media/platform/coda.c:961:
+		if (dev->devtype->product != CODA_DX6 && fourcc ==
V4L2_PIX_FMT_H264)

WARNING: line over 80 characters
#100: FILE: drivers/media/platform/coda.c:962:
+			coda_parabuf_write(ctx, 96 + i,
ctx->internal_frames[i].paddr + ysize + ysize/4 + ysize/4);

total: 0 errors, 3 warnings, 76 lines checked

Patch 6/9
WARNING: line over 80 characters
#186: FILE: drivers/media/platform/coda.c:293:
+	CODA_CODEC(CODADX6_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420,
V4L2_PIX_FMT_H264,  720, 576),

WARNING: line over 80 characters
#187: FILE: drivers/media/platform/coda.c:294:
+	CODA_CODEC(CODADX6_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420,
V4L2_PIX_FMT_MPEG4, 720, 576),

WARNING: line over 80 characters
#191: FILE: drivers/media/platform/coda.c:298:
+	CODA_CODEC(CODA7_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420,
V4L2_PIX_FMT_H264,   1280, 720),

WARNING: line over 80 characters
#192: FILE: drivers/media/platform/coda.c:299:
+	CODA_CODEC(CODA7_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420,
V4L2_PIX_FMT_MPEG4,  1280, 720),

WARNING: line over 80 characters
#584: FILE: drivers/media/platform/coda.c:1110:
+		value |= (q_data_src->height & CODADX6_PICHEIGHT_MASK) <<
CODA_PICHEIGHT_OFFSET;

WARNING: line over 80 characters
#588: FILE: drivers/media/platform/coda.c:1114:
+		value |= (q_data_src->height & CODA7_PICHEIGHT_MASK) <<
CODA_PICHEIGHT_OFFSET;

total: 0 errors, 6 warnings, 603 lines checked

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Philipp Zabel
> Sent: Thursday, May 23, 2013 4:43 PM
> To: linux-media@vger.kernel.org
> Cc: Javier Martin; Hans Verkuil
> Subject: [PATCH 0/9] CODA patches in preparation for decoding support
> 
> The following patch series contains a few fixes and cleanups in
> preparation for decoding support.
> I've simplified the parameter buffer setup code, changed the hardware
> command register access locking for multi-instance support on CODA7,
> and added a list of supported codecs per device type, where each codec
> can have its own frame size limitation.
> 
> I intend follow up with a series that adds h.264 decoding support for
> CODA7541 (i.MX53) and CODA960 (i.MX6), but what I'll send to the list
> exactly depends a bit on whether the mem2mem changes in the patch
> "[media] mem2mem: add support for hardware buffered queue"
> will be accepted.
> 
> regards
> Philipp
> 
> ---
>  drivers/media/platform/coda.c | 600
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> +++++++++++------------------------------------------------------------
> -----------
>  drivers/media/platform/coda.h |  11 ++-
>  2 files changed, 326 insertions(+), 285 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html


