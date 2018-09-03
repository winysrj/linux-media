Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39891 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbeICLyq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2018 07:54:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id o37-v6so16726111wrf.6
        for <linux-media@vger.kernel.org>; Mon, 03 Sep 2018 00:35:52 -0700 (PDT)
Subject: Re: [PATCH] media: intel-ipu3: cio2: register the mdev on v4l2 async
 notifier complete
To: Bing Bu Cao <bingbu.cao@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org
References: <20180831152045.9957-1-javierm@redhat.com>
 <cd307d41-ed19-5ab0-cbdb-a743cdb76e09@linux.intel.com>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <c1e54228-a21a-b4a2-1083-c75b2dda797c@redhat.com>
Date: Mon, 3 Sep 2018 09:35:48 +0200
MIME-Version: 1.0
In-Reply-To: <cd307d41-ed19-5ab0-cbdb-a743cdb76e09@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks a lot your feedback.

On 09/03/2018 09:25 AM, Bing Bu Cao wrote:
> 
> 
> On 08/31/2018 11:20 PM, Javier Martinez Canillas wrote:
>> Commit 9832e155f1ed ("[media] media-device: split media initialization and
>> registration") split the media_device_register() function in two, to avoid
>> a race condition that can happen when the media device node is accessed by
>> userpace before the pending subdevices have been asynchronously registered.
>>
>> But the ipu3-cio2 driver calls the media_device_register() function right
>> after calling media_device_init() which defeats the purpose of having two
>> separate functions.
>>
>> In that case, userspace could have a partial view of the media device if
>> it opened the media device node before all the pending devices have been
>> bound. So instead, only register the media device once all pending v4l2
>> subdevices have been registered.
> Javier, Thanks for your patch.
> IMHO, there are no big differences for registering the cio2 before and after all the subdevices are ready.
> User may see a partial view of media graph but it presents what it really is then.
> It indicate that device is not available currently not it is not there.

I disagree that there are no differences. The media graph shouldn't be exposed
until its complete. That's the reason why we have a v4l2 async notifier .bound
and .complete callbacks (otherwise the .bound would be enough).

It's also the reason why media register was split in _init and _register, as I
mentioned in the commit message.

> Could you help tell more details about your problem? The full context is helpful for me to reproduce your problem.

If an application opens the media device node, how it would know that has an
incomplete media graph? how it would know once the subdevice has been .bound
and that has to query the media graph again?

AFAIK there's no way to notify that information to user-space currenctly but
I may be wrong.

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
