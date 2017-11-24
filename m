Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:38558 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753249AbdKXJT7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 04:19:59 -0500
Received: by mail-ua0-f176.google.com with SMTP id f14so14331049uaa.5
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 01:19:58 -0800 (PST)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com. [209.85.213.53])
        by smtp.gmail.com with ESMTPSA id d77sm2868399vkf.22.2017.11.24.01.19.56
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Nov 2017 01:19:57 -0800 (PST)
Received: by mail-vk0-f53.google.com with SMTP id s197so13183085vkh.11
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 01:19:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171124091716.jasz6rkusazcwhpd@paasikivi.fi.intel.com>
References: <CAFLEztQg2R0oLcSfRKsQGFWTC1pTzPVqoksdKtGAYEYV6nAf9A@mail.gmail.com>
 <20171124085511.pehj5kwvykpzc25a@paasikivi.fi.intel.com> <CAAFQd5DowE=EdLkTi3q02hcKr_tr7GqKOZbKGYaz6uvvzEACHw@mail.gmail.com>
 <20171124091716.jasz6rkusazcwhpd@paasikivi.fi.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 24 Nov 2017 18:19:36 +0900
Message-ID: <CAAFQd5Cz0VfZB-JMf3YESAb4z0i+koQq=BRSzu7vy9Sdwi157A@mail.gmail.com>
Subject: Re: notifier is skipped in some situations
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacob Chen <jacob-chen@iotwrt.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 24, 2017 at 6:17 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi Tomasz,
>
> On Fri, Nov 24, 2017 at 06:03:26PM +0900, Tomasz Figa wrote:
>> Hi Sakari,
>>
>> We have the following graph:
>>
>>     ISP (registers notifier for v4l2_dev)
>>
>>      |
>>
>>     PHY (registers notifier for v4l2_subdev, just like sensors for
>> flash/focuser)
>>
>>   |       \
>>
>> sensor0   sensor1
>>
>> ...
>>
>> Both ISP and PHY are completely separate drivers not directly aware of
>> each other, since we have several different PHY IP blocks that we need
>> to support and some of them are multi-functional, such as CSI+DSI PHY
>> and need to be supported by drivers independent from the ISP driver.
>
> That should work fine. In the above case there are two notifiers, indeed,
> but they're not expecting the *same* sub-devices.

Got it.

Jacob, could you make sure there are no mistakes in the Device Tree source?

Best regards,
Tomasz

>
> What this could be about is that in some version of the set I disabled the
> complete callback on the sub-notifiers for two reasons: there was no need
> seen for them and the complete callback is problematic in general (there's
> been discussion on that, mostly related to earlier versions of the fwnode
> parsing patchset, on #v4l and along the Renesas rcar-csi2 patchsets).
>
>>
>> Best regards,
>> Tomasz
>>
>>
>> On Fri, Nov 24, 2017 at 5:55 PM, Sakari Ailus
>> <sakari.ailus@linux.intel.com> wrote:
>> > Hi Jacob,
>> >
>> > On Fri, Nov 24, 2017 at 09:00:14AM +0800, Jacob Chen wrote:
>> >> Hi Sakari,
>> >>
>> >> I encountered a problem when using async sub-notifiers.
>> >>
>> >> It's like that:
>> >>     There are two notifiers, and they are waiting for one subdev.
>> >>     When this subdev is probing, only one notifier is completed and
>> >> the other one is skipped.
>> >
>> > Do you have a graph that has two master drivers (that register the
>> > notifier) and both are connected to the same sub-device? Could you provide
>> > exact graph you have?
>> >
>> >>
>> >> I found that in v15 of patch "v4l: async: Allow binding notifiers to
>> >> sub-devices", "v4l2_async_notifier_complete" is replaced by
>> >> v4l2_async_notifier_call_complete, which make it only complete one
>> >> notifier.
>> >>
>> >> Why is it changed? Can this be fixed?
>> >
>> > --
>> > Sakari Ailus
>> > sakari.ailus@linux.intel.com
>
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com
