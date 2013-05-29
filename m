Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47058 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934233Ab3E2Mvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 08:51:40 -0400
Message-ID: <1369831845.4050.60.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 0/9] CODA patches in preparation for decoding support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org,
	'Javier Martin' <javier.martin@vista-silicon.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>
Date: Wed, 29 May 2013 14:50:45 +0200
In-Reply-To: <021701ce5c67$fe85ede0$fb91c9a0$%debski@samsung.com>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
	 <021701ce5c67$fe85ede0$fb91c9a0$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 29.05.2013, 14:28 +0200 schrieb Kamil Debski:
> Hi,
> 
> Patches 5/9 an 6/9 have a style issues (Line > 80) found by checkpatch.
> Can you comment on this?

I think that especially with the CODA_CODEC array, readability is
improved by overstepping the 80 character barrier.

> Also patch 8/9 does not apply cleanly to my branch. I think that it might be
> because
> I am missing patches that were taken by Hans.

That is correct. I should have mentioned those are prerequisites.

regards
Philipp

> Warnings from checkpatch:
> 
> Patch 5/9
> 
> WARNING: line over 80 characters
> #73: FILE: drivers/media/platform/coda.c:959:
> +		coda_parabuf_write(ctx, i * 3 + 2, paddr + ysize + ysize/4);
> /* Cr */
> 
> WARNING: line over 80 characters
> #99: FILE: drivers/media/platform/coda.c:961:
> +		if (dev->devtype->product != CODA_DX6 && fourcc ==
> V4L2_PIX_FMT_H264)
> 
> WARNING: line over 80 characters
> #100: FILE: drivers/media/platform/coda.c:962:
> +			coda_parabuf_write(ctx, 96 + i,
> ctx->internal_frames[i].paddr + ysize + ysize/4 + ysize/4);
> 
> total: 0 errors, 3 warnings, 76 lines checked
> 
> Patch 6/9
> WARNING: line over 80 characters
> #186: FILE: drivers/media/platform/coda.c:293:
> +	CODA_CODEC(CODADX6_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420,
> V4L2_PIX_FMT_H264,  720, 576),
> 
> WARNING: line over 80 characters
> #187: FILE: drivers/media/platform/coda.c:294:
> +	CODA_CODEC(CODADX6_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420,
> V4L2_PIX_FMT_MPEG4, 720, 576),
> 
> WARNING: line over 80 characters
> #191: FILE: drivers/media/platform/coda.c:298:
> +	CODA_CODEC(CODA7_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420,
> V4L2_PIX_FMT_H264,   1280, 720),
> 
> WARNING: line over 80 characters
> #192: FILE: drivers/media/platform/coda.c:299:
> +	CODA_CODEC(CODA7_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420,
> V4L2_PIX_FMT_MPEG4,  1280, 720),
> 
> WARNING: line over 80 characters
> #584: FILE: drivers/media/platform/coda.c:1110:
> +		value |= (q_data_src->height & CODADX6_PICHEIGHT_MASK) <<
> CODA_PICHEIGHT_OFFSET;
> 
> WARNING: line over 80 characters
> #588: FILE: drivers/media/platform/coda.c:1114:
> +		value |= (q_data_src->height & CODA7_PICHEIGHT_MASK) <<
> CODA_PICHEIGHT_OFFSET;
> 
> total: 0 errors, 6 warnings, 603 lines checked
> 
> Best wishes,


