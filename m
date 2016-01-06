Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37670 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbcAFPEb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2016 10:04:31 -0500
Subject: Re: [PATCH 10/10] [media] tvp5150: Configure data interface via pdata
 or DT
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
 <1743151.ozK6T8LOF3@avalon> <568CFA1E.6060309@osg.samsung.com>
 <1895052.dqIgFQaCHk@avalon>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Message-ID: <568D2CF8.9090802@osg.samsung.com>
Date: Wed, 6 Jan 2016 12:04:24 -0300
MIME-Version: 1.0
In-Reply-To: <1895052.dqIgFQaCHk@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 01/06/2016 10:48 AM, Laurent Pinchart wrote:

[snip]

>>>> @@ -940,6 +948,16 @@ static int tvp5150_cropcap(struct v4l2_subdev *sd,
>>>> struct v4l2_cropcap *a)
>>>>  static int tvp5150_g_mbus_config(struct v4l2_subdev *sd,
>>>>  				 struct v4l2_mbus_config *cfg)
>>>>  {
>>>> +	struct tvp5150_platform_data *pdata = to_tvp5150(sd)->pdata;
>>>> +
>>>> +	if (pdata) {
>>>> +		cfg->type = pdata->bus_type;
>>>> +		cfg->flags = pdata->parallel_flags;
>>>
>>> The clock and sync signals polarity don't seem configurable, shouldn't
>>> they just be hardcoded as currently done ?
>>
>> That's a very good question, I added the flags because according to
>> Documentation/devicetree/bindings/media/video-interfaces.txt, the way
>> to define that the output format will be BT.656 is to avoid defining
>> {hsync,vsync,field-even}-active properties.
>>
>> IOW, if parallel sync is used, then these properties have to be defined
>> and it felt strange to not use in the driver what is defined in the DT.
> 
> In that case we should restrict the values of the properties to what the 
> hardware actually supports. I would hardcode the flags here, and check them 
> when parsing the endpoint to make sure they're valid.
>

That's a good idea, I'll also mention the supported values in the binding doc.
 
> If you find a register I have missed in the documentation with which 
> polarities could be configured then please also feel free to prove me wrong 
> :-)
>

I didn't find either when reading the datasheet to prepare this patch-set
so I think you are correct on that.

[snip]

>>>> +
>>>> +		pdata->bus_type = bus_cfg.bus_type;
>>>> +		pdata->parallel_flags = bus_cfg.bus.parallel.flags;
>>>
>>> The V4L2_MBUS_DATA_ACTIVE_HIGH flags set returned by
>>> tvp5150_g_mbus_config() when pdata is NULL is never set by
>>> v4l2_of_parse_endpoint(), should you add it unconditionally ?
>>
>> But v4l2_of_parse_endpoint() calls v4l2_of_parse_parallel_bus() which does
>> it or did I read the code incorrectly?
> 
> No, you're right, I had overlooked the V4L2_MBUS_DATA_ACTIVE_HIGH flag when 
> reading v4l2_of_parse_parallel_bus(), probably a typo when searching. Please 
> ignore that comment.
> 

Ok, thanks for the clarification.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
