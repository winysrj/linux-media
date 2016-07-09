Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38646 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756658AbcGIXXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jul 2016 19:23:50 -0400
Date: Sun, 10 Jul 2016 02:23:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: Re: [PATCH v2.1 3/5] media: Refactor copying IOCTL arguments from
 and to user space
Message-ID: <20160709232316.GZ24980@valkosipuli.retiisi.org.uk>
References: <1462360855-23354-4-git-send-email-sakari.ailus@linux.intel.com>
 <3214203.0Eb5nWCm1s@avalon>
 <20160709220309.GX24980@valkosipuli.retiisi.org.uk>
 <1611496.C5bpE1Z3WL@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611496.C5bpE1Z3WL@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 10, 2016 at 02:12:24AM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Sunday 10 Jul 2016 01:03:09 Sakari Ailus wrote:
> > On Sat, Jul 09, 2016 at 10:29:03PM +0300, Laurent Pinchart wrote:
> > > On Monday 09 May 2016 16:16:26 Sakari Ailus wrote:
> > >> Laurent Pinchart wrote:
> > >>> On Wednesday 04 May 2016 16:09:51 Sakari Ailus wrote:
> > >>>> Refactor copying the IOCTL argument structs from the user space and
> > >>>> back, in order to reduce code copied around and make the
> > >>>> implementation more robust.
> > >>>> 
> > >>>> As a result, the copying is done while not holding the graph mutex.
> > >>>> 
> > >>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >>>> ---
> > >>>> since v2:
> > >>>> 
> > >>>> - Remove function to calculate maximum argument size, replace by a
> > >>>>   char array of 256 or kmalloc() if that's too small.
> > >>>>  
> > >>>>  drivers/media/media-device.c | 194 ++++++++++++++-------------------
> > >>>>  1 file changed, 94 insertions(+), 100 deletions(-)
> > >>>> 
> > >>>> diff --git a/drivers/media/media-device.c
> > >>>> b/drivers/media/media-device.c
> > >>>> index 9b5a88d..0797e4b 100644
> > >>>> --- a/drivers/media/media-device.c
> > >>>> +++ b/drivers/media/media-device.c
> > > 
> > > [snip]
> > > 
> > >>>> @@ -453,10 +432,24 @@ static long __media_device_ioctl(
> > >>>> 
> > >>>>  	info = &info_array[_IOC_NR(cmd)];
> > >>>> 
> > >>>> +	if (_IOC_SIZE(info->cmd) > sizeof(__karg)) {
> > >>>> +		karg = kmalloc(_IOC_SIZE(info->cmd), GFP_KERNEL);
> > >>>> +		if (!karg)
> > >>>> +			return -ENOMEM;
> > >>>> +	}
> > >>>> +
> > >>>> +	info->arg_from_user(karg, arg, cmd);
> > >>>> +
> > >>>>  	mutex_lock(&dev->graph_mutex);
> > >>>> -	ret = info->fn(dev, arg);
> > >>>> +	ret = info->fn(dev, karg);
> > >>>>  	mutex_unlock(&dev->graph_mutex);
> > >>>> 
> > >>>> +	if (!ret)
> > >>> 
> > >>> How about if (!ret && info->arg_to_user) instead, and getting rid of
> > >>> copy_arg_to_user_nop() ?
> > >> 
> > >> I thought of that, but I decided to optimise the common case ---  which
> > >> is that the argument is copied back and forth. Not copying the argument
> > >> back is a very special case, we use it for a single compat IOCTL.
> > >> 
> > >> That said, we could use it for the proper ENUM_LINKS as well. Still that
> > >> does not change what's normal.
> > > 
> > > We're talking about one comparison and one branching instruction (that
> > > will not be taken in the common case). Is that micro-optimization really
> > > worth it in an ioctl path that is not that performance-critical ? If you
> > > think it is, could you analyse what the impact of the
> > > copy_arg_to_user_nop() function on cache locality is for the common case ?
> > > ;-)
> > 
> > I sense a certain amount of insistence in your arguments. Fine, I'll change
> > it.
> 
> Thanks. I'll change that in the next version of the request API patches I will 
> send out.

I think we rather should try to decrease the size of the set and get the
preparation patches in first.

I'm ready to send a pull request on these (after testing the rebased
patches), but it's been pending on the minimum arg size vs. list of
supported sizes discussion.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
