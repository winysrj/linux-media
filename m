Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:34882
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292AbZICUDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2009 16:03:42 -0400
Cc: Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	linux-media@vger.kernel.org,
	Brandon Jenkins <bcjenkins@tvwhere.com>
Message-Id: <30AAA297-A772-40B1-8C03-441CC6D3C5BC@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1251978607.22279.36.camel@morgan.walls.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH] hdpvr: i2c fixups for fully functional IR support
Date: Thu, 3 Sep 2009 16:02:12 -0400
References: <200909011019.35798.jarod@redhat.com> <1251855051.3926.34.camel@palomino.walls.org> <4A9DE5FE.8060409@wilsonet.com>  <4A9F38EE.7020104@wilsonet.com> <1251978607.22279.36.camel@morgan.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sep 3, 2009, at 7:50 AM, Andy Walls wrote:

>>>> I recall a problem Brandon Jenkins had from last year, that when  
>>>> I2C was
>>>> enabled in hdpvr, his machine with multiple HVR-1600s and an HD-PVR
>>>> would produce a kernel oops.
>>>>
>>>> Have you tested this on a machine with both an HVR-1600 and HD-PVR
>>>> installed?
>>>
>>> Hrm, no, haven't tested it with such a setup, don't have an  
>>> HVR-1600. I
>>> do have an HVR-1250 that I think might suffice for testing though,  
>>> if
>>> I'm thinking clearly.
>>
>> Hrm. A brief google search suggests the 1250 IR part isn't enabled. I
>> see a number of i2c devices in i2cdetect -l output, but none that say
>> anything about IR... I could just plug the hdpvr in there and see  
>> what
>> happens, I suppose...
>
> You should try that.  It was an issue of legacy I2C driver probing  
> that
> caused the hdpvr module to have problems.  The cx18 driver simply
> stimulated the i2c subsystem to do legacy probing (via the tuner  
> modules
> IIRC)?  See the email I sent you.

So from what I can tell, the i2c changes in 2.6.31 *should* prevent  
that from happening, and now that I've got everything working on  
2.6.31 too, I'll try hooking up my hdpvr to my box w/an hvr-1250,  
hvr-1800 and pchdtv hd-3000 in it and see what blows up (hopefully  
nothing...).

-- 
Jarod Wilson
jarod@wilsonet.com



