Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:41027 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbeH0AYz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Aug 2018 20:24:55 -0400
Subject: Re: [PATCH 3/7] media: imx274: don't hard-code the subdev name to
 DRIVER_NAME
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
References: <20180824163525.12694-1-luca@lucaceresoli.net>
 <20180824163525.12694-4-luca@lucaceresoli.net>
 <20180825144915.tq7m5jlikwndndzq@valkosipuli.retiisi.org.uk>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <799f4d1a-b91d-0404-7ef0-965d123319da@lucaceresoli.net>
Date: Sun, 26 Aug 2018 22:41:13 +0200
MIME-Version: 1.0
In-Reply-To: <20180825144915.tq7m5jlikwndndzq@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 25/08/2018 16:49, Sakari Ailus wrote:
> Hi Luca,
> 
> On Fri, Aug 24, 2018 at 06:35:21PM +0200, Luca Ceresoli wrote:
>> Forcibly setting the subdev name to DRIVER_NAME (i.e. "IMX274") makes
>> it non-unique and less informative.
>>
>> Let the driver use the default name from i2c, e.g. "IMX274 2-001a".
>>
>> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
>> ---
>>  drivers/media/i2c/imx274.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
>> index 9b524de08470..570706695ca7 100644
>> --- a/drivers/media/i2c/imx274.c
>> +++ b/drivers/media/i2c/imx274.c
>> @@ -1885,7 +1885,6 @@ static int imx274_probe(struct i2c_client *client,
>>  	imx274->client = client;
>>  	sd = &imx274->sd;
>>  	v4l2_i2c_subdev_init(sd, client, &imx274_subdev_ops);
>> -	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
>>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
>>  
>>  	/* initialize subdev media pad */
> 
> This ends up changing the entity as well as the sub-device name which may
> well break applications.

Right, unfortunately.

> On the other hand, you currently can't have more
> than one of these devices on a media device complex due to the name being
> specific to a driver, not the device.
>
> An option avoiding that would be to let the user choose by e.g. through a
> Kconfig option would avoid having to address that, but I really hate adding
> such options.

I agree adding a Kconfig option just for this would be very annoying.
However I think the issue affects a few other drivers (sr030pc30.c and
s5c73m3-core.c apparently), thus maybe one option could serve them all.

> I wonder what others think. If anyone ever needs to add another on a board
> so that it ends up being the part of the same media device complex
> (likely), then changing the name now rather than later would be the least
> pain. In this case I'd be leaning (slightly) towards accepting the patch
> and hoping there wouldn't be any fallout... I don't see any board (DT)
> containing imx274, at least not in the upstream kernel.

I'll be OK with either decision. Should we keep it as is, then I think a
comment before that line would be appropriate to clarify it's not
correct but it is kept for backward userspace compatibility. This would
help avoid new driver writers doing the same mistake, and prevent other
people to send another patch like mine.

Regards,
-- 
Luca
