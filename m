Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:54074 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZIUHkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 03:40:39 -0400
Message-ID: <4AB72DD0.70205@cogweb.net>
Date: Mon, 21 Sep 2009 00:40:00 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org
Subject: Re: Audio drop on saa7134
References: <4AAEFEC9.3080405@cogweb.net>	<20090915000841.56c24dd6@pedra.chehab.org>	<4AAF11EC.3040800@cogweb.net>	<1252988501.3250.62.camel@pc07.localdom.local>	<4AAF232F.9060204@cogweb.net>	<1252993000.3250.97.camel@pc07.localdom.local>	<4AAF2F1B.2050206@cogweb.net>	<4AB5E6AC.1090505@cogweb.net> <20090920060218.51971a45@pedra.chehab.org>
In-Reply-To: <20090920060218.51971a45@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em Sun, 20 Sep 2009 01:24:12 -0700
> David Liontooth <lionteeth@cogweb.net> escreveu:
>
>   
>> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 0x000000
>> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 0xbbbbbb
>>     
>
> This means mute. With this, audio will stop.
>
>   
>> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 0x000000
>> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 0xbbbb10
>>     
>
> This means unmute.
>
> It seems that the auto-mute code is doing some bad things for you. What happens
> if you disable automute? This is a control that you can access via v4l2ctl or
> on your userspace application.
>   
Ah, great -- I added "v4lctl -c /dev/video$DEV setattr automute off" to 
the script and verified it works.

Is there a way to turn off the automute on module insertion?

I don't see a lot of difference -- during the initialization, audio is 
still turned off several times, and then left on:

Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: tvaudio thread scan 
start [8]
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: scanning: M
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x454 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x454 = 
0x0000c0
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x470 = 
0x101010
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: tvaudio thread scan 
start [9]
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: scanning: M
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x454 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x454 = 
0x0000c0
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x470 = 
0x101010
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbb10
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:25:19 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbb10
Sep 21 00:25:22 prato kernel: saa7133[4]/audio: tvaudio thread status: 
0x100003 [M (in progress)]
Sep 21 00:25:22 prato kernel: saa7133[4]/audio: detailed status: 
############# init done

And then audio is turned off again at the end of the recording:

Sep 21 00:35:15 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:35:15 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 21 00:35:15 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 21 00:35:15 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb

I'll run with audiomute off for a while and see if it makes a difference 
for the audio drops -- it seems a plausible cause.
> Are you using the last version of the driver? I'm not seeing some debug log messages
> that should be there...
>   
I'm still running 2.6.19.1 and 2.6.20.11 on these production machines -- 
if it works, don't fix it.  If there's a clear reason to upgrade, of 
course I'll do that.

It would be a huge relief to discover the audio drops is a driver issue 
that can be fixed with a simple setting.

Cheers,
Dave


