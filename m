Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KMv9D-0004a4-DE
	for linux-dvb@linuxtv.org; Sun, 27 Jul 2008 03:34:08 +0200
Message-ID: <488BD07B.1030403@linuxtv.org>
Date: Sat, 26 Jul 2008 21:33:47 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Yusik Kim <yusikk@gmail.com>
References: <200807260353.23359.yusikk@gmail.com>	<200807261130.39977.yusikk@gmail.com>	<Pine.LNX.4.64.0807261538040.28819@cnc.isely.net>
	<200807261725.51913.yusikk@gmail.com>
In-Reply-To: <200807261725.51913.yusikk@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1950 digital part
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

Yusik Kim wrote:
> On Saturday 26 July 2008 13:40:36 Mike Isely wrote:
>> On Sat, 26 Jul 2008, Yusik Kim wrote:
>>> On Saturday 26 July 2008 08:39:16 Steven Toth wrote:
>>>> Yusik Kim wrote:
>>>>> Hi,
>>>>>
>>>>> Has anyone got the digital part of this device to work properly?
>>>>>
>>>>> Modules are compiled from the latest (7/26) v4l-dvb snapshot with a
>>>>> 2.6.25.4 kernel. The modules seem to load properly and the analog
>>>>> part works in mythtv. The digital part kind of works.
>>>>> The problems I can observe are:
>>>>> 1. Can only scan 3 digital channels using both the command line scan
>>>>> and mythtv. My other PCI TV card scans 36 of them.
>>>>> 2. Only occasionally locks in to a channel.
>>>>> 3. Takes 5 minutes to lock in to a channel when it actually does
>>>>> succeed.
>>>>>
>>>>> I saw from another mailing list that people were trying to get the
>>>>> remote control to work so I'm guessing the core of the device
>>>>> functions properly. If this is the current state of support, I'd be
>>>>> glad to help testing.
>>>> What steps did you take to prove your hardware is function properly, or
>>>> your digital cable feed is reliable?
>>>>
>>>> The drivers works for me, it sounds like you have an environmental
>>>> issue.
>>>>
>>>> - Steve
>>> Thank you for replying Steve.
>>> I have a windows partition on the same machine and it works perfectly
>>> there. So I don't think there is a problem with the cable feed or
>>> hardware itself.
>>>
>>> Not sure if it has any relevance but I noticed in windows, the red LED
>>> light in the front is always on whereas in linux, it only turns on right
>>> before it tries to lock in to a channel.
>> While I can't vouch for what the Windows driver is doing, the Linux
>> driver (pvrusb2) for this device deliberately only lights the LED when
>> actual streaming is being attempted.  Basically the LED becomes a "busy"
>> indicator.  It's a feature not a bug :-)
>>
>>> I should add that the 3 channels that were successfully scaned do not
>>> always get picked up in subsequent attempts. It seems like it has trouble
>>> tuning. At least it's good to know it's a problem on my end. Just have to
>>> find a way to fix it.
>> Sounds a lot like there's a significant tuning problem.  Unfortunately
>> I'm not seeing the issue here :-(
>>
>>   -Mike
> 
> Thanks Mike.
> Nobody else seems to have the same problem. What's driving me crazy is that I 
> have 2 laptops where I can test (c2d 1.06GHz/ Pentium-M 1.4GHz(backend 
> only);both Debian testing) and both have the exact same problem so it's most 
> likely not machine specific. It works on a windows partition of the c2d 
> machine so it's not hardware related nor is it because of a bad signal 
> source.  So the only thing that stands between me and all the other people 
> who are happily using it can be narrowed down to kernel options or the 
> distro.  Are there any known kernel options/modules that may interfere with 
> the tuning? 
> 
> Another interesting thing is that in mythtv-setup, I have no option to choose 
> ATSC. Only NTSC, NTSC-JP, SECAM, etc. but no ATSC. It doesn't even allow me 
> the option to manually create an ATSC channel. The only way I get an ATSC 
> channel is through active scan (which most of the time doesn't work). I can 
> select ATSC on my desktop with a pci capture card. I can't use the desktop to 
> test it because it's USB1.1.
> 
> It looks like a dead end for now. Thanks to everyone who tried to help.

To use ATSC in mythtv, set the device up as a DVB device, not a video4linux device.  You set up two devices, one video4linux for the analog encoding, the other "DVB" for ATSC.

I also suggest that you try adding a signal amplifier and see if that helps the reception.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
