Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay03.pair.com ([209.68.5.17]:1394 "HELO relay03.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751266AbZEYBEZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 21:04:25 -0400
Message-ID: <4A19EE93.3020200@papercut.com>
Date: Mon, 25 May 2009 11:04:19 +1000
From: Matt Doran <matt.doran@papercut.com>
MIME-Version: 1.0
To: David Ward <david.ward@gatech.edu>
CC: linux-media@vger.kernel.org
Subject: Re: videodev: Unknown symbol i2c_unregister_device (in kernels older
 than 2.6.26)
References: <4A19D3D9.9010800@papercut.com> <4A19EBDE.4080602@gatech.edu>
In-Reply-To: <4A19EBDE.4080602@gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Ward wrote:
> On 05/24/2009 07:10 PM, Matt Doran wrote:
>> Hi there,
>>
>> I tried using the latest v4l code on an Mythtv box running 2.6.20, but
>> the v4l videodev module fails to load with the following warnings:
>>
>>    videodev: Unknown symbol i2c_unregister_device
>>    v4l2_common: Unknown symbol v4l2_device_register_subdev
>>
>
> Matt, I checked out v4l-dvb today and am using it under 2.6.24 and so 
> far so good.  When did the error appear -- when you were trying to 
> load the module?
The error appeared when trying to load the module at boot time for my 
saa7134 based tuner card.   This card would no longer work after 
installing the latest v4l code, however another tuner card continued to 
work.    Maybe because this the saa7134 card is an I2C based card and 
the other is USB based?? (but this is all a bit over my head).

I basically just commented out the "i2c_unregister_device" function in 
v4l2-device.c, recompiled and everything started working. :)    I don't 
know the implication of removing this, so I didn't submit a patch ... I 
thought I'd leave that to the experts.
>
> I have been seeing the errors compiling adv7343.c and ths7303.c under 
> 2.6.24 as well.  Andy Walls and Chaithrika Subrahmanya had written 
> patches for those two modules respectively, but there were some 
> comments during the review of the patches, so I think they are still 
> being worked on.
Great, thanks for letting me know.   It's not a showstopper, but it's a 
pain repeatedly going through the reconfigure/compile/error loop each 
time you encounter a new compiler error. :)    I'm just not game to 
upgrade the kernel on my mythtv box ... it took a long time to get 
stable, and I don't want to go there again. :P    I'm recompiling v4l 
because I added a new tuner card.

Matt
