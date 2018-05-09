Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56458 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935151AbeEIQEh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 12:04:37 -0400
Message-ID: <fca78137c285eff268b0319ca752014c9f4e76fc.camel@collabora.com>
Subject: Re: [PATCH v9 11/15] vb2: add in-fence support to QBUF
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: linux-media@vger.kernel.org, kernel@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Date: Wed, 09 May 2018 13:03:15 -0300
In-Reply-To: <20180509103639.GC39838@e107564-lin.cambridge.arm.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
         <20180504200612.8763-12-ezequiel@collabora.com>
         <20180509103639.GC39838@e107564-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-05-09 at 11:36 +0100, Brian Starkey wrote:

[..]
> > @@ -203,9 +215,14 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
> > 	b->timestamp = ns_to_timeval(vb->timestamp);
> > 	b->timecode = vbuf->timecode;
> > 	b->sequence = vbuf->sequence;
> > -	b->fence_fd = 0;
> > 	b->reserved = 0;
> > 
> > +	b->fence_fd = 0;
> 
> I didn't understand why we're returning 0 instead of -1. Actually the
> doc in patch 10 seems to say it will be -1 or 0 depending on whether
> we set one of the fence flags? I'm not sure:
> 
>     For all other ioctls V4L2 sets this field to -1 if
>     ``V4L2_BUF_FLAG_IN_FENCE`` and/or ``V4L2_BUF_FLAG_OUT_FENCE`` are set,
>     otherwise this field is set to 0 for backward compatibility.
> 

Well, I think that for backwards compatibility (userspace not knowing
about fence_fd field), we should return 0, unless the flags are explicitly
set.

That is what the doc says and it sounds sane.

The bits are implemented in patch 12, but as I mentioned in my reply to
patch 10, I will move it to patch 10, for consistency.

Thanks,
Eze
