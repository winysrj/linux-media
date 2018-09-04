Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:19820 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbeIDJZW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 05:25:22 -0400
From: "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
To: Javier Martinez Canillas <javierm@redhat.com>,
        Bing Bu Cao <bingbu.cao@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] media: intel-ipu3: cio2: register the mdev on v4l2
 async notifier complete
Date: Tue, 4 Sep 2018 05:01:56 +0000
Message-ID: <F4B393EC1A37C8418714AECDAAEF72A93C9A39FC@shsmsx102.ccr.corp.intel.com>
References: <20180831152045.9957-1-javierm@redhat.com>
 <cd307d41-ed19-5ab0-cbdb-a743cdb76e09@linux.intel.com>
 <c1e54228-a21a-b4a2-1083-c75b2dda797c@redhat.com>
 <b15b236e-e0a7-8b2f-1e1f-196c9dc04f4d@linux.intel.com>
 <44eb94a8-3712-155b-b3ab-35538f5b6b38@redhat.com>
In-Reply-To: <44eb94a8-3712-155b-b3ab-35538f5b6b38@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Raise my point.
The case here is that we have multiple sensors connected to CIO2. The sensors work independently. So failure on one sensor should not block the function of the other.
That is, we should not rely on that all sensors are ready before allowing user to operate on the ready cameras.
Sometimes due to hardware issues or incompleteness, we did met the case that one sensor is not probing properly. And in this case, the current implementation blocks us using the working one.
What I can think now to solve this are:
1. Register multiple media devices. One for each sensor path. This will increase media device count.
2. Use .bound callback to create the link and register the subdev node for each sensor. Leave .complete empty.
     Not sure if this breaks the rule of media framework. And also have not found an API to register one single subdev node.

Thanks
Tianshu Qiu


> -----Original Message-----
> From: Javier Martinez Canillas [mailto:javierm@redhat.com]
> Sent: Monday, September 3, 2018 4:52 PM
> To: Bing Bu Cao <bingbu.cao@linux.intel.com>; linux-kernel@vger.kernel.org
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Zheng, Jian Xu
> <jian.xu.zheng@intel.com>; Sakari Ailus <sakari.ailus@linux.intel.com>; Zhi, Yong <yong.zhi@intel.com>; Cao, Bingbu
> <bingbu.cao@intel.com>; linux-media@vger.kernel.org
> Subject: Re: [PATCH] media: intel-ipu3: cio2: register the mdev on v4l2 async notifier complete
> 
> On 09/03/2018 10:49 AM, Bing Bu Cao wrote:
> >
> >
> > On 09/03/2018 03:35 PM, Javier Martinez Canillas wrote:
> >> Hi,
> >>
> >> Thanks a lot your feedback.
> >>
> >> On 09/03/2018 09:25 AM, Bing Bu Cao wrote:
> >>>
> >>> On 08/31/2018 11:20 PM, Javier Martinez Canillas wrote:
> >>>> Commit 9832e155f1ed ("[media] media-device: split media initialization and
> >>>> registration") split the media_device_register() function in two, to avoid
> >>>> a race condition that can happen when the media device node is accessed by
> >>>> userpace before the pending subdevices have been asynchronously registered.
> >>>>
> >>>> But the ipu3-cio2 driver calls the media_device_register() function right
> >>>> after calling media_device_init() which defeats the purpose of having two
> >>>> separate functions.
> >>>>
> >>>> In that case, userspace could have a partial view of the media device if
> >>>> it opened the media device node before all the pending devices have been
> >>>> bound. So instead, only register the media device once all pending v4l2
> >>>> subdevices have been registered.
> >>> Javier, Thanks for your patch.
> >>> IMHO, there are no big differences for registering the cio2 before and after all the subdevices are ready.
> >>> User may see a partial view of media graph but it presents what it really is then.
> >>> It indicate that device is not available currently not it is not there.
> >> I disagree that there are no differences. The media graph shouldn't be exposed
> >> until its complete. That's the reason why we have a v4l2 async notifier .bound
> >> and .complete callbacks (otherwise the .bound would be enough).
> >>
> >> It's also the reason why media register was split in _init and _register, as I
> >> mentioned in the commit message.
> > I revisit the commit 9832e155f1ed and understand and agree that.
> 
> Great. Does this mean the patch has your Reviewed-by / Acked-by ?
> 
> > Seems like there are some other drivers (such as rcar-vin and omap4iss) still have similar issues.
> 
> Yes it seems so. I don't have access to hardware with these IP blocks though,
> I'm hesitant to attempt to fix them.
> 
> Best regards,
> --
> Javier Martinez Canillas
> Software Engineer - Desktop Hardware Enablement
> Red Hat
