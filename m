Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:52469 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZGNAP2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 20:15:28 -0400
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KMQ003P6WPL50@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jul 2009 09:15:22 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KMQ00JYKWPLPH@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jul 2009 09:15:21 +0900 (KST)
Date: Tue, 14 Jul 2009 09:15:21 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 2/2] radio-si470x: add i2c driver for si470x
In-reply-to: <208cbae30907131326t7cf9494bq9c28fed81cffa777@mail.gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	tobias.lorenz@gmx.net, kyungmin.park@samsung.com
Message-id: <4A5BCE19.9090502@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4A5B1950.8000800@samsung.com>
 <208cbae30907131326t7cf9494bq9c28fed81cffa777@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Alexey.

<snip>

>> diff --git a/linux/drivers/media/radio/si470x/radio-si470x-common.c
>> b/linux/drivers/media/radio/si470x/radio-si470x-common.c
>> index d2dc1ff..77f79e7 100644
>> --- a/linux/drivers/media/radio/si470x/radio-si470x-common.c
>> +++ b/linux/drivers/media/radio/si470x/radio-si470x-common.c
>> @@ -473,11 +473,13 @@ static int si470x_vidioc_g_ctrl(struct file *file,
>> void *priv,
>>  	struct si470x_device *radio = video_drvdata(file);
>>  	int retval = 0;
>>
>> +#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
>>  	/* safety checks */
>>  	if (radio->disconnected) {
>>  		retval = -EIO;
>>  		goto done;
>>  	}
>> +#endif
> 
> I'm sorry for asking but is it possible to turn this into separate macro?
> Something like this for example:
> 
> /* comment about macro */
> #if defined (CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
> #define safety_check() if() {
> ... checks ...
> }
> #elseif
> #define safety_check()
> #endif
> 
> to run away from many #if defined-#endif constructions in source code.
> Is it really good to redesign this or am i wrong here?
> 

I think your example is better, i will try it.


<snip>

>> +static int __init si470x_i2c_init(void)
>> +{
>> +	return i2c_add_driver(&si470x_i2c_driver);
>> +}
>> +module_init(si470x_i2c_init);
>> +
>> +static void __exit si470x_i2c_exit(void)
>> +{
>> +	i2c_del_driver(&si470x_i2c_driver);
>> +}
>> +module_exit(si470x_i2c_exit);
>> +
>> +MODULE_DESCRIPTION("i2c radio driver for si470x fm radio receivers");
>> +MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
>> +MODULE_LICENSE("GPL");
> 
> Please, move this information to the top of file to see this
> information fast when you suddenly open source file.

I'm not sure about this because many linux drivers have the module
information at the bottom of file.
