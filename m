Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab2AFNrl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 08:47:41 -0500
Message-ID: <4F06FB76.8070205@redhat.com>
Date: Fri, 06 Jan 2012 11:47:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: "'Hans Verkuil'" <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] vpif_capture.c: v4l2_device_register() is called too
 late in vpif_probe()
References: <201112131044.42862.hverkuil@xs4all.nl> <E99FAA59F8D8D34D8A118DD37F7C8F75015F19@DBDE01.ent.ti.com>
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F75015F19@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13-12-2011 10:19, Hadli, Manjunath wrote:
> Hans,
> 
> On Tue, Dec 13, 2011 at 15:14:42, Hans Verkuil wrote:
>> The function v4l2_device_register() is called too late in vpif_probe().
>> This meant that vpif_obj.v4l2_dev is accessed before it is initialized which caused a crash.
>>
>> This used to work in the past, but video_register_device() is now actually using the v4l2_dev pointer.
> I also found this issue today. Good catch!
>>
>> Note that vpif_display.c doesn't have this bug, there v4l2_device_register() is called at the beginning of vpif_probe.
>>
>> Signed-off-by: Georgios Plakaris <gplakari@cisco.com>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
>> index 49e4deb..6504e40 100644
>> --- a/drivers/media/video/davinci/vpif_capture.c
>> +++ b/drivers/media/video/davinci/vpif_capture.c
>> @@ -2177,6 +2177,12 @@ static __init int vpif_probe(struct platform_device *pdev)
>>  		return err;
>>  	}
>>  
>> +	err = v4l2_device_register(vpif_dev, &vpif_obj.v4l2_dev);
>> +	if (err) {
>> +		v4l2_err(vpif_dev->driver, "Error registering v4l2 device\n");
>> +		return err;
>> +	}
>> +
>>  	k = 0;
>>  	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k))) {
>>  		for (i = res->start; i <= res->end; i++) { @@ -2246,12 +2252,6 @@ static __init int vpif_probe(struct platform_device *pdev)
>>  		goto probe_out;
>>  	}
>>  
>> -	err = v4l2_device_register(vpif_dev, &vpif_obj.v4l2_dev);
>> -	if (err) {
>> -		v4l2_err(vpif_dev->driver, "Error registering v4l2 device\n");
>> -		goto probe_subdev_out;
>> -	}
>> -
>>  	for (i = 0; i < subdev_count; i++) {
>>  		subdevdata = &config->subdev_info[i];
>>  		vpif_obj.sd[i] =
>> @@ -2281,7 +2281,6 @@ probe_subdev_out:
>>  
>>  	j = VPIF_CAPTURE_MAX_DEVICES;
>>  probe_out:
>> -	v4l2_device_unregister(&vpif_obj.v4l2_dev);
>>  	for (k = 0; k < j; k++) {
>>  		/* Get the pointer to the channel object */
>>  		ch = vpif_obj.dev[k];
>> @@ -2303,6 +2302,7 @@ vpif_int_err:
>>  		if (res)
>>  			i = res->end;
>>  	}
>> +	v4l2_device_unregister(&vpif_obj.v4l2_dev);
>>  	return err;
>>  }
>>  
>>
>>
>>
> 
> ACKed by me. <Manjunath.hadli@ti.com>

Please, reply with the standard way:
Acked-by: Manjunath Hadli <Manjunath.hadli@ti.com>

Otherwise, patchwork will not catch your ack.

> 
> Thx,
> -Manju
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

