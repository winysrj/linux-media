Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Ke9Ee-0006xK-En
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 16:02:58 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7300INH5NCYT80@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 12 Sep 2008 10:02:01 -0400 (EDT)
Date: Fri, 12 Sep 2008 10:02:00 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080912074513.GB3216@gmail.com>
To: Gregoire Favre <gregoire.favre@gmail.com>
Message-id: <48CA7658.200@linuxtv.org>
MIME-version: 1.0
References: <48C70F88.4050701@linuxtv.org>
	<200809112024.24821.liplianin@tut.by>
	<20080911200931.GA25626@gmail.com>
	<200809120030.55445.liplianin@tut.by> <20080912051056.GA3216@gmail.com>
	<web-53239698@speedy.tutby.com> <20080912074513.GB3216@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API simple szap-s2 utility
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Gregoire Favre wrote:
> On Fri, Sep 12, 2008 at 09:30:04AM +0300, "?????? ????? <liplianin@tut.by>"@vdr.localdomain wrote:
> 
>> mplayer, kaffeine, xine works with properly filled channels.conf
>>
>>   mplayer dvb://channelname
>>
>> Or you may try:
>> In one console
>>   szap-s2 channelname -r
>>
>> In another
>>   mplayer - < /dev/dvb/adaptero/dvr0
>>
> 
> Thank you very much, I missed the -r yesterday :-)
> 
> Unfortunetely today I can't tune to anything, I always got this error : 
> FE_SET_PROPERTY failed: Operation not permitted
> 
> Directly with mplayer, I only get sofar :
> 
> mplayer dvb://1@ZDF
> MPlayer dev-SVN-r27546 (C) 2000-2008 MPlayer Team
> CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz (Family: 6, Model:
> 15, Stepping: 6)
> CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
> Compiled for x86 CPU with extensions: MMX MMX2 SSE SSE2
> 
> Playing dvb://1@ZDF.
> dvb_tune Freq: 11954000
> TS file format detected.
> 
> Thanks.

The S2API is changing rapidly. Over the last few days the API has been 
refined and the message are being changed / finalized. It's actually 
close to to it's final shape after last nights patches. I probably still 
have a few bugs too! :)

Igor is doing a great job with szap-2 but he's also not quite up to date 
with the current tree, the interfaces on szap-s2 will not match the 
current s2api tree). Let's make sure Igor has caught up with last nights 
changes before you try satellite tuning again.

Recap: The latest version of tune.c (currently 0.0.5 at 
steventoth.net/linux/s2) is the most up to date and contains example 
code for how to tune the API. Igor is taking this code and patching the 
changes into szap-s2 on a regular basis.

As today progresses I'll be collecting feedback on todays patches, if we 
have new bugs then expect more patches and fixes this evening.

Thanks for helping test Gregoire!

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
