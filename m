Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:54070 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZAVTuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 14:50:50 -0500
Received: by ewy13 with SMTP id 13so2968186ewy.13
        for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 11:50:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0901221434040.7609@tupari.net>
References: <48F78D8A020000560001A654@GWISE1.matc.edu>
	 <alpine.LFD.2.00.0901221434040.7609@tupari.net>
Date: Thu, 22 Jan 2009 11:50:48 -0800
Message-ID: <cae4ceb0901221150o5210c743q59a2d820629f5cd7@mail.gmail.com>
Subject: Re: [linux-dvb] Fusion HDTV 7 Dual Express
From: Tu-Tu Yu <tutuyu@usc.edu>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi ~
Did you try to do
>rmmod cx23885
>modprobe s5h1411
>modprobe xc5000
>modprobe cx23885
everytime you reboot the computer.?!
Audrey

On Thu, Jan 22, 2009 at 11:42 AM, Joseph Shraibman
<linuxtv.org@jks.tupari.net> wrote:
> I too am having 0 signal strength with a Fusion HDTV 7 Dual Express.  scan
> (from dvb-apps) does find channels, but my application won't work because
> it is seeing no signal.  I tried rebuilding the drivers from repository
> tip but it doesn't help.  The kernel I'm using is 2.6.27.9-73.fc9.i686.
> lspci -v shows:
>
> 02:00.0 Multimedia video controller: Conexant Unknown device 8852 (rev 04)
>         Subsystem: DViCO Corporation Unknown device d618
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at fbc00000 (64-bit, non-prefetchable) [size=2M]
>         Capabilities: [40] Express Endpoint, MSI 00
>         Capabilities: [80] Power Management version 2
>         Capabilities: [90] Vital Product Data <?>
>         Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>         Capabilities: [100] Advanced Error Reporting <?>
>         Capabilities: [200] Virtual Channel <?>
>         Kernel driver in use: cx23885
>         Kernel modules: cx23885
>
> after "make load" in the v4l-dvb directory  dmesg shows:
>
> cx23885_dvb_register() allocating 1 frontend(s)
> cx23885[0]: cx23885 based dvb card
> xc5000 1-0064: creating new instance
> xc5000: Successfully identified at address 0x64
> xc5000: Firmware has not been loaded previously
> DVB: registering new adapter (cx23885[0])
> DVB: registering adapter 1 frontend 0 (Samsung S5H1411 QAM/8VSB
> Frontend)...
> cx23885_dvb_register() allocating 1 frontend(s)
> cx23885[0]: cx23885 based dvb card
> xc5000 2-0064: creating new instance
> xc5000: Successfully identified at address 0x64
> xc5000: Firmware has not been loaded previously
> DVB: registering new adapter (cx23885[0])
> DVB: registering adapter 2 frontend 0 (Samsung S5H1411 QAM/8VSB
> Frontend)...
> cx23885_dev_checkrevision() New hardware revision found 0x0
> cx23885_dev_checkrevision() Hardware revision unknown 0x0
> cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 17, latency: 0, mmio:
> 0xfbc00000
> cx23885 0000:02:00.0: setting latency timer to 64
> ivtvfb:  no cards found
> or51132: Waiting for firmware upload(dvb-fe-or51132-vsb.fw)...
> firmware: requesting dvb-fe-or51132-vsb.fw
> or51132: Version: 10001134-19430000 (113-4-194-3)
> or51132: Firmware upload complete.
>
>
> On Thu, 16 Oct 2008, Jonathan Johnson wrote:
>
>> Hello linux-dvb members,
>>
>> I know another person posted a message similar to mine, but offered no diagnostic info, so I am.
>>
>> DViCO device d618 using driver cx23885
>> Conexant Device 8852 (rev 02)
>> Base OS: SuSE 11.0
>> kernel manually upgraded to 2.6.27
>> checked dmesg, and all firmware(s) load.
>>
>> I have a FusionHDTV Dual 7 tuner, and it gets no signal at all, and some times no channels appear
>> when I scan from with in mythtv, and sometimes some of the channels appear.
>>
>> 1. First I tried hooking a ATI 650 to Vista and got 100% strength all the time, so it wasn't the antenna.
>> 2. I then hooked up the FusionHDTV card to Vista and it also reported 100% signal strength.
>> Therefore the card is not broken.
>> 3. I have 2 ATI HDTV Wonder that have always worked perfectly, so signal strength is good.
>>
>>
>> When trying to record w/ MythTV I get
>> ---------
>> This occurs a couple times.
>> DVBSM(/dev/dvb/adapter1/frontend0), Warning can not measuer S/N
>> The following occurs many times:
>> DVBChan(3:/dev/dvb/adapter1/frontend0) Error:  Tune(): Setting Frontend using tuning parameters failed.
>> "eno: Invalid argument (22)"
>> -----------
>>
>> Spent 1/2 hour looking thru google results.
>> I decided despite how horrible luck I have with compiling certain things, I would give it a go anyway.
>> The kernel always compiles for me at least.  I went to linuxtv.org and followed the instructions.
>> I did the make and make install and got the invalid symbols mentioned on the website, and it said
>> reboot.  So I did, and I recompiled again, for the heck of it, and still have invalid symbols. Read the
>> INSTALL text file, and tried a bunch of options.    I tried make kernel-(something), and recompile the
>> kernel(completely), and reboot,and still no go.  I tried re-compiling v4l-dvb and still nothing.
>> I eventually tried "make all" and the compile failed with errors.  Could not get it to compile, and now
>> v4l-dvb was un-usable.
>>
>> I then installed and did a full compile of kernel 2.6.27.1 (released last night), and at least everything
>> now works.
>>
>> I would like to try the development version to see if that fixes things, but I am not skilled enough to
>> resolved the unresolved symbol problem.  insmod and modprobe failed with the same error.
>>
>>
>> Later,
>> Jonathan
>>
>>
>> -------------------------------------------
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
