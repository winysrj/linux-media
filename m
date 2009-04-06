Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:45051 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbZDFMlo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 08:41:44 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KHO00FY6J9HJ8V0@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 06 Apr 2009 08:41:41 -0400 (EDT)
Date: Mon, 06 Apr 2009 08:41:40 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: tm6010 development repository
In-reply-to: <49D9D0B4.5070702@yahoo.co.nz>
To: Kevin Wells <wells_kevin@yahoo.co.nz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Message-id: <49D9F884.5090008@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <49D32574.1060908@yahoo.co.nz> <49D4CDBA.9060802@linuxtv.org>
 <49D7FF44.8010705@yahoo.co.nz> <20090405084731.4d67781b@pedra.chehab.org>
 <49D9D0B4.5070702@yahoo.co.nz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin Wells wrote:
> Mauro Carvalho Chehab wrote:
>> On Sun, 05 Apr 2009 12:45:56 +1200
>> Kevin Wells <wells_kevin@yahoo.co.nz> wrote:
>>  
>>> Steven Toth wrote:
>>>    
>>>> Kevin Wells wrote:
>>>>      
>>>>> I've started trying to understand the code in the following 
>>>>> repository:
>>>>>
>>>>>     http://www.linuxtv.org/hg/~mchehab/tm6010/
>>>>>
>>>>> I have a few patches I would like to apply. How should I do this?
>>>>>         
>>>> Submit the patches to the list and I'll try to get some time to 
>>>> create and maintain a ~stoth/tm6010 tree. I think I can get the 
>>>> nova-s-usb2 running with just a little effort.
>>>>       
>>> Patches to follow. Nothing exciting. Just trying to make the code 
>>> more robust. Patches are very granular. Let me know if that doesn't 
>>> work for you.
>>>     
>> I'll merge those with some patches I have here. hvr-900h analog part 
>> is working
>> with a some troubles on the experimental tree I have here. A good 
>> thing to do,
>> after I merge yours and my patches, is to convert it to the new v4l2 
>> dev/subdev
>> interface. I suspect that this will solve several bugs we currently 
>> have with
>> the i2c interface of this driver.
>>
>> I intend to do this later this week, after the end of the merge 
>> window. For
>> now, I still have lots of patches to review, in order to submit for 
>> 2.6.30.
>>   
> Thanks Mauro.

Thanks Kevin.

Mauro,

Let me know when you've done this and I'll clone your tree and look at the 
nova-s-usb2 issues.

Thanks,

- Steve
