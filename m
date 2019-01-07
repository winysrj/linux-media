Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B50CC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3760A2089F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfAGLg5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:36:57 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:37316 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726879AbfAGLg5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:36:57 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gTD9gFSzcBDyIgTDDgNVoU; Mon, 07 Jan 2019 12:36:55 +0100
Subject: Re: [GIT PULL FOR v5.1] vb2/cedrus: use timestamps to identify
 buffers
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
References: <b3bbcd9c-fcaf-4a13-2c46-7e2231e9e8e0@xs4all.nl>
Message-ID: <4c7e839f-ae1b-35cd-df29-a7f6993f17d4@xs4all.nl>
Date:   Mon, 7 Jan 2019 12:36:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <b3bbcd9c-fcaf-4a13-2c46-7e2231e9e8e0@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFN3SsM82Ej2y+AnpLckQLdxxd9On8WRxMp/1MBaA0eslYyAQFKPm3gMFLOTHxk8ICPzd5Kuf2zQTXX1BsA/+WqQYazxYwAf/krHJagi674NmcT632ro
 o55fCwfRXIo00V12BYhSCqiucvCQZQmzBYnB+FNZygEvsdlxLcc80sL981xiTQD9hitm8tRIBazC80W2usK6ZcZeVbBbJ3ecZAPFckoPrGSxqV10F8p7nOaf
 ikqcQSY74DjOUlC2KEEZh30xD+HpiZEZIWWt0ePsRgMCbzQU8E322Kw9oiG21WCA
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/07/2019 12:30 PM, Hans Verkuil wrote:
> As was discussed here (among other places):
> 
> https://lkml.org/lkml/2018/10/19/440
> 
> using capture queue buffer indices to refer to reference frames is
> not a good idea.
> 
> Instead, after a long irc discussion:
> 
> https://linuxtv.org/irc/irclogger_log/v4l?date=2018-12-12,Wed
> 
> it was decided to use the timestamp in v4l2_buffer for this.
> 
> However, struct timeval cannot be used in a compound control since
> the size of struct timeval differs between 32 and 64 bit architectures,
> and there are also changes upcoming for y2038 support.
> 
> But internally the kernel converts the timeval to a u64 (nsecs since
> boot). So we provide a helper function in videodev2.h that converts
> the timeval to a u64, and that u64 can be used inside compound controls.
> 
> In the not too distant future we want to create a new struct v4l2_buffer,
> and then we'll use u64 from the start, so in that case the helper function
> would no longer be needed.
> 
> The first three patches add a new m2m helper function to correctly copy
> the relevant data from an output buffer to a capture buffer. This will
> simplify m2m drivers (in fact, many m2m drivers do not do this quite
> right, so a helper function was really needed).
> 
> The fourth patch clears up messy timecode documentation that I came
> across while working on this.
> 
> Patch 5 adds the new v4l2_timeval_to_ns helper function to videodev2.h.
> The next patch adds the vb2_find_timestamp() function to find buffers
> with a specific u64 timestamp.
> 
> Finally the cedrus driver and documentation are updated to use a
> timestamp as buffer identifier.
> 
> I also removed the 'pad' fields from the mpeg2 control structs (it
> should never been added in the first place) and aligned the structs
> to a u32 boundary.

Note that this pull request corresponds with the v6 patch series.
("[PATCHv6 0/8] vb2/cedrus: use timestamps to identify buffers")

Regards,

	Hans

> 
> Regards,
> 
>         Hans
> 
> The following changes since commit 4bd46aa0353e022c2401a258e93b107880a66533:
> 
>   media: cx23885: only reset DMA on problematic CPUs (2018-12-20 06:52:01 -0500)
> 
> are available in the Git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git tags/br-buftag
> 
> for you to fetch changes up to 690da7b0ab96f6761e72bb0c5c861e1e13acb327:
> 
>   extended-controls.rst: update the mpeg2 compound controls (2019-01-07 12:23:49 +0100)
> 
> ----------------------------------------------------------------
> Tag branch
> 
> ----------------------------------------------------------------
> Hans Verkuil (8):
>       v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
>       vim2m: use v4l2_m2m_buf_copy_data
>       vicodec: use v4l2_m2m_buf_copy_data
>       buffer.rst: clean up timecode documentation
>       videodev2.h: add v4l2_timeval_to_ns inline function
>       vb2: add vb2_find_timestamp()
>       cedrus: identify buffers by timestamp
>       extended-controls.rst: update the mpeg2 compound controls
> 
>  Documentation/media/uapi/v4l/buffer.rst            | 11 +++++------
>  Documentation/media/uapi/v4l/extended-controls.rst | 28 +++++++++++++++++-----------
>  drivers/media/common/videobuf2/videobuf2-v4l2.c    | 19 ++++++++++++++++++-
>  drivers/media/platform/vicodec/vicodec-core.c      | 12 +-----------
>  drivers/media/platform/vim2m.c                     | 12 +-----------
>  drivers/media/v4l2-core/v4l2-ctrls.c               |  9 ---------
>  drivers/media/v4l2-core/v4l2-mem2mem.c             | 20 ++++++++++++++++++++
>  drivers/staging/media/sunxi/cedrus/cedrus.h        |  9 ++++++---
>  drivers/staging/media/sunxi/cedrus/cedrus_dec.c    |  2 ++
>  drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c  | 23 +++++++++++------------
>  include/media/mpeg2-ctrls.h                        | 14 +++++---------
>  include/media/v4l2-mem2mem.h                       | 20 ++++++++++++++++++++
>  include/media/videobuf2-v4l2.h                     | 17 +++++++++++++++++
>  include/uapi/linux/videodev2.h                     | 12 ++++++++++++
>  14 files changed, 135 insertions(+), 73 deletions(-)
> 

