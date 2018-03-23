Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:41512 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752526AbeCWOIe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 10:08:34 -0400
Received: by mail-vk0-f43.google.com with SMTP id l123so7344387vke.8
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2018 07:08:33 -0700 (PDT)
Received: from mail-vk0-f43.google.com (mail-vk0-f43.google.com. [209.85.213.43])
        by smtp.gmail.com with ESMTPSA id j33sm2505132uaj.36.2018.03.23.07.08.31
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Mar 2018 07:08:32 -0700 (PDT)
Received: by mail-vk0-f43.google.com with SMTP id j85so7358358vke.0
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2018 07:08:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180323135024.qxd633qccv5rtid3@paasikivi.fi.intel.com>
References: <1521218319-14972-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5Cbn1sqRWq6A6xYthkHtFjHaa64URDiKDMXOpDPr1r5EA@mail.gmail.com> <20180323135024.qxd633qccv5rtid3@paasikivi.fi.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 23 Mar 2018 23:08:11 +0900
Message-ID: <CAAFQd5ATcV-kWCw+QQfA986G-gwSw2FUZ93Ox_m=fkjixtyuQA@mail.gmail.com>
Subject: Re: [PATCH v9.1] media: imx258: Add imx258 camera sensor driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Yeh <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 23, 2018 at 10:50 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi Tomasz,
>
> On Fri, Mar 23, 2018 at 08:43:50PM +0900, Tomasz Figa wrote:
>> Hi Andy,
>>
>> Some issues found when reviewing cherry pick of this patch to Chrome
>> OS kernel. Please see inline.
>>
>> On Sat, Mar 17, 2018 at 1:38 AM, Andy Yeh <andy.yeh@intel.com> wrote:
>>
>> [snip]
>>
>> > +       case V4L2_CID_VBLANK:
>> > +               /*
>> > +                * Auto Frame Length Line Control is enabled by default.
>> > +                * Not need control Vblank Register.
>> > +                */
>>
>> What is the meaning of this control then? Should it be read-only?
>
> The read-only flag is for the uAPI; the control framework still passes
> through changes to the control value done using kAPI to the driver.

The read-only flag is not even set in current code.

Also, I'm not sure about the control framework setting read-only
control. According to the code, it doesn't:
https://elixir.bootlin.com/linux/latest/source/drivers/media/v4l2-core/v4l2-ctrls.c#L2477

Best regards,
Tomasz
