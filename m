Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.stud.uni-hannover.de ([130.75.176.3]:46147 "EHLO
	studserv5d.stud.uni-hannover.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759314AbZFKKqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 06:46:11 -0400
Message-ID: <20090611124444.17702c9ftt5igwsg@www.stud.uni-hannover.de>
Date: Thu, 11 Jun 2009 12:44:44 +0200
From: Soeren.Moch@stud.uni-hannover.de
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: linux-media@vger.kernel.org
Subject: Re: dib0700 Nova-TD-Stick problem
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick!

Patrick Boettcher wrote:
> Hi Soeren,
>>> For a few weeks I use a Nova-TD-Stick and was annoyed with dvb stream
>>> errors, although the demod bit-error-rate (BER/UNC) was zero.
>>>
>>> I could track down this problem to dib0700_streaming_ctrl:
>>> When one channel is streaming and the other channel is switched on, the
>>> stream of the already running channel gets broken.
>>>
>>> I think this is a firmware bug and should be fixed there, but I attach a
>>> driver patch, which solved the problem for me. (Kernel 2.6.29.1, FW
>>> 1.20, Nova-T-Stick + Nova-TD-Stick used together). Since I had to reduce
>>> the urb count to 1, I consider this patch as quick hack, not a real
>>> solution.
>>>
>>> Probably the same problem exists with other dib0700 diversity/dual
>>> devices, without a firmware fix a similar driver patch may be helpful.
>>>
>>> Regards,
>>> Soeren
>>>
>>
>> Hi Patrick,
>>
>> do you see any chance that somebody will fix the firmware?
>
> :/ .
>
>> If not, can you take into consideration to remove the
>> dib0700_streaming_ctrl callback as in the (again) attached patch so
>> solve the switch-on problem?
>
> I'd rather fix the streaming-enable command, which might be not
> correctly implemented. Need to check. :(

Since the dib0700_streaming_ctrl is more or less a firmware interface only,
I found nothing to patch there. I played with the enable bits but could not
find any working solution. But of course you know the driver code (and maybe
the firmware) better, and maybe somebody from dibcom can give any hint...

Since the streaming_control implementation within the dib0700 seemed to be
not fully usb compliant in the past (e.g. disconnect problem we have seen
a few month ago), it may be not the worst idea to remove this callback
entirely (after stream enable in the init phase). But I don't know for what
side effect the firmware uses this call...

>> The patch runs flawlessly on my vdr system for weeks now. There are no
>> negative side effects from reducing the urb count to 1.
>
> Hmm, on fast systems certainly not, but once the system is loaded or old
> there might be data losses.

My vdr system is based on a via epia board, so I use a C7 cpu (not known to
be the fastest at the market) and via usb controller. I can use one or both
of my dvb-t sticks (nova-t and nova-td) together at the same ehci controller,
I can record up to 3 dvb-t TS-streams simultaneously, I can use PIP decoding
to generate 100% cpu load (full-featured dvb card used for primary video
decode). I never observed any usb data loss with urb count set to 1 (the
fifo within the dib0700 (dib7000p?) seems to be big enough).
In contrast to that, without the patch it is impossible to watch TV on one
nova-td channel while vdr is constantly calling streaming_ctrl on/off for
epg scan on the other nova-td channel. _Without_ the patch I see data
loss/corruption.

> It would be nice to have other people trying this workaround on other
> cards so that we know that it really helps and not just solves the
> problem for you.
>
> Patrick.

Of course it would be nice to have other people testing this patch. So far
the urb count is reduced for all dib0700 devices while the streaming_ctrl
callback is removed for the stk7700d family of devices (nova-td and friends)
only.
I used this patch in 2.6.27.x and 2.6.29.x environments so far. I will try
to test 2.6.30 this weekend.
If anybody else can confirm that this patch works (or not), please send a
short report to the list.

Thanks,
S:oren


