Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay00.pair.com ([209.68.5.9]:2204 "HELO relay00.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752717AbZFCLv5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2009 07:51:57 -0400
Message-ID: <4A2663DC.1050804@papercut.com>
Date: Wed, 03 Jun 2009 21:51:56 +1000
From: Matt Doran <matt.doran@papercut.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: videodev: Unknown symbol i2c_unregister_device (in kernels older
 than 2.6.26)
References: <4A19D3D9.9010800@papercut.com> <20090527154107.6b79a160@pedra.chehab.org>
In-Reply-To: <20090527154107.6b79a160@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em Mon, 25 May 2009 09:10:17 +1000
> Matt Doran <matt.doran@papercut.com> escreveu:
>
>   
>> Hi there,
>>
>> I tried using the latest v4l code on an Mythtv box running 2.6.20, but 
>> the v4l videodev module fails to load with the following warnings:
>>
>>     videodev: Unknown symbol i2c_unregister_device
>>     v4l2_common: Unknown symbol v4l2_device_register_subdev
>>
>>
>> It seems the "i2c_unregister_device" function was added in 2.6.26.   
>> References to this function in v4l2-common.c are enclosed in an ifdef like:
>>
>>     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
>>
>>
>> However in "v4l2_device_unregister()" in v4l2-device.c, there is a 
>> reference to "i2c_unregister_device" without any ifdefs.   I am running 
>> a pretty old kernel, but I'd guess anyone running 2.6.25 or earlier will 
>> have this problem.   It seems this code was added by Mauro 3 weeks ago 
>> in this rev:
>>
>>     http://linuxtv.org/hg/v4l-dvb/rev/87afa7a4ccdf
>>     
>
> I've just applied a patch at the tree that should fix this issue. It adds
> several tests and the code, but, hopefully, it should be possible even to use
> the IR's with kernels starting from 2.6.16.
>
>
>   
Thanks Mauro. 

I've recompiled all drivers without compile error and I've been using 
everything for a few days now and it all works great.

Thanks again!
Matt

