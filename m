Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:45157 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935351AbdIZEa2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 00:30:28 -0400
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
Message-ID: <6ba9b857-a58a-8332-2d99-cc8458136dba@eyal.emu.id.au>
Date: Tue, 26 Sep 2017 14:30:25 +1000
MIME-Version: 1.0
In-Reply-To: <20170925132433.GB8969@ubuntu.windy>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



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
> 
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
> 
> Anyway, hope some of these ideas are helpful.
> Cheers
> Vince

I have now confirmed (tested) that the DTV2000 tunes properly when fed a signal
directly from the antenna. The other USB tuners need a stronger signal so they
are fed through a powered splitter (as it always was).

The issue left open is: can the tuner (is it the FC0013?) be set to handle the
stronger input? I have too many antenna cables attached right now...

cheers
-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
