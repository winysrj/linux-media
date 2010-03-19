Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab0CSNBd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 09:01:33 -0400
Message-ID: <4BA375A7.3000400@redhat.com>
Date: Fri, 19 Mar 2010 10:01:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: v4l-dvb <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>
In-Reply-To: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi all,
> 
> V4L1 support has been marked as scheduled for removal for a long time. The
> deadline for that in the feature-removal-schedule.txt file was July 2009.

As reference, this is what's written there:

What:   Video4Linux API 1 ioctls and from Video devices.
When:   July 2009
Files:  include/linux/videodev.h
Check:  include/linux/videodev.h
Why:    V4L1 AP1 was replaced by V4L2 API during migration from 2.4 to 2.6
        series. The old API have lots of drawbacks and don't provide enough
        means to work with all video and audio standards. The newer API is
        already available on the main drivers and should be used instead.
        Newer drivers should use v4l_compat_translate_ioctl function to handle
        old calls, replacing to newer ones.
        Decoder iocts are using internally to allow video drivers to
        communicate with video decoders. This should also be improved to allow
        V4L2 calls being translated into compatible internal ioctls.
        Compatibility ioctls will be provided, for a while, via 
        v4l1-compat module. 
Who:    Mauro Carvalho Chehab <mchehab@infradead.org>


> 
> I think it is time that we remove the V4L1 compatibility support from V4L2
> drivers for 2.6.35.
> 
> It would help with the videobuf cleanup as well, but that's just a bonus.
> 
> If no one objects, then I can prepare a patch series for this.

With respect to V4L1, there are some aspects to consider:

1) The removal (or conversion to V4L2) of the existing V4L1 drivers. I think this
is a good thing. Hans already said he wants to convert a few more drivers to V4L2.
So, we need to check with him if 2.6.35 is feasible. This means that he has something
like 5-6 weeks to convert, in order to get the next window.

2) The removal of V4L1 compatibility layer. If you take a look at the
feature-removal-schedule.txt annoncement, it talks about removing the V4L1 drivers,
not about removing the V4L1 compat layer: it mentions only videodev.h removal from
userspace API, and says that V4L1 compat will exist "for a while". What I'm meant
to do with that announcement text is that, once removed all V4L1 drivers, we'll replace
the V4L1 removal announcement with a V4L1 compat layer announcement, giving app developers
some time to fix their userspace apps. So, assuming that we'll remove V4L1 drivers on
2.6.35, we should wait at least to 2.6.36 before removing V4L1 compat.

3) The removal of V4L1 means that the existing applications should not try to include 
videodev.h with newer kernels or their compilations will break (easy to fix, but better
to remind application developers that may be reading this thread). Also, the removal of 
V4L1 compat means that all V4L1 only applications will stop working. What's the current
status of webcam/TV/stream/radio/videotext/vbi applications? Just yesterday, somebody
reported me a problem with radio crashing at the V4L1 compat layer. It seemed that maybe
not all radio apps got converted. So, before dropping compat layer support, we should
double check what apps will break.

-- 

Cheers,
Mauro
