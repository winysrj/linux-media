Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:42333
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZIDFBh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2009 01:01:37 -0400
Message-ID: <4AA0A021.6010203@wilsonet.com>
Date: Fri, 04 Sep 2009 01:05:37 -0400
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: Andy Walls <awalls@radix.net>, Jarod Wilson <jarod@redhat.com>,
	linux-media@vger.kernel.org,
	Brandon Jenkins <bcjenkins@tvwhere.com>
Subject: Re: [PATCH] hdpvr: i2c fixups for fully functional IR support
References: <200909011019.35798.jarod@redhat.com> <1251855051.3926.34.camel@palomino.walls.org> <4A9DE5FE.8060409@wilsonet.com> <4A9F38EE.7020104@wilsonet.com> <1251978607.22279.36.camel@morgan.walls.org> <30AAA297-A772-40B1-8C03-441CC6D3C5BC@wilsonet.com> <20090903213226.GF7962@aniel.lan>
In-Reply-To: <20090903213226.GF7962@aniel.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2009 05:32 PM, Janne Grunau wrote:
> On Thu, Sep 03, 2009 at 04:02:12PM -0400, Jarod Wilson wrote:
>> On Sep 3, 2009, at 7:50 AM, Andy Walls wrote:
>>
>>>> Hrm. A brief google search suggests the 1250 IR part isn't enabled. I
>>>> see a number of i2c devices in i2cdetect -l output, but none that say
>>>> anything about IR... I could just plug the hdpvr in there and see
>>>> what
>>>> happens, I suppose...
>>>
>>> You should try that.  It was an issue of legacy I2C driver probing
>>> that
>>> caused the hdpvr module to have problems.  The cx18 driver simply
>>> stimulated the i2c subsystem to do legacy probing (via the tuner
>>> modules
>>> IIRC)?  See the email I sent you.
>>
>> So from what I can tell, the i2c changes in 2.6.31 *should* prevent
>> that from happening, and now that I've got everything working on
>> 2.6.31 too, I'll try hooking up my hdpvr to my box w/an hvr-1250,
>> hvr-1800 and pchdtv hd-3000 in it and see what blows up (hopefully
>> nothing...).
>
> We still need something to prevent it from happening with older kernels.
> Easiest solution would be to disable it for 2.6.30 and earlier.

So I just tried a few permutations of hooking it up to the previously 
mentioned box, running a 2.6.29.6 kernel. No oops hooking the hdpvr up 
after everything else is already up, and no problems booting the system 
w/the hdpvr already connected (in which case it was the first device set 
up). One i2c adapter exposed by the hd-3000, three each by the hvr-1800 
and the hvr-1250, and the one on the hdpvr.

So perhaps we're okay, but I couldn't say for certain if its okay in 
combination with the hvr-1600 (i.e. Brandon's setup). Maybe skip 
enabling the i2c bits by default on kernels prior to 2.6.31, but add a 
modparam to let people enable them if they want to try it out?

-- 
Jarod Wilson
jarod@wilsonet.com
