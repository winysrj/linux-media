Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:54879 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754438AbeEWQTo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 12:19:44 -0400
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based cameras
 on generic apps
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        LMML <linux-media@vger.kernel.org>,
        Wim Taymans <wtaymans@redhat.com>, schaller@redhat.com
References: <20180517160708.74811cfb@vento.lan>
 <644920d91d1f69d659f233c6a52382d3f919babc.camel@ndufresne.ca>
 <3216261.G88TfqiCiH@avalon> <20180518082447.3068c34c@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <727fc55e-970c-53c3-f286-f7e7c1035184@xs4all.nl>
Date: Wed, 23 May 2018 18:19:37 +0200
MIME-Version: 1.0
In-Reply-To: <20180518082447.3068c34c@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/05/18 13:24, Mauro Carvalho Chehab wrote:
> One of the biggest reasons why we decided to start libv4l project,
> in the past, was to ensure an open source solution. The problem we
> faced on that time is to ensure that, when a new media driver were
> added with some proprietary output format, an open source decoding
> software were also added at libv4l.
> 
> This approach ensured that all non-MC cameras are supported by all
> V4L2 applications.
> 
> Before libv4l, media support for a given device were limited to a few 
> apps that knew how to decode the format. There were even cases were a
> proprietary app were required, as no open source decoders were available.
> 
> From my PoV, the biggest gain with libv4l is that the same group of
> maintainers can ensure that the entire solution (Kernel driver and
> low level userspace support) will provide everything required for an
> open source app to work with it.
> 
> I'm not sure how we would keep enforcing it if the pipeline setting
> and control propagation logic for an specific hardware will be
> delegated to PipeWire. It seems easier to keep doing it on a libv4l
> (version 2) and let PipeWire to use it.

I've decided not to attend this meeting. It is not quite my core expertise
and it is a bit too far to make it worth my time. If there are good reasons
for me being there that I missed, then please let me know asap and I might
reconsider this.

What I would like to say though it that I think libv4l is a bit of a dead
end and probably not suitable for adding support for this.

Currently libv4l2 is too intertwined with libv4lconvert and too messy.
Its original motivation was for converting custom formats and that is
mostly obsolete now that UVC has standardized formats to just a few.

I think a core library is needed that provides the basic functionality
and that can be used directly by applications if they don't want to use
v4l2_open() and friends.

I.e. it should be possible for e.g. gstreamer to use this core library
to easily configure and use the MC instead of having to call v4l2_open() etc.
and rely on magic code to do this for them. It's simply ugly to overload
mmap with v4l2_mmap or to emulate read() if the driver doesn't support it.

We might still have a libv4l2-like library sitting on top of this, but
perhaps with limited functionality. For example, I think it would be
reasonable to no longer support custom formats. If an application wants
to support that, then it should call conversion functions for the core
library explicitly. This has the big advantage of solving the dmabuf
and mmap issues in today's libv4l2.

Regards,

	Hans
