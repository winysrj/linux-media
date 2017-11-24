Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:46251 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752223AbdKXJDt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 04:03:49 -0500
Received: by mail-ua0-f177.google.com with SMTP id 21so14292363uas.13
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 01:03:49 -0800 (PST)
Received: from mail-ua0-f179.google.com (mail-ua0-f179.google.com. [209.85.217.179])
        by smtp.gmail.com with ESMTPSA id y41sm4676722uah.5.2017.11.24.01.03.47
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Nov 2017 01:03:47 -0800 (PST)
Received: by mail-ua0-f179.google.com with SMTP id f14so14304693uaa.5
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 01:03:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171124085511.pehj5kwvykpzc25a@paasikivi.fi.intel.com>
References: <CAFLEztQg2R0oLcSfRKsQGFWTC1pTzPVqoksdKtGAYEYV6nAf9A@mail.gmail.com>
 <20171124085511.pehj5kwvykpzc25a@paasikivi.fi.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 24 Nov 2017 18:03:26 +0900
Message-ID: <CAAFQd5DowE=EdLkTi3q02hcKr_tr7GqKOZbKGYaz6uvvzEACHw@mail.gmail.com>
Subject: Re: notifier is skipped in some situations
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Jacob Chen <jacob-chen@iotwrt.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

We have the following graph:

    ISP (registers notifier for v4l2_dev)

     |

    PHY (registers notifier for v4l2_subdev, just like sensors for
flash/focuser)

  |       \

sensor0   sensor1

...

Both ISP and PHY are completely separate drivers not directly aware of
each other, since we have several different PHY IP blocks that we need
to support and some of them are multi-functional, such as CSI+DSI PHY
and need to be supported by drivers independent from the ISP driver.

Best regards,
Tomasz


On Fri, Nov 24, 2017 at 5:55 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi Jacob,
>
> On Fri, Nov 24, 2017 at 09:00:14AM +0800, Jacob Chen wrote:
>> Hi Sakari,
>>
>> I encountered a problem when using async sub-notifiers.
>>
>> It's like that:
>>     There are two notifiers, and they are waiting for one subdev.
>>     When this subdev is probing, only one notifier is completed and
>> the other one is skipped.
>
> Do you have a graph that has two master drivers (that register the
> notifier) and both are connected to the same sub-device? Could you provide
> exact graph you have?
>
>>
>> I found that in v15 of patch "v4l: async: Allow binding notifiers to
>> sub-devices", "v4l2_async_notifier_complete" is replaced by
>> v4l2_async_notifier_call_complete, which make it only complete one
>> notifier.
>>
>> Why is it changed? Can this be fixed?
>
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com
