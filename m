Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:2231 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZA1CpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 21:45:14 -0500
Message-ID: <497FC6AD.5020609@linuxtv.org>
Date: Tue, 27 Jan 2009 21:45:01 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Christoph Pfister <christophpfister@gmail.com>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dallas Texas ATSC scan file
References: <COL108-W41AFFE7632E1F6055B53F8D9CC0@phx.gbl> <19a3b7a80901270915k21729403w1f2f9be019ae9112@mail.gmail.com>
In-Reply-To: <19a3b7a80901270915k21729403w1f2f9be019ae9112@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is just a small subset of the available frequencies where we may 
find ATSC services.

Although this may be helpful for people scanning in Dallas, TX today, it 
will cause problems when the services move to other frequencies.  This 
will only scan a very limited range of frequencies, so naturally, it 
will be much quicker, but you might miss some services.

Users should use the file, "us-ATSC-center-frequencies-8VSB" , which 
contains all of the frequencies below, along with the full frequency 
table for ATSC, from channels 2 through 69.

I wouldn't commit this file, for the same very reason that I deleted the 
TWCNYC file.

Regards,

Mike

Christoph Pfister wrote:
> Mike,
>
> Can I have your $0.02, please?
>
> Thanks,
>
> Christoph
>
> 2009/1/24 Jorge Canas <jcanas2000@hotmail.com>:
>   
>> # DALLAS TX ATSC center frequencies, use if in doubt
>>
>> A 189028615 8VSB
>> A 473028615 8VSB
>> A 497028615 8VSB
>> A 503028615 8VSB
>> A 533028615 8VSB
>> A 569028615 8VSB
>> A 581028615 8VSB
>> A 599028615 8VSB
>> A 605028615 8VSB
>> A 629028615 8VSB
>> A 635028615 8VSB
>> A 641028615 8VSB
>> A 659028615 8VSB
>> A 665028615 8VSB
>> A 677028615 8VSB
>> A 695028615 8VSB
>>     

