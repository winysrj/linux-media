Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43188 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030400AbaDJSs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 14:48:57 -0400
Message-ID: <5346E797.5070503@iki.fi>
Date: Thu, 10 Apr 2014 21:48:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 5/9] Allow passing file descriptors to yavta
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <1393690690-5004-6-git-send-email-sakari.ailus@iki.fi> <349099482.s11F5mBja6@avalon>
In-Reply-To: <349099482.s11F5mBja6@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the comments.

Laurent Pinchart wrote:
...
>> @@ -196,6 +192,16 @@ static int video_open(struct device *dev, const char
>> *devname, int no_query)
>>
>>   	printf("Device %s opened.\n", devname);
>>
>> +	dev->opened = 1;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_querycap(struct device *dev, int no_query) {
>> +	struct v4l2_capability cap;
>> +	unsigned int capabilities;
>> +	int ret;
>> +
>
> video_querycap ends up setting the dev->type field, which isn't really the job
> of a query function. Would there be a clean way to pass the fd to the
> video_open() function instead ? Maybe video_open() could be split and/or
> renamed to video_init() ?

Agreed. I'll separate queue type selection from querycap. As the 
querycap needs to be done after opening the device, I'll put it into 
another function. I'm ok with video_init(), but what would you think 
about e.g. video_set_queue_type() as the function does nothing else.

-- 
Regards,

Sakari Ailus
sakari.ailus@iki.fi
