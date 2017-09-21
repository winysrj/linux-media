Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33499 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdIULHA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 07:07:00 -0400
Received: by mail-wr0-f196.google.com with SMTP id b9so2966625wra.0
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 04:07:00 -0700 (PDT)
Subject: Re: [PATCH] tc358743: fix connected/active CSI-2 lane reporting
From: Ian Arkver <ian.arkver.dev@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>
References: <20170921102428.30709-1-p.zabel@pengutronix.de>
 <f3d4ce20-d3aa-f76f-0d07-e8153e3558a9@gmail.com>
Message-ID: <9518ed83-48da-472f-f895-4cd4c3797373@gmail.com>
Date: Thu, 21 Sep 2017 12:06:57 +0100
MIME-Version: 1.0
In-Reply-To: <f3d4ce20-d3aa-f76f-0d07-e8153e3558a9@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/09/17 12:04, Ian Arkver wrote:
> Hi Philipp
> 
> On 21/09/17 11:24, Philipp Zabel wrote:
>> g_mbus_config was supposed to indicate all supported lane numbers, not
>> only the number of those currently in active use. Since the tc358743
>> can dynamically reduce the number of active lanes if the required
>> bandwidth allows for it, report all lane numbers up to the connected
>> number of lanes as supported.
>> To allow communicating the number of currently active lanes, add a new
>> bitfield to the v4l2_mbus_config flags. This is a temporary fix, until
>> a better solution is found.
>>
>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>> ---
>>   drivers/media/i2c/tc358743.c  | 22 ++++++++++++----------
>>   include/media/v4l2-mediabus.h |  8 ++++++++
>>   2 files changed, 20 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
>> index e6f5c363ccab5..e2a9e6a18a49d 100644
>> --- a/drivers/media/i2c/tc358743.c
>> +++ b/drivers/media/i2c/tc358743.c
>> @@ -1464,21 +1464,22 @@ static int tc358743_g_mbus_config(struct 
>> v4l2_subdev *sd,
>>       /* Support for non-continuous CSI-2 clock is missing in the 
>> driver */
>>       cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
>> -    switch (state->csi_lanes_in_use) {
>> -    case 1:
>> +    if (state->bus.num_data_lanes > 0)
>>           cfg->flags |= V4L2_MBUS_CSI2_1_LANE;
>> -        break;
>> -    case 2:
>> +    if (state->bus.num_data_lanes > 1)
>>           cfg->flags |= V4L2_MBUS_CSI2_2_LANE;
>> -        break;
>> -    case 3:
>> +    if (state->bus.num_data_lanes > 2)
>>           cfg->flags |= V4L2_MBUS_CSI2_3_LANE;
>> -        break;
>> -    case 4:
>> +    if (state->bus.num_data_lanes > 3)
>>           cfg->flags |= V4L2_MBUS_CSI2_4_LANE;
>> -        break;
>> -    default:
>> +
>> +    if (state->csi_lanes_in_use > 4)
>>           return -EINVAL;
>> +
> 
> My understanding of Hans' comment:
> "I'd also add a comment that all other flags must be 0 if the device 
> tree is used. This to avoid mixing the two."
> 
> is that all the above should only happen if (!!state->pdata).

Except that state->pdata is a copy of the pdata, not a pointer, but you 
know what I mean. Some other check for DT needed here.

> I don't know if this would break any existing DT-using bridge drivers.
> 
> Regards,
> Ian
[snip]
