Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58619 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbaHFKKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 06:10:23 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9V009VMQWPLQ70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Aug 2014 11:10:01 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	kernel@pengutronix.de
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Subject: RE: [PATCH RESEND 00/15] CODA patches for v3.17
Date: Wed, 06 Aug 2014 12:10:23 +0200
Message-id: <0d9001cfb15e$a38f8d90$eaaea8b0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

> From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> Sent: Tuesday, August 05, 2014 7:00 PM
> 
> Hi Kamil, Mauro,
> 
> thank you for merging most of the pending coda patches in time for
> v3.17.
> Here are the remaining patches, rebased on top of the current media
> for-3.17 branch.
> I have left all checkpatch warnings in the "[media] coda: request BIT
> processor interrupt by name" patch untouched, as this only moves code
> around. 

As for warnings, I think it could be corrected in another patch. But
please do that ASAP. Also it would be really good to correct warnings/error
in remaining files. Hint: checkpatch -f run on particular files can give
you the list of violations.

I am not saying that all lines over 80 are wrong. Some of them are
justified,
but when splitting a line into two is simple and does not hurt the code it
should be done.

I would like errors to be corrected now. I think, there is one error only
in these patches. Could you do this?

1) coda: move BIT specific functions into separate file

ERROR: return is not a function, parentheses are not required
#83: FILE: drivers/media/platform/coda/coda-bit.c:40:
+	return (coda_read(dev, CODA_REG_BIT_CUR_PC) != 0);

> The other patches are checkpatch clean, except for the
> CODA_CODEC definition lines that I'd like to keep unbroken.
> I've also added a fixup for 38932df4cb17 "coda: move H.264 helper
> function into separate file" in the front.
> 
> regards
> Philipp
> 
> Philipp Zabel (15):
>   [media] coda: include header for memcpy
>   [media] coda: move BIT specific functions into separate file
>   [media] coda: remove unnecessary peek at next destination buffer from
>     coda_finish_decode
>   [media] coda: request BIT processor interrupt by name
>   [media] coda: dequeue buffers if start_streaming fails
>   [media] coda: dequeue buffers on streamoff
>   [media] coda: skip calling coda_find_codec in encoder try_fmt_vid_out
>   [media] coda: allow running coda without iram on mx6dl
>   [media] coda: increase max vertical frame size to 1088
>   [media] coda: add an intermediate debug level
>   [media] coda: improve allocation error messages
>   [media] coda: fix timestamp list handling
>   [media] coda: fix coda_s_fmt_vid_out
>   [media] coda: set capture frame size with output S_FMT
>   [media] coda: disable old cropping ioctls
> 
>  drivers/media/platform/coda/Makefile      |    2 +-
>  drivers/media/platform/coda/coda-bit.c    | 1823
> +++++++++++++++++++++++++++
>  drivers/media/platform/coda/coda-common.c | 1944 ++-------------------
> --------
>  drivers/media/platform/coda/coda-h264.c   |    1 +
>  drivers/media/platform/coda/coda.h        |   56 +
>  5 files changed, 1976 insertions(+), 1850 deletions(-)  create mode
> 100644 drivers/media/platform/coda/coda-bit.c
> 
> --
> 2.0.1

