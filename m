Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab0ELW0T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 18:26:19 -0400
Message-ID: <4BEB2A68.3050801@redhat.com>
Date: Wed, 12 May 2010 18:23:36 -0400
From: Prarit Bhargava <prarit@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] checkstack fixes for drivers/media/dvb
References: <20100512185311.20801.86954.sendpatchset@prarit.bos.redhat.com> <4BEB11E5.8090504@infradead.org>
In-Reply-To: <4BEB11E5.8090504@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/12/2010 04:39 PM, Mauro Carvalho Chehab wrote:
> Prarit Bhargava wrote:
>    
>> When compiling 2.6.34-rc7 I see the following warnings
>>
>> drivers/media/dvb/frontends/dib3000mc.c: In function 'dib3000mc_i2c_enumeration':
>> drivers/media/dvb/frontends/dib3000mc.c:853: warning: the frame size of 2224 bytes is larger than 2048 bytes
>> drivers/media/dvb/frontends/dib7000p.c: In function 'dib7000p_i2c_enumeration':
>> drivers/media/dvb/frontends/dib7000p.c:1346: warning: the frame size of 2304 bytes is larger than 2048 bytes
>>
>> because the dib*_state structs are large and they are alloc'd on the stack.
>>
>> This patch moves the structures off the stack.
>>      
> Hi Prarit,
>
> Thanks for the patch, but I've received two patches to fix the same thing some time ago.
> Unfortunately, it took a long time to be merged, since I was waiting for the driver
> maintainer's ack. It is at those changesets:
>
> http://git.linuxtv.org/v4l-dvb.git?a=commit;h=65483f7e5f3e169ea038de26068395231dd3b13b
> http://git.linuxtv.org/v4l-dvb.git?a=commit;h=370c0cb185d4fccfb2c66fbe94b48579d4c5fa1c
>
>    

Oops!  Sorry about that Mauro :( -- I didn't realize there was another 
git tree to check.  Just curious -- is the one listed in MAINTAINERS 
still active?

>> I also noticed that the cxusb driver doesn't check the return value from
>> dib7000p_i2c_enumeration().
>>      
> Randy's patch also added a test for it, but without the warning printk. It may be a good
> idea to have that warning. So, please be free to send it as a separate patch if you also
> think so.
>    
>

Sure I'll do that shortly (after checking out the above tree ;) ).

P.
