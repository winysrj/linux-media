Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9EA6C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 14:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 842E8217D7
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 14:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbeLROYZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 09:24:25 -0500
Received: from mail.bootlin.com ([62.4.15.54]:60069 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbeLROYZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 09:24:25 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 42BAF207D9; Tue, 18 Dec 2018 15:24:23 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-38-38.w90-88.abo.wanadoo.fr [90.88.157.38])
        by mail.bootlin.com (Postfix) with ESMTPSA id F17A22072C;
        Tue, 18 Dec 2018 15:24:22 +0100 (CET)
Message-ID: <4333e0efc503f20654d31e6b71d998aba93629aa.camel@bootlin.com>
Subject: Re: [PATCHv5 0/8] vb2/cedrus: use timestamps to identify buffers
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Date:   Tue, 18 Dec 2018 15:24:23 +0100
In-Reply-To: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Wed, 2018-12-12 at 13:38 +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
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
> 
> Please note that this patch series will have to be updated one more
> time when pending 4.20 fixes are merged back into our master since
> those patches will move the cedrus mpeg controls to a different header.

I hit the same build issue that Jonas reported already. With the 
appropriate fix, this works fine with the cedrus driver.

So with the related fix included, this is:
Tested-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> Regards,
> 
>         Hans
> 
> Hans Verkuil (8):
>   v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
>   vim2m: use v4l2_m2m_buf_copy_data
>   vicodec: use v4l2_m2m_buf_copy_data
>   buffer.rst: clean up timecode documentation
>   videodev2.h: add v4l2_timeval_to_ns inline function
>   vb2: add vb2_find_timestamp()
>   cedrus: identify buffers by timestamp
>   extended-controls.rst: update the mpeg2 compound controls
> 
>  Documentation/media/uapi/v4l/buffer.rst       | 11 ++++----
>  .../media/uapi/v4l/extended-controls.rst      | 28 +++++++++++--------
>  .../media/common/videobuf2/videobuf2-v4l2.c   | 22 +++++++++++++--
>  drivers/media/platform/vicodec/vicodec-core.c | 12 +-------
>  drivers/media/platform/vim2m.c                | 12 +-------
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ------
>  drivers/media/v4l2-core/v4l2-mem2mem.c        | 20 +++++++++++++
>  drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 ++++--
>  .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 ++
>  .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++++--------
>  include/media/v4l2-mem2mem.h                  | 20 +++++++++++++
>  include/media/videobuf2-v4l2.h                | 19 ++++++++++++-
>  include/uapi/linux/v4l2-controls.h            | 14 ++++------
>  include/uapi/linux/videodev2.h                | 12 ++++++++
>  14 files changed, 136 insertions(+), 75 deletions(-)
> 
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

