Return-Path: <SRS0=+2CU=RU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC83C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 16:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7AB320896
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 16:10:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="bIc0h4Cu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfCQQKw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Mar 2019 12:10:52 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:36914 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfCQQKw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Mar 2019 12:10:52 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 36C5723A;
        Sun, 17 Mar 2019 17:10:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552839049;
        bh=cWZs1/CJiHgYmc3GCh4+zrvPBWO0PLfmX3h0hfnI0ns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bIc0h4Cu8uNKd+usGRdoLIktE5yj6wKwlK0lBQx3EOeNSLB7+zC4uRnsDvh1jsssO
         BwIj3w7aTcSZ/GbjByUGlKQ7DPNxP0rTttCVOE31+fgxJJLo7zSmpD8rttV3WU/wJW
         +D47YhdDiBtUX2S2KrM8whezmBhsDKL//XNrqXVg=
Date:   Sun, 17 Mar 2019 18:10:41 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hirokazu Honda <hiroh@chromium.org>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
Message-ID: <20190317161041.GC17898@pendragon.ideasonboard.com>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <CAAFQd5COSecRGOSUyQGAe0ob-do0C5=FqhQZoq-d1EULhMiWHg@mail.gmail.com>
 <2004464.r89rQTy7OA@avalon>
 <CAAFQd5Dp3xUba-p4qOcZAtfHUd=TQFkEh7TRVdQ_F1=9Qif-9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAFQd5Dp3xUba-p4qOcZAtfHUd=TQFkEh7TRVdQ_F1=9Qif-9Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tomasz,

On Fri, Mar 15, 2019 at 01:18:17PM +0900, Tomasz Figa wrote:
> On Fri, Oct 26, 2018 at 10:42 PM Laurent Pinchart wrote:
> > On Friday, 26 October 2018 14:41:26 EEST Tomasz Figa wrote:
> >> On Thu, Sep 20, 2018 at 11:42 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>> Some parts of the V4L2 API are awkward to use and I think it would be
> >>> a good idea to look at possible candidates for that.
> >>>
> >>> Examples are the ioctls that use struct v4l2_buffer: the multiplanar
> >>> support is really horrible, and writing code to support both single and
> >>> multiplanar is hard. We are also running out of fields and the timeval
> >>> isn't y2038 compliant.
> >>>
> >>> A proof-of-concept is here:
> >>>
> >>> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a
> >>> 95549df06d9900f3559afdbb9da06bd4b22d1f3
> >>>
> >>> It's a bit old, but it gives a good impression of what I have in mind.
> >>
> >> On a related, but slightly different note, I'm wondering how we should
> >> handle a case where we have an M format (e.g. NV12M with 2 memory
> >> planes), but only 1 DMA-buf with all planes to import. That generally
> >> means that we have to use the same DMA-buf FD with an offset for each
> >> plane. In theory, v4l2_plane::data_offset could be used for this, but
> >> the documentation says that it should be set by the application only
> >> for OUTPUT planes. Moreover, existing drivers tend to just ignore
> >> it...
> >
> > The following patches may be of interest.
> >
> > https://patchwork.linuxtv.org/patch/29177/
> > https://patchwork.linuxtv.org/patch/29178/
> 
> [+CC Boris]
> 
> Thanks Laurent for pointing me to those patches.
> 
> Repurposing the data_offset field may sound like a plausible way to do
> it, but it's not, for several reasons:
> 
> 1) The relation between data_offset and other fields in v4l2_buffer
> makes it hard to use in drivers and userspace.

Could you elaborate on this ?

> 2) It is not handled by vb2, so each driver would have to
> explicitly add data_offset to the plane address and subtract it from
> plane size and/or bytesused (since data_offset counts into plane size
> and bytesused),

We should certainly handle that in the V4L2 core and/or in vb2. I think
we should go one step further and handle the compose rectangle there
too, as composing for capture devices is essentially offsetting the
buffer and setting the correct stride. I wonder if it was a mistake to
expose compose rectangle on capture video nodes, maybe stride + offset
would be a better API.

