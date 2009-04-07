Return-path: <linux-media-owner@vger.kernel.org>
Received: from imsantv37.netvigator.com ([210.87.247.8]:45738 "EHLO
	imsantv37.netvigator.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbZDGBeX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 21:34:23 -0400
Received: from imsantv49.netvigator.com (imsantv37 [127.0.0.1])
	by imsantv37.netvigator.com (8.14.2/8.14.2) with ESMTP id n370s88w008136
	for <linux-media@vger.kernel.org>; Tue, 7 Apr 2009 08:54:11 +0800
Message-ID: <49DAA42C.8070302@siriushk.com>
Date: Tue, 07 Apr 2009 08:54:04 +0800
From: Timothy Lee <timothy.lee@siriushk.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Devin Heitmueller <devin.heitmueller@gmail.com>,
	David Wong <davidtlwong@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Support for Legend Silicon LGS8913/LGS8GL5/LGS8GXX China
  DMB-TH digital demodulator
References: <15ed362e0903170855k2ec1e5afm613de692c237e34d@mail.gmail.com>	<412bdbff0903302154w5ddb3fc8m684bcb5092942561@mail.gmail.com> <20090406144408.63b2ef71@pedra.chehab.org>
In-Reply-To: <20090406144408.63b2ef71@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro,

I wrote the original lgs8gl5 driver by reverse-engineering my USB TV 
stick using UsbSnoop.

I've been working together with David to make sure his lgs8gxx driver 
works with my TV stick, so yes, the generic driver actually works.  :)

Regards,
Timothy Lee

On 04/07/2009 01:44 AM, Mauro Carvalho Chehab wrote:
> On Tue, 31 Mar 2009 00:54:49 -0400
> Devin Heitmueller<devin.heitmueller@gmail.com>  wrote:
>
>    
>> On Tue, Mar 17, 2009 at 11:55 AM, David Wong<davidtlwong@gmail.com>  wrote:
>>      
>>> This patch contains the unified driver for Legend Silicon LGS8913 and
>>> LGS8GL5. It should replace lgs8gl5.c in media/dvb/frontends
>>>
>>> David T.L. Wong
>>>        
>> David,
>>
>> The questions you posed tonight on a separate thread about making the
>> xc5000 work with this device prompts the question:
>>
>> Do you know that this driver you submitted actually works?  Have you
>> successfully achieved lock with this driver and been able to view the
>> stream?
>>
>> It is great to see the improvements and more generic support, but if
>> you don't have it working in at least one device, then it probably
>> shouldn't be submitted upstream yet, and it definitely should not be
>> replacing an existing driver.
>>      
> We need to do some tests before replacing the existing one. Yet, it is better
> to have a generic device than specific ones. Do you have any card with lg8gl5?
> If so, could you please test the new driver for us?
>
> Anyway, I'm applying what we currently have.
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

