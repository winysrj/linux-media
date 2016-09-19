Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:56216 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750772AbcISPWe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 11:22:34 -0400
Subject: Re: [PATCH v4 0/8] adv7180 subdev fixes, v4
To: Jack Mitchell <ml@embed.me.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>, lars@metafoo.de
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
 <13d4da12-f0e2-6e3b-9fc2-a081cfc7014c@embed.me.uk>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7aee5a85-e590-64bd-e95d-53ff8a6b3ccb@xs4all.nl>
Date: Mon, 19 Sep 2016 17:22:27 +0200
MIME-Version: 1.0
In-Reply-To: <13d4da12-f0e2-6e3b-9fc2-a081cfc7014c@embed.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2016 04:19 PM, Jack Mitchell wrote:
> 
> 
> On 03/08/16 19:03, Steve Longerbeam wrote:
>> Steve Longerbeam (8):
>>   media: adv7180: fix field type
>>   media: adv7180: define more registers
>>   media: adv7180: add support for NEWAVMODE
>>   media: adv7180: add power pin control
>>   media: adv7180: implement g_parm
>>   media: adv7180: change mbus format to UYVY
>>   v4l: Add signal lock status to source change events
>>   media: adv7180: enable lock/unlock interrupts
>>
>>  .../devicetree/bindings/media/i2c/adv7180.txt      |   8 +
>>  Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   9 +
>>  Documentation/media/videodev2.h.rst.exceptions     |   1 +
>>  drivers/media/i2c/Kconfig                          |   2 +-
>>  drivers/media/i2c/adv7180.c                        | 200 +++++++++++++++++----
>>  include/uapi/linux/videodev2.h                     |   1 +
>>  6 files changed, 183 insertions(+), 38 deletions(-)
>>
> 
> Did anything come of this patchset, I see a few select patches from the 
> original (full imx6) series have been merged in but only seems partial?

I cherry-picked a few patches, but most are still in my TODO list.

I need time to carefully look at the interlaced/NEWAVMODE support. So those
patches won't make 4.9 but will be postponed for 4.10.

Regards,

	Hans
