Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35131 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbZKDLeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 06:34:13 -0500
Received: by bwz27 with SMTP id 27so8737543bwz.21
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2009 03:34:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AF162BC.4010700@stud.uni-hannover.de>
References: <4AEF5FE5.2000607@stud.uni-hannover.de>
	 <4AF162BC.4010700@stud.uni-hannover.de>
Date: Wed, 4 Nov 2009 12:34:15 +0100
Message-ID: <c4e36d110911040334v5ce95acas2efaa7a0b804ac5c@mail.gmail.com>
Subject: Re: [linux-dvb] NOVA-TD exeriences?
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Soeren Moch <Soeren.Moch@stud.uni-hannover.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/11/4 Soeren Moch <Soeren.Moch@stud.uni-hannover.de>:
> Zdenek Kabelac wrote:
>> 2009/11/3 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>>> 2009/11/2 Soeren Moch <Soeren.Moch@stud.uni-hannover.de>:
>>>>>> Hi. I would be happy to hear if anyone has tried both the NOVA-TD and
>>>>>> the
>>>>>> NOVA-T. The NOVA-T has always worked perfectly here but I would like
>>>>>> to
>>>>>> know
>>>>>> if the -TD will do the job of two NOVA-T's. And there also seems to be
>>>>>> a
>>>>>> new
>>>>>> version out with two small antenna connectors instead of the previous
>>>>>> configuration. Anyone tried it? Does it come with an antenna adaptor
>>>>>> cable?
>>>>>> http://www.hauppauge.de/de/pics/novatdstick_top.jpg
>>>>>> Thankful for any info.
>>>>> Well I've this usb stick with these two small connectors - and it runs
>>>>> just fine.
>>>>>
>>>>> Though I think there is some problem with suspend/resume recently
>>>>> (2.6.32-rc5)  and it needs some inspection.
>>>>>
>>>>> But it works just fine for dual dvb-t viewing.
>>>>>
>>>>> And yes - it contains two small antennas with small connectors and
>>>>> one adapter for normal antenna - i.e. 1 antenna input goes to 2 small
>>>>> antenna connectors.
>>>> zdenek, your nova-td stick works just fine for dual dvb-t viewing?
>>>> I always had this problem:
>>>> When one channel is streaming and the other channel is switched on, the
>>>> stream of the already running channel gets broken.
>>>> see also:
>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg06376.html
>>>>
>>>> Can you please test this case on your nova-td stick?
>>> I'll recheck in the evening whether there are no regression, but I've
>>> been able to get 3 dvb-t independent (different mux) TV streams (with
>>> the usage of the second stick Aver Hybrid Volar HX & proprietary Aver
>>> driver) with 2.6.29/30 vanilla kernels played at the same time on my
>>> C2D T61.
>>>
>>
>>
>> Ok - I could confirm, I'm able to play two different muxes at the same
>> time from this USB stick. And I do not experience any stream damage.
>> I'm running Fedora Rawhide with vanilla kernel 2.6.32-rc5, kaffeine
>> 0.8.7 for the first adapter and relatively fresh mplayer compilation
>> for the second adapter
>>
>> Thought there are things to be reported and fixed (some USB regression
>> I guess) - I'll handle this via lkml.
>>
>>
>> Anyway here is dmesg USB stick identification (labeled  WinTV  Nova-TD)
>>
>> USB device found, idVendor=2040, idProduct=5200
>> USB device strings: Mfr=1, Product=2, SerialNumber=3
>> Product: NovaT 500Stick
>>
>> Regards
>>
>> Zdenek
>>
>
> Very strange. Playing of two different muxes is also no problem for me, as
> long
> as no new stream is started (of course after switching off one of the
> streams
> before). In the start moment of the new the stream the already running
> stream
> is disturbed and I see a demaged group of pictures in the old stream. After
> these few pictures the stream is running fine again.
>
> I cannot imagine that this is a specific problem of my stick, however,
> thank you for testing!


Hmm - well I haven't made a close inspection (frame by frame) of every
frame during the startup of second player.
Kaffaine seems to have blocked screen refresh because Xorg gets locked
via starting mplayer.
So there is definitely frame skipping viewing experience - but that's
the flaw of Xorg - sound is played just fine.

If I should check whether there are no TS stream errors only at the
moment of startup, I'll need to grab both streams and make a better
analysis.  My current statement was purely based on the fact, that I
could watch both channels without any picture artefacts or sound
distorsion - but during startup there is surelly a period, when some
frames are not even visibile, because kaffeine cannot even refresh
playing window - but that's another story....


Zdenek
