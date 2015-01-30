Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50445 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbbA3Ptd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2015 10:49:33 -0500
MIME-Version: 1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Fri, 30 Jan 2015 15:49:01 +0000
Message-ID: <CA+V-a8uVRZr3cYNsq5yehxjWoZMp6HMzm486KktKOXYkzJyFbA@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] media: blackfin: bfin_capture enhancements
To: LMML <linux-media@vger.kernel.org>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Scott,

On Thu, Jan 22, 2015 at 10:18 PM, Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> This patch series, enhances blackfin capture driver with
> vb2 helpers.
>
> Changes for v2:
> --------------
> Only patches 5/15 and 8/15 as per Scott's suggestions.
>
> Lad, Prabhakar (15):
>   media: blackfin: bfin_capture: drop buf_init() callback
>   media: blackfin: bfin_capture: release buffers in case
>     start_streaming() call back fails
>   media: blackfin: bfin_capture: set min_buffers_needed
>   media: blackfin: bfin_capture: improve buf_prepare() callback
>   media: blackfin: bfin_capture: improve queue_setup() callback
>   media: blackfin: bfin_capture: use vb2_fop_mmap/poll
>   media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
>   media: blackfin: bfin_capture: use vb2_ioctl_* helpers
>   media: blackfin: bfin_capture: make sure all buffers are returned on
>     stop_streaming() callback
>   media: blackfin: bfin_capture: return -ENODATA for *std calls
>   media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
>   media: blackfin: bfin_capture: add support for vidioc_create_bufs
>   media: blackfin: bfin_capture: add support for VB2_DMABUF
>   media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
>   media: blackfin: bfin_capture: set v4l2 buffer sequence
>
>  drivers/media/platform/blackfin/bfin_capture.c | 311 ++++++++-----------------
>  1 file changed, 99 insertions(+), 212 deletions(-)
>
Can you ACK the series ? so that its easier for Hans to pick it up.

Cheers,
--Prabhakar Lad
