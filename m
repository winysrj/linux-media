Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay00.pair.com ([209.68.5.9]:1087 "HELO relay00.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752018AbZEZBmU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 21:42:20 -0400
Message-ID: <4A1B48FA.8010909@papercut.com>
Date: Tue, 26 May 2009 11:42:18 +1000
From: Matt Doran <matt.doran@papercut.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: David Ward <david.ward@gatech.edu>, linux-media@vger.kernel.org
Subject: Re: videodev: Unknown symbol i2c_unregister_device (in kernels older
 than 2.6.26)
References: <4A19D3D9.9010800@papercut.com>  <4A19EBDE.4080602@gatech.edu> <1243276377.3167.15.camel@palomino.walls.org>
In-Reply-To: <1243276377.3167.15.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sun, 2009-05-24 at 20:52 -0400, David Ward wrote:
>   
>> On 05/24/2009 07:10 PM, Matt Doran wrote:
>>     
>>> Hi there,
>>>
>>> I tried using the latest v4l code on an Mythtv box running 2.6.20, but
>>> the v4l videodev module fails to load with the following warnings:
>>>
>>>    videodev: Unknown symbol i2c_unregister_device
>>>    v4l2_common: Unknown symbol v4l2_device_register_subdev
>>>
>>>
>>> It seems the "i2c_unregister_device" function was added in 2.6.26.
>>> References to this function in v4l2-common.c are enclosed in an ifdef
>>> like:
>>>
>>>    #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
>>>
>>>
>>> However in "v4l2_device_unregister()" in v4l2-device.c, there is a
>>> reference to "i2c_unregister_device" without any ifdefs.   I am
>>> running a pretty old kernel, but I'd guess anyone running 2.6.25 or
>>> earlier will have this problem.   It seems this code was added by
>>> Mauro 3 weeks ago in this rev:
>>>
>>>    http://linuxtv.org/hg/v4l-dvb/rev/87afa7a4ccdf
>>>
>>>       
>> I have been seeing the errors compiling adv7343.c and ths7303.c under 
>> 2.6.24 as well.  Andy Walls and Chaithrika Subrahmanya had written 
>> patches for those two modules respectively, but there were some comments 
>> during the review of the patches, so I think they are still being worked on.
>>     
>
> Well, just to manage expectations: I am not working on this.  I do not
> advise waiting for something from me. ;)
>
>
> As an end user, you work-around is to use "make menuconfig" (or
> whatever) as Matt did: disable the modules that aren't compiling on
> older kernels.
>
>   
I agree, but the main problem I raise is the use of 
"i2c_unregister_device" in the main v4l module on Linux kernels that 
don't support it.

Regards,
Matt

