Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab2GEVlc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 17:41:32 -0400
Message-ID: <4FF60A00.4000802@redhat.com>
Date: Thu, 05 Jul 2012 18:41:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	elezegarcia@gmail.com, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR 3.6] V4L2 API cleanups
References: <4FD50223.4030501@iki.fi> <4FF5FF3F.6030909@redhat.com> <4FF60566.5070802@iki.fi>
In-Reply-To: <4FF60566.5070802@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-07-2012 18:21, Sakari Ailus escreveu:
> Hi Mauro,
> 
> Mauro Carvalho Chehab wrote:
>> Em 10-06-2012 17:22, Sakari Ailus escreveu:
>>> Hi Mauro,
>>>
>>> Here are two V4L2 API cleanup patches; the first removes __user from
>>> videodev2.h from a few places, making it possible to use the header file
>>> as such in user space, while the second one changes the
>>> v4l2_buffer.input field back to reserved.
>>>
>>>
>>> The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:
>>>
>>>     [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24
>>> 09:27:24 -0300)
>>>
>>> are available in the git repository at:
>>>     ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.6
>>>
>>> Sakari Ailus (2):
>>>         v4l: Remove __user from interface structure definitions
>>
>>>         v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
>>
>> Indeed, no drivers use V4L2_BUF_FLAG_INPUT, although I think this should be
>> used there, for some devices.
>>
>> There are several surveillance boards (mostly bttv boards, but there are
>> also cx88 and saa7134 models in the market) where the same chip is used
>> by up to 4 cameras. What software does is to switch the video input
>> to sample one of those cameras on a given frequency (1/60Hz or 1/30Hz),
>> in order to collect the streams for the 4 cameras.
>>
>> Without an input field there at the buffer metadata, it might happen that
>> software would look into the wrong input.
>>
>> That's said, considering that:
>>
>> 1) no driver is currently filling buffer queue with its "inputs" field,
>>     this flag is not used anywhere;
>>
>> 2) an implementation for input switch currently requires userspace to tell
>>     Kernel to switch to the next input, with is racy;
>>
>> 3) a model where the Kernel itself would switch to the next input would
>>     require some Kernelspace changes.
>>
>> I agree that we can just remove this bad implementation. If latter needed,
>> we'll need to not only reapply this patch but also to add a better way to
>> allow time-sharing the same video sampler with multiple inputs.
>>
>> So, I'll apply this patch.
> 
> Thanks!
> 
> There was a discussion between Ezequiel and Hans that in my understanding led to a conclusion there's no such use case, at least one which would be properly supported by the hardware. (Please correct me if I'm mistaken.)
> 
> <URL:http://www.spinics.net/lists/linux-media/msg48474.html>
> 
> So if we ever get such hardware then we could start rethinking it. :-)

This use case exists and I've seen several embedded surveillance systems
doing the right thing there (didn't look inside the source code),
but I suspect that there's a lack of open-source applications over there
and perhaps this used to be working with V4L1 API.

Once I got one of such hardware borrowed and I noticed the issue, but I
didn't manage to get more than one camera in order to properly address it
there.

It probably makes sense to have one set of video buffers per input, and let
the Kernel to do switch the buffer per input, but doing that is not trivial
with the V4L2 API.

Another alternative would be to add an ioctl that would allow userspace to
tell what inputs should be multiplexed, and then use the current way.

Doing input switching everytime switching is bad, as the framerate per
input will reduce. Also, input switching may generate artifacts, so
drivers need to be aware of that and do the switching during the vertical
retrace time.

Anyway, let's discuss it the next time someone come up with this issue, and
have some hardware with multiple cameras per input to test it.

Regards,
Mauro
