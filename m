Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35993 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdGMIb4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 04:31:56 -0400
Received: by mail-yw0-f175.google.com with SMTP id a12so19613635ywh.3
        for <linux-media@vger.kernel.org>; Thu, 13 Jul 2017 01:31:56 -0700 (PDT)
Received: from mail-yw0-f179.google.com (mail-yw0-f179.google.com. [209.85.161.179])
        by smtp.gmail.com with ESMTPSA id p82sm1702113ywc.77.2017.07.13.01.31.53
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jul 2017 01:31:54 -0700 (PDT)
Received: by mail-yw0-f179.google.com with SMTP id v193so19638412ywg.2
        for <linux-media@vger.kernel.org>; Thu, 13 Jul 2017 01:31:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170713082156.zbxnle22effcoarm@valkosipuli.retiisi.org.uk>
References: <1499730214-9005-1-git-send-email-yong.zhi@intel.com>
 <1499730214-9005-4-git-send-email-yong.zhi@intel.com> <20170711103343.qynz4rps7fsx36bc@valkosipuli.retiisi.org.uk>
 <C193D76D23A22742993887E6D207B54D1ADD7EFB@ORSMSX106.amr.corp.intel.com>
 <CAAFQd5CKwWoiEZo9rBy1P3ioGJyScr8iG5iDpq_M+Wem6YAS9g@mail.gmail.com> <20170713082156.zbxnle22effcoarm@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 13 Jul 2017 17:31:33 +0900
Message-ID: <CAAFQd5CN=AK8N6MkJSj8+KGbDEQMmsP=bZq4wyz22Bjb8Y3hmg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] intel-ipu3: cio2: Add new MIPI-CSI2 driver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Vijaykumar, Ramya" <ramya.vijaykumar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 13, 2017 at 5:21 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> >> +     ret = v4l2_async_notifier_register(&cio2->v4l2_dev, &cio2->notifier);
>> >> +     if (ret) {
>> >> +             cio2->notifier.num_subdevs = 0;
>> >
>> > No need to assign num_subdevs as 0.
>> >
>> > [YZ] _notifier_exit() will call _unregister() if this is not 0.
>>
>> You shouldn't call _exit() if _init() failed. I noticed that many
>> error paths in your code does this. Please fix it.
>
> In general most functions that initialise and clean up something are
> implemented so that the cleanup function can be called without calling the
> corresponding init function. This eases driver implementation by reducing
> complexity in error paths that are difficult to implement and test to begin
> with, so I don't see anything wrong with that, quite the contrary.
>
> I.e. in this case you should call v4l2_async_notifier_unregister() without
> checking the number of async sub-devices.
>
> There are exceptions to that though; not all the framework functions behave
> this way. Of kernel APIs, e.g. kmalloc() and kfree() do this --- you can
> pass a NULL pointer to kfree() and it does nothing.

I'd argue that most of the cleanup paths I've seen in the kernel are
the opposite. If you properly check for errors in your code, it's
actually very unlikely that you need to call a cleanup function
without the init function called... That said, I've seen the pattern
you describe too, so probably either there is no strict rule or it's
not strictly enforced. (Still, judging by
https://www.kernel.org/doc/html/v4.10/process/coding-style.html#centralized-exiting-of-functions,
which mentions "one err bugs" and suggests "to split it up into two
error labels", the pattern I'm arguing for might be the recommended
default.)

Best regards,
Tomasz
