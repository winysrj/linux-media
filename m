Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47318 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752032Ab2GEVVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 17:21:43 -0400
Message-ID: <4FF60566.5070802@iki.fi>
Date: Fri, 06 Jul 2012 00:21:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	elezegarcia@gmail.com, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR 3.6] V4L2 API cleanups
References: <4FD50223.4030501@iki.fi> <4FF5FF3F.6030909@redhat.com>
In-Reply-To: <4FF5FF3F.6030909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> Em 10-06-2012 17:22, Sakari Ailus escreveu:
>> Hi Mauro,
>>
>> Here are two V4L2 API cleanup patches; the first removes __user from
>> videodev2.h from a few places, making it possible to use the header file
>> as such in user space, while the second one changes the
>> v4l2_buffer.input field back to reserved.
>>
>>
>> The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:
>>
>>     [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24
>> 09:27:24 -0300)
>>
>> are available in the git repository at:
>>     ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.6
>>
>> Sakari Ailus (2):
>>         v4l: Remove __user from interface structure definitions
>
>>         v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
>
> Indeed, no drivers use V4L2_BUF_FLAG_INPUT, although I think this should be
> used there, for some devices.
>
> There are several surveillance boards (mostly bttv boards, but there are
> also cx88 and saa7134 models in the market) where the same chip is used
> by up to 4 cameras. What software does is to switch the video input
> to sample one of those cameras on a given frequency (1/60Hz or 1/30Hz),
> in order to collect the streams for the 4 cameras.
>
> Without an input field there at the buffer metadata, it might happen that
> software would look into the wrong input.
>
> That's said, considering that:
>
> 1) no driver is currently filling buffer queue with its "inputs" field,
>     this flag is not used anywhere;
>
> 2) an implementation for input switch currently requires userspace to tell
>     Kernel to switch to the next input, with is racy;
>
> 3) a model where the Kernel itself would switch to the next input would
>     require some Kernelspace changes.
>
> I agree that we can just remove this bad implementation. If latter needed,
> we'll need to not only reapply this patch but also to add a better way to
> allow time-sharing the same video sampler with multiple inputs.
>
> So, I'll apply this patch.

Thanks!

There was a discussion between Ezequiel and Hans that in my 
understanding led to a conclusion there's no such use case, at least one 
which would be properly supported by the hardware. (Please correct me if 
I'm mistaken.)

<URL:http://www.spinics.net/lists/linux-media/msg48474.html>

So if we ever get such hardware then we could start rethinking it. :-)

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi


