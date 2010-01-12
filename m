Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f228.google.com ([209.85.217.228]:46450 "EHLO
	mail-gx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0ALB7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 20:59:16 -0500
Received: by gxk28 with SMTP id 28so15145295gxk.9
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2010 17:59:15 -0800 (PST)
Message-ID: <4B4BD5E8.7010101@gmail.com>
Date: Tue, 12 Jan 2010 09:52:40 +0800
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 00/11] add linux driver for chip TLG2300
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com>	<4B1FF5AB.30405@redhat.com> <20100111112405.0505c9df@pedra>
In-Reply-To: <20100111112405.0505c9df@pedra>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Em Wed, 09 Dec 2009 17:08:27 -0200
> Mauro Carvalho Chehab<mchehab@redhat.com>  escreveu:
>
>    
>> Huang Shijie wrote:
>>      
>>> The TLG2300 is a chip of Telegent System.
>>> It support analog tv,DVB-T and radio in a single chip.
>>> The chip has been used in several dongles, such as aeromax DH-9000:
>>> 	http://www.b2bdvb.com/dh-9000.htm
>>>
>>> You can get more info from:
>>> 	[1] http://www.telegent.com/
>>> 	[2] http://www.telegent.com/press/2009Sept14_CSI.html
>>>
>>> Huang Shijie (10):
>>>    add maitainers for tlg2300
>>>    add readme file for tlg2300
>>>    add Kconfig and Makefile for tlg2300
>>>    add header files for tlg2300
>>>    add the generic file
>>>    add video file for tlg2300
>>>    add vbi code for tlg2300
>>>    add audio support for tlg2300
>>>    add DVB-T support for tlg2300
>>>    add FM support for tlg2300
>>>
>>>        
>> Ok, finished reviewing it.
>>
>> Patches 01, 02 and 04 seems ok to me. You didn't sent a patch 03.
>> Patch 05 will likely need some changes (the headers) due to some reviews I did
>> on the other patches.
>>
>> The other patches need some adjustments, as commented on separate emails.
>>
>>      
> Hi Huang,
>
> Happy new year!
>
>    
Happy new year :)

> Had you finish fixing the pointed issues?
>
>    
My email system had a little problem, and losted some important emails.
I missed your email unfortunately. :(

I will do the change according your email as soon as possible.
I will sent out the new version when i finish it.
> Cheers,
> Mauro
>
>    
best regards
Huang Shijie

