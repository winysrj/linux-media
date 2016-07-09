Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38778 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbcGIT3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 15:29:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: Re: [PATCH v2.1 3/5] media: Refactor copying IOCTL arguments from and to user space
Date: Sat, 09 Jul 2016 22:29:03 +0300
Message-ID: <3214203.0Eb5nWCm1s@avalon>
In-Reply-To: <57308DAA.1000404@linux.intel.com>
References: <1462360855-23354-4-git-send-email-sakari.ailus@linux.intel.com> <2507022.47E6MxOJNv@avalon> <57308DAA.1000404@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 09 May 2016 16:16:26 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Wednesday 04 May 2016 16:09:51 Sakari Ailus wrote:
> >> Refactor copying the IOCTL argument structs from the user space and back,
> >> in order to reduce code copied around and make the implementation more
> >> robust.
> >> 
> >> As a result, the copying is done while not holding the graph mutex.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >> since v2:
> >> 
> >> - Remove function to calculate maximum argument size, replace by a char
> >>   array of 256 or kmalloc() if that's too small.
> >>  
> >>  drivers/media/media-device.c | 194 ++++++++++++++++---------------------
> >>  1 file changed, 94 insertions(+), 100 deletions(-)
> >> 
> >> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> >> index 9b5a88d..0797e4b 100644
> >> --- a/drivers/media/media-device.c
> >> +++ b/drivers/media/media-device.c

[snip]

> >> @@ -453,10 +432,24 @@ static long __media_device_ioctl(
> >> 
> >>  	info = &info_array[_IOC_NR(cmd)];
> >> 
> >> +	if (_IOC_SIZE(info->cmd) > sizeof(__karg)) {
> >> +		karg = kmalloc(_IOC_SIZE(info->cmd), GFP_KERNEL);
> >> +		if (!karg)
> >> +			return -ENOMEM;
> >> +	}
> >> +
> >> +	info->arg_from_user(karg, arg, cmd);
> >> +
> >>  	mutex_lock(&dev->graph_mutex);
> >> -	ret = info->fn(dev, arg);
> >> +	ret = info->fn(dev, karg);
> >>  	mutex_unlock(&dev->graph_mutex);
> >> 
> >> +	if (!ret)
> > 
> > How about if (!ret && info->arg_to_user) instead, and getting rid of
> > copy_arg_to_user_nop() ?
> 
> I thought of that, but I decided to optimise the common case ---  which
> is that the argument is copied back and forth. Not copying the argument
> back is a very special case, we use it for a single compat IOCTL.
> 
> That said, we could use it for the proper ENUM_LINKS as well. Still that
> does not change what's normal.

We're talking about one comparison and one branching instruction (that will 
not be taken in the common case). Is that micro-optimization really worth it 
in an ioctl path that is not that performance-critical ? If you think it is, 
could you analyse what the impact of the copy_arg_to_user_nop() function on 
cache locality is for the common case ? ;-)

-- 
Regards,

Laurent Pinchart

