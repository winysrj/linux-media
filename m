Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50683C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 06:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EAF42087F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 06:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfAGGe7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 01:34:59 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:43552 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfAGGe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 01:34:59 -0500
Received: from randy.li?rock-chips.com (unknown [192.168.167.32])
        by regular1.263xmail.com (Postfix) with ESMTP id 16F4F3B7;
        Mon,  7 Jan 2019 14:34:07 +0800 (CST)
X-263anti-spam: KSV:0;BIG:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ADDR-CHECKED4: 1
X-ABS-CHECKED: 1
X-SKE-CHECKED: 1
X-ANTISPAM-LEVEL: 2
Received: from [192.168.10.130] (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P18002T140590266164992S1546842845141679_;
        Mon, 07 Jan 2019 14:34:06 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <aec6759e222204c917c4dd74df3ef2ba>
X-RL-SENDER: randy.li@rock-chips.com
X-SENDER: randy.li@rock-chips.com
X-LOGIN-NAME: randy.li@rock-chips.com
X-FST-TO: ayaka@soulik.info
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Subject: Re: [PATCHv4 00/10] As was discussed here (among other places):
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com, Randy Li <ayaka@soulik.info>
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
From:   Randy Li <randy.li@rock-chips.com>
Message-ID: <8dde36c0-105d-a7a9-8f7a-5227fca66bc8@rock-chips.com>
Date:   Mon, 7 Jan 2019 14:34:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 12/5/18 6:20 PM, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>
> https://lkml.org/lkml/2018/10/19/440
>
> using capture queue buffer indices to refer to reference frames is
> not a good idea. A better idea is to use a 'tag' where the
> application can assign a u32 tag to an output buffer, which is then
> copied to the capture buffer(s) derived from the output buffer.

I agree with the buffer tag. But coping from the OUPUT side to CAPTURE 
side is a bad idea.

I think we need a method to refer any buffers when they are allocated.

When I push a slice with its parameters into the driver, its previous 
picture in decoded order may not ready yet, using the buffer index, the 
driver

is still able to generate the registers table for it. Although you may 
though it just an additional buffer assignment work before wrote it into 
the device,

a few times seeking a buffer in a list. But there is a mode in new 
generation Rockchip device, called the link mode, you can put a 
registers into a memory, device would process that register link. You 
can't interrupt it. That is pretty useful for those codec converting.


Besides, I found it is little hard to refer a buffer with different 
offsets at the same time, it would be used for multiple slices and 
multiple CTU or filed picture which are not usual case nowadays.

> It has been suggested that the timestamp can be used for this. But
> there are a number of reasons why this is a bad idea:
I wonder why using a timestamp in the decoder or encoder, if the stream 
doesn't have a timestamp, we have to generate one.
>
> 1) the struct timeval is converted to a u64 in vb2. So there can be
>     all sorts of unexpected conversion issues. In particular, the
>     output of ns_to_timeval(timeval_to_ns(tv)) does not necessarily
>     match the input.
>
> 2) it gets worse with the y2038 code where userspace either deals
>     with a 32 bit tv_sec value or a 64 bit value.
>
> In other words, using timestamp for this is not a good idea.
>
> This implementation adds a new tag field in a union with the reserved2
> field. The interpretation of that union depends on the flags field, so
> it still can be used for other things as well. In addition, in the previous
> patches the tag was in a union with the timecode field (again determined
> by the flags field), so if we need to cram additional information in this
> struct we can always put it in a union with the timecode field as well.
> It worked for the tag, it should work for other things.
>
> But we really need to start looking at a struct v4l2_ext_buffer.
>
> The first three patches add core tag support, the next two patches document
> the tag support, then a new helper function is added to v4l2-mem2mem.c
> to easily copy data from a source to a destination buffer that drivers
> can use.
>
> Next a new supports_tags vb2_queue flag is added to indicate that
> the driver supports tags. Ideally this should not be necessary, but
> that would require that all m2m drivers are converted to using the
> new helper function introduced in the previous patch. That takes more
> time then I have now.
>
> Finally the vim2m, vicodec and cedrus drivers are converted to support
> tags.
>
> I also removed the 'pad' fields from the mpeg2 control structs (it
> should never been added in the first place) and aligned the structs
> to a u32 boundary.
>
> Note that this might change further (Paul suggested using bitfields).
>
> Also note that the cedrus code doesn't set the sequence counter, that's
> something that should still be added before this driver can be moved
> out of staging.
>
> Note: if no buffer is found for a certain tag, then the dma address
> is just set to 0. That happened before as well with invalid buffer
> indices. This should be checked in the driver!
>
> Regards,
>
>          Hans
>
> Changes since v3:
>
> - use reserved2 for the tag
> - split the documentation in two: one documenting the tag, one
>    cleaning up the timecode documentation.
>
> Changes since v2:
>
> - rebased
> - added Reviewed-by tags
> - fixed a few remaining references in the documentation to the old
>    v4l2_buffer_tag struct that was used in early versions of this
>    series.
>
> Changes since v1:
>
> - changed to a u32 tag. Using a 64 bit tag was overly complicated due
>    to the bad layout of the v4l2_buffer struct, and there is no real
>    need for it by applications.
>
> Main changes since the RFC:
>
> - Added new buffer capability flag
> - Added m2m helper to copy data between buffers
> - Added documentation
> - Added tag logging in v4l2-ioctl.c
>
>
> Hans Verkuil (10):
>    videodev2.h: add tag support
>    vb2: add tag support
>    v4l2-ioctl.c: log v4l2_buffer tag
>    buffer.rst: document the new buffer tag feature.
>    buffer.rst: clean up timecode documentation
>    v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
>    vb2: add new supports_tags queue flag
>    vim2m: add tag support
>    vicodec: add tag support
>    cedrus: add tag support
>
>   Documentation/media/uapi/v4l/buffer.rst       | 28 +++++++++----
>   .../media/uapi/v4l/vidioc-reqbufs.rst         |  4 ++
>   .../media/common/videobuf2/videobuf2-v4l2.c   | 41 ++++++++++++++++---
>   drivers/media/platform/vicodec/vicodec-core.c | 14 ++-----
>   drivers/media/platform/vim2m.c                | 14 ++-----
>   drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ----
>   drivers/media/v4l2-core/v4l2-ioctl.c          |  9 ++--
>   drivers/media/v4l2-core/v4l2-mem2mem.c        | 23 +++++++++++
>   drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 ++--
>   .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 +
>   .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++------
>   .../staging/media/sunxi/cedrus/cedrus_video.c |  2 +
>   include/media/v4l2-mem2mem.h                  | 21 ++++++++++
>   include/media/videobuf2-core.h                |  2 +
>   include/media/videobuf2-v4l2.h                | 21 +++++++++-
>   include/uapi/linux/v4l2-controls.h            | 14 +++----
>   include/uapi/linux/videodev2.h                |  9 +++-
>   17 files changed, 168 insertions(+), 75 deletions(-)
>


