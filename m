Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:1332 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0E3Pdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 11:33:53 -0400
Message-ID: <4C0281C1.70506@linuxtv.org>
Date: Sun, 30 May 2010 11:18:25 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: VDR User <user.vdr@gmail.com>,
	Mike Booth <mike_booth76@iprimus.com.au>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: What ever happened to standardizing signal level?
References: <AANLkTinPCgrLPdtFgEDa76RnEG85GSLVJv0G6z56z3P1@mail.gmail.com> <201005291909.36973.mike_booth76@iprimus.com.au> <AANLkTilbus32dL3I_gkY3PBjHuhptaWQpn6ptjBscANL@mail.gmail.com> <201005300923.35376.hverkuil@xs4all.nl>
In-Reply-To: <201005300923.35376.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Sunday 30 May 2010 09:07:46 VDR User wrote:
>> On Sat, May 29, 2010 at 2:09 AM, Mike Booth <mike_booth76@iprimus.com.au> wrote:
>>> i think someone is too concerned about being precisely accurate. So much so
>>> that no-one can see the woods for the trees any more.
>>>
>>> Its not important to me that accuracy is spot on. I only want to know that
>>> when tuning the dish I'm getting \better or worse.
>> I tend to agree with this.  Ultimately what's important is not
>> necessarily that the readings are 100% accurate, but rather simply put
>> into some kind of universal scale that provides useful output to the
>> user.  Many users were happy to see some activity addressing this
>> issue and unfortunately it seems to have stalled out but I'm not sure
>> why.  I honestly felt there was enough common ground being discussed
>> that we'd have a solution by now.
> 
> To the best of my knowledge Mike Krufky intended to work on this but he
> clearly no longer has time to do that work.
> 
> Mike, can you perhaps explain what you wanted to do? Hopefully someone else
> can find the time to implement it.
> 
> Regards,
> 
> 	Hans
> 


..."clearly no longer has time" -- please do not speak on my behalf -- I 
have taken a break from v4l-dvb, and I will return when I have time for 
it again.

I already did a lot of the work for standardizing signal level, but I 
need to clean it up, consider new demod modules, push trees and send 
pull requests.  Right now, correct -- I don't have time for it.  I'll 
likely get to this by mid-august -- I will have more time again by then.

I have a plethora of changes in my queue that I have to burn through and 
merge, including j-rod's lgdt3304 support.  I used to get this stuff 
done very quickly, but there is a lot of change going on in my life 
right now... When things settle down here, I'll be back in full force.  :-)

Regards,

Mike Krufky

Regards,

Mike
