Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37151 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728685AbeIQVtx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 17:49:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id n11-v6so10321582wmc.2
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 09:21:49 -0700 (PDT)
Subject: Re: [PATCH 0/2] media: intel-ipu3: allow the media graph to be used
 even if a subdev fails
To: linux-kernel@vger.kernel.org
Cc: Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org
References: <20180904113018.14428-1-javierm@redhat.com>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <4e2acf4a-e466-c830-35e0-69a653c797ff@redhat.com>
Date: Mon, 17 Sep 2018 18:21:46 +0200
MIME-Version: 1.0
In-Reply-To: <20180904113018.14428-1-javierm@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tianshu and Sakari,

On 9/4/18 1:30 PM, Javier Martinez Canillas wrote:
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

Any comments about these patches?

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
