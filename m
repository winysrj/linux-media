Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1627 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2IUQy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 12:54:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFCv1 PATCH 4/6] videobuf2-core: fill in length field for multiplanar buffers.
Date: Fri, 21 Sep 2012 18:54:12 +0200
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl> <201209211823.03825.hverkuil@xs4all.nl> <505C9A3A.4030500@samsung.com>
In-Reply-To: <505C9A3A.4030500@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211854.12059.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri September 21 2012 18:47:54 Sylwester Nawrocki wrote:
> On 09/21/2012 06:23 PM, Hans Verkuil wrote:
> > On Fri September 21 2012 18:13:20 Sylwester Nawrocki wrote:
> >> Hi Hans,
> >>
> >> On 09/19/2012 04:37 PM, Hans Verkuil wrote:
> >>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>
> >>> length should be set to num_planes in __fill_v4l2_buffer(). That way the
> >>> caller knows how many planes there are in the buffer.
> >>>
> >>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> I think this would break VIDIOC_CREATE_BUFS. We need per buffer num_planes.
> >> Consider a use case where device is streaming with 2-planar pixel format
> >> and we invoke VIDIOC_CREATE_BUFS with single-planar format. On a single 
> >> queue there will be buffers with different number of planes. The number of 
> >> planes information must be attached to a buffer, otherwise VIDIOC_QUERYBUF 
> >> won't work.
> > 
> > That's a very good point and one I need to meditate on.
> > 
> > However, your comment applies to patch 1/6, not to this one.
> > This patch is about whether or not the length field of v4l2_buffer should
> > be filled in with the actual number of planes used by that buffer or not.
> 
> Yes, right. Sorry, I was editing response to multiple patches from this
> series and have mixed things a bit. I agree that it is logical and expected
> to update struct v4l2_buffer for user space.

OK, great. That's was actually the main reason for working on this as this
unexpected behavior bit me when writing mplane streaming support for v4l2-ctl.

> I have spent some time on this series, and even prepared a patch for s5p-mfc,
> as it relies on num_planes being in struct vb2_buffer. But then a realized
> there could be buffers with distinct number of planes an a single queue.

I'll get back to you about this, probably on Monday. I need to think about the
implications of this.

Regards,

	Hans
