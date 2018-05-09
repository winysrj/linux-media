Return-path: <linux-media-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:41938 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933864AbeEIKfJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 06:35:09 -0400
Date: Wed, 9 May 2018 11:35:05 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 11/15] vb2: add in-fence support to QBUF
Message-ID: <20180509103504.GB39838@e107564-lin.cambridge.arm.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
 <20180504200612.8763-12-ezequiel@collabora.com>
 <5fd5d7a9-5b74-fe2a-6148-59b90cabb9e8@xs4all.nl>
 <1525821486.1445.17.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1525821486.1445.17.camel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, May 08, 2018 at 08:18:06PM -0300, Gustavo Padovan wrote:
>
>Hi Hans,
>
>On Mon, 2018-05-07 at 14:07 +0200, Hans Verkuil wrote:
>> On 04/05/18 22:06, Ezequiel Garcia wrote:
>> > From: Gustavo Padovan <gustavo.padovan@collabora.com>

[snip]

>> > diff --git a/include/media/videobuf2-core.h
>> > b/include/media/videobuf2-core.h
>> > index 364e4cb41b10..28ce8f66882e 100644
>> > --- a/include/media/videobuf2-core.h
>> > +++ b/include/media/videobuf2-core.h
>> > @@ -17,6 +17,7 @@
>> >  #include <linux/poll.h>
>> >  #include <linux/dma-buf.h>
>> >  #include <linux/bitops.h>
>> > +#include <linux/dma-fence.h>
>> >
>> >  #define VB2_MAX_FRAME	(32)
>> >  #define VB2_MAX_PLANES	(8)
>> > @@ -255,12 +256,21 @@ struct vb2_buffer {
>> >  	 * done_entry:		entry on the list that
>> > stores all buffers ready
>> >  	 *			to be dequeued to userspace
>> >  	 * vb2_plane:		per-plane information; do not
>> > change
>> > +	 * in_fence:		fence received from vb2 client
>> > to wait on before
>> > +	 *			using the buffer (queueing to
>> > the driver)
>> > +	 * fence_cb:		fence callback information
>> > +	 * fence_cb_lock:	protect callback signal/remove
>> >  	 */
>> >  	enum vb2_buffer_state	state;
>> >
>> >  	struct vb2_plane	planes[VB2_MAX_PLANES];
>> >  	struct list_head	queued_entry;
>> >  	struct list_head	done_entry;
>> > +
>> > +	struct dma_fence	*in_fence;
>> > +	struct dma_fence_cb	fence_cb;
>> > +	spinlock_t              fence_cb_lock;
>> > +
>>
>> So for the _MPLANE formats this is one fence for all planes. Which
>> makes sense, but how
>> does drm handle that? Also one fence for all planes?
>
>Yes, this is one fence for all planes.
>
>The DRM concept for planes is a totally different concept and is
>basically a representation of an user definable square on the screen,
>and to that plane there in one framebuffer attached - display hw has no
>such a multiplanar for the same image AFAICT. So you probably need some
>blit to convert the v4l2 multiplanar to a DRM framebuffer.
>

Lots of display hardware can do multi-planar formats, and there's
space in struct drm_framebuffer for up to 4 buffer handles (e.g. 3
handles are passed for Luma, Cr, and Cb when the framebuffer format is
DRM_FORMAT_YUV420) - like V4L2 MPLANE.

The V4L2 code here matches with the DRM "explicit sync"
(IN_FENCE_FD/OUT_FENCE_PTR) stuff, which is probably what we want.
The main difference is that in DRM, explicit fences aren't associated
with framebuffers, they're associated with the things using the
framebuffers - but practically it doesn't make a difference.

There can be per-buffer "implicit sync" via dma-buf reservation
objects, but I don't think this series should attempt to deal with
that.

Cheers,
-Brian

>>
>> I think there should be a comment about this somewhere.
>
>Yes, we've been over this exact discussion a few times :)
>Having entirely different things with the same name is quite confusing.
>
>Regards,
>
>Gustavo
>
>-- 
>Gustavo Padovan
>Principal Software Engineer
>Collabora Ltd.
