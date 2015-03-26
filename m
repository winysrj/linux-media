Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36305 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbbCZJSn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 05:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
Date: Thu, 26 Mar 2015 17:18:42 +0800
Message-ID: <CAHG8p1AZMnV_ZLA1Ou=wejxwaHRObX1aAgO=xbXiwwEsJZ9EZA@mail.gmail.com>
Subject: Re: [PATCH v4 00/17] media: blackfin: bfin_capture enhancements
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lad and Hans,

2015-03-08 22:40 GMT+08:00 Lad Prabhakar <prabhakar.csengg@gmail.com>:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> This patch series, enhances blackfin capture driver with
> vb2 helpers.
>
> Changes for v4:
> 1: Improved commit message for path 4/17 and 5/17.
> 2: Added Ack's from Scott to patches 1-15
> 3: Two new patches 16/17 and 17/17
>
> Lad, Prabhakar (17):
>   media: blackfin: bfin_capture: drop buf_init() callback
>   media: blackfin: bfin_capture: release buffers in case
>     start_streaming() call back fails
>   media: blackfin: bfin_capture: set min_buffers_needed
>   media: blackfin: bfin_capture: set vb2 buffer field
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
>   media: blackfin: bfin_capture: drop bcap_get_unmapped_area()
>   media: blackfin: bfin_capture: embed video_device struct in
>     bcap_device
>
>  drivers/media/platform/blackfin/bfin_capture.c | 348 ++++++++-----------------
>  1 file changed, 103 insertions(+), 245 deletions(-)
>

for patch 16/17,
Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
Tested-by: Scott Jiang <scott.jiang.linux@gmail.com>

Hans, I tried to use v4l2-compliance but it failed to compile. Sorry
for telling you it have passed compilation because I forgot to use
blackfin toolchain.
./configure --without-jpeg  --host=bfin-linux-uclibc --disable-libv4l

The main problem is there is no argp.h in uClibc, how to disable checking this?

checking for argp.h... no
configure: error: Cannot continue: argp.h not found

Scott
