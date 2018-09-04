Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38537 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbeIDNK1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 09:10:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id w11-v6so3049804wrc.5
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2018 01:46:18 -0700 (PDT)
Subject: Re: [PATCH] media: intel-ipu3: cio2: register the mdev on v4l2 async
 notifier complete
To: "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Bing Bu Cao <bingbu.cao@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20180831152045.9957-1-javierm@redhat.com>
 <cd307d41-ed19-5ab0-cbdb-a743cdb76e09@linux.intel.com>
 <c1e54228-a21a-b4a2-1083-c75b2dda797c@redhat.com>
 <b15b236e-e0a7-8b2f-1e1f-196c9dc04f4d@linux.intel.com>
 <44eb94a8-3712-155b-b3ab-35538f5b6b38@redhat.com>
 <F4B393EC1A37C8418714AECDAAEF72A93C9A39FC@shsmsx102.ccr.corp.intel.com>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <1404b391-3fdc-9ccd-6467-bf65b4d10ec9@redhat.com>
Date: Tue, 4 Sep 2018 10:46:14 +0200
MIME-Version: 1.0
In-Reply-To: <F4B393EC1A37C8418714AECDAAEF72A93C9A39FC@shsmsx102.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tian Shu,

On 09/04/2018 07:01 AM, Qiu, Tian Shu wrote:
> Hi,
> 
> Raise my point.
> The case here is that we have multiple sensors connected to CIO2. The sensors work independently. So failure on one sensor should not block the function of the other.
> That is, we should not rely on that all sensors are ready before allowing user to operate on the ready cameras.
> Sometimes due to hardware issues or incompleteness, we did met the case that one sensor is not probing properly. And in this case, the current implementation blocks us using the working one.
> What I can think now to solve this are:

After discussing this with Sakari over IRC, I agree with you that $SUBJECT can
do more harm than good and the patch should just be dropped.

> 1. Register multiple media devices. One for each sensor path. This will increase media device count.
> 2. Use .bound callback to create the link and register the subdev node for each sensor. Leave .complete empty.
>      Not sure if this breaks the rule of media framework. And also have not found an API to register one single subdev node.
>

I agree with your comment on (2) since currently the driver isn't able to cope
with the case that you are describing, as you mention the links and the subdev
node registration are done in the .complete callback. So that logic should be
moved to the .bound callback instead, so the media graph is usable even if one
of the drivers for a pending subdevice fails to probe.

> Thanks
> Tianshu Qiu
> 

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
