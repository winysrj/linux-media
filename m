Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:34508 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754815AbdIRJZe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 05:25:34 -0400
Subject: Re: [PATCH v4 2/3] media: ov7670: Add the get_fmt callback
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Jonathan Corbet <corbet@lwn.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20170918064514.6841-1-wenyou.yang@microchip.com>
 <20170918064514.6841-3-wenyou.yang@microchip.com>
 <20170918073628.nwjdyfdk7hvsetfb@valkosipuli.retiisi.org.uk>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <2f2a0259-1176-74b7-d9f7-a5cf7392ebdf@Microchip.com>
Date: Mon, 18 Sep 2017 17:25:28 +0800
MIME-Version: 1.0
In-Reply-To: <20170918073628.nwjdyfdk7hvsetfb@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 2017/9/18 15:36, Sakari Ailus wrote:
> Hi Wenyou,
>
> On Mon, Sep 18, 2017 at 02:45:13PM +0800, Wenyou Yang wrote:
>> @@ -998,8 +1002,15 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
>>   		ret = ov7670_try_fmt_internal(sd, &format->format, NULL, NULL);
>>   		if (ret)
>>   			return ret;
>> -		cfg->try_fmt = format->format;
>> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
>> +		struct v4l2_mbus_framefmt *mbus_fmt;
> This will emit a compiler warning at least.
Thank you for your review.
Will be fixed in next version.
>
>> +
>> +		mbus_fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
>> +		*mbus_fmt = format->format;
>>   		return 0;
>> +#else
>> +		return -ENOTTY;
>> +#endif
>>   	}
>>   
>>   	ret = ov7670_try_fmt_internal(sd, &format->format, &ovfmt, &wsize);

Best Regards,
Wenyou Yang
