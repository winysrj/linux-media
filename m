Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.leissner.se ([212.3.1.210]:12949 "EHLO
	mailgate.leissner.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbbGENpA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2015 09:45:00 -0400
Date: Sun, 5 Jul 2015 15:44:50 +0200 (SST)
From: Peter Fassberg <pf@leissner.se>
To: Andy Furniss <adf.lists@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
In-Reply-To: <55991C3D.4020305@gmail.com>
Message-ID: <alpine.BSF.2.20.1507051542470.72900@nic-i.leissner.se>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se> <5598FDDC.7020804@gmail.com> <alpine.BSF.2.20.1507051323270.71755@nic-i.leissner.se> <55991C3D.4020305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Peter Fassberg wrote:
>> 
>>>> I'm trying to get PCTV TripleStick 292e working in a Raspberry Pi
>>>> B+ environment.
>>>> 
>>>> I have no problem getting DVB-T to work, but I can't tune to any
>>>> DVB-T2 channels. I have tried with three different kernels:
>>>> 3.18.11, 3.18.16 and 4.0.6.  Same problem.  I also cloned the
>>>> media_build under 4.0.6 to no avail.
>>>> 
>>>> The same physical stick works perfectly with DVB-T2 in an Intel
>>>> platform using kernel 3.16.0.
>>>> 
>>>> Do you have any suggestions what I can do to get this running or
>>>> is there a known problem with Raspberry/ARM?
>>> 
>>> What are you trying to tune with?
>> 
>> I'm using dvbv5-scan.
>> 
>> I use the same program on the system that works.
>> 
>> The output for a DVB-T mux: Lock   (0x1f) Signal= -42.00dBm C/N=
>> 20.25dB
>> 
>> And a DVB-T2: Carrier(0x03) Signal= -35.00dBm
>> 
>> There is a difference between Raspberry/ARM and Intel that I don't
>> understand.
>
> Hmm, not sure then - maybe try md5sum on the firmware that dmesg shows
> loading on each then if different backup/copy over etc.
>
> I am just a user so don't know what's different between 3.16 and later.
>
> One thing I noticed at one point when setting mine up was (after
> unknowingly breaking a splitter) that with the degraded splitter I could
> get working/not on some T2 muxed by flipping the lna on off with the
> option available with dvbv5-*.

Yes, I also tested that.  The firmware is identical and the LNA as well.

It do work 100% of the times I scan on the Intel platform.



// Peter

