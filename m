Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:35119 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965948AbdIZNR6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 09:17:58 -0400
Subject: Re: [progress]: dvb_usb_rtl28xxu not tuning "Leadtek Winfast DTV2000
 DS PLUS TV"
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: list linux-media <linux-media@vger.kernel.org>
References: <00ad85dd-2fe3-5f15-6c0c-47fcf580f541@eyal.emu.id.au>
 <678bf4fa-5849-1fb2-adf1-a07458767d9e@eyal.emu.id.au>
 <20170926124508.GA17883@ubuntu.windy>
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Message-ID: <6b2b09a1-07f6-c4c3-df49-c9b8327b6517@eyal.emu.id.au>
Date: Tue, 26 Sep 2017 23:17:56 +1000
MIME-Version: 1.0
In-Reply-To: <20170926124508.GA17883@ubuntu.windy>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/09/17 22:45, Vincent McIntyre wrote:
> On Tue, Sep 26, 2017 at 02:32:26PM +1000, Eyal Lebedinsky wrote:
>>
>> While the problem persists, I managed to find a way around it for now.
>>
>> I changed the antenna input.
>>
>> Originally I used a powered splitter to feed all the tuners, and it worked
>> well with the out-of-kernel driver. This driver does not build or work with
>> a more modern kernel so I shifted to using dvb_usb_rtl28xxu which fails to
>> tune.
>>
>> The new wiring splits (passive) the antenna in two, feeds one side directly
>> to the two "Leadtek Winfast DTV2000 DS PLUS TV" cards (through another passive
>> 2-way) and the other side goes to the old powered splitter that feeds a few
>> USB tuners.
>>
>> Now all tuners are happy. It seems that the "Leadtek Winfast DTV2000 DS PLUS TV"
>> cannot handle the amplified input while the USB tuners require it.
>>
>> I hope that there is a way to set a profile in dvb_usb_rtl28xxu to attenuate
>> the input to an acceptable level thus unravelling the antenna cables rat-nest.
> 
> Glad you had some success.
> 
> I did some more rummaging in v4l-utils. It may help you to know about
> dvb-fe-tool, which gives information about the frontend device
> (eg /dev/dvb/adapter0/frontend0). In particular you can monitor the
> s/n as you make changes:
> 
>   # dvb-fe-tool --femon -a 0  #here doing adapter0/frontend0
> 
> It displays info about the signal quality and the carrier/noise (C/N) ratio,
> which might help any investigation of where the driver fails to cope as
> you change what you are feeding it.
> 
> I noticed your dvbv5-scan showed C/N around 20dB but the manpage shows
> 'good signal' with C/N of 36dB which suggests the device should be
> expected to deal with higher signal levels.
> 
> Once you figured out the signal level, did a dvbv5-scan work with no
> errors? In the example you showed I saw the channels getting 'lock'
> but then some kind of error occurred.

I had very good reception and scandvb tuned to all channels. I did not test
dvbv5-scan again but I expect it would work too (will try in the morning).

> Regards
> Vince

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
