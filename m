Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36316 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbbD2V7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 17:59:16 -0400
Received: by lbbqq2 with SMTP id qq2so30744393lbb.3
        for <linux-media@vger.kernel.org>; Wed, 29 Apr 2015 14:59:14 -0700 (PDT)
Message-ID: <5541542F.7010505@cogentembedded.com>
Date: Thu, 30 Apr 2015 00:59:11 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com
CC: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 1/1] V4L2: platform: Renesas R-Car JPEG codec driver
References: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/30/2015 12:53 AM, Mikhail Ulyanov wrote:

> Here's the the driver for the Renesas R-Car JPEG processing unit driver.

    One "the" is enough. And one "driver" too, you probbaly forgot to remove 
the word at the end.

> The driver is implemented within the V4L2 framework as a mem-to-mem device.  It

    Perhaps "memory-to-memory"?

> presents two video nodes to userspace, one for the encoding part, and one for
> the decoding part.

> It was found that the only working mode for encoding is no markers output, so we
> generate it with software. In current version of driver we also use software
> JPEG header parsing because with hardware parsing performance is lower then
> desired.

>  From a userspace point of view the encoding process is typical (S_FMT, REQBUF,
> optionally QUERYBUF, QBUF, STREAMON, DQBUF) for both the source and destination
> queues. The decoding process requires that the source queue performs S_FMT,
> REQBUF, (QUERYBUF), QBUF and STREAMON. After STREAMON on the source queue, it is
> possible to perform G_FMT on the destination queue to find out the processed
> image width and height in order to be able to allocate an appropriate buffer -
> it is assumed that the user does not pass the compressed image width and height
> but instead this information is parsed from the JPEG input. This is done in
> kernel. Then REQBUF, QBUF and STREAMON on the destination queue complete the
> decoding and it is possible to DQBUF from both queues and finish the operation.

> During encoding the available formats are: V4L2_PIX_FMT_NV12M and
> V4L2_PIX_FMT_NV16M for source and V4L2_PIX_FMT_JPEG for destination.

> During decoding the available formats are: V4L2_PIX_FMT_JPEG for source and
> V4L2_PIX_FMT_NV12M and V4L2_PIX_FMT_NV16M for destination.

> Performance of current version:
> 1280x800 NV12 image encoding/decoding
> 	decoding ~121 FPS
> 	encoding ~190 FPS

> Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> ---
> Changes since v2:
>      - Kconfig entry reordered
>      - unnecessary clk_disable_unprepare(jpu->clk) removed
>      - ref_count fixed in jpu_resume
>      - enable DMABUF in src_vq->io_modes
>      - remove jpu_s_priority jpu_g_priority
>      - jpu_g_selection fixed
>      - timeout in jpu_reset added and hardware reset reworked
>      - remove unused macros
>      - JPEG header parsing now is software because of performance issues
>        based on s5p-jpu code
>      - JPEG header generation redesigned:
>        JPEG header(s) pre-generated and memcpy'ed on encoding
>        we only fill the necessary fields
>        more "transparent" header format description
>      - S_FMT, G_FMT and TRY_FMT hooks redesigned

    Still need a comma before "and" -- the English punctuation rules are 
different from the Russian ones.

>        partially inspired by VSP1 driver code
>      - some code was reformatted
>      - image formats handling redesigned
>      - multi-planar V4L2 API now in use
>      - now passes v4l2-compliance tool check

> Cnanges since v1:
>      - s/g_fmt function simplified
>      - default format for queues added
>      - dumb vidioc functions added to be in compliance with standard api:
>          jpu_s_priority, jpu_g_priority
>      - standard v4l2_ctrl_subscribe_event and v4l2_event_unsubscribe
>        now in use by the same reason

[...]

WBR, Sergei

