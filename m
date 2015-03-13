Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.techmunk.com ([209.141.61.243]:46482 "EHLO
	mail.techmunk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbbCMKoF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 06:44:05 -0400
Message-ID: <5502BF58.7050100@techmunk.com>
Date: Fri, 13 Mar 2015 20:43:36 +1000
From: Christian Dale <kernel@techmunk.com>
Reply-To: Christian Dale <kernel@techmunk.com>
MIME-Version: 1.0
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rtl28xxu: add [0413:6f12] WinFast DTV2000 DS
 Plus
References: <1425878341-3037-1-git-send-email-kernel@techmunk.com> <20150313100731.GA66976@shambles.windy>
In-Reply-To: <20150313100731.GA66976@shambles.windy>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm currently running on ArchLinux
[    0.000000] Linux version 3.18.6-1-ARCH (cdale@huntsman) (gcc version 
4.9.2 20150204 (prerelease) (GCC) ) #2 SMP PREEMPT Sun Mar 8 10:00:24 
AEST 2015

On boot the card is detected by the kernel:

[   13.575736] usb 5-1: dvb_usb_v2: found a 'Leadtek WinFast DTV2000DS 
Plus' in warm state
[   13.625489] usb 5-1: dvb_usb_v2: will pass the complete MPEG2 
transport stream to the software demuxer
[   13.625495] DVB: registering new adapter (Leadtek WinFast DTV2000DS Plus)
[   13.625630] i2c i2c-9: Added multiplexed i2c bus 10
[   13.628355] i2c i2c-9: Added multiplexed i2c bus 11
[   13.628357] usb 5-1: DVB: registering adapter 0 frontend 0 (Realtek 
RTL2832 (DVB-T))...
[   13.636492] fc0013: Fitipower FC0013 successfully attached.
[   13.639454] media: Linux media interface: v0.10
[   13.642166] Linux video capture interface: v2.00
[   13.645296] usb 5-1: Registered as swradio0
[   13.645298] i2c i2c-9: rtl2832_sdr: Realtek RTL2832 SDR attached
[   13.645299] usb 5-1: rtl2832_sdr: SDR API is still slightly 
experimental and functionality changes may follow
[   13.680959] Registered IR keymap rc-leadtek-y04g0051
[   13.681023] input: Leadtek WinFast DTV2000DS Plus as 
/devices/pci0000:00/0000:00:1c.5/0000:05:00.0/0000:06:01.2/usb5/5-1/rc/rc0/input18
[   13.681110] rc0: Leadtek WinFast DTV2000DS Plus as 
/devices/pci0000:00/0000:00:1c.5/0000:05:00.0/0000:06:01.2/usb5/5-1/rc/rc0
[   13.681943] IR RC5(x/sz) protocol handler initialized
[   13.681951] IR NEC protocol handler initialized
[   13.682226] IR RC6 protocol handler initialized
[   13.682869] IR Sony protocol handler initialized
[   13.682976] IR JVC protocol handler initialized
[   13.683088] IR SANYO protocol handler initialized
[   13.683643] IR Sharp protocol handler initialized
[   13.684296] usb 5-1: dvb_usb_v2: schedule remote query interval to 
400 msecs
[   13.684415] lirc_dev: IR Remote Control driver registered, major 246
[   13.684492] IR XMP protocol handler initialized
[   13.684688] input: MCE IR Keyboard/Mouse (dvb_usb_rtl28xxu) as 
/devices/virtual/input/input19
[   13.684996] IR MCE Keyboard/mouse protocol handler initialized
[   13.685031] rc rc0: lirc_dev: driver ir-lirc-codec (dvb_usb_rtl28xxu) 
registered at minor = 0
[   13.685033] IR LIRC bridge handler initialized
[   13.700080] usb 5-1: dvb_usb_v2: 'Leadtek WinFast DTV2000DS Plus' 
successfully initialized and connected
[   13.700095] usb 5-2: dvb_usb_v2: found a 'Leadtek WinFast DTV2000DS 
Plus' in warm state
[   13.741247] usb 5-2: dvb_usb_v2: will pass the complete MPEG2 
transport stream to the software demuxer
[   13.741253] DVB: registering new adapter (Leadtek WinFast DTV2000DS Plus)
[   13.741474] i2c i2c-12: Added multiplexed i2c bus 13
[   13.744120] i2c i2c-12: Added multiplexed i2c bus 14
[   13.744123] usb 5-2: DVB: registering adapter 1 frontend 0 (Realtek 
RTL2832 (DVB-T))...
[   13.744164] fc0013: Fitipower FC0013 successfully attached.
[   13.744413] usb 5-2: Registered as swradio1
[   13.744415] i2c i2c-12: rtl2832_sdr: Realtek RTL2832 SDR attached
[   13.744416] usb 5-2: rtl2832_sdr: SDR API is still slightly 
experimental and functionality changes may follow
[   13.751351] Registered IR keymap rc-leadtek-y04g0051
[   13.751403] input: Leadtek WinFast DTV2000DS Plus as 
/devices/pci0000:00/0000:00:1c.5/0000:05:00.0/0000:06:01.2/usb5/5-2/rc/rc1/input20
[   13.751438] rc1: Leadtek WinFast DTV2000DS Plus as 
/devices/pci0000:00/0000:00:1c.5/0000:05:00.0/0000:06:01.2/usb5/5-2/rc/rc1
[   13.751486] input: MCE IR Keyboard/Mouse (dvb_usb_rtl28xxu) as 
/devices/virtual/input/input21
[   13.751732] rc rc1: lirc_dev: driver ir-lirc-codec (dvb_usb_rtl28xxu) 
registered at minor = 1
[   13.751734] usb 5-2: dvb_usb_v2: schedule remote query interval to 
400 msecs
[   13.763740] usb 5-2: dvb_usb_v2: 'Leadtek WinFast DTV2000DS Plus' 
successfully initialized and connected
[   13.763755] usbcore: registered new interface driver dvb_usb_rtl28xxu

Following that, everything just worked when using mythtv. Found all the 
channels just fine. I haven't played with any SDR stuff yet, though it 
was something I wanted to look at.

I've just tried to use "scan" now, and I do get a segfault from it. So I 
might need to take a look at what's going on there.

[252013.059718] scan[20552]: segfault at ffffffff ip 00007fbb2bbf5ca2 sp 
00007fffa80956b0 error 4 in libc-2.21.so[7fbb2bbad000+199000]

Kind of useless until I build with some debug symbols...

I do get this error from mythbackend every 5 minutes. Not sure if it's 
related.

mythbackend[1513]: 2015-03-13 20:05:23.284218 E 
DVBChan[3](/dev/dvb/adapter1/frontend0): Getting Frontend uncorrected 
block count failed.
mythbackend[1513]: eno: Operation not supported (95)
mythbackend[1513]: 2015-03-13 20:05:23.284225 W 
DVBSigMon[3](/dev/dvb/adapter1/frontend0): Cannot count Uncorrected Blocks
mythbackend[1513]: eno: Operation not supported (95)

Never seen that error happen on adapter0. Only adapter1.

I'm going to play around over the next week and see if I can find out 
why scan is segfaulting for me.

Christian

On 13/03/15 20:07, Vincent McIntyre wrote:
> On Mon, Mar 09, 2015 at 03:19:01PM +1000, Christian Dale wrote:
>> Add Leadtek WinFast DTV2000DS Plus device based on Realtek RTL2832U.
>>
>> I have not tested the remote, but it is the Y04G0051 model.
>>
> Thanks for doing this Christian. I have one of these cards also, 0x6f12.
> I wrote the same patch some time ago and it is not working for me.
> Can you give a few details of what kernel you tested on etc?
>
> I am testing on ubuntu 14.04 LTS
> [    0.000000] Linux version 3.13.0-45-generic (buildd@kissel) (gcc
> version 4.8.2 (Ubuntu 4.8.2-19ubuntu1) ) #74-Ubuntu SMP Tue Jan 13
> 19:37:48 UTC 2015 (Ubuntu 3.13.0-45.74-generic 3.13.11-ckt13)
>
>
> The symptom I have is when I try to tune with 'scan'
> from dvb-apps, the program wedges and I get this in dmesg:
> [  163.138982] fc0013: fc0013_set_params: failed: -22
> [  164.246233] fc0013: fc0013_set_params: failed: -22
> [  165.167758] fc0013: fc0013_set_params: failed: -22
> [  166.250280] fc0013: fc0013_set_params: failed: -22
> [  167.196580] fc0013: fc0013_set_params: failed: -22
> [  168.286208] fc0013: fc0013_set_params: failed: -22
> ...
>
> kind regards
> Vince