> 3) For CAPTURE buffers, it's actually defined as set-by-driver
> (https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/buffer.html#struct-v4l2-plane),
> so anything userspace sets there is bound to be ignored. I'm not sure
> if we can change this now, as it would be a compatibility issue.
> 
> (There are actually real use cases for it, i.e. the venus driver
> outputs VPx encoded frames prepended with the IVF header, but that's
> not what the V4L2 VPx formats expect, so the data_offset is set by the
> driver to point to the raw bitstream data.)

Doesn't that essentially create a custom format though ? Who consumes
the IVF header ?

Another use case is handling of embedded data with CSI-2.

CSI-2 sensors can send multiple types of data multiplexed in a single
virtual channels. Common use cases include sending a few lines of
metadata, or sending optical black lines, in addition to the main image.
A CSI-2 source could also send the same image in multiple formats, but I
haven't seen that happening in practice. The CSI-2 standard tags each
line with a data type in order to differentiate them on the receiver
side. On the receiver side, some receivers allow capturing different
data types in different buffers, while other support a single buffer
only, with or without data type filtering. It may thus be that a sensor
sending 2 lines of embedded data before the image to a CSI-2 receiver
that supports a single buffer will leave the user with two options,
capturing the image only or capturing both in the same buffer (really
simple receivers may only offer the last option). Reporting to the user
how data is organized in the buffer is needed, and the data_offset field
is used for this.

This being said, I don't think it's a valid use case fo data_offset. As
mentioned above a sensor could send more than one data type in addition
to the main image (embedded data + optical black is one example), so a
single data_offset field wouldn't allow differentiating embedded data
from optical black lines. I think a more powerful frame descriptor API
would be needed for this. The fact that the buffer layout doesn't change
between frames also hints that this should be supported at the format
level, not the buffer level.

> >> There is also the opposite problem. Sometimes the application is given
> >> 3 different FDs but pointing to the same buffer. If it has to work
> >> with a video device that only supports non-M formats, it can either
> >> fail, making it unusable, or blindly assume that they all point to the
> >> same buffer and just give the first FD to the video device (we do it
> >> in Chromium, since our allocator is guaranteed to keep all planes of
> >> planar formats in one buffer, if to be used with V4L2).
> >>
> >> Something that we could do is allowing the QBUF semantics of M formats
> >> for non-M formats, where the application would fill the planes[] array
> >> for all planes with all the FDs it has and the kernel could then
> >> figure out if they point to the same buffer (i.e. resolve to the same
> >> dma_buf struct) or fail if not.
> >>
> >> [...]
> >>
> >>> Do we have more ioctls that could use a refresh? S/G/TRY_FMT perhaps,
> >>> again in order to improve single vs multiplanar handling.
> >>
> >> I'd definitely be more than happy to see the plane handling unified
> >> between non-M and M formats, in general. The list of problems with
> >> current interface:
> >>
> >> 1) The userspace has to hardcode the computations of bytesperline for
> >> chroma planes of non-M formats (while they are reported for M
> >> formats).
> >>
> >> 2) Similarly, offsets of the planes in the buffer for non-M formats
> >> must be explicitly calculated in the application,
> >>
> >> 3) Drivers have to explicitly handle both non-M and M formats or
> >> otherwise they would suffer from issues with application compatibility
> >> or sharing buffers with other devices (one supporting only M and the
> >> other only non-M),
> >>
> >> 4) Inconsistency in the meaning of planes[0].sizeimage for non-M
> >> formats and M formats, making it impossible to use planes[0].sizeimage
> >> to set the luma plane size in the hardware for non-M formats (since
> >> it's the total size of all planes).
> >>
> >> I might have probably forgotten about something, but generally fixing
> >> the 4 above, would be a really big step forward.

-- 
Regards,

Laurent Pinchart
