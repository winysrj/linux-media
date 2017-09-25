Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:51895 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934413AbdIYOhq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 10:37:46 -0400
Subject: Re: f26: dvb_usb_rtl28xxu not tuning "Leadtek Winfast DTV2000 DS PLUS
 TV"
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: list linux-media <linux-media@vger.kernel.org>
References: <00ad85dd-2fe3-5f15-6c0c-47fcf580f541@eyal.emu.id.au>
 <3f0c2037-4a84-68a9-228f-015034e27900@eyal.emu.id.au>
 <20170924090417.GA24153@ubuntu.windy>
 <47886ad7-ae90-0667-d6e3-d32d99fa85de@eyal.emu.id.au>
 <20170925132433.GB8969@ubuntu.windy>
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Message-ID: <a654a076-a34d-2cac-e668-a816ab8f3832@eyal.emu.id.au>
Date: Tue, 26 Sep 2017 00:37:44 +1000
MIME-Version: 1.0
In-Reply-To: <20170925132433.GB8969@ubuntu.windy>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Vincent,

On 25/09/17 23:24, Vincent McIntyre wrote:
> On Mon, Sep 25, 2017 at 10:16:23AM +1000, Eyal Lebedinsky wrote:
> 
>>> Turn on debug printing for the modules of interest
>>> # echo 'module rtl2832 +p' > /sys/kernel/debug/dynamic_debug/control
>>> # echo 'module dvb_usb_rtl28xxu +p' > /sys/kernel/debug/dynamic_debug/control
>>
>> Have done this. Attached are the messages from a (failed) scandvb that fails for all multiplexes.
>>
>> The messages at the end continued at a high rate after the test finished (until I disabled debug
>> with '-p') and there was no user of the tuners. Maybe IR RC is active?
>   
> This looks like progress, now we can see more of the rather odd behaviour.
> 
> The tuned frequency does not progress monotonically,
> but wanders up and down the band.
>   Frequency      Delta
>   219166666
>   184833334  -34333332
>   191833334    7000000
>   191166666    -666668
>   177833334  -13333332
>   184166666    6333332
>   177166666   -7000000
>   191500000   14333334
>   184500000   -7000000
>   191833334    7333334
>   191166666    -666668
>   177500000  -13666666
>   219500000   42000000
>   184833334  -34666666
>   191500000    6666666
>   177833334  -13666666
>   184166666    6333332
>   191833334    7666668
>   191166666    -666668
>   177166666  -14000000
>   191500000   14333334
>   184500000   -7000000
>   177500000   -7000000
>   177833334     333334
>   177166666    -666668
> 
> The bandwidth and inversion type seem to be set correctly, at least.
> 
> Also:
>   - every instance of if_frequency=0 pset_iffreq=00000000
>     shows the same numbers - zero. Surely that can't be right.
>   - there seems to be no correlation at all between the AGC level
>     (automatic gain control, I assume) and the 'cnr raw' which I'm
>     guessing is some measure of the signal level.
> 
> I don't know where to start with decoding the rtl28xxu_ctrl_msg
> I'm afraid. It's quite possible the remote control is active.
> You can run
>     ir-keytable -v
> to show which remotes the system knows about.
> 
> We might get more clues to rub together from looking at where
> scandvb falls over, if you run it under 'strace'
>    strace -t -s 2048 -o ./scandvb.strace scandvb <arguments here>
> This will show the system calls being made. The -t will add timestamps
> to the output that could be correlated with the dmesg output.
> 
> I'm curious - did you try scandvb with one of your other tuners?

The other 3 tuner on the "Leadtek Winfast DTV2000 DS PLUS TV" are failing in the same way.

> I'm actually not familiar with scandvb, I can't find a program
> with that name in the ubuntu repositories.
> What I've used before is dvbv5-scan, which is part of:
>   git://linuxtv.org/v4l-utils.git
> 
> That repo also includes the v4l2-compliance tool,
> which might be useful here. Something like:
>   ./v4l2-compliance -d /dev/dvb/adapter3 -a -T -v
> What I am not sure about is whether the tuner needs to be
> 'zapped' to a nice strong TV channel before you can use this.

I will look at these tools.

> Anyway, hope some of these ideas are helpful.

Another data point that may help:

While playing with the tuners, I tried to change the signal strength
(there is an active 4-way splitter feeding the cards) and it made no
difference.

However, at one point I powered off the splitter and the cards started
tuning. However, the USB tuners (now attached as a temporary solution)
had difficulty tuning (naturally). I think that I need the amplifier
but this driver cannot handle the strong signal.

So this made me think: is it possible that something in the dvb_usb_rtl28xxu
setup for the DTV2000 sets some internal gain that makes the  signal too
strong for the tuner? I did not see an option to turn off an LNA or such.

I know that the off kernel driver I was using successfully earlier
	https://github.com/jaredquinn/DVB-Realtek-RTL2832U
had no such issue. It does not build on recent kernels. Looking at
the source I see that at least usb_control_msg() changed.

BTW, If I get the "Hauppauge Nova-TD Stick" working then I can give up
on the DTV2000, they are PCI and will not suit the next mobo upgrade
that is long overdue. I started another thread for the Hauppauge a
few days ago (did not get a response yet).

> Cheers
> Vince

cheers

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
