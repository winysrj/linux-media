Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36061 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751584AbdGRREO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 13:04:14 -0400
Received: by mail-lf0-f49.google.com with SMTP id d78so15083897lfg.3
        for <linux-media@vger.kernel.org>; Tue, 18 Jul 2017 10:04:13 -0700 (PDT)
Date: Tue, 18 Jul 2017 19:04:11 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH v4 3/3] v4l: async: add subnotifier to subdevices
Message-ID: <20170718170411.GF28538@bigcity.dyn.berto.se>
References: <20170717165917.24851-1-niklas.soderlund+renesas@ragnatech.se>
 <20170717165917.24851-4-niklas.soderlund+renesas@ragnatech.se>
 <1da4fac1-3bf4-e66a-2341-b1f71f0f917d@xs4all.nl>
 <20170718144715.GD28538@bigcity.dyn.berto.se>
 <236d014c-ce8c-cd50-9500-c26e3f05991f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <236d014c-ce8c-cd50-9500-c26e3f05991f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2017-07-18 17:06:15 +0200, Hans Verkuil wrote:
> On 18/07/17 16:47, Niklas Söderlund wrote:
> >>>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >>>  {
> >>> -	struct v4l2_subdev *sd, *tmp;
> >>> +	struct v4l2_subdev *sd, *tmp, **subdev;
> >>>  	unsigned int notif_n_subdev = notifier->num_subdevs;
> >>>  	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> >>>  	struct device **dev;
> >>> @@ -217,6 +293,12 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >>>  			"Failed to allocate device cache!\n");
> >>>  	}
> >>>  
> >>> +	subdev = kvmalloc_array(n_subdev, sizeof(*subdev), GFP_KERNEL);
> >>> +	if (!dev) {
> >>> +		dev_err(notifier->v4l2_dev->dev,
> >>> +			"Failed to allocate subdevice cache!\n");
> >>> +	}
> >>> +
> >>
> >> How about making a little struct:
> >>
> >> 	struct whatever {
> >> 		struct device *dev;
> >> 		struct v4l2_subdev *sd;
> >> 	};
> >>
> >> and allocate an array of that. Only need to call kvmalloc_array once.
> > 
> > Neat idea, will do so for next version.
> > 
> >>
> >> Some comments after the dev_err of why you ignore the failed memory allocation
> >> and what the consequences of that are would be helpful. It is unexpected code,
> >> and that needs documentation.
> > 
> > I agree that it's unexpected and I don't know the reason for it, I was 
> > just mimic the existing behavior. If you are OK with it I be more then 
> > happy to add patch to this series returning -ENOMEM if the allocation 
> > failed as Geert pointed out if this allocation fails I think we are in a 
> > lot of trouble anyhow...
> > 
> > Let me know what you think, but I don't think I can add a comment 
> > explaining why the function don't simply abort on failure since I don't 
> > understand it myself.
> 
> So you don't understand the device_release_driver/device_attach reprobing bit either?
> 
> I did some digging and found this thread:
> 
> http://lkml.iu.edu/hypermail/linux/kernel/1210.2/00713.html
> 
> It explains the reason for this.

Nice, thanks for digging this out.

> 
> I'm pretty sure Greg K-H never saw this code :-)
> 
> Looking in drivers/base/bus.c I see this function: device_reprobe().
> 
> I think we need to use that instead.

I have now looked at device_reprobe() and unfortunately it can't be used 
in v4l2_async_notifier_unregister(). This is because some v4l2 drivers 
call v4l2_async_notifier_unregister() in there remove functions leading 
to call chains similar to this:

SyS_delete_module()
  rcar_vin_driver_exit()
    platform_driver_unregister()
      driver_unregister()
        bus_remove_driver()
          driver_detach()
            device_lock(dev->parent); <- Here the lock is taken
            device_release_driver_internal()
              platform_drv_remove()
                rcar_vin_remove()
                  v4l2_async_notifier_unregister()
                    device_reprobe()
                      device_lock(dev->parent); <- Here we dead lock

So we are stuck with calling device_release_driver() and device_attach() 
directly from v4l2-async.

> 
> Regards,
> 
> 	Hans

-- 
Regards,
Niklas Söderlund
