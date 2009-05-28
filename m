Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator5.ecc.gatech.edu ([130.207.185.175]:47337 "EHLO
	deliverator5.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbZE1Vnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 17:43:35 -0400
Message-ID: <4A1F0584.6040001@gatech.edu>
Date: Thu, 28 May 2009 17:43:32 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: linux-media@vger.kernel.org, Andy Walls <awalls@radix.net>
Subject: Re: "Unknown symbol __udivdi3" with rev >= 11873
References: <4A1E0DA7.6040702@gatech.edu> <37219a840905281212i6707a718t3b1e3c9b03d4ac3b@mail.gmail.com>
In-Reply-To: <37219a840905281212i6707a718t3b1e3c9b03d4ac3b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/28/2009 03:12 PM, Michael Krufky wrote:
> On Thu, May 28, 2009 at 12:05 AM, David Ward<david.ward@gatech.edu>  wrote:
>    
>> Revision 11873 (committed earlier today) has broken the cx18 driver for me,
>> with the line "cx18: Unknown symbol __udivdi3" appearing in dmesg when the
>> module tries to load.  I'm using Ubuntu 8.04.2 which uses kernel 2.6.24 and
>> gcc 4.2.4.
>>
>> I also wanted to express my appreciation to Mauro for fixing the build for
>> older kernels today, as it is very desirable for me to use a
>> distribution/kernel which has long-term support and updates, but I simply
>> need to add a DVB driver that wasn't part of the older kernel.
>>
>> Thanks so much.
>>
>> David Ward
>>      
> Let it be known that this issue only affects 32bit kernels.  I believe
> the offending line of code is here:
>
> fsc = ((((u64)sc) * 28636360)/src_decimation)>>  13L;
>
> (cc added to Andy Walls)
>
> -Mike Krufky
>    
Some Google searching seems to suggest that the correct thing to do here 
is to use the 'do_div' macro for the division, which is declared in 
<asm/div64.h>:

http://www.captain.at/howto-udivdi3-umoddi3.php

David
