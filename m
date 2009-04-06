Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfilter11.ihug.co.nz ([203.109.136.11]:22763 "EHLO
	mailfilter11.ihug.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759038AbZDFJun (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 05:50:43 -0400
Message-ID: <49D9D0B4.5070702@yahoo.co.nz>
Date: Mon, 06 Apr 2009 21:51:48 +1200
From: Kevin Wells <wells_kevin@yahoo.co.nz>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org
Subject: Re: tm6010 development repository
References: <49D32574.1060908@yahoo.co.nz>	<49D4CDBA.9060802@linuxtv.org>	<49D7FF44.8010705@yahoo.co.nz> <20090405084731.4d67781b@pedra.chehab.org>
In-Reply-To: <20090405084731.4d67781b@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> On Sun, 05 Apr 2009 12:45:56 +1200
> Kevin Wells <wells_kevin@yahoo.co.nz> wrote:
>   
>> Steven Toth wrote:
>>     
>>> Kevin Wells wrote:
>>>       
>>>> I've started trying to understand the code in the following repository:
>>>>
>>>>     http://www.linuxtv.org/hg/~mchehab/tm6010/
>>>>
>>>> I have a few patches I would like to apply. How should I do this?
>>>>         
>>> Submit the patches to the list and I'll try to get some time to create 
>>> and maintain a ~stoth/tm6010 tree. I think I can get the nova-s-usb2 
>>> running with just a little effort.
>>>       
>> Patches to follow. Nothing exciting. Just trying to make the code more 
>> robust. Patches are very granular. Let me know if that doesn't work for you.
>>     
> I'll merge those with some patches I have here. hvr-900h analog part is working
> with a some troubles on the experimental tree I have here. A good thing to do,
> after I merge yours and my patches, is to convert it to the new v4l2 dev/subdev
> interface. I suspect that this will solve several bugs we currently have with
> the i2c interface of this driver.
>
> I intend to do this later this week, after the end of the merge window. For
> now, I still have lots of patches to review, in order to submit for 2.6.30.
>   
Thanks Mauro.
