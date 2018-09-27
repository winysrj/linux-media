Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:39482 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727018AbeI0QKF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 12:10:05 -0400
Subject: Re: [PATCH 0/2] media: intel-ipu3: allow the media graph to be used
 even if a subdev fails
To: Javier Martinez Canillas <javierm@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org
References: <20180904113018.14428-1-javierm@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0e31ae40-276e-22be-c6aa-b62f8dbea79e@xs4all.nl>
Date: Thu, 27 Sep 2018 11:52:35 +0200
MIME-Version: 1.0
In-Reply-To: <20180904113018.14428-1-javierm@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On 09/04/2018 01:30 PM, Javier Martinez Canillas wrote:
> Hello,
> 
> This series allows the ipu3-cio2 driver to properly expose a subset of the
> media graph even if some drivers for the pending subdevices fail to probe.
> 
> Currently the driver exposes a non-functional graph since the pad links are
> created and the subdev dev nodes are registered in the v4l2 async .complete
> callback. Instead, these operations should be done in the .bound callback.
> 
> Patch #1 just adds a v4l2_device_register_subdev_node() function to allow
> registering a single device node for a subdev of a v4l2 device.
> 
> Patch #2 moves the logic of the ipu3-cio2 .complete callback to the .bound
> callback. The .complete callback is just removed since is empy after that.

Sorry, I missed this series until you pointed to it on irc just now :-)

I have discussed this topic before with Sakari and Laurent. My main problem
with this is how an application can discover that not everything is online?
And which parts are offline?

Perhaps a car with 10 cameras can function with 9, but not with 8. How would
userspace know?

I completely agree that we need to support these advanced scenarios (including
what happens when a camera suddenly fails), but it is the userspace aspects
for which I would like to see an RFC first before you can do these things.

Regards,

	Hans

> 
> Best regards,
> Javier
> 
> 
> Javier Martinez Canillas (2):
>   [media] v4l: allow to register dev nodes for individual v4l2 subdevs
>   media: intel-ipu3: create pad links and register subdev nodes at bound
>     time
> 
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 66 ++++++-----------
>  drivers/media/v4l2-core/v4l2-device.c    | 90 ++++++++++++++----------
>  include/media/v4l2-device.h              | 10 +++
>  3 files changed, 85 insertions(+), 81 deletions(-)
> 
