Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:46874 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964989AbeEIQpJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 12:45:09 -0400
Date: Wed, 9 May 2018 17:45:05 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, kernel@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v9 11/15] vb2: add in-fence support to QBUF
Message-ID: <20180509164504.GB23664@e107564-lin.cambridge.arm.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
 <20180504200612.8763-12-ezequiel@collabora.com>
 <20180509103639.GC39838@e107564-lin.cambridge.arm.com>
 <fca78137c285eff268b0319ca752014c9f4e76fc.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fca78137c285eff268b0319ca752014c9f4e76fc.camel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 09, 2018 at 01:03:15PM -0300, Ezequiel Garcia wrote:
>On Wed, 2018-05-09 at 11:36 +0100, Brian Starkey wrote:
>
>[..]
>> > @@ -203,9 +215,14 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>> > 	b->timestamp = ns_to_timeval(vb->timestamp);
>> > 	b->timecode = vbuf->timecode;
>> > 	b->sequence = vbuf->sequence;
>> > -	b->fence_fd = 0;
>> > 	b->reserved = 0;
>> >
>> > +	b->fence_fd = 0;
>>
>> I didn't understand why we're returning 0 instead of -1. Actually the
>> doc in patch 10 seems to say it will be -1 or 0 depending on whether
>> we set one of the fence flags? I'm not sure:
>>
>>     For all other ioctls V4L2 sets this field to -1 if
>>     ``V4L2_BUF_FLAG_IN_FENCE`` and/or ``V4L2_BUF_FLAG_OUT_FENCE`` are set,
>>     otherwise this field is set to 0 for backward compatibility.
>>
>
>Well, I think that for backwards compatibility (userspace not knowing
>about fence_fd field), we should return 0, unless the flags are explicitly
>set.
>
>That is what the doc says and it sounds sane.

On the line below where you snipped, is this:

+      if (vb->in_fence)
+              b->flags |= V4L2_BUF_FLAG_IN_FENCE;
+      else
+              b->flags &= ~V4L2_BUF_FLAG_IN_FENCE;

If the "if (vb->in_fence)" condition is true, then the flag is set,
and the fence_fd field is 0. I think that's the opposite of what the
doc says:

    For all other ioctls V4L2 sets this field to -1 if
    ``V4L2_BUF_FLAG_IN_FENCE`` and/or ``V4L2_BUF_FLAG_OUT_FENCE`` are set,
    otherwise this field is set to 0 for backward compatibility.

V4L2_BUF_FLAG_IN_FENCE is set, therefore the doc says V4L2 will set
this field to -1. (Or at least the comment should be made less
ambiguous).

>
>The bits are implemented in patch 12, but as I mentioned in my reply to
>patch 10, I will move it to patch 10, for consistency.

Yeah as you say, it looks like you change this behaviour in path 12,
so I'm not totally sure which is right or expected. But consistency is
good :-)

-Brian

>
>Thanks,
>Eze
