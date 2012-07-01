Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51726 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab2GALMH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jul 2012 07:12:07 -0400
Message-ID: <4FF0307E.50408@iki.fi>
Date: Sun, 01 Jul 2012 14:11:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	htl10@users.sourceforge.net
Subject: Re: DVB core enhancements - comments please?
References: <4FEBA656.7060608@iki.fi> <4FEECA65.9090205@kolumbus.fi>
In-Reply-To: <4FEECA65.9090205@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Marko,

On 06/30/2012 12:44 PM, Marko Ristola wrote:
> My suspend / resume patch implemented "Kaffeine continues viewing
> channel after resume".
> Some of the ideas could be still useful:
> http://www.spinics.net/lists/linux-dvb/msg19651.html
>
> Rest of this email has a more thorough description.
>
> Regards,
> Marko Ristola
>
> On 06/28/2012 03:33 AM, Antti Palosaari wrote:
>> Here is my list of needed DVB core related changes. Feel free to
>> comment - what are not needed or what you would like to see instead. I
>> will try to implement what I can (and what I like most interesting :).
>>
> ...
>> suspend / resume support
>> --------------------------------------------------
>> * support is currently quite missing, all what is done is on interface
>> drivers
>> * needs power management
>> * streaming makes it hard
>> * quite a lot work to get it working in case of straming is ongoing
>
>
> I've implemented Suspend/Resume for Mantis cu1216 in 2007 (PCI DVB-C
> device):
> Kaffeine continued viewing the channel after resume.
> When Tuner was idle too long, it was powered off too.
>
> According to Manu Abraham at that time, somewhat smaller patch would
> have sufficed.
> That patch contais nonrelated fixes too, and won't compile now.
>
> Here is the reference (with Manu's answer):
> Start of the thread: http://www.spinics.net/lists/linux-dvb/msg19532.html
> The patch: http://www.spinics.net/lists/linux-dvb/msg19651.html
> Manu's answer: http://www.spinics.net/lists/linux-dvb/msg19668.html
>
> Thoughts about up-to-date implementation
> - Bridge (PCI) device must implement suspend/resume callbacks.

That is very likely very clear as without those callbacks we cannot so 
anything. It is current situation and it is not working as stream is not 
stopped and driver refuses to unload. What user sees computer never goes 
suspend and freezes.

> - Frontend might need some change (power off / power on callbacks)?

Likely. The initial plan in my mind is to power off frontend in case 
suspend and power on in case of resume. On power off save current 
parameters and on resume re-tune using those old parameters.

> - "save Tuner / DMA transfer state to memory" might be addable to dvb_core.
> - Bridge device supporting suspend/resume needs to have a (non-regression)
>    fallback for (frontend) devices that don't have a full tested
> "Kaffeine works"
>    suspend/resume implementation yet.

Hmm, I did some initial suspend / resume changes for DVB USB when I 
rewrote it recently. On suspend, it just kills all ongoing urbs used for 
streaming. And on resume it resubmit those urbs in order to resume 
streaming. It just works as it doesn't hang computer anymore. What I 
tested applications continued to show same television channels on resume.

The problem for that solution is that it does not have any power 
management as power management is DVB-core responsibility. So it 
continues eating current because chips are not put sleep and due to that 
those DVB-core changes are required.

> - What changes encrypted channels need?

I think none?


regards
Antti

-- 
http://palosaari.fi/


