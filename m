Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33623 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab2GGK1B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 06:27:01 -0400
Message-ID: <4FF80EEA.2050606@iki.fi>
Date: Sat, 07 Jul 2012 13:26:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: unload/unplugging (Re: success! (Re: media_build and Terratec
 Cinergy T Black.))
References: <1341655844.10317.YahooMailClassic@web29406.mail.ird.yahoo.com>
In-Reply-To: <1341655844.10317.YahooMailClassic@web29406.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2012 01:10 PM, Hin-Tak Leung wrote:
> --- On Sat, 7/7/12, Antti Palosaari <crope@iki.fi> wrote:
>
> <snipped>
>>> I also have quite a few :
>>>
>>> [224773.229293] DVB: adapter 0 frontend 0 frequency 2
>> out of range (174000000..862000000)
>>>
>>> This seems to come from running w_scan.
>>
>> yes, those warnings are coming when application request
>> illegal frequency. Setting frequency as a 2 Hz is something
>> totally wrong, wild guess, it is some other value set
>> accidentally as frequency.
>
> I am thinking either w_scan is doing something it should not, in which case we should inform its author to have this looked at, or the message does not need to be there?

As scandvb and all the other applications are able to set desired 
parameters without that error it must be w_scan issue.

And personally I don't care whole warning, returning some error code 
(which is likely -EINVAL) should be enough. It is not error situation in 
the mean of Kernel or device error - it is just user error as user tries 
to set unsupported frequency.

>>> The kernel seems happy while having the device
>> physically pulled out. But the kernel module does not like
>> to be unloaded (modprobe -r) while mplayer is running, so we
>> need to fix that.
>>
>> Yep, seems to refuse unload. I suspect it is refused since
>> there is ongoing USB transmission as it streams video. But
>> should we allow that? And is removing open device nodes OK
>> as applications holds those?
>
> I am thinking about suspend/resume, the poorman's way, which is to unload/reload. One interesting thing to try would be to pause but not quit the application - either just press pause, or say, 'gdb <mplayerbinary> <pid>', and see if 'modprobe -r' can be made to work under that sort of condition, if it isn't already.

hmm, what is that kind of suspend/resume?
Is that different what is now implemented?

regards
Antti

-- 
http://palosaari.fi/


